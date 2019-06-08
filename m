From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next 1/3] net/mlx5: Expose eswitch encap mode
Date: Sat, 8 Jun 2019 11:25:01 +0300
Message-ID: <20190608082500.GQ5261@mtr-leonro.mtl.com>
References: <20190606110609.11588-1-leon@kernel.org>
 <20190606110609.11588-2-leon@kernel.org>
 <VI1PR0501MB227150ADAFACF4A5DEC26693D1170@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0501MB227150ADAFACF4A5DEC26693D1170@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mark Bloch <markb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 06, 2019 at 01:08:46PM +0000, Parav Pandit wrote:
>
>
> > -----Original Message-----
> > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> > Sent: Thursday, June 6, 2019 4:36 PM
> > To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
> > <jgg@mellanox.com>
> > Cc: Leon Romanovsky <leonro@mellanox.com>; RDMA mailing list <linux-
> > rdma@vger.kernel.org>; Maor Gottlieb <maorg@mellanox.com>; Mark Bloch
> > <markb@mellanox.com>; Saeed Mahameed <saeedm@mellanox.com>;
> > linux-netdev <netdev@vger.kernel.org>
> > Subject: [PATCH mlx5-next 1/3] net/mlx5: Expose eswitch encap mode
> >
> > From: Maor Gottlieb <maorg@mellanox.com>
> >
> > Add API to get the current Eswitch encap mode.
> > It will be used in downstream patches to check if flow table can be created
> > with encap support or not.
> >
> > Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 10 ++++++++++
> >  include/linux/mlx5/eswitch.h                      | 10 ++++++++++
> >  2 files changed, 20 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> > index 9ea0ccfe5ef5..1da7f9569ee8 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> > @@ -2452,6 +2452,16 @@ u8 mlx5_eswitch_mode(struct mlx5_eswitch
> > *esw)  }  EXPORT_SYMBOL_GPL(mlx5_eswitch_mode);
> >
> > +u16 mlx5_eswitch_get_encap_mode(struct mlx5_core_dev *dev) {
>
> Encap mode as well defined devlink definition.
> So instead of u16, it should return enum devlink_eswitch_encap_mode.
>
> Since this is only reading the mode, it is better to define struct mlx5_core_dev* as const struct mlx5_core_dev *.

Thanks Parav, I'll change and resend, anyway second patch uses wrong types too.
