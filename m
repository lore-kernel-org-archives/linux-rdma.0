From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH 1/2] rdma/cm: fix handling of ipv6 addressing in
 cma_use_port
Date: Tue, 10 May 2011 14:30:20 -0700
Message-ID: <20110510143020.7e6d3d4e.weiny2@llnl.gov>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCC49B2B@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCC49B2B-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 15 Apr 2011 23:42:48 -0700
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> cma_use_port is coded assuming that the sockaddr is an ipv4 address.
> Since ipv6 addressing is supported, and also to support other address
> families, make the code more generic in its address handling.
> 
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>

> ---
> This patch was originally submitted as patch 2 of the AF_IB patch set;
> however, it will also be used by the REUSEADDR support for patch 2/2.
> 
>  drivers/infiniband/core/cma.c |   29 ++++++++++++++++++++++-------
>  1 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index 6884da2..a1b1e27 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -708,6 +708,21 @@ static inline int cma_any_addr(struct sockaddr *addr)
>  	return cma_zero_addr(addr) || cma_loopback_addr(addr);
>  }
>  
> +static int cma_addr_cmp(struct sockaddr *src, struct sockaddr *dst)
> +{
> +	if (src->sa_family != dst->sa_family)
> +		return -1;
> +
> +	switch (src->sa_family) {
> +	case AF_INET:
> +		return ((struct sockaddr_in *) src)->sin_addr.s_addr !=
> +		       ((struct sockaddr_in *) dst)->sin_addr.s_addr;
> +	default:
> +		return ipv6_addr_cmp(&((struct sockaddr_in6 *) src)->sin6_addr,
> +				     &((struct sockaddr_in6 *) dst)->sin6_addr);
> +	}
> +}
> +
>  static inline __be16 cma_port(struct sockaddr *addr)
>  {
>  	if (addr->sa_family == AF_INET)
> @@ -2159,13 +2174,13 @@ retry:
>  static int cma_use_port(struct idr *ps, struct rdma_id_private *id_priv)
>  {
>  	struct rdma_id_private *cur_id;
> -	struct sockaddr_in *sin, *cur_sin;
> +	struct sockaddr *addr, *cur_addr;
>  	struct rdma_bind_list *bind_list;
>  	struct hlist_node *node;
>  	unsigned short snum;
>  
> -	sin = (struct sockaddr_in *) &id_priv->id.route.addr.src_addr;
> -	snum = ntohs(sin->sin_port);
> +	addr = (struct sockaddr *) &id_priv->id.route.addr.src_addr;
> +	snum = ntohs(cma_port(addr));
>  	if (snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
>  		return -EACCES;
>  
> @@ -2177,15 +2192,15 @@ static int cma_use_port(struct idr *ps, struct rdma_id_private *id_priv)
>  	 * We don't support binding to any address if anyone is bound to
>  	 * a specific address on the same port.
>  	 */
> -	if (cma_any_addr((struct sockaddr *) &id_priv->id.route.addr.src_addr))
> +	if (cma_any_addr(addr))
>  		return -EADDRNOTAVAIL;
>  
>  	hlist_for_each_entry(cur_id, node, &bind_list->owners, node) {
> -		if (cma_any_addr((struct sockaddr *) &cur_id->id.route.addr.src_addr))
> +		cur_addr = (struct sockaddr *) &cur_id->id.route.addr.src_addr;
> +		if (cma_any_addr(cur_addr))
>  			return -EADDRNOTAVAIL;
>  
> -		cur_sin = (struct sockaddr_in *) &cur_id->id.route.addr.src_addr;
> -		if (sin->sin_addr.s_addr == cur_sin->sin_addr.s_addr)
> +		if (!cma_addr_cmp(addr, cur_addr))
>  			return -EADDRINUSE;
>  	}
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
