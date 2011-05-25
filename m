From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 2/2] infiniband-diags: perfquery; Support
 PortCountersExtendedNoIETF
Date: Wed, 25 May 2011 08:40:23 -0700
Message-ID: <20110525084023.4dbac8c5.weiny2@llnl.gov>
References: <20110524144206.edb3b5d4.weiny2@llnl.gov>
	<4DDCF65C.6000309@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DDCF65C.6000309-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 25 May 2011 05:30:20 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 5/24/2011 5:42 PM, Ira Weiny wrote:
> > 
> > From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > Date: Fri, 13 May 2011 22:28:55 -0700
> > Subject: [PATCH 2/2] infiniband-diags: perfquery; Support PortCountersExtendedNoIETF
> > 
> > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  src/perfquery.c |   52 ++++++++++++++++++++++++++++++++--------------------
> >  1 files changed, 32 insertions(+), 20 deletions(-)
> > 
> > diff --git a/src/perfquery.c b/src/perfquery.c
> > index 165c419..d34958f 100644
> > --- a/src/perfquery.c
> > +++ b/src/perfquery.c
> > @@ -227,7 +227,7 @@ static void output_aggregate_perfcounters(ib_portid_t * portid,
> >  	       portid2str(portid), ALL_PORTS, ntohs(cap_mask), buf);
> >  }
> >  
> > -static void aggregate_perfcounters_ext(void)
> > +static void aggregate_perfcounters_ext(uint16_t cap_mask)
> >  {
> >  	uint32_t val;
> >  	uint64_t val64;
> > @@ -244,14 +244,17 @@ static void aggregate_perfcounters_ext(void)
> >  	aggregate_64bit(&perf_count_ext.portxmitpkts, val64);
> >  	mad_decode_field(pc, IB_PC_EXT_RCV_PKTS_F, &val64);
> >  	aggregate_64bit(&perf_count_ext.portrcvpkts, val64);
> > -	mad_decode_field(pc, IB_PC_EXT_XMT_UPKTS_F, &val64);
> > -	aggregate_64bit(&perf_count_ext.portunicastxmitpkts, val64);
> > -	mad_decode_field(pc, IB_PC_EXT_RCV_UPKTS_F, &val64);
> > -	aggregate_64bit(&perf_count_ext.portunicastrcvpkts, val64);
> > -	mad_decode_field(pc, IB_PC_EXT_XMT_MPKTS_F, &val64);
> > -	aggregate_64bit(&perf_count_ext.portmulticastxmitpkits, val64);
> > -	mad_decode_field(pc, IB_PC_EXT_RCV_MPKTS_F, &val64);
> > -	aggregate_64bit(&perf_count_ext.portmulticastrcvpkts, val64);
> > +
> > +	if (cap_mask & IB_PM_EXT_WIDTH_NOIETF_SUP) {
> > +		mad_decode_field(pc, IB_PC_EXT_XMT_UPKTS_F, &val64);
> > +		aggregate_64bit(&perf_count_ext.portunicastxmitpkts, val64);
> > +		mad_decode_field(pc, IB_PC_EXT_RCV_UPKTS_F, &val64);
> > +		aggregate_64bit(&perf_count_ext.portunicastrcvpkts, val64);
> > +		mad_decode_field(pc, IB_PC_EXT_XMT_MPKTS_F, &val64);
> > +		aggregate_64bit(&perf_count_ext.portmulticastxmitpkits, val64);
> > +		mad_decode_field(pc, IB_PC_EXT_RCV_MPKTS_F, &val64);
> > +		aggregate_64bit(&perf_count_ext.portmulticastrcvpkts, val64);
> > +	}
> 
> Doesn't NoIETF mean these counters aren't supported ? How can you get
> unicast/multicast transmit/receive counters ?

Typo, that should be.

	if (cap_mask & IB_PM_EXT_WIDTH_SUPPORTED) {
...

> 
> >  }
> >  
> >  static void output_aggregate_perfcounters_ext(ib_portid_t * portid,
> > @@ -260,6 +263,8 @@ static void output_aggregate_perfcounters_ext(ib_portid_t * portid,
> >  	char buf[1024];
> >  	uint32_t val = ALL_PORTS;
> >  
> > +	memset(buf, 0, 1024);
> > +
> >  	/* set port_select to 255 to emulate AllPortSelect */
> >  	mad_encode_field(pc, IB_PC_EXT_PORT_SELECT_F, &val);
> >  	mad_encode_field(pc, IB_PC_EXT_COUNTER_SELECT_F,
> > @@ -271,14 +276,17 @@ static void output_aggregate_perfcounters_ext(ib_portid_t * portid,
> >  	mad_encode_field(pc, IB_PC_EXT_XMT_PKTS_F,
> >  			 &perf_count_ext.portxmitpkts);
> >  	mad_encode_field(pc, IB_PC_EXT_RCV_PKTS_F, &perf_count_ext.portrcvpkts);
> > -	mad_encode_field(pc, IB_PC_EXT_XMT_UPKTS_F,
> > -			 &perf_count_ext.portunicastxmitpkts);
> > -	mad_encode_field(pc, IB_PC_EXT_RCV_UPKTS_F,
> > -			 &perf_count_ext.portunicastrcvpkts);
> > -	mad_encode_field(pc, IB_PC_EXT_XMT_MPKTS_F,
> > -			 &perf_count_ext.portmulticastxmitpkits);
> > -	mad_encode_field(pc, IB_PC_EXT_RCV_MPKTS_F,
> > -			 &perf_count_ext.portmulticastrcvpkts);
> > +
> > +	if (cap_mask & IB_PM_EXT_WIDTH_NOIETF_SUP) {
> > +		mad_encode_field(pc, IB_PC_EXT_XMT_UPKTS_F,
> > +				 &perf_count_ext.portunicastxmitpkts);
> > +		mad_encode_field(pc, IB_PC_EXT_RCV_UPKTS_F,
> > +				 &perf_count_ext.portunicastrcvpkts);
> > +		mad_encode_field(pc, IB_PC_EXT_XMT_MPKTS_F,
> > +				 &perf_count_ext.portmulticastxmitpkits);
> > +		mad_encode_field(pc, IB_PC_EXT_RCV_MPKTS_F,
> > +				 &perf_count_ext.portmulticastrcvpkts);
> > +	}
> 
> Same comment as above.

Yep same correction.

Thanks for catching this,
Ira

> 
> -- Hal
> 
> >  
> >  	mad_dump_perfcounters_ext(buf, sizeof buf, pc, sizeof pc);
> >  
> > @@ -312,9 +320,13 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
> >  							(cap_mask & IB_PM_PC_XMIT_WAIT_SUP)?IB_PC_LAST_F:(IB_PC_RCV_PKTS_F+1));
> >  
> >  	} else {
> > -		if (!(cap_mask & IB_PM_EXT_WIDTH_SUPPORTED))	/* 1.2 errata: bit 9 is extended counter support */
> > +		/* 1.2 errata: bit 9 is extended counter support
> > +		 * bit 10 is extended counter NoIETF
> > +		 */
> > +		if (!(cap_mask & IB_PM_EXT_WIDTH_SUPPORTED) &&
> > +		    !(cap_mask & IB_PM_EXT_WIDTH_NOIETF_SUP))
> >  			IBWARN
> > -			    ("PerfMgt ClassPortInfo 0x%x extended counters not indicated\n",
> > +			    ("PerfMgt ClassPortInfo 0x%x; No extended counter support indicated\n",
> >  			     ntohs(cap_mask));
> >  
> >  		memset(pc, 0, sizeof(pc));
> > @@ -322,7 +334,7 @@ static void dump_perfcounters(int extended, int timeout, uint16_t cap_mask,
> >  				   IB_GSI_PORT_COUNTERS_EXT, srcport))
> >  			IBERROR("perfextquery");
> >  		if (aggregate)
> > -			aggregate_perfcounters_ext();
> > +			aggregate_perfcounters_ext(cap_mask);
> >  		else
> >  			mad_dump_perfcounters_ext(buf, sizeof buf, pc,
> >  						  sizeof pc);
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
