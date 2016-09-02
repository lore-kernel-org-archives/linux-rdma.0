From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/9] RDMA fixes for 4.8
Date: Fri, 2 Sep 2016 14:13:27 -0400
Message-ID: <d5eff78f-0014-e748-11c9-888c70542391@redhat.com>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="u92J97ImGE4nF0fjaxNvgECbO5Llqusvc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472371118-8260-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--u92J97ImGE4nF0fjaxNvgECbO5Llqusvc
Content-Type: multipart/mixed; boundary="sveG48BEdxpphJijlJ6CuDuHRpAheqShb";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <d5eff78f-0014-e748-11c9-888c70542391-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/9] RDMA fixes for 4.8
References: <1472371118-8260-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1472371118-8260-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--sveG48BEdxpphJijlJ6CuDuHRpAheqShb
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/28/2016 3:58 AM, Leon Romanovsky wrote:
> Hi Doug,
>=20
> This is compilation of fixes to RDMA core, IPoIB, Mellanox mlx4
> and mlx5 drivers all together. Most of the fixes are one liners and
> for easy handling, I'm sending them in one patchset.
>=20
> Thanks
>=20
> Chuck Lever (1):
>   IB/mlx5: Return EINVAL when caller specifies too many SGEs
>=20
> Erez Shitrit (2):
>   IB/core: Fix use after free in send_leave function
>   IB/ipoib: Fix memory corruption during ipoib cm connection
>     establishment
>=20
> Leon Romanovsky (5):
>   Revert "IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one"
>   IB/mlx4: Don't return errors from poll_cq
>   IB/mlx5: Simplify code by removing return variable
>   IB/mlx5: Add VERBOSITY Kconfig option
>   IB/mlx5: Don't return errors from poll_cq
>=20
> Yishai Hadas (1):
>   IB/mlx5: Use TIR number based on selector
>=20
>  drivers/infiniband/core/multicast.c       | 13 ++-----------
>  drivers/infiniband/hw/mlx4/cq.c           | 26 ++---------------------=
---
>  drivers/infiniband/hw/mlx5/Kconfig        |  6 ++++++
>  drivers/infiniband/hw/mlx5/cq.c           | 22 ++--------------------
>  drivers/infiniband/hw/mlx5/main.c         |  6 +++++-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h      |  1 +
>  drivers/infiniband/hw/mlx5/qp.c           | 15 ++++++---------
>  drivers/infiniband/ulp/ipoib/ipoib.h      |  1 +
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c   | 16 ++++++++++++++++
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |  2 +-
>  10 files changed, 42 insertions(+), 66 deletions(-)

I took everything except patch 7.  That one had to go.  It would take a
very strong argument about why that needs a Kconfig option instead of a
runtime config switch to make me change my mind.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--sveG48BEdxpphJijlJ6CuDuHRpAheqShb--

--u92J97ImGE4nF0fjaxNvgECbO5Llqusvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXycFHAAoJELgmozMOVy/d0zIQAJsQ9wzIFodlR3U7I7Wm+M0w
d7lV2KObYErtes947ddpGOj/cCyz3RyO4eYlJ+WBvyMbIWlLErS3u59/CbKslsTg
zTIKiK4ZfLsfggtLPfivxNHQVnAXjA3x3XvKr1Ao3prfsZABVMlX9irSWcQ+lnh4
JrxF3J5pvi6OlJSI/OWaI7trfTXi7iqI9N+nPzll362ApHd9+qYd5Za7rLFs7CU4
d1xaaGIPQKULytugCjDM+R2cKlD0QkWJWBVTZxpFUuYE2fyTA7wbXEpT2kfmIsZZ
j9JkG1KHqd8uHL/+NM2VOrWH1JQiqt7iNWHXV9c/5gO/ZhDmSvpR/7CdONZxbCE/
/Rqyel+YCCgETg1ETIYFiuI1UG5+X54c3Woc3JdNGFcXhkt4DD5kaNhLzF3Oi9KG
JUE52kwG66NGXcpYXvCVLvWMUc+bkMjx/lLEy2C/yQ+ghAJYDHIluZ5zfXI6SxUg
/uGEGrgUUrJBxonOYwg+CRHcQdEfNLGMmDnUeScUUy7EN2tZy70G2+EtqCjf4JIS
L1QYdhE1aI2xU9GWAoaBEZp9RPPaXqZNvvEKrsSsFeYVKUFgOz6y4lO5qLYhXF18
BXhhzDDx8QDkdfzIXPOM5UyN+GJ4Sx9FUXmY0Uc2dpcLDafwVeO00FEjRmcK6KvQ
V6xc9VPEM+wENbtgWt2C
=kNbt
-----END PGP SIGNATURE-----

--u92J97ImGE4nF0fjaxNvgECbO5Llqusvc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
