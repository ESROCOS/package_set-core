
require 'autoproj/gitorious'
if !Autoproj.has_source_handler? 'github'
    Autoproj.gitorious_server_configuration('GITHUB', 'github.com', :http_url => 'https://github.com')
end


Autoproj.env_inherit 'CMAKE_PREFIX_PATH'

Autoproj.env_add_path 'PKG_CONFIG_PATH', "$AUTOPROJ_CURRENT_ROOT/install/pkgconfig"

Autoproj.env_add_path 'CPLUS_INCLUDE_PATH', "$AUTOPROJ_CURRENT_ROOT/install/include"

Autoproj.env_add_path 'C_INCLUDE_PATH', "$AUTOPROJ_CURRENT_ROOT/install/include"

Autoproj.env_add_path 'CPATH', "$AUTOPROJ_CURRENT_ROOT/install/include"

Autoproj.env_add_path 'LD_LIBRARY_PATH', "$AUTOPROJ_CURRENT_ROOT/install/lib/orocos/types"

# Autoproj changes PYTHONUSERBASE, but we need access to Python packages installed at system level 
# (e.g., packages installed by TASTE at the default location), so we add the default user-site to 
# PYTHONPATH.
default_python3_user_base = "`env -i python3 -m site --user-site`".chop
Autoproj.env_add_path 'PYTHONPATH', default_python3_user_base, "$AUTOPROJ_CURRENT_ROOT/install/lib/python"

Autoproj.env_set 'ESROCOS_TEMPLATES', ENV["AUTOPROJ_CURRENT_ROOT"]+"/install/templates"

Autoproj.env_set 'ESROCOS_CMAKE', ENV["AUTOPROJ_CURRENT_ROOT"]+"/install/cmake_macros/esrocos.cmake"

def esrocos_package(name, workspace: Autoproj.workspace)
    package_common(:cmake, name, workspace: workspace) do |pkg|
      pkg.depends_on 'cmake'
      pkg.depends_on 'tools/workflow'
      
      common_make_based_package_setup(pkg)

      yield(pkg) if block_given?
 
      #works but causes non-termination error state when errors during build occur and --no-retry is not set
      #puts pkg.post_install do
      #    Autobuild::Subprocess.run(
      #                        pkg, "install",
      #                        "esrocos_build_project",
      #                        :working_directory => pkg.srcdir)
      #end
    end    
end
