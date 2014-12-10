From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH ] mlx4_core: Enhance device capabilities flags debug
 printouts
Date: Wed, 10 Dec 2014 10:25:41 +0200
Message-ID: <20141210082540.GB2998@yuval-lab>
References: <1417996112-19060-1-git-send-email-yuval.shaia@oracle.com>
 <CAJ3xEMgjP0V7h7mRTr84NLW3Rib-QLN8j0rbEk5_MRvORXbDMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMgjP0V7h7mRTr84NLW3Rib-QLN8j0rbEk5_MRvORXbDMQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 09, 2014 at 07:55:07PM +0200, Or Gerlitz wrote:
> On Mon, Dec 8, 2014 at 1:48 AM, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > 1. Add indication whether feature is supported or not.
> > 2. Add descriptions of all features.
> > Without this fix there is no way to tell if feature is not supported or that description is not exist.
> 
> 
> The problem with this patch is that the current practice is to only
> advertize a feature as a string in this table when **both** the driver
> and the firmware support it.
I proposed this fix when faced feature which supported by FW and by the driver but was not printed out (auto-sense).
This shows that the current practice is hard to maintain, when developer implement feature in driver he *must remember* also to add string here.

The function is called dump_dev_cap_flags so why not used it to dump device capability flags?
> 
> We can make a fix here to add dumping for features which are currently
> supported on that level but not dumped today (e.g WoL and such).
See my note above - this will be hard to maintain.
Maybe, as suggestion, we should have the equivalent priv.driver_cap_flags, and dump function will print the merged flags (binary and them)?
> 
> You can have a look on the MLX4_DEV_CAP_FLAG_ enum under
> include/linux/mlx4/device.h to pick up such values (used by the driver
> but aren't dumped as dev-caps)
> 
> Or.
> 
> 
> >
> > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/net/ethernet/mellanox/mlx4/fw.c |   37 +++++++++++++++++++++++++++---
> >  1 files changed, 33 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
> > index 2e88a23..79ab326 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/fw.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
> > @@ -91,7 +91,10 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
> >                 [ 8] = "P_Key violation counter",
> >                 [ 9] = "Q_Key violation counter",
> >                 [10] = "VMM",
> > +               [11] = "Fibre Channel Protocol On Ethernet Ports support",
> >                 [12] = "Dual Port Different Protocol (DPDP) support",
> > +               [13] = "Raw Ethertype support",
> > +               [14] = "Raw IPv6 support",
> >                 [15] = "Big LSO headers",
> >                 [16] = "MW support",
> >                 [17] = "APM support",
> > @@ -99,16 +102,40 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
> >                 [19] = "Raw multicast support",
> >                 [20] = "Address vector port checking support",
> >                 [21] = "UD multicast support",
> > +               [22] = "UD IPv4 Multicast support",
> >                 [24] = "Demand paging support",
> >                 [25] = "Router support",
> > +               [26] = "L2 Ethernet Multicast support",
> > +               [28] = "Software parsing support for UD transport",
> > +               [29] = "TCP checksum off-load support",
> >                 [30] = "IBoE support",
> > +               [31] = "FCoE T11 frame format support",
> >                 [32] = "Unicast loopback support",
> > +               [33] = "Multicast loopback support",
> >                 [34] = "FCS header control",
> > +               [35] = "Address Path ud_force_mgid support",
> > +               [36] = "Header-Data Split support",
> > +               [37] = "Wake On LAN support on port 1",
> > +               [38] = "Wake On LAN support on port 2",
> > +               [39] = "Fatal Warning Event upon a thermal warning condition",
> >                 [38] = "Wake On LAN support",
> >                 [40] = "UDP RSS support",
> >                 [41] = "Unicast VEP steering support",
> >                 [42] = "Multicast VEP steering support",
> > +               [43] = "VLAN Steering mechanism support",
> > +               [44] = "Steering according to EtherType support",
> > +               [45] = "WQE format version 1 support",
> > +               [46] = "Keep Alive Validiation support",
> > +               [47] = "PTP1588 support",
> >                 [48] = "Counters support",
> > +               [49] = "Advanced Counters support",
> > +               [50] = "Force Ethernet user priority from QPC support",
> > +               [51] = "RX Port Num check disabled",
> > +               [52] = "RSS on fragmented IP datagram support",
> > +               [55] = "Link Sensing support",
> > +               [56] = "Reliable Multicast support",
> > +               [57] = "Fast Drop support",
> > +               [58] = "Protected FMR support",
> >                 [53] = "Port ETS Scheduler support",
> >                 [55] = "Port link type sensing support",
> >                 [59] = "Port management change event support",
> > @@ -119,8 +146,9 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u64 flags)
> >
> >         mlx4_dbg(dev, "DEV_CAP flags:\n");
> >         for (i = 0; i < ARRAY_SIZE(fname); ++i)
> > -               if (fname[i] && (flags & (1LL << i)))
> > -                       mlx4_dbg(dev, "    %s\n", fname[i]);
> > +               if (fname[i])
> > +                       mlx4_dbg(dev, "    (%c) %s\n", (flags & (1LL << i)) ?
> > +                                '*' : ' ', fname[i]);
> >  }
> >
> >  static void dump_dev_cap_flags2(struct mlx4_dev *dev, u64 flags)
> > @@ -144,8 +172,9 @@ static void dump_dev_cap_flags2(struct mlx4_dev *dev, u64 flags)
> >         int i;
> >
> >         for (i = 0; i < ARRAY_SIZE(fname); ++i)
> > -               if (fname[i] && (flags & (1LL << i)))
> > -                       mlx4_dbg(dev, "    %s\n", fname[i]);
> > +               if (fname[i])
> > +                       mlx4_dbg(dev, "    (%c) %s\n", (flags & (1LL << i)) ?
> > +                                '*' : ' ', fname[i]);
> >  }
> >
> >  int mlx4_MOD_STAT_CFG(struct mlx4_dev *dev, struct mlx4_mod_stat_cfg *cfg)
> > --
> > 1.7.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
