From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: QoS in local SA entity
Date: Mon, 09 Nov 2009 09:44:31 +0200
Message-ID: <4AF7C85F.5000604@voltaire.com>
References: <4AF2C00A.4040808@voltaire.com>	<9BF1CEFA7F6F44F5B5641065C4914EB5@amr.corp.intel.com>	<4AF66473.2050303@voltaire.com> <20091109005607.GV1966@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091109005607.GV1966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> The entire point of the rdma_getaddrinfo + AF_IB is to avoid hacking up librdmacm for every address lookup/cache scheme someone invents
the entire simple point I am trying to make is that rdma_getaddrinfo + 
AF_INET is doable, is simple and is needed to keep up the essence of the 
rdma-cm. I don't see how AF_IB buys anything to anyone that but if you 
want to push it up as long as AF_INET is first and most 
supported/interoperable future/present go and add your bits. As you 
indicated the route lookup I was mentioning could be done in 
rdma_addrinfo, sure with  &res including both source and destination 
addresses. No rdma_resolve_addr2 is needed the one that exists now has  
source addresses specified, I  don't see that extra info is needed for 
AF_INET that was resolved with rdma_getaddrinfo is this AF_IB specific?

I don't see why the app should bother on calling rdma_getaddrinfo, it 
can be done by librdmacm with rdma_getaddrinfo having multiple modules 
as you suggested. I am in favor of the approach suggested by Sean of 
librdmacm either doing its native flow or under environment variable 
doing an alternative flow, where your suggestion not to have the 2nd 
flow being tightly coupled with ACM, e.g through using get_addrinfo 
abstraction and friends makes sense (yes!)

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
