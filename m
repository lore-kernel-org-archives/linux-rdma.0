From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 1/5 v6] IB/srp: Preparation for transmit ring response
 allocation
Date: Tue, 24 Aug 2010 22:36:29 -0400
Message-ID: <1282703789.24982.10.camel@obelisk.thedillows.org>
References: <201008221856.19900.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201008221856.19900.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2010-08-22 at 18:56 +0200, Bart Van Assche wrote:
> @@ -989,19 +989,19 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
>  static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
>  					enum srp_request_type req_type)
>  {
> -	s32 min = (req_type == SRP_REQ_TASK_MGMT) ? 1 : 2;
> +	s32 rsv = (req_type == SRP_REQ_TASK_MGMT) ? 0 : SRP_TSK_MGMT_SQ_SIZE;

> -	if (target->req_lim < min) {
> +	if (target->req_lim <= rsv) {
>  		++target->zero_req_lim;

I'm still not sure these two changes make the intent of the code any
clearer, especially the "less than or equal to the reserved credits".

However, if Roland is OK with it, then

Acked-by: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
