From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V4 for-next 1/4] IB/core: Introduce capabilitymask2 field in ClassPortInfo mad
Date: Tue, 17 May 2016 15:45:16 -0400
Message-ID: <20160517194515.GA17141@phlsvsds.ph.intel.com>
References: <1463401694-19247-1-git-send-email-erezsh@mellanox.com> <1463401694-19247-2-git-send-email-erezsh@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1463401694-19247-2-git-send-email-erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 16, 2016 at 03:28:11PM +0300, Erez Shitrit wrote:
> 

<snip>

>  
> +/**
> + * ib_get_cpi_resp_time - Returns the resp_time value from
> + * cap_mask2_resp_time in ib_class_port_info.
> + * @cpi: A struct ib_class_port_info mad.
> + */
> +static inline u8 ib_get_cpi_resp_time(struct ib_class_port_info *cpi)
> +{
> +	return ((be32_to_cpu(cpi->cap_mask2_resp_time) & 0xF8) >> 3);

return (uint8_t)((be32_to_cpu(cpi->cap_mask2_resp_time) & 0xF8000000) >> 27);

???

> +}
> +
> +/**
> + * ib_set_cpi_resptime - Sets the response time in an
> + * ib_class_port_info mad.
> + * @cpi: A struct ib_class_port_info.
> + * @rtime: The response time to set.
> + */
> +static inline void ib_set_cpi_resp_time(struct ib_class_port_info *cpi,
> +					u8 rtime)
> +{
> +	u32 tmp;
> +	u32 tmp2;
> +
> +	tmp = rtime;
> +	tmp = tmp << 3;

<< 27 ???


> +	tmp2 = (be32_to_cpu(cpi->cap_mask2_resp_time) & ~0xF8);
> +	tmp = tmp | tmp2;
> +	cpi->cap_mask2_resp_time = cpu_to_be32(tmp);
> +}
> +
> +/**
> + * ib_get_cpi_capmask2 - Returns the capmask2 value from
> + * cap_mask2_resp_time in ib_class_port_info.
> + * @cpi: A struct ib_class_port_info mad.
> + */
> +static inline u32 ib_get_cpi_capmask2(struct ib_class_port_info *cpi)
> +{
> +	u8 tmp;
> +
> +	tmp = ((be32_to_cpu(cpi->cap_mask2_resp_time) & 0x7) << 5);
> +	return (((be32_to_cpu(cpi->cap_mask2_resp_time) & ~0xFF) >> 5) | tmp);


return (be32_to_cpu(cpi->cap_mask2_resp_time) & 0x07FFFFFF);


?


> +}
> +
> +/**
> + * ib_set_cpi_capmask2 - Sets the capmask2 in an
> + * ib_class_port_info mad.
> + * @cpi: A struct ib_class_port_info.
> + * @capmask2: The capmask2 to set.
> + */
> +static inline void ib_set_cpi_capmask2(struct ib_class_port_info *cpi,
> +				       u32 capmask2)
> +{
> +	u32 tmp;
> +
> +	tmp = ib_get_cpi_resp_time(cpi);
> +	tmp = tmp << 27;
> +	cpi->cap_mask2_resp_time = (__force __be32)(tmp | capmask2);

Why is this not

cpi->cap_mask2_resp_time = cpu_to_be32(..);

?

Ira


> +}
> +
>  struct ib_mad_notice_attr {
>  	u8 generic_type;
>  	u8 prod_type_msb;
> -- 
> 1.7.11.3
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
