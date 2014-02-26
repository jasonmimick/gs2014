// Copyright (c) 2012 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// When the html page is loaded, fetch the channel id so we can display it.
// In this case, it is only used to display to the user so the user can
// cut and paste it to their server app.  In a real app, we would have
// instead sent the channel id to the server in onInstalled.
window.onload = fetchChannelId;

// Get the channel ID for display to the user.
function fetchChannelId() {
  chrome.pushMessaging.getChannelId(true, channelIdCallback);

  chrome.pushMessaging.onMessage.addListener(showPushMessage);
  console.log("fetchChannelId returned.  Awaiting callback...");
}

// When the channel ID is available, this callback recieves it.
function channelIdCallback(message) {
  console.log("Push Sample Channel ID callback seen, channel Id is " + message.channelId);
  console.dir(message);
  channel_id = message.channelId;

  showChannelId(channel_id);
}

// Pop up when the icon is clicked to show the channel ID that is registered.
function showChannelId(channelId) {

  var break_node = document.createElement("br");

  // Display the channel ID if we have one, blank if getChannelId failed.
  var channel_id_node = document.createElement("p");
  channel_id_node.textContent = "channel_id is " + channelId;
  var channelDiv = document.getElementById("channelId");
  console.dir(channelDiv);
  channelDiv.appendChild(break_node);
  channelDiv.appendChild(channel_id_node);
  channelDiv.appendChild(break_node);
}

function showPushMessage(message) {
  var msg_node = document.createElement("p");
  msg_node.textContent = message.payload
  document.getElementById("messages").appendChild(msg_node);
}
