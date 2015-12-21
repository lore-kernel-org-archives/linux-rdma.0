From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3] Display extended counter set if available
Date: Mon, 21 Dec 2015 12:57:29 -0500
Message-ID: <56783D89.4060704@dev.mellanox.co.il>
References: <20151221142026.238104419@linux.com>
 <20151221142039.386488696@linux.com>
 <20151221175311.GI3860@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151221175311.GI3860-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/21/2015 12:53 PM, ira.weiny wrote:
> On Mon, Dec 21, 2015 at 08:20:29AM -0600, Christoph Lameter wrote:
>> V2->V3: Add check for NOIETF mode and create special table
>>   for that case.
>>
>> Check if the extended counters are available and if so
>> create the proper extended and additional counters.
>>
>> Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/infiniband/core/sysfs.c | 104 +++++++++++++++++++++++++++++++++++++++-
>>  include/rdma/ib_pma.h           |   1 +
>>  2 files changed, 104 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
>> index 34dcc23..b179fca 100644
>> --- a/drivers/infiniband/core/sysfs.c
>> +++ b/drivers/infiniband/core/sysfs.c
>> @@ -320,6 +320,13 @@ struct port_table_attribute port_pma_attr_##_name = {			\
>>  	.attr_id = IB_PMA_PORT_COUNTERS ,				\
>>  }
>>  
>> +#define PORT_PMA_ATTR_EXT(_name, _width, _offset)			\
>> +struct port_table_attribute port_pma_attr_ext_##_name = {		\
>> +	.attr  = __ATTR(_name, S_IRUGO, show_pma_counter, NULL),	\
>> +	.index = (_offset) | ((_width) << 16),				\
>> +	.attr_id = IB_PMA_PORT_COUNTERS_EXT ,				\
>> +}
>> +
>>  /*
>>   * Get a Perfmgmt MAD block of data.
>>   * Returns error code or the number of bytes retrieved.
>> @@ -400,6 +407,11 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
>>  		ret = sprintf(buf, "%u\n",
>>  			      be32_to_cpup((__be32 *)data));
>>  		break;
>> +	case 64:
>> +		ret = sprintf(buf, "%llu\n",
>> +				be64_to_cpup((__be64 *)data));
>> +		break;
>> +
>>  	default:
>>  		ret = 0;
>>  	}
>> @@ -424,6 +436,18 @@ static PORT_PMA_ATTR(port_rcv_data		    , 13, 32, 224);
>>  static PORT_PMA_ATTR(port_xmit_packets		    , 14, 32, 256);
>>  static PORT_PMA_ATTR(port_rcv_packets		    , 15, 32, 288);
>>  
>> +/*
>> + * Counters added by extended set
>> + */
>> +static PORT_PMA_ATTR_EXT(port_xmit_data		    , 64,  64);
>> +static PORT_PMA_ATTR_EXT(port_rcv_data		    , 64, 128);
>> +static PORT_PMA_ATTR_EXT(port_xmit_packets	    , 64, 192);
>> +static PORT_PMA_ATTR_EXT(port_rcv_packets	    , 64, 256);
>> +static PORT_PMA_ATTR_EXT(unicast_xmit_packets	    , 64, 320);
>> +static PORT_PMA_ATTR_EXT(unicast_rcv_packets	    , 64, 384);
>> +static PORT_PMA_ATTR_EXT(multicast_xmit_packets	    , 64, 448);
>> +static PORT_PMA_ATTR_EXT(multicast_rcv_packets	    , 64, 512);
>> +
>>  static struct attribute *pma_attrs[] = {
>>  	&port_pma_attr_symbol_error.attr.attr,
>>  	&port_pma_attr_link_error_recovery.attr.attr,
>> @@ -444,11 +468,65 @@ static struct attribute *pma_attrs[] = {
>>  	NULL
>>  };
>>  
>> +static struct attribute *pma_attrs_ext[] = {
>> +	&port_pma_attr_symbol_error.attr.attr,
>> +	&port_pma_attr_link_error_recovery.attr.attr,
>> +	&port_pma_attr_link_downed.attr.attr,
>> +	&port_pma_attr_port_rcv_errors.attr.attr,
>> +	&port_pma_attr_port_rcv_remote_physical_errors.attr.attr,
>> +	&port_pma_attr_port_rcv_switch_relay_errors.attr.attr,
>> +	&port_pma_attr_port_xmit_discards.attr.attr,
>> +	&port_pma_attr_port_xmit_constraint_errors.attr.attr,
>> +	&port_pma_attr_port_rcv_constraint_errors.attr.attr,
>> +	&port_pma_attr_local_link_integrity_errors.attr.attr,
>> +	&port_pma_attr_excessive_buffer_overrun_errors.attr.attr,
>> +	&port_pma_attr_VL15_dropped.attr.attr,
>> +	&port_pma_attr_ext_port_xmit_data.attr.attr,
>> +	&port_pma_attr_ext_port_rcv_data.attr.attr,
>> +	&port_pma_attr_ext_port_xmit_packets.attr.attr,
>> +	&port_pma_attr_ext_port_rcv_packets.attr.attr,
>> +	&port_pma_attr_ext_unicast_rcv_packets.attr.attr,
>> +	&port_pma_attr_ext_unicast_xmit_packets.attr.attr,
>> +	&port_pma_attr_ext_multicast_rcv_packets.attr.attr,
>> +	&port_pma_attr_ext_multicast_xmit_packets.attr.attr,
>> +	NULL
>> +};
>> +
>> +static struct attribute *pma_attrs_noietf[] = {
>> +	&port_pma_attr_symbol_error.attr.attr,
>> +	&port_pma_attr_link_error_recovery.attr.attr,
>> +	&port_pma_attr_link_downed.attr.attr,
>> +	&port_pma_attr_port_rcv_errors.attr.attr,
>> +	&port_pma_attr_port_rcv_remote_physical_errors.attr.attr,
>> +	&port_pma_attr_port_rcv_switch_relay_errors.attr.attr,
>> +	&port_pma_attr_port_xmit_discards.attr.attr,
>> +	&port_pma_attr_port_xmit_constraint_errors.attr.attr,
>> +	&port_pma_attr_port_rcv_constraint_errors.attr.attr,
>> +	&port_pma_attr_local_link_integrity_errors.attr.attr,
>> +	&port_pma_attr_excessive_buffer_overrun_errors.attr.attr,
>> +	&port_pma_attr_VL15_dropped.attr.attr,
>> +	&port_pma_attr_ext_port_xmit_data.attr.attr,
>> +	&port_pma_attr_ext_port_rcv_data.attr.attr,
>> +	&port_pma_attr_ext_port_xmit_packets.attr.attr,
>> +	&port_pma_attr_ext_port_rcv_packets.attr.attr,
>> +	NULL
>> +};
>> +
>>  static struct attribute_group pma_group = {
>>  	.name  = "counters",
>>  	.attrs  = pma_attrs
>>  };
>>  
>> +static struct attribute_group pma_group_ext = {
>> +	.name  = "counters",
>> +	.attrs  = pma_attrs_ext
>> +};
>> +
>> +static struct attribute_group pma_group_noietf = {
>> +	.name  = "counters",
>> +	.attrs  = pma_attrs_noietf
>> +};
>> +
>>  static void ib_port_release(struct kobject *kobj)
>>  {
>>  	struct ib_port *p = container_of(kobj, struct ib_port, kobj);
>> @@ -521,6 +599,30 @@ err:
>>  	return NULL;
>>  }
>>  
>> +/*
>> + * Figure out which counter table to use depending on
>> + * the device capabilities.
>> + */
>> +static struct attribute_group *get_counter_table(struct ib_device *dev)
>> +{
>> +	struct ib_class_port_info cpi;
>> +
>> +	if (get_perf_mad(dev, 0, IB_PMA_CLASS_PORT_INFO,
>> +				&cpi, 40, sizeof(cpi)) >= 0) {
>> +
>> +		if (cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH)
>> +			/* We have extended counters */
>> +			return &pma_group_ext;
>> +
>> +		if (cpi.capability_mask && IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF)
>> +			/* But not the IETF ones */
>> +			return &pma_group_noietf;
>> +	}
>> +
>> +	/* Fall back to normal counters */
>> +	return &pma_group;
>> +}
>> +
>>  static int add_port(struct ib_device *device, int port_num,
>>  		    int (*port_callback)(struct ib_device *,
>>  					 u8, struct kobject *))
>> @@ -549,7 +651,7 @@ static int add_port(struct ib_device *device, int port_num,
>>  		return ret;
>>  	}
>>  
>> -	ret = sysfs_create_group(&p->kobj, &pma_group);
>> +	ret = sysfs_create_group(&p->kobj, get_counter_table(device));
> 
> Don't we need to change all the sysfs_remove_groups to use get_counter_table as
> well?

Looks like it to me too. Good catch.

-- Hal

> 
> Ira
> 
>>  	if (ret)
>>  		goto err_put;
>>  
>> diff --git a/include/rdma/ib_pma.h b/include/rdma/ib_pma.h
>> index a5889f1..2f8a65c 100644
>> --- a/include/rdma/ib_pma.h
>> +++ b/include/rdma/ib_pma.h
>> @@ -42,6 +42,7 @@
>>   */
>>  #define IB_PMA_CLASS_CAP_ALLPORTSELECT  cpu_to_be16(1 << 8)
>>  #define IB_PMA_CLASS_CAP_EXT_WIDTH      cpu_to_be16(1 << 9)
>> +#define IB_PMA_CLASS_CAP_EXT_WIDTH_NOIETF cpu_to_be16(1 << 10)
>>  #define IB_PMA_CLASS_CAP_XMIT_WAIT      cpu_to_be16(1 << 12)
>>  
>>  #define IB_PMA_CLASS_PORT_INFO          cpu_to_be16(0x0001)
>> -- 
>> 2.5.0
>>
>>
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
