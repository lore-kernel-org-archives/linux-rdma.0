From: Roland Fehrenbacher <rf-PKu+Ek1N2UGzQB+pC5nmwQ@public.gmane.org>
Subject: Re: srp_daemon : =?utf-8?Q?=E2=80=8BDisallow_=E2=80=8Ball?= targets =?utf-8?Q?=E2=80=8Bif_=E2=80=8Bnot_=E2=80=8Bexplicitly_=E2=80=8Ballowed?= by default
Date: Wed, 10 May 2017 16:02:29 +0200
Message-ID: <22803.7541.113159.214164@gargle.gargle.HOWL>
References: <1494349653.3752.4.camel@profitbricks.com>
        <021b0a17-0552-6ee4-ec19-0e86ead527ef@sandisk.com>
        <1050725096.6555338.1494351706650.JavaMail.zimbra@redhat.com>
        <20170509180159.GK10073@mtr-leonro.local>
        <1494423046.3739.8.camel@profitbricks.com>
Reply-To: rf-PKu+Ek1N2UGzQB+pC5nmwQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494423046.3739.8.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>>>>> "BD" == Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> writes:

Hi all,

    BD> Am Dienstag, den 09.05.2017, 21:01 +0300 schrieb Leon
    BD> Romanovsky:
    >> On Tue, May 09, 2017 at 01:41:46PM -0400, Laurence Oberman wrote:
    >> >
    >> >
    >> > ----- Original Message -----
    >> > > From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> To:
    >> > > "Benjamin Drung" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdm
    >> > > a@vger.kernel.org Sent: Tuesday, May 9, 2017 1:11:06 PM
    >> > > Subject: Re: srp_daemon : Disallow all targets if not
    >> > > explicitly allowed by default
    >> > >
    >> > > On 05/09/17 10:07, Benjamin Drung wrote:
    >> > > > srptools 1.0.3-2 in Debian disallows all targets if not
    >> > > > explicitly allowed by default. Motivation (taken from
    >> > > > debian/changelog):
    >> > > >
    >> > > > * Don't activate any targets per default. (Closes: #740945)
    >> > > >   This is more sensible than the previous default of
    >> > > > bringing   up all targets in the IB fabric upon boot. In a
    >> > > > larger fabric   with many storage targets available, most
    >> > > > of the times only   one or a few targets are wanted on a
    >> > > > particular machine.
    >> > > >
    >> > > > Do you agree and could you change the default upstream? I
    >> > > > prefer not to carry a different behavior in Debian alone.
    >> > >
    >> > > Hello Benjamin,
    >> > >
    >> > > What I expect is that users will hate this change. They will
    >> > > notice that after they have installed and enabled srp_daemon
    >> > > that no targets are discovered without having any clue why no
    >> > > automatic login to SRP targets occurs.
    >> > >
    >> > > Bart.
    >> > >
    >> > > -- To unsubscribe from this list: send the line "unsubscribe
    >> > > linux- rdma" in the body of a message to
    >> > > majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info
    >> > > at  http://vger.kernel.org/majordomo-info.htm l
    >> > >
    >> >
    >> > Hello
    >> >
    >> > Indeed, I agree with Bart here, this change will lead to a lot
    >> > of confusion about why users no longer see device discovery.
    >> > For me I would prefer its not changed.
    >>
    >> According to the Benjamin's description, this is already behavior
    >> of Debian and their derivatives. So this change won't change for
    >> these users anything. I think that the best solution will be to
    >> keep in sync distros and upstream. Or enable by default on all
    >> systems or disable by default on all systems.

    BD> This change was uploaded to Debian unstable two days ago. So it
    BD> is a recent change done by Roland Fehrenbacher (CCed) which
    BD> still can be reverted. I'm fine with any option as long as
    BD> Debian and upstream are in sync.

    BD> Bart's objection (that users of large setups know how to edit
    BD> the srp_daemon configuration file but most users of small setups
    BD> don't know how to edit that configuration file) seem valid to
    BD> me. Roland, your input please.

it's hard to judge what is the most wanted default setup. The reason why
this was changed was the cited Debian bug report. I'm also a friend of
well-defined configs, so I agree with that opinion. I believe,
adding a '#' in front of a line of a config file shouldn't overburden an
admin who deals with IB storage under Linux, if she/he prefers the most
simple config. The change in Debian is also clearly communicated (NEWS
file), so I don't really see a problem. Finally: There are many packages
in Debian that have a different default config as compared to upstream.

Cheers,

Roland--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
