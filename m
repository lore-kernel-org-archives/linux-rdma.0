From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] Support optional performance counters, including	congestion
 control performance counters.
Date: Wed, 20 Jul 2011 09:45:19 -0400
Message-ID: <4E26DBEF.1030205@dev.mellanox.co.il>
References: <1311113629.6898.139.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1311113629.6898.139.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Albert L. Chu" <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On 2:59 PM, Albert L. Chu wrote:

Looks mostly good to me. Some nits/typos and one question below:
> Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---
>  include/infiniband/mad.h |  228 +++++++++++++++++++++++++++++++++++++++++++++-
>  src/dump.c               |  121 ++++++++++++++++++++++++
>  src/fields.c             |  194 +++++++++++++++++++++++++++++++++++++++
>  src/libibmad.map         |   12 +++
>  4 files changed, 554 insertions(+), 1 deletions(-)
>
> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> index f00bf7a..d748aec 100644
> --- a/include/infiniband/mad.h
> +++ b/include/infiniband/mad.h
> @@ -174,8 +174,20 @@ enum GSI_ATTR_ID {
>  	IB_GSI_PORT_COUNTERS = 0x12,
>  	IB_GSI_PORT_RCV_ERROR_DETAILS = 0x15,
>  	IB_GSI_PORT_XMIT_DISCARD_DETAILS = 0x16,
> +	IB_GIS_PORT_PORT_OP_RCV_COUNTERS = 0x17,
> +	IB_GIS_PORT_PORT_FLOW_CTL_COUNTERS = 0x18,
> +	IB_GIS_PORT_PORT_VL_OP_PACKETS = 0x19,
> +	IB_GIS_PORT_PORT_VL_OP_DATA = 0x1A,
> +	IB_GIS_PORT_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS = 0x1B,
> +	IB_GIS_PORT_PORT_VL_XMIT_WAIT_COUNTERS = 0x1C,

typo: IB_GIS_xxx -> IB_GSI_xxx

>  	IB_GSI_PORT_COUNTERS_EXT = 0x1D,
>  	IB_GSI_PORT_EXT_SPEEDS_COUNTERS = 0x1F,
> +	IB_GSI_SW_PORT_VL_CONGESTION = 0x30,
> +	IB_GSI_PORT_RCV_CON_CTRL = 0x31,
> +	IB_GSI_PORT_SL_RCV_FECN = 0x32,
> +	IB_GSI_PORT_SL_RCV_BECN = 0x33,
> +	IB_GSI_PORT_XMIT_CON_CTRL = 0x34,
> +	IB_GSI_PORT_VL_XMIT_TIME_CONG = 0x35,
>  	IB_GSI_PORT_XMIT_DATA_SL = 0x36,
>  	IB_GSI_PORT_RCV_DATA_SL = 0x37,
>  	IB_GSI_ATTR_LAST
> @@ -805,6 +817,214 @@ enum MAD_FIELDS {
>  	IB_PESC_FEC_UNCORR_BLOCK_CTR_LANE11_F,
>  	IB_PESC_LAST_F,
>  
> +	/*
> + 	 * PortOpRcvCounters fields
> + 	 */
> +	IB_PC_PORT_OP_RCV_COUNTERS_FIRST_F,
> +	IB_PC_PORT_OP_RCV_PKTS = IB_PC_PORT_OP_RCV_COUNTERS_FIRST_F,
> +	IB_PC_PORT_OP_RCV_DATA,
> +	IB_PC_PORT_OP_RCV_COUNTERS_LAST_F,
> +
> +	/*
> + 	 * PortFlowCtlCounters fields
> + 	 */
> +	IB_PC_PORT_FLOW_CTL_COUNTERS_FIRST_F,
> +	IB_PC_PORT_XMIT_FLOW_PKTS = IB_PC_PORT_FLOW_CTL_COUNTERS_FIRST_F,
> +	IB_PC_PORT_RCV_FLOW_PKTS,
> +	IB_PC_PORT_FLOW_CTL_COUNTERS_LAST_F,
> +
> +	/*
> + 	 * PortVLOpPackets fields
> + 	 */
> +	IB_PC_PORT_VL_OP_PACKETS_FIRST_F,
> +	IB_PC_PORT_VL_OP_PACKETS0 = IB_PC_PORT_VL_OP_PACKETS_FIRST_F,
> +	IB_PC_PORT_VL_OP_PACKETS1,
> +	IB_PC_PORT_VL_OP_PACKETS2,
> +	IB_PC_PORT_VL_OP_PACKETS3,
> +	IB_PC_PORT_VL_OP_PACKETS4,
> +	IB_PC_PORT_VL_OP_PACKETS5,
> +	IB_PC_PORT_VL_OP_PACKETS6,
> +	IB_PC_PORT_VL_OP_PACKETS7,
> +	IB_PC_PORT_VL_OP_PACKETS8,
> +	IB_PC_PORT_VL_OP_PACKETS9,
> +	IB_PC_PORT_VL_OP_PACKETS10,
> +	IB_PC_PORT_VL_OP_PACKETS11,
> +	IB_PC_PORT_VL_OP_PACKETS12,
> +	IB_PC_PORT_VL_OP_PACKETS13,
> +	IB_PC_PORT_VL_OP_PACKETS14,
> +	IB_PC_PORT_VL_OP_PACKETS15,
> +	IB_PC_PORT_VL_OP_PACKETS_LAST_F,
> +
> +	/*
> + 	 * PortVLOpData fields
> + 	 */
> +	IB_PC_PORT_VL_OP_DATA_FIRST_F,
> +	IB_PC_PORT_VL_OP_DATA0 = IB_PC_PORT_VL_OP_DATA_FIRST_F,
> +	IB_PC_PORT_VL_OP_DATA1,
> +	IB_PC_PORT_VL_OP_DATA2,
> +	IB_PC_PORT_VL_OP_DATA3,
> +	IB_PC_PORT_VL_OP_DATA4,
> +	IB_PC_PORT_VL_OP_DATA5,
> +	IB_PC_PORT_VL_OP_DATA6,
> +	IB_PC_PORT_VL_OP_DATA7,
> +	IB_PC_PORT_VL_OP_DATA8,
> +	IB_PC_PORT_VL_OP_DATA9,
> +	IB_PC_PORT_VL_OP_DATA10,
> +	IB_PC_PORT_VL_OP_DATA11,
> +	IB_PC_PORT_VL_OP_DATA12,
> +	IB_PC_PORT_VL_OP_DATA13,
> +	IB_PC_PORT_VL_OP_DATA14,
> +	IB_PC_PORT_VL_OP_DATA15,
> +	IB_PC_PORT_VL_OP_DATA_LAST_F,
> +
> +	/*
> + 	 * PortVLXmitFlowCtlUpdateErrors fields
> + 	 */
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_FIRST_F,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS0 = IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_FIRST_F,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS1,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS2,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS3,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS4,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS5,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS6,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS7,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS8,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS9,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS10,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS11,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS12,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS13,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS14,
> +	IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS15,
> +        IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_LAST_F,
> +
> +	/*
> + 	 * PortVLXmitWaitCounters fields
> + 	 */
> +	IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_FIRST_F,
> +	IB_PC_PORT_VL_XMIT_WAIT0 = IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_FIRST_F,
> +	IB_PC_PORT_VL_XMIT_WAIT1,
> +	IB_PC_PORT_VL_XMIT_WAIT2,
> +	IB_PC_PORT_VL_XMIT_WAIT3,
> +	IB_PC_PORT_VL_XMIT_WAIT4,
> +	IB_PC_PORT_VL_XMIT_WAIT5,
> +	IB_PC_PORT_VL_XMIT_WAIT6,
> +	IB_PC_PORT_VL_XMIT_WAIT7,
> +	IB_PC_PORT_VL_XMIT_WAIT8,
> +	IB_PC_PORT_VL_XMIT_WAIT9,
> +	IB_PC_PORT_VL_XMIT_WAIT10,
> +	IB_PC_PORT_VL_XMIT_WAIT11,
> +	IB_PC_PORT_VL_XMIT_WAIT12,
> +	IB_PC_PORT_VL_XMIT_WAIT13,
> +	IB_PC_PORT_VL_XMIT_WAIT14,
> +	IB_PC_PORT_VL_XMIT_WAIT15,
> +	IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_LAST_F,
> +
> +	/*
> + 	 * SwPortVLCongestion fields
> + 	 */
> +

Nit... eliminate this blank line
> +	IB_PC_SW_PORT_VL_CONGESTION_FIRST_F,
> +	IB_PC_SW_PORT_VL_CONGESTION0 = IB_PC_SW_PORT_VL_CONGESTION_FIRST_F,
> +	IB_PC_SW_PORT_VL_CONGESTION1,
> +	IB_PC_SW_PORT_VL_CONGESTION2,
> +	IB_PC_SW_PORT_VL_CONGESTION3,
> +	IB_PC_SW_PORT_VL_CONGESTION4,
> +	IB_PC_SW_PORT_VL_CONGESTION5,
> +	IB_PC_SW_PORT_VL_CONGESTION6,
> +	IB_PC_SW_PORT_VL_CONGESTION7,
> +	IB_PC_SW_PORT_VL_CONGESTION8,
> +	IB_PC_SW_PORT_VL_CONGESTION9,
> +	IB_PC_SW_PORT_VL_CONGESTION10,
> +	IB_PC_SW_PORT_VL_CONGESTION11,
> +	IB_PC_SW_PORT_VL_CONGESTION12,
> +	IB_PC_SW_PORT_VL_CONGESTION13,
> +	IB_PC_SW_PORT_VL_CONGESTION14,
> +	IB_PC_SW_PORT_VL_CONGESTION15,
> +	IB_PC_SW_PORT_VL_CONGESTION_LAST_F,
> +
> +	/*
> +	 * PortRcvConCtrl fields
> +	 */
> +
Nit... eliminate this blank line
> +	IB_PC_RCV_CON_CTRL_FIRST_F,
> +	IB_PC_RCV_CON_CTRL_PKT_RCV_FECN = IB_PC_RCV_CON_CTRL_FIRST_F,
> +	IB_PC_RCV_CON_CTRL_PKT_RCV_BECN,
> +	IB_PC_RCV_CON_CTRL_LAST_F,
> +
> +	/*
> +	 * PortSLRcvFECN fields
> +	 */
> +	IB_PC_SL_RCV_FECN_FIRST_F,
> +	IB_PC_SL_RCV_FECN0 = IB_PC_SL_RCV_FECN_FIRST_F,
> +	IB_PC_SL_RCV_FECN1,
> +	IB_PC_SL_RCV_FECN2,
> +	IB_PC_SL_RCV_FECN3,
> +	IB_PC_SL_RCV_FECN4,
> +	IB_PC_SL_RCV_FECN5,
> +	IB_PC_SL_RCV_FECN6,
> +	IB_PC_SL_RCV_FECN7,
> +	IB_PC_SL_RCV_FECN8,
> +	IB_PC_SL_RCV_FECN9,
> +	IB_PC_SL_RCV_FECN10,
> +	IB_PC_SL_RCV_FECN11,
> +	IB_PC_SL_RCV_FECN12,
> +	IB_PC_SL_RCV_FECN13,
> +	IB_PC_SL_RCV_FECN14,
> +	IB_PC_SL_RCV_FECN15,
> +	IB_PC_SL_RCV_FECN_LAST_F,
> +
> +	/*
> +	 * PortSLRcvBECN fields
> +	 */
> +	IB_PC_SL_RCV_BECN_FIRST_F,
> +	IB_PC_SL_RCV_BECN0 = IB_PC_SL_RCV_BECN_FIRST_F,
> +	IB_PC_SL_RCV_BECN1,
> +	IB_PC_SL_RCV_BECN2,
> +	IB_PC_SL_RCV_BECN3,
> +	IB_PC_SL_RCV_BECN4,
> +	IB_PC_SL_RCV_BECN5,
> +	IB_PC_SL_RCV_BECN6,
> +	IB_PC_SL_RCV_BECN7,
> +	IB_PC_SL_RCV_BECN8,
> +	IB_PC_SL_RCV_BECN9,
> +	IB_PC_SL_RCV_BECN10,
> +	IB_PC_SL_RCV_BECN11,
> +	IB_PC_SL_RCV_BECN12,
> +	IB_PC_SL_RCV_BECN13,
> +	IB_PC_SL_RCV_BECN14,
> +	IB_PC_SL_RCV_BECN15,
> +	IB_PC_SL_RCV_BECN_LAST_F,
> +
> +	/*
> +	 * PortXmitConCtrl fields
> +	 */
> +	IB_PC_XMIT_CON_CTRL_FIRST_F,
> +	IB_PC_XMIT_CON_CTRL_TIME_CONG = IB_PC_XMIT_CON_CTRL_FIRST_F,
> +	IB_PC_XMIT_CON_CTRL_LAST_F,
> +
> +	/*
> +	 * PortVLXmitTimeCong fields
> +	 */
> +	IB_PC_VL_XMIT_TIME_CONG_FIRST_F,
> +	IB_PC_VL_XMIT_TIME_CONG0 = IB_PC_VL_XMIT_TIME_CONG_FIRST_F,
> +	IB_PC_VL_XMIT_TIME_CONG1,
> +	IB_PC_VL_XMIT_TIME_CONG2,
> +	IB_PC_VL_XMIT_TIME_CONG3,
> +	IB_PC_VL_XMIT_TIME_CONG4,
> +	IB_PC_VL_XMIT_TIME_CONG5,
> +	IB_PC_VL_XMIT_TIME_CONG6,
> +	IB_PC_VL_XMIT_TIME_CONG7,
> +	IB_PC_VL_XMIT_TIME_CONG8,
> +	IB_PC_VL_XMIT_TIME_CONG9,
> +	IB_PC_VL_XMIT_TIME_CONG10,
> +	IB_PC_VL_XMIT_TIME_CONG11,
> +	IB_PC_VL_XMIT_TIME_CONG12,
> +	IB_PC_VL_XMIT_TIME_CONG13,
> +	IB_PC_VL_XMIT_TIME_CONG14,
> +	IB_PC_VL_XMIT_TIME_CONG_LAST_F,
> +
>  	IB_FIELD_LAST_		/* must be last */
>  };
>  
> @@ -1137,7 +1357,13 @@ MAD_EXPORT ib_mad_dump_fn
>      mad_dump_switchinfo, mad_dump_perfcounters, mad_dump_perfcounters_ext,
>      mad_dump_perfcounters_xmt_sl, mad_dump_perfcounters_rcv_sl,
>      mad_dump_perfcounters_xmt_disc, mad_dump_perfcounters_rcv_err,
> -    mad_dump_portsamples_control, mad_dump_port_ext_speeds_counters;
> +    mad_dump_portsamples_control, mad_dump_port_ext_speeds_counters,
> +    mad_dump_perfcounters_port_op_rcv_counters, mad_dump_perfcounters_port_flow_ctl_counters,
> +    mad_dump_perfcounters_port_vl_op_packet, mad_dump_perfcounters_port_vl_op_data,
> +    mad_dump_perfcounters_port_vl_xmit_flow_ctl_update_errors, mad_dump_perfcounters_port_vl_xmit_wait_counters,
> +    mad_dump_perfcounters_sw_port_vl_congestion, mad_dump_perfcounters_rcv_con_ctrl,
> +    mad_dump_perfcounters_sl_rcv_fecn, mad_dump_perfcounters_sl_rcv_becn,
> +    mad_dump_perfcounters_xmit_con_ctrl, mad_dump_perfcounters_vl_xmit_time_cong;
>  
>  MAD_EXPORT void mad_dump_fields(char *buf, int bufsz, void *val, int valsz,
>  				int start, int end);
> diff --git a/src/dump.c b/src/dump.c
> index 4b4279d..52b2010 100644
> --- a/src/dump.c
> +++ b/src/dump.c
> @@ -836,6 +836,127 @@ void mad_dump_port_ext_speeds_counters(char *buf, int bufsz, void *val, int vals
>  	_dump_fields(buf, bufsz, val, IB_PESC_PORT_SELECT_F, IB_PESC_LAST_F);
>  }
>  
> +void mad_dump_perfcounters_port_op_rcv_counters(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
> +			   IB_PC_EXT_XMT_BYTES_F);
> +	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_OP_RCV_COUNTERS_FIRST_F,
> +		     IB_PC_PORT_OP_RCV_COUNTERS_LAST_F);
> +}
> +
> +void mad_dump_perfcounters_port_flow_ctl_counters(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
> +			   IB_PC_EXT_XMT_BYTES_F);
> +	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_FLOW_CTL_COUNTERS_FIRST_F,
> +		     IB_PC_PORT_FLOW_CTL_COUNTERS_LAST_F);
> +}
> +
> +void mad_dump_perfcounters_port_vl_op_packet(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
> +			   IB_PC_EXT_XMT_BYTES_F);
> +	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_VL_OP_PACKETS_FIRST_F,
> +		     IB_PC_PORT_VL_OP_PACKETS_LAST_F);
> +}
> +
> +void mad_dump_perfcounters_port_vl_op_data(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
> +			   IB_PC_EXT_XMT_BYTES_F);
> +	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_VL_OP_DATA_FIRST_F,
> +		     IB_PC_PORT_VL_OP_DATA_LAST_F);
> +}
> +
> +void mad_dump_perfcounters_port_vl_xmit_flow_ctl_update_errors(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
> +			   IB_PC_EXT_XMT_BYTES_F);
> +	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_FIRST_F,
> +		     IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_LAST_F);
> +}
> +
> +void mad_dump_perfcounters_port_vl_xmit_wait_counters(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
> +			   IB_PC_EXT_XMT_BYTES_F);
> +	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_FIRST_F,
> +		     IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_LAST_F);
> +}
> +
> +void mad_dump_perfcounters_sw_port_vl_congestion(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
> +			   IB_PC_EXT_XMT_BYTES_F);
> +	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_SW_PORT_VL_CONGESTION_FIRST_F,
> +		     IB_PC_SW_PORT_VL_CONGESTION_LAST_F);
> +}
> +
> +void mad_dump_perfcounters_rcv_con_ctrl(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
> +			   IB_PC_EXT_XMT_BYTES_F);
> +	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_RCV_CON_CTRL_FIRST_F,
> +		     IB_PC_RCV_CON_CTRL_LAST_F);
> +}
> +
> +
> +void mad_dump_perfcounters_sl_rcv_fecn(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
> +			   IB_PC_EXT_XMT_BYTES_F);
> +	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_SL_RCV_FECN_FIRST_F,
> +		     IB_PC_SL_RCV_FECN_LAST_F);
> +}
> +
> +void mad_dump_perfcounters_sl_rcv_becn(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
> +			   IB_PC_EXT_XMT_BYTES_F);
> +	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_SL_RCV_BECN_FIRST_F,
> +		     IB_PC_SL_RCV_BECN_LAST_F);
> +}
> +
> +void mad_dump_perfcounters_xmit_con_ctrl(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
> +			   IB_PC_EXT_XMT_BYTES_F);
> +	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_XMIT_CON_CTRL_FIRST_F,
> +		     IB_PC_XMIT_CON_CTRL_LAST_F);
> +}
> +
> +void mad_dump_perfcounters_vl_xmit_time_cong(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_PORT_SELECT_F,
> +			   IB_PC_EXT_XMT_BYTES_F);
> +	_dump_fields(buf + cnt, bufsz - cnt, val, IB_PC_VL_XMIT_TIME_CONG_FIRST_F,
> +		     IB_PC_VL_XMIT_TIME_CONG_LAST_F);
> +}
> +
>  void xdump(FILE * file, char *msg, void *p, int size)
>  {
>  #define HEX(x)  ((x) < 10 ? '0' + (x) : 'a' + ((x) -10))
> diff --git a/src/fields.c b/src/fields.c
> index 8039882..83d5374 100644
> --- a/src/fields.c
> +++ b/src/fields.c
> @@ -578,6 +578,200 @@ static const ib_field_t ib_mad_f[] = {
>  	{992, 32, "FECUncorrectableBlockCtrLane11", mad_dump_uint},
>  	{0, 0},			/* IB_PESC_LAST_F */
>  
> +	/*
> + 	 * PortOpRcvCounters fields
> + 	 */
> +	{32, 32, "PortOpRcvPkts", mad_dump_uint},
> +	{64, 32, "PortOpRcvData", mad_dump_uint},
> +	{0, 0},			/* IB_PC_PORT_OP_RCV_COUNTERS_LAST_F */
> +
> +	/*
> + 	 * PortFlowCtlCounters fields
> + 	 */
> +	{32, 32, "PortXmitFlowPkts", mad_dump_uint},
> +	{64, 32, "PortRcvFlowPkts", mad_dump_uint},
> +	{0, 0},			/* IB_PC_PORT_FLOW_CTL_COUNTERS_LAST_F */
> +
> +	/*
> + 	 * PortVLOpPackets fields
> + 	 */
> +	{32, 16, "PortVLOpPackets0", mad_dump_uint},
> +	{48, 16, "PortVLOpPackets1", mad_dump_uint},
> +	{64, 16, "PortVLOpPackets2", mad_dump_uint},
> +	{80, 16, "PortVLOpPackets3", mad_dump_uint},
> +	{96, 16, "PortVLOpPackets4", mad_dump_uint},
> +	{112, 16, "PortVLOpPackets5", mad_dump_uint},
> +	{128, 16, "PortVLOpPackets6", mad_dump_uint},
> +	{144, 16, "PortVLOpPackets7", mad_dump_uint},
> +	{160, 16, "PortVLOpPackets8", mad_dump_uint},
> +	{176, 16, "PortVLOpPackets9", mad_dump_uint},
> +	{192, 16, "PortVLOpPackets10", mad_dump_uint},
> +	{208, 16, "PortVLOpPackets11", mad_dump_uint},
> +	{224, 16, "PortVLOpPackets12", mad_dump_uint},
> +	{240, 16, "PortVLOpPackets13", mad_dump_uint},
> +	{256, 16, "PortVLOpPackets14", mad_dump_uint},
> +	{272, 16, "PortVLOpPackets15", mad_dump_uint},
> +	{0, 0},			/* IB_PC_PORT_VL_OP_PACKETS_LAST_F */
> +
> +	/*
> + 	 * PortVLOpData fields
> + 	 */
> +	{32, 32, "PortVLOpData0", mad_dump_uint},
> +	{64, 32, "PortVLOpData1", mad_dump_uint},
> +	{96, 32, "PortVLOpData2", mad_dump_uint},
> +	{128, 32, "PortVLOpData3", mad_dump_uint},
> +	{160, 32, "PortVLOpData4", mad_dump_uint},
> +	{192, 32, "PortVLOpData5", mad_dump_uint},
> +	{224, 32, "PortVLOpData6", mad_dump_uint},
> +	{256, 32, "PortVLOpData7", mad_dump_uint},
> +	{288, 32, "PortVLOpData8", mad_dump_uint},
> +	{320, 32, "PortVLOpData9", mad_dump_uint},
> +	{352, 32, "PortVLOpData10", mad_dump_uint},
> +	{384, 32, "PortVLOpData11", mad_dump_uint},
> +	{416, 32, "PortVLOpData12", mad_dump_uint},
> +	{448, 32, "PortVLOpData13", mad_dump_uint},
> +	{480, 32, "PortVLOpData14", mad_dump_uint},
> +	{512, 32, "PortVLOpData15", mad_dump_uint},
> +	{0, 0},			/* IB_PC_PORT_VL_OP_DATA_LAST_F */
> +
> +	/*
> + 	 * PortVLXmitFlowCtlUpdateErrors fields
> + 	 */
> +	{32, 2, "PortVLXmitFlowCtlUpdateErrors0", mad_dump_uint},
> +	{34, 2, "PortVLXmitFlowCtlUpdateErrors1", mad_dump_uint},
> +	{36, 2, "PortVLXmitFlowCtlUpdateErrors2", mad_dump_uint},
> +	{38, 2, "PortVLXmitFlowCtlUpdateErrors3", mad_dump_uint},
> +	{40, 2, "PortVLXmitFlowCtlUpdateErrors4", mad_dump_uint},
> +	{42, 2, "PortVLXmitFlowCtlUpdateErrors5", mad_dump_uint},
> +	{44, 2, "PortVLXmitFlowCtlUpdateErrors6", mad_dump_uint},
> +	{46, 2, "PortVLXmitFlowCtlUpdateErrors7", mad_dump_uint},
> +	{48, 2, "PortVLXmitFlowCtlUpdateErrors8", mad_dump_uint},
> +	{50, 2, "PortVLXmitFlowCtlUpdateErrors9", mad_dump_uint},
> +	{52, 2, "PortVLXmitFlowCtlUpdateErrors10", mad_dump_uint},
> +	{54, 2, "PortVLXmitFlowCtlUpdateErrors11", mad_dump_uint},
> +	{56, 2, "PortVLXmitFlowCtlUpdateErrors12", mad_dump_uint},
> +	{58, 2, "PortVLXmitFlowCtlUpdateErrors13", mad_dump_uint},
> +	{60, 2, "PortVLXmitFlowCtlUpdateErrors14", mad_dump_uint},
> +	{62, 2, "PortVLXmitFlowCtlUpdateErrors15", mad_dump_uint},

Don't these need to be BITSOFFS(nn, 2)  ?

-- Hal

> +	{0, 0},			/* IB_PC_PORT_VL_XMIT_FLOW_CTL_UPDATE_ERRORS_LAST_F */
> +
> +	/*
> + 	 * PortVLXmitWaitCounters fields
> + 	 */
> + 	{32, 16, "PortVLXmitWait0", mad_dump_uint},
> +	{48, 16, "PortVLXmitWait1", mad_dump_uint},
> +	{64, 16, "PortVLXmitWait2", mad_dump_uint},
> +	{80, 16, "PortVLXmitWait3", mad_dump_uint},
> +	{96, 16, "PortVLXmitWait4", mad_dump_uint},
> +	{112, 16, "PortVLXmitWait5", mad_dump_uint},
> +	{128, 16, "PortVLXmitWait6", mad_dump_uint},
> +	{144, 16, "PortVLXmitWait7", mad_dump_uint},
> +	{160, 16, "PortVLXmitWait8", mad_dump_uint},
> +	{176, 16, "PortVLXmitWait9", mad_dump_uint},
> +	{192, 16, "PortVLXmitWait10", mad_dump_uint},
> +	{208, 16, "PortVLXmitWait11", mad_dump_uint},
> +	{224, 16, "PortVLXmitWait12", mad_dump_uint},
> +	{240, 16, "PortVLXmitWait13", mad_dump_uint},
> +	{256, 16, "PortVLXmitWait14", mad_dump_uint},
> +	{272, 16, "PortVLXmitWait15", mad_dump_uint},
> +	{0, 0},			/* IB_PC_PORT_VL_XMIT_WAIT_COUNTERS_LAST_F */
> +
> +	/*
> + 	 * SwPortVLCongestion fields
> + 	 */
> +	{32, 16, "SWPortVLCongestion0", mad_dump_uint},
> +	{48, 16, "SWPortVLCongestion1", mad_dump_uint},
> +	{64, 16, "SWPortVLCongestion2", mad_dump_uint},
> +	{80, 16, "SWPortVLCongestion3", mad_dump_uint},
> +	{96, 16, "SWPortVLCongestion4", mad_dump_uint},
> +	{112, 16, "SWPortVLCongestion5", mad_dump_uint},
> +	{128, 16, "SWPortVLCongestion6", mad_dump_uint},
> +	{144, 16, "SWPortVLCongestion7", mad_dump_uint},
> +	{160, 16, "SWPortVLCongestion8", mad_dump_uint},
> +	{176, 16, "SWPortVLCongestion9", mad_dump_uint},
> +	{192, 16, "SWPortVLCongestion10", mad_dump_uint},
> +	{208, 16, "SWPortVLCongestion11", mad_dump_uint},
> +	{224, 16, "SWPortVLCongestion12", mad_dump_uint},
> +	{240, 16, "SWPortVLCongestion13", mad_dump_uint},
> +	{256, 16, "SWPortVLCongestion14", mad_dump_uint},
> +	{272, 16, "SWPortVLCongestion15", mad_dump_uint},
> +	{0, 0},			/* IB_PC_SW_PORT_VL_CONGESTION_LAST_F */
> +
> +	/*
> + 	 * PortRcvConCtrl fields
> + 	 */
> +	{32, 32, "PortPktRcvFECN", mad_dump_uint},
> +	{64, 32, "PortPktRcvBECN", mad_dump_uint},
> +	{0, 0},			/* IB_PC_RCV_CON_CTRL_LAST_F */
> +
> +	/*
> + 	 * PortSLRcvFECN fields
> + 	 */
> +	{32, 32, "PortSLRcvFECN0", mad_dump_uint},
> +	{64, 32, "PortSLRcvFECN1", mad_dump_uint},
> +	{96, 32, "PortSLRcvFECN2", mad_dump_uint},
> +	{128, 32, "PortSLRcvFECN3", mad_dump_uint},
> +	{160, 32, "PortSLRcvFECN4", mad_dump_uint},
> +	{192, 32, "PortSLRcvFECN5", mad_dump_uint},
> +	{224, 32, "PortSLRcvFECN6", mad_dump_uint},
> +	{256, 32, "PortSLRcvFECN7", mad_dump_uint},
> +	{288, 32, "PortSLRcvFECN8", mad_dump_uint},
> +	{320, 32, "PortSLRcvFECN9", mad_dump_uint},
> +	{352, 32, "PortSLRcvFECN10", mad_dump_uint},
> +	{384, 32, "PortSLRcvFECN11", mad_dump_uint},
> +	{416, 32, "PortSLRcvFECN12", mad_dump_uint},
> +	{448, 32, "PortSLRcvFECN13", mad_dump_uint},
> +	{480, 32, "PortSLRcvFECN14", mad_dump_uint},
> +	{512, 32, "PortSLRcvFECN15", mad_dump_uint},
> +	{0, 0},			/* IB_PC_SL_RCV_FECN_LAST_F */
> +
> +	/*
> + 	 * PortSLRcvBECN fields
> + 	 */
> +	{32, 32, "PortSLRcvBECN0", mad_dump_uint},
> +	{64, 32, "PortSLRcvBECN1", mad_dump_uint},
> +	{96, 32, "PortSLRcvBECN2", mad_dump_uint},
> +	{128, 32, "PortSLRcvBECN3", mad_dump_uint},
> +	{160, 32, "PortSLRcvBECN4", mad_dump_uint},
> +	{192, 32, "PortSLRcvBECN5", mad_dump_uint},
> +	{224, 32, "PortSLRcvBECN6", mad_dump_uint},
> +	{256, 32, "PortSLRcvBECN7", mad_dump_uint},
> +	{288, 32, "PortSLRcvBECN8", mad_dump_uint},
> +	{320, 32, "PortSLRcvBECN9", mad_dump_uint},
> +	{352, 32, "PortSLRcvBECN10", mad_dump_uint},
> +	{384, 32, "PortSLRcvBECN11", mad_dump_uint},
> +	{416, 32, "PortSLRcvBECN12", mad_dump_uint},
> +	{448, 32, "PortSLRcvBECN13", mad_dump_uint},
> +	{480, 32, "PortSLRcvBECN14", mad_dump_uint},
> +	{512, 32, "PortSLRcvBECN15", mad_dump_uint},
> +	{0, 0},			/* IB_PC_SL_RCV_BECN_LAST_F */
> +
> +	/*
> + 	 * PortXmitConCtrl fields
> + 	 */
> +	{32, 32, "PortXmitTimeCong", mad_dump_uint},
> +	{0, 0},			/* IB_PC_XMIT_CON_CTRL_LAST_F */
> +
> +	/*
> + 	 * PortVLXmitTimeCong fields
> + 	 */
> +	{32, 32, "PortVLXmitTimeCong0", mad_dump_uint},
> +	{64, 32, "PortVLXmitTimeCong1", mad_dump_uint},
> +	{96, 32, "PortVLXmitTimeCong2", mad_dump_uint},
> +	{128, 32, "PortVLXmitTimeCong3", mad_dump_uint},
> +	{160, 32, "PortVLXmitTimeCong4", mad_dump_uint},
> +	{192, 32, "PortVLXmitTimeCong5", mad_dump_uint},
> +	{224, 32, "PortVLXmitTimeCong6", mad_dump_uint},
> +	{256, 32, "PortVLXmitTimeCong7", mad_dump_uint},
> +	{288, 32, "PortVLXmitTimeCong8", mad_dump_uint},
> +	{320, 32, "PortVLXmitTimeCong9", mad_dump_uint},
> +	{352, 32, "PortVLXmitTimeCong10", mad_dump_uint},
> +	{384, 32, "PortVLXmitTimeCong11", mad_dump_uint},
> +	{416, 32, "PortVLXmitTimeCong12", mad_dump_uint},
> +	{448, 32, "PortVLXmitTimeCong13", mad_dump_uint},
> +	{480, 32, "PortVLXmitTimeCong14", mad_dump_uint},
> +	{0, 0},			/* IB_PC_VL_XMIT_TIME_CONG_LAST_F */
> +
>  	{0, 0}			/* IB_FIELD_LAST_ */
>  
>  };
> diff --git a/src/libibmad.map b/src/libibmad.map
> index 457ec86..f0b42a5 100644
> --- a/src/libibmad.map
> +++ b/src/libibmad.map
> @@ -34,6 +34,18 @@ IBMAD_1.3 {
>  		mad_dump_portcapmask;
>  		mad_dump_portinfo;
>  		mad_dump_portsamples_control;
> +		mad_dump_perfcounters_port_op_rcv_counters;
> +		mad_dump_perfcounters_port_flow_ctl_counters;
> +		mad_dump_perfcounters_port_vl_op_packet;
> +		mad_dump_perfcounters_port_vl_op_data;
> +		mad_dump_perfcounters_port_vl_xmit_flow_ctl_update_errors;
> +		mad_dump_perfcounters_port_vl_xmit_wait_counters;
> +		mad_dump_perfcounters_sw_port_vl_congestion;
> +		mad_dump_perfcounters_rcv_con_ctrl;
> +		mad_dump_perfcounters_sl_rcv_fecn;
> +		mad_dump_perfcounters_sl_rcv_becn;
> +		mad_dump_perfcounters_xmit_con_ctrl;
> +		mad_dump_perfcounters_vl_xmit_time_cong;
>  		mad_dump_portstates;
>  		mad_dump_portstate;
>  		mad_dump_rhex;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
