From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next v1 08/12] IB/mlx5: Introduce
 MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD
Date: Mon, 24 Jun 2019 11:51:03 +0000
Message-ID: <20190624115059.GA5479@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-9-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190618171540.11729-9-leon@kernel.org>
Content-Language: en-US
Content-ID: <05B2F1E9CF684640A4D5B2CDC86F9823@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 18, 2019 at 08:15:36PM +0300, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@mellanox.com>
>=20
> Introduce MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD and its initial
> implementation.
>=20
> This object is from type class FD and will be used to read DEVX
> async events.
>=20
> Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mlx5/devx.c         | 112 ++++++++++++++++++++--
>  include/uapi/rdma/mlx5_user_ioctl_cmds.h  |  10 ++
>  include/uapi/rdma/mlx5_user_ioctl_verbs.h |   4 +
>  3 files changed, 116 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/ml=
x5/devx.c
> index 80b42d069328..1815ce0f8daf 100644
> +++ b/drivers/infiniband/hw/mlx5/devx.c
> @@ -33,6 +33,24 @@ struct devx_async_data {
>  	struct mlx5_ib_uapi_devx_async_cmd_hdr hdr;
>  };
> =20
> +struct devx_async_event_queue {

It seems to be a mistake to try and re-use the async_event_queue for
both cmd and event, as they use it very differently and don't even
store the same things in the event_list. I think it is bettter to just
inline this into devx_async_event_file (and inline the old struct in
the cmd file

> +	spinlock_t		lock;
> +	wait_queue_head_t	poll_wait;
> +	struct list_head	event_list;
> +	atomic_t		bytes_in_use;
> +	u8			is_destroyed:1;
> +	u32			flags;
> +};

All the flags testing is ugly, why not just add another bitfield?

> +
> +struct devx_async_event_file {
> +	struct ib_uobject		uobj;
> +	struct list_head subscribed_events_list; /* Head of events that are
> +						  * subscribed to this FD
> +						  */
> +	struct devx_async_event_queue	ev_queue;
> +	struct mlx5_ib_dev *dev;
> +};
> +

Crazy indenting

> diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi/rdm=
a/mlx5_user_ioctl_verbs.h
> index a8f34c237458..57beea4589e4 100644
> +++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
> @@ -63,5 +63,9 @@ enum mlx5_ib_uapi_dm_type {
>  	MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM,
>  };
> =20
> +enum mlx5_ib_uapi_devx_create_event_channel_flags {
> +	MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA =3D 1
> << 0,

Maybe this name is too long

Jason
