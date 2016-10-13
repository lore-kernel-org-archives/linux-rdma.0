From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next 00/10] Hardware tag matching support
Date: Thu, 13 Oct 2016 21:23:46 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB095A90@ORSMSX109.amr.corp.intel.com>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
 <20161007145620.GV9282@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB093986@ORSMSX109.amr.corp.intel.com>
 <6259953b-27fe-77c9-ea90-af744f188671@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373AB095429@ORSMSX109.amr.corp.intel.com>
 <20161013170641.GA9094@infradead.org>
 <1828884A29C6694DAF28B7E6B8A82373AB095647@ORSMSX109.amr.corp.intel.com>
 <20161013195605.GA8077@obsidianresearch.com>
 <20161013200208.GA8998@infradead.org>
 <a3495685-69c7-26a7-ba97-9761848535a8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a3495685-69c7-26a7-ba97-9761848535a8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I think there are some fundamental questions here about what this is.
> As I understand it (and Mellanox can chime in if I'm wrong), tag
> matching already exists on the wire, it's just implemented above the
> level of the link layer transmissions.  This enables a hardware
> accelerator for something that is already done at an upper layer, so
> the
> implementation is mostly defined by the defacto existing use in upper
> layer applications, not by the IBTA.  I believe this could roughly be

MPIs definitely make use of this sort of protocol, but it is an application level protocol that is non-standard, even between MPI implementations.  There's no interoperability between them.

The Intel truescale and OPA implementations support tag matching, with HW offload support, but those too are proprietary (i.e. PSM).  In the case of PSM, I believe the tag matching is part of the transport protocol.  There's a decent chance the Mellanox implementation is the same.

> considered analogous to a network driver enabling a layer3 or layer4
> accelerator.  It's not a layer1 thing, so the IBTA is not appropriate
> to
> review it.

The IBTA defines layer1-4, plus the verbs interfaces.  So, it _could_ be an IBTA issue.  However, the IBTA allows for vendor specific features (e.g. PSM), so it could be a vendor feature.

IMO, this is a feature worth supporting.  My concern is over how it is exposed.  There's a lot of variety in how tag matching can be implemented.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
