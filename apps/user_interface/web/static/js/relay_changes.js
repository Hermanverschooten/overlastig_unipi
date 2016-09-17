import socket from './socket'

$(
  function() {
    let channel = socket.channel("relay_changes:lobby", {});
    channel.join()
      .receive("ok", data => {
        console.log("Joined topic");
        })
      .receive("error", resp => {
        console.log("Unable to join topic")
        })
    channel.on("change", changes => {
      console.log("Change", changes.state)
      $('#' + changes.relay)
        .removeClass('on off')
        .addClass(changes.state)
      })
  }
)
