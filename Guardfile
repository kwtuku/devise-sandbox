# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
directories(%w[app config].select { |d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist") })

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard 'process', name: 'BuildingTailwindCSS', command: 'bin/rails tailwindcss:build', stop_signal: 'KILL' do
  watch(%r{app/helpers/.+\.rb})
  watch(%r{app/javascript/.+\.js})
  watch(%r{app/views/.+\.(erb|haml|html|slim)})
  watch('app/assets/stylesheets/application.tailwind.css')
  watch('config/tailwind.config.js')
end
