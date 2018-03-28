From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 20:56:28 +1100
Message-ID: <1522230988.21446.7.camel@kernel.crashing.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180328090710.GB28871@arm.com>
Sender: netdev-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Duyck <alexander.duyck@gmail.com>, Sinan Kaya <okaya@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2018-03-28 at 10:07 +0100, Will Deacon wrote:
> 
> For arm/arm64 we guarantee ordering for (1) but not for (2) -- you'd need to
> add an mb() to make it work.
> 
> Do both of these work on power? 

Yes. There's even another quirk, see further down ;-)

> If so, I guess I can make readl even more
> expensive :/ Feels a bit like the tail wagging the dog, though.

Maybe, but then readl is always horribly slow anyway so you may not
necessarily be losing that much.

> Another thing I just realised is that we restrict the barriers we use in
> readl/writel on arm64 so that they don't necessary apply to both loads and
> stores. To be specific:
> 
>    writel is ordered against prior writes to memory, but not reads

That could be tricky... You may end up with something that reads before
triggering a DMA and ends up with the post-DMA value ... ugh.

>    readl is ordered against subsequent reads of memory, but not writes (but
>    note that in example (1) above, the control dependency ensures that).
> 
> If necessary, I could move the barrier in our readl implementation to be
> before the read, then play the control-dependency + instruction-sync (ISB)
> trick that you do on power.

Yeah so that other trick I'm talking about is also used for timing
accuracy.

For example, let's say I have a device with a reset bit and the spec
says the reset bit needs to be set for at least 10us.

This is wrong:

	writel(1, RESET_REG);
	usleep(10);
	writel(0, RESET_REG);

Because of write posting, the first write might arrive to the device
right before the second one.

The typical "fix" is to turn that into:

	writel(1, RESET_REG);
	readl(RESET_REG); /* Flush posted writes */
	usleep(10);
	writel(0, RESET_REG);

*However* the issue here, at least on power, is that the CPU can issue
that readl but doesn't necessarily wait for it to complete (ie, the
data to return), before proceeding to the usleep. Now a usleep contains
a bunch of loads and stores and is probably fine, but a udelay which
just loops on the timebase may not be.

Thus we may still violate the timing requirement.

What we did inside readl, with the twi;isync sequence (which basically
means, trap on return value with "trap never" as a condition, followed
by isync that ensures all excpetion conditions are resolved), is force
the CPU to "consume" the data from the read before moving on.

This effectively makes readl fully synchronous (we would probably avoid
that if we were to implement a readl_relaxed).

Cheers,
Ben.
