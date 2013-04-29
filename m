From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 for-next 1/5] IB/core: Add RSS and TSS QP groups -
 suggesting BOF during OFA conf to further discuss that
Date: Mon, 29 Apr 2013 14:36:53 -0600
Message-ID: <20130429203653.GA25804@obsidianresearch.com>
References: <CAJZOPZLVyYODJ=z6KDfx0UJtaHpA7nUt2kwadEugpV1LWxhEMw@mail.gmail.com>
 <CAJZOPZKwH66uEukqDSvV+4-z+RhroOB1a0AiWBvdq7D3mso7gQ@mail.gmail.com>
 <CAJZOPZL1eminwg+MVAC+8y4Pg3Nff=aeMN9ic57SB3cRAg8Hnw@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A823736FD1E64F@ORSMSX109.amr.corp.intel.com>
 <20130425201255.GB31863@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A823736FD1EF16@ORSMSX109.amr.corp.intel.com>
 <20130425204357.GD31863@obsidianresearch.com>
 <CAJZOPZK8hcfm2OCnsJkhCiRNxOFXOB0xc9i7tmB4qEnkXrXC0Q@mail.gmail.com>
 <20130425214058.GF31863@obsidianresearch.com>
 <CAJZOPZLMtoxYyQO24F5_2Gr7ye0AFPQ5aZHp4dZFu1LQFK_cYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJZOPZLMtoxYyQO24F5_2Gr7ye0AFPQ5aZHp4dZFu1LQFK_cYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org \"Shlomo Pongratz\"" <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2013 at 10:52:21PM +0300, Or Gerlitz wrote:
> On Fri, Apr 26, 2013 at 12:40 AM, Jason Gunthorpe wrote:
> > But I don't follow why the send QPNs have to be sequential for
> > IPoIB. It looks like this is being motivated by RSS and RSS QPNs are
> > just being reused for TSS?
> 
> Go read "It turns out that there are IPoIB drivers used by some
> operating-systems
> and/or Hypervisors in a para-virtualization (PV) scheme which extract the
> source QPN from the CQ WC associated with an incoming packets in order
> to.." and what follows in the change-log of patch 4/5
> http://marc.info/?l=linux-rdma&m=136412901621797&w=2

This is what I said in the first place, the RFC is premised on the
src.QPN to be set properly, you can't just mess with it, because stuff
needs it.

I think you should have split this patch up, there is lots going on
here.

- Add proper TSS that doesn't change the wire protocol
- Add fake TSS that does change the wire protocol, and
  properly document those changes so other people can
  follow/implement them
- Add RSS

And.. 'tss_qpn_mask_sz' seems unnecessarily limiting, using
 WC.srcQPN + ipoib_header.tss_qpn_offset == real QPN
 (ie use a signed offset, not a mask)
Seems much better than
 Wc.srcQPN & ~((1<<(ipoib_header.tss_qpn_mask_sz >> 12))-1) == real QPN
 (Did I even get that right?)

Specifically it means the requirements for alignment and
contiguous-ness are gone. This means you can implement it without
using the QP groups API and it will work immediately with every HCA
out there. I think if we are going to actually mess with the wire
protocol this sort of broad applicability is important.

As for the other two questions: seems reasonable to me. Without a
consensus among HW vendors how to do this it makes sense to move ahead
*in the kernel* with a minimal API. Userspace is a different question
of course..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
