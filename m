From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v3 for-next 1/2] RDMA/hns: Add detailed comments for mb()
 call
Date: Thu, 28 Dec 2017 08:55:19 -0700
Message-ID: <20171228155519.GT25436@ziepe.ca>
References: <1514470683-6972-1-git-send-email-liuyixian@huawei.com>
 <1514470683-6972-2-git-send-email-liuyixian@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1514470683-6972-2-git-send-email-liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 28, 2017 at 10:18:02PM +0800, Yixian Liu wrote:
> This patch adds more detailed comments when we call the
> memory barrier function, such as rmb, wmb and mb. Three
> mb() callers are deleted since they are unnecessary.
> 
> v3:
> 1. Subsitute rmb() with dma_rmb() according to Jason's comment,
>    since using dma_rmb() is enough.

This is such a big improvement, thanks

> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> index 6100ace..47ef90b 100644
> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
> @@ -3963,7 +3963,10 @@ static void set_eq_cons_index_v1(struct hns_roce_eq *eq, int req_not)
>  {
>  	roce_raw_write((eq->cons_index & HNS_ROCE_V1_CONS_IDX_M) |
>  		      (req_not << eq->log_entries), eq->doorbell);
> -	/* Memory barrier */
> +
> +	/* Make sure we update the consumer index of EQ before
> +	 * accessing it later
> +	 */
>  	mb();
>  }

This (and the other one below like it) is the only one that puzzles
me..

What are you trying to accomplish here? It looks like cons_index is
the tail pointer for a ring that the device DMA's into? And the
dma_rmb seems properly placed, so no barrier should be needed for DMA
when updating the tail pointer.

Is the barrier attempting to protect eq->cons_index in system memory?
If yes, shouldn't it be an atomic and/or locked?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
