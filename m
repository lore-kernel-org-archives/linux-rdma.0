From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RDMA PATCH 00/16] RDMA/Intel X722 iWARP driver update
Date: Fri, 13 May 2016 16:07:56 -0400
Message-ID: <726e0989-30e9-800d-568b-7fa603e632a4@redhat.com>
References: <1460557852-10824-1-git-send-email-mustafa.ismail@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CvAJIcSS9HQERPu3WPG64sn08slwVlh2A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460557852-10824-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CvAJIcSS9HQERPu3WPG64sn08slwVlh2A
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/13/2016 10:30 AM, Mustafa Ismail wrote:
> This (V2) series incorporates feedback received for the initial series.=

>=20
> This patch series covers changes to i40iw since the initial driver
> submission including base memory management extensions, virtual channel=

> messages queue, corrections for endian warnings and bug fixes.
>=20
> This patch series is based on Doug Ledford's
> https://github.com/dledford/linux.git branch: k.o/for-4.6-rc
>=20
> Changes from original version to V2 incorporates feedback received:
> 1. Move RDMA in subject line.
> 2. Fix for cast warning due to u64 to u32 assignment.
> 3. Use named initializers for structures that have meaning outside
> the file.
>=20
>=20
> Mustafa Ismail (16):
>   RDMA/i40iw: Fix overflow of region length
>   RDMA/i40iw: Correct QP size calculation
>   RDMA/i40iw: Fix refused connections
>   RDMA/i40iw: Correct max message size in query port
>   RDMA/i40iw: Do not set self-referencing pointer to NULL after free
>   RDMA/i40iw: Add qp table lock around AE processing
>   RDMA/i40iw: Set vendor_err only if there is an actual error
>   RDMA/i40iw: Populate vendor_id and vendor_part_id fields
>   RDMA/i40iw: Remove unused code and fix warning
>   RDMA/i40iw: Add virtual channel message queue
>   RDMA/i40iw: Correct return code check in add_pble_pool
>   RDMA/i40iw: Initialize max enabled vfs variable
>   RDMA/i40iw: Add base memory management extensions
>   RDMA/i40iw: Fix endian issues and warnings
>   RDMA/i40iw: Fix SD calculation for initial HMC creation
>   RDMA/i40iw: Adding queue drain functions
>=20
>  drivers/infiniband/hw/i40iw/i40iw.h          |   7 +-
>  drivers/infiniband/hw/i40iw/i40iw_cm.c       | 144 +++++++-------
>  drivers/infiniband/hw/i40iw/i40iw_cm.h       |  10 +-
>  drivers/infiniband/hw/i40iw/i40iw_ctrl.c     | 185 ++++++++++++-----
>  drivers/infiniband/hw/i40iw/i40iw_d.h        |   2 +-
>  drivers/infiniband/hw/i40iw/i40iw_hw.c       |  11 +-
>  drivers/infiniband/hw/i40iw/i40iw_main.c     |  55 ++++--
>  drivers/infiniband/hw/i40iw/i40iw_osdep.h    |   1 +
>  drivers/infiniband/hw/i40iw/i40iw_pble.c     |   9 +-
>  drivers/infiniband/hw/i40iw/i40iw_puda.c     |   2 +-
>  drivers/infiniband/hw/i40iw/i40iw_type.h     |  12 +-
>  drivers/infiniband/hw/i40iw/i40iw_uk.c       |  80 +++-----
>  drivers/infiniband/hw/i40iw/i40iw_user.h     |  36 ++--
>  drivers/infiniband/hw/i40iw/i40iw_utils.c    |  47 +++--
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c    | 283 +++++++++++++++++++=
+++++---
>  drivers/infiniband/hw/i40iw/i40iw_verbs.h    |   3 +
>  drivers/infiniband/hw/i40iw/i40iw_virtchnl.c |  96 ++++-----
>  17 files changed, 671 insertions(+), 312 deletions(-)
>=20

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--CvAJIcSS9HQERPu3WPG64sn08slwVlh2A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNjQcAAoJELgmozMOVy/dP8YQAJY9g+TGGXZ5hOMLRMwSSU+F
o6CJrNNzF03Xa1oNOKcw4Rx4rHskvcBJ2T8tECZmRigac4Uqi+/ZTfOrDjQxXkRk
0XdNzO05NBjgGtXw2nOBdbR0RTWv/91CfvO5zU7oic7jY8A2AEa4/RY5pbNxt4TZ
nlTh8/Znh1Ib46Dy/lPQpnn+CfnOSk4tXioPvmeDTzz2tNYh4uZzkFdXDZ768xrb
B0kB7duYeqWy8hioHPruOPqg8fNvnwcv4CA4pG982ehxox+1+HjomQMHkU4TTrsa
fggpgNQJ12wDlgXTG4YHUxOdZaydmGLeoxWLVZphShsL7Sg32kj3UWyn9YzABN+R
3sfVVj2cZTZKZyiPBgimH0yJGuYZN8yjwFLInq3thmA2+akkO/x3ozL6RQkuJUQ7
je10JGZl5gsOeRRsJytEudiWrbQvYJUu1IGr6uAWwrZViCyyV/Gc+RPeTXc3fHI8
WLejFOllvkVbuosIOu1GsKLqrf21+vE+AZi6MACXsVBirSOe/0BrL8Y3yLdnkx9O
tO5W8r+2ii/Lnms1A7FSltV90ahITYzoQQH0qUf6HR5DbLURST+oxH4OGvmrukIl
uqzuKzYKjKJumMOkrs9D8EU9/wkpJ3sNo7PbxPwE6ORHkWlrZgtWTv3Ue+KV75gl
L9+aNjqcx/mj35JepEiw
=kKpK
-----END PGP SIGNATURE-----

--CvAJIcSS9HQERPu3WPG64sn08slwVlh2A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
