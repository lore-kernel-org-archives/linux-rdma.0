From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 04/5] infiniband-diags: ibqueryerrors --data; show/clear
 PortCountersExtended when supported
Date: Thu, 28 Apr 2011 09:54:36 -0700
Message-ID: <20110428095436.1589ff4a.weiny2@llnl.gov>
References: <20110427184656.797179ed.weiny2@llnl.gov>
	<4DB97DB2.5010808@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DB97DB2.5010808-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 28 Apr 2011 07:46:10 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 4/27/2011 9:46 PM, Ira Weiny wrote:
> > 
> > From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > Date: Tue, 26 Apr 2011 22:59:15 -0700
> > Subject: [PATCH 04/5] infiniband-diags: ibqueryerrors --data; show/clear PortCountersExtended when supported
> > 
> > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  src/ibqueryerrors.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++----
> >  1 files changed, 81 insertions(+), 7 deletions(-)
> > 
> > diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c
> > index 71fb5f6..a7556cf 100644
> > --- a/src/ibqueryerrors.c
> > +++ b/src/ibqueryerrors.c
> > @@ -340,7 +340,7 @@ static int query_and_dump(char *buf, size_t size, ib_portid_t * portid,
> >  
> >  static int print_results(ib_portid_t * portid, char *node_name,
> >  			 ibnd_node_t * node, uint8_t * pc, int portnum,
> > -			 int *header_printed)
> > +			 int *header_printed, uint8_t *pce)
> >  {
> >  	char buf[1024];
> >  	char *str = buf;
> > @@ -389,15 +389,26 @@ static int print_results(ib_portid_t * portid, char *node_name,
> >  
> >  	/* if we found errors. */
> >  	if (n != 0) {
> > -		if (data_counters)
> > -			for (i = IB_PC_XMT_BYTES_F; i <= IB_PC_RCV_PKTS_F; i++) {
> > +		if (data_counters) {
> > +			uint8_t *pkt = pc;
> > +			int start_field = IB_PC_XMT_BYTES_F;
> > +			int end_field = IB_PC_RCV_PKTS_F;
> > +
> > +			if (pce) {
> > +				pkt = pce;
> > +				start_field = IB_PC_EXT_XMT_BYTES_F;
> > +				end_field = IB_PC_EXT_RCV_MPKTS_F;
> 
> 
> Shouldn't end field vary based on whether cap mask indicates NoIETF
> support or not ? In the case of NoIETF support, it should be
> IB_PC_EXT_RCV_PKTS_F.

Yes, you are correct, I missread the spec and thought the Unicast/Multicast counters would be always set to 0, but it clearly states that in the case of NoIETF they are not.  Which probably means hardware would leave them undefined.

I will clean up both patchs, thanks,
Ira

> 
> > +			}
> > +
> > +			for (i = start_field; i <= end_field; i++) {
> >  				uint64_t val64 = 0;
> > -				mad_decode_field(pc, i, (void *)&val64);
> > +				mad_decode_field(pkt, i, (void *)&val64);
> >  				if (val64)
> >  					n += snprintf(str + n, 1024 - n,
> > -						      " [%s == %" PRIu64 "]",
> > -						      mad_field_name(i), val64);
> > +						" [%s == %" PRIu64 "]",
> > +						mad_field_name(i), val64);
> >  			}
> > +		}
> >  
> >  		if (!*header_printed) {
> >  			printf("Errors for 0x%" PRIx64 " \"%s\"\n", node->guid,
> > @@ -445,8 +456,11 @@ static int print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
> >  		      ibnd_node_t * node, int portnum, int *header_printed)
> >  {
> >  	uint8_t pc[1024];
> > +	uint8_t pce[1024];
> > +	uint8_t *pc_ext = NULL;
> >  
> >  	memset(pc, 0, 1024);
> > +	memset(pce, 0, 1024);
> >  
> >  	if (!pma_query_via(pc, portid, portnum, ibd_timeout,
> >  			   IB_GSI_PORT_COUNTERS, ibmad_port)) {
> > @@ -454,13 +468,62 @@ static int print_port(ib_portid_t * portid, uint16_t cap_mask, char *node_name,
> >  		       node_name, portid2str(portid), portnum);
> >  		return (0);
> >  	}
> > +
> > +	if (cap_mask & (IB_PM_EXT_WIDTH_SUPPORTED | IB_PM_EXT_WIDTH_NOIETF_SUP)) {
> > +		if (!pma_query_via(pce, portid, portnum, ibd_timeout,
> > +		    IB_GSI_PORT_COUNTERS_EXT, ibmad_port)) {
> > +			IBWARN("IB_GSI_PORT_COUNTERS_EXT query failed on %s, %s port %d",
> > +			       node_name, portid2str(portid), portnum);
> > +			return (0);
> > +		}
> > +		pc_ext = pce;
> > +	}
> > +
> >  	if (!(cap_mask & IB_PM_PC_XMIT_WAIT_SUP)) {
> >  		/* if PortCounters:PortXmitWait not supported clear this counter */
> >  		uint32_t foo = 0;
> >  		mad_encode_field(pc, IB_PC_XMT_WAIT_F, &foo);
> >  	}
> >  	return (print_results(portid, node_name, node, pc, portnum,
> > -			      header_printed));
> > +			      header_printed, pc_ext));
> > +}
> > +
> > +uint8_t *reset_pc_ext(void *rcvbuf, ib_portid_t * dest,
> > +		      int port, unsigned mask, unsigned timeout,
> > +		      const struct ibmad_port * srcport)
> > +{
> > +	ib_rpc_t rpc = { 0 };
> > +	int lid = dest->lid;
> > +
> > +	DEBUG("lid %u port %d mask 0x%x", lid, port, mask);
> > +
> > +	if (lid == -1) {
> > +		IBWARN("only lid routed is supported");
> > +		return NULL;
> > +	}
> > +
> > +	if (!mask)
> > +		mask = ~0;
> > +
> > +	rpc.mgtclass = IB_PERFORMANCE_CLASS;
> > +	rpc.method = IB_MAD_METHOD_SET;
> > +	rpc.attr.id = IB_GSI_PORT_COUNTERS_EXT;
> > +
> > +	memset(rcvbuf, 0, IB_MAD_SIZE);
> > +
> > +	/* Same for attribute IDs */
> > +	mad_set_field(rcvbuf, 0, IB_PC_EXT_PORT_SELECT_F, port);
> > +	mad_set_field(rcvbuf, 0, IB_PC_EXT_COUNTER_SELECT_F, mask);
> > +	rpc.attr.mod = 0;
> > +	rpc.timeout = timeout;
> > +	rpc.datasz = IB_PC_DATA_SZ;
> > +	rpc.dataoffs = IB_PC_DATA_OFFS;
> > +	if (!dest->qp)
> > +		dest->qp = 1;
> > +	if (!dest->qkey)
> > +		dest->qkey = IB_DEFAULT_QP1_QKEY;
> > +
> > +	return mad_rpc(srcport, &rpc, dest, rcvbuf, rcvbuf);
> >  }
> >  
> >  static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
> > @@ -497,6 +560,17 @@ static void clear_port(ib_portid_t * portid, uint16_t cap_mask,
> >  				      IB_GSI_PORT_RCV_ERROR_DETAILS,
> >  				      ibmad_port);
> >  	}
> > +
> > +	if (clear_counts &&
> > +	    (cap_mask &
> > +	     (IB_PM_EXT_WIDTH_SUPPORTED | IB_PM_EXT_WIDTH_NOIETF_SUP))) {
> > +		mask = 0xFF;
> 
> Shouldn't the reset mask vary based on whether cap mask indicates NoIETF
> support or not ? So something like:
> 		if (cap_mask & IB_PM_EXT_WIDTH_NOIETF_SUP)
> 			mask = 0x0F;
> 		else
> 			mask = 0xFF;
> 
> -- Hal
> 
> > +		if (!reset_pc_ext(pc, portid, port, mask, ibd_timeout,
> > +		    ibmad_port))
> > +			IBERROR("Failed to reset extended data counters %s, "
> > +				"%s port %d", node_name, portid2str(portid),
> > +				port);
> > +	}
> >  }
> >  
> >  void print_node(ibnd_node_t * node, void *user_data)
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
