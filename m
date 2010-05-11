From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: IPoIB multiqueue support?
Date: Tue, 11 May 2010 14:43:58 -0600
Message-ID: <20100511204358.GQ15969@obsidianresearch.com>
References: <alpine.DEB.2.00.1005101607580.17916@router.home> <adawrvbxxyd.fsf@roland-alpha.cisco.com> <alpine.DEB.2.00.1005110851530.1500@router.home> <adawrvawhyc.fsf@roland-alpha.cisco.com> <alpine.DEB.2.00.1005111516500.1500@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1005111516500.1500-sBS69tsa9Uj/9pzu0YdTqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 11, 2010 at 03:17:36PM -0500, Christoph Lameter wrote:
> On Tue, 11 May 2010, Roland Dreier wrote:
> 
> >  > I am mostly interested in multicast traffic. Connected mode is not
> >  > relevant to that usage scenario.
> >
> > As I said, I don't think anyone is working on it.  However it wouldn't
> > be that hard to get something pretty good for multicast, since the
> > InfiniBand multicast join mechanism would let you have essentially a
> > perfect filter for steering individual multicast groups to whichever QP
> > (ring) you wanted to.
> 
> Right but then would each individual QP need its own IP address?

I think Roland means that each IP multicast address is mapped into an
IB multicast GID, and you can bind a QP to a set of MGIDs. Right now
the driver binds all MGIDs to the rx QP and basically ignores the
MGID on receive.

To go multi-queue you'd create multiple QPs and spread the MGID binds
amongst them.

> > Of course you could also implement the equivalent thing in userspace and
> > probably get even better performance.
> 
> Start a QP listening to IPoIB mc traffic?

Yes, but the downside is that if you rely on the kernel to the group
join then the HCA will send the packet to user space and the kernel QP.

Some of the weird features in the RDMA CM seem to be for supporting
this..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
