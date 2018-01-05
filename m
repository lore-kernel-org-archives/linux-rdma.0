From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][for-next V3 00/11] Mellanox, mlx5 E-Switch
 updates 2017-12-19
Date: Fri, 05 Jan 2018 14:07:34 -0500
Message-ID: <1515179254.3403.32.camel@redhat.com>
References: <20171228232314.13678-1-saeedm@mellanox.com>
         <20171228.194616.2274862427545657993.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-pBZ1bw4NXaWus2dKDkI5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171228.194616.2274862427545657993.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Gunthorpe, Jason" <jgg-uk2M96/98Pc@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-pBZ1bw4NXaWus2dKDkI5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-12-28 at 19:46 -0500, David Miller wrote:
> From: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date: Fri, 29 Dec 2017 01:23:03 +0200
>=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > This series includes updates for mlx5 E-Switch infrastructures,
> > to be merged into net-next and rdma-next trees.
> >=20
> > Mark's patches provide E-Switch refactoring that generalize the mlx5
> > E-Switch vf representors interfaces and data structures. The serious is
> > mainly focused on moving ethernet (netdev) specific representors logic =
out
> > of E-Switch (eswitch.c) into mlx5e representor module (en_rep.c), which
> > provides better separation and allows future support for other types of=
 vf
> > representors (e.g. RDMA).
> >=20
> > Gal's patches at the end of this serious, provide a simple syntax fix a=
nd
> > two other patches that handles vport ingress/egress ACL steering name
> > spaces to be aligned with the Firmware/Hardware specs.
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >=20
> > V1->V2:
> >  - Addressed coding style comments in patches #1 and #7
> >  - The series is still based on rc4, as now I see net-next is also @rc4=
.
> >=20
> > V2->V3:
> >  - Fixed compilation warning, reported by Dave.
> >=20
> > Please pull and let me know if there's any problem.
>=20
> Looks good, pulled, thank you.

Hi Jason,

Unless I missed something, you haven't pulled this for for-next,
correct?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-pBZ1bw4NXaWus2dKDkI5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpPzPYACgkQuCajMw5X
L93gvg//RR7VfQUTeX9pa5VGCHUb2IvE0FEK85BwxF+E0uJhN3OwVj9mHK3BpABl
yuqlYo7S9Qm8ipaBao2TUPllAkwt1YXZCNtZ2q4JgDERuDw39WDrfsHA/9ovRKpF
63VLs30HU6PW/b44yMcGr7uVpe0s7gCBC3YtINEpvL8K2KOosx8f4QgNyYPvZyjn
yqq1SJvQ2ZkO1I1brhzWFLD5vTU1Q5RbneWI/0tJlXZBsDiT50CJNndu37zKMBNW
3eRJXID/MXv/qxHxso2rP4XnRWNSELDkZ1haopSpnDI6aac5PHbNeu7WYezYz/q3
+ucpWCDOaspunLsVbduhfI1l6GzVzp1b3qbvIqdVFKs0hvadukgxY1OwkkB0YuJ0
Hfj8JWMeVZfPF/jCLBmlSfpKt0QXaPt+CevLiLpRWIcX/jGHrC1LZv/PuuoX44qY
Zzk11zrLAVVMF3F1AQ3/tfYxmTPmrDNdZ1/lkU8okL27UO4we9Tjisskh/5cbNut
4jf1zjDI+K+rQPAetRpxvUcOZF2X1y5r++CH+c8CRGkxaY+/TqzpYRFpoUpGNbR/
2OjdxW2PGaueZFaCCQH17oFw1Yfs7/b+PuEvt8kVqQk4Y+62qPRdkz3LDB9Ff3VJ
MFKcb2J+nHODJ1/1kWjS9Mq1NZR0UuAPT2AJRlJgOkrmZiOBIIE=
=fF/t
-----END PGP SIGNATURE-----

--=-pBZ1bw4NXaWus2dKDkI5--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
