From: Nicholas Mc Guire <der.herr-kA1LtwSENNE@public.gmane.org>
Subject: Re: [Cocci] [PATCH] staging/rdma/hfi1: Fix a possible null pointer
 dereference
Date: Fri, 18 Dec 2015 14:20:25 +0000
Message-ID: <20151218142025.GA32208@osadl.at>
References: <20151210161338.3341.95259.stgit@phlsvslse11.ph.intel.com>
 <20151214132849.GA22053@osadl.at>
 <alpine.DEB.2.02.1512180727310.2052@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1512180727310.2052-bi+AKbBUZKagILUCTcTcHdKyNwTtLsGr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 18, 2015 at 07:33:36AM +0100, Julia Lawall wrote:
> 
> 
> On Mon, 14 Dec 2015, Nicholas Mc Guire wrote:
> 
> > On Thu, Dec 10, 2015 at 11:13:38AM -0500, Mike Marciniszyn wrote:
> > > From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > 
> > > A code inspection pointed out that kmalloc_array may return NULL and
> > > memset doesn't check the input pointer for NULL, resulting in a possible
> > > NULL dereference. This patch fixes this.
> > > 
> > > Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  drivers/staging/rdma/hfi1/chip.c |    2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
> > > index dc69159..49d49b2 100644
> > > --- a/drivers/staging/rdma/hfi1/chip.c
> > > +++ b/drivers/staging/rdma/hfi1/chip.c
> > > @@ -10129,6 +10129,8 @@ static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
> > >  	if (num_vls * qpns_per_vl > dd->chip_rcv_contexts)
> > >  		goto bail;
> > >  	rsmmap = kmalloc_array(NUM_MAP_REGS, sizeof(u64), GFP_KERNEL);
> > > +	if (!rsmmap)
> > > +		goto bail;
> > >  	memset(rsmmap, rxcontext, NUM_MAP_REGS * sizeof(u64));
> > >  	/* init the local copy of the table */
> > >  	for (i = 0, ctxt = first_ctxt; i < num_vls; i++) {
> > > 
> > > --
> > 
> > Based on this report a generalization of unchecked use turned up one more
> > case in the current kernel (patch sent). Probably the  when  block needs 
> > some cleanup, but findings like this definitely are a case for coccinelle 
> > scanners.
> > 
> > <snip>
> > /// check for missing NULL check before use                                     
> > //
> > //  missing check in: 
> > //  ./drivers/staging/rdma/hfi1/chip.c:10131 unchecked allocation
> > //  in -next-20151214
> > //  reported-by Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> 
> > //
> > //  after generalization this also found:
> > //  ./drivers/clk/shmobile/clk-div6.c:197 unchecked allocation
> > 
> > virtual context
> > virtual org
> > virtual report
> > 
> > @badmemset@
> > expression mem;
> > position p;
> > statement S;
> > @@
> > 
> > <+...
> > *mem = kmalloc_array@p(...);
> >   ... when != if (!mem || ...) S
> >       when != if (... && !mem) S
> >       when != if (mem == NULL || ...) S
> >       when != if (... && mem == NULL) S
> >       when != if (unlikely(mem == NULL)) S
> >       when != if (unlikely(!mem)) S
> >       when != if (likely(!mem)) S
> >       when != if (likely(mem == NULL)) S
> >   return;
> > ...+>
> > 
> > @script:python@
> > p << badmemset.p;
> > @@
> > 
> > print "%s:%s unchecked allocation" % (p[0].file,p[0].line)
> > 
> > <snip>
> 
> How about the following?  I got two hits with this, in 
> drivers/clk/shmobile/clk-div6.c and drivers/staging/rdma/hfi1/chip.c.
> 
> @@
> expression mem;
> identifier f;
> @@
> 
> *mem = kmalloc_array(...);
> ... when != mem == NULL
>     when != mem != NULL
> (

works perfectly for this case - thanks 

I actually initially used the "template" from api/alloc/kzalloc-simple.cocci
but that did not catch all cases for the kmalloc_array scanner.
Poping your proposal into kzalloc-simple.cocci seems to be finding quite 
a few additional cases will review them to see if there are any false 
positives - but a first scan did show that most of the reported cases 
seem to be valid.


thx!
hofrat
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
