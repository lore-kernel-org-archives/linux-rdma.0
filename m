From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v2 04/15] IB/srp: Fail I/O fast if target offline
Date: Mon, 01 Jul 2013 11:25:05 +0200
Message-ID: <51D14AF1.4000803@profitbricks.com>
References: <51CD856A.3010102@acm.org> <51CD8676.6080205@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CD8676.6080205-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 28.06.2013 14:49, Bart Van Assche wrote:
> If reconnecting failed we know that no command completion will
> be received anymore. Hence let the SCSI error handler fail such
> commands immediately.
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 8c95262..5c91521 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1755,6 +1755,8 @@ static int srp_abort(struct scsi_cmnd *scmnd)
>  	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
>  			      SRP_TSK_ABORT_TASK) == 0)
>  		ret = SUCCESS;
> +	else if (target->transport_offline)
> +		ret = FAST_IO_FAIL;
>  	else
>  		ret = FAILED;
>  	srp_free_req(target, req, scmnd, 0);
> 

I'm also missing the concept for srp_reset_device(). There is a very
common case that the SCSI error handling and the transport layer error
handling run in parallel: Congestion.

In congestion some LUNs are blocked while others can still transmit. A
little bit later the QP timeout triggers in the middle of the SCSI error
handling in srp_abort(), srp_reset_device() or less likely in
srp_reset_host().

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
