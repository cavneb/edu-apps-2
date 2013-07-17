var Organization = require("../../models/organization");

var OrganizationsNewController = Ember.ObjectController.extend({
  
  save: function() {
    var self = this;
    organization = this.get('model');
    organization.save().then(
      function(object) {
        App.FlashQueue.pushFlash('notice', 'Organization has been created successfully!');
        self.transitionToRoute('organizations.index');
      },
      function(error) {
        App.FlashQueue.pushFlash('error', 'Please try again');
      }
    );
  }
});

module.exports = OrganizationsNewController;

