From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/9] ib_mad: incoming sminfo SMPs gets discarded if no
 process_mad function is registered
Date: Tue, 6 Sep 2016 10:01:10 -0400
Message-ID: <57867d7f-cc9f-5ec2-6632-c552e6469e40@dev.mellanox.co.il>
References: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
 <1472774969-18997-2-git-send-email-knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472774969-18997-2-git-send-email-knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/1/2016 8:09 PM, Knut Omang wrote:
> From: Dag Moxnes <dag.moxnes-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> The process_mad function is an optional IB driver entry point
> allows a driver to intercept or modify MAD traffic.

process_mad is optional but currently that optionality is based on
whether MADs (QP0 and/or QP1) are supported or not. This is reflected in
the core_cap_flags and is related to the device type: IB including RoCE
v. non IB. The current in tree device drivers that do not support
process_mad are i40iw (iWARP) and usnic.

> This fix allows MAD traffic to flow down to the device also
> when MAD traffic is completely handled by the device

All MAD traffic is not handled by the device.

> and no process_mad function is provided.
> 
> Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/core/mad.c | 6 ++++++
>  drivers/infiniband/core/smi.h | 6 ++----
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> index 2d49228..ece33ec 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -813,6 +813,12 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
>  			goto out;
>  	}
>  
> +	/* If device does not define the optional process_mad function it means that
> +	 * everything is handled in hardware:
> +	 */
> +	if (!device->process_mad)
> +		goto out;
> +

This changes the ib_post_send_mad flow for those devices in that it
takes the send rather than error path.

>  	local = kmalloc(sizeof *local, GFP_ATOMIC);
>  	if (!local) {
>  		ret = -ENOMEM;
> diff --git a/drivers/infiniband/core/smi.h b/drivers/infiniband/core/smi.h
> index 33c91c8..16a9f9a 100644
> --- a/drivers/infiniband/core/smi.h
> +++ b/drivers/infiniband/core/smi.h
> @@ -67,8 +67,7 @@ static inline enum smi_action smi_check_local_smp(struct ib_smp *smp,
>  {
>  	/* C14-9:3 -- We're at the end of the DR segment of path */
>  	/* C14-9:4 -- Hop Pointer = Hop Count + 1 -> give to SMA/SM */
> -	return ((device->process_mad &&
> -		!ib_get_smp_direction(smp) &&
> +	return ((!ib_get_smp_direction(smp) &&
>  		(smp->hop_ptr == smp->hop_cnt + 1)) ?
>  		IB_SMI_HANDLE : IB_SMI_DISCARD);
>  }
> @@ -82,8 +81,7 @@ static inline enum smi_action smi_check_local_returning_smp(struct ib_smp *smp,
>  {
>  	/* C14-13:3 -- We're at the end of the DR segment of path */
>  	/* C14-13:4 -- Hop Pointer == 0 -> give to SM */
> -	return ((device->process_mad &&
> -		ib_get_smp_direction(smp) &&
> +	return ((ib_get_smp_direction(smp) &&
>  		!smp->hop_ptr) ? IB_SMI_HANDLE : IB_SMI_DISCARD);
>  }

Also, with this approach of optional process_mad for IB device, will/how
will sysfs port counters be supported for this device ? This currently
relies on process_mad.

It should be possible to implement a process_mad routine to return
ib_mad_result based on management class and perhaps attribute ID in the
case of SMInfo. Can this alternative approach be used for SIF ?

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
