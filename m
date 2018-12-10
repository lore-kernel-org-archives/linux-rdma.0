From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH mlx5-next 01/10] net/mlx5: Rework handling of port module events
Date: Mon, 10 Dec 2018 11:07:36 -0800
Message-ID: <CALzJLG8hNt5iUv6HTuS83DACm7MQkKCEdP+j=Pw-V447T0D14Q@mail.gmail.com>
References: <20181210030442.7543-1-saeedm@mellanox.com> <20181210030442.7543-2-saeedm@mellanox.com>
 <20181210160938.GE3459@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210160938.GE3459@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Linux Netdev List <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, migo@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 10, 2018 at 8:09 AM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Sun, Dec 09, 2018 at 07:04:33PM -0800, Saeed Mahameed wrote:
> > From: Mikhael Goikhman <migo@mellanox.com>
> >
> > Add explicit HW defined error values. For simplicity, keep counters for all
> > statuses starting from 0, although currently status=0 is not used.
> >
> > Additionally, when HW signals an unexpected cable status, it is reported
> > now rather than ignored. And status counter is now updated on errors.
> >
> > Signed-off-by: Mikhael Goikhman <migo@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> >  .../ethernet/mellanox/mlx5/core/en_stats.c    |  8 +-
> >  .../net/ethernet/mellanox/mlx5/core/events.c  | 83 ++++++++++++-------
> >  .../ethernet/mellanox/mlx5/core/lib/mlx5.h    | 19 ++---
> >  3 files changed, 65 insertions(+), 45 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> > index 748d23806391..881c54c12e19 100644
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> > @@ -1087,13 +1087,13 @@ static void mlx5e_grp_per_prio_update_stats(struct mlx5e_priv *priv)
> >  }
> >
> >  static const struct counter_desc mlx5e_pme_status_desc[] = {
> > -     { "module_unplug", 8 },
> > +     { "module_unplug",       sizeof(u64) * MLX5_MODULE_STATUS_UNPLUGGED },
> >  };
> >
> >  static const struct counter_desc mlx5e_pme_error_desc[] = {
> > -     { "module_bus_stuck", 16 },       /* bus stuck (I2C or data shorted) */
> > -     { "module_high_temp", 48 },       /* high temperature */
> > -     { "module_bad_shorted", 56 },    /* bad or shorted cable/module */
> > +     { "module_bus_stuck",    sizeof(u64) * MLX5_MODULE_EVENT_ERROR_BUS_STUCK },
> > +     { "module_high_temp",    sizeof(u64) * MLX5_MODULE_EVENT_ERROR_HIGH_TEMPERATURE },
> > +     { "module_bad_shorted",  sizeof(u64) * MLX5_MODULE_EVENT_ERROR_BAD_CABLE },
> >  };
> >
> >  #define NUM_PME_STATUS_STATS         ARRAY_SIZE(mlx5e_pme_status_desc)
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
> > index e92df7020a26..587d93ec905f 100644
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
> > @@ -157,23 +157,43 @@ static int temp_warn(struct notifier_block *nb, unsigned long type, void *data)
> >  }
> >
> >  /* MLX5_EVENT_TYPE_PORT_MODULE_EVENT */
> > -static const char *mlx5_pme_status[MLX5_MODULE_STATUS_NUM] = {
> > -     "Cable plugged",   /* MLX5_MODULE_STATUS_PLUGGED    = 0x1 */
> > -     "Cable unplugged", /* MLX5_MODULE_STATUS_UNPLUGGED  = 0x2 */
> > -     "Cable error",     /* MLX5_MODULE_STATUS_ERROR      = 0x3 */
> > -};
> > +static const char *mlx5_pme_status_to_string(enum port_module_event_status_type status)
> > +{
> > +     switch (status) {
> > +     case MLX5_MODULE_STATUS_PLUGGED:
> > +             return "Cable plugged";
> > +     case MLX5_MODULE_STATUS_UNPLUGGED:
> > +             return "Cable unplugged";
> > +     case MLX5_MODULE_STATUS_ERROR:
> > +             return "Cable error";
> > +     default:
> > +             return "Unknown status";
> > +     }
> > +}
>
> Arrays are usually a bette codegen bet than switch/case unless the array is
> very sparse, but it should be written as
>
>   [MLX5_MODULE_STATUS_PLUGGED] = "Cable plugged",
>
> Commit message should explain why this is being converted. Maybe it is
> very sparse?
>

In the next patch it will become sparse, due to:
      MLX5_MODULE_EVENT_ERROR_PCIE_POWER_SLOT_EXCEEDED = 0xc,

and it will need some  corner case handling to report "unknown" for the gaps.
I tend to agree that arrays are better but in this case they demanded
more code to handle corner cases
in the next patches.



> Jason
