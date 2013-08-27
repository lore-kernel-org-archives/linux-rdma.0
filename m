From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/srp: add change_queue_depth and change_queue_type
 support
Date: Tue, 27 Aug 2013 10:31:54 +0200
Message-ID: <521C63FA.3070709@acm.org>
References: <521B5DD5.3020804@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <521B5DD5.3020804-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/26/13 15:53, Jack Wang wrote:
> From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> Date: Mon, 26 Aug 2013 15:50:03 +0200
> Subject: [PATCH] IB/srp: add change_queue_depth/change_queue_type support
>
> Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

Hello Jack,

When posting a Linux kernel patch it is not only expected that the 
commit message explains what is changed but also why these changes have 
been made. What made you look into adding dynamic queue depth support ? 
Had you perhaps run into a performance issue, an issue that is solved by 
this patch ? If so, did it occur with all storage types or only with 
certain storage types (e.g. hard disks or hard disk arrays) ? How much 
did this patch improve performance ?

> @@ -1697,6 +1698,56 @@ static int srp_cm_handler(struct ib_cm_id *cm_id,
> struct ib_cm_event *event)
>
>   	return 0;
>   }
> +/**
> + * srp_change_queue_type - changing device queue tag type

Please leave a blank line between the end of one function and the header 
of the next function.

> +
> +/**
> + * srp_change_queue_depth - setting device queue depth
> + * @sdev: scsi device struct
> + * @qdepth: requested queue depth
> + * @reason: SCSI_QDEPTH_DEFAULT/SCSI_QDEPTH_QFULL/SCSI_QDEPTH_RAMP_UP
> + * (see include/scsi/scsi_host.h for definition)
> + *
> + * Returns queue depth.
> + */
> +static int
> +srp_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
> +{
> +	if (reason == SCSI_QDEPTH_DEFAULT || reason == SCSI_QDEPTH_RAMP_UP) {
> +		struct Scsi_Host *shost = sdev->host;
> +		int max_depth;

Nothing important, but I think in the Linux kernel there is a preference 
to declare variables at the outermost scope.

 > +		if (!sdev->tagged_supported)
 > +			max_depth = 1;

This code seems incorrect to me for the SRP protocol. In the SRP 
protocol, although there is no TCQ support, queue depths above one are 
supported.

I also have a more general remark. There is no TCQ support in the SRP 
protocol, which means that sdev->tagged_supported is always 0 (false). 
So my recommendation is to leave out all code that depends on "if 
(sdev->tagged_supported)" and to remove the "if 
(!sdev->tagged_supported)" tests.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
