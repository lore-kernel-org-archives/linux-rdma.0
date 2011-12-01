From: chas williams - CONTRACTOR <chas-vT06rRrALxcmhCb6mdbn6A@public.gmane.org>
Subject: Re: [PATCH 06/14] ib_srp: Micro-optimize completion handlers
Date: Thu, 1 Dec 2011 16:35:39 -0500
Message-ID: <20111201163539.572ca669@thirdoffive.cmf.nrl.navy.mil>
References: <201112011954.25811.bvanassche@acm.org>
	<201112012002.17829.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112012002.17829.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

perhaps this should use the unlikely() macro instead:

	if (unlikely(wc.status)) {
		...
	}

	...

On Thu, 1 Dec 2011 20:02:17 +0100
Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:

> Help the CPU branch predictor by rearranging two if-statements such
> that the most likely code is in the if-part instead of the else-part.
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index a2624bf..e6d1aef 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1224,15 +1224,15 @@ static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
>  
>  	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
>  	while (ib_poll_cq(cq, 1, &wc) > 0) {
> -		if (wc.status) {
> +		if (wc.status == IB_WC_SUCCESS) {
> +			srp_handle_recv(target, &wc);
> +		} else {
>  			shost_printk(KERN_ERR, target->scsi_host,
>  				     PFX "failed receive status %d\n",
>  				     wc.status);
>  			target->qp_in_error = 1;
>  			break;
>  		}
> -
> -		srp_handle_recv(target, &wc);
>  	}
>  }
>  
> @@ -1243,16 +1243,16 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
>  	struct srp_iu *iu;
>  
>  	while (ib_poll_cq(cq, 1, &wc) > 0) {
> -		if (wc.status) {
> +		if (wc.status == IB_WC_SUCCESS) {
> +			iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
> +			list_add(&iu->list, &target->free_tx);
> +		} else {
>  			shost_printk(KERN_ERR, target->scsi_host,
>  				     PFX "failed send status %d\n",
>  				     wc.status);
>  			target->qp_in_error = 1;
>  			break;
>  		}
> -
> -		iu = (struct srp_iu *) (uintptr_t) wc.wr_id;
> -		list_add(&iu->list, &target->free_tx);
>  	}
>  }
>  

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
