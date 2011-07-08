From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 3/3] libibmad: Add PortExtendedSpeedsCounters support
Date: Fri, 8 Jul 2011 14:30:20 -0700
Message-ID: <20110708143020.97015e3f.weiny2@llnl.gov>
References: <4E15E3CD.7060900@dev.mellanox.co.il>
	<20110708133540.e9ac0e85.weiny2@llnl.gov>
	<4E177564.5000503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E177564.5000503-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 8 Jul 2011 14:23:48 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> Hi Ira,
> 
> On 7/8/2011 4:35 PM, Ira Weiny wrote:
> > Hey Hal,
> > 
> > On Thu, 7 Jul 2011 09:50:21 -0700
> > Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> > 
> >>
> >> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> ---
> >>  include/infiniband/mad.h |   48 +++++++++++++++++++++++++++++++++++++++++++++-
> >>  src/dump.c               |    5 ++++
> >>  src/fields.c             |   45 +++++++++++++++++++++++++++++++++++++++++++
> >>  src/libibmad.map         |    1 +
> >>  4 files changed, 98 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> >> index 7500e1a..426095b 100644
> >> --- a/include/infiniband/mad.h
> >> +++ b/include/infiniband/mad.h
> >> @@ -175,6 +175,7 @@ enum GSI_ATTR_ID {
> >>  	IB_GSI_PORT_RCV_ERROR_DETAILS = 0x15,
> >>  	IB_GSI_PORT_XMIT_DISCARD_DETAILS = 0x16,
> >>  	IB_GSI_PORT_COUNTERS_EXT = 0x1D,
> >> +	IB_GSI_PORT_EXT_SPEEDS_COUNTERS = 0x1F,
> >>  	IB_GSI_PORT_XMIT_DATA_SL = 0x36,
> >>  	IB_GSI_PORT_RCV_DATA_SL = 0x37,
> >>  	IB_GSI_ATTR_LAST
> >> @@ -759,6 +760,51 @@ enum MAD_FIELDS {
> >>  	IB_PORT_LINK_SPEED_EXT_ENABLED_F,
> >>  	IB_PORT_LINK_SPEED_EXT_LAST_F,
> >>  
> >> +	/*
> >> +	 * PortExtendedSpeedsCounters fields
> >> +	 */
> >> +	IB_PESC_PORT_SELECT_F,
> >> +	IB_PESC_COUNTER_SELECT_F,
> >> +	IB_PESC_SYNC_HDR_ERR_CTR_F,
> >> +	IB_PESC_UNK_BLOCK_CTR_F,
> >> +	IB_PESC_ERR_DET_CTR_LANE0_F,
> >> +	IB_PESC_ERR_DET_CTR_LANE1_F,
> >> +	IB_PESC_ERR_DET_CTR_LANE2_F,
> >> +	IB_PESC_ERR_DET_CTR_LANE3_F,
> >> +	IB_PESC_ERR_DET_CTR_LANE4_F,
> >> +	IB_PESC_ERR_DET_CTR_LANE5_F,
> >> +	IB_PESC_ERR_DET_CTR_LANE6_F,
> >> +	IB_PESC_ERR_DET_CTR_LANE7_F,
> >> +	IB_PESC_ERR_DET_CTR_LANE8_F,
> >> +	IB_PESC_ERR_DET_CTR_LANE9_F,
> >> +	IB_PESC_ERR_DET_CTR_LANE10_F,
> >> +	IB_PESC_ERR_DET_CTR_LANE11_F,
> >> +	IB_FEC_CORRECTABLE_BLOCK_CTR_LANE0_F,
> >> +	IB_FEC_CORRECTABLE_BLOCK_CTR_LANE1_F,
> >> +	IB_FEC_CORRECTABLE_BLOCK_CTR_LANE2_F,
> >> +	IB_FEC_CORRECTABLE_BLOCK_CTR_LANE3_F,
> >> +	IB_FEC_CORRECTABLE_BLOCK_CTR_LANE4_F,
> >> +	IB_FEC_CORRECTABLE_BLOCK_CTR_LANE5_F,
> >> +	IB_FEC_CORRECTABLE_BLOCK_CTR_LANE6_F,
> >> +	IB_FEC_CORRECTABLE_BLOCK_CTR_LANE7_F,
> >> +	IB_FEC_CORRECTABLE_BLOCK_CTR_LANE8_F,
> >> +	IB_FEC_CORRECTABLE_BLOCK_CTR_LANE9_F,
> >> +	IB_FEC_CORRECTABLE_BLOCK_CTR_LANE10_F,
> >> +	IB_FEC_CORRECTABLE_BLOCK_CTR_LANE11_F,
> >> +	IB_FEC_UNCORRECTABLE_BLOCK_CTR_LANE0_F,
> >> +	IB_FEC_UNCORRECTABLE_BLOCK_CTR_LANE1_F,
> >> +	IB_FEC_UNCORRECTABLE_BLOCK_CTR_LANE2_F,
> >> +	IB_FEC_UNCORRECTABLE_BLOCK_CTR_LANE3_F,
> >> +	IB_FEC_UNCORRECTABLE_BLOCK_CTR_LANE4_F,
> >> +	IB_FEC_UNCORRECTABLE_BLOCK_CTR_LANE5_F,
> >> +	IB_FEC_UNCORRECTABLE_BLOCK_CTR_LANE6_F,
> >> +	IB_FEC_UNCORRECTABLE_BLOCK_CTR_LANE7_F,
> >> +	IB_FEC_UNCORRECTABLE_BLOCK_CTR_LANE8_F,
> >> +	IB_FEC_UNCORRECTABLE_BLOCK_CTR_LANE9_F,
> >> +	IB_FEC_UNCORRECTABLE_BLOCK_CTR_LANE10_F,
> >> +	IB_FEC_UNCORRECTABLE_BLOCK_CTR_LANE11_F,
> > 
> > I hate to have such long names but I think for consistency these should be:
> > 
> > IB_PESC_FEC_*
> 
> OK; do you want an updated patch with those names ?

If you could, Thanks,
Ira

> 
> -- Hal
> 
> > 
> > Ira
> > 
> >> +	IB_PESC_LAST_F,
> >> +
> >>  	IB_FIELD_LAST_		/* must be last */
> >>  };
> >>  
> >> @@ -1091,7 +1137,7 @@ MAD_EXPORT ib_mad_dump_fn
> >>      mad_dump_switchinfo, mad_dump_perfcounters, mad_dump_perfcounters_ext,
> >>      mad_dump_perfcounters_xmt_sl, mad_dump_perfcounters_rcv_sl,
> >>      mad_dump_perfcounters_xmt_disc, mad_dump_perfcounters_rcv_err,
> >> -    mad_dump_portsamples_control;
> >> +    mad_dump_portsamples_control, mad_dump_port_ext_speeds_counters;
> >>  
> >>  MAD_EXPORT void mad_dump_fields(char *buf, int bufsz, void *val, int valsz,
> >>  				int start, int end);
> >> diff --git a/src/dump.c b/src/dump.c
> >> index 39e1bbf..4b4279d 100644
> >> --- a/src/dump.c
> >> +++ b/src/dump.c
> >> @@ -831,6 +831,11 @@ void mad_dump_portsamples_control(char *buf, int bufsz, void *val, int valsz)
> >>  	_dump_fields(buf, bufsz, val, IB_PSC_OPCODE_F, IB_PSC_LAST_F);
> >>  }
> >>  
> >> +void mad_dump_port_ext_speeds_counters(char *buf, int bufsz, void *val, int valsz)
> >> +{
> >> +	_dump_fields(buf, bufsz, val, IB_PESC_PORT_SELECT_F, IB_PESC_LAST_F);
> >> +}
> >> +
> >>  void xdump(FILE * file, char *msg, void *p, int size)
> >>  {
> >>  #define HEX(x)  ((x) < 10 ? '0' + (x) : 'a' + ((x) -10))
> >> diff --git a/src/fields.c b/src/fields.c
> >> index 92c1b6b..8039882 100644
> >> --- a/src/fields.c
> >> +++ b/src/fields.c
> >> @@ -533,6 +533,51 @@ static const ib_field_t ib_mad_f[] = {
> >>  	{BITSOFFS(507, 5), "LinkSpeedExtEnabled", mad_dump_linkspeedexten},
> >>  	{0, 0},			/* IB_PORT_LINK_SPEED_EXT_LAST_F */
> >>  
> >> +	/*
> >> +	 * PortExtendedSpeedsCounters fields
> >> +	 */
> >> +	{BITSOFFS(8, 8), "PortSelect", mad_dump_uint},
> >> +	{64, 64, "CounterSelect", mad_dump_hex},
> >> +	{BITSOFFS(128, 8), "SyncHeaderErrorCounter", mad_dump_uint},
> >> +	{BITSOFFS(136, 8), "UnknownBlockCounter", mad_dump_uint},
> >> +	{BITSOFFS(144, 8), "ErrorDetectionCounterLane0", mad_dump_uint},
> >> +	{BITSOFFS(152, 8), "ErrorDetectionCounterLane1", mad_dump_uint},
> >> +	{BITSOFFS(160, 8), "ErrorDetectionCounterLane2", mad_dump_uint},
> >> +	{BITSOFFS(168, 8), "ErrorDetectionCounterLane3", mad_dump_uint},
> >> +	{BITSOFFS(176, 8), "ErrorDetectionCounterLane4", mad_dump_uint},
> >> +	{BITSOFFS(184, 8), "ErrorDetectionCounterLane5", mad_dump_uint},
> >> +	{BITSOFFS(192, 8), "ErrorDetectionCounterLane6", mad_dump_uint},
> >> +	{BITSOFFS(200, 8), "ErrorDetectionCounterLane7", mad_dump_uint},
> >> +	{BITSOFFS(208, 8), "ErrorDetectionCounterLane8", mad_dump_uint},
> >> +	{BITSOFFS(216, 8), "ErrorDetectionCounterLane9", mad_dump_uint},
> >> +	{BITSOFFS(224, 8), "ErrorDetectionCounterLane10", mad_dump_uint},
> >> +	{BITSOFFS(232, 8), "ErrorDetectionCounterLane11", mad_dump_uint},
> >> +	{256, 32, "FECCorrectableBlockCtrLane0", mad_dump_uint},
> >> +	{288, 32, "FECCorrectableBlockCtrLane1", mad_dump_uint},
> >> +	{320, 32, "FECCorrectableBlockCtrLane2", mad_dump_uint},
> >> +	{352, 32, "FECCorrectableBlockCtrLane3", mad_dump_uint},
> >> +	{384, 32, "FECCorrectableBlockCtrLane4", mad_dump_uint},
> >> +	{416, 32, "FECCorrectableBlockCtrLane5", mad_dump_uint},
> >> +	{448, 32, "FECCorrectableBlockCtrLane6", mad_dump_uint},
> >> +	{480, 32, "FECCorrectableBlockCtrLane7", mad_dump_uint},
> >> +	{512, 32, "FECCorrectableBlockCtrLane8", mad_dump_uint},
> >> +	{544, 32, "FECCorrectableBlockCtrLane9", mad_dump_uint},
> >> +	{580, 32, "FECCorrectableBlockCtrLane10", mad_dump_uint},
> >> +	{608, 32, "FECCorrectableBlockCtrLane11", mad_dump_uint},
> >> +	{640, 32, "FECUncorrectableBlockCtrLane0", mad_dump_uint},
> >> +	{672, 32, "FECUncorrectableBlockCtrLane1", mad_dump_uint},
> >> +	{704, 32, "FECUncorrectableBlockCtrLane2", mad_dump_uint},
> >> +	{736, 32, "FECUncorrectableBlockCtrLane3", mad_dump_uint},
> >> +	{768, 32, "FECUncorrectableBlockCtrLane4", mad_dump_uint},
> >> +	{800, 32, "FECUncorrectableBlockCtrLane5", mad_dump_uint},
> >> +	{832, 32, "FECUncorrectableBlockCtrLane6", mad_dump_uint},
> >> +	{864, 32, "FECUncorrectableBlockCtrLane7", mad_dump_uint},
> >> +	{896, 32, "FECUncorrectableBlockCtrLane8", mad_dump_uint},
> >> +	{928, 32, "FECUncorrectableBlockCtrLane9", mad_dump_uint},
> >> +	{960, 32, "FECUncorrectableBlockCtrLane10", mad_dump_uint},
> >> +	{992, 32, "FECUncorrectableBlockCtrLane11", mad_dump_uint},
> >> +	{0, 0},			/* IB_PESC_LAST_F */
> >> +
> >>  	{0, 0}			/* IB_FIELD_LAST_ */
> >>  
> >>  };
> >> diff --git a/src/libibmad.map b/src/libibmad.map
> >> index b9d1205..457ec86 100644
> >> --- a/src/libibmad.map
> >> +++ b/src/libibmad.map
> >> @@ -115,5 +115,6 @@ IBMAD_1.3 {
> >>  		ib_resolve_self_via;
> >>  		mad_field_name;
> >>  		bm_call_via;
> >> +		mad_dump_port_ext_speeds_counters;
> >>  	local: *;
> >>  };
> >> -- 
> >> 1.5.3
> >>
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
