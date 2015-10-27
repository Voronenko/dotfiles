dir=~/.WebIde90                    # webide directory
olddir=~/WebIde90_old             # old webide backup directory
files="config/codestyles/Slavko.xml config/options/updates.xml config/options/code.style.schemes.xml config/templates/angular_basic.xml config/templates/es_basic.xml  config/templates/jasmine_basic.xml config/templates/lodash_basic.xml"    # list of files/folders to symlink in webide dir

##########

# create WebIde90_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the  directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to WebIde_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving $dir/$file to $olddir"
    echo "Moving $dir/$file to $olddir" >> $olddir/backup.log
    mv $dir/$file $olddir/
    echo "Creating symlink $dir/$file pointing on ~/dotfiles/webide/$file"
    echo "ln -s ~/dotfiles/webide/$file $dir/$file"
    ln -s ~/dotfiles/webide/$file $dir/$file
done

