From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: srp_daemon :    targets      by default
Date: Tue, 9 May 2017 18:04:37 +0000
Message-ID: <1494353077.2518.12.camel@sandisk.com>
References: <1494349653.3752.4.camel@profitbricks.com>
         <021b0a17-0552-6ee4-ec19-0e86ead527ef@sandisk.com>
         <1050725096.6555338.1494351706650.JavaMail.zimbra@redhat.com>
         <20170509180159.GK10073@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170509180159.GK10073-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <D7A504964C1A6F41BC3C2705FA7BAA21-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-05-09 at 21:01 +0300, Leon Romanovsky wrote:
> On Tue, May 09, 2017 at 01:41:46PM -0400, Laurence Oberman wrote:
> >=20
> >=20
> > ----- Original Message -----
> > > From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > To: "Benjamin Drung" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma@vg=
er.kernel.org
> > > Sent: Tuesday, May 9, 2017 1:11:06 PM
> > > Subject: Re: srp_daemon : Disallow all targets if not explicitly allo=
wed by default
> > >=20
> > > On 05/09/17 10:07, Benjamin Drung wrote:
> > > > srptools 1.0.3-2 in Debian disallows all targets if not explicitly
> > > > allowed by default. Motivation (taken from debian/changelog):
> > > >=20
> > > > * Don't activate any targets per default. (Closes: #740945)
> > > >   This is more sensible than the previous default of bringing
> > > >   up all targets in the IB fabric upon boot. In a larger fabric
> > > >   with many storage targets available, most of the times only
> > > >   one or a few targets are wanted on a particular machine.
> > > >=20
> > > > Do you agree and could you change the default upstream? I prefer no=
t to
> > > > carry a different behavior in Debian alone.
> > >=20
> > > Hello Benjamin,
> > >=20
> > > What I expect is that users will hate this change. They will notice t=
hat
> > > after they have installed and enabled srp_daemon that no targets are
> > > discovered without having any clue why no automatic login to SRP targ=
ets
> > > occurs.
> >=20
> > Indeed, I agree with Bart here, this change will lead to a lot of confu=
sion about why users no longer see device discovery.
> > For me I would prefer its not changed.
>=20
> According to the Benjamin's description, this is already behavior of
> Debian and their derivatives. So this change won't change for these users
> anything. I think that the best solution will be to keep in sync distros
> and upstream. Or enable by default on all systems or disable by default
> on all systems.

Users of large setups know how to edit the srp_daemon configuration file bu=
t
most users of small setups don't know how to edit that configuration file. =
So
if consistency is required my advice is to change the behavior on Debian to
activating all targets by default.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
