const express = require('express');
const os = require('os');

const app = express();
const port = 3000;

app.use(express.json());

app.post('/statistics', (req, res) => {
  const { token } = req.body;

  const cpuUsage = os.loadavg()[0];
  const maxCpu = os.cpus().length;
  const ramUsage = (os.totalmem() - os.freemem()) / 1024 / 1024;
  const maxRam = os.totalmem() / 1024 / 1024;
  const uptime = process.uptime();

  const statistics = {
    "token" : token,
    "uptime" : uptime,
    "cpu" : {
        cpuUsage,
        maxCpu,
    },
    "ram" : {
        ramUsage,
        maxRam,    
    },
  };

  res.json(statistics);
});

app.post("/heartbeat", (req, res) => {
    const { token } = req.body;

    res.json({
        "token" : token,
    })
})

app.listen(port, () => {
  console.log(`Serveur Node.js en cours d'exécution sur le port ${port}`);
});
