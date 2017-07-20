From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] usnic: add rtnl lock around
 __ethtool_get_link_ksettings()
Date: Thu, 20 Jul 2017 22:38:17 +0300
Message-ID: <20170720193816.GB2569@yuvallap>
References: <20170720182340.28864-1-gvaradar@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170720182340.28864-1-gvaradar-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Govindarajulu Varadarajan <gvaradar-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 20, 2017 at 11:23:39AM -0700, Govindarajulu Varadarajan wrote:
> __ethtool_get_link_ksettings requires rtnl lock. If not it throws the
> following warnning.
> 
> [ 1855.996191] RTNL: assertion failed at net/core/ethtool.c (564)
> [ 1855.997084] CPU: 12 PID: 1866 Comm: kworker/12:0 Not tainted 4.12.0+ #47
> [ 1855.997982] Hardware name: Cisco Systems Inc UCSC-C240-M4S2/UCSC-C240-M4S2, BIOS C240M4.2.0.12.503.0307172239 03/07/2017
> [ 1855.998949] Workqueue: infiniband ib_cache_task [ib_core]
> [ 1855.999920] Call Trace:
> [ 1856.000872]  dump_stack+0x63/0x8b
> [ 1856.001576] enic 0000:11:00.0 a0: Link DOWN
> [ 1856.002769]  __ethtool_get_link_ksettings+0xfe/0x110
> [ 1856.003733]  ? netlink_broadcast_filtered+0x14b/0x3a0
> [ 1856.004703]  usnic_ib_query_port+0x46/0x1c0 [usnic_verbs]
> [ 1856.005680]  ib_query_port+0x9e/0x120 [ib_core]
> [ 1856.006654]  ib_cache_update+0xcf/0x430 [ib_core]
> [ 1856.007621]  ? ib_cache_update+0xcf/0x430 [ib_core]
> [ 1856.008601]  ? netdev_run_todo+0x51/0x2f0
> [ 1856.009581]  ? linkwatch_do_dev+0x38/0x50
> [ 1856.010588]  ib_cache_task+0x1e/0x30 [ib_core]
> [ 1856.011564]  process_one_work+0x1bc/0x3e0
> [ 1856.012528]  worker_thread+0x4a/0x3a0
> [ 1856.013486]  kthread+0x125/0x140
> [ 1856.014437]  ? process_one_work+0x3e0/0x3e0
> [ 1856.015378]  ? kthread_create_on_node+0x40/0x40
> [ 1856.016318]  ret_from_fork+0x25/0x30
> 
> Signed-off-by: Govindarajulu Varadarajan <gvaradar-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
> v2: resubmit for changes in patch 2/2
> 
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> index 4996984885c2..03002bac93e7 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -331,7 +331,9 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
>  	usnic_dbg("\n");
>  
>  	mutex_lock(&us_ibdev->usdev_lock);
> +	rtnl_lock();
>  	__ethtool_get_link_ksettings(us_ibdev->netdev, &cmd);
> +	rtnl_unlock();

This, along with other similar places is already taking cared in a
patch-set i posted few weeks ago and reposed based on for-next few days
ago.
http://marc.info/?l=linux-rdma&m=150023353924211&w=2

Will appreciate if you can review it.

>  	/* props being zeroed by the caller, avoid zeroing it here */
>  
>  	props->lid = 0;
> -- 
> 2.13.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
