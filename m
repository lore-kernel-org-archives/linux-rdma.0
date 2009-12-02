From: "Liran Liss" <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: RDMAoE verbs questions
Date: Wed, 2 Dec 2009 12:38:31 +0200
Message-ID: <2ED289D4E09FBD4D92D911E869B97FDD01D647E2@mtlexch01.mtl.com>
References: <F57121538EA0C94F86018DDD40ADA1D101A4E9A6@mtiexch01.mti.com> <2ED289D4E09FBD4D92D911E869B97FDD01CBE494@mtlexch01.mtl.com> <2ED289D4E09FBD4D92D911E869B97FDD01D0D6F9@mtlexch01.mtl.com> <20091201174604.GO1966@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <20091201174604.GO1966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> So? There are substantial semantic differences for *all* non-rdmacm
applications. Even common ones like OpenMPI. You propose to ignore them?

On the contrary! Any application that *does* care what the link layer is
can look up a new field in port_attr (rather than a new node transport
type).
Applications that don't, both old and new, can continue as normal - no
changes to the code are required.

>> RDMAoE *is* IB transport over Ethernet - we don't want different 
>> devices with different node types exactly for this reason: 
>> applications shouldn't care if they are running over IB or RDMAoE,
and 
>> shouldn't add another switch statement to support RDMAoE.

> Nonsense. RDMAoE is no such thing, it is utterly incompatible with the
IB management model. It is some new protocol that is only about 90%
compatible with IB.

You are missing the point here - RDMAoE is 100% compatible with IB at
the *transport* level, as reflected by the Verbs.
The point that the management model is different is true, but
irrelevant. The only transport-related issue that matters is addressing,
but for user-space apps, it is completely abstracted by the rdmacm.

Non-rdmacm apps fall into 2 main categories:
1. IB management+diagnostics apps - these are irrelevant for an Eth
network anyway.
2. High-performance middleware such as MPI and SHMEM - these perform
optimizations according to the link protocol anyway.

So, all relevant apps will work great with either IB or RDMAoE, in a
transparent manner.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
