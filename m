From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ewg] rping is not resolving ipv6 addresses
Date: Mon, 12 Oct 2009 10:52:59 -0700
Message-ID: <1255369979.29677.7.camel@wilder.ibm.com>
References: <1254957121.23471.17.camel@wilder.ibm.com>
	 <adavdiqn63u.fsf@cisco.com> <1255114672.3533.8.camel@wilder.ibm.com>
	 <15ddcffd0910091353w51bddc60w8452ca107de296fb@mail.gmail.com>
	 <1255122901.3533.20.camel@wilder.ibm.com>
	 <20091009224604.GG5191@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091009224604.GG5191-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, linux-rdma <linux-rdm>
List-Id: linux-rdma@vger.kernel.org


On Fri, 2009-10-09 at 16:46 -0600, Jason Gunthorpe wrote:
> On Fri, Oct 09, 2009 at 02:15:01PM -0700, David J. Wilder wrote:
> 
> > Yes ping6 will work but I must specify the interface to use:
> > ping6 fe80::202:c903:1:1925%ib0
> > 
> > Here is the patch to rping to allow the source address to be specified.
> > I am not sure this is the correct approach to fix this.
> 
> It is not, IPv6 link local addresses must be scoped. rping is
> parsing the address with getaddrinfo, that does correctly set the
> sin6_scope_id value in the sockaddr.

ping6 is scoping the address (setting sin6_scope_id) by hand. So rping
should do the same thing.

> 
> rdma_resolve_addr (and likely the underlying kernel component) must
> respect this when dealing with link local scope addresses.
> 
> rmda_resolve_addr should fail if a link local IPv6 address is provided
> without scope, like the normal IP stack:
> 
> connect(3, {sa_family=AF_INET6, sin6_port=htons(1025), inet_pton(AF_INET6, "fe80::202:c903:1:1925", &sin6_addr), sin6_flowinfo=0, sin6_scope_id=0}, 28) = -1 EINVAL (Invalid argument)
> 
> So this is two bugs in the rdma cm, rping is correct as is..

It may be correct, but not functional with link-local address.

> 
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
