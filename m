From: Honggang LI <honli@redhat.com>
Subject: Re: [PATCH 2/2] IB/core: Set width to 1X for invalid active widths
 when port is down
Date: Thu, 15 Mar 2018 20:43:42 +0800
Message-ID: <20180315124342.GA29859@dhcp-13-42.nay.redhat.com>
References: <20180315090214.21706-1-honli@redhat.com>
 <20180315090214.21706-3-honli@redhat.com>
 <74460de7-9603-146b-28ec-2e16b8b5bb52@dev.mellanox.co.il>
 <f3d70fc6-08ec-3af1-90c3-a0a431c81ce2@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f3d70fc6-08ec-3af1-90c3-a0a431c81ce2@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, noaos@mellanox.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 15, 2018 at 08:32:02AM -0400, Hal Rosenstock wrote:
> On 3/15/2018 8:01 AM, Hal Rosenstock wrote:
> > On 3/15/2018 5:02 AM, Honggang LI wrote:
> >> From: Honggang Li <honli@redhat.com>
> >>
> >> commit f1b65df5a232 ("IB/mlx5: Add support for active_width and
> >> active_speed in RoCE"). Before this patch applied, the mlx5_ib
> >> driver set default active_width and active_speed to IB_WIDTH_4X
> >> and IB_SPEED_QDR.
> >>
> >> When the RoCE port is down, the RoCE port did not negotiate the
> >> active width with remote side. The active width is zero. If run
> >> ibstat to require the port status, ibstat will panic as it read
> >> invalid width from sys file.
> >>
> >> Signed-off-by: Honggang Li <honli@redhat.com>
> >> ---
> >>  drivers/infiniband/core/sysfs.c | 15 +++++++++++----
> >>  1 file changed, 11 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
> >> index cf36ff1f0068..722e4571f4d2 100644
> >> --- a/drivers/infiniband/core/sysfs.c
> >> +++ b/drivers/infiniband/core/sysfs.c
> >> @@ -240,6 +240,7 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
> >>  	struct ib_port_attr attr;
> >>  	char *speed = "";
> >>  	int rate;		/* in deci-Gb/sec */
> >> +	int width;
> >>  	ssize_t ret;
> >>  
> >>  	ret = ib_query_port(p->ibdev, p->port_num, &attr);
> >> @@ -278,13 +279,19 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
> >>  		break;
> >>  	}
> >>  
> >> -	rate *= ib_width_enum_to_int(attr.active_width);
> >> -	if (rate < 0)
> >> -		return -EINVAL;
> >> +	width = ib_width_enum_to_int(attr.active_width);
> >> +	if (width < 0) {
> >> +		if (attr.state != IB_PORT_ACTIVE)
> > 
> > Link width is valid in any PortState other than Down so I think that
> > this check should be:
> > 		if (attr.state != IB_PORT_DOWN)
> > 
> > However, I don't think overriding width should be needed for this case
> > and just returning -EINVAL should be fine regardless of port state.
> > AFAIK it's the driver responsibility to populate acceptable defaults for
> > such parameters. What driver(s) have this issue ? Shouldn't it be fixed
> > there rather than here ?
> 
> I just noticed that you reference commit f1b65df5a232 ("IB/mlx5: Add
> support for active_width and active_speed in RoCE"). Before this patch
> applied, the mlx5_ib driver set default active_width and active_speed to
> IB_WIDTH_4X and IB_SPEED_QDR.
> 
> Should the fix be to hw/mlx5/main.c:translate_eth_proto_oper which now has:
> 
>         switch (eth_proto_oper) {
> ...
>         default:
>                 return -EINVAL;
>         }
> 
>         return 0;
> 
> and change default case to:
> 		*active_width = IB_WIDTH_1X;
> 
> ?

I suggest to restore previous behavior before apply f1b65df5a232.

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 033b6af90de9..0d73d2772d9b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -388,6 +388,9 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	if (err)
 		goto out;
 
+        props->active_width     = IB_WIDTH_4X;
+        props->active_speed     = IB_SPEED_QDR;
+
 	translate_eth_proto_oper(eth_prot_oper, &props->active_speed,
 				 &props->active_width);
 
