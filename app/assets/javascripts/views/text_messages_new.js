MobileZen.Views.TextMessagesNew = Backbone.View.Extend({
  tagName: 'form',
  id: 'new-text-message',

  events: {
    "submit": "save",
  },

  initialize: function(options) {
    this.users = options.users;
    _.bindAll(this, "render", "saved");
    this.newTextMessage();
  },

  newTextMessage = function() {
    this.model = new MobileZen.Models.TextMessage();
  },

  render: function() {
    this.$el.html(JST['text_messages/form_fields']());
    this.$('input[name=title]').focus();
    return this;
  },

  renderFlash: function(flashText) {
    this.$el.prepend(JST['text_messages/flash']({ flashText: flashText, type: 'success'}));
  },

  save: function(e) {
    e.preventDefault();
    
    this.commitForm();
    this.model.save({}, { success: this.saved });
    return false;
  },

  commitForm: function() {
    this.model.set({ title: this.$('input[name=title]').val() });
    this.model.assignedUsers = new MobileZen.Collections.Users(this.assignedUsers());
  },

  saved: function() {
    var flash = "You'll now receive: " + this.model.escape('text_message_body');

    this.collection.add(this.model);
    this.newTextMessage();
    this.render();
    this.renderFlash(flash);
  },
});


