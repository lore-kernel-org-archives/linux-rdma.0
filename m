From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibmad: Add support for PortSamplesResult
Date: Fri, 15 Feb 2013 14:34:13 -0800
Message-ID: <20130215143413.26f7e6fd887e924ca2c47141@llnl.gov>
References: <50F9D531.8010500@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50F9D531.8010500-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 18 Jan 2013 18:05:21 -0500
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied,
Ira

> ---
> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> index 0694dc4..e6de2c5 100644
> --- a/include/infiniband/mad.h
> +++ b/include/infiniband/mad.h
> @@ -1230,6 +1230,28 @@ enum MAD_FIELDS {
>  	IB_SA_NR_NODEDESC_F,
>  	IB_SA_NR_LAST_F,
>  
> +	/*
> +	 * PortSamplesResult fields
> +	 */
> +	IB_PSR_TAG_F,
> +	IB_PSR_SAMPLE_STATUS_F,
> +	IB_PSR_COUNTER0_F,
> +	IB_PSR_COUNTER1_F,
> +	IB_PSR_COUNTER2_F,
> +	IB_PSR_COUNTER3_F,
> +	IB_PSR_COUNTER4_F,
> +	IB_PSR_COUNTER5_F,
> +	IB_PSR_COUNTER6_F,
> +	IB_PSR_COUNTER7_F,
> +	IB_PSR_COUNTER8_F,
> +	IB_PSR_COUNTER9_F,
> +	IB_PSR_COUNTER10_F,
> +	IB_PSR_COUNTER11_F,
> +	IB_PSR_COUNTER12_F,
> +	IB_PSR_COUNTER13_F,
> +	IB_PSR_COUNTER14_F,
> +	IB_PSR_LAST_F,
> +
>  	IB_FIELD_LAST_		/* must be last */
>  };
>  
> @@ -1589,7 +1611,7 @@ MAD_EXPORT ib_mad_dump_fn
>      mad_dump_cc_switchportcongestionsettingelement, mad_dump_cc_cacongestionsetting,
>      mad_dump_cc_cacongestionentry, mad_dump_cc_congestioncontroltable,
>      mad_dump_cc_congestioncontroltableentry, mad_dump_cc_timestamp,
> -    mad_dump_classportinfo;
> +    mad_dump_classportinfo, mad_dump_portsamples_result;
>  
>  MAD_EXPORT void mad_dump_fields(char *buf, int bufsz, void *val, int valsz,
>  				int start, int end);
> diff --git a/src/dump.c b/src/dump.c
> index 9cf31da..7f3ef7d 100644
> --- a/src/dump.c
> +++ b/src/dump.c
> @@ -851,6 +851,11 @@ void mad_dump_portsamples_control(char *buf, int bufsz, void *val, int valsz)
>  	_dump_fields(buf, bufsz, val, IB_PSC_OPCODE_F, IB_PSC_LAST_F);
>  }
>  
> +void mad_dump_portsamples_result(char *buf, int bufsz, void *val, int valsz)
> +{
> +	_dump_fields(buf, bufsz, val, IB_PSR_TAG_F, IB_PSR_LAST_F);
> +}
> +
>  void mad_dump_port_ext_speeds_counters(char *buf, int bufsz, void *val, int valsz)
>  {
>  	_dump_fields(buf, bufsz, val, IB_PESC_PORT_SELECT_F, IB_PESC_LAST_F);
> diff --git a/src/fields.c b/src/fields.c
> index 06bc9f0..d2b6792 100644
> --- a/src/fields.c
> +++ b/src/fields.c
> @@ -927,6 +927,28 @@ static const ib_field_t ib_mad_f[] = {
>  	{352, 64 * 8, "NodeDesc", mad_dump_string},
>  	{0, 0}, /* IB_SA_NR_LAST_F */
>  
> +	/*
> +	 * PortSamplesResult fields
> +	 */
> +	{BITSOFFS(0, 16), "Tag", mad_dump_hex},
> +	{BITSOFFS(30, 2), "SampleStatus", mad_dump_hex},
> +	{32, 32, "Counter0", mad_dump_uint},
> +	{64, 32, "Counter1", mad_dump_uint},
> +	{96, 32, "Counter2", mad_dump_uint},
> +	{128, 32, "Counter3", mad_dump_uint},
> +	{160, 32, "Counter4", mad_dump_uint},
> +	{192, 32, "Counter5", mad_dump_uint},
> +	{224, 32, "Counter6", mad_dump_uint},
> +	{256, 32, "Counter7", mad_dump_uint},
> +	{288, 32, "Counter8", mad_dump_uint},
> +	{320, 32, "Counter9", mad_dump_uint},
> +	{352, 32, "Counter10", mad_dump_uint},
> +	{384, 32, "Counter11", mad_dump_uint},
> +	{416, 32, "Counter12", mad_dump_uint},
> +	{448, 32, "Counter13", mad_dump_uint},
> +	{480, 32, "Counter14", mad_dump_uint},
> +	{0, 0},			/* IB_PSR_LAST_F */
> +
>  	{0, 0}			/* IB_FIELD_LAST_ */
>  
>  };
> diff --git a/src/libibmad.map b/src/libibmad.map
> index a4d4418..a1988be 100644
> --- a/src/libibmad.map
> +++ b/src/libibmad.map
> @@ -35,6 +35,7 @@ IBMAD_1.3 {
>  		mad_dump_portcapmask;
>  		mad_dump_portinfo;
>  		mad_dump_portsamples_control;
> +		mad_dump_portsamples_result;
>  		mad_dump_perfcounters_port_op_rcv_counters;
>  		mad_dump_perfcounters_port_flow_ctl_counters;
>  		mad_dump_perfcounters_port_vl_op_packet;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
