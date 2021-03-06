class openssh::params {

  $sshd_config='/etc/ssh/sshd_config'
  $ssh_config='/etc/ssh/ssh_config'
  $sshd_config_template='sshd_config.erb'

  $clientaliveinterval_default='300'
  $clientalivecountmax_default='5'

  if(hiera('eypopensshserver::hardening', false))
  {
    $sshd_ciphers_default = [ 'aes256-ctr', 'aes192-ctr', 'aes128-ctr' ]
  }
  else
  {
    $sshd_ciphers_default = undef
  }

    # CentOS 6
    #  KexAlgorithms
    #          Specifies the available KEX (Key Exchange) algorithms.  Multiple algorithms must be comma-separated.  The default is
    #          diffie-hellman-group-exchange-sha256
    #          diffie-hellman-group-exchange-sha1
    #          diffie-hellman-group14-sha1
    #          diffie-hellman-group1-sha1


    # Ubuntu 14.04
    #  KexAlgorithms
    #          Specifies the available KEX (Key Exchange) algorithms.  Multiple algorithms must be comma-separated.  The default is

    #                curve25519-sha256@libssh.org
    #                ecdh-sha2-nistp256
    #                ecdh-sha2-nistp384
    #                ecdh-sha2-nistp521
    #                diffie-hellman-group-exchange-sha256
    #                diffie-hellman-group-exchange-sha1
    #                diffie-hellman-group14-sha1
    #                diffie-hellman-group1-sha1

  if(hiera('eypopensshserver::hardening', false))
  {
    $sshd_kex_algorithms = [ 'diffie-hellman-group-exchange-sha256' ]
  }
  else
  {
    $sshd_kex_algorithms = []
  }

  case $::osfamily
  {
    'redhat':
    {
      $package_sshd='openssh-server'

      $sftp_server='/usr/libexec/openssh/sftp-server'
      $package_sftp=undef

      $sshd_service='sshd'

      $package_ssh_client='openssh-clients'

      $syslogfacility_default='AUTHPRIV'

      case $::operatingsystem
      {
        #
        # RHEL
        #
        'RedHat':
        {
          case $::operatingsystemrelease
          {
            /^[56].*$/:
            {
              # disponibles:
              #
              # RHEL 6
              # hmac-md5,
              # hmac-sha1,
              # umac-64@openssh.com,
              # hmac-ripemd160,
              # hmac-sha1-96,
              # hmac-md5-96,
              # * hmac-sha2-256,
              # * hmac-sha2-512,
              # hmac-ripemd160@openssh.com
              $sshd_authorized_keys_command_user_default=undef
              $sshd_authorized_keys_command_user_directive='AuthorizedKeysCommandRunAs'

              if(hiera('eypopensshserver::hardening', false))
              {
                $sshd_macs_default = [
                  'hmac-sha2-256',
                  'hmac-sha2-512',
                ]
              }
              else
              {
                $sshd_macs_default = undef
              }

              $sshd_global_config = undef
              $supports_first_ssh_protocol=true
            }
            /^7.*$/:
            {
              # RHEL 7

              # hmac-md5-etm@openssh.com,
              # hmac-sha1-etm@openssh.com,
              # umac-64-etm@openssh.com,
              # * umac-128-etm@openssh.com,
              # * hmac-sha2-256-etm@openssh.com,
              # * hmac-sha2-512-etm@openssh.com,
              # hmac-ripemd160-etm@openssh.com,
              # hmac-sha1-96-etm@openssh.com,
              # hmac-md5-96-etm@openssh.com,
              # hmac-md5,
              # hmac-sha1,
              # umac-64@openssh.com,
              # * umac-128@openssh.com,
              # * hmac-sha2-256,
              # * hmac-sha2-512,
              # hmac-ripemd160,
              # hmac-sha1-96,
              # hmac-md5-96
              $sshd_authorized_keys_command_user_default='root'
              $sshd_authorized_keys_command_user_directive='AuthorizedKeysCommandUser'

              if(hiera('eypopensshserver::hardening', false))
              {
                $sshd_macs_default = [
                  'hmac-sha2-512-etm@openssh.com',
                  'hmac-sha2-256-etm@openssh.com',
                  'umac-128-etm@openssh.com',
                  'hmac-sha2-512',
                  'hmac-sha2-256',
                  'umac-128@openssh.com',
                ]
              }
              else
              {
                $sshd_macs_default = undef
              }

              $sshd_global_config = undef
              $supports_first_ssh_protocol=true
            }
            /^8.*$/:
            {
              $sshd_authorized_keys_command_user_default='root'
              $sshd_authorized_keys_command_user_directive='AuthorizedKeysCommandUser'

              # CIS does not define specific macs to be set
              $sshd_macs_default = undef

              $sshd_global_config = '/etc/sysconfig/sshd'
              $supports_first_ssh_protocol=false
            }
            default: { fail("Unsupported RHEL version! - ${::operatingsystemrelease}")  }
          }
        }
        #
        # CentOS base OS
        #
        default:
        {
          case $::operatingsystemrelease
          {
            /^[56].*$/:
            {
              # disponibles:
              #
              # CentOS 6
              # hmac-md5,
              # hmac-sha1,
              # umac-64@openssh.com,
              # hmac-ripemd160,
              # hmac-sha1-96,
              # hmac-md5-96

              # hmac-sha2-256,hmac-sha2-512,hmac-sha1

              $sshd_authorized_keys_command_user_default=undef
              $sshd_authorized_keys_command_user_directive='AuthorizedKeysCommandRunAs'

              if(hiera('eypopensshserver::hardening', false))
              {
                $sshd_macs_default = [
                  'hmac-sha1',
                ]
              }
              else
              {
                $sshd_macs_default = undef
              }

              $sshd_global_config = undef
              $supports_first_ssh_protocol=true
            }
            /^7.*$/:
            {
              # CentOS

              # hmac-md5-etm@openssh.com,hmac-sha1-etm@openssh.com,
              # umac-64-etm@openssh.com,umac-128-etm@openssh.com,
              # hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,
              # hmac-ripemd160-etm@openssh.com,hmac-sha1-96-etm@openssh.com,
              # hmac-md5-96-etm@openssh.com,
              # hmac-md5,hmac-sha1,umac-64@openssh.com,umac-128@openssh.com,
              # hmac-sha2-256,hmac-sha2-512,hmac-ripemd160,
              # hmac-sha1-96,hmac-md5-96

              $sshd_authorized_keys_command_user_default='root'
              $sshd_authorized_keys_command_user_directive='AuthorizedKeysCommandUser'

              if(hiera('eypopensshserver::hardening', false))
              {
                $sshd_macs_default = [
                  'hmac-sha2-512-etm@openssh.com',
                  'hmac-sha2-256-etm@openssh.com',
                  'umac-128-etm@openssh.com',
                  'hmac-sha2-512',
                  'hmac-sha2-256',
                  'umac-128@openssh.com',
                ]
              }
              else
              {
                $sshd_macs_default = undef
              }

              $sshd_global_config = undef
              $supports_first_ssh_protocol=true
            }
            /^8.*$/:
            {
              $sshd_authorized_keys_command_user_default='root'
              $sshd_authorized_keys_command_user_directive='AuthorizedKeysCommandUser'

              # CIS does not define specific macs to be set
              $sshd_macs_default = undef

              $sshd_global_config = '/etc/sysconfig/sshd'
              $supports_first_ssh_protocol=false
            }
            default: { fail("Unsupported CentOS version! - ${::operatingsystemrelease}")  }
          }
        }
      }
    }
    'Debian':
    {
      $package_sshd='openssh-server'

      $sftp_server='/usr/lib/openssh/sftp-server'
      $package_sftp='openssh-sftp-server'

      $sshd_service='ssh'

      $package_ssh_client='openssh-client'

      $syslogfacility_default='AUTH'

      $sshd_global_config = undef

      case $::operatingsystem
      {
        'Ubuntu':
        {
          $sshd_authorized_keys_command_user_default='root'
          $sshd_authorized_keys_command_user_directive='AuthorizedKeysCommandUser'

          if(hiera('eypopensshserver::hardening', false))
          {
            $sshd_macs_default = [
              'hmac-sha2-512-etm@openssh.com',
              'hmac-sha2-256-etm@openssh.com',
              'umac-128-etm@openssh.com',
              'hmac-sha2-512',
              'hmac-sha2-256',
              'umac-128@openssh.com',
            ]
          }
          else
          {
            $sshd_macs_default = undef
          }

          case $::operatingsystemrelease
          {
            /^1[46].*$/:
            {
              $supports_first_ssh_protocol=true
            }
            /^18.*$/:
            {
              $supports_first_ssh_protocol=false
            }
            /^20.*$/:
            {
              $supports_first_ssh_protocol=false
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    'Suse':
    {
      $package_sshd='openssh'
      $supports_first_ssh_protocol=true

      $sshd_global_config = undef

      case $::operatingsystem
      {
        'SLES':
        {
          case $::operatingsystemrelease
          {
            /^1[12].[34]$/:
            {
              $sftp_server='/usr/lib/ssh/sftp-server'
              $package_sftp=undef

              $sshd_service='sshd'

              $package_ssh_client=undef

              $syslogfacility_default='AUTH'

              if(hiera('eypopensshserver::hardening', false))
              {
                $sshd_macs_default = undef
              }
              else
              {
                $sshd_macs_default = undef
              }
            }
            default: { fail("Unsupported operating system ${::operatingsystem} ${::operatingsystemrelease}") }
          }
        }
        default: { fail("Unsupported operating system ${::operatingsystem}") }
      }
    }

    default: { fail('Unsupported OS!')  }
  }
}
