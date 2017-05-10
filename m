From: Roland Fehrenbacher <rf-PKu+Ek1N2UGzQB+pC5nmwQ@public.gmane.org>
Subject: Re: srp_daemon :    targets      by default
Date: Wed, 10 May 2017 18:39:01 +0200
Message-ID: <22803.16933.196383.482890@gargle.gargle.HOWL>
References: <1494349653.3752.4.camel@profitbricks.com>
        <021b0a17-0552-6ee4-ec19-0e86ead527ef@sandisk.com>
        <1050725096.6555338.1494351706650.JavaMail.zimbra@redhat.com>
        <20170509180159.GK10073@mtr-leonro.local>
        <1494423046.3739.8.camel@profitbricks.com>
        <22803.7541.113159.214164@gargle.gargle.HOWL>
        <1494432414.2578.9.camel@sandisk.com>
Reply-To: rf-PKu+Ek1N2UGzQB+pC5nmwQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494432414.2578.9.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>>>>> "B" == Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> writes:

Hi Bart,

    B> On Wed, 2017-05-10 at 16:02 +0200, Roland Fehrenbacher wrote:
    >> it's hard to judge what is the most wanted default setup. The
    >> reason why this was changed was the cited Debian bug report. I'm
    >> also a friend of well-defined configs, so I agree with that
    >> opinion. I believe, adding a '#' in front of a line of a config
    >> file shouldn't overburden an admin who deals with IB storage
    >> under Linux, if she/he prefers the most simple config. The change
    >> in Debian is also clearly communicated (NEWS file), so I don't
    >> really see a problem. Finally: There are many packages in Debian
    >> that have a different default config as compared to upstream.

    B> Hello Roland,

    B> Thanks for chiming in. Are you perhaps referring to
    B> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=740945 ?

yes.

    B> If so, are you aware that changing /etc/srp_daemon.conf was not
    B> necessary because of the PORTS=NONE setting in
    B> /etc/default/srptools?

That setting has a different effect: srp_daemon won't even be started if
PORTS=NONE. The PORTS variable just controls for which ports of the HCA(s)
a daemon is started. On the other hand, in the config file you have
additional control over the targets that will be added to the system.

    B> BTW, I just reinstalled srptools on an Ubuntu 17.04 system
    B> (apt-get remove -y srptools && dpkg --purge srptools && rm -f
    B> /etc/default/srptools /etc/srp_daemon.conf && rm -rf
    B> /var/cache/apt/archives && apt-get install -y srptools). From
    B> what I see in the installed configuration files it looks like the
    B> change you mentioned has either not been applied or it has been
    B> reverted?

The new package is very new, sits in debian unstable and most likely
hasn't made it to Ubuntu 17.04.

Cheers,

Roland

    B> # head -n 99 /etc/default/srptools /etc/srp_daemon.conf   
    B> ==> /etc/default/srptools <==
    B> #How often should srpdeamon  rescan the fabric (seconds)
    B> RETRIES=60

    B> #Where should srp-deamon log to
    B> LOG=/var/log/srp_daemon.log

    B> # What ports should srp-deamon be started on.  Format is CA:port
    B> # ALL or NONE will run on all ports on none respectively

    B> PORTS=NONE
    B> #PORTS=ALL PORTS="mthca0:1 mlx4_0:2"

    B> ==> /etc/srp_daemon.conf <==
    B> ## This is an example rules configuration file for srp_daemon.
    B> ##
    B> #This is a comment
    B> ## disallow the following dgid
    B> #d       dgid=fe800000000000000002c90200402bd5
    B> ## allow target with the following ioc_guid
    B> #a       ioc_guid=00a0b80200402bd7
    B> ## allow target with the following pkey
    B> #a       pkey=ffff
    B> ## allow target with the following id_ext and ioc_guid
    B> #a       id_ext=200500A0B81146A1,ioc_guid=00a0b80200402bef
    B> ## disallow all the rest
    B> #d
    B> ##
    B> ## Here is another example:
    B> ##
    B> ## Allow all targets and set queue size to 128.
    B> # a      queue_size=128,max_cmd_per_lun=128

    B> Thanks,

    B> Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
