# See https://github.com/voltrb/volt#routes for more info on routes

client '/users', component: 'admin', controller: 'main', action: 'users'
client '/marketing', component: 'admin', controller: 'main', action: 'index'
client '/users/{{ id }}', component: 'admin', controller: 'main', action: 'user'
client '/reminders', component: 'admin', controller: 'main', action: 'reminders'
client '/issue_surveys', component: 'admin', controller: 'main', action: 'issue_surveys'
client '/allow_access', component: 'admin', controller: 'main', action: 'allow_results'
client '/email_groups', component: 'admin', controller: 'main', action: 'email_group'
