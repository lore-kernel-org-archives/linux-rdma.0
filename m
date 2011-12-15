From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 04/14] ib_srp: Set block layer timeout
Date: Thu, 15 Dec 2011 14:37:21 -0500
Message-ID: <1323977841.16703.57.camel@lap75545.ornl.gov>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112011959.11956.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112011959.11956.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-12-01 at 19:59 +0100, Bart Van Assche wrote:
> Make sure that the default block layer timeout is above the
> InfiniBand transport layer timeout. The default block layer
> timeout is 30 seconds. Typical values for the QP local ack
> timeout and retry count are 19 and 7 respectively, which means
> that it can take up to 60.1 seconds before a HCA submits an
> error completion. The block layer timeout must be larger than
> the transport layer timeout because otherwise it can happen
> that an SRP response is received after the SCSI layer has
> already killed a command.

Good idea, but a few nits:


> +static int srp_slave_alloc(struct scsi_device *sdev)
> +{
> +	struct Scsi_Host *shost = sdev->host;
> +	struct srp_target_port *target = host_to_target(shost);
> +
> +	if (!WARN_ON(target->rq_tmo_jiffies == 0))
> +		blk_queue_rq_timeout(sdev->request_queue,
> +				     target->rq_tmo_jiffies);

What does having a WARN_ON here buy us? We should just set
target->rq_tmo_jiffies to a default value in srp_create_target(), and
adjust it as needed based on the CM response.

Also, since this is a call-back routine, please put it after
srp_reset_host() rather than in the middle of the target setup and CM
handling.

>  static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
>  			       struct srp_login_rsp *lrsp,
>  			       struct srp_target_port *target)
> @@ -1431,6 +1442,24 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
>  	if (ret)
>  		goto error_free;
>  
> +	if (!WARN_ON((attr_mask & (IB_QP_TIMEOUT | IB_QP_RETRY_CNT)) == 0)) {

Mentally unpacking that to realize the body gets executed if either of
those is set took a bit of thought... I think you will be better served
setting a default and reducing line that to

	if (attr_mask & (IP_QP_TIMEOUT | IB_QP_RETRY_CNT)) {

Also, you need to handle the case where only one of those is set, and
provide defaults when they aren't -- unless the spec says they both must
always be set (I haven't looked), in which case you can modify the
attr_mask test.

> +		uint64_t T_tr_ns, max_compl_time_ms;
> +
> +		/*
> +		 * Set target->rq_tmo_jiffies to one second more than the
> +		 * largest time it can take before an error completion is
> +		 * generated.
> +		 */

The calculations have a fair number of magic numbers in them; may be
useful to explain. 

You should be able to use nsecs_to_jiffies() instead of doing the math
yourself, but I see that's not exported. Bummer, but we can leave fixing
that for later, I think.

> +		T_tr_ns = 1ULL << (12 + qp_attr->timeout);
> +		max_compl_time_ms = qp_attr->retry_cnt * 4 * T_tr_ns;
> +		do_div(max_compl_time_ms, 1000 * 1000);
> +		target->rq_tmo_jiffies =
> +			msecs_to_jiffies(max_compl_time_ms + 1000);
> +		pr_debug("max. IB completion time = %lld ms; block layer"
> +			 " timeout = %d jiffies\n", max_compl_time_ms,
> +			 target->rq_tmo_jiffies);

Is the debug statement really needed? Though I suppose it isn't really
hurting anything...


> diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
> index 020caf0..f010bd9 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.h
> +++ b/drivers/infiniband/ulp/srp/ib_srp.h
> @@ -138,6 +138,7 @@ struct srp_target_port {
>  	u32			lkey;
>  	u32			rkey;
>  	enum srp_target_state	state;
> +	u32			rq_tmo_jiffies;
>  	unsigned int		max_iu_len;

Please don't put that in the middle of the options used in the hot path;
it should go further down in the struct, somewhere after the comment

        /* Everything above this point is used in the hot path of
         * command processing. Try to keep them packed into cachelines.
         */

Bonus points if you can shove into a hole caused by packing rules.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
