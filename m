From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH] infiniband/hw/cxgb4/qp.c: Use dma_zalloc_coherent
Date: Mon, 12 Nov 2018 09:31:52 -0600
Message-ID: <53589711-602e-1a0f-9036-ff0d0c30bf57@opengridcomputing.com>
References: <5be99a9e.1c69fb81.87c65.4ec2@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5be99a9e.1c69fb81.87c65.4ec2@mx.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sabyasachi Gupta <sabyasachi.linux@gmail.com>, dledford@redhat.com, jgg@ziepe.ca
Cc: jrdr.linux@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-rdma@vger.kernel.org



On 11/12/2018 9:21 AM, Sabyasachi Gupta wrote:
> Replaced dma_alloc_coherent + memset with dma_zalloc_coherent
> 
> Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
> ---
>  drivers/infiniband/hw/cxgb4/qp.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
> index 13478f3..5a8030b 100644
> --- a/drivers/infiniband/hw/cxgb4/qp.c
> +++ b/drivers/infiniband/hw/cxgb4/qp.c
> @@ -2564,13 +2564,12 @@ static int alloc_srq_queue(struct c4iw_srq *srq, struct c4iw_dev_ucontext *uctx,
>  	wq->rqt_abs_idx = (wq->rqt_hwaddr - rdev->lldi.vr->rq.start) >>
>  		T4_RQT_ENTRY_SHIFT;
>  
> -	wq->queue = dma_alloc_coherent(&rdev->lldi.pdev->dev,
> +	wq->queue = dma_zalloc_coherent(&rdev->lldi.pdev->dev,
>  				       wq->memsize, &wq->dma_addr,
>  			GFP_KERNEL);
>  	if (!wq->queue)
>  		goto err_free_rqtpool;
>  
> -	memset(wq->queue, 0, wq->memsize);
>  	dma_unmap_addr_set(wq, mapping, wq->dma_addr);
>  
>  	wq->bar2_va = c4iw_bar2_addrs(rdev, wq->qid, CXGB4_BAR2_QTYPE_EGRESS,
> 

Acked-by: Steve Wise <swise@opengridcomputing.com>
