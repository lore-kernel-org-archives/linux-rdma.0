From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [RFC 2/2] mlx5: Sample code to exercise new device statistics
Date: Fri, 4 Mar 2016 13:12:10 -0600
Message-ID: <00cb01d17649$c0deeba0$429cc2e0$@opengridcomputing.com>
References: <20160304183854.551339866@linux.com> <20160304183909.703201393@linux.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160304183909.703201393-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Lameter' <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Christoph Lameter
> Sent: Friday, March 04, 2016 12:39 PM
> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Mark Bloch; Jason Gunthorpe; Steve Wise
> Subject: [RFC 2/2] mlx5: Sample code to exercise new device statistics
> 
> Just put some counters out to allow the testing of the new ib statistics.
> 
> Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/sysfs.c             | 298 ++++++++++++++++------------
>  drivers/infiniband/hw/cxgb3/iwch_provider.c | 136 +++++++++----
>  drivers/infiniband/hw/cxgb4/provider.c      |  26 ++-
>  drivers/infiniband/hw/mlx5/main.c           |  35 ++++
>  include/rdma/ib_verbs.h                     |  60 +-----
>  5 files changed, 335 insertions(+), 220 deletions(-)
>

The diffstat shows changes to cxgb3/4 yet there are no changes in the patch.

 
> Index: linux/drivers/infiniband/hw/mlx5/main.c
> ===================================================================
> --- linux.orig/drivers/infiniband/hw/mlx5/main.c	2016-03-03 13:13:50.471454368 -0600
> +++ linux/drivers/infiniband/hw/mlx5/main.c	2016-03-03 13:13:50.469454440 -0600
> @@ -2122,6 +2122,40 @@ static int mlx5_port_immutable(struct ib
>  	return 0;
>  }
> 
> +static char *names[] = {
> +	"tcpInSegs",
> +	"tcpOutSegs",
> +	"tcpRetransSegs",
> +	"tcpOutRsts",
> +	NULL
> +};
> +
> +static char *port_names[] = {
> +	"p1",
> +	NULL
> +};
> +
> +static int mlx5_get_protocol_stats(struct ib_device *ibdev,
> +				   struct rdma_protocol_stats *stats,
> +				   u8 port)
> +{
> +	if (port != 0) {
> +		stats->name = port_names;
> +		stats->dirname = "ib_stats";
> +		stats->value[0] = 1;
> +		return 0;
> +	}
> +	stats->value[0] = 1;
> +	stats->value[1] = 2;
> +	stats->value[2] = 3;
> +	stats->value[3] = 4;
> +
> +	stats->name = names;
> +	stats->dirname = "ib_stats";
> +
> +	return 0;
> +}
> +
>  static int mlx5_enable_roce(struct mlx5_ib_dev *dev)
>  {
>  	int err;
> @@ -2266,6 +2300,7 @@ static void *mlx5_ib_add(struct mlx5_cor
>  	dev->ib_dev.map_mr_sg		= mlx5_ib_map_mr_sg;
>  	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
>  	dev->ib_dev.get_port_immutable  = mlx5_port_immutable;
> +	dev->ib_dev.get_protocol_stats	= mlx5_get_protocol_stats;
> 
>  	mlx5_ib_internal_fill_odp_caps(dev);
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
