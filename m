From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: QoS in local SA entity
Date: Tue, 10 Nov 2009 07:51:06 +0200
Message-ID: <4AF8FF4A.6060407@voltaire.com>
References: <4AF2C00A.4040808@voltaire.com>	<9BF1CEFA7F6F44F5B5641065C4914EB5@amr.corp.intel.com>	<4AF66473.2050303@voltaire.com> <20091109005607.GV1966@obsidianresearch.com>	<4AF7C85F.5000604@voltaire.com> <20091109080812.GX1966@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091109080812.GX1966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> The extra info in rdma_resolve_addr2 carries the IB specific path information from the rdma_getaddrinfo module to the kernel for the address pair. The entire purpose of AF_IB is to let user space tell the kernel it does not want a kernel side ND and PR query, instead user space will provide all the information.
The kernel patches posted by Sean replace the ND/PR flow with a two 
steps process, first specifying a DGID to the kernel next specifying a 
PATH. My suggestion is to have a librdmacm initiated bind before the 
sending the DGID to the kernel, this way AF_INET would be supported 
perfectly under the slight limitation that the source address <device, 
port, pkey> tuple would be chosen by route lookup and not by the 
neigh->dev that what resolved by the kernel ND. This is only when the 
modified flow of librdmacm is taken (e.g under user specification with 
environment variable etc).

--If-- on top of that you want to add AF_IB, we may be able to do that, 
but I don't see why the whole thing should be made for AF_IB only.

> Think of it this way, ACM takes over the entire process of what AF_INET does in the kernel. AF_INET talks directly to the IB CM module in the kernel. Thus, it also makes sense that ACM would need to talk to IB CM directly as well. AF_IB is that direct connection.

I don't agree we must state it this way. I see ACM as an alternative way 
for AF_INET to resolve ND/PR.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
