# make the script fail for any failed command
set -e
# make the script display the commands it runs to help debugging failures
set -x

# configure env
git config --global user.email 'waldio.webdesign@gmail.com'
git config --global user.name 'WouterJ.nl bot'

# checkout publish branch
if [ "`git show-ref --heads master`" ]; then
  git branch -D master
fi
git checkout -b master

# build site
sass source/css/wouterj.scss:source/css/wouterj.css --style compressed --no-cache
./vendor/bin/sculpin generate --env prod
touch output_prod/.nojekyll

# commit build
git add -f output_prod
git commit -m "Build website"

# only push output
git filter-branch --subdirectory-filter output_prod/ -f

# push to GitHub Pages
git push "https://github.com/WouterJ/wouterj.github.com" -f master
