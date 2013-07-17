var OrganizationsAddMemberController = Ember.ObjectController.extend({

  addMember: function() {
    var data = {
      email: this.get('newEmail') || '',
      is_admin: this.get('newIsAdmin') === true
    }

    console.log(data);

    if (data.email.length > 0) {
      var self = this;

      var request = $.ajax({
        type: 'POST',
        url: '/api/v1/organizations/' + this.get('id') + '/add_member',
        data: data
      });

      request.done(function( msg ) {
        self.set('email', null);
        self.set('is_admin', null);

        App.FlashQueue.pushFlash('notice', 'Added ' + data.email + ' successfully');
        debugger;
      });

      request.fail(function(jqxhr) {
        switch(jqxhr.status) {
          case 401:
            App.FlashQueue.pushFlash('error', 'You do not have permission to do this');
            break;

          case 404:
            App.FlashQueue.pushFlash('warning', 'You do not have access to this organization');
            break;

          case 422:
            var msg = JSON.parse(jqxhr.responseText);
            App.FlashQueue.pushFlash('warning', msg.message);
            break;

          default:
            App.FlashQueue.pushFlash('error', 'Unexpected response from server');
        }
      });

    }
  }

});

module.exports = OrganizationsAddMemberController;

