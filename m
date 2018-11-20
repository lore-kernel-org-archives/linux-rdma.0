From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH V2 mlx5-next 00/12] mlx5 core generic EQ API for RDMA ODP
Date: Tue, 20 Nov 2018 18:11:16 +0000
Message-ID: <20181120181113.GC5394@mtr-leonro.mtl.com>
References: <20181119185242.21961-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181119185242.21961-1-saeedm@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 19, 2018 at 10:52:30AM -0800, Saeed Mahameed wrote:
> Hi,
>
> This patchset is for mlx5-next shared branch, and will be applied there
> once the review is done.
>
> This patchset introduces mostly refactoring work and EQ related code updates to
> allow moving the ODP rdma only logic from mlx5_core into mlx5 ib where it
> belongs, and will allow future updates and optimizations for the rdma ODP
> (On Demand Paging) feature to go only to rdma tree.
>
> Patch #1: Fixes the offsets of stored irq affinity hints inside mlx5
> irq info array.
>
> Patch #2,3,4: Remove unused fields, code and logic
>
> Patch #5: Move all EQ related logic from main.c to eq.c to allow clear
> and seamless refactoring for creating generic EQ management API.
>
> Patch #6: Create mlx5 core EQs in one place, in order to have one entry
> point to call from main file.
>
> Patch #7,8: Move EQ related structures into eq_table mlx5 structure and
> make eq_table fields and logic private to eq.c file.
>
> Patch #9,10: Create one generic EQ struct and use it in different
> EQ types (usages) e.g. (Async, Command, FW pages, completion and ODP)
> Introduce generic EQ API to allow creating Generic EQs regardless of
> their types, will be uesd to create all mlx5 core EQs in mlx5_core and
> ODP EQ in mlx5_ib.
>
> Patch #11: Move ODP logic out from mlx5_core eq.c into mlx5 rdma driver.
> odp.c file.
>
> Patch #12: Make the trivial EQE access methods inline.
>
> v1->v2:
> 	- Remove vertical alignment
> 	- Fix spilling "Chip" -> "Cheap"
>
> Thanks,
> Saeed.
>
> ---
>
> Saeed Mahameed (12):
>   net/mlx5: EQ, Use the right place to store/read IRQ affinity hint
>   net/mlx5: EQ, Remove unused fields and structures
>   net/mlx5: EQ, No need to store eq index as a field
>   net/mlx5: EQ, Remove redundant completion EQ list lock
>   net/mlx5: EQ, Move all EQ logic to eq.c
>   net/mlx5: EQ, Create all EQs in one place
>   net/mlx5: EQ, irq_info and rmap belong to eq_table
>   net/mlx5: EQ, Privatize eq_table and friends
>   net/mlx5: EQ, Different EQ types
>   net/mlx5: EQ, Generic EQ
>   {net,IB}/mlx5: Move Page fault EQ and ODP logic to RDMA
>   net/mlx5: EQ, Make EQE access methods inline
>

Pushed to shared mlx5-next:

6d2d6fc83a28 net/mlx5: EQ, Make EQE access methods inline
d5d284b829a6 {net,IB}/mlx5: Move Page fault EQ and ODP logic to RDMA
7701707cb94e net/mlx5: EQ, Generic EQ
16d760839cee net/mlx5: EQ, Different EQ types
f2f3df550139 net/mlx5: EQ, Privatize eq_table and friends
d674a9aa4344 net/mlx5: EQ, irq_info and rmap belong to eq_table
c8e21b3b576b net/mlx5: EQ, Create all EQs in one place
ca828cb4686f net/mlx5: EQ, Move all EQ logic to eq.c
aaa553a64438 net/mlx5: EQ, Remove redundant completion EQ list lock
2883f352571b net/mlx5: EQ, No need to store eq index as a field
4de45c758636 net/mlx5: EQ, Remove unused fields and structures
1e86ace4c140 net/mlx5: EQ, Use the right place to store/read IRQ affinity hint

Thanks

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb9E5BAAoJEORje4g2clinmNwP/i0PYtWsxnhlu1ybVmYg2pjI
6o76Ak1K034SXdYE+3rS/Fxq0e1Yojhz4jd0TU6yNfLXdR/ylr1i6xrfnsm9ZdGc
/hTrTeQ1RhNhjP6tfaKzDiOW0qI9nvxr0JEp4jwOxxx9cILAFdYH88IzSZE7jmw7
Yy7Ok4ULzUnSZ0dUeSpGV12jVtuQzc3KCbhe8j6k2XmTkVZKMArpZJVv89JNZgci
XpN5doMrOJyobksyDXlZ71U2YqNzlt+ZO2MACrv6QdqJ1XpeSM+YQrr/vMwe9wAj
qZSSuhDxLeFscVNouCrZYXzJTmjv28z4GVpM8e06kL75h+k+Niy41X/fHt5jcOhv
I0nh1rq6pGd1Zx+SDtn+exSIx4SnoNscXr+VIdoDtcuJbK0DRLT4fPQQXimBa1a2
wj94QrAgSG6sScXp1yfi4pRJAl23gjKNqRxqrzRl/TSidgQRJohZvyDZWqBFkudZ
IY7NHbCzqtZUjS96PW+q6wEnKvJbJebtr/ulKudxPbp7gQTGJf7FlRwEp7reg5bR
XTIHOa3cPLE1q+VxtJFnE5bNJxfvPT86OzDerEYzkiY812qF6xwMv6K5dd9xkpcZ
smHIBKBTOSP2yhAJOE561ziLfIDd+y94f6VTeGl4uGNqckL5hKd6Rl95i000+Djk
2xJrB14wB0UQ2HMwgqwO
=Z+Yv
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
