From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] osm_port_info_rcv.c Issue a log message if we cannot
 read the MKey of a port
Date: Fri, 16 Aug 2013 09:47:50 -0400
Message-ID: <520E2D86.6080903@dev.mellanox.co.il>
References: <e5b46785-f443-42ef-bf16-660f9e7df190@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e5b46785-f443-42ef-bf16-660f9e7df190@default>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/14/2013 6:26 AM, Line Holen wrote:
> Signed-off-by: Line Holen <Line.Holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> ---
> 
> diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
> index 7dcd15e..961b376 100644
> --- a/opensm/osm_port_info_rcv.c
> +++ b/opensm/osm_port_info_rcv.c
> @@ -85,7 +85,7 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
>  	osm_madw_context_t context;
>  	ib_api_status_t status;
>  	ib_net64_t port_guid;
> -	uint8_t rate, mtu;
> +	uint8_t rate, mtu, mpb;
>  	unsigned data_vls;
>  	cl_qmap_t *p_sm_tbl;
>  	osm_remote_sm_t *p_sm;
> @@ -126,6 +126,14 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
>  		}
>  	}
>  
> +	/* Check M_Key vs M_Key protect, can we control the port ? */
> +	mpb = ib_port_info_get_mpb(p_pi);
> +	if (mpb > 0 && p_pi->m_key == 0) {
> +		OSM_LOG(sm->p_log, OSM_LOG_INFO,
> +			"Port 0x%" PRIx64 " has unknown M_Key, protection level %u\n",
> +			cl_ntoh64(port_guid), mpb);
> +	}
> +

It looks to me like the only case here is when protect bits is 1 for
gets; all others fail. Is it more than that ?

Also, would this spam the OpenSM log ?

-- Hal

>  	if (port_guid != sm->p_subn->sm_port_guid) {
>  		p_sm_tbl = &sm->p_subn->sm_guid_tbl;
>  		if (p_pi->capability_mask & IB_PORT_CAP_IS_SM) {
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
