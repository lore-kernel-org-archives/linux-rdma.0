From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 28/29] IB/rxe: Shared objects between user and
 kernel
Date: Thu, 9 Jun 2016 09:09:31 +0300
Message-ID: <20160609060931.GM3663@leon.nu>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com>
 <1464886657-14258-29-git-send-email-monis@mellanox.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g6DVDhPhk1bqxDrC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464886657-14258-29-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--g6DVDhPhk1bqxDrC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 02, 2016 at 07:57:36PM +0300, Moni Shoua wrote:
> User and kernel pass objects in shared memeory. For this both sides need
> to declare about the layout of each object in memory or in other words:
> agree about the ABI.
>=20
> Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/uapi/rdma/Kbuild   |   1 +
>  include/uapi/rdma/ib_rxe.h | 139 +++++++++++++++++++++++++++++++++++++++=
++++++
>  2 files changed, 140 insertions(+)
>  create mode 100644 include/uapi/rdma/ib_rxe.h
>=20
> diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
> index 231901b..94f9401 100644
> --- a/include/uapi/rdma/Kbuild
> +++ b/include/uapi/rdma/Kbuild
> @@ -6,3 +6,4 @@ header-y +=3D ib_user_verbs.h
>  header-y +=3D rdma_netlink.h
>  header-y +=3D rdma_user_cm.h
>  header-y +=3D hfi/
> +header-y +=3D ib_rxe.h

IMHO, it needs to be called ib_user_rxe.h and not ib_rxe.h
It looks like rdma_netlink.h is exclusion from that convention.

> diff --git a/include/uapi/rdma/ib_rxe.h b/include/uapi/rdma/ib_rxe.h
> new file mode 100644
> index 0000000..eb8ff8c
> --- /dev/null
> +++ b/include/uapi/rdma/ib_rxe.h
> @@ -0,0 +1,139 @@
> +/*
> + * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.

Small nitpick - need to update Copyright.


--g6DVDhPhk1bqxDrC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXWQgbAAoJEORje4g2clinCF4P/2hzAp2KSvSkLMm4858C2TwL
xePYHhVyoH9yC0Rz16m5jv73wvDMQoqD/jsQzDcsBfeYm/myqvxh0i9pwKNGwbZ7
lR7XjcDNiCFMbqgP4aaNVWcQCIGM4fgP0lC2Z1xe42HXsXxBWWfzfp50fJJ+WByL
EQDvBQwUDfplBpALksty6ru+B4TsAej41BnwonNiLWgP9JhMj/W/kjwIYxXeSth7
Kq/a2yJtUTGgoxnClJspQZzMHKB9+IfvJab+8sXjKTZsnW/CVfcUmjAzaPc8cFhc
ZaMutMBPp26AZaPQJRTNxtlkYoxL48TcjSrUZsns3DvAV3YQOGdrLR8aERLkL9gV
zry3dmEYhodKiYaq+CJMYAo6qWx5uukI1NWl/hI/FBSWFw1EFdz7a5kADaLsAr/f
7jNcZc6DXG8ikoR5ebJaxIG73vh2Mc9I+jfHbVhzC8KExLplUbgUrd0G1eec4Lk3
Ny4dA1MhDhAetNS3LLuTTKMx4bP142VUl52ld8FqFyA5l6OGb8D4Bf9AboDuJ1EB
yqLZqL9uDv4HwLaKiczy17VPxb7GJ7d+1N94ss+AQi6KmhRv0rMFo58zdVyRtRf+
aId5Uar1A3pkTmRrQj9urT95yXEZqCghm/HHhi8xpihn8nJHd1lJz79/YivCqAb5
7RSH5nEDZl4JstYmC5Rc
=7TPc
-----END PGP SIGNATURE-----

--g6DVDhPhk1bqxDrC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
