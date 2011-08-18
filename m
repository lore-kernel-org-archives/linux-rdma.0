From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibmad: Add support for PortInfo CapabilityMask2
Date: Thu, 18 Aug 2011 10:50:52 -0700
Message-ID: <20110818105052.d191c73e.weiny2@llnl.gov>
References: <4E4983F2.8010902@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E4983F2.8010902-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 15 Aug 2011 13:39:14 -0700
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira

> ---
> diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
> index 6d65a29..25c1141 100644
> --- a/include/infiniband/mad.h
> +++ b/include/infiniband/mad.h
> @@ -772,6 +772,7 @@ enum MAD_FIELDS {
>  	/*
>  	 * More PortInfo fields
>  	 */
> +	IB_PORT_CAPMASK2_F,
>  	IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
>  	IB_PORT_LINK_SPEED_EXT_SUPPORTED_F,
>  	IB_PORT_LINK_SPEED_EXT_ENABLED_F,
> diff --git a/src/dump.c b/src/dump.c
> index 29fb742..581f044 100644
> --- a/src/dump.c
> +++ b/src/dump.c
> @@ -561,6 +563,8 @@ void mad_dump_portcapmask(char *buf, int bufsz, void *val, int valsz)
>  			     "\t\t\t\tIsPkeySwitchExternalPortTrapSupported\n");
>  	if (mask & (1 << 14))
>  		s += sprintf(s, "\t\t\t\tIsExtendedSpeedsSupported\n");
> +	if (mask & (1 << 15))
> +		s += sprintf(s, "\t\t\t\tIsCapabilityMask2Supported\n");
>  	if (mask & (1 << 16))
>  		s += sprintf(s, "\t\t\t\tIsCommunicatonManagementSupported\n");
>  	if (mask & (1 << 17))
> @@ -762,8 +766,7 @@ void mad_dump_portinfo(char *buf, int bufsz, void *val, int valsz)
>  
>  	cnt = _dump_fields(buf, bufsz, val, IB_PORT_FIRST_F, IB_PORT_LAST_F);
>  	_dump_fields(buf + cnt, bufsz - cnt, val,
> -		     IB_PORT_LINK_SPEED_EXT_ACTIVE_F,
> -		     IB_PORT_LINK_SPEED_EXT_LAST_F);
> +		     IB_PORT_CAPMASK2_F, IB_PORT_LINK_SPEED_EXT_LAST_F);
>  }
>  
>  void mad_dump_portstates(char *buf, int bufsz, void *val, int valsz)
> diff --git a/src/fields.c b/src/fields.c
> index 7e5ac7d..45c07dd 100644
> --- a/src/fields.c
> +++ b/src/fields.c
> @@ -1,7 +1,7 @@
>  /*
>   * Copyright (c) 2004-2009 Voltaire Inc.  All rights reserved.
>   * Copyright (c) 2009 HNR Consulting.  All rights reserved.
> - * Copyright (c) 2009-2010 Mellanox Technologies LTD.  All rights reserved.
> + * Copyright (c) 2009-2011 Mellanox Technologies LTD.  All rights reserved.
>   *
>   * This software is available to you under a choice of one of two
>   * licenses.  You may choose to be licensed under the terms of the GNU
> @@ -529,6 +529,7 @@ static const ib_field_t ib_mad_f[] = {
>  	/*
>  	 * More PortInfo fields
>  	 */
> +	{BITSOFFS(480, 16), "CapabilityMask2", mad_dump_hex},
>  	{BITSOFFS(496, 4), "LinkSpeedExtActive", mad_dump_linkspeedext},
>  	{BITSOFFS(500, 4), "LinkSpeedExtSupported", mad_dump_linkspeedextsup},
>  	{BITSOFFS(507, 5), "LinkSpeedExtEnabled", mad_dump_linkspeedexten},


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
