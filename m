From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/5] RDMA core/mlx4/mlx5 fixes and MTT
 improvements
Date: Mon, 13 Nov 2017 14:44:29 -0500
Message-ID: <1510602269.3735.25.camel@redhat.com>
References: <20171102132228.20985-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Q7h8JlSovHa5TLxsV4XR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102132228.20985-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-Q7h8JlSovHa5TLxsV4XR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-11-02 at 15:22 +0200, Leon Romanovsky wrote:
> * Optimization to mlx4 MTT logic
> * Fixup to mlx5 ABI alignment
> * Code simplification to IB/core
>=20
> The patches are available in the git repository at:
>   git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git tags/rdma-n=
ext-2017-11-02
>=20
> 	Thanks
> ---------------------------------------
>=20
> Guy Levi (2):
>   IB/mlx4: Use optimal numbers of MTT entries
>   IB/mlx4: Add contig support for control objects
>=20
> Mark Bloch (1):
>   IB/mlx4: Increase maximal message size under UD QP
>=20
> Noa Osherovich (1):
>   IB/mlx5: Fix ABI alignment to 64 bit
>=20
> Parav Pandit (1):
>   IB/core: Avoid unnecessary return value check
>=20
>  drivers/infiniband/core/security.c   |  15 +-
>  drivers/infiniband/hw/mlx4/cq.c      |   8 +-
>  drivers/infiniband/hw/mlx4/mlx4_ib.h |   2 +
>  drivers/infiniband/hw/mlx4/mr.c      | 284 +++++++++++++++++++++++++++++=
+++---
>  drivers/infiniband/hw/mlx4/qp.c      |  10 +-
>  include/uapi/rdma/mlx5-abi.h         |   1 +
>  6 files changed, 280 insertions(+), 40 deletions(-)
>=20
> --
> 2.14.2
>=20

Thanks Leon, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-Q7h8JlSovHa5TLxsV4XR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloJ9h0ACgkQuCajMw5X
L92bfA/8DON+Zgz3yTYU/Kt8pWvx9rPR+KYHLgYTpjfpMp/XVoOsVgX1kGFDi9e0
2oClFauUO7TucMeqZbzEshdn9RjHqtVM/65WREIGMM0TPbIHjMKhzlXc6cv06DgH
IYIKxUQ2+RQD6eys+fMsD8R9txtbSfmZbIycYvnGxIDVZfR55COPIzO+JGj7PPp2
n2FSZUux36Reb1/fQk/0HOjgUnhHolbdi1rpZh7a4VE6Miiewo0ULDCWqSK6O5fp
/OmzLlEQeg3ynwvgaIHtSCgCyH7Prp39tnOq7Ma01P6A/niv45kuy6z6qte+NSZe
dcQL6psWTmg5ReGkS7/yujpF+uWmNlbpdw3N2Nk8WBHDSA/KAuW6yAO0nJAMsxAx
i6Xg+5ZL92bYbOx7TKWg8up0WAbB4q2r6qAOUD7CTGCHdEDHW5ik6CurcI4jK+NG
ZKH5Z1SaNGKT63VjAuTtYDkcTU7PcVlRAxe27Z1aPz12rcTgWXBkc6tJqonm0PT7
TlzjoOj71IKt4FihNfP8vTCsdK/tVF/ZIWibW9XQZ/hBxeG0CiVPjBlrpTNxbq8C
Y+CymISJ3m1t3YPheTLbeV732JumUp6tVNYjMJkQhsiKUETKZr8cC7TNSBcOnwsi
gAeKrQW6yfzeK1YRJCUu0wsMWZRKS7L6fuuAc+KcCALZMO+SHxE=
=ksr9
-----END PGP SIGNATURE-----

--=-Q7h8JlSovHa5TLxsV4XR--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
