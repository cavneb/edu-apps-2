var LtiApp = Ember.Model.extend({
  // attributes
  id:                   Ember.attr(),
  name:                 Ember.attr(),
  short_name:           Ember.attr(),
  short_description:    Ember.attr(),
  description:          Ember.attr(),
  testing_instructions: Ember.attr(),
  author_name:          Ember.attr(),
  app_type:             Ember.attr(),
  config_url:           Ember.attr(),
  preview_url:          Ember.attr(),
  ims_cert_url:         Ember.attr(),
  banner_image_url:     Ember.attr(),
  logo_image_url:       Ember.attr(),
  icon_image_url:       Ember.attr(),
  created_at:           Ember.attr(),
  updated_at:           Ember.attr(),
  cartridge:            Ember.attr(),
  average_rating:       Ember.attr(),
  total_ratings:        Ember.attr(),
  
  // associations
  tags: Ember.hasMany('App.Tag', { key: 'tag_ids' }),
  reviews: Ember.hasMany('App.Review', { key: 'review_ids' }),

  hasPreview: function() {
    return !Ember.isEmpty(this.get('preview_url'));
  }.property('preview_url')

}).reopenClass({
  rootKey:       'lti_app',
  collectionKey: 'lti_apps',
  url:           '/api/v1/apps',
  adapter:       Ember.RESTAdapter.create()
});

module.exports = LtiApp;

