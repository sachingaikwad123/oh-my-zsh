
function history-stat() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head
}

function mkdcd() {
  mkdir -p "$1"
  cd "$1"
}

function cdll() {
  if [[ -n "$1" ]]; then
    builtin cd "$1"
    ls -lFhA
  else
    ls -lFhA
  fi
}

function pushdll() {
  if [[ -n "$1" ]]; then
    builtin pushd "$1"
    ls -lFhA
  else
    ls -lFhA
  fi
}

function popdll() {
  builtin popd
  ls -lFhA
}

function gown() {
  sudo chown -R "${USER}" "${1:-.}"
}

function reload() {
  local zshrc="$HOME/.zshrc"
  if [[ -n "$1" ]]; then
    zshrc="$1"
  fi
  source "$zshrc"
}

function calc() {
  echo "scale=4; $@" | bc -l
}

function pmine() {
  ps "$@" -u "$USER" -o pid,%cpu,%mem,command
}

function findexec() {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" {} \;
}

function httpserve() {
  python -m SimpleHTTPServer "$@"
}

# screen hack to change title of window when login to other machines
function ssh() {
    args=$@
    OLDHOSTNAME=`hostname|cut -d "." -f1 `;
    echo -ne "\033k${args##* }\033\\";
    /usr/bin/ssh "$@";
    # Set window title back here!
    echo -ne "\033k${OLDHOSTNAME}\033\\";
}

# Delete given 'string' from .ssh/known_hosts
function sshdel()
{
    HOSTNAME=$1
    if [ -z $HOSTNAME ]
    then
	echo "No hostname given. Nothing deleted from .ssh/known_hosts"
	return
    fi
    sed -i "/$HOSTNAME/d" ~/.ssh/known_hosts
}

function pmake()
{
    PRETTY=1 nice -n 20 ionice -c 3 make $@
}

function duf()
{
    du -skc "$@" | sort -n | while read size fname; \
do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; \
then echo -e "${size}${unit}\t${fname}"; break; fi; \
size=$((size/1024)); done; done

}

# Print git config user.name and user.email
function gcu()
{
    echo "Name : `git config user.name`"
    echo "Email: `git config user.email`"
}

# Change gitconfig from "personal" or "work"
# gitconfig file names should be this format: gitconfig_<theme>
# Example: For "personal": gitconfig_personal should be present in homedir
# Current supported themes:
# 	- personal
# 	- work
function chgit()
{
    GITCONFIG_FILE="$HOME/.gitconfig"
    TO_THEME=$1
    TO_GITCONFIG_FILE="$HOME/gitconfig_${TO_THEME}"
    if [ ! -f "${TO_GITCONFIG_FILE}" ]; then
	echo "ERROR: ${TO_THEME} is not valid. ${TO_GITCONFIG_FILE} file does not exist."
	return
    fi
    echo "Switching gitconfig to '${TO_THEME}'"
    rm -rf ${GITCONFIG_FILE}
    ln -s "${TO_GITCONFIG_FILE}" "${GITCONFIG_FILE}"
    if [[ $? -ne 0 ]]; then
	echo "ERROR: Failed to create ${GITCONFIG_FILE} file."
	return
    fi
    gcu
}
