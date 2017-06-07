From: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/addr: Fix setting source address in addr6_resolve()
Date: Wed, 07 Jun 2017 14:57:17 +0200
Message-ID: <1496840237.2409.14.camel@redhat.com>
References: <20170606162200.24629-1-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170606162200.24629-1-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-06-06 at 09:22 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> 
> Commit eea40b8f624f ("infiniband: call ipv6 route lookup via the stub
> interface") introduced a regression in address resolution when connecting
> to IPv6 destination addresses.  The old code called ip6_route_output(),
> while the new code calls ipv6_stub->ipv6_dst_lookup().  The two are almost
> the same, except that ipv6_dst_lookup() also calls ip6_route_get_saddr()
> if the source address is in6addr_any.
> 
> This means that the test of ipv6_addr_any(&fl6.saddr) now never succeeds,
> and so we never copy the source address out.  This ends up causing
> rdma_resolve_addr() to fail, because without a resolved source address,
> cma_acquire_dev() will fail to find an RDMA device to use.  For me, this
> causes connecting to an NVMe over Fabrics target via RoCE / IPv6 to fail.
> 
> Fix this by copying out fl6.saddr if ipv6_addr_any() is true for the original
> source address passed into addr6_resolve().  We can drop our call to
> ipv6_dev_get_saddr() because ipv6_dst_lookup() already does that work.
> 
> Fixes: eea40b8f624 ("infiniband: call ipv6 route lookup via the stub interface")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.12+
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> ---
>  drivers/infiniband/core/addr.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
> index 02971e239a18..ece6926fa2e6 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -449,12 +449,7 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
>  		return ret;
>  
>  	rt = (struct rt6_info *)dst;
> -	if (ipv6_addr_any(&fl6.saddr)) {
> -		ret = ipv6_dev_get_saddr(addr->net, ip6_dst_idev(dst)->dev,
> -					 &fl6.daddr, 0, &fl6.saddr);
> -		if (ret)
> -			goto put;
> -
> +	if (ipv6_addr_any(&src_in->sin6_addr)) {
>  		src_in->sin6_family = AF_INET6;
>  		src_in->sin6_addr = fl6.saddr;
>  	}
> @@ -471,9 +466,6 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
>  
>  	*pdst = dst;
>  	return 0;
> -put:
> -	dst_release(dst);
> -	return ret;
>  }
>  #else
>  static int addr6_resolve(struct sockaddr_in6 *src_in,

LGTM, thank you for fixing this!

Acked-by: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
