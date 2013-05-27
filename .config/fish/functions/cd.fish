#
# This makes the 'cd' command emit CHDIR events, so hooks can act upon
# that and perform useful stuff upon each dir change.
#
function cd --description "Change working directory"
  builtin cd $argv

  set -l success $status

  # Only emit events when we're ready for them
  if test "$success" -eq 0
    if test "$__fish_initialized" -eq 1
      emit CHDIR $argv
    end
  end

  return $success
end
