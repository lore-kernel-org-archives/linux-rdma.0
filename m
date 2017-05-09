From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: srp_daemon :    targets      by default
Date: Tue, 9 May 2017 21:12:03 +0300
Message-ID: <20170509181203.GL10073@mtr-leonro.local>
References: <1494349653.3752.4.camel@profitbricks.com>
 <021b0a17-0552-6ee4-ec19-0e86ead527ef@sandisk.com>
 <1050725096.6555338.1494351706650.JavaMail.zimbra@redhat.com>
 <20170509180159.GK10073@mtr-leonro.local>
 <1494353077.2518.12.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vtJ+CqYNzKB4ukR4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494353077.2518.12.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--vtJ+CqYNzKB4ukR4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 09, 2017 at 06:04:37PM +0000, Bart Van Assche wrote:
> On Tue, 2017-05-09 at 21:01 +0300, Leon Romanovsky wrote:
> > On Tue, May 09, 2017 at 01:41:46PM -0400, Laurence Oberman wrote:
> > >
> > >
> > > ----- Original Message -----
> > > > From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > > To: "Benjamin Drung" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > Sent: Tuesday, May 9, 2017 1:11:06 PM
> > > > Subject: Re: srp_daemon : Disallow all targets if not explicitly allowed by default
> > > >
> > > > On 05/09/17 10:07, Benjamin Drung wrote:
> > > > > srptools 1.0.3-2 in Debian disallows all targets if not explicitly
> > > > > allowed by default. Motivation (taken from debian/changelog):
> > > > >
> > > > > * Don't activate any targets per default. (Closes: #740945)
> > > > >   This is more sensible than the previous default of bringing
> > > > >   up all targets in the IB fabric upon boot. In a larger fabric
> > > > >   with many storage targets available, most of the times only
> > > > >   one or a few targets are wanted on a particular machine.
> > > > >
> > > > > Do you agree and could you change the default upstream? I prefer not to
> > > > > carry a different behavior in Debian alone.
> > > >
> > > > Hello Benjamin,
> > > >
> > > > What I expect is that users will hate this change. They will notice that
> > > > after they have installed and enabled srp_daemon that no targets are
> > > > discovered without having any clue why no automatic login to SRP targets
> > > > occurs.
> > >
> > > Indeed, I agree with Bart here, this change will lead to a lot of confusion about why users no longer see device discovery.
> > > For me I would prefer its not changed.
> >
> > According to the Benjamin's description, this is already behavior of
> > Debian and their derivatives. So this change won't change for these users
> > anything. I think that the best solution will be to keep in sync distros
> > and upstream. Or enable by default on all systems or disable by default
> > on all systems.
>
> Users of large setups know how to edit the srp_daemon configuration file but
> most users of small setups don't know how to edit that configuration file. So
> if consistency is required my advice is to change the behavior on Debian to
> activating all targets by default.

I'm fine with any option as long as Debian and upstream are in sync.

Thanks

>
> Bart.--
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--vtJ+CqYNzKB4ukR4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkSBnMACgkQ5GN7iDZy
WKeWGA/5Aeqwjn1qlsWp1b55wu0yeOB+uLmDUQamZJfKQD51GSZkv1SFLqovhw7f
pNP1GyTnUsTQJktWcJbo6Lf9S7Larhyd38QofkSBj7pXrfXLMlcWsCM/fAxJ9Kcz
N2SJ/W+vXDP02fiyJ3w17CWIf7rdf/6UzzQel99y/8Arx5DUbYCl3/lhUfuRQefl
QyNyvIYLb+bQ5iynTaptd6JUCOAICLoQPiSMmz6fOsskfeELUrJo2/hnFn9cjhPI
BtTnRUWIoZcvYouHDF8c0sbtqpkUFZ0x+SEVRht2ywo4R6sBYqlFGLrp+ESxv37A
9oIYe6BDyiXt7l9+SLcrVQSkUVlLo3M3TILrcGk3J8/big7kpoEpAOq26Uxt7mrB
coBZWsJKi0z4IF24+krzYSJraleDFSmsysswWHxdUfKBpKbghpwQNp+eI5lTb4E/
gH222WV3asUwtWhz1s19NoisniAyF+MXvL+6zBbH7IPbztviq8oRLJbisGd/j//R
YXFs9JmPKN4cv+uzlJHFz281rpHcnClEfnE7KmBRXzRtlmAmjckIwzUyzTWbBi15
dexvJ8IHhDXiiT3GCiBoccYFscTFo4s6cWu5oEbhnAjohT4EcWnhRrTlSxosuFad
uHDlK1R3A3M2a8XSuhQ0ERpz7tdzs/znkL4/2nSe1ifAKr5IHJA=
=DyPG
-----END PGP SIGNATURE-----

--vtJ+CqYNzKB4ukR4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
