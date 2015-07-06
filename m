From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] rds: rds_ib_device.refcount overflow
Date: Mon, 6 Jul 2015 09:18:24 +0300
Message-ID: <559A1DB0.5010003@mellanox.com>
References: <1435121680-11491-1-git-send-email-wen.gang.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435121680-11491-1-git-send-email-wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 24/06/2015 07:54, Wengang Wang wrote:
> There lacks a dropping on rds_ib_device.refcount in case rds_ib_alloc_fmr
> failed(mr pool running out). this lead to the refcount overflow.
> 
> A complain in line 117(see following) is seen. From vmcore:
> s_ib_rdma_mr_pool_depleted is 2147485544 and rds_ibdev->refcount is -2147475448.
> That is the evidence the mr pool is used up. so rds_ib_alloc_fmr is very likely
> to return ERR_PTR(-EAGAIN).
> 
> 115 void rds_ib_dev_put(struct rds_ib_device *rds_ibdev)
> 116 {
> 117         BUG_ON(atomic_read(&rds_ibdev->refcount) <= 0);
> 118         if (atomic_dec_and_test(&rds_ibdev->refcount))
> 119                 queue_work(rds_wq, &rds_ibdev->free_work);
> 120 }
> 
> fix is to drop refcount when rds_ib_alloc_fmr failed.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  net/rds/ib_rdma.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index 273b8bf..657ba9f 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -759,8 +759,10 @@ void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
>  	}
>  
>  	ibmr = rds_ib_alloc_fmr(rds_ibdev);
> -	if (IS_ERR(ibmr))
> +	if (IS_ERR(ibmr)) {
> +		rds_ib_dev_put(rds_ibdev);
>  		return ibmr;
> +	}
>  
>  	ret = rds_ib_map_fmr(rds_ibdev, ibmr, sg, nents);
>  	if (ret == 0)
> 

It seems like the function indeed is missing a put on the rds_ibdev in
that case.

Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

You may also want to add:
Fixes: 3e0249f9c05c ("RDS/IB: add refcount tracking to struct
rds_ib_device")
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
