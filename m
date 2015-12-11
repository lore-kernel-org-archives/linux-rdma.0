From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] IB core: Allow specification of attr_id in PORT_PMA_ATTR macro
Date: Fri, 11 Dec 2015 18:31:00 -0500
Message-ID: <20151211233100.GE7855@phlsvsds.ph.intel.com>
References: <20151211182532.332343651@linux.com> <20151211182543.135984387@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151211182543.135984387-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 11, 2015 at 12:25:33PM -0600, Christoph Lameter wrote:
> This is necessary to support the extended attributes which involves
> a different attribute id.
> 
> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/infiniband/core/sysfs.c | 41 ++++++++++++++++++++++-------------------
>  1 file changed, 22 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
> index b1f37d4..1c8716f 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
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
> @@ -311,10 +313,11 @@ static ssize_t show_port_pkey(struct ib_port *p, struct port_attribute *attr,
>  	return sprintf(buf, "0x%04x\n", pkey);
>  }
>  
> -#define PORT_PMA_ATTR(_name, _counter, _width, _offset)			\
> +#define PORT_PMA_ATTR(_name, _counter, _width, _offset, _attr_id)	\
>  struct port_table_attribute port_pma_attr_##_name = {			\
>  	.attr  = __ATTR(_name, S_IRUGO, show_pma_counter, NULL),	\
> -	.index = (_offset) | ((_width) << 16) | ((_counter) << 24)	\
> +	.index = (_offset) | ((_width) << 16) | ((_counter) << 24),	\
> +	.attr_id = _attr_id ,						\
>  }
>  
>  static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
> @@ -344,7 +347,7 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
>  	in_mad->mad_hdr.mgmt_class    = IB_MGMT_CLASS_PERF_MGMT;
>  	in_mad->mad_hdr.class_version = 1;
>  	in_mad->mad_hdr.method        = IB_MGMT_METHOD_GET;
> -	in_mad->mad_hdr.attr_id       = cpu_to_be16(0x12); /* PortCounters */
> +	in_mad->mad_hdr.attr_id       = tab_attr->attr_id;
>  
>  	in_mad->data[41] = p->port_num;	/* PortSelect field */
>  
> @@ -386,22 +389,22 @@ out:
>  	return ret;
>  }
>  
> -static PORT_PMA_ATTR(symbol_error		    ,  0, 16,  32);
> -static PORT_PMA_ATTR(link_error_recovery	    ,  1,  8,  48);
> -static PORT_PMA_ATTR(link_downed		    ,  2,  8,  56);
> -static PORT_PMA_ATTR(port_rcv_errors		    ,  3, 16,  64);
> -static PORT_PMA_ATTR(port_rcv_remote_physical_errors,  4, 16,  80);
> -static PORT_PMA_ATTR(port_rcv_switch_relay_errors   ,  5, 16,  96);
> -static PORT_PMA_ATTR(port_xmit_discards		    ,  6, 16, 112);
> -static PORT_PMA_ATTR(port_xmit_constraint_errors    ,  7,  8, 128);
> -static PORT_PMA_ATTR(port_rcv_constraint_errors	    ,  8,  8, 136);
> -static PORT_PMA_ATTR(local_link_integrity_errors    ,  9,  4, 152);
> -static PORT_PMA_ATTR(excessive_buffer_overrun_errors, 10,  4, 156);
> -static PORT_PMA_ATTR(VL15_dropped		    , 11, 16, 176);
> -static PORT_PMA_ATTR(port_xmit_data		    , 12, 32, 192);
> -static PORT_PMA_ATTR(port_rcv_data		    , 13, 32, 224);
> -static PORT_PMA_ATTR(port_xmit_packets		    , 14, 32, 256);
> -static PORT_PMA_ATTR(port_rcv_packets		    , 15, 32, 288);
> +static PORT_PMA_ATTR(symbol_error		    ,  0, 16,  32, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(link_error_recovery	    ,  1,  8,  48, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(link_downed		    ,  2,  8,  56, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(port_rcv_errors		    ,  3, 16,  64, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(port_rcv_remote_physical_errors,  4, 16,  80, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(port_rcv_switch_relay_errors   ,  5, 16,  96, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(port_xmit_discards		    ,  6, 16, 112, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(port_xmit_constraint_errors    ,  7,  8, 128, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(port_rcv_constraint_errors	    ,  8,  8, 136, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(local_link_integrity_errors    ,  9,  4, 152, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(excessive_buffer_overrun_errors, 10,  4, 156, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(VL15_dropped		    , 11, 16, 176, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(port_xmit_data		    , 12, 32, 192, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(port_rcv_data		    , 13, 32, 224, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(port_xmit_packets		    , 14, 32, 256, IB_PMA_PORT_COUNTERS);
> +static PORT_PMA_ATTR(port_rcv_packets		    , 15, 32, 288, IB_PMA_PORT_COUNTERS);
>  
>  static struct attribute *pma_attrs[] = {
>  	&port_pma_attr_symbol_error.attr.attr,
> -- 
> 2.5.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
