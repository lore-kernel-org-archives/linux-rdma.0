From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: srp_daemon : =?UTF-8?Q?=E2=80=8BDisallow?=
 =?UTF-8?Q?_=E2=80=8Ball?= targets =?UTF-8?Q?=E2=80=8Bif?=
 =?UTF-8?Q?_=E2=80=8Bnot?= =?UTF-8?Q?_=E2=80=8Bexplicitly?=
 =?UTF-8?Q?_=E2=80=8Ballowed?= by default
Date: Wed, 10 May 2017 15:30:46 +0200
Message-ID: <1494423046.3739.8.camel@profitbricks.com>
References: <1494349653.3752.4.camel@profitbricks.com>
         <021b0a17-0552-6ee4-ec19-0e86ead527ef@sandisk.com>
         <1050725096.6555338.1494351706650.JavaMail.zimbra@redhat.com>
         <20170509180159.GK10073@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-l40nWu+y803Uf9d5En7q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170509180159.GK10073-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Fehrenbacher <rf-PKu+Ek1N2UGzQB+pC5nmwQ@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-l40nWu+y803Uf9d5En7q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 09.05.2017, 21:01 +0300 schrieb Leon Romanovsky:
> On Tue, May 09, 2017 at 01:41:46PM -0400, Laurence Oberman wrote:
> >=20
> >=20
> > ----- Original Message -----
> > > From: "Bart Van Assche" <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > To: "Benjamin Drung" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdm
> > > a@vger.kernel.org
> > > Sent: Tuesday, May 9, 2017 1:11:06 PM
> > > Subject: Re: srp_daemon : Disallow all targets if not
> > > explicitly allowed by default
> > >=20
> > > On 05/09/17 10:07, Benjamin Drung wrote:
> > > > srptools 1.0.3-2 in Debian disallows all targets if not
> > > > explicitly
> > > > allowed by default. Motivation (taken from debian/changelog):
> > > >=20
> > > > * Don't activate any targets per default. (Closes: #740945)
> > > > =C2=A0 This is more sensible than the previous default of bringing
> > > > =C2=A0 up all targets in the IB fabric upon boot. In a larger fabri=
c
> > > > =C2=A0 with many storage targets available, most of the times only
> > > > =C2=A0 one or a few targets are wanted on a particular machine.
> > > >=20
> > > > Do you agree and could you change the default upstream? I
> > > > prefer not to
> > > > carry a different behavior in Debian alone.
> > >=20
> > > Hello Benjamin,
> > >=20
> > > What I expect is that users will hate this change. They will
> > > notice that
> > > after they have installed and enabled srp_daemon that no targets
> > > are
> > > discovered without having any clue why no automatic login to SRP
> > > targets
> > > occurs.
> > >=20
> > > Bart.
> > >=20
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-
> > > rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at=C2=A0=C2=A0http://vger.kernel.org/majordomo-in=
fo.htm
> > > l
> > >=20
> >=20
> > Hello
> >=20
> > Indeed, I agree with Bart here, this change will lead to a lot of
> > confusion about why users no longer see device discovery.
> > For me I would prefer its not changed.
>=20
> According to the Benjamin's description, this is already behavior of
> Debian and their derivatives. So this change won't change for these
> users
> anything. I think that the best solution will be to keep in sync
> distros
> and upstream. Or enable by default on all systems or disable by
> default
> on all systems.

This change was uploaded to Debian unstable two days ago. So it is a
recent change done by Roland Fehrenbacher (CCed) which still can be
reverted. I'm fine with any option as long as Debian and upstream are
in sync.

Bart's objection (that users of large setups know how to edit the
srp_daemon configuration file but most users of small setups don't know
how to edit that configuration file) seem valid to me. Roland, your
input please.

--=20
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web:=C2=A0https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss.

--=-l40nWu+y803Uf9d5En7q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJZExYGAAoJEN2M1aXejH56+EIP/01YPYtNzRyraM/uQ5b+xiE1
zBrAhd9auQFXxQyX3iiwXAGTNaP5ceALZcoKNlnAaVvxGuKEtN6dyvkMpuQY/vGW
OC9yvsMMQAOkYZFCvlVqacmS5tw4Mc3CpOZUOEbppC3rYSs8dUNuusNLNuUDjP7O
lfXk13IkxTgg2PBQIeuy6+z9+WWqTtwX3jYqCs0qlaovvVt3OVdC0WIYcC/UK9ws
5t1QkLmC4xSxjk4lvUhGXMZKRRvcQpb7Vwh/7En5is51rc4IHs1T8mXknO3V9Ma0
BFsl4R8NE6hLebRhjZRcS/R5Qo3iJyWanpmHEKCv2BI+WRw1cjY8y7lGsROjPg6x
/QTNmhBNAVyqENK2sKejV0YHiQn/otm8Va4qunkVscQg8mHUo5Np65Z/kE3R1K+1
CxHxYg9xkvGYIAoeyqK3jsE5QuBh3hQYPfYfdS7SMVqNWKgSq15Fj4shSx1v5rua
6BE+Sg5/fyVJak0ylgAb6Dll7MZoPoSj/AYxjQ2m2HwcNGpUE9iY/gY5Kg/2fpDZ
/LQIL3RRwPJl4qJjdyeIVGra7BnJReO6SluH8N7jG3jNzUV9apYkIVtDV0iQmelF
1tTbtoZwU99yRqa0NGBiC4ihZo8H2y/0tRN0uc1upk9H/qgNuhtECNhxsZNBcc4b
Lqt7XFQA3GPtl8nWDFO+
=nYug
-----END PGP SIGNATURE-----

--=-l40nWu+y803Uf9d5En7q--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
