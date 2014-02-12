MobileZen.Routers.TextMessages = Support.SwappingRouter.extend({
  initialize: function(options) {
    this.el = $('#text_messages');
    this.collection = options.collection;
    this.users = options.users;
  },

  routes: {
    "":                     "index",
    "new":                  "newTextMessage",
    "text_messages/:id":    "show"
  },

  index: function() {
    var view = new MobileZen.Views.TextMessagesIndex({ collection: this.collection });
    this.swap(view);
  },

  newTextMessage: function() {
    var view = new MobileZen.Views.TextMessagesNew({ collection: this.collection, users: this.users });
    this.swap(view);
  },

  show: function(textMessageId) {
    var textMessage = this.collection.get(textMessageId);
    var textMessagesRouter = this;
    textMessage.fetch({
      success: function() {
        var view = new MobileZen.Views.TextMessageShow({ model: textMessage });
        textMessagesRouter.swap(view);
      }
    });
  }
});
