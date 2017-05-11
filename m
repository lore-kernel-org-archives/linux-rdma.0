From: Roland Fehrenbacher <rf-PKu+Ek1N2UGzQB+pC5nmwQ@public.gmane.org>
Subject: Re: srp_daemon :    targets      by default
Date: Thu, 11 May 2017 10:50:13 +0200
Message-ID: <22804.9669.234394.488480@gargle.gargle.HOWL>
References: <1494349653.3752.4.camel@profitbricks.com>
        <021b0a17-0552-6ee4-ec19-0e86ead527ef@sandisk.com>
        <1050725096.6555338.1494351706650.JavaMail.zimbra@redhat.com>
        <20170509180159.GK10073@mtr-leonro.local>
        <1494423046.3739.8.camel@profitbricks.com>
        <22803.7541.113159.214164@gargle.gargle.HOWL>
        <1494432414.2578.9.camel@sandisk.com>
        <22803.16933.196383.482890@gargle.gargle.HOWL>
        <1494434801.2578.13.camel@sandisk.com>
        <22803.19010.749349.461444@gargle.gargle.HOWL>
        <1494436821.2578.15.camel@sandisk.com>
Reply-To: rf-PKu+Ek1N2UGzQB+pC5nmwQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494436821.2578.15.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>>>>> "B" == Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> writes:

Hi Bart,

    B> On Wed, 2017-05-10 at 19:13 +0200, Roland Fehrenbacher wrote:
    >> > > > > > "B" == Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
    >> > > > > > writes:
    >>
    B> On Wed, 2017-05-10 at 18:39 +0200, Roland Fehrenbacher wrote:
    >> >> The new package is very new, sits in debian unstable and most
    >> >> likely hasn't made it to Ubuntu 17.04.
    >>
    B> Hello Roland,
    >>
    B> Does that mean that most Debian users do not yet have that change
    B> in their /etc/srp_daemon.conf and when they upgrade and the
    B> packaged version of /etc/srp_daemon.conf gets installed that SRP
    B> login to remote systems will not occur anymore after a reboot?
    >>
    >> The pre/postinst files of the new package version are written,
    >> such that the new config file/behavior has to be explicitly
    >> enabled by the admin when the package is updated. Only new
    >> installations get the new config file automatically.
    >>
    B> Since you wrote in a previous message that such changes are
    B> mentioned in the NEWS file: how many people do you think read
    B> that file before or after installing an upgrade?
    >>
    >> The NEWS file is displayed automatically if the apt-listchanges
    >> package is installed.

    B> Hello Roland,

    B> Please revert this change such that the Debian srptools package
    B> is again in sync with the upstream srptools package and such that
    B> SRP users are saved a few hours of frustration by trying to
    B> figure out why SRP login doesn't work if they would install a
    B> version of srptools in which /etc/srp_daemon.conf disables login
    B> by default.

    B> In case you would not be aware of this: I am the maintainer of
    B> the upstream srptools package.

I didn't find any of the arguments presented against this change really
convincing. You make an assumption about SRP users whereas the motivation
of the change came from a bug report by a real user who was frustrated
with the previous config. Understandably in my opinion.

Anyway, since I'm not a DD, I can't revert it. Benjamin, since you're a
DD and if you also believe the change should be reverted, please feel free
to do so.

Roland

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
