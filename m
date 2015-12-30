From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V3 10/11] IB/core: Initialize UD header structure
 with IP and UDP headers
Date: Wed, 30 Dec 2015 07:57:38 +0200
Message-ID: <56837252.70705@mellanox.com>
References: <1450875417-19262-1-git-send-email-matanb@mellanox.com>
 <1450875417-19262-11-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450875417-19262-11-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/23/2015 2:56 PM, Matan Barak wrote:
>   
> +__be16 ib_ud_ip4_csum(struct ib_ud_header *header)
> +{
> +	struct iphdr iph;
> +
> +	iph.ihl		= 5;
> +	iph.version	= 4;
> +	iph.tos		= header->ip4.tos;
> +	iph.tot_len	= header->ip4.tot_len;
> +	iph.id		= header->ip4.id;
> +	iph.frag_off	= header->ip4.frag_off;
> +	iph.ttl		= header->ip4.ttl;
> +	iph.protocol	= header->ip4.protocol;
> +	iph.check	= 0;
> +	iph.saddr	= header->ip4.saddr;
> +	iph.daddr	= header->ip4.daddr;
> +
> +	return ip_fast_csum((u8 *)&iph, iph.ihl);
> +}
> +EXPORT_SYMBOL(ib_ud_ip4_csum);

You have introduced here this sparse warning, please fix

drivers/infiniband/core/ud_header.c:299:28: warning: incorrect type in 
return expression (different base types)
drivers/infiniband/core/ud_header.c:299:28:    expected restricted __be16
drivers/infiniband/core/ud_header.c:299:28:    got restricted __sum16

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
