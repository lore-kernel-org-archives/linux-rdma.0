From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 1/3] libibmad: Add initial extended speed support
Date: Fri, 8 Jul 2011 13:45:37 -0700
Message-ID: <20110708134537.58fc6251.weiny2@llnl.gov>
References: <4E15E3BB.2000609@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E15E3BB.2000609-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 7 Jul 2011 09:50:03 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> Add support for new LinkSpeedExt* components in SM PortInfo attribute
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, _this_ one is applied...

Ira

> ---
>  include/infiniband/mad.h |    9 +++++
>  src/dump.c               |   75 ++++++++++++++++++++++++++++++++++++++++++++-
>  src/fields.c             |    8 +++++
>  src/libibmad.map         |    3 ++
>  4 files changed, 93 insertions(+), 2 deletions(-)
> 
> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> index e0b5fae..7500e1a 100644
> --- a/include/infiniband/mad.h
> +++ b/include/infiniband/mad.h
> @@ -751,6 +751,14 @@ enum MAD_FIELDS {
>  	IB_SA_GIR_GUID6,
>  	IB_SA_GIR_GUID7,
>  
> +	/*
> +	 * More PortInfo fields
> +	 */
> +	IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
> +	IB_PORT_LINK_SPEED_EXT_SUPPORTED_F,
> +	IB_PORT_LINK_SPEED_EXT_ENABLED_F,
> +	IB_PORT_LINK_SPEED_EXT_LAST_F,
> +
>  	IB_FIELD_LAST_		/* must be last */
>  };
>  
> @@ -1074,6 +1082,7 @@ MAD_EXPORT ib_mad_dump_fn
>      mad_dump_linkwidth, mad_dump_linkwidthsup, mad_dump_linkwidthen,
>      mad_dump_linkdowndefstate,
>      mad_dump_linkspeed, mad_dump_linkspeedsup, mad_dump_linkspeeden,
> +    mad_dump_linkspeedext, mad_dump_linkspeedextsup, mad_dump_linkspeedexten,
>      mad_dump_portstate, mad_dump_portstates,
>      mad_dump_physportstate, mad_dump_portcapmask,
>      mad_dump_mtu, mad_dump_vlcap, mad_dump_opervls,
> diff --git a/src/dump.c b/src/dump.c
> index c29f625..39e1bbf 100644
> --- a/src/dump.c
> +++ b/src/dump.c
> @@ -1,7 +1,7 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
>   * Copyright (c) 2007 Xsigo Systems Inc.  All rights reserved.
> - * Copyright (c) 2009 Mellanox Technologies LTD.  All rights reserved.
> + * Copyright (c) 2009-2011 Mellanox Technologies LTD.  All rights reserved.
>   * Copyright (c) 2009 HNR Consulting.  All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
> @@ -308,6 +308,70 @@ void mad_dump_linkspeeden(char *buf, int bufsz, void *val, int valsz)
>  	dump_linkspeed(buf, bufsz, speed);
>  }
>  
> +void mad_dump_linkspeedext(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int speed = *(int *)val;
> +
> +	switch (speed) {
> +	case 0:
> +		snprintf(buf, bufsz, "No Extended Speed");
> +		break;
> +	case 1:
> +		snprintf(buf, bufsz, "14.0625 Gbps");
> +		break;
> +	case 2:
> +		snprintf(buf, bufsz, "25.78125 Gbps");
> +		break;
> +	default:
> +		snprintf(buf, bufsz, "undefined (%d)", speed);
> +		break;
> +	}
> +}
> +
> +static void dump_linkspeedext(char *buf, int bufsz, int speed)
> +{
> +	int n = 0;
> +
> +	if (speed == 0) {
> +		sprintf(buf, "%d", speed);
> +		return;
> +	}
> +
> +	if (speed & 0x1)
> +		n += snprintf(buf + n, bufsz - n, "14.0625 Gbps or ");
> +	if (n < bufsz && speed & 0x2)
> +		n += snprintf(buf + n, bufsz - n, "25.78125 Gbps or ");
> +	if (n >= bufsz) {
> +		if (bufsz > 3)
> +			buf[n - 4] = '\0';
> +		return;
> +	}
> +
> +	if (speed >> 2) {
> +		n += snprintf(buf + n, bufsz - n, "undefined (%d)", speed);
> +		return;
> +	} else if (bufsz > 3)
> +		buf[n - 4] = '\0';
> +}
> +
> +void mad_dump_linkspeedextsup(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int speed = *(int *)val;
> +
> +	dump_linkspeedext(buf, bufsz, speed);
> +}
> +
> +void mad_dump_linkspeedexten(char *buf, int bufsz, void *val, int valsz)
> +{
> +	int speed = *(int *)val;
> +
> +	if (speed == 30) {
> +		sprintf(buf, "%s", "Extended link speeds disabled");
> +		return;
> +	}
> +	dump_linkspeedext(buf, bufsz, speed);
> +}
> +
>  void mad_dump_portstate(char *buf, int bufsz, void *val, int valsz)
>  {
>  	int state = *(int *)val;
> @@ -495,6 +559,8 @@ void mad_dump_portcapmask(char *buf, int bufsz, void *val, int valsz)
>  	if (mask & (1 << 12))
>  		s += sprintf(s,
>  			     "\t\t\t\tIsPkeySwitchExternalPortTrapSupported\n");
> +	if (mask & (1 << 14))
> +		s += sprintf(s, "\t\t\t\tIsExtendedSpeedsSupported\n");
>  	if (mask & (1 << 16))
>  		s += sprintf(s, "\t\t\t\tIsCommunicatonManagementSupported\n");
>  	if (mask & (1 << 17))
> @@ -692,7 +758,12 @@ void mad_dump_nodeinfo(char *buf, int bufsz, void *val, int valsz)
>  
>  void mad_dump_portinfo(char *buf, int bufsz, void *val, int valsz)
>  {
> -	_dump_fields(buf, bufsz, val, IB_PORT_FIRST_F, IB_PORT_LAST_F);
> +	int cnt;
> +
> +	cnt = _dump_fields(buf, bufsz, val, IB_PORT_FIRST_F, IB_PORT_LAST_F);
> +	_dump_fields(buf + cnt, bufsz - cnt, val,
> +		     IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
> +		     IB_PORT_LINK_SPEED_EXT_LAST_F);
>  }
>  
>  void mad_dump_portstates(char *buf, int bufsz, void *val, int valsz)
> diff --git a/src/fields.c b/src/fields.c
> index faf3d8d..92c1b6b 100644
> --- a/src/fields.c
> +++ b/src/fields.c
> @@ -525,6 +525,14 @@ static const ib_field_t ib_mad_f[] = {
>  	{448, 64, "Guid6", mad_dump_hex},
>  	{512, 64, "Guid7", mad_dump_hex},
>  
> +	/*
> +	 * More PortInfo fields
> +	 */
> +	{BITSOFFS(496, 4), "LinkSpeedExtActive", mad_dump_linkspeedext},
> +	{BITSOFFS(500, 4), "LinkSpeedExtSupported", mad_dump_linkspeedextsup},
> +	{BITSOFFS(507, 5), "LinkSpeedExtEnabled", mad_dump_linkspeedexten},
> +	{0, 0},			/* IB_PORT_LINK_SPEED_EXT_LAST_F */
> +
>  	{0, 0}			/* IB_FIELD_LAST_ */
>  
>  };
> diff --git a/src/libibmad.map b/src/libibmad.map
> index 1e6a028..b9d1205 100644
> --- a/src/libibmad.map
> +++ b/src/libibmad.map
> @@ -12,6 +12,9 @@ IBMAD_1.3 {
>  		mad_dump_linkspeed;
>  		mad_dump_linkspeeden;
>  		mad_dump_linkspeedsup;
> +		mad_dump_linkspeedext;
> +		mad_dump_linkspeedexten;
> +		mad_dump_linkspeedextsup;
>  		mad_dump_linkwidth;
>  		mad_dump_linkwidthen;
>  		mad_dump_linkwidthsup;
> -- 
> 1.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


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
