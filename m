From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH v2 09/15] IB/srp: Add srp_terminate_io()
Date: Sun, 30 Jun 2013 17:10:58 -0400
Message-ID: <1372626658.12468.38.camel@haswell.thedillows.org>
References: <51CD856A.3010102@acm.org> <51CD877E.80606@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CD877E.80606-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2013-06-28 at 14:54 +0200, Bart Van Assche wrote:
> Finish all outstanding I/O requests after fast_io_fail_tmo expired,
> which speeds up failover in a multipath setup. This patch is a
> reworked version of a patch from Sebastian Riemer.

> -static void srp_reset_req(struct srp_target_port *target, struct srp_request *req)
> +static void srp_finish_req(struct srp_target_port *target,
> +			   struct srp_request *req, int result)
>  {
>  	struct scsi_cmnd *scmnd = srp_claim_req(target, req, NULL);
>  
>  	if (scmnd) {
>  		srp_free_req(target, req, scmnd, 0);
> -		scmnd->result = DID_RESET << 16;
> +		scmnd->result = result;

Rather than have all the callers do the shift, just have
srp_finish_req() do it.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
