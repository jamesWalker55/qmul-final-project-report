fn clear_expired_records(
    recent_deleted_paths: &mut Vec<(Instant, PathBuf, EventAttributes)>,
    output_tx: &UnboundedSender<notify::Result<Event>>,
) {
    let now = Instant::now();
    recent_deleted_paths.retain(|(expires_at, path, attrs)| {
        if expires_at <= &now {
            let evt = Event {
                kind: Remove(RemoveKind::Any),
                paths: vec![path],
                attrs,
            };
            output_tx.send(Ok(evt)).unwrap();
            true
        } else {
            false
        }
    });
}

async fn event_handler(
    mut watcher_rx: UnboundedReceiver<notify::Result<Event>>,
    output_tx: UnboundedSender<notify::Result<Event>>,
) {
    let mut last_rename_from: Option<PathBuf> = None;
    let mut recent_deleted_paths: Vec<(Instant, PathBuf, EventAttributes)> = vec![];
    let mut res;
    loop {
        // If we have paths in the database, timeout until the next path's instant
        if recent_deleted_paths.len() > 0 {
            let next_wake_time = recent_deleted_paths.get(0).unwrap().0;
            match timeout_at(next_wake_time.clone(), watcher_rx.recv()).await {
                Ok(x) => {
                    // Didn't timeout, assign the return value to res
                    res = x;
                }
                Err(_) => {
                    // Timeout occurred, clear expired records from database and wait again
                    clear_expired_records(&mut recent_deleted_paths, &output_tx);
                    continue;
                }
            }
        } else {
            // No paths in database, just wait for next record indefinitely
            res = watcher_rx.recv().await;
        }
        match res {
            Some(evt) => {
                if evt.is_err() {
                    output_tx.send(evt).unwrap();
                    continue;
                }
                let evt = evt.unwrap();
                match evt {
                    Event {
                        kind: Modify(Name(RenameMode::From)), mut paths, ..
                    } => {
                        if let Some(_) = last_rename_from {
                            panic!("Got multiple 'Rename From' events in a row!")
                        }
                        let path = paths.pop().unwrap();
                        last_rename_from = Some(path);
                        continue;
                    }
                    Event { kind: Modify(Name(RenameMode::To)), mut paths, .. } => {
                        let from_path = last_rename_from.take().expect(
                        "Got 'Rename To' event, but no 'Rename From' event happened before this!",
                    );
                        let to_path = paths.pop().unwrap();
                        let evt = Event {
                            kind: Modify(Name(RenameMode::Both)),
                            paths: vec![from_path, to_path],
                            attrs: evt.attrs.clone(),
                        };
                        output_tx.send(Ok(evt)).unwrap();
                    }
                    Event { kind: Remove(RemoveKind::Any), mut paths, attrs } => {
                        assert_eq!(
                            paths.len(),
                            1,
                            "Number of created paths is not 1: {}",
                            paths.len()
                        );
                        let removed_path = paths.pop().unwrap();
                        let expires_at = Instant::now() + Duration::from_millis(10);
                        recent_deleted_paths.push((expires_at, removed_path, attrs));
                    }
                    Event { kind: Create(CreateKind::Any), paths, attrs } => {
                        assert_eq!(
                            paths.len(),
                            1,
                            "Number of created paths is not 1: {}",
                            paths.len()
                        );
                        let created_path = paths.get(0).unwrap().clone();
                        let mut deleted_path_match_id: Option<usize> = None;
                        for i in 0..recent_deleted_paths.len() {
                            let deleted_path = &recent_deleted_paths.get(i).unwrap().1;
                            let created_name = created_path
                                .file_name()
                                .expect("Path doesn't have file name");
                            let deleted_name = deleted_path
                                .file_name()
                                .expect("Path doesn't have file name");
                            if created_name == deleted_name {
                                deleted_path_match_id = Some(i);
                                break;
                            }
                        }
                        match deleted_path_match_id {
                            Some(i) => {
                                let deleted_path_match = recent_deleted_paths.remove(i).1;
                                let evt = Event {
                                    kind: Modify(Name(RenameMode::Both)),
                                    paths: vec![deleted_path_match, created_path.to_path_buf()],
                                    attrs,
                                };
                                output_tx.send(Ok(evt)).unwrap();
                            }
                            None => {
                                let evt = Event {
                                    kind: Create(CreateKind::Any),
                                    paths: vec![created_path],
                                    attrs,
                                };
                                output_tx.send(Ok(evt)).unwrap();
                            }
                        }
                    }
                    _ => output_tx.send(Ok(evt)).unwrap(),
                }
            }
            None => {
                // send remaining deleted paths to output
                for (_, path, attrs) in recent_deleted_paths {
                    let evt = Event {
                        kind: Remove(RemoveKind::Any),
                        paths: vec![path],
                        attrs,
                    };
                    output_tx.send(Ok(evt)).unwrap();
                }
                break;
            }
        }
    }
}
