* eliminate need for staging directory
* Phone sync UX: don’t remove originals from phone until after new files appear
* Rewrite inotify watcher to handle appearance of directories
* auto-create inbox/staging/libraries if they don’t exist
* double-check deletion-sync logic
  and make sure we don’t delete files with the same timestamp
  but potentially different content (e.g., a JPG and a PNG)
* what should xferase do with corrupted videos that photein failed to import?
