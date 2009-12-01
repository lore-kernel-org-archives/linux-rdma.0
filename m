From: "Liran Liss" <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: RDMAoE verbs questions
Date: Tue, 1 Dec 2009 19:00:15 +0200
Message-ID: <2ED289D4E09FBD4D92D911E869B97FDD01D0D792@mtlexch01.mtl.com>
References: <F57121538EA0C94F86018DDD40ADA1D101A4E9A6@mtiexch01.mti.com> <2ED289D4E09FBD4D92D911E869B97FDD01CBE494@mtlexch01.mtl.com> <2ED289D4E09FBD4D92D911E869B97FDD01D0D6F9@mtlexch01.mtl.com> <44B4931AF8354AF3BABCCA052150D2BA@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <44B4931AF8354AF3BABCCA052150D2BA-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The issue is that from an rdmacm app's point of view - there is no
visible difference between IB and RDMAoE ports: both support the
complete set of Verbs, just as any IB transport provider.
Therefore, both ports should reside on a node with an IB transport type.

-----Original Message-----
From: Sean Hefty [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Tuesday, December 01, 2009 6:27 PM
To: Liran Liss; Jason Gunthorpe
Cc: Eli Cohen; Jeff Squyres; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: RDMAoE verbs questions

>RDMAoE *is* IB transport over Ethernet

RDMAoE carries something that looks a lot like IB L3 or an IPv6 header,
so it isn't exactly IB transport over Ethernet.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
