From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-3.2 v2 1/5] ib/core: Add extended link speeds
Date: Wed, 5 Oct 2011 18:40:38 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E697CA@ORSMSX101.amr.corp.intel.com>
References: <201110031754.59246.marcela@dev.mellanox.co.il>
 <201110051321.48023.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201110051321.48023.marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <marcela-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The following extended speeds are introduced:
> FDR-10  - is a proprietary link speed which is 10.3125 Gbps at 64/66
> 	  encoding rather than 8b10b encoding.
> FDR     - represents the IBA extended speed: 14.0625 Gbps.
> EDR     - represents the IBA extended speed: 25.78125 Gbps.
> 
> Signed-off-by: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---

FWIW - this series looks okay with me.

> Changes from v1
> - Removed ib_active_speed_to_rate function
> - Moved ib_active_speed_to_rate code into rate_show method
> 
>  drivers/infiniband/core/sysfs.c |   26 ++++++++++++++++++++++----
>  drivers/infiniband/core/verbs.c |   25 +++++++++++++++++++++++++
>  include/rdma/ib_verbs.h         |   18 +++++++++++++++++-
>  3 files changed, 64 insertions(+), 5 deletions(-)
> 
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -185,17 +185,35 @@ static ssize_t rate_show(struct ib_port
>  	if (ret)
>  		return ret;
> 
> +	rate = (25 * attr.active_speed) / 10;
> +
>  	switch (attr.active_speed) {
> -	case 2: speed = " DDR"; break;
> -	case 4: speed = " QDR"; break;
> +	case 2:
> +		speed = " DDR";
> +		break;
> +	case 4:
> +		speed = " QDR";
> +		break;
> +	case 8:
> +		speed = " FDR10";
> +		rate = 10;
> +		break;
> +	case 16:
> +		speed = " FDR";
> +		rate = 14;
> +		break;
> +	case 32:
> +		speed = " EDR";
> +		rate = 25;
> +		break;
>  	}
> 
> -	rate = 25 * ib_width_enum_to_int(attr.active_width) * attr.active_speed;
> +	rate *= ib_width_enum_to_int(attr.active_width);
>  	if (rate < 0)
>  		return -EINVAL;
> 
>  	return sprintf(buf, "%d%s Gb/sec (%dX%s)\n",
> -		       rate / 10, rate % 10 ? ".5" : "",
> +		       rate, (attr.active_speed == 1) ? ".5" : "",
>  		       ib_width_enum_to_int(attr.active_width), speed);
>  }
> 
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -77,6 +77,31 @@ enum ib_rate mult_to_ib_rate(int mult)
>  }
>  EXPORT_SYMBOL(mult_to_ib_rate);
> 
> +int ib_rate_to_mbps(enum ib_rate rate)
> +{
> +	switch (rate) {
> +	case IB_RATE_2_5_GBPS: return 2500;
> +	case IB_RATE_5_GBPS:   return 5000;
> +	case IB_RATE_10_GBPS:  return 10000;
> +	case IB_RATE_20_GBPS:  return 20000;
> +	case IB_RATE_30_GBPS:  return 30000;
> +	case IB_RATE_40_GBPS:  return 40000;
> +	case IB_RATE_60_GBPS:  return 60000;
> +	case IB_RATE_80_GBPS:  return 80000;
> +	case IB_RATE_120_GBPS: return 120000;
> +	case IB_RATE_14_GBPS:  return 14062;
> +	case IB_RATE_56_GBPS:  return 56250;
> +	case IB_RATE_112_GBPS: return 112500;
> +	case IB_RATE_168_GBPS: return 168750;
> +	case IB_RATE_25_GBPS:  return 25781;
> +	case IB_RATE_100_GBPS: return 103125;
> +	case IB_RATE_200_GBPS: return 206250;
> +	case IB_RATE_300_GBPS: return 309375;
> +	default:	       return -1;
> +	}
> +}
> +EXPORT_SYMBOL(ib_rate_to_mbps);
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
> @@ -415,7 +416,15 @@ enum ib_rate {
>  	IB_RATE_40_GBPS  = 7,
>  	IB_RATE_60_GBPS  = 8,
>  	IB_RATE_80_GBPS  = 9,
> -	IB_RATE_120_GBPS = 10
> +	IB_RATE_120_GBPS = 10,
> +	IB_RATE_14_GBPS  = 11,
> +	IB_RATE_56_GBPS  = 12,
> +	IB_RATE_112_GBPS = 13,
> +	IB_RATE_168_GBPS = 14,
> +	IB_RATE_25_GBPS  = 15,
> +	IB_RATE_100_GBPS = 16,
> +	IB_RATE_200_GBPS = 17,
> +	IB_RATE_300_GBPS = 18
>  };
> 
>  /**
> @@ -427,6 +436,13 @@ enum ib_rate {
>  int ib_rate_to_mult(enum ib_rate rate) __attribute_const__;
> 
>  /**
> + * ib_rate_to_mbps - Convert the IB rate enum to Mbps.
> + * For example, IB_RATE_2_5_GBPS will be converted to 2500.
> + * @rate: rate to convert.
> + */
> +int ib_rate_to_mbps(enum ib_rate rate) __attribute_const__;
> +
> +/**
>   * mult_to_ib_rate - Convert a multiple of 2.5 Gbit/sec to an IB rate
>   * enum.
>   * @mult: multiple to convert.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
