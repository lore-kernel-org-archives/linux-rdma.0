From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] Create get_perf_mad function in sysfs.c
Date: Mon, 21 Dec 2015 12:42:09 -0500
Message-ID: <20151221174209.GG3860@phlsvsds.ph.intel.com>
References: <20151221142026.238104419@linux.com> <20151221142039.168096557@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151221142039.168096557-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 21, 2015 at 08:20:27AM -0600, Christoph Lameter wrote:
> Create a new function to retrieve performance management
> data from the existing code in get_pma_counter().
> 
> Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/sysfs.c | 62 ++++++++++++++++++++++++++---------------
>  1 file changed, 40 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
> index b1f37d4..acefe85 100644
> --- a/drivers/infiniband/core/sysfs.c
> +++ b/drivers/infiniband/core/sysfs.c
> @@ -317,21 +317,21 @@ struct port_table_attribute port_pma_attr_##_name = {			\
>  	.index = (_offset) | ((_width) << 16) | ((_counter) << 24)	\
>  }
>  
> -static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
> -				char *buf)
> +/*
> + * Get a Perfmgmt MAD block of data.
> + * Returns error code or the number of bytes retrieved.
> + */
> +static int get_perf_mad(struct ib_device *dev, int port_num, int attr,
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
> @@ -344,12 +344,12 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
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
> @@ -358,31 +358,49 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
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
> +	ret = get_perf_mad(p->ibdev, p->port_num, cpu_to_be16(0x12), &data,
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
>  		break;
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
> -- 
> 2.5.0
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
