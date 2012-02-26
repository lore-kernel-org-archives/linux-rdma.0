From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 03/18] ib_srp: Enlarge block layer timeout
Date: Sun, 26 Feb 2012 01:32:01 -0500
Message-ID: <1330237921.1026.81.camel@obelisk.thedillows.org>
References: <3109536.qySrY1Ts3e@asus> <2007426.PROb5t3CLZ@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2007426.PROb5t3CLZ@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2012-01-14 at 12:41 +0000, Bart Van Assche wrote:
> Enlarge the block layer timeout such that it is above the
> InfiniBand transport layer timeout. This is necessary to avoid
> that an SRP response is received after the SCSI layer has
> already killed the associated SCSI command. Note: the timeout is
> only set for SCSI disk devices but not for any other type of
> SCSI device (M/O disk, tape, CD-ROM, ...).

Why disk only? Different default timeouts? If so, there's a better
solution.

> +static uint32_t srp_compute_rq_tmo(struct ib_qp_attr *qp_attr, int attr_mask)
> +{
> +	uint64_t T_tr_ns, max_compl_time_ms;
> +	uint32_t rq_tmo_jiffies;
> +
> +	/*
> +	 * According to section 11.2.4.2 in the IBTA spec (Modify Queue Pair,
> +	 * table 91), both the QP timeout and the retry count have to be set
> +	 * for RC QP's during the RTR to RTS transition.
> +	 */
> +	WARN_ON((attr_mask & (IB_QP_TIMEOUT | IB_QP_RETRY_CNT)) !=
> +		(IB_QP_TIMEOUT | IB_QP_RETRY_CNT));

Are you guaranteed to get those attributes set if they aren't changed
from the default? You'd get a splat from this non-error case. The user
at least can go looking for the cause of the splat and find a pointer to
why, but I contend it is more user-friendly to just cope:

	/* Use the defaults from ITBA spec if CM doesn't supply them */
	timeout = (attr_mask * IP_QP_TIMEOUT) ? qp_attr->timeout : 19;
	retries = (attr_mask & IP_QP_RETRY_CNT) ? qp_attr->retry_cnt : 7;

> +	 * Set target->rq_tmo_jiffies to one second more than the largest time
> +	 * it can take before an error completion is generated. See also
> +	 * C9-140..C9-142 in the IBTA spec for more information about how to
> +	 * convert the QP Local ACK Timeout value to nanoseconds.
> +	 */
> +	T_tr_ns = 1ULL << (12 + qp_attr->timeout);

I still think T_tr_ns = 4096 * (1ULL << timeout) is more readable, and
the compiler will do the right thing -- not that it matters in this slow
path.

> +static int srp_slave_configure(struct scsi_device *sdev)
> +{
> +	struct Scsi_Host *shost = sdev->host;
> +	struct srp_target_port *target = host_to_target(shost);
> +	struct request_queue *q = sdev->request_queue;
> +	unsigned long timeout;
> +
> +	WARN_ON(target->rq_tmo_jiffies == 0);
> +	if (sdev->type == TYPE_DISK) {
> +		timeout = max_t(unsigned, 30 * HZ, target->rq_tmo_jiffies);
> +		blk_queue_rq_timeout(q, timeout);
> +	}

I think you can get rid of any dependency on the default values by just
doing

	if (q->rq_timeout < target->rq_tmo_jiffies)
		blk_queue_rq_timeout(q, timeout);

This -- or the changes to srp_compute_rq_tmo() -- would also avoid the
need for the WARN_ON().
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
