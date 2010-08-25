From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 2/5 v6] IB/srp: IB/srp: Implement SRP_CRED_REQ and
 SRP_AER_REQ
Date: Tue, 24 Aug 2010 22:48:23 -0400
Message-ID: <1282704503.24982.22.camel@obelisk.thedillows.org>
References: <201008221856.29895.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201008221856.29895.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2010-08-22 at 18:56 +0200, Bart Van Assche wrote:
> @@ -929,6 +1008,14 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
>  			     PFX "Got target logout request\n");
>  		break;
>  
> +	case SRP_CRED_REQ:
> +		srp_handle_req(target, iu, &__srp_handle_cred_req);
> +		break;
> +
> +	case SRP_AER_REQ:
> +		srp_handle_req(target, iu, &__srp_handle_aer_req);
> +		break;

Would prefer the two handlers just call a common response routine after
handling their part, but you seem dead-set against that.

You don't need to take the address of a function; there have been a
number of patches recently to change &function to just function.

> + * - SRP_IU_REQ_NORMAL: SRP_NORMAL_REQ_SQ_SIZE, since the SCSI mid-layer
> + *   never queues more than Scsi_Host.can_queue requests.
> + * - SRP_IU_REQ_TSK_MGMT: SRP_TSK_MGMT_SQ_SIZE.
> + * - SRP_IU_RSP: 1, since a conforming SRP target never sends more than
> + *   one unanswered SRP request to an initiator.

If you're going to churn the names, these are better than the SRP_TX_IU*
variants. Better still would be SRP_IU_CMD, SRP_IU_MGMT, SRP_IU_RSP or
SRP_IU_RESP, or leave them alone.

>  static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
> -					enum srp_request_type req_type)
> +				      enum srp_tx_iu_type iu_type)
>  {
> -	s32 rsv = (req_type == SRP_REQ_TASK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;
> +	s32 rsv = (iu_type == SRP_IU_REQ_TSK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;

You check for credits even if this is an SRP_IU_RSP, so we'll fail to
allocate an IU if we're low on credits. Not a common condition, but
possible within the spec.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
