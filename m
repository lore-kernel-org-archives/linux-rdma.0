From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net] infiniband: avoid dereferencing uninitialized dst
 on error path
Date: Tue, 02 May 2017 11:25:23 -0400
Message-ID: <1493738723.3041.199.camel@redhat.com>
References: <18718a11bb9bc427da129949c5b3527902f9f9ff.1493732887.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <18718a11bb9bc427da129949c5b3527902f9f9ff.1493732887.git.pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sabrina Dubroca <sd-y1jBWg8GRStKuXlAQpz2QA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-05-02 at 16:03 +0200, Paolo Abeni wrote:
> With commit eea40b8f624f ("infiniband: call ipv6 route lookup
> via the stub interface"), if the route lookup fails due to
> ipv6 being disabled, the dst variable is left untouched, and
> the following dst_release() may access uninitialized memory.
> 
> Since ipv6_dst_lookup() always sets dst to NULL in case of
> lookup failure with ipv6 enabled, fix the above just
> returning the error code if the lookup fails.
> 
> Fixes: eea40b8f624 ("infiniband: call ipv6 route lookup via the stub
> interface")
> Reported-by: Sabrina Dubroca <sd-y1jBWg8GRStKuXlAQpz2QA@public.gmane.org>
> Signed-off-by: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Sabrina Dubroca <sd-y1jBWg8GRStKuXlAQpz2QA@public.gmane.org>
> ---
>  drivers/infiniband/core/addr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/addr.c
> b/drivers/infiniband/core/addr.c
> index 8fd108d..6c8411a 100644
> --- a/drivers/infiniband/core/addr.c
> +++ b/drivers/infiniband/core/addr.c
> @@ -446,7 +446,7 @@ static int addr6_resolve(struct sockaddr_in6
> *src_in,
>  
>  	ret = ipv6_stub->ipv6_dst_lookup(addr->net, NULL, &dst,
> &fl6);
>  	if (ret < 0)
> -		goto put;
> +		return ret;
>  
>  	rt = (struct rt6_info *)dst;
>  	if (ipv6_addr_any(&fl6.saddr)) {

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
