import socket from './socket'
import $ from "jquery"

$(
  function() {
    // socket.logger = (kind, msg, data) => { console.log('${kind}: ${msg}', data)};
    let channel = socket.channel("relay_changes:lobby", {});

    $('#button-list a').on("click", event => {
      channel.push("toggle", { button: event.target.id });
      console.log("push toggle for " + event.target.id);
      });

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
      });
  }
)
