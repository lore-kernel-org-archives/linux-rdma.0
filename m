From: "Liran Liss" <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: RDMAoE verbs questions
Date: Thu, 3 Dec 2009 20:26:52 +0200
Message-ID: <2ED289D4E09FBD4D92D911E869B97FDD01DB3EB0@mtlexch01.mtl.com>
References: <F57121538EA0C94F86018DDD40ADA1D101A4E9A6@mtiexch01.mti.com> <2ED289D4E09FBD4D92D911E869B97FDD01CBE494@mtlexch01.mtl.com> <2ED289D4E09FBD4D92D911E869B97FDD01D0D6F9@mtlexch01.mtl.com> <20091201174604.GO1966@obsidianresearch.com> <2ED289D4E09FBD4D92D911E869B97FDD01D647E2@mtlexch01.mtl.com> <20091202173314.GP1966@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <20091202173314.GP1966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Existing apps rely on transport_type == IBV_TRANSPORT_IB to indicate
IB management is present. There are many examples of this.
> The art of API compatability is to not break existing old apps, so you
don't get to change the meaning of transport_type == IBV_TRANSPORT_IB to
mean 'it is only IB verbs like'. That breaks the API.
> Adding a new field to port_attr preserves functionality but not
compatability. I hope you understand the difference.

I understand exactly what you mean, but I want to propose another way of
looking at the compatibility issue:

IB management is a network service. Just as an administrator might
mistakenly try to access an FTP server over a wrong eth interface, an IB
admin can mistakenly run an IB management application (or a non-rdmacm
app that is incompatible with RDMAoE) on a RDMAoE port. In both cases,
the service is unreachable, but otherwise no harm is done.
Basically, IB management is "supported" by RDMAoE --- you use the same
verbs to access it but you don't get any answers...
(Of course that it terms of implementation, we can choose to drop SMPs
or non-CM MADs rather then sending them on the wire.)

There is a tradeoff here between transparently supporting existing
rdmacm apps versus making sure that non-rdmacm apps that may come across
an RDMAoE port do not attempt to use it. 
Given the fact that rdmacm has become a preferred approach, and that for
non-rdmacm apps the worst case effect is that of being unable to create
a connection through a port that they were not designed to support to
begin with, we prefer the approach that we proposed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
