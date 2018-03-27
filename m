From: Will Deacon <will.deacon@arm.com>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 12:02:58 +0100
Message-ID: <20180327110258.GF2464@arm.com>
References: <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <ebb36fd4-62e2-394a-219f-686c45a6dc75@codeaurora.org>
 <1522101717.7364.14.camel@kernel.crashing.org>
 <20180326222756.GJ15554@ziepe.ca>
 <CAK8P3a3a+zUNLjqw9CL5rYkXhJ-GMVTVnBU2XUu2f3njZfrqKw@mail.gmail.com>
 <1522141019.7364.43.camel@kernel.crashing.org>
 <20180327095745.GB29373@arm.com>
 <CAK8P3a0s+kP5=qEqTqAHGwB7j9ydaXD+oQJdLrFz=8swuWaDBg@mail.gmail.com>
 <20180327100944.GD29373@arm.com>
 <CAK8P3a0Xep0-EpGS9jnjUf1iJhRxH1WRztGQrvkdrLVaxBPT1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a0Xep0-EpGS9jnjUf1iJhRxH1WRztGQrvkdrLVaxBPT1w@mail.gmail.com>
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

On Tue, Mar 27, 2018 at 12:53:49PM +0200, Arnd Bergmann wrote:
> On Tue, Mar 27, 2018 at 12:09 PM, Will Deacon <will.deacon@arm.com> wrote:
> > On Tue, Mar 27, 2018 at 12:05:06PM +0200, Arnd Bergmann wrote:
> >> > -
> >> > -     See Documentation/DMA-API.txt for more information on consistent memory.
> >> > +     can see it now has ownership.  Note that, when using writel(), a prior
> >> > +     wmb() is not needed to guarantee that the cache coherent memory writes
> >> > +     have completed before writing to the cache incoherent MMIO region.
> >> > +     If this ordering between incoherent MMIO and coherent memory regions
> 
> One more thing: I think the term "incoherent MMIO" is a bit confusing, I'd
> prefer just "MMIO" here. At least I don't have the faintest clue what the
> difference between "coherent MMIO" and "incoherent MMIO" would be ;-)

Yes, you're right. I was just following the terminology that's already used
here, but actually that seems not be used anywhere else in the document!
I'll kill it.

> >> > +     is not required, writel_relaxed() can be used instead and is significantly
> >> > +     cheaper on some weakly-ordered architectures.
> >>
> >> I think that's a great improvement, but I'm a bit worried about recommending
> >> writel_relaxed() too much: I've seen a lot of drivers that just always use
> >> writel_relaxed() over write(), and some of them get that wrong when they
> >> don't understand the difference but end up using DMA without explicit
> >> barriers anyway.
> >>
> >> Also, having an architecture-independent driver use wmb()+writel_relaxed()
> >> ends up being more expensive than just using write(). Not sure how to
> >> best phrase it though.
> >
> > Perhaps I add reword that with a simple example to say:
> >
> >   If this ordering between incoherent MMIO and coherent memory regions
> >   is not required (e.g. in a sequence of accesses all to the MMIO region)
> >   [...]
> >
> > since that seems to be the usual case where the _relaxed accessors help.
> 
> That still doesn't quite capture what I'd like driver writes to do: in essence
> I would recommend them to use writel() all the time, except in performance
> critical code that has been shown to be correct and has a comment to explain
> why _relaxed() is ok in that particular function.
> 
> Maybe it can just be rephrased to warn against the use of writel_relaxed()
> here, and explain the difference that way:
> 
>      can see it now has ownership.  Note that, when using writel(), a prior
>      wmb() is not needed to guarantee that the cache coherent memory writes
>      have completed before writing to the cache incoherent MMIO region.
>      The cheaper writel_relaxed() does not guarantee the DMA to be visible
>      to the device and must not be used here.

Fair enough. I'd rather people used _relaxed by default, but I have to admit
that it will probably just result in them getting things wrong. Just a tiny
bit of wordsmithing brings this to:


diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index a863009849a3..3247547d1c36 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1909,9 +1909,6 @@ There are some more advanced barrier functions:
 		/* assign ownership */
 		desc->status = DEVICE_OWN;
 
-		/* force memory to sync before notifying device via MMIO */
-		wmb();
-
 		/* notify device of new descriptors */
 		writel(DESC_NOTIFY, doorbell);
 	}
@@ -1919,11 +1916,15 @@ There are some more advanced barrier functions:
      The dma_rmb() allows us guarantee the device has released ownership
      before we read the data from the descriptor, and the dma_wmb() allows
      us to guarantee the data is written to the descriptor before the device
-     can see it now has ownership.  The wmb() is needed to guarantee that the
-     cache coherent memory writes have completed before attempting a write to
-     the cache incoherent MMIO region.
-
-     See Documentation/DMA-API.txt for more information on consistent memory.
+     can see it now has ownership.  Note that, when using writel(), a prior
+     wmb() is not needed to guarantee that the cache coherent memory writes
+     have completed before writing to the MMIO region.  The cheaper
+     writel_relaxed() does not provide this guarantee and must not be used
+     here.
+
+     See the subsection "Kernel I/O barrier effects" for more information on
+     relaxed I/O accessors and the Documentation/DMA-API.txt file for more
+     information on consistent memory.
 
 
 MMIO WRITE BARRIER


If you're happy with that, I'll send it as a proper patch.

Cheers,

Will
