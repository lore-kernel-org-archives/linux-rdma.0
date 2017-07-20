From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] usnic: do not ignore return value of
 __ethtool_get_link_ksettings
Date: Thu, 20 Jul 2017 22:39:42 +0300
Message-ID: <20170720193941.GC2569@yuvallap>
References: <20170720182340.28864-1-gvaradar@cisco.com>
 <20170720182340.28864-2-gvaradar@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170720182340.28864-2-gvaradar-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Govindarajulu Varadarajan <gvaradar-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 20, 2017 at 11:23:40AM -0700, Govindarajulu Varadarajan wrote:
> Do not ignore the return value of the caller.
> 
> Signed-off-by: Govindarajulu Varadarajan <gvaradar-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
> v2: Do not initialize err as it is over written later
> 
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> index 03002bac93e7..f7be74740b3f 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -327,13 +327,16 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
>  {
>  	struct usnic_ib_dev *us_ibdev = to_usdev(ibdev);
>  	struct ethtool_link_ksettings cmd;
> +	int err;
>  
>  	usnic_dbg("\n");
>  
>  	mutex_lock(&us_ibdev->usdev_lock);
>  	rtnl_lock();
> -	__ethtool_get_link_ksettings(us_ibdev->netdev, &cmd);
> +	err = __ethtool_get_link_ksettings(us_ibdev->netdev, &cmd);

Same here, already handled in http://marc.info/?l=linux-rdma&m=150023353924211&w=2

>  	rtnl_unlock();
> +	if (err)
> +		goto out;
>  	/* props being zeroed by the caller, avoid zeroing it here */
>  
>  	props->lid = 0;
> @@ -364,9 +367,10 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
>  	/* Userspace will adjust for hdrs */
>  	props->max_msg_sz = us_ibdev->ufdev->mtu;
>  	props->max_vl_num = 1;
> +out:
>  	mutex_unlock(&us_ibdev->usdev_lock);
>  
> -	return 0;
> +	return err;
>  }
>  
>  int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
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
