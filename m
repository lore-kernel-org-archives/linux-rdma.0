From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 12:03:01 +1100
Message-ID: <1522198981.7364.81.camel@kernel.crashing.org>
References: <1521854626.16434.359.camel@kernel.crashing.org>
         <58ce5b83f40f4775bec1be8db66adb0d@AcuMS.aculab.com>
         <20180326165425.GA15554@ziepe.ca>
         <CAK8P3a1zeMyj+Z-y4ER4moY6Zip9EWNOinf+VnboGOrgiwbBZA@mail.gmail.com>
         <20180326202545.GB15554@ziepe.ca>
         <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
         <20180326210951.GD15554@ziepe.ca>
         <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
         <1522101616.7364.13.camel@kernel.crashing.org>
         <1e077f6a-90b6-cce9-6f0f-a8c003fec850@codeaurora.org>
         <20180327151029.GB17494@arm.com>
         <CAKgT0Uem6HT-Z=HBnSVcC4rnDL0yFyXEbr+FN3YYkJ=ExZpUPQ@mail.gmail.com>
         <1522186396.7364.61.camel@kernel.crashing.org>
         <CA+55aFw2R4pirO0m+jtj4F8AF2-tVi3guEaWOA-EBqNyFmh29w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CA+55aFw2R4pirO0m+jtj4F8AF2-tVi3guEaWOA-EBqNyFmh29w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, Will Deacon <will.deacon@arm.com>, Sinan Kaya <okaya@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Alexander Duyck <alexander.h.duyck@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2018-03-27 at 14:39 -1000, Linus Torvalds wrote:
> On Tue, Mar 27, 2018 at 11:33 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > 
> > Well, we need to clarify that once and for all, because as I wrote
> > earlier, it was decreed by Linus more than a decade ago that writel
> > would be fully ordered by itself vs. previous memory stores (at least
> > on UC memory).
> 
> Yes.
> 
> So "writel()" needs to be ordered with respect to other writel() uses
> on the same thread. Anything else *will* break drivers. Obviously, the
> drivers may then do magic to say "do write combining etc", but that
> magic will be architecture-specific.
> 
> The other issue is that "writel()" needs to be ordered wrt other CPU's
> doing "writel()" if those writel's are in a spinlocked region.

 .../...

The discussion at hand is about

	dma_buffer->foo = 1;			/* WB */
	writel(KICK, DMA_KICK_REGISTER);	/* UC */

(The WC case is something else, let's not mix things up just yet)

IE, a store to normal WB cache memory followed by a writel to a device
which will then DMA from that buffer.

Back in the days, we did require on powerpc a wmb() between these, but
you made the point that x86 didn't and driver writers would never get
that right.

We decided to go conservative, added the necessary barrier inside
writel, so did ARM and it became the norm that writel is also fully
ordered vs. previous stores to memory *by the same CPU* of course (or
protected by the same spinlock).

Now it appears that this wasn't fully understood back then, and some
people are now saying that x86 might not even provide that semantic
always.

So a number (fairly large) of drivers have been adding wmb() in those
case, while others haven't, and it's a mess.

The mess is compounded by the fact that if writel is now defined to
*not* provide that ordering guarantee, then writel_relaxed() is
pointless since all it is defined to relax is precisely the above
ordering guarantee.

So I want to get to the bottom of this once and for all so we can have
well defined and documented semantics and stop having drivers do random
things that may or may not work on some or all architectures (including
x86 !).

Quite note about the spinlock case... In fact this is the only case you
did allow back then to be relaxed. In theory a writel followed by a
spin_unlock requires an mmiowb (which is the only point of that barrier
in fact). This was done because an arch (I think ia64) had a hard time
getting MMIOs from multiple CPUs get in order vs. a lock and required
an expensive access to the PCI host bridge to do so.

Back then, on powerpc, we chose not to allow that relaxing and instead
added code to our writel to set a per-cpu flag which would cause the
next spin_unlock to use a stronger barrier than usual.

We do need to clarify this as well, but let's start with the most basic
one first, there is enough confusion already.

Cheers,
Ben.
