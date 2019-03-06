From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-next 3/3] IB/hfi1: Close race condition on user
 context disable and close
Date: Wed, 6 Mar 2019 14:47:40 -0400
Message-ID: <20190306184740.GH1662@ziepe.ca>
References: <20190226164333.31476.43732.stgit@scvm10.sc.intel.com>
 <20190226164530.31476.26502.stgit@scvm10.sc.intel.com>
 <316cda1d-eeaa-c75a-a4d8-fb087cd38714@intel.com>
 <20190304204153.GF8613@ziepe.ca>
 <03a0a78b-8ae6-26b2-7d6c-9d605971d975@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <03a0a78b-8ae6-26b2-7d6c-9d605971d975@intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 05, 2019 at 10:30:39AM -0500, Dennis Dalessandro wrote:
> On 3/4/2019 3:41 PM, Jason Gunthorpe wrote:
> > On Tue, Feb 26, 2019 at 12:15:59PM -0500, Dennis Dalessandro wrote:
> > > On 2/26/2019 11:45 AM, Dennis Dalessandro wrote:
> > > >    struct hfi1_ctxtdata *hfi1_rcd_get_by_index(struct hfi1_devdata *dd, u16 ctxt);
> > > > diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
> > > > index 7841a0a..2cc5164 100644
> > > > +++ b/drivers/infiniband/hw/hfi1/init.c
> > > > @@ -214,12 +214,12 @@ static void hfi1_rcd_free(struct kref *kref)
> > > >    	struct hfi1_ctxtdata *rcd =
> > > >    		container_of(kref, struct hfi1_ctxtdata, kref);
> > > > -	hfi1_free_ctxtdata(rcd->dd, rcd);
> > > > -
> > > >    	spin_lock_irqsave(&rcd->dd->uctxt_lock, flags);
> > > >    	rcd->dd->rcd[rcd->ctxt] = NULL;
> > > >    	spin_unlock_irqrestore(&rcd->dd->uctxt_lock, flags);
> > > > +	hfi1_free_ctxtdata(rcd->dd, rcd);
> > > > +
> > > >    	kfree(rcd);
> > > >    }
> > > Whoops, hold off on pulling this one just yet. We need to take a closer look
> > > at the above hunk.
> > 
> > Oh, okay.. Please resend it
> 
> We've talked it over, it is OK to take after all. Just needed to be sure and
> folks were on vacation last week. If you still have the patch it's good to
> go, if not I'll tack it on my next submit as well.

Okay I grabbed the old one

Jason
