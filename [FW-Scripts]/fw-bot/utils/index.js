module.exports = {
    updatePlayerCount: (client, seconds) => {
        const interval = setInterval(function setStatus() {
            status = `${GetNumPlayerIndices()} Spelers`
            //console.log(status)
            client.user.setActivity(status, {type: 'WATCHING'})
            return setStatus;
        }(), seconds * 1000)
    }
}