const { Client } = require('discord.js');
const client = new Client;
const {updatePlayerCount} = require("./utils/")
global.config = require("./config.json")
client.on('ready', () => {
    console.log(`Discord Bot logged in as ${client.user.tag}`);
    updatePlayerCount(client, 5)
});

client.login(config.token);