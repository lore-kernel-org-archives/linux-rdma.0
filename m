From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: QoS in local SA entity
Date: Mon, 9 Nov 2009 01:08:12 -0700
Message-ID: <20091109080812.GX1966@obsidianresearch.com>
References: <4AF2C00A.4040808@voltaire.com> <9BF1CEFA7F6F44F5B5641065C4914EB5@amr.corp.intel.com> <4AF66473.2050303@voltaire.com> <20091109005607.GV1966@obsidianresearch.com> <4AF7C85F.5000604@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AF7C85F.5000604-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 09, 2009 at 09:44:31AM +0200, Or Gerlitz wrote:

>  No rdma_resolve_addr2 is needed the one that exists now has  
> source addresses specified, I  don't see that extra info is needed for 
> AF_INET that was resolved with rdma_getaddrinfo is this AF_IB specific?

The extra info in rdma_resolve_addr2 carries the IB specific path
information from the rdma_getaddrinfo module to the kernel for the
address pair. Then entire purpose of AF_IB is to let user space tell
the kernel it does not want a kernel side ND and PR query, instead
user space will provide all the information.

Think of it this way, ACM takes over the entire process of what
AF_INET does in the kernel. AF_INET talks directly to the IB CM module
in the kernel. Thus, it also makes sense that ACM would need to talk to
IB CM directly as well. AF_IB is that direct connection.

> I don't see why the app should bother on calling rdma_getaddrinfo, it 
> can be done by librdmacm with rdma_getaddrinfo having multiple modules 
> as you suggested. I am in favor of the approach suggested by Sean of 
> librdmacm either doing its native flow or under environment variable 
> doing an alternative flow, where your suggestion not to have the 2nd 
> flow being tightly coupled with ACM, e.g through using get_addrinfo 
> abstraction and friends makes sense (yes!)

I don't entirely understand this paragraph, but the point of a string
based rdma_getaddrinfo is exactly the same point as for IP - strings
may have different meaning and may encode richer information than a
simple sock addr (eg normal getaddrinfo can determine AF_INET,
AF_INET6, and AF_UNIX depending on the form of the string).

For instance it might make sense to trigger/disable the ACM method
with a special string based indicator.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
