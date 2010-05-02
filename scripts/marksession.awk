BEGIN {
  session_count = 0;
  FS="|"
  OFS="|"
}

{
  if ($1 ~ "[0-9]+") {
    # See if the current line is already in the table
    frame_file = destDir "/frames/Frame"$3".html"
    session_line = ""
    "grep -i \"" session_token "\" " frame_file | getline session_line

    if (session_line == "" ) {
      $6 = "{0}"
      print $0

    } else {
      found = 0;
      split(session_line, array, " ")
      session = array[2]
      for (i=0; i < session_count; i++) {
        if (sessions[i] == session) {
          found = 1
          $6 = "{" i+1 "}"
          print $0
          break
        }
      }

      if (found == 0) {
        $6 = "{" session_count+1 "}"
        sessions[session_count++] = session
        print $0
        s = sprintf("echo '%2d: new session in frame %4s: %s' >&2", session_count, $3, session)
        system(s)
      }
    }
  
  } else {
    # Comment line, line starting with "#".
    # Requires no processing, just print it
    print $0
  }
}

