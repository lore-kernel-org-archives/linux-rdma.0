From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH rdma-next v1 09/12] IB/mlx5: Register DEVX with mlx5_core
 to get async events
Date: Mon, 24 Jun 2019 14:30:51 +0000
Message-ID: <20190624143047.GD7418@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-10-leon@kernel.org>
 <20190624115206.GB5479@mellanox.com>
 <3bc6780f-5c3e-b121-e4ea-f7b8f00cbd13@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <3bc6780f-5c3e-b121-e4ea-f7b8f00cbd13@dev.mellanox.co.il>
Content-Language: en-US
Content-ID: <C68FF18D75BE184DAA10F58247D6D7A2@eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Yishai Hadas <yishaih@dev.mellanox.co.il>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 04:36:44PM +0300, Yishai Hadas wrote:
> On 6/24/2019 2:52 PM, Jason Gunthorpe wrote:
> > On Tue, Jun 18, 2019 at 08:15:37PM +0300, Leon Romanovsky wrote:
> > >   void __mlx5_ib_remove(struct mlx5_ib_dev *dev,
> > > diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniban=
d/hw/mlx5/mlx5_ib.h
> > > index 9cf23ae6324e..556af34b788b 100644
> > > +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> > > @@ -944,6 +944,13 @@ struct mlx5_ib_pf_eq {
> > >   	mempool_t *pool;
> > >   };
> > > +struct mlx5_devx_event_table {
> > > +	struct mlx5_nb devx_nb;
> > > +	/* serialize updating the event_xa */
> > > +	struct mutex event_xa_lock;
> > > +	struct xarray event_xa;
> > > +};
> > > +
> > >   struct mlx5_ib_dev {
> > >   	struct ib_device		ib_dev;
> > >   	struct mlx5_core_dev		*mdev;
> > > @@ -994,6 +1001,7 @@ struct mlx5_ib_dev {
> > >   	struct mlx5_srq_table   srq_table;
> > >   	struct mlx5_async_ctx   async_ctx;
> > >   	int			free_port;
> > > +	struct mlx5_devx_event_table devx_event_table;
> >=20
> > I really question if adding all these structs really does anything for
> > readability..
> >=20
>=20
> I would prefer this option to add only one structure (i.e.
> mlx5_devx_event_table) on ib_dev, it will hold internally the other relat=
ed
> stuff.

It seems confounding but generally is the style in this struct :\

Jason
