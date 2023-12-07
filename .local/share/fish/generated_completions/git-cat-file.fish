# git-cat-file
# Autogenerated from man page /nix/store/jha53c5kh54c46fgywh37v3m3h4hcl0k-git-2.34.1/share/man/man1/git-cat-file.1.gz
complete -c git-cat-file -s t -d 'Instead of the content, show the object type identified by <object>'
complete -c git-cat-file -s s -d 'Instead of the content, show the object size identified by <object>'
complete -c git-cat-file -s e -d 'Exit with zero status if <object> exists and is a valid object'
complete -c git-cat-file -s p -d 'Pretty-print the contents of <object> based on its type'
complete -c git-cat-file -l textconv -d 'Show the content as transformed by a textconv filter'
complete -c git-cat-file -l filters -d 'Show the content as converted by the filters configured in the current workin…'
complete -c git-cat-file -l path -d 'For use with --textconv or --filters, to allow specifying an object name and …'
complete -c git-cat-file -l batch -l batch -d 'Print object information and contents for each object provided on stdin'
complete -c git-cat-file -l batch-check -l batch-check -d 'Print object information for each object provided on stdin'
complete -c git-cat-file -l batch-all-objects -d 'Instead of reading a list of objects on stdin, perform the requested batch op…'
complete -c git-cat-file -l buffer -d 'Normally batch output is flushed after each object is output, so that a proce…'
complete -c git-cat-file -l unordered -d 'When --batch-all-objects is in use, visit objects in an order which may be mo…'
complete -c git-cat-file -l allow-unknown-type -d 'Allow -s or -t to query broken/corrupt objects of unknown type'
complete -c git-cat-file -l follow-symlinks -d 'With --batch or --batch-check, follow symlinks inside the repository when req…'

