From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 07/11] IB/core: Validate route in
 ib_init_ah_from_wc and ib_init_ah_from_path
Date: Mon, 7 Dec 2015 15:42:12 +0200
Message-ID: <56658CB4.7090402@mellanox.com>
References: <1449150450-13679-1-git-send-email-matanb@mellanox.com>
 <1449150450-13679-20-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449150450-13679-20-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/03/2015 03:47 PM, Matan Barak wrote:
> +static int addr_resolve_neigh(struct dst_entry *dst,
> +			      const struct sockaddr *dst_in,
> +			      struct rdma_dev_addr *addr)
> +{
> +	if (dst->dev->flags & IFF_LOOPBACK) {
> +		int ret;
> +
> +		ret = rdma_translate_ip(dst_in, addr, NULL);
> +		if (!ret)
> +			memcpy(addr->dst_dev_addr, addr->src_dev_addr,
> +			       MAX_ADDR_LEN);
> +
> +		return ret;
> +	}
> +
> +	/* If the device does ARP internally */
You mean "doesn't do ARP internally" right?

> +	if (!(dst->dev->flags & IFF_NOARP)) {
> +		const struct sockaddr_in *dst_in4 =
> +			(const struct sockaddr_in *)dst_in;
> +		const struct sockaddr_in6 *dst_in6 =
> +			(const struct sockaddr_in6 *)dst_in;
> +
> +		return dst_fetch_ha(dst, addr,
> +				    dst_in->sa_family == AF_INET ?
> +				    (const void *)&dst_in4->sin_addr.s_addr :
> +				    (const void *)&dst_in6->sin6_addr);
> +	}
> +
> +	return rdma_copy_addr(addr, dst->dev, NULL);
> +}

> +int rdma_resolve_ip_route(struct sockaddr *src_addr,
> +			  const struct sockaddr *dst_addr,
> +			  struct rdma_dev_addr *addr)
> +{
> +	struct sockaddr_storage ssrc_addr;
> +	struct sockaddr *src_in = (struct sockaddr *)&ssrc_addr;
> +
> +	if (src_addr->sa_family != dst_addr->sa_family)
> +		return -EINVAL;
> +
> +	if (src_addr)
> +		memcpy(src_in, src_addr, rdma_addr_size(src_addr));
> +	else
> +		src_in->sa_family = dst_addr->sa_family;
Don't you need to clear the rest of src_in? I believe you pass
uninitialized memory to it.

> +
> +	return addr_resolve(src_in, dst_addr, addr, false);
> +}
> +EXPORT_SYMBOL(rdma_resolve_ip_route);

Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
