From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next 08/14] net/mlx5: Make mlx5_core messages
 independent from mdev->pdev
Date: Sat, 30 Mar 2019 08:08:56 +0000
Message-ID: <20190330080851.GQ22899@mtr-leonro.mtl.com>
References: <20190329223804.8954-1-saeedm@mellanox.com>
 <20190329223804.8954-9-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ExIO7AL6tcaLjJBF"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190329223804.8954-9-saeedm@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: "saeed@mellanox.com" <saeed@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Huy Nguyen <huyn@mellanox.com>, Vu Pham <vuhuong@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

--ExIO7AL6tcaLjJBF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 29, 2019 at 03:37:58PM -0700, Saeed Mahameed wrote:
> From: Huy Nguyen <huyn@mellanox.com>
>
> Detach mlx5_core mdev messages from pci device mdev->pdev messages and
> provide a better report/debug of different mlx5 device types.
>
> This patch does not change any functionality.
>
> Signed-off-by: Huy Nguyen <huyn@mellanox.com>
> Signed-off-by: Vu Pham <vuhuong@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  .../ethernet/mellanox/mlx5/core/mlx5_core.h   | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> index 7b331674622c..052e81974c3b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
> @@ -48,12 +48,12 @@
>  extern uint mlx5_core_debug_mask;
>
>  #define mlx5_core_dbg(__dev, format, ...)				\
> -	dev_dbg(&(__dev)->pdev->dev, "%s:%d:(pid %d): " format,		\
> +	pr_debug("%s:%s:%d:(pid %d): " format, (__dev)->priv.name,      \
>  		 __func__, __LINE__, current->pid,			\

I see that we printed PID even before this patch, but unfortunately it
is wrong and doesn't handle correctly kernel contexts.

If you are changing those debug prints, it will be nicer to use
CONFIG_PRINTK_CALLER instead like we are doing for the timestamps.

https://marc.info/?l=linux-rdma&m=155289145403897&w=2

Thanks

--ExIO7AL6tcaLjJBF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcnyQTAAoJEORje4g2cline6YP/jBR3gTSHcmtttOFz18PLP5H
8Lh8F8EDF0WGWjTggLyn+t1evTg2gO8GvII4Q5nbnQ9vnBed2TRoTvYLVpDJnQAE
ZiRAiyPuqAqKUiRhMvSWjKcG2zaEcIjtuUtuHjXApYu9QMup94jk16QW9mJ8jPtY
Jr/UAYQ5agjvUZFBk7UmJ1bM6l5OZgrncMsgtPcv8VzGLjri0K1aHoVeDWaGcgCH
aGdxiNKYFUe8YmXAU2k3PVgkn+J1UFGLagdq071BCJX/iCtxG7c8XqUH+B/P92Q9
GCsLbKF0Wb3qTxgcHZ8st0/7cnpGx/titEZfGSjGJ/du1Uc+RGhgzmxYqrVFjWbB
ZVuqCrzLmFrPPSwT63PCpa2uuah2APDjPOQIDfBbR6sZ8SR+0SHXJ+eO/irkYz2g
Jx0bXj10SsYSMU7GaSppU6LPAIbsRTtxec8kMt4DHONBPvTdmlLtteeyqvxpw0zx
WIbtAGP3ynnidsmRgM3Y1SE0EycUYUOhLHqMMT4GrbW3LqJ/yQU/+aq3pofZHyXO
P+8YXR0fHmPKSrdN6SEhCRrIjiNIMWKKJ7qbg2Y7z0S8bnedoqidTROJQyaLMY4g
STd55Md4oUoQU0t07FwRwrbZ37CPkT7Rwvrjk0wnhLnEMLIZGTYUeyfIhuskJ1tQ
XNvP8Ew+2jaHrzN9NxLb
=yoJF
-----END PGP SIGNATURE-----

--ExIO7AL6tcaLjJBF--
