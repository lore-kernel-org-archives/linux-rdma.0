From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH] IB/srp receive buffer handling robustness improvement
Date: Fri, 30 Jul 2010 11:36:17 -0400
Message-ID: <1280504177.31468.47.camel@obelisk.thedillows.org>
References: <201007301259.05796.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201007301259.05796.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2010-07-30 at 12:59 +0200, Bart Van Assche wrote:
> The current strategy in ib_srp for posting receive buffers is as follows:
> * Post one buffer after channel establishment.
> * Post one buffer before sending an SRP_CMD or SRP_TSK_MGMT to the target.
> As a result, only the first non-SRP_RSP information unit from the target will
> be processed. If that first information unit is an SRP_T_LOGOUT, it will be
> processed. On the other hand, if the initiator receives an SRP_CRED_REQ or
> SRP_AER_REQ before it receives a SRP_T_LOGOUT, the SRP_T_LOGOUT won't be
> processed. This patch fixes this inconsistency by changing the strategy for
> posting receive buffers as follows:
> * Post all receive buffers after channel establishment.
> * After a receive buffer has been consumed and processed, post it again.
> A side effect is that the ib_post_recv() call is moved out of the SCSI command
> processing path.

Some comments below, but fixed or no,

Acked-by: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

>  static void srp_send_completion(struct ib_cq *cq, void *target_ptr);
> +static int srp_post_recv(struct srp_target_port *target);

I think you can avoid adding this declaration by hoisting
__srp_post_recv() and srp_post_recv() above srp_handle_recv(). I believe
Roland shares my preference to avoid forward declarations if possible.

> @@ -1298,7 +1301,11 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
>  		if (target->status)
>  			break;
>  
> -		target->status = srp_post_recv(target);
> +		for (i = 0; i < SRP_RQ_SIZE; i++) {
> +			target->status = srp_post_recv(target);
> +			if (target->status)
> +				break;
> +		}

Hmm, target setup is getting a bit wordy in that switch statement. It's
probably getting to be time to move it to a separate function, but that
doesn't need to happen in this patch.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
