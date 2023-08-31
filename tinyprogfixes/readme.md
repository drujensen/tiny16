# fixes to tinyprog to provide metadata

The tinyfpga didn't come with the meta data.

To fix this, you can hardcode the values in the init file of the tinyprog package.

The file is located at: /usr/local/lib/python3.7/dist-packages/tinyprog/__init__.py

update the TinyMeta class and set the root to the metadata provided in __init__.py provided.
