From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix a debug kernel crash
Date: Wed, 13 Apr 2016 10:47:43 +0300
Message-ID: <570DF99F.6080805@mellanox.com>
References: <570D6B06.8080204@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <570D6B06.8080204-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 4/13/2016 12:39 AM, Bart Van Assche wrote:
> Avoid that the following BUG() is triggered against a debug
> kernel:
>

Looks good.
Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 7672b19..30c3dfc 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1503,7 +1503,7 @@ static int srp_map_idb(struct srp_rdma_ch *ch, struct srp_request *req,
>
>   	if (dev->use_fast_reg) {
>   		state.sg = idb_sg;
> -		sg_set_buf(idb_sg, req->indirect_desc, idb_len);
> +		sg_init_one(idb_sg, req->indirect_desc, idb_len);
>   		idb_sg->dma_address = req->indirect_dma_addr; /* hack! */
>   #ifdef CONFIG_NEED_SG_DMA_LENGTH
>   		idb_sg->dma_length = idb_sg->length;	      /* hack^2 */
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
