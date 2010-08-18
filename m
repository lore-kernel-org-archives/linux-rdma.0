From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 3/3 v5] IB/srp: Reduce number of BUSY conditions
Date: Wed, 18 Aug 2010 19:52:53 -0400
Message-ID: <1282175573.25848.20.camel@obelisk.thedillows.org>
References: <201008162055.47174.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201008162055.47174.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-08-16 at 20:55 +0200, Bart Van Assche wrote:
> -			target->scsi_host->can_queue = min(target->req_lim,
> -							   target->scsi_host->can_queue);
> +			/*
> +			 * Set can_queue such that the SCSI mid-layer
> +			 * never causes __srp_get_tx_iu() to fail.
> +			 */
> +			target->scsi_host->can_queue
> +				= min(target->req_lim - SRP_TASK_MGMT_SQ_SIZE,
> +				      target->scsi_host->can_queue);

/*
 * Reserve credits for task management so we don't
 * needlessly bounce requests back to the SCSI mid-layer
 */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
