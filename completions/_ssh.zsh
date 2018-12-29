#compdef ssh ssh-ident=ssh slogin=ssh ~/dotfiles/ssh/ssh-ident=ssh scp ssh-add ssh-agent ssh-copy-id ssh-keygen ssh-keyscan sftp

# TODO: sshd, ssh-keysign

_ssh () {
  local curcontext="$curcontext" state line expl suf ret=1
  local args common common_transfer algopt tmp p1 file cmn cmds sdesc
  typeset -A opt_args

  common=(
    '(-6)-4[forces ssh to use IPv4 addresses only]'
    '(-4)-6[forces ssh to use IPv6 addresses only]'
    '-C[compress data]'
    '-c+[select encryption cipher]:encryption cipher:->ciphers'
    '-F+[specify alternate config file]:config file:_files'
    '*-i+[select identity file]:SSH identity file:_files -g "*(-.^AR)"'
    '*-o+[specify extra options]:option string:->option'
  )
  common_transfer=(
    '-l+[limit used bandwidth]:bandwidth (Kbit/s)'
    '-P+[specify port on remote host]:port number on remote host'
    '-p[preserve modification times, access times and modes]'
    '-q[disable progress meter and warnings]'
    '-r[recursively copy directories (follows symbolic links)]'
    '-S+[specify ssh program]:path to ssh:_command_names -e' \
    '-v[verbose mode]'
  )
  algopt='-E+[specify hash algorithm for fingerprints]:algorithm:(md5 sha256)'

  case "$service" in
  ssh)
    _arguments -C -s \
      '(-a)-A[enable forwarding of the authentication agent connection]' \
      '(-A)-a[disable forwarding of authentication agent connection]' \
      '-B+[bind to specified interface before attempting to connect]:interface:_net_interfaces' \
      '(-P)-b+[specify interface to transmit on]:bind address:_bind_addresses' \
      '-D+[specify a dynamic port forwarding]:dynamic port forwarding:->dynforward' \
      '-e+[set escape character]:escape character (or `none'\''):' \
      '-E+[append log output to file instead of stderr]:_files' \
      '(-n)-f[go to background]' \
      '-g[allow remote hosts to connect to local forwarded ports]' \
      '-G[output configuration and exit]' \
      '-I+[specify smartcard device]:device:_files' \
      '-J+[connect via a jump host]: :->userhost' \
      '-K[enable GSSAPI-based authentication and forwarding]' \
      '-k[disable forwarding of GSSAPI credentials]' \
      '*-L+[specify local port forwarding]:local port forwarding:->forward' \
      '-l+[specify login name]:login name:_ssh_users' \
      '-M[master mode for connection sharing]' \
      '-m+[specify mac algorithms]: :->macs' \
      "-N[don't execute a remote command]" \
      '-n[redirect stdin from /dev/null]' \
      '-O+[control an active connection multiplexing master process]:multiplex control command:((check\:"check master process is running" exit\:"request the master to exit" forward\:"request forward without command execution" stop\:"request the master to stop accepting further multiplexing requests" cancel\:"cancel existing forwardings with -L and/or -R" proxy))' \
      '-P[use non privileged port]' \
      '-p+[specify port on remote host]:port number on remote host' \
      '(-v)*-q[quiet operation]' \
      '*-R+[specify remote port forwarding]:remote port forwarding:->forward' \
      '-S+[specify location of control socket for connection sharing]:path to control socket:_files' \
      '-Q+[query parameters]:query option:((cipher\:"supported symmetric ciphers" cipher-auth\:"supported symmetric ciphers that support authenticated encryption" mac\:"supported message integrity codes" kex\:"key exchange algorithms" key\:"key types" key-cert\:"certificate key types" key-plain\:"non-certificate key types" protocol-version\:"supported SSH protocol versions" sig\:"supported signature algorithms" help\:"show supported queries"))' \
      '-s[invoke subsystem]' \
      '(-t)-T[disable pseudo-tty allocation]' \
      '(-T)-t[force pseudo-tty allocation]' \
      '-V[show version number]' \
      '(-q)*-v[verbose mode (multiple increase verbosity, up to 3)]' \
      '-W+[forward standard input and output to host]:stdinout forward:->hostport' \
      '-w+[request tunnel device forwarding]:local_tun[\:remote_tun] (integer or "any"):' \
      '(-x -Y)-X[enable (untrusted) X11 forwarding]' \
      '(-X -Y)-x[disable X11 forwarding]' \
      '(-x -X)-Y[enable trusted X11 forwarding]' \
      '-y[send log info via syslog instead of stderr]' \
      ':remote host name:->userhost' \
      '*::args:->command' "$common[@]" && ret=0
    ;;
  scp)
    _arguments -C -s \
      '-3[copy through local host, not directly between the remote hosts]' \
      '-B[batch mode (don'\''t ask for passphrases)]' \
      '*:file:->file' "$common[@]" "$common_transfer[@]" && ret=0
    ;;
  ssh-add)
    [[ $OSTYPE == darwin* ]] && args=(
      '-A[add identities from keychain]'
      '-K[update keychain when adding/removing identities]'
    )
    _arguments -s : $args \
      '-c[identity is subject to confirmation via SSH_ASKPASS]' \
      '-D[delete all identities]' \
      '-d[remove identity]' \
      $algopt \
      '-e+[remove keys provided by the PKCS#11 shared library]:library:_files -g "*.(so|dylib)(|.<->)(-.)"' \
      '-k[load plain private keys only and skip certificates]' \
      '-L[list public key parameters of all identities in the agent]'\
      '-l[list all identities]' \
      '-m+[specify minimum remaining signatures before maximum is changed]:number' \
      '-M+[specify maximum number of signatures]:number' \
      '-s+[add keys provided by the PKCS#11 shared library]:library:_files -g "*.(so|dylib)(|.<->)(-.)"' \
      '-t+[set maximum lifetime for identity]:maximum lifetime (in seconds or time format):' \
      '-q[be quiet after a successful operation]' \
      '-X[unlock the agent]' \
      '-x[lock the agent with a password]' \
      '*:SSH identity file:_files'
    return
    ;;
  ssh-agent)
    _arguments -s \
      '(-k)-a+[UNIX-domain socket to bind agent to]:UNIX-domain socket:_files' \
      '(-k -s)-c[force csh-style shell]' \
      '(-k)-d[debug mode]' \
      '(-k)-D[foreground mode]' \
      "(-k)$algopt" \
      '-k[kill current agent]' \
      '(-k)-P[specify PKCS#11 shared library whitelist]:PKCS#11 library whitelist pattern' \
      '(-k -c)-s[force sh-style shell]' \
      '-t[set default maximum lifetime for identities]:maximum lifetime (in seconds or time format):' \
      '*::command: _normal'
    return
    ;;
  ssh-keygen)
    # options can be in any order but use ! to limit those shown for the first argument
    (( CURRENT == 2 )) && p1='!'
    args=( '!-z:number' )
    sdesc='certify keys with CA key'
    (( $+words[(r)-s] )) && args=( '-z[specify serial number]:serial number' )
    (( $+words[(r)-[ku]] )) && args=( '-z[specify version number]:version number' ) &&
        sdesc='specify CA public key file'
    file=key
    (( $+words[(r)-[HR]] )) && file=known_hosts
    (( $+words[(r)-T] )) && file=input
    if (( $+words[(r)-[kQ]] )); then
      file=krl
      args+=( '*:file:_files' )
    fi
    cmds=( -p -i -e -y -c -l -B -D -H -R -r -G -T -s -L -A -k -Q ) # basic commands
    cmn=( -b -P -N -C -m -v ) # options common to many basic commands (except -f which is common to most)
    cms=( -E -q -t -g -M -S -a -J -j -K -W -I -h -n -O -V -u ) # options specific to one basic command
    _arguments -s $args \
      "(${${(@)cmds:#-G}} -P -m ${${(@)cms:#-[MS]}})-b+[specify number of bits in key]:bits in key" \
      "$p1(${${(@)cmds:#-[pc]}} -b -C $cms)-P+[provide old passphrase]:old passphrase" \
      "(${${(@)cmds:#-p}} -m -v ${${(@)cms:#-[qt]}})-N+[provide new passphrase]:new passphrase" \
      "(${${(@)cmds:#-c}} -m -v $cms)-C+[provide new comment]:new comment" \
      "(-D -G -M -S -I -h -n -O -V -A)-f+[$file file]:$file file:_files" \
      "$p1(${${(@)cmds:#-[ie]}})-m+[specify conversion format]:format:(PEM PKCS7 RFC4716)" \
      "(${${(@)cmds:#-[lGT]}} ${${(@)cmn:#-[bv]}} -f)*-v[verbose mode]" \
      - '(commands)' \
      "(-b -P -C -v)-p[change passphrase of private key file]" \
      '(-b -P -N -C -v)-i[import key to OpenSSH format]' \
      '(-b -P -N -C -v)-e[export key to SECSH file format]' \
      "($cmn)-y[get public key from private key]" \
      '(-b -N -m -v)-c[change comment in private and public key files]' \
      "($cmn)-B[show the bubblebabble digest of key]" \
      "(-)-D+[download key stored in smartcard reader]:reader" \
      "($cmn)-H[hash names in known_hosts file]" \
      "($cmn)-R+[remove host from known_hosts file]:host:_ssh_hosts" \
      "($cmn)-L[print the contents of a certificate]" \
      "(-)-A[generate host keys for all key types]" \
      "($cmn)-Q[test whether keys have been revoked in a KRL]" \
      - finger \
      "($cmn)-l[show fingerprint of key file]" \
      "$p1($cmn)$algopt" \
      - create \
      '(-P -m)-q[silence ssh-keygen]' \
      "(-P -m)-t+[specify the type of the key to create]:key type:(rsa dsa ecdsa ed25519)" \
      - dns \
      "($cmn)-r[print DNS resource record]:hostname:_hosts" \
      "$p1($cmn)-g[use generic DNS format]" \
      - primes \
      "(-P -N -C -m -f)-G[generate candidates for DH-GEX moduli]" \
      "$p1(-P -N -C -m -f)-M+[specify amount of memory to use for generating DH-GEX moduli]:memory (MB)" \
      "$p1(-P -N -C -m -f)-S+[specify start point]:start point (hex)" \
      - screen \
      "(${${(@)cmn:#-v}})-T+[screen candidates for DH-GEX moduli]:output file:_files" \
      "${p1}(${${(@)cmn:#-v}})-a+[specify number of rounds]:rounds" \
      "${p1}(${${(@)cmn:#-v}})-J[exit after screening specified number of lines]" \
      "${p1}(${${(@)cmn:#-v}})-j+[start screening at the specified line number]:line number" \
      "${p1}(${${(@)cmn:#-v}})-K+[write the last line processed to file]:file:_files" \
      "${p1}(${${(@)cmn:#-v}})-W[specify desired generator]:generator" \
      - certify \
      "($cmn)-s[$sdesc]:CA key:_files" \
      "$p1($cmn -f -u)-I+[specify key identifier to include in certificate]:key id" \
      "$p1($cmn -f -u)-h[generate host certificate instead of a user certificate]" \
      "$p1($cmn -f -u -D)-U[indicate that CA key is held by ssh-agent]" \
      "$p1($cmn -f -u -U)-D+[indicate the CA key is stored in a PKCS#11 token]:PKCS11 shared library:_files -g '*.(so|dylib)(|.<->)(-.)'" \
      "$p1($cmn -f -u)-n+[specify user/host principal names to include in certificate]:principals" \
      "$p1($cmn -f -u)*-O+[specify a certificate option]: : _values 'option'
        clear critical\:name extension\:name force-command\:command\:_cmdstring
	no-agent-forwarding no-port-forwarding no-pty no-user-rc no-x11-forwarding
	permit-agent-forwarding permit-port-forwarding permit-pty permit-user-rc
	permit-x11-forwarding source-address\:source\ address" \
      "$p1($cmn -f -u)-V+[specify certificate validity interval]:interval" \
      "($cmn -I -h -n -O -V)-k[generate a KRL file]" \
      "$p1($cmn -I -h -n -O -V)-u[update a KRL]"
    return
  ;;
  ssh-keyscan)
    _arguments \
      '(-6)-4[forces ssh to use IPv4 addresses only]' \
      '(-4)-6[forces ssh to use IPv6 addresses only]' \
      '-c[request certificates from target hosts instead of plain keys]' \
      '*-f+[read hosts from file, one per line]:file:_files' \
      '-H[hash all hostnames and addresses in the output]' \
      '-p+[specify port on remote host]:port number on remote host' \
      '-T+[specify timeout]:timeout (seconds) [5]' \
      '-t+[specify key types to fetch from scanned hosts]:key type:_sequence compadd - rsa dsa ecdsa ed25519' \
      '-v[verbose mode]'
    return
  ;;
  sftp)
    _arguments -C -s \
      '-a[attempt to continue interrupted transfers]' \
      '-B+[specify buffer size]:buffer size (bytes) [32768]' \
      '-b+[specify batch file to read]:batch file:_files' \
      '-D+[connect directly to a local sftp server]:sftp server path' \
      '-f[request that files be flushed immediately after transfer]' \
      '-R+[specify number of outstanding requests]:number of requests [64]' \
      '-s+[SSH2 subsystem or path to sftp server on the remote host]:subsystem/path' \
      '1:file:->rfile' '*:file:->file' "$common[@]" "$common_transfer[@]" && ret=0
    ;;
  ssh-copy-id)
    _arguments \
      '-i+[select identity file]:SSH identity file:_files -g "*(-.^AR)"' \
      '-f[copy keys without trying to check if they are already installed]' \
      '-n[dry run - no keys are actually copied]' \
      '*-o+[specify ssh options]:option string:->option' \
      '-p+[specify port on remote host]:port number on remote host' \
      '(- 1)'{-h,-\?}'[display usage information]' \
      ':remote host name:->userhost' && ret=0
    ;;
  esac

  while [[ -n "$state" ]]; do
    lstate="$state"
    state=''

    case "$lstate" in
    option)
      if compset -P 1 '*='; then
        case "${IPREFIX#-o}" in
          (#i)(ciphers|macs|kexalgorithms|hostkeyalgorithms|pubkeyacceptedkeytypes|hostbasedkeytypes)=)
          if ! compset -P +; then
            _wanted append expl 'append to default' compadd + && ret=0
          fi
          ;;
        esac
        case "${IPREFIX#-o}" in
        (#i)(afstokenpassing|batchmode|canonicalizefallbacklocal|challengeresponseauthentication|checkhostip|clearallforwardings|compression|enablesshkeysign|exitonforwardfailure|fallbacktorsh|forward(agent|x11)|forwardx11trusted|gatewayports|gssapiauthentication|gssapidelegatecredentials|gssapikeyexchange|gssapirenewalforcesrekey|gssapitrustdns|hashknownhosts|hostbasedauthentication|identitiesonly|kbdinteractiveauthentication|(tcp|)keepalive|nohostauthenticationforlocalhost|passwordauthentication|permitlocalcommand|proxyusefdpass|pubkeyauthentication|rhosts(|rsa)authentication|rsaauthentication|streamlocalbindunlink|usersh|kerberos(authentication|tgtpassing)|useprivilegedport|visualhostkey)=*)
          _wanted values expl 'truth value' compadd yes no && ret=0
          ;;
        (#i)addressfamily=*)
          _wanted values expl 'address family' compadd any inet inet6 && ret=0
          ;;
        (#i)bindaddress=*)
          _wanted bind-addresses expl 'bind address' _bind_addresses && ret=0
          ;;
        (#i)canonicaldomains=*)
          _message -e 'canonical domains (space separated)' && ret=0
          ;;
        (#i)canonicalizehostname=*)
          _wanted values expl 'truthish value' compadd yes no always && ret=0
          ;;
        (#i)canonicalizemaxdots=*)
          _message -e 'number of dots' && ret=0
          ;;
        (#i)canonicalizepermittedcnames=*)
          _message -e 'CNAME rule list (source_domain_list:target_domain_list, each pattern list comma separated)' && ret=0
          ;;
        (#i)ciphers=*)
          state=ciphers
          ;;
        (#i)connectionattempts=*)
          _message -e 'connection attempts' && ret=0
          ;;
        (#i)connecttimeout=*)
          _message -e 'connection timeout' && ret=0
          ;;
        (#i)controlmaster=*)
          _wanted values expl 'truthish value' compadd yes no auto autoask && ret=0
          ;;
        (#i)controlpath=*)
          _description files expl 'path to control socket'
          _files "$expl[@]" && ret=0
          ;;
        (#i)controlpersist=*)
          _message -e 'timeout'
          ret=0
          _wanted values expl 'truth value' compadd yes no && ret=0
          ;;
        (#i)escapechar=*)
          _message -e 'escape character (or `none'\'')'
          ret=0
          ;;
        (#i)fingerprinthash=*)
          _values 'fingerprint hash algorithm' \
              md5 ripemd160 sha1 sha256 sha384 sha512 && ret=0
          ;;
        (#i)forwardx11timeout=*)
          _message -e 'timeout'
          ret=0
          ;;
        (#i)globalknownhostsfile=*)
          _description files expl 'global file with known hosts'
          _files "$expl[@]" && ret=0
          ;;
        (#i)hostname=*)
          _wanted hosts expl 'real host name to log into' _ssh_hosts && ret=0
          ;;
        (#i)(hostbasedkeytypes|hostkeyalgorithms|pubkeyacceptedkeytypes)=*)
	  _wanted key-types expl 'key type' _sequence compadd - $(_call_program key-types ssh -Q key) && ret=0
          ;;
        (#i)identityfile=*)
          _description files expl 'SSH identity file'
          _files "$expl[@]" && ret=0
          ;;
        (#i)ignoreunknown=*)
          _message -e 'pattern list' && ret=0
          ;;
        (#i)ipqos=*)
          local descr
          if [[ $PREFIX = *\ *\ * ]]; then return 1; fi
          if compset -P '* '; then
            descr='QoS for non-interactive sessions'
          else
            descr='QoS [for interactive sessions if second value given, separated by white space]'
          fi
          _values $descr 'af11' 'af12' 'af13' 'af14' 'af22' \
              'af23' 'af31' 'af32' 'af33' 'af41' 'af42' 'af43' \
              'cs0' 'cs1' 'cs2' 'cs3' 'cs4' 'cs5' 'cs6' 'cs7' 'ef' \
              'lowdelay' 'throughput' 'reliability' && ret=0
          ;;
        (#i)(local|remote)forward=*)
          state=forward
          ;;
        (#i)dynamicforward=*)
          state=dynforward
          ;;
        (#i)kbdinteractivedevices=*)
          _values -s , 'keyboard-interactive authentication methods' \
              'bsdauth' 'pam' 'skey' && ret=0
          ;;
        (#i)(kexalgorithms|gssapikexalgorithms)=*)
          _wanted algorithms expl 'key exchange algorithm' _sequence compadd - \
              $(_call_program algorithms ssh -Q kex) && ret=0
          ;;
        (#i)localcommand=*)
          _description commands expl 'run command locally after connecting'
          _command_names && ret=0
          ;;
        (#i)loglevel=*)
          _values 'log level' QUIET FATAL ERROR INFO VERBOSE\
              DEBUG DEBUG1 DEBUG2 DEBUG3 && ret=0
          ;;
        (#i)macs=*)
          state=macs
          ;;
        (#i)numberofpasswordprompts=*)
          _message -e 'number of password prompts'
          ret=0
          ;;
        (#i)pkcs11provider=*)
          _description files expl 'PKCS#11 shared library'
          _files -g '*.(so|dylib)(|.<->)(-.)' "$expl[@]" && ret=0
          ;;
        (#i)port=*)
          _message -e 'port number on remote host'
          ret=0
          ;;
        (#i)preferredauthentications=*)
          _values -s , 'authentication method' gssapi-with-mic \
              hostbased publickey keyboard-interactive password && ret=0
          ;;
        (#i)protocol=*)
          _values -s , 'protocol version' \
              '1' \
              '2' && ret=0
          ;;
        (#i)(proxy|remote)command=*)
          _cmdstring && ret=0
          ;;
        (#i)rekeylimit=*)
          _message -e 'maximum number of bytes transmitted before renegotiating session key'
          ret=0
          ;;
        (#i)requesttty=*)
          _values 'request a pseudo-tty' \
              'no[never request a TTY]' \
              'yes[always request a TTY when stdin is a TTY]' \
              'force[always request a TTY]' \
              'auto[request a TTY when opening a login session]' && ret=0
          ;;
        (#i)revokedhostkeys=*)
          _description files expl 'revoked host keys file'
          _files "$expl[@]" && ret=0
          ;;
        (#i)sendenv=*)
          _wanted envs expl 'environment variable' _parameters -g 'scalar*export*' && ret=0
          ;;
        (#i)serveralivecountmax=*)
          _message -e 'number of alive messages without replies before disconnecting'
          ret=0
          ;;
        (#i)serveraliveinterval=*)
          _message -e 'timeout in seconds since last data was received to send alive message'
          ret=0
          ;;
        (#i)streamlocalbindmask=*)
          _message -e 'octal mask' && ret=0
          ;;
        (#i)stricthostkeychecking=*)
          _wanted values expl 'value' compadd yes no ask accept-new off && ret=0
          ;;
        (#i)syslogfacility=*)
          _wanted facilities expl 'facility' compadd -M 'm:{a-z}={A-Z}' DAEMON USER AUTH LOCAL{0,1,2,3,4,5,6,7} && ret=0
          ;;
        (#i)(verifyhostkeydns|updatehostkeys)=*)
          _wanted values expl 'truthish value' compadd yes no ask && ret=0
          ;;
        (#i)transport=*)
          _values 'transport protocol' TCP SCTP && ret=0
          ;;
        (#i)tunnel=*)
          _values 'request device forwarding' \
              'yes' \
              'point-to-point' \
              'ethernet' \
              'no' && ret=0
          ;;
        (#i)tunneldevice=*)
          _message -e 'local_tun[:remote_tun] (integer or "any")'
          ret=0
          ;;
        (#i)userknownhostsfile=*)
          _description files expl 'user file with known hosts'
          _files "$expl[@]" && ret=0
          ;;
        (#i)user=*)
          _wanted users expl 'user to log in as' _ssh_users && ret=0
          ;;
        (#i)xauthlocation=*)
          _description files expl 'xauth program'
          _files "$expl[@]" -g '*(-*)' && ret=0
          ;;
        esac
      else
        # old options are after the empty "\"-line
        _wanted values expl 'configure file option' \
            compadd -M 'm:{a-z}={A-Z}' -q -S '=' - \
                AddKeysToAgent \
                AddressFamily \
                BatchMode \
                BindAddress \
                CanonicalDomains \
                CanonicalizeFallbackLocal \
                CanonicalizeHostname \
                CanonicalizeMaxDots \
                CanonicalizePermittedCNAMEs \
                CASignatureAlgorithms \
                CertificateFile \
                ChallengeResponseAuthentication \
                CheckHostIP \
                Ciphers \
                ClearAllForwardings \
                Compression \
                ConnectionAttempts \
                ConnectTimeout \
                ControlMaster \
                ControlPath \
                ControlPersist \
                DynamicForward \
                EnableSSHKeysign \
                EscapeChar \
                ExitOnForwardFailure \
                FingerprintHash \
                ForwardAgent \
                ForwardX11 \
                ForwardX11Timeout \
                ForwardX11Trusted \
                GatewayPorts \
                GlobalKnownHostsFile \
                GSSAPIAuthentication \
                GSSAPIClientIdentity \
                GSSAPIDelegateCredentials \
                GSSAPIKeyExchange \
                GSSAPIRenewalForcesRekey \
                GSSAPIServerIdentity \
                GSSAPITrustDns \
                GSSAPIKexAlgorithms \
                HashKnownHosts \
                HostbasedAuthentication \
                HostbasedKeyTypes \
                HostKeyAlgorithms \
                HostKeyAlias \
                HostName \
                IdentitiesOnly \
                IdentityAgent \
                IdentityFile \
                IgnoreUnknown \
                IPQoS \
                KbdInteractiveAuthentication \
                KbdInteractiveDevices \
                KexAlgorithms \
                LocalCommand \
                LocalForward \
                LogLevel \
                MACs \
                NoHostAuthenticationForLocalhost \
                NumberOfPasswordPrompts \
                PasswordAuthentication \
                PermitLocalCommand \
                PKCS11Provider \
                Port \
                PreferredAuthentications \
                ProxyCommand \
                ProxyJump \
                ProxyUseFdpass \
                PubkeyAcceptedKeyTypes \
                PubkeyAuthentication \
                RekeyLimit \
                RemoteCommand \
                RemoteForward \
                RequestTTY \
                RevokedHostKeys \
                RhostsRSAAuthentication \
                RSAAuthentication \
                SendEnv \
                ServerAliveCountMax \
                ServerAliveInterval \
                StreamLocalBindMask \
                StreamLocalBindUnlink \
                StrictHostKeyChecking \
                SyslogFacility \
                TCPKeepAlive \
                Tunnel \
                TunnelDevice \
                UpdateHostKeys \
                UsePrivilegedPort \
                User \
                UserKnownHostsFile \
                VerifyHostKeyDNS \
                VisualHostKey \
                XAuthLocation \
                \
                AFSTokenPassing \
                FallBackToRsh \
                KeepAlive \
                KerberosAuthentication \
                KerberosTgtPassing \
                PreferredAuthentications \
                ProtocolKeepAlives \
                RhostsAuthentication \
                SetupTimeOut \
                SmartcardDevice \
                UseRsh \
                && ret=0
      fi
      ;;
    forward)
      local port=false host=false listen=false bind=false
      if compset -P 1 '*:'; then
        if [[ $IPREFIX != (*=|)<-65535>: ]]; then
          if compset -P 1 '*:'; then
            if compset -P '*:'; then
              port=true
            else
              host=true
            fi
          else
            listen=true
            ret=0
          fi
        else
          if compset -P '*:'; then
            port=true
          else
            host=true
          fi
        fi
      else
        listen=true
        bind=true
      fi
      $port && { _message -e port-numbers 'port number'; ret=0 }
      $listen && { _message -e port-numbers 'listen-port number'; ret=0 }
      $host && { _wanted hosts expl host _ssh_hosts -S: && ret=0 }
      $bind && { _wanted bind-addresses expl bind-address _bind_addresses -S: && ret=0 }
      return ret
      ;;
    dynforward)
      _message -e port-numbers 'listen-port number'
      if ! compset -P '*:'; then
        _wanted bind-addresses expl bind-address _bind_addresses -qS:
      fi
      return 0
      ;;
    hostport)
      if compset -P '*:'; then
        _message -e port-numbers 'port number'
        ret=0
      else
        _wanted hosts expl host _ssh_hosts -S: && ret=0
      fi
      return ret
      ;;
    macs)
      _wanted macs expl 'MAC algorithm' _sequence compadd - $(_call_program macs ssh -Q mac)
      return
      ;;
    ciphers)
      _wanted ciphers expl 'encryption cipher' _sequence compadd - $(_call_program ciphers ssh -Q cipher)
      return
      ;;
    command)
      if (( $+opt_args[-s] )); then
	_wanted subsystems expl subsystem compadd sftp
	return
      fi
      local -a _comp_priv_prefix
      shift 1 words
      (( CURRENT-- ))
      _normal
      return
      ;;
    userhost)
      if compset -P '*@'; then
        _wanted hosts expl 'remote host name' _ssh_hosts && ret=0
      elif compset -S '@*'; then
        _wanted users expl 'login name' _ssh_users -S '' && ret=0
      else
        if (( $+opt_args[-l] )); then
          tmp=()
        else
          tmp=( 'users:login name:_ssh_users -qS@' )
        fi
        _alternative \
            'hosts:remote host name:_ssh_hosts' \
            "$tmp[@]" && ret=0
      fi
      ;;
    file)
      if compset -P 1 '[^./][^/]#:'; then
        _remote_files -- ssh ${(kv)~opt_args[(I)-[FP1246]]/-P/-p} && ret=0
      elif compset -P 1 '*@'; then
        suf=( -S '' )
        compset -S ':*' || suf=( -r: -S: )
        _wanted hosts expl 'remote host name' _ssh_hosts $suf && ret=0
      else
        _alternative \
            'files:: _files' \
            'hosts:remote host name:_ssh_hosts -r: -S:' \
            'users:user:_ssh_users -qS@' && ret=0
      fi
      ;;
    rfile)
      if compset -P 1 '*:'; then
        _remote_files -- ssh && ret=0
      elif compset -P 1 '*@'; then
        _wanted hosts expl host _ssh_hosts -r: -S: && ret=0
      else
        _alternative \
            'hosts:remote host name:_ssh_hosts -r: -S:' \
            'users:user:_ssh_users -qS@' && ret=0
      fi
      ;;
    esac
  done

  return ret
}

_ssh_users () {
  _combination -s '[:@]' my-accounts users-hosts users "$@"
}

_ssh "$@"
