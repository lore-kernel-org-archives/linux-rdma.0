From: Dave Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 01/15] ib_srp: Enlarge block layer timeout
Date: Thu, 29 Mar 2012 12:59:31 -0400
Message-ID: <20120329165931.GA19700@ornl.gov>
References: <5207288.nSt5MkVMpO@asus>
 <1385797.u8D4MDGaaX@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1385797.u8D4MDGaaX@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 25, 2012 at 10:47:06AM -0400, Bart Van Assche wrote:
> Enlarge the block layer timeout for disks such that it is above
> the InfiniBand transport layer timeout. This is necessary to avoid
> that an SRP response is received after the SCSI layer has already
> killed the associated SCSI command.

> +
> +	/*
> +	 * According to section 11.2.4.2 in the IBTA spec (Modify Queue Pair,
> +	 * table 91), both the QP timeout and the retry count have to be set
> +	 * for RC QP's during the RTR to RTS transition.
> +	 */
> +	WARN_ON((attr_mask & (IB_QP_TIMEOUT | IB_QP_RETRY_CNT)) !=
> +		(IB_QP_TIMEOUT | IB_QP_RETRY_CNT));

I still don't like this useless splat when it could be written in a
more safe manner, but not enough to kick it back again.

Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>

I haven't chewed on the rest yet, but would like to see this one at
least in 3.4 if possible.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
