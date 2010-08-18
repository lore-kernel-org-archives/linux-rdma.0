From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: using same IP subnet on multiple interfaces
Date: Wed, 18 Aug 2010 09:02:50 +0300
Message-ID: <4C6B778A.4070000@voltaire.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A9687B2B@orsmsx501.amr.corp.intel.com>	<4C679C39.8060709@Voltaire.com> <20100815165946.GA2861@obsidianresearch.com>	<4C69597C.2040008@Voltaire.com> <20100817031945.GA5251@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100817031945.GA5251-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
>> As for the original issue we were discussing here, the conclusion is that with upstream 2.6.35 bits for the rdma connection to go from hca1 port1 to hca1 port2 (or from hca1 port1 to hca2 port1), the rdma-cm needs a neighbour, similarly to a ping -I ib0 to ib1 address. A neighbour isn't created unless the responding NIC (ib1 in my example) has both rp_filter set to 0 and accept_local set to 1,
>> does this makes sense?
> This description seemed reasonable to me. It is pretty confusing what binding means in RDMA CM, it is different then sockets, and is some combination of SO_BINDTODEVICE and bind to address.
I was thinking that one of the things taken care by the patch set to 
addr.c/cma.c you, David and Sean did last year was to make binding in 
rdma-cm to be bind to address by-the-book, in what aspect it is 
different now?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
