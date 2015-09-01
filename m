From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH] infiniband:cxgb4:Fix incorrect return statement in the function c4iw_destroy_cq
Date: Tue, 1 Sep 2015 09:58:41 -0500
Message-ID: <002701d0e4c6$b0d1c760$12755620$@opengridcomputing.com>
References: <1440965510-6724-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440965510-6724-1-git-send-email-xerofoify@gmail.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Nicholas Krause' <xerofoify@gmail.com>, swise@chelsio.com
Cc: dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Nicholas Krause [mailto:xerofoify@gmail.com]
> Sent: Sunday, August 30, 2015 3:12 PM
> To: swise@chelsio.com
> Cc: dledford@redhat.com; sean.hefty@intel.com; hal.rosenstock@gmail.com; linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] infiniband:cxgb4:Fix incorrect return statement in the function c4iw_destroy_cq
> 
> This fixes the incorrect return statement at the end of the function
> c4iw_destroy_cq's body that returns zero to instead correctly return
> the return value of the call to the function destroy_cq as all callers
> of c4iw_destroy_cq should be signaled when this call fails in order
> for them to handle it in their own intended error paths.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/infiniband/hw/cxgb4/cq.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
> index 92d5183..4f7af20 100644
> --- a/drivers/infiniband/hw/cxgb4/cq.c
> +++ b/drivers/infiniband/hw/cxgb4/cq.c
> @@ -848,6 +848,7 @@ int c4iw_destroy_cq(struct ib_cq *ib_cq)
>  {
>  	struct c4iw_cq *chp;
>  	struct c4iw_ucontext *ucontext;
> +	int ret;
> 
>  	PDBG("%s ib_cq %p\n", __func__, ib_cq);
>  	chp = to_c4iw_cq(ib_cq);
> @@ -858,10 +859,10 @@ int c4iw_destroy_cq(struct ib_cq *ib_cq)
> 
>  	ucontext = ib_cq->uobject ? to_c4iw_ucontext(ib_cq->uobject->context)
>  				  : NULL;
> -	destroy_cq(&chp->rhp->rdev, &chp->cq,
> -		   ucontext ? &ucontext->uctx : &chp->cq.rdev->uctx);
> +	ret = destroy_cq(&chp->rhp->rdev, &chp->cq,
> +			 ucontext ? &ucontext->uctx : &chp->cq.rdev->uctx);
>  	kfree(chp);
> -	return 0;
> +	return ret;
>  }


The SW CQ is destroyed regardless of any errors returned by destroy_cq().  So c4iw_destroy_cq() shouldn't return non-zero since it
is freeing the CQ memory.   I think the correct change here is to only kfree(chp) if destroy_cq() returns 0.

Steve.


> 
>  struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,
> --
> 2.1.4
