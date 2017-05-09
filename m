From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: srp_daemon : =?utf-8?B?4oCLRGlzYWxs?=
 =?utf-8?B?b3cg4oCLYWxsIHRhcmdldHMg4oCLaWYg4oCLbm90IOKAi2V4cGxpY2l0bHkg?=
 =?utf-8?Q?=E2=80=8Ballowed?= by default
Date: Tue, 9 May 2017 21:01:59 +0300
Message-ID: <20170509180159.GK10073@mtr-leonro.local>
References: <1494349653.3752.4.camel@profitbricks.com>
 <021b0a17-0552-6ee4-ec19-0e86ead527ef@sandisk.com>
 <1050725096.6555338.1494351706650.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tvOENZuN7d6HfOWU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1050725096.6555338.1494351706650.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--tvOENZuN7d6HfOWU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 09, 2017 at 01:41:46PM -0400, Laurence Oberman wrote:
>
>
> ----- Original Message -----
> > From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > To: "Benjamin Drung" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma@vger=
=2Ekernel.org
> > Sent: Tuesday, May 9, 2017 1:11:06 PM
> > Subject: Re: srp_daemon : =E2=80=8BDisallow =E2=80=8Ball targets =E2=80=
=8Bif =E2=80=8Bnot =E2=80=8Bexplicitly =E2=80=8Ballowed by default
> >
> > On 05/09/17 10:07, Benjamin Drung wrote:
> > > srptools 1.0.3-2 in Debian disallows all targets if not explicitly
> > > allowed by default. Motivation (taken from debian/changelog):
> > >
> > > * Don't activate any targets per default. (Closes: #740945)
> > >   This is more sensible than the previous default of bringing
> > >   up all targets in the IB fabric upon boot. In a larger fabric
> > >   with many storage targets available, most of the times only
> > >   one or a few targets are wanted on a particular machine.
> > >
> > > Do you agree and could you change the default upstream? I prefer not =
to
> > > carry a different behavior in Debian alone.
> >
> > Hello Benjamin,
> >
> > What I expect is that users will hate this change. They will notice that
> > after they have installed and enabled srp_daemon that no targets are
> > discovered without having any clue why no automatic login to SRP targets
> > occurs.
> >
> > Bart.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
> Hello
>
> Indeed, I agree with Bart here, this change will lead to a lot of confusi=
on about why users no longer see device discovery.
> For me I would prefer its not changed.

According to the Benjamin's description, this is already behavior of
Debian and their derivatives. So this change won't change for these users
anything. I think that the best solution will be to keep in sync distros
and upstream. Or enable by default on all systems or disable by default
on all systems.

Thanks

>
> Regards
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--tvOENZuN7d6HfOWU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkSBBcACgkQ5GN7iDZy
WKfVXQ/9EmY/dPomLMxHzg0HGt8SPnWNHZRitXU4DgUPAn7o9Up4F1Okt/bKRo9z
/J6dANd1BHOjZR/1xF5bCskHGMj30Iw9mtU7lbpX8wH2cS3pMhVJ0k2bCUZ51DZ4
hklv5ICjmZ49/jNW4NUX3EcuQ01MsXYdVtdh6XNYnsFJghBU5L90nUWugJGeiMH5
FigcsML4hFoCetg0r7CsClAZRCrMUHqfxdD1KzkLcjr/9172ugxj/miUW8LXi9TV
87hDHr4C2Ja8sSfToeNXn8qN+sLmGrBkofqF6xiMGMQsE86iS5W+QWxwRUDb/d4s
UUUVbD+El4vj4calQ9LS0MO5BcwvUn/SM2B82Pwmj+7G2X7iYuoaz8xC2cRi0LUw
Km2T89poIZ4OlLoGngHIvdoJQx2of8JGffwg16kmWD0vy9mQXoyc7Bo9vQekZNHm
JOyZEPeBESXTs05dOLVoG8SdPAvnPsUSHPehDdAFaXVhnJwOVAVkrceuIKDyzLBO
U+5F7tVPEq8BR4QdSTz0VBSvIfi/dtwJYqG388GxyGZ1bsnmH3AJ2XKAg+ENryn8
ZErMc/hEnIATJh9/jbzcWdxudVhZTHnoZfwcguzJxhG1WxvcY2y29Ou2IOT1Atf5
WgATAUDMSyNy6c0TRdrNStXiWoCFs3xfgF+iE2QcrA82KQJMsnE=
=8JkS
-----END PGP SIGNATURE-----

--tvOENZuN7d6HfOWU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
