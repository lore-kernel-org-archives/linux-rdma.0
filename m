From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags 3/3] ibqueryerrors.c: Add support for additional counters in PortCountersExtended
Date: Sat, 29 Apr 2017 20:15:13 -0400
Message-ID: <20170430001512.GD27829@phlsvsds.ph.intel.com>
References: <21830b83-d1ed-82f2-8046-c25cf8c68933@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <21830b83-d1ed-82f2-8046-c25cf8c68933-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 27, 2017 at 11:37:53AM -0400, Hal Rosenstock wrote:
> From: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Signed-off-by: Oded Nissan <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> 
> diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> index 2329f91..938753f 100644
> --- a/src/ibqueryerrors.c
> +++ b/src/ibqueryerrors.c
> @@ -395,25 +395,41 @@
>  
>  static int print_results(ib_portid_t * portid, char *node_name,
>  			 ibnd_node_t * node, uint8_t * pc, int portnum,
> -			 int *header_printed, uint8_t *pce, uint16_t cap_mask)
> +			 int *header_printed, uint8_t *pce, uint16_t cap_mask, uint32_t cap_mask2)

This line is really long for no reason...  Wrap please.

>  {
>  	char buf[1024];
>  	char *str = buf;
>  	uint32_t val = 0;
> -	int i, n;
> +	int i, ext_i, n;
>  
> -	for (n = 0, i = IB_PC_ERR_SYM_F; i <= IB_PC_VL15_DROPPED_F; i++) {
> +	for (n = 0, i = IB_PC_ERR_SYM_F, ext_i = IB_PC_EXT_ERR_SYM_F;
> +			i <= IB_PC_VL15_DROPPED_F; i++, ext_i++ ) {
>  		if (suppress(i))
>  			continue;
>  
>  		/* this is not a counter, skip it */
> -		if (i == IB_PC_COUNTER_SELECT2_F)
> +		if (i == IB_PC_COUNTER_SELECT2_F) {
> +			ext_i--;
>  			continue;
> +		}
>  
>  		mad_decode_field(pc, i, (void *)&val);
>  		if (exceeds_threshold(i, val)) {

Please extend the threshold capabilities to allow for 64 bit values to be used.
This is making a weird implicit decision that the thresholds should be in the
old smaller ranges for the counters.  That does not make sense if someone is
looking at the larger counters.


> -			n += snprintf(str + n, 1024 - n, " [%s == %u]",
> -				      mad_field_name(i), val);
> +			if (htonl(cap_mask2) & IB_PM_IS_ADDL_PORT_CTRS_EXT_SUP) {

Make this check read the proper value and then check the threshold.

> +				uint64_t val64 = 0;
> +				float val = 0;
> +				char *unit = "";
> +				mad_decode_field(pce, ext_i, (void *)&val64);
> +				if (val64) {
> +					unit = conv_cnt_human_readable(val64, &val, 0);
> +					n += snprintf(str + n, 1024 - n,
> +					              " [%s == %" PRIu64	" (%5.3f%s)]",
> +					              mad_field_name(ext_i), val64, val, unit);
> +				}
> +			}
> +			else
> +				n += snprintf(str + n, 1024 - n, " [%s == %u]",
> +					      mad_field_name(i), val);
>  
>  			/* If there are PortXmitDiscards, get details (if supported) */
>  			if (i == IB_PC_XMT_DISCARDS_F && details) {
> @@ -437,9 +453,24 @@
>  
>  	if (!suppress(IB_PC_XMT_WAIT_F)) {
>  		mad_decode_field(pc, IB_PC_XMT_WAIT_F, (void *)&val);
> -		if (exceeds_threshold(IB_PC_XMT_WAIT_F, val))
> -			n += snprintf(str + n, 1024 - n, " [%s == %u]",
> -				      mad_field_name(IB_PC_XMT_WAIT_F), val);
> +		if (exceeds_threshold(IB_PC_XMT_WAIT_F, val)) {

Same

> +			if (htonl(cap_mask2) & IB_PM_IS_ADDL_PORT_CTRS_EXT_SUP) {
> +				uint64_t val64 = 0;
> +				float val = 0;
> +				char *unit = "";
> +				mad_decode_field(pce, IB_PC_EXT_XMT_WAIT_F, (void *)&val64);
> +				if (val64) {
> +					unit = conv_cnt_human_readable(val64, &val, 0);
> +					n += snprintf(str + n, 1024 - n,
> +					              " [%s == %" PRIu64	" (%5.3f%s)]",
> +					              mad_field_name(IB_PC_EXT_XMT_WAIT_F),
> +					              val64, val, unit);
> +				}
> +			}
> +			else
> +				n += snprintf(str + n, 1024 - n, " [%s == %u]",
> +					      mad_field_name(IB_PC_XMT_WAIT_F), val);
> +		}
>  	}
>  
>  	/* if we found errors. */
> @@ -507,10 +538,11 @@
>  }
>  
>  static int query_cap_mask(ib_portid_t * portid, char *node_name, int portnum,
> -			  uint16_t * cap_mask)
> +			  uint16_t * cap_mask, uint32_t * cap_mask2)
>  {
>  	uint8_t pc[1024] = { 0 };
>  	uint16_t rc_cap_mask;
> +	uint32_t rc_cap_mask2;
>  
>  	portid->sl = lid2sl_table[portid->lid];
>  
> @@ -525,8 +557,11 @@
>  
>  	/* ClassPortInfo should be supported as part of libibmad */
>  	memcpy(&rc_cap_mask, pc + 2, sizeof(rc_cap_mask));	/* CapabilityMask */
> +	memcpy(&rc_cap_mask2, pc + 4, sizeof(rc_cap_mask2));	/* CapabilityMask2 */
> +	rc_cap_mask2 = ntohl(rc_cap_mask2) >> 5;
>  
>  	*cap_mask = rc_cap_mask;
> +	*cap_mask2 = rc_cap_mask2;
>  	return 0;
>  }
>  
> @@ -601,7 +636,7 @@
>  	return (0);
>  }
>  
> -static int print_errors(ib_portid_t * portid, uint16_t cap_mask,
> +static int print_errors(ib_portid_t * portid, uint16_t cap_mask, uint32_t cap_mask2,
>  			char *node_name, ibnd_node_t * node, int portnum,
>  			int *header_printed)
>  {
> @@ -639,7 +674,7 @@
>  		mad_encode_field(pc, IB_PC_XMT_WAIT_F, &foo);
>  	}
>  	return (print_results(portid, node_name, node, pc, portnum,
> -			      header_printed, pc_ext, cap_mask));
> +			      header_printed, pc_ext, cap_mask, cap_mask2));
>  }
>  
>  uint8_t *reset_pc_ext(void *rcvbuf, ib_portid_t * dest,
> @@ -668,6 +703,8 @@
>  	/* Same for attribute IDs */
>  	mad_set_field(rcvbuf, 0, IB_PC_EXT_PORT_SELECT_F, port);
>  	mad_set_field(rcvbuf, 0, IB_PC_EXT_COUNTER_SELECT_F, mask);
> +	mask = mask >> 16;
> +	mad_set_field(rcvbuf, 0, IB_PC_EXT_COUNTER_SELECT2_F, mask);
>  	rpc.attr.mod = 0;
>  	rpc.timeout = timeout;
>  	rpc.datasz = IB_PC_DATA_SZ;
> @@ -680,7 +717,7 @@
>  	return mad_rpc(srcport, &rpc, dest, rcvbuf, rcvbuf);
>  }
>  
> -static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
> +static void clear_port(ib_portid_t * portid, uint16_t cap_mask, uint32_t cap_mask2,
>  		       char *node_name, int port)
>  {
>  	uint8_t pc[1024] = { 0 };
> @@ -714,15 +751,21 @@
>  				      ibmad_port);
>  	}
>  
> -	if (clear_counts &&
> -	    (cap_mask &
> -	     (IB_PM_EXT_WIDTH_SUPPORTED | IB_PM_EXT_WIDTH_NOIETF_SUP))) {
> -		if (cap_mask & IB_PM_EXT_WIDTH_SUPPORTED)
> -			mask = 0xFF;
> -		else
> -			mask = 0x0F;
> +	if (cap_mask & (IB_PM_EXT_WIDTH_SUPPORTED | IB_PM_EXT_WIDTH_NOIETF_SUP)) {
> +		mask = 0;
> +		if (clear_counts)

Clean up the ambiguous if/else here.

> +			if (cap_mask & IB_PM_EXT_WIDTH_SUPPORTED)
> +				mask = 0xFF;
> +			else
> +				mask = 0x0F;
>  
> -		if (!reset_pc_ext(pc, portid, port, mask, ibd_timeout,
> +		if (clear_errors && (htonl(cap_mask2) & IB_PM_IS_ADDL_PORT_CTRS_EXT_SUP)) {
> +			mask |= 0xfff0000;
> +			if (cap_mask & IB_PM_PC_XMIT_WAIT_SUP)
> +				mask |= (1 << 28);

What about QP1_drops?

Ira

> +		}
> +
> +		if (mask && !reset_pc_ext(pc, portid, port, mask, ibd_timeout,
>  		    ibmad_port))
>  			fprintf(stderr, "Failed to reset extended data counters %s, "
>  				"%s port %d\n", node_name, portid2str(portid),
> @@ -739,6 +782,7 @@
>  	int all_port_sup = 0;
>  	ib_portid_t portid = { 0 };
>  	uint16_t cap_mask = 0;
> +	uint32_t cap_mask2 = 0;
>  	char *node_name = NULL;
>  
>  	switch (node->type) {
> @@ -775,7 +819,7 @@
>  		}
>  	}
>  
> -	if ((query_cap_mask(&portid, node_name, p, &cap_mask) == 0) &&
> +	if ((query_cap_mask(&portid, node_name, p, &cap_mask, &cap_mask2) == 0) &&
>  	    (cap_mask & IB_PM_ALL_PORT_SELECT))
>  		all_port_sup = 1;
>  
> @@ -792,12 +836,12 @@
>  						&header_printed);
>  				summary.ports_checked++;
>  				if (!all_port_sup)
> -					clear_port(&portid, cap_mask, node_name, p);
> +					clear_port(&portid, cap_mask, cap_mask2, node_name, p);
>  			}
>  		}
>  	} else {
>  		if (all_port_sup)
> -			if (!print_errors(&portid, cap_mask, node_name, node,
> +			if (!print_errors(&portid, cap_mask, cap_mask2, node_name, node,
>  					  0xFF, &header_printed)) {
>  				summary.ports_checked += node->numports;
>  				goto clear;
> @@ -811,11 +855,11 @@
>  					ib_portid_set(&portid, node->ports[p]->base_lid,
>  						      0, 0);
>  
> -				print_errors(&portid, cap_mask, node_name, node, p,
> +				print_errors(&portid, cap_mask, cap_mask2, node_name, node, p,
>  					     &header_printed);
>  				summary.ports_checked++;
>  				if (!all_port_sup)
> -					clear_port(&portid, cap_mask, node_name, p);
> +					clear_port(&portid, cap_mask, cap_mask2, node_name, p);
>  			}
>  		}
>  	}
> @@ -823,7 +867,7 @@
>  clear:
>  	summary.nodes_checked++;
>  	if (all_port_sup)
> -		clear_port(&portid, cap_mask, node_name, 0xFF);
> +		clear_port(&portid, cap_mask, cap_mask2, node_name, 0xFF);
>  
>  	free(node_name);
>  }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
