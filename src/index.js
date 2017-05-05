const Elm = require('./App.elm');
const Sub = require('./SubApp.elm');

function elmCluster(master, ...slaves) {
  const masterPortNames = Object.keys(master.ports);
  function isSendPort(port) {
    return port.send instanceof Function
  }

  function isSubPort(port) {
    return !isSendPort(port)
  }
  slaves.forEach(slave => {
    const slavePortNames = Object.keys(slave.ports);
    masterPortNames.forEach(portName => {
      const masterPort = master.ports[portName];
      const slavePort = slave.ports[portName];
      if (isSendPort(masterPort)) {
        slavePort.subscribe(masterPort.send);
      } else if (isSubPort(masterPort)) {
        masterPort.subscribe(slavePort.send);
      }
    });
  })

}

const app = Elm.App.fullscreen();
const worker = Sub.SubApp.worker();

elmCluster(app, worker, Sub.SubApp.worker())

// app.ports.sendPort.subscribe((s) => console.log(s))
// worker.ports.sendPort.send("hgoe")