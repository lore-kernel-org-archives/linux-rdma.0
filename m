From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibmad: Support for Mellanox vendor specific
 ExtendedPortInfo SM class MAD
Date: Wed, 3 Aug 2011 12:51:00 -0700
Message-ID: <20110803125100.7a50a327.weiny2@llnl.gov>
References: <4E1F3419.3010508@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E1F3419.3010508-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 14 Jul 2011 11:23:21 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> for FDR10 operation
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> index f00bf7a..8175704 100644
> --- a/include/infiniband/mad.h
> +++ b/include/infiniband/mad.h
> @@ -141,7 +141,9 @@ enum SMI_ATTR_ID {
>  	IB_ATTR_VENDORMADSTBL = 0x1d,
>  	IB_ATTR_SMINFO = 0x20,
>  
> -	IB_ATTR_LAST
> +	IB_ATTR_LAST,
> +
> +	IB_ATTR_MLNX_EXT_PORT_INFO = 0xff90,
>  };
>  
>  enum SA_ATTR_ID {
> @@ -805,6 +807,15 @@ enum MAD_FIELDS {
>  	IB_PESC_FEC_UNCORR_BLOCK_CTR_LANE11_F,
>  	IB_PESC_LAST_F,
>  
> +	/*
> +	 * Mellanox ExtendedPortInfo
> +	 */
> +	IB_MLNX_EXT_PORT_STATE_CHG_ENABLE_F,
> +	IB_MLNX_EXT_PORT_LINK_SPEED_SUPPORTED_F,
> +	IB_MLNX_EXT_PORT_LINK_SPEED_ENABLED_F,
> +	IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F,
> +	IB_MLNX_EXT_PORT_LAST_F,
> +
>  	IB_FIELD_LAST_		/* must be last */
>  };
>  
> @@ -1137,7 +1148,8 @@ MAD_EXPORT ib_mad_dump_fn
>      mad_dump_switchinfo, mad_dump_perfcounters, mad_dump_perfcounters_ext,
>      mad_dump_perfcounters_xmt_sl, mad_dump_perfcounters_rcv_sl,
>      mad_dump_perfcounters_xmt_disc, mad_dump_perfcounters_rcv_err,
> -    mad_dump_portsamples_control, mad_dump_port_ext_speeds_counters;
> +    mad_dump_portsamples_control, mad_dump_port_ext_speeds_counters,
> +    mad_dump_mlnx_ext_port_info;
>  
>  MAD_EXPORT void mad_dump_fields(char *buf, int bufsz, void *val, int valsz,
>  				int start, int end);
> diff --git a/src/dump.c b/src/dump.c
> index 4b4279d..76987ff 100644
> --- a/src/dump.c
> +++ b/src/dump.c
> @@ -836,6 +836,12 @@ void mad_dump_port_ext_speeds_counters(char *buf, int bufsz, void *val, int vals
>  	_dump_fields(buf, bufsz, val, IB_PESC_PORT_SELECT_F, IB_PESC_LAST_F);
>  }
>  
> +void mad_dump_mlnx_ext_port_info(char *buf, int bufsz, void *val, int valsz)
> +{
> +	_dump_fields(buf, bufsz, val, IB_MLNX_EXT_PORT_STATE_CHG_ENABLE_F,
> +		     IB_MLNX_EXT_PORT_LAST_F);
> +}
> +
>  void xdump(FILE * file, char *msg, void *p, int size)
>  {
>  #define HEX(x)  ((x) < 10 ? '0' + (x) : 'a' + ((x) -10))
> diff --git a/src/fields.c b/src/fields.c
> index 8039882..665797b 100644
> --- a/src/fields.c
> +++ b/src/fields.c
> @@ -578,6 +578,12 @@ static const ib_field_t ib_mad_f[] = {
>  	{992, 32, "FECUncorrectableBlockCtrLane11", mad_dump_uint},
>  	{0, 0},			/* IB_PESC_LAST_F */
>  
> +	{BITSOFFS(24, 8), "StateChangeEnable", mad_dump_hex},
> +	{BITSOFFS(56, 8), "LinkSpeedSupported", mad_dump_hex},
> +	{BITSOFFS(88, 8), "LinkSpeedEnabled", mad_dump_hex},
> +	{BITSOFFS(120, 8), "LinkSpeedActive", mad_dump_hex},
> +	{0, 0},			/* IB_MLNX_EXT_PORT_LAST_F */
> +
>  	{0, 0}			/* IB_FIELD_LAST_ */
>  
>  };
> diff --git a/src/libibmad.map b/src/libibmad.map
> index 457ec86..ebeaf48 100644
> --- a/src/libibmad.map
> +++ b/src/libibmad.map
> @@ -116,5 +116,6 @@ IBMAD_1.3 {
>  		mad_field_name;
>  		bm_call_via;
>  		mad_dump_port_ext_speeds_counters;
> +		mad_dump_mlnx_ext_port_info;
>  	local: *;
>  };


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
