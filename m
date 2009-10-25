From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] rdma/cm: allow user to specify IP to DGID mapping
Date: Sun, 25 Oct 2009 13:25:21 +0200
Message-ID: <4AE435A1.6040309@voltaire.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com>		<F451C333D8CB45E4B4642C6BD1EDD3C3@amr.corp.intel.com>		<4ACAF913.3050909@voltaire.com>		<AA7E7C8FC2A04B9688CD69CEB7355DF8@amr.corp.intel.com>		<15ddcffd0910071523w4f229b14j905ad170ceb8c21f@mail.gmail.com>		<9F4DE6A2B4F644698E94F00C4FEEF30A@amr.corp.intel.com>		<0A383504E0E54C949DEF84405E3AE92F@amr.corp.intel.com>	<15ddcffd0910081633q20d98abfg41a9f4e781e486b1@mail.gmail.com>	<859D79BFCA4741F393AABF76BBCA4F7B@amr.corp.intel.com>	<4ADD8F5F.3010008@voltaire.com>	<9F76F7CD7B9048E8821A1B05CC5FAFE8@amr.corp.intel.com>	<4AE07D41.7040300@voltaire.com> <9574E625AB3C48E6A7DF1A2760882363@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9574E625AB3C48E6A7DF1A2760882363-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> These are the things done today in the kernel wrt IB:
> * Map a local or remote IP address to a GID
> * If a local address is not given, provide a usable address based on the destination address
> * Acquire a path between the source and destination
> * Format the first 36 bytes of private data in the CM REQ
> Any or all of these could be done in user space instead.  Adding AF_IB to the kernel can provide a clean way of enabling this.  It can also allow full support of IB CM functionality through the RDMA CM interfaces
Sean,

First, on top of what you have mentioned above, the kernel also 
generates the SID to connect to / listen on, maintains a "binding" 
(mapping) between an rdma-cm id to a netdevice which today is used for 
generating address change events, and maybe some more tasks which I 
neither of us brought. From what you write here I understand that the 
reasoning is something like:

1. we can do all this in user space
2. for that end AF_INET/PS_TCP flow has to be converted to AF_IB/PS_IB 
behind the cover

well, you didn't address some of my comments (not the ice-cream 
ones...), which come to say that this wouldn't be inter-operable if for 
one side you convert INET/TCP to IB/IB and for the other side you don't 
(e.g userA/userB user/kernel kernel/user etc schemes). Also the 
functionality added under the bonding scheme is lost, etc.

I am asking you to have INET/TCP apps enjoy both ACM's DGID and route 
resolution without being converted to IB/IB, simple as that. If needed 
I'd be happy to assist in making this flow happen.

The rdma-cm was born first and most to serve as a glue between the IP 
and RDMA worlds, and I just ask you, as the maintainer, to keep this 
well-going-glue happening also under ACM.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
