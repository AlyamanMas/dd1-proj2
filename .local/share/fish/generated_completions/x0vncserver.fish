# x0vncserver
# Autogenerated from man page /nix/store/0b2bvviijkvq2nvm04dbq3lwlq7h742m-tigervnc-1.12.0/share/man/man1/x0vncserver.1.gz
complete -c x0vncserver -o SomeParameter -d 'Enable the parameter, turn the feature on'
complete -c x0vncserver -o desktop -d 'Each desktop has a name which may be displayed by the viewer'
complete -c x0vncserver -o display -d 'The X display name'
complete -c x0vncserver -o rfbport -d 'Specifies the TCP port on which x0vncserver listens for connections from view…'
complete -c x0vncserver -o fbport -s 1
complete -c x0vncserver -o UseIPv4 -d 'Use IPv4 for incoming and outgoing connections.  Default is on'
complete -c x0vncserver -o UseIPv6 -d 'Use IPv6 for incoming and outgoing connections.  Default is on'
complete -c x0vncserver -o rfbunixpath -d 'Specifies the path of a Unix domain socket on which x0vncserver listens for c…'
complete -c x0vncserver -o rfbunixmode -d 'Specifies the mode of the Unix domain socket.   The default is 0600'
complete -c x0vncserver -o Log -d 'Configures the debug log settings'
complete -c x0vncserver -o HostsFile -d 'This parameter allows to specify a file name with IP access control rules'
complete -c x0vncserver -o SecurityTypes -d 'Specify which security scheme to use for incoming connections'
complete -c x0vncserver -o rfbauth -o PasswordFile -d 'Password file for VNC authentication'
complete -c x0vncserver -o Password -d 'Obfuscated binary encoding of the password which clients must supply to acces…'
complete -c x0vncserver -o PlainUsers -d 'A comma separated list of user names that are allowed to authenticate via any…'
complete -c x0vncserver -o pam_service -o PAMService -d 'PAM service name to use when authentication users using any of the "Plain" se…'
complete -c x0vncserver -o X509Cert -d 'Path to a X509 certificate in PEM format to be used for all X509 based securi…'
complete -c x0vncserver -o X509Key -d 'Private key counter part to the certificate given in X509Cert'
complete -c x0vncserver -o GnuTLSPriority -d 'GnuTLS priority string that controls the TLS sessionâs handshake algorithms'
complete -c x0vncserver -o UseBlacklist -d 'Temporarily reject connections from a host if it repeatedly fails to authenti…'
complete -c x0vncserver -o BlacklistThreshold -d 'The number of unauthenticated connection attempts allowed from any individual…'
complete -c x0vncserver -o BlacklistTimeout -d 'The initial timeout applied when a host is first black-listed'
complete -c x0vncserver -o QueryConnect -d 'Prompts the user of the desktop to explicitly accept or reject incoming conne…'
complete -c x0vncserver -o QueryConnectTimeout -d 'Number of seconds to show the Accept Connection dialog before rejecting the c…'
complete -c x0vncserver -o localhost -d 'Only allow connections from the same machine'
complete -c x0vncserver -o interface -d 'Listen on interface'
complete -c x0vncserver -o AlwaysShared -d 'Always treat incoming connections as shared, regardless of the client-specifi…'
complete -c x0vncserver -o NeverShared -d 'Never treat incoming connections as shared, regardless of the client-specifie…'
complete -c x0vncserver -o DisconnectClients -d 'Disconnect existing clients if an incoming connection is non-shared'
complete -c x0vncserver -o AcceptKeyEvents -d 'Accept key press and release events from clients.  Default is on'
complete -c x0vncserver -o AcceptPointerEvents -d 'Accept pointer press and release events from clients.  Default is on'
complete -c x0vncserver -o AcceptSetDesktopSize -d 'Accept requests to resize the size of the desktop.  Default is on'
complete -c x0vncserver -o RemapKeys -d 'Sets up a keyboard mapping'
complete -c x0vncserver -o RawKeyboard -d 'Send keyboard events straight through and avoid mapping them to the current k…'
complete -c x0vncserver -o 'Protocol3.3' -d 'Always use protocol version 3'
complete -c x0vncserver -o Geometry -d 'This option specifies the screen area that will be shown to VNC clients'
complete -c x0vncserver -o MaxProcessorUsage -d 'Maximum percentage of CPU time to be consumed when polling the screen'
complete -c x0vncserver -o PollingCycle -d 'Milliseconds per one polling cycle'
complete -c x0vncserver -o FrameRate -d 'The maximum number of updates per second sent to each client'
complete -c x0vncserver -o CompareFB -d 'Perform pixel comparison on framebuffer to reduce unnecessary updates'
complete -c x0vncserver -o UseSHM -d 'Use MIT-SHM extension if available'
complete -c x0vncserver -o ZlibLevel -d 'Zlib compression level for ZRLE encoding (it does not affect Tight encoding)'
complete -c x0vncserver -o ImprovedHextile -d 'Use improved compression algorithm for Hextile encoding which achieves better…'
complete -c x0vncserver -o IdleTimeout -d 'The number of seconds after which an idle VNC connection will be dropped'
complete -c x0vncserver -o MaxDisconnectionTime -d 'Terminate when no client has been connected for N seconds.   Default is 0'
complete -c x0vncserver -o MaxConnectionTime -d 'Terminate when a client has been connected for N seconds.   Default is 0'
complete -c x0vncserver -o MaxIdleTime -d 'Terminate after N seconds of user inactivity.   Default is 0'

