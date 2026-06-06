clear

ansible-inventory -y --list
#
# Setup logging: create logs dir and timestamped logfile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
mkdir -p "$LOG_DIR"
LOGFILE="$LOG_DIR/tags-$(date +%Y%m%d-%H%M%S).log"
ln -sf "$LOGFILE" "$LOG_DIR/latest-tags.log"
echo "Logging ansible output to $LOGFILE"

TAGS=$(IFS=,; echo "$*")

ansible-playbook --tags "$TAGS" -v --limit '!gh-servers,!localhost' run-main.yml 2>&1 | tee -a "$LOGFILE"

#ansible-playbook --tag $1 $1 -v --limit '!gh-servers !localhost' run-main.yml 2>&1 | tee -a "$LOGFILE" # works

#I use the above script to start my ansible. I want it to be able to start specific tags regardless of how many i enter at the prompt