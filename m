From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 27 May 2016 07:51:57 +0300
Message-ID: <20160527045157.GW25500@leon.nu>
References: <166c87fa-09ef-f170-7351-d18062bc25cf@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yPlaimQd/TpiYx8R"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <166c87fa-09ef-f170-7351-d18062bc25cf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--yPlaimQd/TpiYx8R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 26, 2016 at 06:34:28PM -0400, Doug Ledford wrote:
> Hi Linus,
>=20
> This is the second group of code for the 4.7 merge window.  It looks
> large, but only in one sense.  I'll get to that in a minute.  The list
> of changes here breaks down as follows:
>=20
> Round two of 4.7 merge window patches
>=20

<...>

> - The big item on the list: hfi1 driver updates, plus moving the hfi1
>   driver out of staging                             <- everything else

Hi Doug and Linus,

The move hfi1 from the staging is a right thing, it was there a long
time and it is almost ready.

However the timing of this move puzzle me, we are in the process of ABI
change [1, 2] as a response to security alert [3]. Moves like this with
proprietary char device and ABI scheme different from whole RDMA stack
will limit the ABI work without real need.

Will this driver be **forced** to adjust to new ABI scheme whenever it
comes? If it is not possible, the better solution to converge on ABI change=
 will be
to leave this driver in staging/rdma and wait till proper solution will be =
accepted.

Thanks.

[1] http://marc.info/?l=3Dlinux-rdma&m=3D146407111911544&w=3D2
[2] http://marc.info/?l=3Dlinux-rdma&m=3D146410054120206&w=3D2
[3] https://git.kernel.org/cgit/linux/kernel/git/dledford/rdma.git/commit/?=
id=3De6bd18f57aad1a2d1ef40e646d03ed0f2515c9e3

--yPlaimQd/TpiYx8R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXR9JtAAoJEORje4g2clinQAUP/37/aFQcu0iWgOdPRWyHG8de
tFO2Kb/43z3Vrp6R+AhMzsF6ozml4PqtgewbAWy+U3AV3f6jLAZPbSB4kar/W+3C
xhjupCFrpnq6x4dOU96RO2GECXS0QmsoXQueiOOxz+j3NOH/MPRaqj/cyXTIplo0
yY1uQy3LF4PYn+uDtc6BxB/BXhfdWJ7pRXD5qBGGN4OxTmVYjBO4xWhgTk37D45/
nEUfEQe1oKx0HnTpnVAb+DevERPcgWsBkULNMbQX3a67vEwU4O0jf/A+ArYp0n0A
t5S2Ssx+xS5yGIhGTQfntGTtNxF/E10Oqug3IikW3r4wGihd9iQLpAsXKo0a/8F9
Pl0thm7vnY60AasT4uW6h8zlabZ6bRvGy37HaO5OdCyjAF7YrDkguqYtLlRqcuSm
5W8rs1ouhl2jSqAZQ5IEE1XvAcNYlyFV+6Xyu7UwdMu2u5xagg2l8bQuFQC2ki2c
gJhAge59Aufv8pseb9w+Pxvlkm+kAuufYYhkqXxxT/BjwBOKB4o2I7/SxcsR78QM
95SyMoXFnyR8qIx2IpkG/7tl74WSaLlndCA4o/48DSTgC7zCjFGjklVppGWTYYYe
51MJApQsYM4C2eAn2VAIwC1jgzPOlhPW3894cPXOMeCULxWfjcjLSGNRJnucJ4gi
FtRFvBnZVqlvr71IQx8d
=S7n/
-----END PGP SIGNATURE-----

--yPlaimQd/TpiYx8R--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
