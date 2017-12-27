From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH rdma-core] Support writing man pages in MarkDown
Date: Wed, 27 Dec 2017 14:56:52 +0100
Message-ID: <1514383012.4412.10.camel@profitbricks.com>
References: <20171212225936.GA29558@ziepe.ca>
         <455f0faf-516b-fa8d-c0d2-d2cee9194e5b@dev.mellanox.co.il>
         <1514368433.4412.2.camel@profitbricks.com>
         <20171227111348.GB3494@mtr-leonro.local>
         <1514374021.4412.9.camel@profitbricks.com>
         <20171227122056.GD3494@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-m3zv0nWuCrlIBoQIe/zH"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227122056.GD3494-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-m3zv0nWuCrlIBoQIe/zH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch, den 27.12.2017, 14:20 +0200 schrieb Leon Romanovsky:
> On Wed, Dec 27, 2017 at 12:27:01PM +0100, Benjamin Drung wrote:
> > Am Mittwoch, den 27.12.2017, 13:13 +0200 schrieb Leon Romanovsky:
> > > On Wed, Dec 27, 2017 at 10:53:53AM +0100, Benjamin Drung wrote:
> > > > > > Am Sonntag, den 24.12.2017, 14:03 +0200 schrieb Yishai
> > > > > > Hadas:
> > > > >=20
> > > > > On 12/13/2017 12:59 AM, Jason Gunthorpe wrote:
> > > > > > > pandoc is fairly widely available in the distros with the
> > > > > > > notable
> > > > > >=20
> > > > > > problem that centos 6 and 7 can only get it from EPEL.
> > > > > >=20
> > > > >=20
> > > > > There might be even a worse case scenario where pandoc may
> > > > > not
> > > > > exist
> > > > > as
> > > > > a package to be installed, for example how about SLES OS ?
> > > >=20
> > > > The release tarball could contain pre-built man page. So in
> > > > case
> > > > the OS
> > > > does provide pandoc to regenerate the man pages, the pre-built
> > > > can
> > > > be
> > > > used.
> > >=20
> > > Why should OS be dependent on pandoc? IMHO all releases should
> > > contain
> > > pre-built man pages and they should be used without need to
> > > regenerate
> > > them at all.
> >=20
> > Debian's rule is to build everything from source where the source
> > is in
> > the preferred format for modification. So we will drop the pre-
> > build
> > man pages and build them from source - even if that would not be
> > needed. This is useful in case we have to modify it (e.g. fix
> > typos).
>=20
> Thanks for the explanation.

FYI: Debian has a wiki page dedicated for upstream developers:
https://wiki.debian.org/UpstreamGuide

--=20
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
URL: https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg
--=-m3zv0nWuCrlIBoQIe/zH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJaQ6akAAoJEN2M1aXejH56cMAQAIHXUFGknvCrFM8OgtxeyJQT
OBfXqJBUj5WadVQeAfTcO3GqQISDfEpsMg5J2Xip8NPgx2ov5Q3n2bAPnzFrCWw1
sxojdVHUO1nLgw89L7rSdmSfJZzYQ00IOjeJw6as31euA7p+i7j299kpBYp9BY0D
iZVut15sVhutueqYTBzQ8CceAZG/JeZaIWARqVWNFXQo8Pd8Z9z3mGhYogn/q+TF
Wpp2+zHSLjjyf2OVydw9J2Iy/e8sK1SmhymXfIWgeCEs5ezAQYEMNFP+iFt2r0xB
u9sbzDV/XmNYDyYlzKTdqM8qxKJa6u1TFyVlIJKj6ICb2hKn+ZsCfwqfMOgNtOWy
fqSlOda5nQtlBVSiT2rBeYi9TauimCSQvH71mmh0jgiihDxPxFPi/nEcpp7HI06n
lBdbQKqaB8hPM06Bq1ROoRy1BERaIXQgiI2eGaP8rAtSDOTSQ9TLZT4k5YXQDMvg
otii5A+KXc6DxdY5TG83zAB2vRLQFXoSSQxXxsgG/UcDHu0ULDAaWYFMlJzAWfVK
WxnTZDLjN6r3gEZyIl/dOapTkGqk4hNTadFEVaWxyDdVlJnRD+Zc1ukqRYcRQKp2
eX1Znwfb8IjBP5SWX/p90rZkcmdYrtrLkqfK6y7wYz9qEyJB6qxJvGOkvl8y/XQl
Ap2eM4f8xNjh0UFBj4kG
=2Tsz
-----END PGP SIGNATURE-----

--=-m3zv0nWuCrlIBoQIe/zH--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
