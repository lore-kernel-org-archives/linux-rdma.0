From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next v1 08/12] IB/mlx5: Introduce
 MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD
Date: Mon, 24 Jun 2019 14:30:19 +0000
Message-ID: <20190624143016.GC7418@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-9-leon@kernel.org> <20190624115059.GA5479@mellanox.com>
 <baae74b9-94ff-9f5a-0992-c1eec5049306@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <baae74b9-94ff-9f5a-0992-c1eec5049306@dev.mellanox.co.il>
Content-Language: en-US
Content-ID: <C5E69717CEF56D4CA091E76CCD5397A4@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Yishai Hadas <yishaih@dev.mellanox.co.il>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 04:25:37PM +0300, Yishai Hadas wrote:
> On 6/24/2019 2:51 PM, Jason Gunthorpe wrote:
> > On Tue, Jun 18, 2019 at 08:15:36PM +0300, Leon Romanovsky wrote:
> > > From: Yishai Hadas <yishaih@mellanox.com>
> > >=20
> > > Introduce MLX5_IB_OBJECT_DEVX_ASYNC_EVENT_FD and its initial
> > > implementation.
> > >=20
> > > This object is from type class FD and will be used to read DEVX
> > > async events.
> > >=20
> > > Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
> > > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > >   drivers/infiniband/hw/mlx5/devx.c         | 112 +++++++++++++++++++=
+--
> > >   include/uapi/rdma/mlx5_user_ioctl_cmds.h  |  10 ++
> > >   include/uapi/rdma/mlx5_user_ioctl_verbs.h |   4 +
> > >   3 files changed, 116 insertions(+), 10 deletions(-)
> > >=20
> > > diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/h=
w/mlx5/devx.c
> > > index 80b42d069328..1815ce0f8daf 100644
> > > +++ b/drivers/infiniband/hw/mlx5/devx.c
> > > @@ -33,6 +33,24 @@ struct devx_async_data {
> > >   	struct mlx5_ib_uapi_devx_async_cmd_hdr hdr;
> > >   };
> > > +struct devx_async_event_queue {
> >=20
> > It seems to be a mistake to try and re-use the async_event_queue for
> > both cmd and event, as they use it very differently and don't even
> > store the same things in the event_list. I think it is bettter to just
> > inline this into devx_async_event_file (and inline the old struct in
> > the cmd file
> >=20
>=20
> How about having another struct with all the event's queue fields togethe=
r ?
> this has the benefit of having all those related fields in one place and
> leave the cmd as is.
>=20
> Alternatively,
> We can inline the event stuff under devx_async_event_file and leave the c=
md
> for now under a struct as it's not directly related to this series.

I would probbaly do this

> > > +	spinlock_t		lock;
> > > +	wait_queue_head_t	poll_wait;
> > > +	struct list_head	event_list;
> > > +	atomic_t		bytes_in_use;
> > > +	u8			is_destroyed:1;
> > > +	u32			flags;
> > > +};
> >=20
> > All the flags testing is ugly, why not just add another bitfield?
>=20
> The flags are coming from user space and have their different name space,=
 I
> prefer to not mix with kernel ones. (i.e. is_destroyed).
> Makes sense ?

No, better to add a bitfield than store the raw flags and another
bitfield.

> > > diff --git a/include/uapi/rdma/mlx5_user_ioctl_verbs.h b/include/uapi=
/rdma/mlx5_user_ioctl_verbs.h
> > > index a8f34c237458..57beea4589e4 100644
> > > +++ b/include/uapi/rdma/mlx5_user_ioctl_verbs.h
> > > @@ -63,5 +63,9 @@ enum mlx5_ib_uapi_dm_type {
> > >   	MLX5_IB_UAPI_DM_TYPE_HEADER_MODIFY_SW_ICM,
> > >   };
> > > +enum mlx5_ib_uapi_devx_create_event_channel_flags {
> > > +	MLX5_IB_UAPI_DEVX_CREATE_EVENT_CHANNEL_FLAGS_OMIT_EV_DATA =3D 1
> > > << 0,
> >=20
> > Maybe this name is too long
>=20
> Quite long but follows the name scheme having the UAPI prefix.
> Any shorter suggestion ?
>=20

I think you should shorten it

Jason
