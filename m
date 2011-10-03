From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-3.2 v1 1/5] ib/core: Add extended link speeds
Date: Mon, 3 Oct 2011 18:53:12 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E690F8@ORSMSX101.amr.corp.intel.com>
References: <201110031754.59246.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201110031754.59246.marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -77,6 +77,35 @@ enum ib_rate mult_to_ib_rate(int mult)
>  }
>  EXPORT_SYMBOL(mult_to_ib_rate);
> 
> +int ib_rate_to_int(enum ib_rate rate, int *rounded)
> +{

I like this approach better, but I wonder if it still couldn't be slightly cleaner.  Rather than returning 'rounded' and having the caller assume that 1 means add .5 to the result, we could return the fractional part directly.  I.e. rename 'rounded' to 'fraction' and return 5.

Or if ib_rate_to_int() is only used to convert the rate into a string, we could just return the string directly. 

> +	*rounded = 0;
> +
> +	switch (rate) {
> +	case IB_RATE_2_5_GBPS:
> +		*rounded = 1;
> +		return 2;
> +	case IB_RATE_5_GBPS:   return 5;
> +	case IB_RATE_10_GBPS:  return 10;
> +	case IB_RATE_20_GBPS:  return 20;
> +	case IB_RATE_30_GBPS:  return 30;
> +	case IB_RATE_40_GBPS:  return 40;
> +	case IB_RATE_60_GBPS:  return 60;
> +	case IB_RATE_80_GBPS:  return 80;
> +	case IB_RATE_120_GBPS: return 120;
> +	case IB_RATE_14_GBPS:  return 14;
> +	case IB_RATE_56_GBPS:  return 56;
> +	case IB_RATE_112_GBPS: return 112;
> +	case IB_RATE_168_GBPS: return 168;
> +	case IB_RATE_25_GBPS:  return 25;
> +	case IB_RATE_100_GBPS: return 100;
> +	case IB_RATE_200_GBPS: return 200;
> +	case IB_RATE_300_GBPS: return 300;
> +	default:	       return -1;
> +	}
> +}
> +EXPORT_SYMBOL(ib_rate_to_int);
> +
>  enum rdma_transport_type
>  rdma_node_get_transport(enum rdma_node_type node_type)
>  {
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -207,6 +207,7 @@ enum ib_port_cap_flags {
>  	IB_PORT_SM_DISABLED			= 1 << 10,
>  	IB_PORT_SYS_IMAGE_GUID_SUP		= 1 << 11,
>  	IB_PORT_PKEY_SW_EXT_PORT_TRAP_SUP	= 1 << 12,
> +	IB_PORT_EXTENDED_SPEEDS_SUP             = 1 << 14,
>  	IB_PORT_CM_SUP				= 1 << 16,
>  	IB_PORT_SNMP_TUNNEL_SUP			= 1 << 17,
>  	IB_PORT_REINIT_SUP			= 1 << 18,
> @@ -226,6 +227,42 @@ enum ib_port_width {
>  	IB_WIDTH_12X	= 8
>  };
> 
> +static inline int ib_active_speed_to_rate(u8 active_speed, int *rounded)

I don't see where this is used.

The other patches in this series look good to me.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
