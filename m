From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-core 06/14] i40iw: Get rid of unique barrier macros
Date: Tue, 7 Mar 2017 17:16:58 -0600
Message-ID: <20170307231658.GB52428@ssaleem-MOBL4.amr.corp.intel.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1487272989-8215-7-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170306181808.GA34252@ssaleem-MOBL4.amr.corp.intel.com>
 <20170306190751.GA30663@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170306190751.GA30663-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 06, 2017 at 12:07:51PM -0700, Jason Gunthorpe wrote:
> On Mon, Mar 06, 2017 at 12:18:09PM -0600, Shiraz Saleem wrote:
> > On Thu, Feb 16, 2017 at 12:23:01PM -0700, Jason Gunthorpe wrote:
> > > Use our standard versions from util instead. There doesn't seem
> > > to be anything tricky here, but the inlined versions were like our
> > > wc_wmb() barriers, not the wmb().
> > > 
> > > There appears to be no WC memory in this driver, so despite the comments,
> > > these barriers are also making sure that user DMA data is flushed out. Make
> > > them all wmb()
> > > 
> > > Guess at where the missing rmb() should be.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > 
> > 
> > > @@ -780,6 +780,8 @@ static enum i40iw_status_code i40iw_cq_poll_completion(struct i40iw_cq_uk *cq,
> > >  	if (polarity != cq->polarity)
> > >  		return I40IW_ERR_QUEUE_EMPTY;
> > >  
> > > +	udma_from_device_barrier();
> > > +
> > 
> > What is the need for the barrier here?
> 
> Every driver doing DMA needs to have a rmb(), I guessed this is
> approximately the right place to put it for i10iw.
> 
> Within the PCI producer/consumer model the rmb needs to be placed
> after the CPU observes a DMA write that proves other DMA writes have
> occured.
> 
> It serializes the CPU with the write stream from PCI and prevents the
> compiler/CPU from re-ordering dependent loads to be before the proving
> load.
> 

OK. This change makes sense. ACK.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
