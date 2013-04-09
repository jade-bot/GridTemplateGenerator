# Aditional compass plugins installed on the system.
require 'compass-normalize'
require 'susy'

# Location of the project's resources.
images_dir = "../../public/images"
fonts_dir  = "../../public/fonts"

# Project rot.
http_path = "/"

# Switch between environment for diferent output styles.
output_style = ( environment == :production ) ? :compressed : :expanded