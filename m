From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 for-next 1/5] IB/core: Add RSS and TSS QP groups -
 suggesting BOF during OFA conf to further discuss that
Date: Thu, 25 Apr 2013 14:43:57 -0600
Message-ID: <20130425204357.GD31863@obsidianresearch.com>
References: <CAJZOPZLVyYODJ=z6KDfx0UJtaHpA7nUt2kwadEugpV1LWxhEMw@mail.gmail.com>
 <CAJZOPZKwH66uEukqDSvV+4-z+RhroOB1a0AiWBvdq7D3mso7gQ@mail.gmail.com>
 <CAJZOPZL1eminwg+MVAC+8y4Pg3Nff=aeMN9ic57SB3cRAg8Hnw@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A823736FD1E64F@ORSMSX109.amr.corp.intel.com>
 <20130425201255.GB31863@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A823736FD1EF16@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD1EF16-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org \"Shlomo Pongratz\"" <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 25, 2013 at 08:26:45PM +0000, Hefty, Sean wrote:
> > > Conceptually, RSS/TSS are a set of send/receive work queues all
> > > belonging to the same transport level address.  There's no
> > > parent-child relationship or needed pairing of send and receive
> > > queues together in order to form a group.
> > 
> > This view makes sense to me as well. Can someone also confirm that
> > using TSS doesn't affect the on-the-wire packets vs the non-TSS cases?
> > I heard a few comments that sounded like TSS users get a per-queue QPN
> > in the outgoing packet rather than a single QPN for the group, which
> > would be pretty ugly.
> 
> After speaking with Tzahi, my understanding is that the receive work
> queues all receive on the same QPN, but the send work queues use
> different QPNs.  The on-wire packets are affected, specifically the
> ipoib header.  This is why the send QPNs must be sequential, so that
> a mask can be applied at the receiving side to determine a single
> source QPN.

Ah, this seems contrary to the IPoIB specification? Someone should
probably talk about how sending from the wrong QPN is acceptable..

As I said, that is ugly. 'TSS' that changes the on-the-wire packet is
not TSS. It is just ganging QPs together.

Allocating sequential TSS QPNs is an awful hack, what we really need
is a way to force a UD QP's outgoing QPN.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
