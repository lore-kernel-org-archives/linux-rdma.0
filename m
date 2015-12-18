From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Cocci] [PATCH] staging/rdma/hfi1: Fix a possible null pointer
 dereference
Date: Fri, 18 Dec 2015 07:33:36 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1512180727310.2052@localhost6.localdomain6>
References: <20151210161338.3341.95259.stgit@phlsvslse11.ph.intel.com>
 <20151214132849.GA22053@osadl.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151214132849.GA22053@osadl.at>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, dledford@redhat.com, linux-next@vger.kernel.org, Cocci@systeme.lip6.fr
List-Id: linux-rdma@vger.kernel.org



On Mon, 14 Dec 2015, Nicholas Mc Guire wrote:

> On Thu, Dec 10, 2015 at 11:13:38AM -0500, Mike Marciniszyn wrote:
> > From: Easwar Hariharan <easwar.hariharan@intel.com>
> > 
> > A code inspection pointed out that kmalloc_array may return NULL and
> > memset doesn't check the input pointer for NULL, resulting in a possible
> > NULL dereference. This patch fixes this.
> > 
> > Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> > Signed-off-by: Easwar Hariharan <easwar.hariharan@intel.com>
> > ---
> >  drivers/staging/rdma/hfi1/chip.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
> > index dc69159..49d49b2 100644
> > --- a/drivers/staging/rdma/hfi1/chip.c
> > +++ b/drivers/staging/rdma/hfi1/chip.c
> > @@ -10129,6 +10129,8 @@ static void init_qos(struct hfi1_devdata *dd, u32 first_ctxt)
> >  	if (num_vls * qpns_per_vl > dd->chip_rcv_contexts)
> >  		goto bail;
> >  	rsmmap = kmalloc_array(NUM_MAP_REGS, sizeof(u64), GFP_KERNEL);
> > +	if (!rsmmap)
> > +		goto bail;
> >  	memset(rsmmap, rxcontext, NUM_MAP_REGS * sizeof(u64));
> >  	/* init the local copy of the table */
> >  	for (i = 0, ctxt = first_ctxt; i < num_vls; i++) {
> > 
> > --
> 
> Based on this report a generalization of unchecked use turned up one more
> case in the current kernel (patch sent). Probably the  when  block needs 
> some cleanup, but findings like this definitely are a case for coccinelle 
> scanners.
> 
> <snip>
> /// check for missing NULL check before use                                     
> //
> //  missing check in: 
> //  ./drivers/staging/rdma/hfi1/chip.c:10131 unchecked allocation
> //  in -next-20151214
> //  reported-by Mike Marciniszyn <mike.marciniszyn@intel.com> 
> //
> //  after generalization this also found:
> //  ./drivers/clk/shmobile/clk-div6.c:197 unchecked allocation
> 
> virtual context
> virtual org
> virtual report
> 
> @badmemset@
> expression mem;
> position p;
> statement S;
> @@
> 
> <+...
> *mem = kmalloc_array@p(...);
>   ... when != if (!mem || ...) S
>       when != if (... && !mem) S
>       when != if (mem == NULL || ...) S
>       when != if (... && mem == NULL) S
>       when != if (unlikely(mem == NULL)) S
>       when != if (unlikely(!mem)) S
>       when != if (likely(!mem)) S
>       when != if (likely(mem == NULL)) S
>   return;
> ...+>
> 
> @script:python@
> p << badmemset.p;
> @@
> 
> print "%s:%s unchecked allocation" % (p[0].file,p[0].line)
> 
> <snip>

How about the following?  I got two hits with this, in 
drivers/clk/shmobile/clk-div6.c and drivers/staging/rdma/hfi1/chip.c.

@@
expression mem;
identifier f;
@@

*mem = kmalloc_array(...);
... when != mem == NULL
    when != mem != NULL
(
f(...,mem,...)
|
mem->f
|
mem[...]
)

There is a semantic patch in the kernel called kmerr that goes in this 
direction, but it seems to be overly restrictive and it doesn't address 
this function:

/// This semantic patch looks for kmalloc etc that are not followed by a
/// NULL check.  It only gives a report in the case where there is some
/// error handling code later in the function, which may be helpful
/// in determining what the error handling code for the call to kmalloc etc
/// should be.

Probably there are a lot of other functions that should be considered.

julia
