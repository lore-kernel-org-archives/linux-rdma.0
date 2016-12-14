From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/4] Mellanox ConnectX-3/ConnectX-4 fixes for
 4.10
Date: Wed, 14 Dec 2016 14:05:27 -0500
Message-ID: <8449b01d-1a37-6f19-f79b-868adf195dfa@redhat.com>
References: <1480252702-8005-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mI22sdjKp5cnw9F65f9kkaqlVJ0gutw9P"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480252702-8005-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mI22sdjKp5cnw9F65f9kkaqlVJ0gutw9P
Content-Type: multipart/mixed; boundary="PuqFfJFnhTwaNBWvR17m2vnitIFmW4kai";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <8449b01d-1a37-6f19-f79b-868adf195dfa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/4] Mellanox ConnectX-3/ConnectX-4 fixes for
 4.10
References: <1480252702-8005-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1480252702-8005-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--PuqFfJFnhTwaNBWvR17m2vnitIFmW4kai
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/27/2016 8:18 AM, Leon Romanovsky wrote:
> Hi Doug,
>=20
> Please find below four different fixes to ConnectX-3/ConnectX-4.
>=20
> This patchset was generated against v4.9-rc6 and targeted for 4.10.
>=20
> Available in the "topic/mlx-fixes-4.10" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>=20
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/mlx-fixes-4.10
>=20
> Thanks
>=20
> Eli Cohen (1):
>   IB/mlx5: Avoid system crash when enabling many VFs
>=20
> Jack Morgenstein (1):
>   IB/mlx4: Fix out-of-range array index in destroy qp flow
>=20
> Maor Gottlieb (2):
>   IB/mlx5: Assign SRQ type earlier
>   IB/mlx5: Use u64 for UMR length
>=20
>  drivers/infiniband/hw/mlx4/qp.c      | 3 ++-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 2 +-
>  drivers/infiniband/hw/mlx5/mr.c      | 3 ++-
>  drivers/infiniband/hw/mlx5/srq.c     | 2 +-
>  4 files changed, 6 insertions(+), 4 deletions(-)
>=20
> --
> 2.7.4
>=20

Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--PuqFfJFnhTwaNBWvR17m2vnitIFmW4kai--

--mI22sdjKp5cnw9F65f9kkaqlVJ0gutw9P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZf3AAoJELgmozMOVy/dW/gP/3WFJKIyZAXsAMJUUzmMkVHk
jnb0XeqMptiLS906xNi7i9/tpseSvL4uXe6oRL8hnDE3rigBAGOxcMVQ/7a1Tf26
r3pSb0lVEdWgEEanDpAVIVJkw73wWBYFDS04sBUWuGW5xX2FsWjSZKU9DiyUkdpP
S08tnCP3+4Fj7fIADS6qVf/KKrl2FHDP++2zlYHyIcJCgEjlcHJ74fOGi5fwU9DA
FVzCkzYI9ey1fS2khvepZpGUlaLvqBLTy6mPz+SpIATkFvla42zLkf+6G15sF2av
X6w7oE/qTivDeVjoaok63t80v3QYEYE735zoEum/Wdef518h2ndfjGtVkyAdolUD
5qddDrFFAlQM1Ihp8CBTlZ/BmMu0Yr29X1fGb5r18ATEYz5hnC1IQ47SSYfeoLSn
p3eFMUftu1gdw0jNSrClZe8fEGrIqXIBRcQJqVs56DEHtUt4d/25TNXNQxgQbfmn
DwP2ql4+Kb/HCiJ8Z59iUWv3ookHrvUxvq22+x+V3pgcKUmazm4PYjYiO11jR46R
hH0HABIBEZIC4+7Vv/3YeA/fTZecUZ5+aO7DC1qraTg3NWqgF7R1E1GE4k8OQdwx
3eZx/N+sEsntgzI+QdAzbPa1+czVUag1rIJsFqDUMuyCZrDn0LSHoHOfEhZUlnI3
toXdV9WbYbChTxHWXUFn
=VBqM
-----END PGP SIGNATURE-----

--mI22sdjKp5cnw9F65f9kkaqlVJ0gutw9P--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
