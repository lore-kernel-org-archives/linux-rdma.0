From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 07/14] ib_srp: Introduce srp_handle_qp_err()
Date: Sun, 18 Dec 2011 18:55:55 -0500
Message-ID: <1324252556.17849.42.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012002.56307.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112012002.56307.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2011-12-01 at 20:02 +0100, Bart Van Assche wrote:
> +static void srp_handle_qp_err(enum ib_wc_status wc_status,
> +			      enum ib_wc_opcode wc_opcode,
> +			      struct srp_target_port *target)
> +{
> +	shost_printk(KERN_ERR, target->scsi_host,
> +		     PFX "failed receive status %d\n", wc_status);
> +	target->qp_in_error = 1;
> +}

You don't do anything with the wc_opcode here. You add a shost_printk()
in patch 12 -- that part should be in this patch.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
