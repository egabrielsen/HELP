# See https://github.com/voltrb/volt#routes for more info on routes

client '/about', action: 'about'
client '/events', component: 'main', controller: 'events', action: 'index'
client '/clubs', component: 'main', controller: 'clubs', action: 'index'
client '/organizations', component: 'main', controller: 'clubs', action: 'clubs'
client '/competencies', component: 'main', controller: 'competencies', action: 'index'

# Routes for login and signup, provided by user_templates component gem
client '/signup', component: 'user_templates', controller: 'signup'
client '/login', component: 'user_templates', controller: 'login', action: 'index'
client '/password_reset', component: 'user_templates', controller: 'password_reset', action: 'index'
client '/forgot', component: 'user_templates', controller: 'login', action: 'forgot'
client '/account', component: 'user_templates', controller: 'account', action: 'index'
# The main route, this should be last. It will match any params not
# previously matched.
client '/', {}
