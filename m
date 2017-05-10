From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: srp_daemon :    targets      by default
Date: Wed, 10 May 2017 16:06:59 +0000
Message-ID: <1494432414.2578.9.camel@sandisk.com>
References: <1494349653.3752.4.camel@profitbricks.com>
         <021b0a17-0552-6ee4-ec19-0e86ead527ef@sandisk.com>
         <1050725096.6555338.1494351706650.JavaMail.zimbra@redhat.com>
         <20170509180159.GK10073@mtr-leonro.local>
         <1494423046.3739.8.camel@profitbricks.com>
         <22803.7541.113159.214164@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <22803.7541.113159.214164-4mDQ13Tdud8Jw5R7aSpS0dP8p4LwMBBS@public.gmane.org>
Content-Language: en-US
Content-ID: <51E22C2E89769F448558ABDD6C1925A9-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "rf-PKu+Ek1N2UGzQB+pC5nmwQ@public.gmane.org" <rf-PKu+Ek1N2UGzQB+pC5nmwQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-05-10 at 16:02 +0200, Roland Fehrenbacher wrote:
> it's hard to judge what is the most wanted default setup. The reason why
> this was changed was the cited Debian bug report. I'm also a friend of
> well-defined configs, so I agree with that opinion. I believe,
> adding a '#' in front of a line of a config file shouldn't overburden an
> admin who deals with IB storage under Linux, if she/he prefers the most
> simple config. The change in Debian is also clearly communicated (NEWS
> file), so I don't really see a problem. Finally: There are many packages
> in Debian that have a different default config as compared to upstream.

Hello Roland,

Thanks for chiming in. Are you perhaps referring to
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D740945 ? If so, are you
aware that changing /etc/srp_daemon.conf was not necessary because of the
PORTS=3DNONE setting in /etc/default/srptools? BTW, I just reinstalled srpt=
ools
on an Ubuntu 17.04 system (apt-get remove -y srptools &&=A0dpkg --purge srp=
tools
&& rm -f /etc/default/srptools /etc/srp_daemon.conf &&=A0rm -rf
/var/cache/apt/archives && apt-get install -y srptools). From what I see in
the installed configuration files it looks like the change you mentioned ha=
s
either not been applied or it has been reverted?

# head -n 99 /etc/default/srptools /etc/srp_daemon.conf=A0=A0=A0
=3D=3D> /etc/default/srptools <=3D=3D
#How often should srpdeamon=A0=A0rescan the fabric (seconds)
RETRIES=3D60

#Where should srp-deamon log to
LOG=3D/var/log/srp_daemon.log

# What ports should srp-deamon be started on.
# Format is CA:port
# ALL or NONE will run on all ports on none
# respectively

PORTS=3DNONE
#PORTS=3DALL
#PORTS=3D"mthca0:1 mlx4_0:2"

=3D=3D> /etc/srp_daemon.conf <=3D=3D
## This is an example rules configuration file for srp_daemon.
##
#This is a comment
## disallow the following dgid
#d=A0=A0=A0=A0=A0=A0=A0dgid=3Dfe800000000000000002c90200402bd5
## allow target with the following ioc_guid
#a=A0=A0=A0=A0=A0=A0=A0ioc_guid=3D00a0b80200402bd7
## allow target with the following pkey
#a=A0=A0=A0=A0=A0=A0=A0pkey=3Dffff
## allow target with the following id_ext and ioc_guid
#a=A0=A0=A0=A0=A0=A0=A0id_ext=3D200500A0B81146A1,ioc_guid=3D00a0b80200402be=
f
## disallow all the rest
#d
##
## Here is another example:
##
## Allow all targets and set queue size to 128.
# a=A0=A0=A0=A0=A0=A0queue_size=3D128,max_cmd_per_lun=3D128

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
