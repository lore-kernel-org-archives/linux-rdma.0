From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] IB/srp: export reset-host via sysfs
Date: Tue, 4 Oct 2016 07:24:52 -0700
Message-ID: <af0d75ef-734d-2cdf-05d8-bf4cd9c59ef9@sandisk.com>
References: <1475589609-26451-1-git-send-email-gi-oh.kim@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475589609-26451-1-git-send-email-gi-oh.kim-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gioh Kim <gi-oh.kim-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/04/16 07:00, Gioh Kim wrote:
> Standard SCSI device has host_reset sysfs interface.
> This patch exports the host_reset interface for upper layer.
>
> Signed-off-by: Gioh Kim <gi-oh.kim-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 3322ed7..92e6c3f 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -2628,6 +2628,15 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
>  	return SUCCESS;
>  }
>
> +static int srp_scsi_host_reset(struct Scsi_Host *shost, int reset_type)
> +{
> +	struct srp_target_port *target = host_to_target(shost);
> +
> +	shost_printk(KERN_EMERG, target->scsi_host, PFX "SRP reset_host called\n");
> +
> +	return srp_reconnect_rport(target->rport);
> +}
> +
>  static int srp_reset_host(struct scsi_cmnd *scmnd)
>  {
>  	struct srp_target_port *target = host_to_target(scmnd->device->host);
> @@ -2858,6 +2867,7 @@ static struct scsi_host_template srp_template = {
>  	.use_clustering			= ENABLE_CLUSTERING,
>  	.shost_attrs			= srp_host_attrs,
>  	.track_queue_depth		= 1,
> +	.host_reset			= srp_scsi_host_reset,
>  };

Hello Gioh,

A patch description should not only explain what is changed but also why 
a change is considered useful. Why do you think it would be useful to 
allow users to trigger a call of srp_reconnect_rport() through sysfs 
instead of using the functionality that is already available through 
sysfs, namely removing a SCSI host and reconnecting?

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
