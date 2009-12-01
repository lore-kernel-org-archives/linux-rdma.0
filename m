From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: RDMAoE verbs questions
Date: Tue, 1 Dec 2009 08:27:16 -0800
Message-ID: <44B4931AF8354AF3BABCCA052150D2BA@amr.corp.intel.com>
References: <F57121538EA0C94F86018DDD40ADA1D101A4E9A6@mtiexch01.mti.com> <2ED289D4E09FBD4D92D911E869B97FDD01CBE494@mtlexch01.mtl.com> <2ED289D4E09FBD4D92D911E869B97FDD01D0D6F9@mtlexch01.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2ED289D4E09FBD4D92D911E869B97FDD01D0D6F9-ia22CT07NJfiMCgWhms8HQC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Liran Liss' <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>RDMAoE *is* IB transport over Ethernet

RDMAoE carries something that looks a lot like IB L3 or an IPv6 header, so it
isn't exactly IB transport over Ethernet.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
