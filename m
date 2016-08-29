From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/srp: use IB_PD_UNSAFE_GLOBAL_RKEY
Date: Mon, 29 Aug 2016 10:00:33 -0700
Message-ID: <df613e79-7c01-5fa6-5586-6f567254224b@sandisk.com>
References: <1472464943-29450-1-git-send-email-hch@lst.de>
 <1472464943-29450-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472464943-29450-5-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08/29/2016 03:02 AM, Christoph Hellwig wrote:
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
> index 26bb9b0..446f559 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.h
> +++ b/drivers/infiniband/ulp/srp/ib_srp.h
> @@ -90,7 +90,6 @@ struct srp_device {
>  	struct list_head	dev_list;
>  	struct ib_device       *dev;
>  	struct ib_pd	       *pd;
> -	struct ib_mr	       *global_mr;
>  	u64			mr_page_mask;
>  	int			mr_page_size;
>  	int			mr_max_size;
> @@ -179,7 +178,6 @@ struct srp_target_port {
>  	spinlock_t		lock;
>
>  	/* read only in the hot path */
> -	struct ib_mr		*global_mr;
>  	struct srp_rdma_ch	*ch;
>  	u32			ch_count;
>  	u32			lkey;

Hello Christoph,

Was it really necessary to remove these two member variables? If the 
per-PD global MR is ever removed all the code that uses 
pd->unsafe_global_rkey will have to be touched again. Keeping the two 
global_mr variables would reduce the number of load instructions the CPU 
has to perform while mapping SRP requests.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
