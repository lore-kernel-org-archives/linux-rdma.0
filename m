From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] Add node/port information to some error messages
Date: Thu, 27 Jan 2011 16:35:38 -0500
Message-ID: <4D41E52A.5020403@dev.mellanox.co.il>
References: <20110125171445.0525eb20.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110125171445.0525eb20.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ira,

On 1/25/2011 8:14 PM, Ira Weiny wrote:
>
> From: Ira Weiny<weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
> Date: Tue, 25 Jan 2011 17:09:04 -0800
> Subject: [PATCH] Add node/port information to some error messages
>
>
> Signed-off-by: Ira Weiny<weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
> ---
>   opensm/opensm/osm_sa_path_record.c |  116 +++++++++++++++++++++++++++--------
>   opensm/opensm/osm_ucast_mgr.c      |    5 +-
>   2 files changed, 92 insertions(+), 29 deletions(-)
>
> diff --git a/opensm/opensm/osm_sa_path_record.c b/opensm/opensm/osm_sa_path_record.c
> index 2897c7b..7373875 100644
> --- a/opensm/opensm/osm_sa_path_record.c
> +++ b/opensm/opensm/osm_sa_path_record.c
> @@ -230,8 +230,9 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
>   		p_physp = osm_switch_get_route_by_lid(p_node->sw, dest_lid);
>   		if (p_physp == 0) {
>   			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F02: "
> -				"Cannot find routing to LID %u from switch for GUID 0x%016"
> -				PRIx64 "\n", dest_lid_ho,
> +				"Cannot find routing to LID %u from switch "
> +				"%s (GUID: 0x%016" PRIx64 ")\n", dest_lid_ho,
> +				p_node->print_desc,
>   				cl_ntoh64(osm_node_get_node_guid(p_node)));
>   			status = IB_NOT_FOUND;
>   			goto Exit;
> @@ -273,8 +274,9 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
>
>   		if (p_dest_physp == 0) {
>   			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F03: "
> -				"Cannot find routing to LID %u from switch for GUID 0x%016"
> -				PRIx64 "\n", dest_lid_ho,
> +				"Cannot find routing to LID %u to switch "
> +				"%s (GUID: 0x%016" PRIx64 ")\n", dest_lid_ho,
> +				p_node->print_desc,
>   				cl_ntoh64(osm_node_get_node_guid(p_node)));
>   			status = IB_NOT_FOUND;
>   			goto Exit;
> @@ -288,14 +290,17 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
>
>   	while (p_physp != p_dest_physp) {
>
> +		int tmp_pnum = p_physp->port_num;
>   		p_node = osm_physp_get_node_ptr(p_physp);
>   		p_physp = osm_physp_get_remote(p_physp);
>
>   		if (p_physp == 0) {
>   			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F05: "
> -				"Cannot find remote phys port when routing to LID %u from node GUID 0x%016"
> -				PRIx64 "\n", dest_lid_ho,
> -				cl_ntoh64(osm_node_get_node_guid(p_node)));
> +				"Cannot find remote phys port when routing to "
> +				"LID %u from node %s (GUID: 0x%016"
> +				PRIx64 "), port %d\n", dest_lid_ho, p_node->print_desc,
> +				cl_ntoh64(osm_node_get_node_guid(p_node)),
> +				tmp_pnum);
>   			status = IB_ERROR;
>   			goto Exit;
>   		}
> @@ -317,7 +322,15 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
>   			   the destination by now!
>   			 */
>   			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F06: "
> -				"Internal error, bad path\n");
> +				"Internal error, bad path while routing "
> +				"%s (GUID: 0x%016"PRIx64") port %d to "
> +				"%s (GUID: 0x%016"PRIx64") port %d\n",
> +				p_src_port->p_node->print_desc,
> +				cl_ntoh64(p_src_port->p_node->node_info.node_guid),
> +				p_src_port->p_physp->port_num,
> +				p_dest_port->p_node->print_desc,
> +				cl_ntoh64(p_dest_port->p_node->node_info.node_guid),
> +				p_dest_port->p_physp->port_num);
>   			status = IB_ERROR;
>   			goto Exit;
>   		}
> @@ -339,8 +352,9 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
>   		p_physp = osm_switch_get_route_by_lid(p_node->sw, dest_lid);
>   		if (p_physp == 0) {
>   			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F07: "
> -				"Dead end on path to LID %u from switch for GUID 0x%016"
> -				PRIx64 "\n", dest_lid_ho,
> +				"Dead end path to LID %u; on switch "
> +				"%s (GUID: 0x%016" PRIx64 ")\n", dest_lid_ho,
> +				p_node->print_desc,
>   				cl_ntoh64(osm_node_get_node_guid(p_node)));
>   			status = IB_ERROR;
>   			goto Exit;
> @@ -602,18 +616,33 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
>   		pkey = p_pr->pkey;
>   		if (!osm_physp_share_this_pkey(p_src_physp, p_dest_physp, pkey)) {
>   			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1A: "
> -				"Ports 0x%016" PRIx64 " 0x%016" PRIx64
> +				"Ports 0x%016" PRIx64 " (%s port %d) and "
> +				"0x%016" PRIx64 " (%s port %d) "
>   				" do not share specified PKey 0x%04x\n",
>   				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
> +				p_src_physp->p_node->print_desc,
> +				p_src_physp->port_num,
>   				cl_ntoh64(osm_physp_get_port_guid
> -					  (p_dest_physp)), cl_ntoh16(pkey));
> +					  (p_dest_physp)),
> +				p_dest_physp->p_node->print_desc,
> +				p_dest_physp->port_num,
> +				cl_ntoh16(pkey));
>   			status = IB_NOT_FOUND;
>   			goto Exit;
>   		}
>   		if (p_qos_level&&  p_qos_level->pkey_range_len&&
>   		!osm_qos_level_has_pkey(p_qos_level, pkey)) {
>   			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1D: "
> -				"Ports do not share PKeys defined by QoS level\n");
> +				"Ports 0x%016" PRIx64 " (%s port %d) and "
> +				"0x%016"PRIx64" (%s port %d) "
> +				"do not share PKeys defined by QoS level\n",
> +				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
> +				p_src_physp->p_node->print_desc,
> +				p_src_port->p_physp->port_num,
> +				cl_ntoh64(osm_physp_get_port_guid
> +					  (p_dest_physp)),
> +				p_dest_physp->p_node->print_desc,
> +				p_dest_port->p_physp->port_num);
>   			status = IB_NOT_FOUND;
>   			goto Exit;
>   		}
> @@ -627,11 +656,14 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
>   						     p_src_physp, p_dest_physp);
>   		if (!pkey) {
>   			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1E: "
> -				"Ports 0x%016" PRIx64 " 0x%016" PRIx64
> -				" do not share PKeys defined by QoS level\n",
> +				"Ports 0x%016" PRIx64 " (%s) and "
> +				"0x%016" PRIx64 " (%s) do not share "
> +				"PKeys defined by QoS level\n",
>   				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
> +				p_src_physp->p_node->print_desc,
>   				cl_ntoh64(osm_physp_get_port_guid
> -					  (p_dest_physp)));
> +					  (p_dest_physp)),
> +				p_dest_physp->p_node->print_desc);
>   			status = IB_NOT_FOUND;
>   			goto Exit;
>   		}
> @@ -643,11 +675,14 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
>   		pkey = osm_physp_find_common_pkey(p_src_physp, p_dest_physp);
>   		if (!pkey) {
>   			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1B: "
> -				"Ports 0x%016" PRIx64 " 0x%016" PRIx64
> -				" do not have any shared PKeys\n",
> +				"Ports 0x%016" PRIx64 " (%s) and "
> +				"0x%016" PRIx64 " (%s) do not have "
> +				"any shared PKeys\n",
>   				cl_ntoh64(osm_physp_get_port_guid(p_src_physp)),
> +				p_src_physp->p_node->print_desc,
>   				cl_ntoh64(osm_physp_get_port_guid
> -					  (p_dest_physp)));
> +					  (p_dest_physp)),
> +				p_dest_physp->p_node->print_desc);
>   			status = IB_NOT_FOUND;
>   			goto Exit;
>   		}
> @@ -679,8 +714,13 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
>   		&&  (p_qos_level->sl != sl)) {
>   			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1F: "
>   				"QoS constraints: required PathRecord SL (%u) "
> -				"doesn't match QoS policy SL (%u)\n", sl,
> -				p_qos_level->sl);
> +				"doesn't match QoS policy SL (%u) "
> +				"[%s port %d<->  %s port %d]\n", sl,
> +				p_qos_level->sl,
> +				p_src_port->p_node->print_desc,
> +				p_src_port->p_physp->port_num,
> +				p_dest_port->p_node->print_desc,
> +				p_dest_port->p_physp->port_num);
>   			status = IB_NOT_FOUND;
>   			goto Exit;
>   		}
> @@ -689,7 +729,11 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
>   		&&  osm_get_lash_sl(p_osm, p_src_port, p_dest_port) != sl) {
>   			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F23: "
>   				"Required PathRecord SL (%u) doesn't "
> -				"match LASH SL\n", sl);
> +				"match LASH SL [%s port %d<->  %s port %d]\n", sl,
> +				p_src_port->p_node->print_desc,
> +				p_src_port->p_physp->port_num,
> +				p_dest_port->p_node->print_desc,
> +				p_dest_port->p_physp->port_num);
>   			status = IB_NOT_FOUND;
>   			goto Exit;
>   		}
> @@ -722,8 +766,14 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
>   			/* this may be possible when pkey tables are created somehow in
>   			   previous runs or things are going wrong here */
>   			OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F1C: "
> -				"No partition found for PKey 0x%04x - using default SL %d\n",
> -				cl_ntoh16(pkey), sl);
> +				"No partition found for PKey 0x%04x - "
> +				"using default SL %d "
> +				"[%s port %d<->  %s port %d]\n",
> +				cl_ntoh16(pkey), sl,
> +				p_src_port->p_node->print_desc,
> +				p_src_port->p_physp->port_num,
> +				p_dest_port->p_node->print_desc,
> +				p_dest_port->p_physp->port_num);
>   		} else
>   			sl = p_prtn->sl;
>   	} else if (sa->p_subn->opt.qos) {
> @@ -740,7 +790,13 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
>
>   	if (sa->p_subn->opt.qos&&  !(valid_sl_mask&  (1<<  sl))) {
>   		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F24: "
> -			"Selected SL (%u) leads to VL15\n", sl);
> +			"Selected SL (%u) leads to VL15 "
> +			"[%s port %d<->  %s port %d]\n",
> +			sl,
> +			p_src_port->p_node->print_desc,
> +			p_src_port->p_physp->port_num,
> +			p_dest_port->p_node->print_desc,
> +			p_dest_port->p_physp->port_num);
>   		status = IB_NOT_FOUND;
>   		goto Exit;
>   	}
> @@ -1004,13 +1060,19 @@ static void pr_rcv_get_port_pair_paths(IN osm_sa_t * sa,
>
>   	if (src_lid_min_ho == 0) {
>   		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F20:"
> -			"Obtained source LID of 0. No such LID possible\n");
> +			"Obtained source LID of 0. No such LID possible "
> +			"(%s port %d)\n",
> +			p_src_port->p_node->print_desc,
> +			p_src_port->p_physp->port_num);
>   		goto Exit;
>   	}
>
>   	if (dest_lid_min_ho == 0) {
>   		OSM_LOG(sa->p_log, OSM_LOG_ERROR, "ERR 1F21:"
> -			"Obtained destination LID of 0. No such LID possible\n");
> +			"Obtained destination LID of 0. No such LID possible "
> +			"(%s port %d)\n",
> +			p_dest_port->p_node->print_desc,
> +			p_dest_port->p_physp->port_num);
>   		goto Exit;
>   	}

Shouldn't osm_sa_multipath_record.c be updated similarly to this ?

-- Hal

> diff --git a/opensm/opensm/osm_ucast_mgr.c b/opensm/opensm/osm_ucast_mgr.c
> index 37b8741..9120480 100644
> --- a/opensm/opensm/osm_ucast_mgr.c
> +++ b/opensm/opensm/osm_ucast_mgr.c
> @@ -217,9 +217,10 @@ static void ucast_mgr_process_port(IN osm_ucast_mgr_t * p_mgr,
>   	 * the initialization. Don't handle this port. */
>   	if (min_lid_ho == 0 || max_lid_ho == 0) {
>   		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR, "ERR 3A04: "
> -			"Port 0x%" PRIx64 " has LID 0. An initialization "
> +			"Port 0x%" PRIx64 " (%s) has LID 0. An initialization "
>   			"error occurred. Ignoring port\n",
> -			cl_ntoh64(osm_port_get_guid(p_port)));
> +			cl_ntoh64(osm_port_get_guid(p_port)),
> +			p_port->p_node->print_desc);
>   		goto Exit;
>   	}
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
