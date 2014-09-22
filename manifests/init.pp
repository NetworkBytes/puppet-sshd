class sshd 
(
   $allowgroups = '',
   $enablefirewall = true,
)
{
   
   $sshd_config = "/etc/ssh/sshd_config"

   package { 'openssh-server':
       ensure => latest,
   }

   service { 'sshd':
       subscribe => File["${sshd_config}"],
       ensure  => running,
       require  => Package['openssh-server'],
   }

   sshd::config { "${sshd_config}":
      allowtcpforwarding => 'yes',
      allowgroups   => "${allowgroups}",
   }

}

define sshd::config (
    $port = "22",
    $enablefirewall = true,
    $loglevel = "info",
    $permitrootlogin = "no",
    $allowtcpforwarding = "no",
    $allowgroups = "") 
    {
      file { "${name}":
        owner   => root,
        group   => root,
        mode    => 600,
        content => template("sshd/sshd_config.erb"),
        notify  => Service['sshd']
      }
      
      if $enablefirewall {
         include 'sshd::firewall'
      } 
}

class sshd::firewall {
   
   firewall { '100 allow SSH access':
      port   => [22],
      proto  => tcp,
      action => accept,
   }
   
}



