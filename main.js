const { app, BrowserWindow, Menu, dialog } = require('electron');
const { autoUpdater } = require("electron-updater");
const log = require('electron-log');
const path = require("path");
const url = require("url");

autoUpdater.logger = log;
autoUpdater.logger.transports.file.level = 'info';

function createWindow()
{
    log.info("Begin electron app 2.1.7...");

    let win = new BrowserWindow({
        fullscreen: true,
        titleBarStyle: "hidden",
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false,
            nodeIntegrationInWorker: true,
            enableRemoteModule: true,
            webSecurity: false,
            secure: false
        }
    });

    app.commandLine.appendSwitch('ignore-certificate-errors');
    //win.loadFile('./macropay/index.html');
    win.loadURL(url.format({ pathname: path.join(__dirname, "./macropay/index.html"), protocol: 'file:', slashes: true }));
    win.setMenu(null);
    win.removeMenu();
    Menu.setApplicationMenu(null);
    win.webContents.openDevTools();

    setTimeout(() => {
        log.info("Execute checkForUpdates");
        autoUpdater.checkForUpdates();
    }, 2000);
}

app.whenReady().then(createWindow)

autoUpdater.on('checking-for-update', () => {
    log.info("Checking for updates event..");
});

autoUpdater.on('update-available', info => {
    log.info('update available and downloaded -> update: '+info.version);
    log.info(info);
});

/*
autoUpdater.on('error', (err) => {
    log.info(`Update error: ${err.toString()}`);
});*/

autoUpdater.on('update-downloaded', () => {
    log.info('update downloaded');
    
    const dialogOpts = {
        type: 'info',
        buttons: ['Reiniciar y actualizar'],
        title: 'Actualización disponible',
        message: "Se ha descargado una nueva versión de la aplicación, por lo que se requiere instalar de manera obligatoria para evitar problemas en las operaciones",
        detail: 'A new version has been downloaded. Restart the application to apply the updates.'
    };

    dialog.showMessageBox(dialogOpts).then((returnValue) => {
        if (returnValue.response === 0) autoUpdater.quitAndInstall()
    });
});

autoUpdater.on('download-progress', progressObj => {
    log.info(`Download speed ${progressObj.bytesPerSecond} - Donloaded ${progressObj.percent}%`);
});