From: Will Deacon <will.deacon@arm.com>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 10:57:46 +0100
Message-ID: <20180327095745.GB29373@arm.com>
References: <CAK8P3a1zeMyj+Z-y4ER4moY6Zip9EWNOinf+VnboGOrgiwbBZA@mail.gmail.com>
 <20180326202545.GB15554@ziepe.ca>
 <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
 <20180326210951.GD15554@ziepe.ca>
 <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <ebb36fd4-62e2-394a-219f-686c45a6dc75@codeaurora.org>
 <1522101717.7364.14.camel@kernel.crashing.org>
 <20180326222756.GJ15554@ziepe.ca>
 <CAK8P3a3a+zUNLjqw9CL5rYkXhJ-GMVTVnBU2XUu2f3njZfrqKw@mail.gmail.com>
 <1522141019.7364.43.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <1522141019.7364.43.camel@kernel.crashing.org>
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
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Arnd Bergmann <arnd@arndb.de>, corbet@lwn.net, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Sinan Kaya <okaya@codeaurora.org>, Jason Gunthorpe <jgg@ziepe.ca>, peterz@infradead.org, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, Alexander Duyck <alexander.h.duyck@redhat.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, mingo@redhat.com
List-Id: linux-rdma@vger.kernel.org

[+ locking/ordering/docs people]

On Tue, Mar 27, 2018 at 07:56:59PM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2018-03-27 at 09:56 +0200, Arnd Bergmann wrote:
> > On Tue, Mar 27, 2018 at 12:27 AM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > On Tue, Mar 27, 2018 at 09:01:57AM +1100, Benjamin Herrenschmidt wrote:
> > > > On Mon, 2018-03-26 at 17:46 -0400, Sinan Kaya wrote:
> > > 
> > > I even see patches adding wmb() based on actual observed memory
> > > corruption during testing on Intel:
> > > 
> > > https://patchwork.kernel.org/patch/10177207/
> > > 
> > > So you think all of this is unnecessary and writel is totally strongly
> > > ordered, even on multi-socket Intel?
> > 
> > This example adds a wmb() between two writes to a coherent DMA
> > area, it is definitely required there. 
> 
> Ah you are right, I incorrectly assumed that the "prod_db" function was
> an MMIO. So we do NOT have a counter example where wmb is needed on
> x86, pfiew ! :-)
> 
> > I'm pretty sure I've never seen
> > any bug reports pointing to a missing wmb() between memory
> > and MMIO write accesses, but if you remember seeing them in the
> > list, maybe you can look again for some evidence of something going
> > wrong on x86 without it?
> 
> The interesting thing is that we do seem to have a whole LOT of these
> spurrious wmb before writel all over the tree, I suspect because of
> that incorrect recommendation in memory-barriers.txt.
> 
> We should fix that.

Patch below. Thoughts?

Will

--->8

>From db0daeaf94f0f6232f8206fc07a74211324b11d9 Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Tue, 27 Mar 2018 10:49:58 +0100
Subject: [PATCH] docs/memory-barriers.txt: Fix broken DMA vs MMIO ordering
 example

The section of memory-barriers.txt that describes the dma_Xmb() barriers
has an incorrect example claiming that a wmb() is required after writing
to coherent memory in order for those writes to be visible to a device
before a subsequent MMIO access using writel() can reach the device.

In fact, this ordering guarantee is provided (at significant cost on some
architectures such as arm and power) by writel, so the wmb() is not
necessary. writel_relaxed exists for cases where this ordering is not
required.

Fix the example and update the text to make this clearer.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Reported-by: Sinan Kaya <okaya@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 Documentation/memory-barriers.txt | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index a863009849a3..2556b4b0e6f9 100644
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
@@ -1919,11 +1916,16 @@ There are some more advanced barrier functions:
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
+     have completed before writing to the cache incoherent MMIO region.
+     If this ordering between incoherent MMIO and coherent memory regions
+     is not required, writel_relaxed() can be used instead and is significantly
+     cheaper on some weakly-ordered architectures.
+
+     See the subsection "Kernel I/O barrier effects" for more information on
+     relaxed I/O accessors and the Documentation/DMA-API.txt file for more
+     information on consistent memory.
 
 
 MMIO WRITE BARRIER
-- 
2.1.4
