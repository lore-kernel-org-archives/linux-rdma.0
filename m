From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3] bject: IB Core: Display extended counter set if
 available
Date: Thu, 17 Dec 2015 15:11:35 -0500
Message-ID: <567316F7.9030707@dev.mellanox.co.il>
References: <20151217195255.334854705@linux.com>
 <20151217195312.334770847@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151217195312.334770847-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/17/2015 2:52 PM, Christoph Lameter wrote:
> Check if the extended counters are available and if so
> create the proper extended and additional counters.
> 
> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> 
> Index: linux/drivers/infiniband/core/sysfs.c
> ===================================================================
> --- linux.orig/drivers/infiniband/core/sysfs.c
> +++ linux/drivers/infiniband/core/sysfs.c
> @@ -320,6 +320,13 @@ struct port_table_attribute port_pma_att
>  	.attr_id = IB_PMA_PORT_COUNTERS ,				\
>  }
>  
> +#define PORT_PMA_ATTR_EXT(_name, _width, _offset)			\
> +struct port_table_attribute port_pma_attr_ext_##_name = {		\
> +	.attr  = __ATTR(_name, S_IRUGO, show_pma_counter, NULL),	\
> +	.index = (_offset) | ((_width) << 16),				\
> +	.attr_id = IB_PMA_PORT_COUNTERS_EXT ,				\
> +}
> +
>  /*
>   * Get a Perfmgmt MAD block of data.
>   * Returns error code or the number of bytes retrieved.
> @@ -349,7 +356,8 @@ static int get_perf_mad(struct ib_device
>  	in_mad->mad_hdr.method        = IB_MGMT_METHOD_GET;
>  	in_mad->mad_hdr.attr_id       = attr;
>  
> -	in_mad->data[41] = port_num;	/* PortSelect field */
> +	if (port_num)
> +		in_mad->data[41] = port_num;	/* PortSelect field */
>  
>  	if ((dev->process_mad(dev, IB_MAD_IGNORE_MKEY,
>  		 port_num, NULL, NULL,
> @@ -400,6 +408,11 @@ static ssize_t show_pma_counter(struct i
>  		ret = sprintf(buf, "%u\n",
>  			      be32_to_cpup((__be32 *)data));
>  		break;
> +	case 64:
> +		ret = sprintf(buf, "%llu\n",
> +				be64_to_cpup((__be64 *)data));
> +		break;
> +
>  	default:
>  		ret = 0;
>  	}
> @@ -424,6 +437,18 @@ static PORT_PMA_ATTR(port_rcv_data
>  static PORT_PMA_ATTR(port_xmit_packets		    , 14, 32, 256);
>  static PORT_PMA_ATTR(port_rcv_packets		    , 15, 32, 288);
>  
> +/*
> + * Counters added by extended set
> + */
> +static PORT_PMA_ATTR_EXT(port_xmit_data		    , 64,  64);
> +static PORT_PMA_ATTR_EXT(port_rcv_data		    , 64, 128);
> +static PORT_PMA_ATTR_EXT(port_xmit_packets	    , 64, 192);
> +static PORT_PMA_ATTR_EXT(port_rcv_packets	    , 64, 256);
> +static PORT_PMA_ATTR_EXT(unicast_xmit_packets	    , 64, 320);
> +static PORT_PMA_ATTR_EXT(unicast_rcv_packets	    , 64, 384);
> +static PORT_PMA_ATTR_EXT(multicast_xmit_packets	    , 64, 448);
> +static PORT_PMA_ATTR_EXT(multicast_rcv_packets	    , 64, 512);
> +
>  static struct attribute *pma_attrs[] = {
>  	&port_pma_attr_symbol_error.attr.attr,
>  	&port_pma_attr_link_error_recovery.attr.attr,
> @@ -444,11 +469,40 @@ static struct attribute *pma_attrs[] = {
>  	NULL
>  };
>  
> +static struct attribute *pma_attrs_ext[] = {
> +	&port_pma_attr_symbol_error.attr.attr,
> +	&port_pma_attr_link_error_recovery.attr.attr,
> +	&port_pma_attr_link_downed.attr.attr,
> +	&port_pma_attr_port_rcv_errors.attr.attr,
> +	&port_pma_attr_port_rcv_remote_physical_errors.attr.attr,
> +	&port_pma_attr_port_rcv_switch_relay_errors.attr.attr,
> +	&port_pma_attr_port_xmit_discards.attr.attr,
> +	&port_pma_attr_port_xmit_constraint_errors.attr.attr,
> +	&port_pma_attr_port_rcv_constraint_errors.attr.attr,
> +	&port_pma_attr_local_link_integrity_errors.attr.attr,
> +	&port_pma_attr_excessive_buffer_overrun_errors.attr.attr,
> +	&port_pma_attr_VL15_dropped.attr.attr,
> +	&port_pma_attr_ext_port_xmit_data.attr.attr,
> +	&port_pma_attr_ext_port_rcv_data.attr.attr,
> +	&port_pma_attr_ext_port_xmit_packets.attr.attr,
> +	&port_pma_attr_ext_port_rcv_packets.attr.attr,
> +	&port_pma_attr_ext_unicast_rcv_packets.attr.attr,
> +	&port_pma_attr_ext_unicast_xmit_packets.attr.attr,
> +	&port_pma_attr_ext_multicast_rcv_packets.attr.attr,
> +	&port_pma_attr_ext_multicast_xmit_packets.attr.attr,
> +	NULL
> +};
> +
>  static struct attribute_group pma_group = {
>  	.name  = "counters",
>  	.attrs  = pma_attrs
>  };
>  
> +static struct attribute_group pma_group_ext = {
> +	.name  = "counters",
> +	.attrs  = pma_attrs_ext
> +};
> +
>  static void ib_port_release(struct kobject *kobj)
>  {
>  	struct ib_port *p = container_of(kobj, struct ib_port, kobj);
> @@ -521,6 +575,26 @@ err:
>  	return NULL;
>  }
>  
> +/*
> + * Check if the port supports the Extended Counters.
> + * Return error code of 0 for success
> + */
> +static int port_check_extended_counters(struct ib_device *dev)
> +{
> +	int ret = 0;
> +	struct ib_class_port_info cpi;
> +
> +	ret = get_perf_mad(dev, 0, IB_PMA_CLASS_PORT_INFO, &cpi, 40, sizeof(cpi));
> +
> +	if (ret >= 0) {
> +		if (!(cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH) &&
> +			!(cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF))
> +			ret = -ENOSYS;
> +	}
> +
> +	return ret;
> +}
> +
>  static int add_port(struct ib_device *device, int port_num,
>  		    int (*port_callback)(struct ib_device *,
>  					 u8, struct kobject *))
> @@ -549,7 +623,11 @@ static int add_port(struct ib_device *de
>  		return ret;
>  	}un
>  
> -	ret = sysfs_create_group(&p->kobj, &pma_group);
> +	ret = sysfs_create_group(&p->kobj,
> +		port_check_extended_counters(device) ?
> +			&pma_group_ext :

Would be nice to populate 2 different groups based on whether PMA
supports full extended counters or extended counters without the IETF
ones (no [uni mcast] [rcv xmit] pkt counters) in sysfs.

-- Hal

> +			&pma_group);
> +
>  	if (ret)
>  		goto err_put;
>  
> Index: linux/include/rdma/ib_pma.h
> ===================================================================
> --- linux.orig/include/rdma/ib_pma.h
> +++ linux/include/rdma/ib_pma.h
> @@ -42,6 +42,7 @@
>   */
>  #define IB_PMA_CLASS_CAP_ALLPORTSELECT  cpu_to_be16(1 << 8)
>  #define IB_PMA_CLASS_CAP_EXT_WIDTH      cpu_to_be16(1 << 9)
> +#define IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF cpu_to_be16(1 << 10)
>  #define IB_PMA_CLASS_CAP_XMIT_WAIT      cpu_to_be16(1 << 12)
>  
>  #define IB_PMA_CLASS_PORT_INFO          cpu_to_be16(0x0001)
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
