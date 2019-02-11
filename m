From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH mlx5-next 2/2] net/mlx5: Factor out HCA capabilities
 functions
Date: Mon, 11 Feb 2019 19:50:55 +0000
Message-ID: <20190211195050.GL24706@mellanox.com>
References: <20190211115608.22677-1-leon@kernel.org>
 <20190211115608.22677-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190211115608.22677-3-leon@kernel.org>
Content-Language: en-US
Content-ID: <598CB911B890F242AD7490A70F39A831@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 01:56:08PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> Combine all HCA capabilities setters under one function
> and compile out the ODP related function in case kernel
> was compiled without ODP support.
>=20
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  .../net/ethernet/mellanox/mlx5/core/main.c    | 47 +++++++++++++------
>  1 file changed, 33 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net=
/ethernet/mellanox/mlx5/core/main.c
> index 6d45518edbdc..d7145ab6105d 100644
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -459,6 +459,7 @@ static int handle_hca_cap_atomic(struct mlx5_core_dev=
 *dev)
>  	return err;
>  }
> =20
> +#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
>  static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
>  {
>  	void *set_hca_cap;
> @@ -502,6 +503,7 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *d=
ev)
>  	kfree(set_ctx);
>  	return err;
>  }
> +#endif
> =20
>  static int handle_hca_cap(struct mlx5_core_dev *dev)
>  {
> @@ -576,6 +578,35 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
>  	return err;
>  }
> =20
> +static int set_hca_cap(struct mlx5_core_dev *dev)
> +{
> +	struct pci_dev *pdev =3D dev->pdev;
> +	int err;
> +
> +	err =3D handle_hca_cap(dev);
> +	if (err) {
> +		dev_err(&pdev->dev, "handle_hca_cap failed\n");
> +		goto out;
> +	}
> +
> +	err =3D handle_hca_cap_atomic(dev);
> +	if (err) {
> +		dev_err(&pdev->dev, "handle_hca_cap_atomic failed\n");
> +		goto out;
> +	}
> +
> +#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> +	err =3D handle_hca_cap_odp(dev);
> +	if (err) {
> +		dev_err(&pdev->dev, "handle_hca_cap_odp failed\n");
> +		goto out;
> +	}
> +#endif

Adding=20
  if (IS_ENABLED..)=20
    return 0;

To the top of handle_hca_cap_odp is alot better.

Jason
