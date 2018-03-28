From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Thu, 29 Mar 2018 02:12:30 +1100
Message-ID: <1522249950.21446.23.camel@kernel.crashing.org>
References: <1e077f6a-90b6-cce9-6f0f-a8c003fec850@codeaurora.org>
         <20180327151029.GB17494@arm.com>
         <CAKgT0Uem6HT-Z=HBnSVcC4rnDL0yFyXEbr+FN3YYkJ=ExZpUPQ@mail.gmail.com>
         <1522186396.7364.61.camel@kernel.crashing.org>
         <CA+55aFw2R4pirO0m+jtj4F8AF2-tVi3guEaWOA-EBqNyFmh29w@mail.gmail.com>
         <1522198981.7364.81.camel@kernel.crashing.org>
         <CA+55aFyTeuXPmC5-1JGh2ow-rf5wMA6Vcv0aeS_q0_EnptSK9Q@mail.gmail.com>
         <1522211620.7364.94.camel@kernel.crashing.org>
         <CA+55aFw24R3YAujir59GdG+sBBQOA9WyXySEN3AcEYK99ZHuwQ@mail.gmail.com>
         <1522219376.7364.109.camel@kernel.crashing.org>
         <20180328090710.GB28871@arm.com>
         <1522230988.21446.7.camel@kernel.crashing.org>
         <a642dc060b484d98bc728eb1f4b5c600@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <a642dc060b484d98bc728eb1f4b5c600@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>, Will Deacon <will.deacon@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Duyck <alexander.duyck@gmail.com>, Sinan Kaya <okaya@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2018-03-28 at 11:30 +0000, David Laight wrote:
> From: Benjamin Herrenschmidt
> > Sent: 28 March 2018 10:56
> 
> ...
> > For example, let's say I have a device with a reset bit and the spec
> > says the reset bit needs to be set for at least 10us.
> > 
> > This is wrong:
> > 
> > 	writel(1, RESET_REG);
> > 	usleep(10);
> > 	writel(0, RESET_REG);
> > 
> > Because of write posting, the first write might arrive to the device
> > right before the second one.
> > 
> > The typical "fix" is to turn that into:
> > 
> > 	writel(1, RESET_REG);
> > 	readl(RESET_REG); /* Flush posted writes */
> 
> Would a writel(1, RESET_REG) here provide enough synchronsiation?

Probably yes. It's one of those things where you try to deal with the
fact that 90% of driver writers barely understand the basic stuff and
so you need the "default" accessors to be hardened as much as possible.

We still need to get a reasonably definition of the semantics of the
relaxed ones vs. WC memory but let's get through that exercise first
and hopefully for the last time.
 
> > 	usleep(10);
> > 	writel(0, RESET_REG);
> > 
> > *However* the issue here, at least on power, is that the CPU can issue
> > that readl but doesn't necessarily wait for it to complete (ie, the
> > data to return), before proceeding to the usleep. Now a usleep contains
> > a bunch of loads and stores and is probably fine, but a udelay which
> > just loops on the timebase may not be.
> > 
> > Thus we may still violate the timing requirement.
> 
> I've seem that sort of code (with udelay() and no read back) quite often.
> How many were in linux I don't know.
> 
> For small delays I usually fix it by repeated writes (of the same value)
> to the device register. That can guarantee very short intervals.

As long as you know the bus frequency...

> The only time I've actually seen buffered writes break timing was
> between a 286 and an 8859 interrupt controller.

:-)

The problem for me is not so much what I've seen, I realize that most
of the issues we are talking about are the kind that will hit once in a
thousand times or less.

But we *can* reason about them in a way that can effectively prevent
the problem completely and when your cluster has 10000 machine, 1/1000
starts becoming significant.

These days the vast majority of IO devices either are 99% DMA driven so
that a bit of overhead on MMIOs is irrelevant, or have one fast path
(low latency IB etc...) that needs some finer control, and the rest is
all setup which can be paranoid at will.

So I think we should aim for the "default" accessors most people use to
be as hadened as we can think of. I favor correctness over performance
in all cases. But then we also define a reasonable semantic for the
relaxed ones (well, we sort-of do have one, we might have to make it a
bit more precise in some areas) that allows the few MMIO fast path that
care to be optimized.

> If you wrote to the mask then enabled interrupts the first IACK cycle
> could be too close to write and break the cycle recovery time.
> That clobbered most of the interrupt controller registers.
> That probably affected every 286 board ever built!
> Not sure how much software added the required extra bus cycle.
> 
> > What we did inside readl, with the twi;isync sequence (which basically
> > means, trap on return value with "trap never" as a condition, followed
> > by isync that ensures all excpetion conditions are resolved), is force
> > the CPU to "consume" the data from the read before moving on.
> > 
> > This effectively makes readl fully synchronous (we would probably avoid
> > that if we were to implement a readl_relaxed).
> 
> I've always wondered exactly what the twi;isync were for - always seemed
> very heavy handed for most mmio reads.
> Particularly if you are doing mmio reads from a data fifo.

If you do that you should use the "s" version of the accessors. Those
will only do the above trick at the end of the access series. Also a
FIFO needs special care about endianness anyway, so you should use
those accessors regardless. (Hint: you never endian swap a FIFO even on
BE on a LE device, unless something's been wired very badly in HW).

> Perhaps there should be a writel_wait() that is allowed to do a read back
> for such code paths?

I think what we have is fine, we just define that the standard
writel/readl as fairly simple and hardened, and we look at providing a
somewhat reasonable set of relaxed variants for optimizing fast path.
We pretty much already are there, we just need to be better at defining
the semantics.

And for the super high perf case, which thankfully is either seldom
(server high perf network stuff) or very arch specific (ARM SoC stuff),
then arch specific driver hacks will always remain the norm.

Cheers,
Ben. 

> 	David
> 
