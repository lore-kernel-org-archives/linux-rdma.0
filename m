From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RDMA PATCH 00/16] RDMA/Intel X722 iWARP driver update
Date: Mon, 18 Apr 2016 09:56:42 +0300
Message-ID: <20160418065642.GI6349@leon.nu>
References: <1460557852-10824-1-git-send-email-mustafa.ismail@intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2xeD/fx0+7k8I/QN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460557852-10824-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--2xeD/fx0+7k8I/QN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 13, 2016 at 09:30:36AM -0500, Mustafa Ismail wrote:
> This (V2) series incorporates feedback received for the initial series.
>=20
> This patch series covers changes to i40iw since the initial driver
> submission including base memory management extensions, virtual channel
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

Please follow SubmittingPatches guide [1].

If your patch fixes a bug in a specific commit, e.g. you found an issue usi=
ng
git-bisect, please use the 'Fixes:' tag with the first 12 characters of the
SHA-1 ID, and the one line summary.  For example:

	Fixes: e21d2170f366 ("video: remove unnecessary platform_set_drvdata()")

[1] https://www.kernel.org/doc/Documentation/SubmittingPatches

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
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c    | 283 +++++++++++++++++++++=
+++---
>  drivers/infiniband/hw/i40iw/i40iw_verbs.h    |   3 +
>  drivers/infiniband/hw/i40iw/i40iw_virtchnl.c |  96 ++++-----
>  17 files changed, 671 insertions(+), 312 deletions(-)
>=20
> --=20
> 2.7.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--2xeD/fx0+7k8I/QN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXFIUqAAoJEORje4g2clin+jsP/0gtgp6dwVvLuXR5GIeWl5tG
KjXwVXaqt6ljrhJSOTIF8O45Y7CzPoaSCKEF6iXluv+6wwa3cprA741rfS3ibm7W
yYW6hQWdyTmYag4qYsucaXVEpQ5yMqFzPLoCAdvPQSnok7u64pDRUOmvyW8Vsk+m
01FM3T118nOwRGFa885IbESkcv4BKiBH4eNHdosn8wJAN2CVedQdXtEh3qUeYJv+
vgEpRtEEFP9k6XqLOPvMZp7SvU7QtQCZ++FE0/y/dDYeYbgXs89lkNN968yvle3O
rwoYxNwRMZiBODsg00800kwnjuCfnW3NdolhhHXzjxxJ+OnGKRtxn7uUwxqs19X+
H8+6WFMuT/fkQQh4uyEYs8DOvGwv/GqlGhvYVvNYrTWToeYIHmiQGdPn9TjwYWGG
LTRwKE80gg+VMom+2jfGzC95mQkMsj9xa8mqu+pdgQZrFt0/Qb/0IVnVqsqQQEr+
U2yLwNcxeRcJN2WVRRyXf9Sc0YDYYgUBB0FH7L+aE3TaUkCkKp41KzNSZUu61qby
iGM3b+PBArjnxwW/Uem89rUg7eFKKltM0+Y6U1Ss8W328rbf/56rWZwLFOO4tPqe
5AAtHByqdFLQm+5Z3MhESRvHhLZYKlOsIqwkLA9Sy3Ja2XGIbIyAB6kKKNcuRjVS
EhbxdbCxvf9aVzP4kbx0
=fuqM
-----END PGP SIGNATURE-----

--2xeD/fx0+7k8I/QN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
