From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 4/5] ib_srp: check if rport->lld_data is NULL before removing
 rport
Date: Sat, 01 Sep 2012 07:59:24 +0000
Message-ID: <5041C05C.5060608@acm.org>
References: <1346443241-24844-1-git-send-email-dongsu.park@profitbricks.com> <1346443241-24844-5-git-send-email-dongsu.park@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1346443241-24844-5-git-send-email-dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 08/31/12 20:00, dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org wrote:
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 1b274484..ba7bbfd 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -647,9 +647,19 @@ static void srp_remove_work(struct work_struct *work)
>  
>  static void srp_rport_delete(struct srp_rport *rport)
>  {
> -	struct srp_target_port *target = rport->lld_data;
> +	struct srp_target_port *target;
> +
> +	if (!rport->lld_data) {
> +		pr_warn("skipping srp_rport_delete. rport->lld_data=%p\n",
> +			rport->lld_data);
> +		return;
> +	}
> +
> +	target = rport->lld_data;
>  
>  	srp_queue_remove_work(target);
> +
> +	rport->lld_data = NULL;
>  }
>  
>  /**
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index af3cb56..915b355 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -272,6 +272,12 @@ static void rport_dev_loss_timedout(struct work_struct *work)
>  	struct Scsi_Host *shost;
>  	struct srp_internal *i;
>  
> +	if (!rport->lld_data) {
> +		pr_warn("skipping rport_delete, rport->lld_data=%p\n",
> +			rport->lld_data);
> +		return;
> +	}
> +
>  	pr_err("SRP transport: dev_loss_tmo (%ds) expired - removing %s.\n",
>  	       rport->dev_loss_tmo, dev_name(&rport->dev));
>  

The above changes look harmless to me. But what I'd really like to know
is whether the pr_warn() statements added by this patch have been hit
after testing with patch [5/5] started ? The srp-ha patch series has
been designed such that rport->lld_data != NULL as long as the rport
data structure exists.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
