From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ewg] rping is not resolving ipv6 addresses
Date: Mon, 12 Oct 2009 13:47:58 -0600
Message-ID: <20091012194758.GB20313@obsidianresearch.com>
References: <1254957121.23471.17.camel@wilder.ibm.com> <adavdiqn63u.fsf@cisco.com> <1255114672.3533.8.camel@wilder.ibm.com> <15ddcffd0910091353w51bddc60w8452ca107de296fb@mail.gmail.com> <1255122901.3533.20.camel@wilder.ibm.com> <20091009224604.GG5191@obsidianresearch.com> <1255369979.29677.7.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1255369979.29677.7.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 12, 2009 at 10:52:59AM -0700, David J. Wilder wrote:

> > It is not, IPv6 link local addresses must be scoped. rping is
> > parsing the address with getaddrinfo, that does correctly set the
> > sin6_scope_id value in the sockaddr.
> 
> ping6 is scoping the address (setting sin6_scope_id) by hand. So rping
> should do the same thing.

getaddrinfo already sets sin6_scope_id. Newish iputils ping6 also uses
getaddrinfo and doesn't touch the sin6_scope_id except in some
specialized cases.

> > So this is two bugs in the rdma cm, rping is correct as is..
> 
> It may be correct, but not functional with link-local address.

Like I said, the RDMA CM kernel component has the bugs, not rping..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
