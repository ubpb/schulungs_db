server "ubstage1", user: "ubpb", roles: %w{app db web}
set :deploy_to, "/ubpb/schulungsdb"
set :branch, "master"
