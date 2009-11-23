From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 9/9] ib/addr: fix ipv6 routing lookup
Date: Mon, 23 Nov 2009 12:48:47 -0700
Message-ID: <20091123194847.GL6188@obsidianresearch.com>
References: <2449CF17D7E94FCBA643A743473246A5@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2449CF17D7E94FCBA643A743473246A5-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 16, 2009 at 04:12:07PM -0800, Sean Hefty wrote:

> +static int cma_check_linklocal(struct rdma_dev_addr *dev_addr,
> +			       struct sockaddr *addr)
> +{
> +	struct sockaddr_in6 *sin6;
> +
> +	if (addr->sa_family != AF_INET6)
> +		return 0;
> +
> +	sin6 = (struct sockaddr_in6 *) addr;
> +	if ((ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL) &&
> +	    !sin6->sin6_scope_id)
> +			return -EINVAL;
> +
> +	dev_addr->bound_dev_if = sin6->sin6_scope_id;
> +	return 0;
> +}

There is something missing here to match the TCP sin6_scope_id
semantics..

I think what you have is OK for the non-error cases, but the
rdma_resolve_addr path does need to check that an input sin6_scope_id
is either 0 or matches bound_dev_if and return EINVAL.

My approach was to use this:
static int check_ip6_ll(struct rdma_dev_addr *dev_addr,
                        const struct sockaddr *addr)
{
        const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6 *)addr;

        if (addr->sa_family != AF_INET6)
                return 0;

        if (ipv6_addr_type(&addr6->sin6_addr) & IPV6_ADDR_LINKLOCAL) {
                if (dev_addr->bound_dev_if &&
                    dev_addr->bound_dev_if != addr6->sin6_scope_id)
                        return -EINVAL;
                dev_addr->bound_dev_if = addr6->sin6_scope_id;
                if (!dev_addr->bound_dev_if)
                        return -EINVAL;
        }
        return 0;
}

On all 3 addresess, I copied the algorithm from the TCP stack.

The main missing test from the new version is:
                if (dev_addr->bound_dev_if &&
                    dev_addr->bound_dev_if != addr6->sin6_scope_id)
                        return -EINVAL;

Done on the 2nd src and dest address.

Any thoughts on how to fit that in?

Were you able to check the dst/neighbour stuff at all?

Otherwise it looks great to me, thanks for doing this.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
