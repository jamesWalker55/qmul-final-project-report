= Appendices

== Database Schema

```sql
CREATE TABLE items (
  id INTEGER PRIMARY KEY,
  path TEXT UNIQUE NOT NULL,
  tags TEXT NOT NULL,
  meta_tags TEXT NOT NULL DEFAULT 'all'
);

-- FTS5 Documentation:
-- https://www.sqlite.org/fts5.html
CREATE VIRTUAL TABLE tag_query USING fts5 (
  -- Include columns to be stored on this virtual table:
  -- Include the `id` column so I can join it to `items`, but don't index with FTS
  id UNINDEXED,
  -- Include the `tags` column to index them
  tags,
  -- a 'meta' column that stores additional tags, e.g. 'all'
  meta_tags,

  -- Make this an external content table (don't store the data in this table, but reference
  -- the original table)
  content=items,
  content_rowid=id,

  -- Use the Unicode61 tokenizer
  -- https://www.sqlite.org/fts5.html#unicode61_tokenizer
  tokenize="unicode61"
);

CREATE TRIGGER items_trigger_ai AFTER INSERT ON items BEGIN
  INSERT INTO tag_query(id, tags, meta_tags) VALUES (NEW.id, NEW.tags, NEW.meta_tags);
END;

CREATE TRIGGER items_trigger_ad AFTER DELETE ON items BEGIN
  INSERT INTO tag_query(tag_query, id, tags, meta_tags) VALUES('delete', OLD.id, OLD.tags, OLD.meta_tags);
END;

CREATE TRIGGER items_trigger_au AFTER UPDATE ON items BEGIN
  INSERT INTO tag_query(tag_query, id, tags, meta_tags) VALUES('delete', OLD.id, old.tags, old.meta_tags);
  INSERT INTO tag_query(id, tags, meta_tags) VALUES (NEW.id, NEW.tags, NEW.meta_tags);
END;
```

== Directory Watcher Event Handler

```rust
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
```

== Test Output

```
test helpers::sql::test_fts5::no_quotes ... ok
test helpers::sql::test_fts5::both_quotes ... ok
test helpers::sql::test_fts5::single_quotes ... ok
test helpers::sql::test_fts5::double_quotes ... ok
test helpers::sql::test_like::both_quotes ... ok
test helpers::sql::test_like::escape_char_1 ... ok
test helpers::sql::test_like::single_quotes ... ok
test helpers::sql::test_like::double_quotes ... ok
test helpers::sql::test_like::no_quotes ... ok
test helpers::sql::test_like::percent_2 ... ok
test helpers::sql::test_like::escape_char_2 ... ok
test helpers::sql::test_like::percent_1 ... ok
test helpers::sql::test_like::underscore_2 ... ok
test query::convert::test_clauses::fts_3 ... ok
test query::convert::test_clauses::common_1 ... ok
test query::convert::test_clauses::common_2 ... ok
test query::convert::test_clauses::common_3 ... ok
test query::convert::test_clauses::fts_1 ... ok
test query::convert::test_clauses::fts_2 ... ok
test helpers::sql::test_like::underscore_1 ... ok
test query::convert::test_clauses::inpath_1 ... ok
test query::convert::test_clauses::inpath_3 ... ok
test query::convert::test_clauses::fts_4 ... ok
test query::convert::test_clauses::fts_5 ... ok
test query::convert::test_clauses::inpath_4 ... ok
test query::convert::test_clauses::inpath_2 ... ok
test query::convert::test_clauses::inpath_5 ... ok
test query::convert::test_clauses::inpath_6 ... ok
test query::convert::test_fts_query::and_1 ... ok
test query::convert::test_fts_query::and_2 ... ok
test query::convert::test_fts_query::neg_1 ... ok
test query::convert::test_fts_query::complex_1 ... ok
test query::convert::test_fts_query::neg_3 ... ok
test query::convert::test_fts_query::neg_2 ... ok
test query::convert::test_fts_query::neg_4 ... ok
test query::convert::test_fts_query::neg_5 ... ok
test query::convert::test_fts_query::or_1 ... ok
test query::convert::test_fts_query::or_2 ... ok
test query::convert::test_to_sql::fts_1 ... ok
test query::convert::test_to_sql::common_1 ... ok
test query::convert::test_to_sql::fts_2 ... ok
test query::convert::test_to_sql::inpath_1 ... ok
test query::convert::test_to_sql::fts_3 ... ok
test query::convert::test_to_sql::inpath_2 ... ok
test query::convert::test_to_sql::inpath_3 ... ok
test query::convert::test_to_sql::inpath_4 ... ok
test query::convert::test_to_sql::inpath_5 ... ok
test query::parser::expr_tests::and_or_1 ... ok
test query::parser::expr_tests::and_or_2 ... ok
test query::parser::expr_tests::common_1 ... ok
test query::parser::expr_tests::just_and_1 ... ok
test query::parser::expr_tests::just_and_2 ... ok
test query::parser::expr_tests::just_and_3 ... ok
test query::parser::expr_tests::complex_1 ... ok
test query::parser::expr_tests::just_and_4 ... ok
test query::parser::expr_tests::just_or_2 ... ok
test query::parser::expr_tests::just_or_1 ... ok
test query::parser::expr_tests::just_or_3 ... ok
test query::parser::expr_tests::just_or_4 ... ok
test query::parser::expr_tests::parens_1 ... ok
test query::parser::expr_tests::not_1 ... ok
test query::parser::expr_tests::not_2 ... ok
test query::parser::expr_tests::parens_2 ... ok
test query::parser::expr_tests::parens_3 ... ok
test query::parser::expr_tests::parens_4 ... ok
test query::parser::expr_tests::string_tags_1 ... ok
test query::parser::expr_tests::string_tags_2 ... ok
test query::parser::expr_tests::string_tags_3 ... ok
test query::parser::tests::test_literal ... ok
test query::parser::tests::test_key_value ... ok
test query::parser::tests::test_string ... ok
test query::parser::tests::test_tag ... ok
test query::tests::common_1 ... ok
test query::tests::common_2 ... ok
test query::tests::empty ... ok
test query::tests::common_3 ... ok
test watch::tests::basic_test ... ok
test scan::tests::scans_files_in_folder ... ok
test watch::tests::file_creations_01 ... ok
test watch::tests::file_removes_01 ... ok
test watch::tests::file_creations_02 ... ok
test watch::tests::file_removes_02 ... ok
test watch::tests::file_renames_01 ... ok
test watch::tests::file_renames_02 ... ok
test watch::tests::file_renames_03 ... ok
test repo::tests::check_tables_of_newly_created_database ... ok
test repo::tests::can_get_item_by_id ... ok
test repo::tests::can_remove_item_by_path ... ok
test tests::query_repo::query_1 ... ok
test tests::query_repo::query_4 ... ok
test repo::tests::cant_insert_duplicate_items ... ok
test tests::query_repo::query_2 ... ok
test repo::tests::can_insert_items ... ok
test tests::query_repo::query_3 ... ok
test repo::tests::can_get_item_by_path ... ok
test repo::tests::can_get_all_items ... ok
test repo::tests::can_query_items ... ok
test repo::tests::can_update_item_path ... ok
test repo::tests::can_remove_item_by_id ... ok
test repo::tests::can_update_item_tags ... ok
test repo::tests::query_test ... ok
test repo::tests::query_test_2 ... ok
test scan::tests::benchmark ... ok
test repo::tests::scan_integration::my_test ... ok
```

#pagebreak()
