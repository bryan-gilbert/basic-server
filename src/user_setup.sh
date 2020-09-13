#!/usr/bin/env bash

echo "Home is ${HOME}"
USER_BASH=~/.bashrc
CUSTOMIZATION_NAME=.bash_customize_ssh
CUSTOMIZATION_FILE=resource/$CUSTOMIZATION_NAME
USER_CUSTOM_HOME=~/$CUSTOMIZATION_NAME
ALIAS_FILENAME=.bash_aliases
CUSTOM_ALIAS_FILE=resource/custom_aliases
CUSTOM_ALIAS_TEST_TEXT=customAliases
USER_ALIAS=~/$ALIAS_FILENAME

if [ -f "$USER_BASH" ]; then
  if [ -f $CUSTOMIZATION_FILE ]; then
    # test if user profile needs our customization
    if ! grep -q "${CUSTOMIZATION_NAME}" "$USER_BASH"
    then
      echo "Make backup of bash file"
      cp "${USER_BASH}" ${USER_BASH}.bak
      echo 'if [ -f ~/.bash_customize_ssh ]; then source ~/.bash_customize_ssh; fi' >> "$USER_BASH"
    fi

    if [ ! -f USER_CUSTOM_HOME ]; then
      echo "Copy $CUSTOMIZATION_FILE to $USER_CUSTOM_HOME"
      cp $CUSTOMIZATION_FILE $USER_CUSTOM_HOME
    fi
  fi
  if [ -f $CUSTOM_ALIAS_FILE ]; then
    if ! grep -q $ALIAS_FILENAME $USER_BASH; then
      echo "Get $USER_BASH to source alias file"
      echo "if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi" >> ${USER_BASH}
    fi

    if [ -f $USER_ALIAS ]; then
      if ! grep -q $CUSTOM_ALIAS_TEST_TEXT $USER_ALIAS
      then
        echo "Insert $CUSTOM_ALIAS_FILE into $USER_ALIAS"
        cat $CUSTOM_ALIAS_FILE >> $USER_ALIAS
      fi
    else
      echo "Copy $CUSTOM_ALIAS_FILE to $USER_ALIAS"
      cp $CUSTOM_ALIAS_FILE $USER_ALIAS
    fi
  fi
fi

echo "source $USER_BASH"
source $USER_BASH

#./user_setup_git.sh
