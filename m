From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCHv2 1/2] libibmad: Support for Mellanox vendor specific
 ExtendedPortInfo SM class MAD
Date: Fri, 22 Jul 2011 17:08:52 -0700
Message-ID: <20110722170852.d4c2b2d6.weiny2@llnl.gov>
References: <4E295D5B.2070005@dev.mellanox.co.il>
	<20110722153704.a0b87091.weiny2@llnl.gov>
	<4E2A0DE5.6000207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E2A0DE5.6000207-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 22 Jul 2011 16:55:17 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 7/22/2011 6:37 PM, Ira Weiny wrote:
> > I don't know if it would be more appropriate in ib_types.h or here but what are the values for the speeds indicated.  
> 
> Typically there has been duplication between libibmad and ib_types.h.

<sigh> I know...  :-(

> 
> > I assume 0 is _not_ FDR10 but what is FDR10, 0x01?
> 
> Yes; that's all that's currrently defined. The rest is reserved.
> 
> > Also with that define the dump function could be more than "mad_dump_hex".
> 
> I thought just hex dumping was sufficient for now. Other fields are done
> this way. Does it really need a pretty print ?

The pretty print is not important.  But I think the enums should be there.  Just for completeness.

Ira

> 
> -- Hal
> 
> > 
> > Ira
> > 
> > On Fri, 22 Jul 2011 04:22:03 -0700
> > Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> > 
> >>
> >> for FDR10 operation
> >>
> >> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> ---
> >> Changes since v1:
> >> Rebased
> >>
> >> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> >> index b1258bd..60bc0d8 100644
> >> --- a/include/infiniband/mad.h
> >> +++ b/include/infiniband/mad.h
> >> @@ -141,7 +141,9 @@ enum SMI_ATTR_ID {
> >>  	IB_ATTR_VENDORMADSTBL = 0x1d,
> >>  	IB_ATTR_SMINFO = 0x20,
> >>  
> >> -	IB_ATTR_LAST
> >> +	IB_ATTR_LAST,
> >> +
> >> +	IB_ATTR_MLNX_EXT_PORT_INFO = 0xff90,
> >>  };
> >>  
> >>  enum SA_ATTR_ID {
> >> @@ -1023,6 +1025,15 @@ enum MAD_FIELDS {
> >>  	IB_PC_VL_XMIT_TIME_CONG14,
> >>  	IB_PC_VL_XMIT_TIME_CONG_LAST_F,
> >>  
> >> +	/*
> >> +	 * Mellanox ExtendedPortInfo fields
> >> +	 */
> >> +	IB_MLNX_EXT_PORT_STATE_CHG_ENABLE_F,
> >> +	IB_MLNX_EXT_PORT_LINK_SPEED_SUPPORTED_F,
> >> +	IB_MLNX_EXT_PORT_LINK_SPEED_ENABLED_F,
> >> +	IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F,
> >> +	IB_MLNX_EXT_PORT_LAST_F,
> >> +
> >>  	IB_FIELD_LAST_		/* must be last */
> >>  };
> >>  
> >> @@ -1361,7 +1372,8 @@ MAD_EXPORT ib_mad_dump_fn
> >>      mad_dump_perfcounters_port_vl_xmit_flow_ctl_update_errors, mad_dump_perfcounters_port_vl_xmit_wait_counters,
> >>      mad_dump_perfcounters_sw_port_vl_congestion, mad_dump_perfcounters_rcv_con_ctrl,
> >>      mad_dump_perfcounters_sl_rcv_fecn, mad_dump_perfcounters_sl_rcv_becn,
> >> -    mad_dump_perfcounters_xmit_con_ctrl, mad_dump_perfcounters_vl_xmit_time_cong;
> >> +    mad_dump_perfcounters_xmit_con_ctrl, mad_dump_perfcounters_vl_xmit_time_cong,
> >> +    mad_dump_mlnx_ext_port_info;
> >>  
> >>  MAD_EXPORT void mad_dump_fields(char *buf, int bufsz, void *val, int valsz,
> >>  				int start, int end);
> >> diff --git a/src/dump.c b/src/dump.c
> >> index 52b2010..29fb742 100644
> >> --- a/src/dump.c
> >> +++ b/src/dump.c
> >> @@ -957,6 +957,12 @@ void mad_dump_perfcounters_vl_xmit_time_cong(char *buf, int bufsz, void *val, in
> >>  		     IB_PC_VL_XMIT_TIME_CONG_LAST_F);
> >>  }
> >>  
> >> +void mad_dump_mlnx_ext_port_info(char *buf, int bufsz, void *val, int valsz)
> >> +{
> >> +	_dump_fields(buf, bufsz, val, IB_MLNX_EXT_PORT_STATE_CHG_ENABLE_F,
> >> +		     IB_MLNX_EXT_PORT_LAST_F);
> >> +}
> >> +
> >>  void xdump(FILE * file, char *msg, void *p, int size)
> >>  {
> >>  #define HEX(x)  ((x) < 10 ? '0' + (x) : 'a' + ((x) -10))
> >> diff --git a/src/fields.c b/src/fields.c
> >> index 23947dc..04c60c7 100644
> >> --- a/src/fields.c
> >> +++ b/src/fields.c
> >> @@ -772,6 +772,15 @@ static const ib_field_t ib_mad_f[] = {
> >>  	{480, 32, "PortVLXmitTimeCong14", mad_dump_uint},
> >>  	{0, 0},			/* IB_PC_VL_XMIT_TIME_CONG_LAST_F */
> >>  
> >> +	/*
> >> +	 * Mellanox ExtendedPortInfo fields
> >> +	 */
> >> +	{BITSOFFS(24, 8), "StateChangeEnable", mad_dump_hex},
> >> +	{BITSOFFS(56, 8), "LinkSpeedSupported", mad_dump_hex},
> >> +	{BITSOFFS(88, 8), "LinkSpeedEnabled", mad_dump_hex},
> >> +	{BITSOFFS(120, 8), "LinkSpeedActive", mad_dump_hex},
> >> +	{0, 0},			/* IB_MLNX_EXT_PORT_LAST_F */
> >> +
> >>  	{0, 0}			/* IB_FIELD_LAST_ */
> >>  
> >>  };
> >> diff --git a/src/libibmad.map b/src/libibmad.map
> >> index f0b42a5..508c18b 100644
> >> --- a/src/libibmad.map
> >> +++ b/src/libibmad.map
> >> @@ -18,6 +18,7 @@ IBMAD_1.3 {
> >>  		mad_dump_linkwidth;
> >>  		mad_dump_linkwidthen;
> >>  		mad_dump_linkwidthsup;
> >> +		mad_dump_mlnx_ext_port_info;
> >>  		mad_dump_mtu;
> >>  		mad_dump_node_type;
> >>  		mad_dump_nodedesc;
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
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
