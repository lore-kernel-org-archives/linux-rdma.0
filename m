From: Will Deacon <will.deacon@arm.com>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 10:07:11 +0100
Message-ID: <20180328090710.GB28871@arm.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1522219376.7364.109.camel@kernel.crashing.org>
Sender: netdev-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Duyck <alexander.duyck@gmail.com>, Sinan Kaya <okaya@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 28, 2018 at 05:42:56PM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2018-03-27 at 20:26 -1000, Linus Torvalds wrote:
> > On Tue, Mar 27, 2018 at 6:33 PM, Benjamin Herrenschmidt
> > <benh@kernel.crashing.org> wrote:
> > > 
> > > This is why, I want (with your agreement) to define clearly and once
> > > and for all, that the Linux semantics of writel are that it is ordered
> > > with previous writes to coherent memory (*)
> > 
> > Honestly, I think those are the sane semantics. In fact, make it
> > "ordered with previous writes" full stop, since it's not only ordered
> > wrt previous writes to memory, but also previous writel's.
> 
> Of course. It was somewhat a given that it's ordered vs. any previous
> MMIO actually, but it doesn't hurt to spell it out once more.

Good. So I think this confirms our understanding so far.

> 
> > > Also, can I assume the above ordering with writel() equally applies to
> > > readl() or not ?
> > > 
> > > IE:
> > >         dma_buf->foo = 1;
> > >         readl(STUPID_DEVICE_DMA_KICK_ON_READ);
> > 
> > If that KICK_ON_READ is UC, then that's definitely the case. And
> > honestly, status registers like that really should always be UC.
> > 
> > But if somebody sets the area WC (which is crazy), then I think it
> > might be at least debatable. x86 semantics does allow reads to be done
> > before previous writes (or, put another way, writes to be buffered -
> > the buffers are ordered so writes don't get re-ordered, but reads can
> > happen during the buffering).
> 
> Right, for now I worry about UC semantics. Once we have nailed that, we
> can look at WC, which is a lot more tricky as archs differs more
> widely, but one thing at a time.
> 
> > But UC accesses are always  done entirely ordered, and honestly, any
> > status register that starts a DMA would not make sense any other way.
> > 
> > Of course, you'd have to be pretty odd to want to start a DMA with a
> > read anyway - partly exactly because it's bad for performance since
> > reads will be synchronous and not buffered like a write).
> 
> I have bad memories of old adaptec controllers ...
> 
> That said, I think the above might not be right on ARM if we want to
> make it the rule, Will, what do you reckon ?

So there are two cases to consider:

1.
	if (readl(DEVICE_DMA_STATUS) == DMA_DONE)
		mydata = *dma_bufp;



2.
	*dma_bufp = 42;
	readl(DEVICE_DMA_KICK_ON_READ);


For arm/arm64 we guarantee ordering for (1) but not for (2) -- you'd need to
add an mb() to make it work.

Do both of these work on power? If so, I guess I can make readl even more
expensive :/ Feels a bit like the tail wagging the dog, though.

Another thing I just realised is that we restrict the barriers we use in
readl/writel on arm64 so that they don't necessary apply to both loads and
stores. To be specific:

   writel is ordered against prior writes to memory, but not reads

   readl is ordered against subsequent reads of memory, but not writes (but
   note that in example (1) above, the control dependency ensures that).

If necessary, I could move the barrier in our readl implementation to be
before the read, then play the control-dependency + instruction-sync (ISB)
trick that you do on power.

Will
