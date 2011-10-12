From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Building 3.1-rc9 in kernel infiniband support with OFED
 libraries
Date: Wed, 12 Oct 2011 16:37:04 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E6A98C@ORSMSX101.amr.corp.intel.com>
References: <alpine.DEB.2.00.1110110900290.3388@router.home>
 <20111011173929.GH26965@obsidianresearch.com>
 <CAO+b5-pxyc0LpGQ4kkOXJVi7cgYm_cgyJ0qM-m81=fZ+MGXHwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pxyc0LpGQ4kkOXJVi7cgYm_cgyJ0qM-m81=fZ+MGXHwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Why is the OFED libibverbs library binary incompatible with the
> non-OFED libibverbs library ? Why hasn't XRC support been implemented
> in the OFED libibverbs library such that applications built against
> the upstream libibverbs headers also work with the latest OFED version
> of that library ?

The original XRC patches were submitted upstream, but were never accepted.  Along with those patches were modifications to ibverbs.  Those changes broke existing applications and were also never accepted upstream.  However, OFED still provided a release based on that code.  This is only a guess, but the push to release may have been a time to market decision.  (I'm just trying to relay history here.)

I have since re-worked both the kernel and user space XRC patches and submitted them for inclusion upstream.  Those patches do maintain backwards compatibility.  I believe that OFA is waiting for those patches (or some deviation) to be accepted upstream.  OFED will then be rebased on those patches, released as 2.0, with a stronger attempt made to keep everything in sync.

Hopefully XRC can make it into the 3.2 kernel.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
