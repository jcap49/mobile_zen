MobileZen.Collections.Users = Backbone.Collection.extend({
  model: MobileZen.Models.User,

  findByEmail: function(email) {
    return this.find(function(user) {
      return user.get('email') == email
    });
  }
});


