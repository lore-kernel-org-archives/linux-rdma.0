From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ewg] rdma/cm: revert associating an RDMA device when binding
	to loopback
Date: Tue, 9 Feb 2010 15:17:04 -0700
Message-ID: <20100209221704.GY16490@obsidianresearch.com>
References: <4B718A2C.2030602@linux.vnet.ibm.com> <4FA7F42E-308A-4A4D-82D8-87794CB8C4DE@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FA7F42E-308A-4A4D-82D8-87794CB8C4DE-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 09, 2010 at 05:01:21PM -0500, Jeff Squyres wrote:

> 1. Is this now the recommended way to find all the IP interfaces that support RDMA:
> 
> - loop over all local IP addresses
> - if 127.0.0.1/8, skip
> - try to rdma_bind_addr()
> - if it succeeds and verbs ptr is != NULL, it's an RDMA device

RDMA is not special, it is just like any other IP service. RDMA is
supported on loopback.

To find the list of RMDA capable IPs you do the rdma_bind_addr test.

You then have to transform that list exactly as you would for TCP to
get a list of candidate addresses that could be used for remote
connection. This means removing loopback, doing someting about link
local addresses, and matching as necessary IPs to interfaces, to
networks, and to source IPs on the connecting side. It isn't trivial,
but it is exactly the same as for TCP. I suppose ideally OMPI would
use the same codes for both TCP and RDMACM - and it should have user
configurables!

It is worth reviewing what the OMPI TCP does and at least checking
that the RDMACM hits all the same points.

> 2. Before Sean backed out the localhost behavior, when you
> rdma_addr_bind(127.0.0.1), what did the id->verbs pointer
> correspond to?

One of the RDMA verbs devices in the system. The API does not define
which one the kernel will select.

I think the current patches simply picked the first one.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
