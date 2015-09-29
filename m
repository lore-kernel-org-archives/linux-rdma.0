From: "'J. Bruce Fields'" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 2/3] svcrdma: handle rdma read with a non-zero initial
 page offset
Date: Tue, 29 Sep 2015 11:40:46 -0400
Message-ID: <20150929154046.GE3190@fieldses.org>
References: <20150921172423.9761.92399.stgit@build2.ogc.int>
 <20150921172428.9761.27838.stgit@build2.ogc.int>
 <56094F3D.2030002@opengridcomputing.com>
 <20150928210459.GC3190@fieldses.org>
 <009001d0fa37$8871a980$9954fc80$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <009001d0fa37$8871a980$9954fc80$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 28, 2015 at 04:49:21PM -0500, Steve Wise wrote:
> 
> 
> > -----Original Message-----
> > From: J. Bruce Fields [mailto:bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org]
> > Sent: Monday, September 28, 2015 4:05 PM
> > To: Steve Wise
> > Cc: trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [PATCH 2/3] svcrdma: handle rdma read with a non-zero initial page offset
> > 
> > On Mon, Sep 28, 2015 at 09:31:25AM -0500, Steve Wise wrote:
> > > On 9/21/2015 12:24 PM, Steve Wise wrote:
> > > >The server rdma_read_chunk_lcl() and rdma_read_chunk_frmr() functions
> > > >were not taking into account the initial page_offset when determining
> > > >the rdma read length.  This resulted in a read who's starting address
> > > >and length exceeded the base/bounds of the frmr.
> > > >
> > > >Most work loads don't tickle this bug apparently, but one test hit it
> > > >every time: building the linux kernel on a 16 core node with 'make -j
> > > >16 O=/mnt/0' where /mnt/0 is a ramdisk mounted via NFSRDMA.
> > > >
> > > >This bug seems to only be tripped with devices having small fastreg page
> > > >list depths.  I didn't see it with mlx4, for instance.
> > > >
> > > >Fixes: 0bf4828983df ('svcrdma: refactor marshalling logic')
> > > >Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > > >Tested-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > >---
> > > >
> > > >
> > >
> > > Hey Bruce, can this make 4.3-rc?  Also, what do you think about
> > > pushing it to stable?
> > 
> > It looks like a reasonable candidate for stable.  Apologies, somehow I
> > missed it when you posted it--would you mind resending?
> > 
> > --b.
> 
> resent this one patch.
> 
> What is your process for pushing to stable?

Currently my standard regression tests don't seem to be passing on
recent 4.3; once I figure that out, I'll push out a branch with your
patch (and any others required) to

	git://linux-nfs.org/~bfields for-4.3

and then send a pull request to Linus.  Should be by the end of the
week.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
