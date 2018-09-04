From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH mlx5-next] net/mlx5: Add memic command opcode to command
 checker
Date: Tue, 4 Sep 2018 15:06:14 +0300
Message-ID: <20180904120614.GD2796@mtr-leonro.mtl.com>
References: <20180903171948.19461-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ufMBWnG1WFkAvCRz"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180903171948.19461-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Ariel Levkovich <lariel@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--ufMBWnG1WFkAvCRz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 03, 2018 at 08:19:48PM +0300, Leon Romanovsky wrote:
> From: Ariel Levkovich <lariel@mellanox.com>
>
> Adding the alloc/dealloc memic FW command opcodes to
> avoid "unknown command" prints in the command string
> converter and internal error status handler.
>
> Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++++
>  1 file changed, 4 insertions(+)
>

Applied to mlx5-next: 09adbb5dd01b net/mlx5: Add memic command opcode to command checker

Thanks

--ufMBWnG1WFkAvCRz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbjnU1AAoJEORje4g2clineI4P/3E2krqrAfpypbZjKsm0XYEu
y/81YFYJKoxzzfTeuKoTqNnpClAi8mrldDU/v0m8ERbsncCYHPMwrwPD2bzMhpXz
suZkmXbb/XAcT1fxbLwMdXd3HUvzbN+eQygYG6IJ3E9rt2T+gkEew4ob9jsHc7i3
SVNcOQEy7MitAQpA/0zaYBwm3Kuv7vAcS9OlCUtZScXKV44lY27/hRYv5z/PWzcb
PAhhnrE3mXXu+QP9uzrFAeveJmUGsW+KoDmsdA2q5+QaDpOt5r0KJoVAt8NHDEWk
9kiNKhFh9qn5T72yzm75MnECk8n7/oHCbATAUKlBMzQJ6PMHkMAdHnM3H0UKP1JU
8abKy6cAg/vUNJx51f1Fu7UrLvDq1dRWY/sVBEt9B51NHqwjH6jXha1TMT6nH3At
VlfD4SW9xgzTj4pK1nrUiWbICecnQiLGQehDJ4Zhy0BBk0FpKpR49ol9mlMmtHGQ
Jp3pg72XfrBKveb3n/jz+qPH/vN4+o59xm25vyAAw2uY5pRNZXOIR7aDWISxS8aK
em54/HYgQQ50rQQNuGULYZGP3IEHB7Muzcgc/KSgZkA5JiKnnHSMU1mId/yh1GJF
H3lIdp2TIUNezrXPLN+k5D2wHxKeJMGSFDwf2UQWWMHrlYM5FAyCjF/Y0faXWg3X
4kyQfkt9/zualuLcmDMO
=XVxn
-----END PGP SIGNATURE-----

--ufMBWnG1WFkAvCRz--
