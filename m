From: Will Deacon <will.deacon@arm.com>
Subject: Re: RFC on writel and writel_relaxed
Date: Thu, 29 Mar 2018 10:20:47 +0100
Message-ID: <20180329092046.GB22926@arm.com>
References: <CA+55aFxULkhZGhg-tTBBxBBvXbL7QV7f6zvwW7U2wHFijqGEqw@mail.gmail.com>
 <b02cc752d90c5e5ae2cc8cc4f67429a7@codeaurora.org>
 <1522249996.21446.25.camel@kernel.crashing.org>
 <20180328.115509.481837809903086401.davem@davemloft.net>
 <20180329022324.037c3f39@roar.ozlabs.ibm.com>
 <1522272692.21446.42.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1522272692.21446.42.camel@kernel.crashing.org>
Sender: netdev-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nicholas Piggin <npiggin@gmail.com>, David Miller <davem@davemloft.net>, paulmck@linux.vnet.ibm.com, arnd@arndb.de, linux-rdma@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linus971@gmail.com, alexander.duyck@gmail.com, okaya@codeaurora.org, jgg@ziepe.ca, David.Laight@aculab.com, oohall@gmail.com, netdev@vger.kernel.org, alexander.h.duyck@redhat.com, torvalds@linux-foundation.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 29, 2018 at 08:31:32AM +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2018-03-29 at 02:23 +1000, Nicholas Piggin wrote:
> >   This is a variation on the mandatory write barrier that causes writes to weakly
> >   ordered I/O regions to be partially ordered.  Its effects may go beyond the
> >   CPU->Hardware interface and actually affect the hardware at some level.
> > 
> > How can a driver writer possibly get that right?
> > 
> > IIRC it was added for some big ia64 system that was really expensive
> > to implement the proper wmb() semantics on. So wmb() semantics were
> > quietly downgraded, then the subsequently broken drivers they cared
> > about were fixed by adding the stronger mmiowb().
> > 
> > What should have happened was wmb and writel remained correct, sane, and
> > expensive, and they add an mmio_wmb() to order MMIO stores made by the
> > writel_relaxed accessors, then use that to speed up the few drivers they
> > care about.
> > 
> > Now that ia64 doesn't matter too much, can we deprecate mmiowb and just
> > make wmb ordering talk about stores to the device, not to some
> > intermediate stage of the interconnect where it can be subsequently
> > reordered wrt the device? Drivers can be converted back to using wmb
> > or writel gradually.
> 
> I was under the impression that mmiowb was specifically about ordering
> writel's with a subsequent spin_unlock, without it, MMIOs from
> different CPUs (within the same lock) would still arrive OO.
> 
> If that's indeed the case, I would suggest ia64 switches to a similar
> per-cpu flag trick powerpc uses.

... or we could remove ia64.

/me runs for cover

Will
