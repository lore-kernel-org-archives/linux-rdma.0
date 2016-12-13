From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-rc 2/5] IB/rxe: Fix handling of erroneous WR
Date: Tue, 13 Dec 2016 08:03:03 +0100
Message-ID: <5bd83de1-64d3-e5a9-1c58-cca52d89d64a@sandisk.com>
References: <1479285558-19627-1-git-send-email-leon@kernel.org>
 <1479285558-19627-3-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479285558-19627-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/16/2016 09:39 AM, Leon Romanovsky wrote:
> @@ -745,13 +746,17 @@ int rxe_requester(void *arg)
>  	wqe->status = IB_WC_LOC_PROT_ERR;
>  	wqe->state = wqe_state_error;
>  
> -complete:
> -	if (qp_type(qp) != IB_QPT_RC) {
> -		while (rxe_completer(qp) == 0)
> -			;
> -	}
> -
> -	return 0;
> +	/*
> +	 * IBA Spec. Section 10.7.3.1 SIGNALED COMPLETIONS
> +	 * ---------8<---------8<-------------
> +	 * ...Note that if a completion error occurs, a Work Completion
> +	 * will always be generated, even if the signaling
> +	 * indicator requests an Unsignaled Completion.
> +	 * ---------8<---------8<-------------
> +	 */
> +	wqe->wr.send_flags |= IB_SEND_SIGNALED;
> +	__rxe_do_task(&qp->comp.task);
> +	return -EAGAIN;

Hello Leon and Yonatan,

Sorry for the late reply but I think setting IB_SEND_SIGNALED for WQE's
reporting a completion error is wrong. I noticed this because this change
conflicts with Doug's rxe branch on github. Have you considered to apply
the following (untested) patch instead of setting the IB_SEND_SIGNALED
flag?

--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -418,7 +418,7 @@ static void do_complete(struct rxe_qp *qp, struct rxe_send_w
qe *wqe)
 
        if ((qp->sq_sig_type == IB_SIGNAL_ALL_WR) ||
            (wqe->wr.send_flags & IB_SEND_SIGNALED) ||
-           (qp->req.state == QP_STATE_ERROR)) {
+           wqe->status != IB_WC_SUCCESS) {
                make_send_cqe(qp, wqe, &cqe);
                advance_consumer(qp->sq.queue);
                rxe_cq_post(qp->scq, &cqe, 0);

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
