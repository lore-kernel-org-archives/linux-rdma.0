From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH libibmad 1/2] mad.h, [fields dump].c: Add support for additional PortCountersExtended fields
Date: Sat, 29 Apr 2017 20:05:41 -0400
Message-ID: <20170430000541.GB27829@phlsvsds.ph.intel.com>
References: <fb92b904-6afd-0a3e-f5aa-b1aadb2ef918@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fb92b904-6afd-0a3e-f5aa-b1aadb2ef918-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 27, 2017 at 11:34:52AM -0400, Hal Rosenstock wrote:
> 
> introduced by MgtWG errata #9301-9303
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> index 946e034..50c5bc5 100644
> --- a/include/infiniband/mad.h
> +++ b/include/infiniband/mad.h
> @@ -1290,6 +1290,26 @@ enum MAD_FIELDS {
>  	IB_PESC_PORT_FEC_CORR_SYMBOL_CTR_F,
>  	IB_PESC_RSFEC_LAST_F,
>  
> +	/*
> +	 * More PortCountersExtended fields
> +	 */
> +	IB_PC_EXT_COUNTER_SELECT2_F,
> +	IB_PC_EXT_ERR_SYM_F,
> +	IB_PC_EXT_LINK_RECOVERS_F,
> +	IB_PC_EXT_LINK_DOWNED_F,
> +	IB_PC_EXT_ERR_RCV_F,
> +	IB_PC_EXT_ERR_PHYSRCV_F,
> +	IB_PC_EXT_ERR_SWITCH_REL_F,
> +	IB_PC_EXT_XMT_DISCARDS_F,
> +	IB_PC_EXT_ERR_XMTCONSTR_F,
> +	IB_PC_EXT_ERR_RCVCONSTR_F,
> +	IB_PC_EXT_ERR_LOCALINTEG_F,
> +	IB_PC_EXT_ERR_EXCESS_OVR_F,
> +	IB_PC_EXT_VL15_DROPPED_F,
> +	IB_PC_EXT_XMT_WAIT_F,
> +	IB_PC_EXT_QP1_DROP_F,
> +	IB_PC_EXT_ERR_LAST_F,
> +
>  	IB_FIELD_LAST_		/* must be last */
>  };
>  
> diff --git a/src/dump.c b/src/dump.c
> index b7ad381..b491bc2 100644
> --- a/src/dump.c
> +++ b/src/dump.c
> @@ -792,7 +792,14 @@ void mad_dump_perfcounters(char *buf, int bufsz, void *val, int valsz)
>  
>  void mad_dump_perfcounters_ext(char *buf, int bufsz, void *val, int valsz)
>  {
> -	_dump_fields(buf, bufsz, val, IB_PC_EXT_FIRST_F, IB_PC_EXT_LAST_F);
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PC_EXT_FIRST_F, IB_PC_EXT_LAST_F);
> +	if (cnt < 0)
> +		return;
> +
> +	 _dump_fields(buf + cnt, bufsz - cnt, val,
> +		      IB_PC_EXT_COUNTER_SELECT2_F, IB_PC_EXT_ERR_LAST_F);
>  }
>  
>  void mad_dump_perfcounters_xmt_sl(char *buf, int bufsz, void *val, int valsz)
> diff --git a/src/fields.c b/src/fields.c
> index fbade55..8273f97 100644
> --- a/src/fields.c
> +++ b/src/fields.c
> @@ -984,6 +984,26 @@ static const ib_field_t ib_mad_f[] = {
>  	{1184, 32, "PortFECCorrectedSymbolCtr", mad_dump_uint},
>  	{0, 0},			/* IB_PESC_RSFEC_LAST_F */
>  
> +	/*
> +	 * More PortCountersExtended fields
> +	 */
> +	{32, 32, "CounterSelect2", mad_dump_hex},
> +	{576, 64, "SymbolErrorCounter", mad_dump_uint},
> +	{640, 64, "LinkErrorRecoveryCounter",  mad_dump_uint},
> +	{704, 64, "LinkDownedCounter", mad_dump_uint},
> +	{768, 64, "PortRcvErrors", mad_dump_uint},
> +	{832, 64, "PortRcvRemotePhysicalErrors", mad_dump_uint},
> +	{896, 64, "PortRcvSwitchRelayErrors", mad_dump_uint},
> +	{960, 64, "PortXmitDiscards", mad_dump_uint},
> +	{1024, 64, "PortXmitConstraintErrors", mad_dump_uint},
> +	{1088, 64, "PortRcvConstraintErrors", mad_dump_uint},
> +	{1152, 64, "LocalLinkIntegrityErrors", mad_dump_uint},
> +	{1216, 64, "ExcessiveBufferOverrunErrors", mad_dump_uint},
> +	{1280, 64, "VL15Dropped", mad_dump_uint},
> +	{1344, 64, "PortXmitWait", mad_dump_uint},
> +	{1408, 64, "QP1Dropped", mad_dump_uint},
> +	{0, 0},			/* IB_PC_EXT_ERR_LAST_F */
> +
>  	{0, 0}			/* IB_FIELD_LAST_ */
>  };
>  
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
