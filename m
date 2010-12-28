From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 04/24] IB/qib: add thresholds to VendorPortCounters PMA
 operation
Date: Tue, 28 Dec 2010 14:24:13 -0500
Message-ID: <4D1A395D.6040103@dev.mellanox.co.il>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org> <20101228152711.19960.52491.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152711.19960.52491.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/28/2010 10:27 AM, Mike Marciniszyn wrote:
> This adds thresholds to be specified in the VendorPortCounters PMA
> operation.
>
> Signed-off-by: Mike Marciniszyn<mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/infiniband/hw/qib/qib_mad.c |   87 +++++++++++++++++++++++------------
>   1 files changed, 57 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
> index 94b0d1f..9794020 100644
> --- a/drivers/infiniband/hw/qib/qib_mad.c
> +++ b/drivers/infiniband/hw/qib/qib_mad.c
> @@ -1135,10 +1135,10 @@ static int pma_get_classportinfo(struct ib_perf *pmp,
>   	p->class_version = 1;
>   	p->cap_mask = IB_PMA_CLASS_CAP_EXT_WIDTH;
>   	/*
> -	 * Set the most significant bit of CM2 to indicate support for
> +	 * Set the most significant two bits of CM2 to indicate support for
>   	 * congestion statistics
>   	 */

Where in the IBA spec do these bits come from ? What are they ?

> -	p->reserved[0] = dd->psxmitwait_supported<<  7;
> +	p->reserved[0] = (dd->psxmitwait_supported * 3)<<  6;

It looks weird to me to set an IBA reserved field. Should the structure 
be updated to contain the real field name ?

-- Hal

>   	/*
>   	 * Expected response time is 4.096 usec. * 2^18 == 1.073741824 sec.
>   	 */
> @@ -1709,8 +1709,14 @@ static int pma_set_portcounters(struct ib_perf *pmp,
>   }
>
>   static int pma_set_portcounters_cong(struct ib_perf *pmp,
> -				     struct ib_device *ibdev, u8 port)
> +				     struct ib_device *ibdev, u8 port,
> +				     struct ib_perf *pmp_in)
>   {
> +	/* Congestion PMA packets start at offset 24 not 64 */
> +	struct ib_pma_portcounters_cong *p_out =
> +			(struct ib_pma_portcounters_cong *)pmp->reserved;
> +	struct ib_pma_portcounters_cong *p_in =
> +			(struct ib_pma_portcounters_cong *)pmp_in->reserved;
>   	struct qib_ibport *ibp = to_iport(ibdev, port);
>   	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
>   	struct qib_devdata *dd = dd_from_ppd(ppd);
> @@ -1724,36 +1730,56 @@ static int pma_set_portcounters_cong(struct ib_perf *pmp,
>   	ret = pma_get_portcounters_cong(pmp, ibdev, port);
>
>   	if (counter_select&  IB_PMA_SEL_CONG_XMIT) {
> -		spin_lock_irqsave(&ppd->ibport_data.lock, flags);
> -		ppd->cong_stats.counter = 0;
> -		dd->f_set_cntr_sample(ppd, QIB_CONG_TIMER_PSINTERVAL,
> -				      0x0);
> -		spin_unlock_irqrestore(&ppd->ibport_data.lock, flags);
> +		if (p_out->port_xmit_wait>  p_in->port_xmit_wait) {
> +			spin_lock_irqsave(&ppd->ibport_data.lock, flags);
> +			ppd->cong_stats.counter = 0;
> +			dd->f_set_cntr_sample(ppd, QIB_CONG_TIMER_PSINTERVAL,
> +					      0x0);
> +			spin_unlock_irqrestore(&ppd->ibport_data.lock, flags);
> +		}
>   	}
>   	if (counter_select&  IB_PMA_SEL_CONG_PORT_DATA) {
> -		ibp->z_port_xmit_data = cntrs.port_xmit_data;
> -		ibp->z_port_rcv_data = cntrs.port_rcv_data;
> -		ibp->z_port_xmit_packets = cntrs.port_xmit_packets;
> -		ibp->z_port_rcv_packets = cntrs.port_rcv_packets;
> +		if (p_out->port_xmit_data>  p_in->port_xmit_data)
> +			ibp->z_port_xmit_data = cntrs.port_xmit_data;
> +		if (p_out->port_rcv_data>  p_in->port_rcv_data)
> +			ibp->z_port_rcv_data = cntrs.port_rcv_data;
> +		if (p_out->port_xmit_packets>  p_in->port_xmit_packets)
> +			ibp->z_port_xmit_packets = cntrs.port_xmit_packets;
> +		if (p_out->port_rcv_packets>  p_in->port_rcv_packets)
> +			ibp->z_port_rcv_packets = cntrs.port_rcv_packets;
>   	}
>   	if (counter_select&  IB_PMA_SEL_CONG_ALL) {
> -		ibp->z_symbol_error_counter =
> -			cntrs.symbol_error_counter;
> -		ibp->z_link_error_recovery_counter =
> -			cntrs.link_error_recovery_counter;
> -		ibp->z_link_downed_counter =
> -			cntrs.link_downed_counter;
> -		ibp->z_port_rcv_errors = cntrs.port_rcv_errors;
> -		ibp->z_port_rcv_remphys_errors =
> -			cntrs.port_rcv_remphys_errors;
> -		ibp->z_port_xmit_discards =
> -			cntrs.port_xmit_discards;
> -		ibp->z_local_link_integrity_errors =
> -			cntrs.local_link_integrity_errors;
> -		ibp->z_excessive_buffer_overrun_errors =
> -			cntrs.excessive_buffer_overrun_errors;
> -		ibp->n_vl15_dropped = 0;
> -		ibp->z_vl15_dropped = cntrs.vl15_dropped;
> +		if (p_out->symbol_error_counter>  p_in->symbol_error_counter)
> +			ibp->z_symbol_error_counter =
> +				cntrs.symbol_error_counter;
> +		if (p_out->link_error_recovery_counter>
> +		    p_in->link_error_recovery_counter)
> +			ibp->z_link_error_recovery_counter =
> +				cntrs.link_error_recovery_counter;
> +		if (p_out->link_downed_counter>  p_in->link_downed_counter)
> +			ibp->z_link_downed_counter =
> +				cntrs.link_downed_counter;
> +		if (p_out->port_rcv_errors>  p_in->port_rcv_errors)
> +			ibp->z_port_rcv_errors = cntrs.port_rcv_errors;
> +		if (p_out->port_rcv_remphys_errors>
> +		    p_in->port_rcv_remphys_errors)
> +			ibp->z_port_rcv_remphys_errors =
> +				cntrs.port_rcv_remphys_errors;
> +		if (p_out->port_xmit_discards>  p_in->port_xmit_discards)
> +			ibp->z_port_xmit_discards =
> +				cntrs.port_xmit_discards;
> +		if ((p_out->lli_ebor_errors&  0xf0)>
> +		    (p_in->lli_ebor_errors&  0xf0))
> +			ibp->z_local_link_integrity_errors =
> +				cntrs.local_link_integrity_errors;
> +		if ((p_out->lli_ebor_errors&  0x0f)>
> +		    (p_in->lli_ebor_errors&  0x0f))
> +			ibp->z_excessive_buffer_overrun_errors =
> +				cntrs.excessive_buffer_overrun_errors;
> +		if (p_out->vl15_dropped>  p_in->vl15_dropped) {
> +			ibp->n_vl15_dropped = 0;
> +			ibp->z_vl15_dropped = cntrs.vl15_dropped;
> +		}
>   	}
>
>   	return ret;
> @@ -2004,7 +2030,8 @@ static int process_perf(struct ib_device *ibdev, u8 port,
>   			ret = pma_set_portcounters_ext(pmp, ibdev, port);
>   			goto bail;
>   		case IB_PMA_PORT_COUNTERS_CONG:
> -			ret = pma_set_portcounters_cong(pmp, ibdev, port);
> +			ret = pma_set_portcounters_cong(pmp, ibdev, port,
> +						(struct ib_perf *)in_mad);
>   			goto bail;
>   		default:
>   			pmp->status |= IB_SMP_UNSUP_METH_ATTR;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
