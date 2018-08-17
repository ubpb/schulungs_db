server "ubperseus", user: "ubpb", roles: %w{app web db}
server "ubpegasus", user: "ubpb", roles: %w{app web}
set :deploy_to, "/ubpb/schulungsdb"
set :branch, "production"
