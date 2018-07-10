From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] ib/mlx4: adjust gfp flags for DMA allocations
Date: Tue, 10 Jul 2018 13:56:42 +0300
Message-ID: <20180710105642.GD3014@mtr-leonro.mtl.com>
References: <1531144273-25959-1-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UXdImcDs+Jp8Skh3"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1531144273-25959-1-git-send-email-jan.dakinevich@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org


--UXdImcDs+Jp8Skh3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 09, 2018 at 04:51:13PM +0300, Jan Dakinevich wrote:
> For most cases it is enough to use common GFP_KERNEL flag. However,
> there is one place with defined fallback path on unsuccessful allocation.
> In this case it would be preferred to append on first allocation attempt
> __GFP_NOWARN and __GFP_NORETRY flags to suppress possible warnings and
> to shorten the path to the fallback in a case of memory pressure.
>
> Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
> ---
>  drivers/infiniband/hw/mlx4/cq.c            |  2 +-
>  drivers/infiniband/hw/mlx4/qp.c            |  6 ++++--
>  drivers/infiniband/hw/mlx4/srq.c           |  2 +-
>  drivers/net/ethernet/mellanox/mlx4/alloc.c | 12 ++++++------
>  include/linux/mlx4/device.h                |  2 +-
>  5 files changed, 13 insertions(+), 11 deletions(-)
>

Thanks for the patch, however we are working on the patch to avoid
second call to mlx4_buf_alloc() and it will eliminate the annoying
WARN splat.

Because it is in latest stages of internal review, NAK.

Thanks

--UXdImcDs+Jp8Skh3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbRJDqAAoJEORje4g2clinKCwP/isUFdWDQl5E6247HvyTeC3a
/vG4hTqCcNZ+a2e0FWCtIgPdZ9wfj5b/NBf9a/MMva2X/drKHjaXs6sszBwbLvOu
c1Fev75rSnzoiKgcBQZHnG7IiRlqZGgk396o3qz4HyBklKf4EaZuLPWV4z8J6IBG
K+rxZCd8bHvzOJBtzMvi9GeOHh/e1XNmlNQsvTpRf+yK/Fg2KdYWqP0BLgryWLuP
XQwKx5TuhiuLx2bkV/DaqHZ+wgltxmc1dwYpPwgFkZdUhd2TrByfkMeJp40JPbHo
lLU57U0QBUEV/8WZaWgua4lmw6U5k5jJ10ZsylW/yH+6BYyuxDObdByssqLU5gDp
eWULOq41M96rJXbc+idxhABKHMl7kWcvZtQ6WC/w5QVbIMz8dlqJ1QauaynvojN2
G0ToKMg9Q/+KYcuZf4W1R0lZ7uA4DiGiP08bCh6VSedeE1dyuwoySVs3FnWJEroQ
tFY2+A72waUm8JpkbpnQkHHkB90XMR0r25srz2qKm19HSlND8u2oSO401JAk0Hau
cjbG0IAQlko7akGX+ubn+R6MNOJ0UiJ4bsVV9gr+G9Za9mWjG4lE9SzXnBAaQLSS
yxRrTLmPA7Zf68Ig+S8mcsSP1i5wYYkHx8omYA8eS/F6MyPs8fP0y484tyKTgtcQ
dr/wJZO7y9sa+8/abuLM
=A3Y2
-----END PGP SIGNATURE-----

--UXdImcDs+Jp8Skh3--
