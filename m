From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 05/5] infiniband-diags: ibqueryerrors; add --counters
 option
Date: Thu, 28 Apr 2011 10:46:23 -0400
Message-ID: <4DB97DBF.20709@dev.mellanox.co.il>
References: <20110427184700.f2a561c6.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110427184700.f2a561c6.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/27/2011 9:47 PM, Ira Weiny wrote:
> 
> From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> Date: Wed, 27 Apr 2011 01:07:59 -0700
> Subject: [PATCH 05/5] infiniband-diags: ibqueryerrors; add --counters option
> 
> Display the data counters (optionally extended data counters) for all ports in the fabric.
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---
>  src/ibqueryerrors.c |  139 ++++++++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 110 insertions(+), 29 deletions(-)
> 
> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> index a7556cf..26ff72b 100644
> --- a/src/ibqueryerrors.c
> +++ b/src/ibqueryerrors.c
> @@ -62,6 +62,7 @@ static nn_map_t *node_name_map = NULL;
>  static char *load_cache_file = NULL;
>  
>  int data_counters = 0;
> +int data_counters_only = 0;
>  int port_config = 0;
>  uint64_t node_guid = 0;
>  char *node_guid_str = NULL;
> @@ -452,8 +453,65 @@ static int query_cap_mask(ib_portid_t * portid, char *node_name, int portnum,
>  	return 0;
>  }
>  
> -static int print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
> -		      ibnd_node_t * node, int portnum, int *header_printed)
> +static int print_data_cnts(ib_portid_t * portid, uint16_t cap_mask,
> +			   char *node_name, ibnd_node_t * node, int portnum,
> +			   int *header_printed)
> +{
> +	uint8_t pc[1024];
> +	int i;
> +	int start_field = IB_PC_XMT_BYTES_F;
> +	int end_field = IB_PC_RCV_PKTS_F;
> +
> +	memset(pc, 0, 1024);
> +
> +	if (cap_mask & (IB_PM_EXT_WIDTH_SUPPORTED | IB_PM_EXT_WIDTH_NOIETF_SUP)) {
> +		if (!pma_query_via(pc, portid, portnum, ibd_timeout,
> +				   IB_GSI_PORT_COUNTERS_EXT, ibmad_port)) {
> +			IBWARN("IB_GSI_PORT_COUNTERS_EXT query failed on %s, %s port %d",
> +			       node_name, portid2str(portid), portnum);
> +			return (1);
> +		}
> +		start_field = IB_PC_EXT_XMT_BYTES_F;
> +		end_field = IB_PC_EXT_RCV_MPKTS_F;

Shouldn't end field vary based on whether it's NoIETF or not ? In the
case of NoIETF, it should be IB_PC_EXT_RCV_PKTS_F so something like:

	if (cap_mask & IB_PM_EXT_WIDTH_NOIETF_SUP)
		end_field = IB_PC_EXT_RCV_PKTS_F;
	else
		end_field = IB_PC_EXT_RCV_MPKTS_F;

-- Hal

> +	} else {
> +		if (!pma_query_via(pc, portid, portnum, ibd_timeout,
> +				   IB_GSI_PORT_COUNTERS, ibmad_port)) {
> +			IBWARN("IB_GSI_PORT_COUNTERS query failed on %s, %s port %d",
> +			       node_name, portid2str(portid), portnum);
> +			return (1);
> +		}
> +		start_field = IB_PC_XMT_BYTES_F;
> +		end_field = IB_PC_RCV_PKTS_F;
> +	}
> +
> +	if (!*header_printed) {
> +		printf("Data Counters for 0x%" PRIx64 " \"%s\"\n", node->guid,
> +		       node_name);
> +		*header_printed = 1;
> +	}
> +
> +	if (portnum == 0xFF)
> +		printf("   GUID 0x%" PRIx64 " port ALL:", node->guid);
> +	else
> +		printf("   GUID 0x%" PRIx64 " port %d:",
> +		       node->guid, portnum);
> +
> +	for (i = start_field; i <= end_field; i++) {
> +		uint64_t val64 = 0;
> +		mad_decode_field(pc, i, (void *)&val64);
> +		printf(" [%s == %" PRIu64 "]", mad_field_name(i), val64);
> +	}
> +	printf("\n");
> +
> +	if (portnum != 0xFF && port_config)
> +		print_port_config(node_name, node, portnum);
> +
> +	return (0);
> +}
> +
> +static int print_errors(ib_portid_t * portid, uint16_t cap_mask,
> +			char *node_name, ibnd_node_t * node, int portnum,
> +			int *header_printed)
>  {
>  	uint8_t pc[1024];
>  	uint8_t pce[1024];
> @@ -535,9 +593,6 @@ static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
>  	 */
>  	uint32_t mask = 0;
>  
> -	if (!clear_errors && !clear_counts)
> -		return;
> -
>  	if (clear_errors) {
>  		mask |= 0xFFF;
>  		if (cap_mask & IB_PM_PC_XMIT_WAIT_SUP)
> @@ -546,11 +601,13 @@ static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
>  	if (clear_counts)
>  		mask |= 0xF000;
>  
> -	if (!performance_reset_via(pc, portid, port, mask, ibd_timeout,
> -				   IB_GSI_PORT_COUNTERS, ibmad_port))
> -		IBERROR("Failed to reset errors %s port %d", node_name, port);
> +	if (mask)
> +		if (!performance_reset_via(pc, portid, port, mask, ibd_timeout,
> +					   IB_GSI_PORT_COUNTERS, ibmad_port))
> +			IBERROR("Failed to reset errors %s port %d", node_name,
> +				port);
>  
> -	if (details && clear_errors) {
> +	if (clear_errors && details) {
>  		memset(pc, 0, 1024);
>  		performance_reset_via(pc, portid, port, 0xf, ibd_timeout,
>  				      IB_GSI_PORT_XMIT_DISCARD_DETAILS,
> @@ -617,29 +674,49 @@ void print_node(ibnd_node_t * node, void *user_data)
>  			}
>  		}
>  	}
> +
>  	if ((query_cap_mask(&portid, node_name, p, &cap_mask) == 0) &&
> -	    (cap_mask & IB_PM_ALL_PORT_SELECT)) {
> +	    (cap_mask & IB_PM_ALL_PORT_SELECT))
>  		all_port_sup = 1;
> -		if (!print_port(&portid, cap_mask, node_name, node,
> -				0xFF, &header_printed)) {
> -			summary.ports_checked += node->numports;
> -			goto clear;
> -		}
> -	}
>  
> -	for (p = startport; p <= node->numports; p++) {
> -		if (node->ports[p]) {
> -			if (node->type == IB_NODE_SWITCH)
> -				ib_portid_set(&portid, node->smalid, 0, 0);
> -			else
> -				ib_portid_set(&portid, node->ports[p]->base_lid,
> -					      0, 0);
> +	if (data_counters_only) {
> +		for (p = startport; p <= node->numports; p++) {
> +			if (node->ports[p]) {
> +				if (node->type == IB_NODE_SWITCH)
> +					ib_portid_set(&portid, node->smalid, 0, 0);
> +				else
> +					ib_portid_set(&portid, node->ports[p]->base_lid,
> +						      0, 0);
> +
> +				print_data_cnts(&portid, cap_mask, node_name, node, p,
> +						&header_printed);
> +				summary.ports_checked++;
> +				if (!all_port_sup)
> +					clear_port(&portid, cap_mask, node_name, p);
> +			}
> +		}
> +	} else {
> +		if (all_port_sup)
> +			if (!print_errors(&portid, cap_mask, node_name, node,
> +					  0xFF, &header_printed)) {
> +				summary.ports_checked += node->numports;
> +				goto clear;
> +			}
>  
> -			print_port(&portid, cap_mask, node_name, node, p,
> -				   &header_printed);
> -			summary.ports_checked++;
> -			if (!all_port_sup)
> -				clear_port(&portid, cap_mask, node_name, p);
> +		for (p = startport; p <= node->numports; p++) {
> +			if (node->ports[p]) {
> +				if (node->type == IB_NODE_SWITCH)
> +					ib_portid_set(&portid, node->smalid, 0, 0);
> +				else
> +					ib_portid_set(&portid, node->ports[p]->base_lid,
> +						      0, 0);
> +
> +				print_errors(&portid, cap_mask, node_name, node, p,
> +					     &header_printed);
> +				summary.ports_checked++;
> +				if (!all_port_sup)
> +					clear_port(&portid, cap_mask, node_name, p);
> +			}
>  		}
>  	}
>  
> @@ -713,6 +790,9 @@ static int process_opt(void *context, int ch, char *optarg)
>  	case 8:
>  		threshold_file = strdup(optarg);
>  		break;
> +	case 9:
> +		data_counters_only = 1;
> +		break;
>  	case 'G':
>  	case 'S':
>  		node_guid_str = optarg;
> @@ -771,11 +851,12 @@ int main(int argc, char **argv)
>  		 "specify an alternate thresold file, default: " DEF_THRES_FILE},
>  		{"GNDN", 'R', 0, NULL,
>  		 "(This option is obsolete and does nothing)"},
> -		{"data", 2, 0, NULL, "include the data counters in the output"},
> +		{"data", 2, 0, NULL, "include data counters for ports with errors"},
>  		{"switch", 3, 0, NULL, "print data for switches only"},
>  		{"ca", 4, 0, NULL, "print data for CA's only"},
>  		{"router", 5, 0, NULL, "print data for routers only"},
>  		{"details", 6, 0, NULL, "include transmit discard details"},
> +		{"counters", 9, 0, NULL, "print data counters only"},
>  		{"clear-errors", 'k', 0, NULL,
>  		 "Clear error counters after read"},
>  		{"clear-counts", 'K', 0, NULL,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
