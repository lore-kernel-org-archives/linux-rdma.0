From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] IB/core: off by one in error handling
Date: Fri, 28 Aug 2015 21:18:00 -0400
Message-ID: <20150829011800.GB2713@phlsvsds.ph.intel.com>
References: <20150818092317.GF3965@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150818092317.GF3965@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 18, 2015 at 12:23:17PM +0300, Dan Carpenter wrote:
> This is a zero offset array.  The current code could try to free random
> memory and crash.  Also it leaks the first element.
> 
> Fixes: 230145ff8124 ('IB/core: Add RoCE GID table management')
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

I don't actually see this in Dougs to-be-rebased/for-4.3 tree.

Looks like Doug picked up a different version of the patch in the latest
rebase.

annotating cache.c I see a different change from Matan in commit

76680c1cfc5ab

+rollback_table_setup:
+       for (port = 0; port < ib_dev->phys_port_cnt; port++) {
+               cleanup_gid_table_port(ib_dev, port + rdma_start_port(ib_dev),
+                                      table[port]);
+               release_gid_table(table[port]);
+       }

Ira

> 
> diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
> index a9d5c70..f5d14a7 100644
> --- a/drivers/infiniband/core/cache.c
> +++ b/drivers/infiniband/core/cache.c
> @@ -582,7 +582,7 @@ static int _gid_table_setup_one(struct ib_device *ib_dev)
>  	return 0;
>  
>  rollback_table_setup:
> -	for (port = 1; port <= ib_dev->phys_port_cnt; port++)
> +	for (port = 0; port < ib_dev->phys_port_cnt; port++)
>  		free_gid_table(ib_dev, port, table[port]);
>  
>  	kfree(table);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
