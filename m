From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 15:33:40 +1100
Message-ID: <1522211620.7364.94.camel@kernel.crashing.org>
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
         <1522198981.7364.81.camel@kernel.crashing.org>
         <CA+55aFyTeuXPmC5-1JGh2ow-rf5wMA6Vcv0aeS_q0_EnptSK9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyTeuXPmC5-1JGh2ow-rf5wMA6Vcv0aeS_q0_EnptSK9Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, Will Deacon <will.deacon@arm.com>, Sinan Kaya <okaya@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Alexander Duyck <alexander.h.duyck@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2018-03-27 at 16:51 -1000, Linus Torvalds wrote:
> On Tue, Mar 27, 2018 at 3:03 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > 
> > The discussion at hand is about
> > 
> >         dma_buffer->foo = 1;                    /* WB */
> >         writel(KICK, DMA_KICK_REGISTER);        /* UC */
> 
> Yes. That certainly is ordered on x86. In fact, afaik it's ordered
> even if that writel() might be of type WC, because that only delays
> writes, it doesn't move them earlier.

Ok so this is our answer ...

 ... snip ... (thanks for the background info !)

> Oh, the above UC case is absoutely guaranteed.

Good.

Then....

> The only issue really is that 99.9% of all testing gets done on x86
> unless you look at specific SoC drivers.
> 
> On ARM, for example, there is likely little reason to care about x86
> memory ordering, because there is almost zero driver overlap between
> x86 and ARM.
> 
> *Historically*, the reason for following the x86 IO ordering was
> simply that a lot of architectures used the drivers that were
> developed on x86. The alpha and powerpc workstations were *designed*
> with the x86 IO bus (PCI, then PCIe) and to work with the devices that
> came with it.
> 
> ARM? PCIe is almost irrelevant. For ARM servers, if they ever take
> off, sure. But 99.99% of ARM is about their own SoC's, and so "x86
> test coverage" is simply not an issue.
> 
> How much of an issue is it for Power? Maybe you decide it's not a big deal.
> 
> Then all the above is almost irrelevant.

So the overlap may not be that NIL in practice :-) But even then that
doesn't matter as ARM has been happily implementing the same semantic
you describe above for years, as do we powerpc.

This is why, I want (with your agreement) to define clearly and once
and for all, that the Linux semantics of writel are that it is ordered
with previous writes to coherent memory (*)

This is already what ARM and powerpc provide, from what you say, what
x86 provides, I don't see any reason to keep that badly documented and
have drivers randomly growing useless wmb()'s because they don't think
it works on x86 without them !

Once that's sorted, let's tackle the problem of mmiowb vs. spin_unlock
and the problem of writel_relaxed semantics but as separate issues :-)

Also, can I assume the above ordering with writel() equally applies to
readl() or not ?

IE:
	dma_buf->foo = 1;
	readl(STUPID_DEVICE_DMA_KICK_ON_READ);

Also works on x86 ? (It does on power, maybe not on ARM).

Cheers,
Ben.

(*) From an Linux API perspective, all of this is only valid if the
memory was allocated by dma_alloc_coherent(). Anything obtained by
dma_map_something() might have been bounced bufferred or might require
extra cache flushes on some architectures, and thus needs
dma_sync_for_{cpu,device} calls.

Cheers,
Ben.
