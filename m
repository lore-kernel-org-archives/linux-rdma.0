From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next v1 12/12] IB/mlx5: Add DEVX support for CQ
 events
Date: Mon, 24 Jun 2019 12:04:20 +0000
Message-ID: <20190624120416.GE5479@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-13-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190618171540.11729-13-leon@kernel.org>
Content-Language: en-US
Content-ID: <60761A0C778A3E4BAF0B53E1E2474CBF@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 18, 2019 at 08:15:40PM +0300, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
>=20
> Add DEVX support for CQ events by creating and destroying the CQ via
> mlx5_core and set an handler to manage its completions.
>=20
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/devx.c | 40 +++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/ml=
x5/devx.c
> index 49fdce95d6d9..91ccd58ebc05 100644
> +++ b/drivers/infiniband/hw/mlx5/devx.c
> @@ -19,9 +19,12 @@
>  #define UVERBS_MODULE_NAME mlx5_ib
>  #include <rdma/uverbs_named_ioctl.h>
> =20
> +static void dispatch_event_fd(struct list_head *fd_list, const void *dat=
a);
> +
>  enum devx_obj_flags {
>  	DEVX_OBJ_FLAGS_INDIRECT_MKEY =3D 1 << 0,
>  	DEVX_OBJ_FLAGS_DCT =3D 1 << 1,
> +	DEVX_OBJ_FLAGS_CQ =3D 1 << 2,
>  };
> =20
>  struct devx_async_data {
> @@ -94,6 +97,7 @@ struct devx_async_event_file {
>  #define MLX5_MAX_DESTROY_INBOX_SIZE_DW MLX5_ST_SZ_DW(delete_fte_in)
>  struct devx_obj {
>  	struct mlx5_core_dev	*mdev;
> +	struct mlx5_ib_dev	*ib_dev;

This seems strange, why would we need to store the core_dev and the ib_dev
in a struct when ibdev->mdev =3D=3D core_dev?

Jason
