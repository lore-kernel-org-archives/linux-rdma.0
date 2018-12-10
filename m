From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH mlx5-next 08/10] net/mlx5: Support extended destination
 format in flow steering command
Date: Mon, 10 Dec 2018 11:13:32 -0800
Message-ID: <CALzJLG-Oqw2Kj556rx674BgHHu8mquVbBh8s51zo1Zh2+3WcZQ@mail.gmail.com>
References: <20181210030442.7543-1-saeedm@mellanox.com> <20181210030442.7543-9-saeedm@mellanox.com>
 <20181210161614.GG3459@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210161614.GG3459@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Linux Netdev List <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, elibr@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 10, 2018 at 8:17 AM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Sun, Dec 09, 2018 at 07:04:40PM -0800, Saeed Mahameed wrote:
> > From: Eli Britstein <elibr@mellanox.com>
> >
> > Update the flow steering command formatting according to the extended
> > destination API.
> > Note that the FW dictates that multi destination FTEs that involve at
> > least one encap must use the extended destination format, while single
> > destination ones must use the legacy format.
> > Using extended destination format requires FW support. Check for its
> > capabilities and return error if not supported.
> >
> > Signed-off-by: Eli Britstein <elibr@mellanox.com>
> > Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
> > Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> >  .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  | 80 +++++++++++++++++--
> >  include/linux/mlx5/fs.h                       |  2 +
> >  2 files changed, 75 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
> > index dda63dedaa49..a18fbea7a931 100644
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
> > @@ -308,22 +308,68 @@ static int mlx5_cmd_destroy_flow_group(struct mlx5_core_dev *dev,
> >       return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
> >  }
> >
> > +static int mlx5_set_extended_dest(struct mlx5_core_dev *dev,
> > +                               struct fs_fte *fte, bool *extended_dest)
> > +{
> > +     int fw_log_max_fdb_encap_uplink =
> > +             MLX5_CAP_ESW(dev, log_max_fdb_encap_uplink);
> > +     int num_fwd_destinations = 0;
> > +     struct mlx5_flow_rule *dst;
> > +     int num_encap = 0;
> > +
> > +     *extended_dest = false;
> > +     if (!(fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST))
> > +             return 0;
> > +
> > +     list_for_each_entry(dst, &fte->node.children, node.list) {
> > +             if (dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_COUNTER)
> > +                     continue;
> > +             if (dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_VPORT &&
> > +                 dst->dest_attr.vport.flags & MLX5_FLOW_DEST_VPORT_REFORMAT_ID)
> > +                     num_encap++;
> > +             num_fwd_destinations++;
> > +     }
> > +     if (num_fwd_destinations > 1 && num_encap > 0)
> > +             *extended_dest = true;
> > +
> > +     if (*extended_dest && !fw_log_max_fdb_encap_uplink) {
> > +             pr_warn("FW does not support extended destination");
> > +             return -EOPNOTSUPP;
> > +     }
> > +     if (num_encap > (1 << fw_log_max_fdb_encap_uplink)) {
> > +             pr_warn("FW does not support more than %d encaps",
> > +                     1 << fw_log_max_fdb_encap_uplink);
>
> Drivers should avoid using pr_ if they have an struct device, in this
> case &dev->pdev->dev ..
>

Yes ! we will fix this in V2

> This is probably a comment for the entire core code directory I
> suppose?

yes a future patch, a grep shows some places that can be fixed.

>
> Jason
