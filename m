From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/7] Second round of mlx4/mlx5 fixes for 4.8
Date: Fri, 16 Sep 2016 14:02:23 -0400
Message-ID: <9a11fa8a-03a8-e9fa-ad79-a4f0ffca9690@redhat.com>
References: <1473696984-6161-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OllhPN4ucPxETVDkiHHiQkDfed2fegsnA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473696984-6161-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OllhPN4ucPxETVDkiHHiQkDfed2fegsnA
Content-Type: multipart/mixed; boundary="EkxhuRpWTrdLXtjWTAx8slkfhLhl3WS9v";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <9a11fa8a-03a8-e9fa-ad79-a4f0ffca9690-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/7] Second round of mlx4/mlx5 fixes for 4.8
References: <1473696984-6161-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1473696984-6161-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--EkxhuRpWTrdLXtjWTAx8slkfhLhl3WS9v
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/12/2016 12:16 PM, Leon Romanovsky wrote:
> Hi Doug,
>=20
> Here are seven patches which fix different bugs mostly crashes and one
> patch with code cleanup. This code cleanup was needed to create fix
> without checkpatch warnings.
>=20
> Available in the "topic/fixes-for-4.8-2" topic branch of this git repo:=

> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>=20
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/fixes-for-4.8-2
>=20
> Alex Vesker (1):
>   IB/mlx4: Fix incorrect MC join state bit-masking on SR-IOV
>=20
> Jack Morgenstein (3):
>   IB/mlx4: Fix code indentation in QP1 MAD flow
>   IB/mlx4: Use correct subnet-prefix in QP1 mads under SRIOV
>   IB/mlx4: Fix possible vl/sl field mismatch in LRH header in QP1
>     packets
>=20
> Kamal Heib (1):
>   IB/mlx4: Diagnostic HW counters are not supported in slave mode
>=20
> Maor Gottlieb (1):
>   IB/mlx5: Set source mac address in FTE
>=20
> Noa Osherovich (1):
>   IB/mlx5: Enable MAD_IFC commands for IB ports only
>=20
>  drivers/infiniband/hw/mlx4/mad.c        |  87 +++++++++++++++++++++++-=

>  drivers/infiniband/hw/mlx4/main.c       | 113 ++++++++++++++++++++++++=
+++++++-
>  drivers/infiniband/hw/mlx4/mcg.c        |  14 ++--
>  drivers/infiniband/hw/mlx4/mlx4_ib.h    |   9 ++-
>  drivers/infiniband/hw/mlx4/qp.c         |  60 ++++++++++++-----
>  drivers/infiniband/hw/mlx5/main.c       |  11 +++-
>  drivers/net/ethernet/mellanox/mlx4/fw.c |  13 ++--
>  include/linux/mlx4/device.h             |  13 +++-
>  8 files changed, 284 insertions(+), 36 deletions(-)
>=20
> --
> 2.7.4
>=20

Series, minus 4 of 7, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--EkxhuRpWTrdLXtjWTAx8slkfhLhl3WS9v--

--OllhPN4ucPxETVDkiHHiQkDfed2fegsnA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX3DOvAAoJELgmozMOVy/dHfQQALm2Yh9SvDPGe7VBdSes+Soa
O2gaNl7NxV2259wv4xbXgZmg1+i67sbGjwWYkD1LpHYSpQZxyZpU4MAbjX15wVTi
nSAUw37ku+kNttHTgjdTqNMmGNCE0pmRUtJODlxPzsf2os6o17BvwfuitxcdCfAj
LMdv1biNCihMQoLpgYq4rD3Fjo/cePT+fLAk5CE790bR5Xdk6r0ugXMbSihlwQdr
R77ZOlfaPakwpgPOKcU/pvQidyyS625LtJEjh0SihB3MaMGxf6QF/soig3R7vldV
4XXtFQszIVWg67h/dDEbm94daYPXek4lS9mUC8BUVBGhAPvqABWPVIYVXJgLgpaY
uf2x8eiwL+8+NYG/UOWFacItjKksFc3xeN+Y3v2SZc/cm3WAuv/YkpwNk+XAO736
g6jKQXK2fJCFLf1qqcumNKfsZ/6oqUKSSTt5gcgklQp+0t9WNBEOWwhP4/pHkczY
t9gFgLlkA0YvsMTRkXUIydiHLRx/B4YbJfXY9weMwe69tOBOvaXr+FbpfOHL806u
UNxOSDFYmT7K44ReUk5zV0uS86fYal9kZB4XCdgazskaZfnwWeAvhxJP/ePavv1d
W/PgIxeuZbLJojoXeD7KN7Mxm3iZr2L0gZKu5X/aqnAiMdkbIpYvJgT3S8G33TQJ
nz+tYraII5pjyuDjgQz4
=ZDgS
-----END PGP SIGNATURE-----

--OllhPN4ucPxETVDkiHHiQkDfed2fegsnA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
