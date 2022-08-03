# after install

<!-- toc -->

- [Set up vscode settings sync + globalstorage](#set-up-vscode-settings-sync--globalstorage)

<!-- tocstop -->

## Set up vscode settings sync + globalstorage

After setting up settings sync make sure that the "ignoreUploadFolders" in [~/.config/Code/User/syncLocalSettings.json](~/.config/Code/User/syncLocalSettings.json) includes "globalstorages":

```sh
  "ignoreUploadFolders": [
    "workspaceStorage",
    "History",
    "globalStorage",
    "GlobalStorage"
  ],
```
