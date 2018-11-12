From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 00/10] Collection of ODP fixes
Date: Mon, 12 Nov 2018 20:43:15 +0000
Message-ID: <20181112204310.GI3695@mtr-leonro.mtl.com>
References: <20181108191017.21891-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MmQIYbZiCoQ2kDro"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181108191017.21891-1-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--MmQIYbZiCoQ2kDro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 08, 2018 at 09:10:07PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Hi,
>
> This is collection of fixes to mlx5_core and mlx5_ib ODP logic.
> There are two main reasons why we decided to forward it to mlx5-next
> and not to rdma-rc or net like our other fixes.
>
> 1. We have large number of patches exactly in that area that are ready
> for submission and we don't want to create extra merge work for
> maintainers due to that. Among those future series (already ready and
> tested): internal change of mlx5_core pagefaults handling, moving ODP
> code to RDMA, change in EQ mechanism, simplification and moving SRQ QP
> to RDMA, extra fixes to mlx5_ib ODP and ODP SRQ support.
>
> 2. Most of those fixes are for old bugs and there is no rush to fix them
> right now (in -rc1/-rc2).
>
> Thanks
>
> Moni Shoua (10):
>   net/mlx5: Release resource on error flow
>   net/mlx5: Add interface to hold and release core resources
>   net/mlx5: Enumerate page fault types
>   IB/mlx5: Lock QP during page fault handling
>   net/mlx5: Return success for PAGE_FAULT_RESUME in internal error state
>   net/mlx5: Use multi threaded workqueue for page fault handling
>   IB/mlx5: Improve ODP debugging messages

Applied to mlx5-next
b02394aa75e3 IB/mlx5: Improve ODP debugging messages
90290db7669b net/mlx5: Use multi threaded workqueue for page fault handling
ef90c5e9757d net/mlx5: Return success for PAGE_FAULT_RESUME in internal error state
032080ab43ac IB/mlx5: Lock QP during page fault handling
c99fefea2cc9 net/mlx5: Enumerate page fault types
27e95603f4df net/mlx5: Add interface to hold and release core resources
698114968a22 net/mlx5: Release resource on error flow

>   IB/mlx5: Avoid hangs due to a missing completion
>   IB/mlx5: Call PAGE_FAULT_RESUME command asynchronously

Dropped to address feedback.

>   net/mlx5: Remove unused function

Dropped, because it depends on dropped commit.

Thanks

>
>  drivers/infiniband/core/umem_odp.c            |  14 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |   1 +
>  drivers/infiniband/hw/mlx5/mr.c               |  15 +-
>  drivers/infiniband/hw/mlx5/odp.c              | 158 ++++++++++++++----
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  21 +--
>  drivers/net/ethernet/mellanox/mlx5/core/qp.c  |  20 ++-
>  include/linux/mlx5/device.h                   |   7 +
>  include/linux/mlx5/driver.h                   |   7 +-
>  include/linux/mlx5/qp.h                       |   5 +
>  10 files changed, 191 insertions(+), 59 deletions(-)
>
> --
> 2.19.1
>

--MmQIYbZiCoQ2kDro
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb6eXeAAoJEORje4g2cliniDAP/1TB70mRlUki+VRCY5tEHISx
bNQvS3fOcXRSfue8+p9eHT98J37j83REn5upOZTYr0KtPyrThYkavy8FLu/fcyaj
EWcWw85I32hAEv09gyd2qEOJ5OaL8IFbCMtvFV5xLWWhe+mt79OsIh+QlI+jQFEV
45PeN8YRlIt7zu2Vxd5dmGOyGK7i6j64R1OoqwWqFZbjHB87U8cx42Qh6T/75I76
v0pR91ssLsleWIhdTxnMgvlyYpdAV4RmIapIwzUIAPmMRtiG6OjmK0fy91htM6CR
Gg1os8VR4oMFrXfsJAdf30zCiHphhOITH5nHUmfA0jqpcCr6Vdg0Q9+L1vFXYMoS
xFqVBdj9iY9HAHClzO4b17QCxpkYgplwurC6bC7Q9GwUFKlDgQFFFI1fEyRKD5zh
kgWBoVlqKssNh2pRxXFZCVaAghZn0s4EAcilpn7Mgs9Qgbd27MO17qZaOiJrcojj
NI/sE1MEDD3ahJoPT6aiLypJkdeFtguavEoLFHbd4Q4qSSHGhVunkGFNzm9/C8Ds
mAQhz9zSRfCiJ2cSUUKHTXh9vSfK9Ks1HsBJFbYp/V/nZ5SNAgy0m4O3i944ekck
Dh/m5uNks9k8w/WqLxupFymzMEwQEP195Nw3jHrvEn6G3pOJrcsmId6VDBDZoKki
JLZi2BvBHyM7ekCpQaqa
=biUK
-----END PGP SIGNATURE-----

--MmQIYbZiCoQ2kDro--
