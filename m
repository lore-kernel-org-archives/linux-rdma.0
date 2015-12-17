From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended
 set
Date: Thu, 17 Dec 2015 12:44:31 -0500
Message-ID: <5672F47F.9060806@dev.mellanox.co.il>
References: <20151211182532.332343651@linux.com>
 <20151211182543.329283794@linux.com>
 <20151211235630.GG7855@phlsvsds.ph.intel.com>
 <20151212000047.GA9961@obsidianresearch.com>
 <566EEE69.5080906@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512151351050.3509@east.gentwo.org>
 <20151215195554.GA28167@obsidianresearch.com>
 <5670717F.9090701@dev.mellanox.co.il>
 <20151215212035.GD28167@obsidianresearch.com>
 <alpine.DEB.2.20.1512161000150.17457@east.gentwo.org>
 <alpine.DEB.2.20.1512161332200.10147@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1512161332200.10147-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/16/2015 2:34 PM, Christoph Lameter wrote:
> On Wed, 16 Dec 2015, Christoph Lameter wrote:
> 
>> DRAFT: This is missing the check if this device supports
>> extended counters.
> 
> Found some time and here is the patch with the detection of the extended
> attribute through sending a mad request. Untested. Got the info on how
> to do the proper mad request from an earlier patch by Or in 2011.
> 
> 
> Subject: IB Core: Display extended counter set if available V2
> 
> Check if the extended counters are available and if so
> create the proper extended and additional counters.

Looks mostly good to me with some minor comments below.

> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> 
> Index: linux/drivers/infiniband/core/sysfs.c
> ===================================================================
> --- linux.orig/drivers/infiniband/core/sysfs.c
> +++ linux/drivers/infiniband/core/sysfs.c
> @@ -39,6 +39,7 @@
>  #include <linux/string.h>
> 
>  #include <rdma/ib_mad.h>
> +#include <rdma/ib_pma.h>
> 
>  struct ib_port {
>  	struct kobject         kobj;
> @@ -65,6 +66,7 @@ struct port_table_attribute {
>  	struct port_attribute	attr;
>  	char			name[8];
>  	int			index;
> +	int			attr_id;
>  };
> 
>  static ssize_t port_attr_show(struct kobject *kobj,
> @@ -314,24 +316,33 @@ static ssize_t show_port_pkey(struct ib_
>  #define PORT_PMA_ATTR(_name, _counter, _width, _offset)			\
>  struct port_table_attribute port_pma_attr_##_name = {			\
>  	.attr  = __ATTR(_name, S_IRUGO, show_pma_counter, NULL),	\
> -	.index = (_offset) | ((_width) << 16) | ((_counter) << 24)	\
> +	.index = (_offset) | ((_width) << 16) | ((_counter) << 24),	\
> +	.attr_id = IB_PMA_PORT_COUNTERS ,				\
>  }
> 
> -static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
> -				char *buf)
> +#define PORT_PMA_ATTR_EXT(_name, _width, _offset)			\
> +struct port_table_attribute port_pma_attr_ext_##_name = {		\
> +	.attr  = __ATTR(_name, S_IRUGO, show_pma_counter, NULL),	\
> +	.index = (_offset) | ((_width) << 16),				\
> +	.attr_id = IB_PMA_PORT_COUNTERS_EXT ,				\
> +}
> +
> +
> +/*
> + * Get a MAD block of data.

Nit: Get PerfMgt MAD block of data

> + * Returns error code or the number of bytes retrieved.
> + */
> +static int get_mad(struct ib_device *dev, int port_num, int attr,

Nit: Maybe this is too verbose but better name might be get_perf_mad

> +		void *data, int offset, size_t size)
>  {
> -	struct port_table_attribute *tab_attr =
> -		container_of(attr, struct port_table_attribute, attr);
> -	int offset = tab_attr->index & 0xffff;
> -	int width  = (tab_attr->index >> 16) & 0xff;
> -	struct ib_mad *in_mad  = NULL;
> -	struct ib_mad *out_mad = NULL;
> +	struct ib_mad *in_mad;
> +	struct ib_mad *out_mad;
>  	size_t mad_size = sizeof(*out_mad);
>  	u16 out_mad_pkey_index = 0;
>  	ssize_t ret;
> 
> -	if (!p->ibdev->process_mad)
> -		return sprintf(buf, "N/A (no PMA)\n");
> +	if (!dev->process_mad)
> +		return -ENOSYS;
> 
>  	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
>  	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
> @@ -344,12 +355,12 @@ static ssize_t show_pma_counter(struct i
>  	in_mad->mad_hdr.mgmt_class    = IB_MGMT_CLASS_PERF_MGMT;
>  	in_mad->mad_hdr.class_version = 1;
>  	in_mad->mad_hdr.method        = IB_MGMT_METHOD_GET;
> -	in_mad->mad_hdr.attr_id       = cpu_to_be16(0x12); /* PortCounters */
> +	in_mad->mad_hdr.attr_id       = attr;
> 
> -	in_mad->data[41] = p->port_num;	/* PortSelect field */
> +	in_mad->data[41] = port_num;	/* PortSelect field */
> 
> -	if ((p->ibdev->process_mad(p->ibdev, IB_MAD_IGNORE_MKEY,
> -		 p->port_num, NULL, NULL,
> +	if ((dev->process_mad(dev, IB_MAD_IGNORE_MKEY,
> +		 port_num, NULL, NULL,
>  		 (const struct ib_mad_hdr *)in_mad, mad_size,
>  		 (struct ib_mad_hdr *)out_mad, &mad_size,
>  		 &out_mad_pkey_index) &
> @@ -358,31 +369,54 @@ static ssize_t show_pma_counter(struct i
>  		ret = -EINVAL;
>  		goto out;
>  	}
> +	memcpy(data, out_mad->data + offset, size);
> +	ret = size;
> +out:
> +	kfree(in_mad);
> +	kfree(out_mad);
> +	return ret;
> +}
> +
> +static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
> +				char *buf)
> +{
> +	struct port_table_attribute *tab_attr =
> +		container_of(attr, struct port_table_attribute, attr);
> +	int offset = tab_attr->index & 0xffff;
> +	int width  = (tab_attr->index >> 16) & 0xff;
> +	ssize_t ret;
> +	u8 data[8];
> +
> +	ret = get_mad(p->ibdev, p->port_num, tab_attr->attr_id, &data,
> +			40 + offset / 8, sizeof(data));
> +	if (ret < 0)
> +		return sprintf(buf, "N/A (no PMA)\n");
> 
>  	switch (width) {
>  	case 4:
> -		ret = sprintf(buf, "%u\n", (out_mad->data[40 + offset / 8] >>
> +		ret = sprintf(buf, "%u\n", (*data >>
>  					    (4 - (offset % 8))) & 0xf);
>  		break;
>  	case 8:
> -		ret = sprintf(buf, "%u\n", out_mad->data[40 + offset / 8]);
> +		ret = sprintf(buf, "%u\n", *data);
>  		break;
>  	case 16:
>  		ret = sprintf(buf, "%u\n",
> -			      be16_to_cpup((__be16 *)(out_mad->data + 40 + offset / 8)));
> +			      be16_to_cpup((__be16 *)data));
>  		break;
>  	case 32:
>  		ret = sprintf(buf, "%u\n",
> -			      be32_to_cpup((__be32 *)(out_mad->data + 40 + offset / 8)));
> +			      be32_to_cpup((__be32 *)data));
> +		break;
> +	case 64:
> +		ret = sprintf(buf, "%llu\n",
> +				be64_to_cpup((__be64 *)data));
>  		break;
> +
>  	default:
>  		ret = 0;
>  	}
> 
> -out:
> -	kfree(in_mad);
> -	kfree(out_mad);
> -
>  	return ret;
>  }
> 
> @@ -403,6 +437,18 @@ static PORT_PMA_ATTR(port_rcv_data
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
> @@ -423,11 +469,40 @@ static struct attribute *pma_attrs[] = {
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
> @@ -500,6 +575,26 @@ err:
>  	return NULL;
>  }
> 
> +/*
> + * Check if the port supports the Extended Counters.
> + * Return error code of 0 for success
> + */
> +static int port_check_extended_counters(struct ib_device *dev, int port)
> +{
> +	int ret = 0;
> +	struct ib_class_port_info cpi;
> +
> +	ret = get_mad(dev, port, IB_PMA_CLASS_PORT_INFO, &cpi, 40, sizeof(cpi));

ClassPortInfo is per class not per class per port so need to indicate to
get_mad whether a port is supplied or not or conditionalize based on
attr ID.

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
> @@ -528,7 +623,11 @@ static int add_port(struct ib_device *de
>  		return ret;
>  	}
> 
> -	ret = sysfs_create_group(&p->kobj, &pma_group);
> +	ret = sysfs_create_group(&p->kobj,
> +		port_check_extended_counters(device, port_num) ?
> +			&pma_group_ext :
> +			&pma_group);

PortExtendedCounters does not have all the error counters in
PortCounters so this isn't an either or. When extended port counters are
supported should still include the original port counters with the
exception of the [xmit rcv] [pkts data] which should come from the
extended counters.

-- Hal

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
