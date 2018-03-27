From: Will Deacon <will.deacon@arm.com>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 11:09:44 +0100
Message-ID: <20180327100944.GD29373@arm.com>
References: <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
 <20180326210951.GD15554@ziepe.ca>
 <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <ebb36fd4-62e2-394a-219f-686c45a6dc75@codeaurora.org>
 <1522101717.7364.14.camel@kernel.crashing.org>
 <20180326222756.GJ15554@ziepe.ca>
 <CAK8P3a3a+zUNLjqw9CL5rYkXhJ-GMVTVnBU2XUu2f3njZfrqKw@mail.gmail.com>
 <1522141019.7364.43.camel@kernel.crashing.org>
 <20180327095745.GB29373@arm.com>
 <CAK8P3a0s+kP5=qEqTqAHGwB7j9ydaXD+oQJdLrFz=8swuWaDBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a0s+kP5=qEqTqAHGwB7j9ydaXD+oQJdLrFz=8swuWaDBg@mail.gmail.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Corbet <corbet@lwn.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Sinan Kaya <okaya@codeaurora.org>, Jason Gunthorpe <jgg@ziepe.ca>, Peter Zijlstra <peterz@infradead.org>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 27, 2018 at 12:05:06PM +0200, Arnd Bergmann wrote:
> On Tue, Mar 27, 2018 at 11:57 AM, Will Deacon <will.deacon@arm.com> wrote:
> 
> >
> > From db0daeaf94f0f6232f8206fc07a74211324b11d9 Mon Sep 17 00:00:00 2001
> > From: Will Deacon <will.deacon@arm.com>
> > Date: Tue, 27 Mar 2018 10:49:58 +0100
> > Subject: [PATCH] docs/memory-barriers.txt: Fix broken DMA vs MMIO ordering
> >  example
> >
> > The section of memory-barriers.txt that describes the dma_Xmb() barriers
> > has an incorrect example claiming that a wmb() is required after writing
> > to coherent memory in order for those writes to be visible to a device
> > before a subsequent MMIO access using writel() can reach the device.
> >
> > In fact, this ordering guarantee is provided (at significant cost on some
> > architectures such as arm and power) by writel, so the wmb() is not
> > necessary. writel_relaxed exists for cases where this ordering is not
> > required.
> >
> > Fix the example and update the text to make this clearer.
> >
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Jason Gunthorpe <jgg@ziepe.ca>
> > Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Reported-by: Sinan Kaya <okaya@codeaurora.org>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > ---
> >  Documentation/memory-barriers.txt | 18 ++++++++++--------
> >  1 file changed, 10 insertions(+), 8 deletions(-)
> >
> > diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> > index a863009849a3..2556b4b0e6f9 100644
> > --- a/Documentation/memory-barriers.txt
> > +++ b/Documentation/memory-barriers.txt
> > @@ -1909,9 +1909,6 @@ There are some more advanced barrier functions:
> >                 /* assign ownership */
> >                 desc->status = DEVICE_OWN;
> >
> > -               /* force memory to sync before notifying device via MMIO */
> > -               wmb();
> > -
> >                 /* notify device of new descriptors */
> >                 writel(DESC_NOTIFY, doorbell);
> >         }
> > @@ -1919,11 +1916,16 @@ There are some more advanced barrier functions:
> >       The dma_rmb() allows us guarantee the device has released ownership
> >       before we read the data from the descriptor, and the dma_wmb() allows
> >       us to guarantee the data is written to the descriptor before the device
> > -     can see it now has ownership.  The wmb() is needed to guarantee that the
> > -     cache coherent memory writes have completed before attempting a write to
> > -     the cache incoherent MMIO region.
> > -
> > -     See Documentation/DMA-API.txt for more information on consistent memory.
> > +     can see it now has ownership.  Note that, when using writel(), a prior
> > +     wmb() is not needed to guarantee that the cache coherent memory writes
> > +     have completed before writing to the cache incoherent MMIO region.
> > +     If this ordering between incoherent MMIO and coherent memory regions
> > +     is not required, writel_relaxed() can be used instead and is significantly
> > +     cheaper on some weakly-ordered architectures.
> 
> I think that's a great improvement, but I'm a bit worried about recommending
> writel_relaxed() too much: I've seen a lot of drivers that just always use
> writel_relaxed() over write(), and some of them get that wrong when they
> don't understand the difference but end up using DMA without explicit
> barriers anyway.
> 
> Also, having an architecture-independent driver use wmb()+writel_relaxed()
> ends up being more expensive than just using write(). Not sure how to
> best phrase it though.

Perhaps I add reword that with a simple example to say:

  If this ordering between incoherent MMIO and coherent memory regions
  is not required (e.g. in a sequence of accesses all to the MMIO region)
  [...]

since that seems to be the usual case where the _relaxed accessors help.

Will
