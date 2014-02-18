var MobileZen = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function(data) {
    this.text_messages = new MobileZen.Collections.TextMessages(data.text_messages);
    this.users = new MobileZen.Collections.Users(data.users);

    new MobileZen.Routers.TextMessages({ collection: this.text_messages, users: this.users});
    if (!Backbone.history.started) {
      Backbone.history.start();
      Backbone.history.started = true;
    }
  }
};

