* Replace staging directory with crash log (see ADR #1)
* Rewrite inotify watcher to handle appearance of directories
* double-check deletion-sync logic
  and make sure we don’t delete files with the same timestamp
  but potentially different content (e.g., a JPG and a PNG)
* what should xferase do with corrupted videos that photein failed to import?
