From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Mon, 20 Jul 2015 16:13:33 -0600
Message-ID: <20150720221333.GA11356@obsidianresearch.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net>
 <20150720190311.10997.12636.stgit@manet.1015granger.net>
 <55AD5B48.3010906@talpey.com>
 <20150720210544.GA9655@obsidianresearch.com>
 <015501d0c334$3f1c2830$bd547890$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <015501d0c334$3f1c2830$bd547890$@opengridcomputing.com>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 20, 2015 at 04:37:15PM -0500, Steve Wise wrote:
> 
> 
> > From: Steve Wise [mailto:swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org]
> > Sent: Monday, July 20, 2015 4:34 PM
> > To: 'Jason Gunthorpe'; 'Tom Talpey'
> > Cc: 'Chuck Lever'; 'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'; 'linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'
> > Subject: RE: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
> > 
> > 
> > >
> > > > Based on that, should we remove the cxgb3 driver as well? Or at least
> > > > can you fix it up to at least fail get_dma_mr if there is too much
> > > > ram?
> > > >
> > >
> > > I would like to keep cxgb3 around.  I can add code to fail if the memory is > 32b.  Do you know how I get the amount of
> available ram?
> > >
> > 
> > Something like this?
> > 
> > @@ -736,6 +736,9 @@ static struct ib_mr *iwch_get_dma_mr(struct ib_pd *pd, int acc)
> >         /*
> >          * T3 only supports 32 bits of size.
> >          */
> > +       if ((totalram_pages << PAGE_SHIFT) > 0xffffffff)
> > +               return -ENOTSUPP;
> 
> oops: ERR_PTR(-ENOTSUPP);
> 
> > +
> >         bl.size = 0xffffffff;
> >         bl.addr = 0;
> >         kva = 0;

Yah, that seems much better.. With the patch set I am working on this
will mean all ULPs will fail to create a kernel PD on cxgb3 if the
above triggers. If our error handling works that should just make it
unuable from kernel space which is what we need to see..

To remove the amasso driver, move it to Staging. I don't know the
exact details, sorry. Hopefully Doug will be able to help you do that.

Maybe add some kind of one time print 'cxgb3 is not usuable on
machines with >4G of RAM' as well?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
