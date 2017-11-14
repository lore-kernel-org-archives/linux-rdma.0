From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: rdma-core_15-1_amd64.changes ACCEPTED into unstable
Date: Tue, 14 Nov 2017 11:51:01 +0100
Message-ID: <1510656661.4026.23.camel@profitbricks.com>
References: <E1eENiD-000EaM-BG@fasolo.debian.org>
         <20171114023711.GA22633@ziepe.ca> <20171114072056.GP18825@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-M5/AQFPyWEiWLzH3Hg1m"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114072056.GP18825-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-M5/AQFPyWEiWLzH3Hg1m
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Dienstag, den 14.11.2017, 09:20 +0200 schrieb Leon Romanovsky:
> On Mon, Nov 13, 2017 at 07:37:11PM -0700, Jason Gunthorpe wrote:
> > Great news! Good job!
>=20
> Thanks a lot.

Yeah, finally \o/

Now it is also synced to Ubuntu 18.04 (bionic):
https://launchpad.net/ubuntu/+source/rdma-core

Some builds fail. Reasons:

* Non-Linux architectures: One package is marked as architechture "any"
instead of "linux-any". Thus the builds are tried on non-Linux archs.
Expect a patch to come.

* Architecture NOT able to do coherent DMA: Some providers will be
disabled and the install target fail to install the missing providers.

* valgrind is not available on some archs: Can we drop valgrind for
those archs?

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
--=-M5/AQFPyWEiWLzH3Hg1m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJaCsqVAAoJEN2M1aXejH56R9QP/ih+Hyel8lRURxV3iE5Y+hUk
ZStsyXkBx3gL6mNzn402I034Rn1JmM5WYRcyUQoT2hL1VfdIHrK9T0rD/n0pXsjO
22PBsRryuxRc0+qcEqYBTJAbrOrHdxRFttsdlbNBKe9BZIlKcaA5yH+kVSQ5JhHq
ir2hysdWknosJBj6y3irg5iYcDAOkeZpuEGq3dUwFGCmQoH9Mr8Ylhzxp4lKh39H
Gfy6BO0jSdPFDUNo7OjvliPluEVHvgSxAYMOZhn/U+lsAXULdMa/kYNOapclymMR
df/9KS2frU/SNKB12tflnjA9f6BWz3EKeIwegsRh5LdAj3vJMtTGFlpdInYNvyDB
TQ31pRGBxWKupco2s7CciGg3i6bb3SSoLDe7xu/xQz13IipU5Iw8asBxSq0eSUQv
YwCK3aCxCe28ndxuF6vLx7J5AqRR685kCgDIkYte2wUhvMU8F69g9y3IzTv0AqKD
TgeyJcuKIRjHZ08DpY6RzndBSuQ29xYQYUN/saZnl3Ju1WuJm9qjYBJGGxePbYnS
Gcj/n4EylPf+zT5YsAHjWzyNTCLumaPL9l59S8t8J9No0lOiYWBG5siwKg4veWxr
UzF6IwLYX4CWWObhZ+7mDxs17dJSQUtssBvL1W766LPjMuqfrrw/8RU3rpmoWKQG
xjLo6xAzF9fN/BHqplmH
=igQA
-----END PGP SIGNATURE-----

--=-M5/AQFPyWEiWLzH3Hg1m--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
