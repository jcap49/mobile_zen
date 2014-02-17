MobileZenn.Models.TextMessage = Backbone.Model.extend({
  initialize: function() {
  },

  urlRoot: '/text_messages',

  isComplete: function() {
    return this.get('complete');
  },

  toJSON: function() {
    var json = _.clone(this.attributes);
    json.assignments_attributes = this.assignedUsers.map(function(user) {
      return { user_id: user.id };
    });
    return json;
  }
});


