From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 04/14] RDMA/cxgb4: Use common error handling code in
 recover_queues()
Date: Thu, 9 Feb 2017 10:30:08 +0100
Message-ID: <af80d74d-fee5-6917-d92d-bd85a4cb92c2@suse.de>
References: <0aff92fa-2891-333a-2e1e-ca309db2ec72@users.sourceforge.net>
 <e8abf0d7-1f4d-d218-194c-4c831dbf72d5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <e8abf0d7-1f4d-d218-194c-4c831dbf72d5@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Steve Wise <swise@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 02/08/2017 10:14 PM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 8 Feb 2017 15:51:58 +0100
> 
> Add a jump target so that a bit of exception handling can be better reused
> at the end of this function.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/infiniband/hw/cxgb4/device.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
> index 444c28206dae..46410c4a9afb 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -1467,10 +1467,9 @@ static void recover_queues(struct uld_ctx *ctx)
>  	idr_for_each(&ctx->dev->qpidr, count_qps, &count);
>  
>  	qp_list.qps = kcalloc(count, sizeof(*qp_list.qps), GFP_ATOMIC);
> -	if (!qp_list.qps) {
> -		spin_unlock_irq(&ctx->dev->lock);
> -		return;
> -	}
> +	if (!qp_list.qps)
> +		goto unlock;
> +
>  	qp_list.idx = 0;
>  
>  	/* add and ref each qp so it doesn't get freed */
> @@ -1488,6 +1487,7 @@ static void recover_queues(struct uld_ctx *ctx)
>  	spin_lock_irq(&ctx->dev->lock);
>  	WARN_ON(ctx->dev->db_state != RECOVERY);
>  	ctx->dev->db_state = STOPPED;
> +unlock:
>  	spin_unlock_irq(&ctx->dev->lock);
>  }
>  
> 

This patch is rather pointless IMHO. Using goto labels only brings
benefits if you have more than one code path jumping to them this one
just confuses the readers.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
