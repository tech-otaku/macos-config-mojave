#!/usr/bin/env bash

# # # # # # # # # # # # # # # # # # # # # # # # # #
# # INSTALL HOMEBREW
# #

    if [[ $(which brew) != "/usr/local/bin/brew" ]]; then
        # Homebrew
        #/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

        echo "Installed Homebrew"

    fi

    # Bash
    if [[ $(which bash) != "/usr/local/bin/bash" ]]; then
        brew install bash
        echo "/usr/local/bin/bash" | sudo tee -a /etc/shells  > /dev/null 2>&1
        sudo chsh -s /usr/local/bin/bash steve

        echo "Installed Bash"
    
    fi

    # hcloud
#    if [[ $(which hcloud) != "/usr/local/bin/hcloud" ]]; then
#        brew install hcloud
#
#        echo "Installed hcloud"
#    
#    fi

#    # pyenv
#    if [[ $(which pyenv) != "/usr/local/bin/pyenv" ]]; then
#        brew install pyenv
#
#        echo "Installed pyenv"
#    
#    fi

# Revoke sudo privileges
#    sudo -k