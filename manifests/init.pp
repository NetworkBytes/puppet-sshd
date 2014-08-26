class sshd {
   
   $sshd_config = "/etc/ssh/sshd_config"

   package { 'openssh-server':
       ensure => latest,
   }

   service { 'sshd':
       subscribe => File["${sshd_config}"],
       ensure  => running,
       require  => Package['openssh-server'],
   }

   linux_base::sshd::config { "${sshd_config}":
      allowtcpforwarding => 'yes',
      allowgroups   => 'sysadmin',
   }

   firewall { '100 allow SSH access':
      port   => [22],
      proto  => tcp,
      action => accept,
   }

}

define linux_base::sshd::config (
    $port = "22",
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
}



