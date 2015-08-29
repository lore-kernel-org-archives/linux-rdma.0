From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] IB/core: missing curly braces in ib_find_gid()
Date: Fri, 28 Aug 2015 21:10:41 -0400
Message-ID: <20150829011040.GA2713@phlsvsds.ph.intel.com>
References: <20150818092210.GE3965@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150818092210.GE3965@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 18, 2015 at 12:22:10PM +0300, Dan Carpenter wrote:
> Smatch says that, based on the indenting, we should probably add curly
> braces here.
> 
> Fixes: 230145ff8124 ('IB/core: Add RoCE GID table management')
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> 
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 258b3f7..5d5bbae 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -807,9 +807,10 @@ int ib_find_gid(struct ib_device *device, union ib_gid *gid,
>  	for (port = rdma_start_port(device); port <= rdma_end_port(device); ++port) {
>  		if (rdma_cap_roce_gid_table(device, port)) {
>  			if (!ib_cache_gid_find_by_port(device, gid, port,
> -						       NULL, index))
> +						       NULL, index)) {
>  				*port_num = port;
>  				return 0;
> +			}
>  		}
>  
>  		for (i = 0; i < device->port_immutable[port].gid_tbl_len; ++i) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
