From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH v2] IB/mlx5: fix debugfs cleanup
Date: Mon, 18 Sep 2017 14:49:05 +0300
Message-ID: <20170918114905.GF5788@mtr-leonro.local>
References: <1505734128-21708-1-git-send-email-sudip.mukherjee@codethink.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5Mfx4RzfBqgnTE/w"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1505734128-21708-1-git-send-email-sudip.mukherjee@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Matan Barak <matanb@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--5Mfx4RzfBqgnTE/w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 18, 2017 at 12:28:48PM +0100, Sudip Mukherjee wrote:
> From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
>
> If delay_drop_debugfs_init() fails in any of the operations to create
> debugfs, it is calling delay_drop_debugfs_cleanup() as part of its
> cleanup. But delay_drop_debugfs_cleanup() checks for 'dbg' and since
> we have not yet pointed 'dbg' to the debugfs we need to cleanup, the
> cleanup fails and we are left with stray debugfs elements and also a
> memory leak.
>
> Fixes: 4a5fd5d2965c ("IB/mlx5: Add necessary delay drop assignment")
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> ---
>  drivers/infiniband/hw/mlx5/main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
> index ab3c562..05fb4bd 100644
> --- a/drivers/infiniband/hw/mlx5/main.c
> +++ b/drivers/infiniband/hw/mlx5/main.c
> @@ -3837,11 +3837,13 @@ static int delay_drop_debugfs_init(struct mlx5_ib_dev *dev)
>  	if (!dbg)
>  		return -ENOMEM;
>
> +	dev->delay_drop.dbg = dbg;
> +
>  	dbg->dir_debugfs =
>  		debugfs_create_dir("delay_drop",
>  				   dev->mdev->priv.dbg_root);
>  	if (!dbg->dir_debugfs)
> -		return -ENOMEM;
> +		goto out_debugfs;
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

--5Mfx4RzfBqgnTE/w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm/srAACgkQ5GN7iDZy
WKcJSw/+Kifbar0+QMPnfnhPUjRtyXNkm4V/RpSzEH4Kks3sKqVSuj3oLsH42enQ
4SOFVwKrm6RPQ3Q9Dl8rS255LhffGzv8brBhIwi32Ik0lDwjno2xTiwChJraJkco
bSj7rhgz1mV4hVzChX4fBIzD5UE9mjJc+seWXk2YONcoopBHY6yIK2KtdMsWQEGP
9rHnCMWRDWzVAA7wY/xA6sZ4Wjn+UjkgsjG9zZuqe6SLQetnbNgqujEzQ7/TjXVr
kCpT5qoMVIWIXou/1qiLz4ubpJ+favBTva9pzw7y+zts98ukXAHMIOKYcJlOS0p+
PRmNWNjl1CbXcePLgktwYSe5dvqHHp5xBLRhpls00ZP+vToXLjceATsQLWaAxP+p
kfsdpGEqFcnZCFMXLhR0dmePBVY6KS09/ww9h2CippvQZm6FT+d7jnmfOcHoWw/B
uZgqOm5vNiekZCGa/vTB/tcrGa41b8jyO1vYuwhTdXBtC7o8OXUNXymknBbbO+4F
YRkMSVbXNVhUpqOVj9bnUCnwKyWcPf6TvGPkackuIdsjiMpScxCuJEmo1sU+mECw
87UxXtG65smD2FlYPRrfYmiSl2sLg4thL0DhpIvaJCWn+PFLfl4gfHsJjH+pnywN
3Dtyu135qbDCkosmWIsEkwwLjghjktCYGsPezwkel2Y2bBbZhPs=
=2Xp/
-----END PGP SIGNATURE-----

--5Mfx4RzfBqgnTE/w--
