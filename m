From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH RFC 1/4] ib/core: handle EDR/FDR extended speeds
Date: Mon, 19 Sep 2011 18:00:51 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E64FDC@ORSMSX101.amr.corp.intel.com>
References: <201109191906.05360.marcela@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201109191906.05360.marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcel Apfelbaum <marcela-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Index: b/drivers/infiniband/core/verbs.c
> ===================================================================
> --- a/drivers/infiniband/core/verbs.c	2011-09-13 13:34:19.660539000 +0300
> +++ b/drivers/infiniband/core/verbs.c	2011-09-13 16:42:39.713754400 +0300
> @@ -77,6 +77,23 @@ enum ib_rate mult_to_ib_rate(int mult)
>  }
>  EXPORT_SYMBOL(mult_to_ib_rate);
> 
> +int ib_ext_rate_to_int(enum ib_rate rate)
> +{
> +	switch (rate) {
> +	case IB_RATE_14_GBPS:	return 14;
> +	case IB_RATE_56_GBPS:	return 56;
> +	case IB_RATE_112_GBPS:	return 112;
> +	case IB_RATE_168_GBPS:	return 168;
> +	case IB_RATE_25_GBPS:	return 25;
> +	case IB_RATE_100_GBPS:	return 100;
> +	case IB_RATE_200_GBPS:	return 200;
> +	case IB_RATE_300_GBPS:	return 300;
> +	/* For higher speeds report 56 */
> +	default:		return 56;
> +	}
> +}
> +EXPORT_SYMBOL(ib_ext_rate_to_int);

I don't like the idea of introducing new fields and functions to report the rate when there are existing ones that should be usable.

> +
>  enum rdma_transport_type
>  rdma_node_get_transport(enum rdma_node_type node_type)
>  {
> Index: b/drivers/infiniband/ulp/ipoib/ipoib_fs.c
> ===================================================================
> --- a/drivers/infiniband/ulp/ipoib/ipoib_fs.c	2011-09-13 13:34:19.666040100
> +0300
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_fs.c	2011-09-13 13:34:25.043115300
> +0300
> @@ -212,16 +212,28 @@ static int ipoib_path_seq_show(struct se
>  		   gid_buf, path.pathrec.dlid ? "yes" : "no");
> 
>  	if (path.pathrec.dlid) {
> -		rate = ib_rate_to_mult(path.pathrec.rate) * 25;
> +		if (path.pathrec.rate > IB_RATE_120_GBPS) {
> +			rate = ib_ext_rate_to_int(path.pathrec.rate);
> 
> -		seq_printf(file,
> -			   "  DLID:     0x%04x\n"
> -			   "  SL: %12d\n"
> -			   "  rate: %*d%s Gb/sec\n",
> -			   be16_to_cpu(path.pathrec.dlid),
> -			   path.pathrec.sl,
> -			   10 - ((rate % 10) ? 2 : 0),
> -			   rate / 10, rate % 10 ? ".5" : "");
> +			seq_printf(file,
> +				   "  DLID:     0x%04x\n"
> +				   "  SL: %12d\n"
> +				   "  rate: %*d Gb/sec\n",
> +				   be16_to_cpu(path.pathrec.dlid),
> +				   path.pathrec.sl,
> +				   rate);
> +		} else {
> +			rate = ib_rate_to_mult(path.pathrec.rate) * 25;
> +
> +			seq_printf(file,
> +				   "  DLID:     0x%04x\n"
> +				   "  SL: %12d\n"
> +				   "  rate: %*d%s Gb/sec\n",
> +				   be16_to_cpu(path.pathrec.dlid),
> +				   path.pathrec.sl,
> +				   10 - ((rate % 10) ? 2 : 0),
> +				   rate / 10, rate % 10 ? ".5" : "");
> +		}
>  	}
> 
>  	seq_putc(file, '\n');
> Index: b/include/rdma/ib_user_verbs.h
> ===================================================================
> --- a/include/rdma/ib_user_verbs.h	2011-09-13 13:34:19.745055900 +0300
> +++ b/include/rdma/ib_user_verbs.h	2011-09-13 13:34:25.050116700 +0300
> @@ -206,7 +206,8 @@ struct ib_uverbs_query_port_resp {
>  	__u8  active_speed;
>  	__u8  phys_state;
>  	__u8  link_layer;
> -	__u8  reserved[2];
> +	__u8  ext_active_speed;
> +	__u8  reserved;
>  };

Why can't we carry the new speed values in the existing active_speed fields?  It seems awkward for a user to need to read 2 fields to get the active speed.

> +static inline int ib_ext_active_speed_to_rate(u8 ext_active_speed)
> +{
> +	switch (ext_active_speed) {
> +	case 1:	return 14;
> +	case 2:	return 25;
> +	default: return -1;
> +	}
> +}
> +
>  static inline int ib_width_enum_to_int(enum ib_port_width width)
>  {
>  	switch (width) {
> @@ -308,6 +318,7 @@ struct ib_port_attr {
>  	u8			active_width;
>  	u8			active_speed;
>  	u8                      phys_state;
> +	u8                      ext_active_speed;
>  };
> 
>  enum ib_device_modify_flags {
> @@ -415,7 +426,15 @@ enum ib_rate {
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
> +	IB_RATE_300_GBPS = 18,
>  };
> 
>  /**
> @@ -427,6 +446,14 @@ enum ib_rate {
>  int ib_rate_to_mult(enum ib_rate rate) __attribute_const__;
> 
>  /**
> + * ib_ext_rate_to_int - Convert the extended IB rate enum to a
> + * real integer value.  For example,
> + * IB_RATE_14_GBPS will be converted to 14
> + * @rate: extended rate to convert.
> + */
> +int ib_ext_rate_to_int(enum ib_rate rate) __attribute_const__;

Why can't the existing function be used?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
