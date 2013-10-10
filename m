From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/srp: Avoid offlining operational SCSI devices
Date: Thu, 10 Oct 2013 14:31:22 +0200
Message-ID: <52569E1A.4010004@profitbricks.com>
References: <5256941A.3040506@acm.org> <52569501.5030108@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52569501.5030108-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/10/2013 01:52 PM, Bart Van Assche wrote:
> If SCSI commands are submitted with a SCSI request timeout that is
> lower than the the IB RC timeout it can happen that the SCSI error
> handler has already started device recovery before transport layer
> error handling starts. So it can happen that the SCSI error handler
> tries to abort a SCSI command after it has been reset by
> srp_rport_reconnect(). Tell the SCSI error handler that such commands
> have finished and that it is not necessary to continue its recovery
> strategy for commands that have been reset by srp_rport_reconnect().
Another possible is srp has already finish the req (req is NULL)when
scsi error handle call into srp_abort.

I tested it on my side, works for me.
You can add my Tested-by if needed.

Thanks Bart.

Jack


> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index f1318a8..93a35a1 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -1752,7 +1752,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
>  	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
>  
>  	if (!req || !srp_claim_req(target, req, scmnd))
> -		return FAILED;
> +		return SUCCESS;
>  	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
>  			      SRP_TSK_ABORT_TASK) == 0)
>  		ret = SUCCESS;
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
