From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 9/9] ib/addr: fix ipv6 routing lookup
Date: Mon, 23 Nov 2009 15:26:52 -0700
Message-ID: <20091123222652.GM6188@obsidianresearch.com>
References: <2449CF17D7E94FCBA643A743473246A5@amr.corp.intel.com> <20091123194847.GL6188@obsidianresearch.com> <913F7AE25239487A9AF368E608F30A34@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <913F7AE25239487A9AF368E608F30A34-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2009 at 02:07:09PM -0800, Sean Hefty wrote:

> >The main missing test from the new version is:
> >                if (dev_addr->bound_dev_if &&
> >                    dev_addr->bound_dev_if != addr6->sin6_scope_id)
> >                        return -EINVAL;
> >
> >Done on the 2nd src and dest address.
> >
> >Any thoughts on how to fit that in?
> 
> A separate check can be added to rdma_resolve_addr if it's really
> needed, but I'm not sure that we need to require that the source and
> destination use the same device or RDMA port.

We do need to check this only for IPv6 link local addresses, that is
what TCP does. The reason is that the LL addresses are not unique, so
it is impossible to reach a LL on a different interface than the
socket is bound to.

All other cases can use any IP/IPv6 address assigned to any interface with
any bound device (the Linux IP is associated with the host, not the
NIC, model).

Actually, upon looking closer, there is another little thing:

2083 static int cma_check_linklocal(struct rdma_dev_addr *dev_addr,
2084                                struct sockaddr *addr)
2085 {
2086 #if defined(CONFIG_IPv6) || defined(CONFIG_IPV6_MODULE)
2087         struct sockaddr_in6 *sin6;
2088
2089         if (addr->sa_family != AF_INET6)
2090                 return 0;
2091
2092         sin6 = (struct sockaddr_in6 *) addr;
2093         if ((ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL) &&
2094             !sin6->sin6_scope_id)
2095                         return -EINVAL;
2096
2097         dev_addr->bound_dev_if = sin6->sin6_scope_id;

The sin6_scope_id must be ignored in all cases except LL
addresses. Fixing this will break the path that sets the bound_dev_if
starting from rdma_resolve_addr. This is why my version was setting
bound_dev_if directly in rdma_resolve_addr.

Did you change it to be like this because you found something wrong
with the way things were in my big patch?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
