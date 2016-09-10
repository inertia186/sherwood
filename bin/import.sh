if [ -z "$RAILS_ENV" ]; then
  echo "RAILS_ENV not set."
  exit
fi

cat projects.csv | rake sherwood:import:projects
cat users.csv | rake sherwood:import:users
cat posts.csv | rake sherwood:import:posts

