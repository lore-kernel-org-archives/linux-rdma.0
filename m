From: "Liran Liss" <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: RDMAoE verbs questions
Date: Tue, 1 Dec 2009 18:22:06 +0200
Message-ID: <2ED289D4E09FBD4D92D911E869B97FDD01D0D6F9@mtlexch01.mtl.com>
References: <F57121538EA0C94F86018DDD40ADA1D101A4E9A6@mtiexch01.mti.com> <2ED289D4E09FBD4D92D911E869B97FDD01CBE494@mtlexch01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <2ED289D4E09FBD4D92D911E869B97FDD01CBE494-ia22CT07NJfiMCgWhms8HQC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Dealing with ABI compatability is a different issue, this new scheme
is API incompatible due to the change in semantics for existing values.

For rdmacm applications, there are no semantic changes between IB and
RDMAoE.

> Please look at my message regarding using multiple devices, perhaps
you can improve on that general idea.

RDMAoE *is* IB transport over Ethernet - we don't want different devices
with different node types exactly for this reason: applications
shouldn't care if they are running over IB or RDMAoE, and shouldn't add
another switch statement to support RDMAoE.
In addiiton, any existing rdmacm app can work transparently over RDMAoE
without recompilation or relinking.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
