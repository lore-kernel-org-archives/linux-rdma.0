From: Will Deacon <will.deacon@arm.com>
Subject: Re: RFC on writel and writel_relaxed
Date: Mon, 26 Mar 2018 12:44:49 +0100
Message-ID: <20180326114449.GC6579@arm.com>
References: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
 <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
 <4e5c745a-8b9b-959e-8893-d99cd6032484@codeaurora.org>
 <1521692689.16434.293.camel@kernel.crashing.org>
 <CAOSf1CFv1HHCL3YOVhRn2U=grdNjaQ=A4m3xwxN2Rek1-_TySg@mail.gmail.com>
 <1521726722.16434.312.camel@kernel.crashing.org>
 <5ccdb208-4664-0a7f-df5d-2e12cbe4c239@codeaurora.org>
 <1521764168.16434.324.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <1521764168.16434.324.camel@kernel.crashing.org>
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
Cc: Sinan Kaya <okaya@codeaurora.org>, linuxppc dev list <linuxppc-dev@lists.ozlabs.org>, Oliver <oohall@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ben,

I don't seem to have the beginning of this thread, so please bounce it over
if you'd like me to look at it!

On Fri, Mar 23, 2018 at 11:16:08AM +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2018-03-22 at 12:51 -0500, Sinan Kaya wrote:
> > On 3/22/2018 8:52 AM, Benjamin Herrenschmidt wrote:
> > > > > No, it's not sufficient.
> > > 
> > > Just to clarify ... barrier() is just a compiler barrier, it means the
> > > compiler will generate things in the order they are written. This isn't
> > > sufficient on archs with an OO memory model, where an actual memory
> > > barrier instruction needs to be emited.
> > 
> > Surprisingly, ARM64 GCC compiler generates a write barrier as
> > opposed to preventing code reordering.

In context, this looks like a misunderstanding somewhere. barrier() is a
compiler barrier for us just like everybody else and we use the generic
implementation with the empty asm + memory clobber.

> > I was curious if this is an ARM only thing or not. 
> 
> Are you sure of that ? I thought it's the ARM implementation of writel
> that had an explicit write barrier in it:
> 
> #define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c)); })
> 
> And __iowmb() is 
> 
> #define __iowmb()		wmb()
> 
> Note, I'm a bit dubious about this in ARM:
> 
> #define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(); __v; }
> 
> Will, Marc, on powerpc, we put a sync *before* the read in readl etc...
> 
> The reasoning was there could be some DMA setup followed by a side
> effect readl rather than a side effect writel to trigger a DMA. Granted
> I wouldn't expect modern devices to be that stupid, but I have vague
> memory of some devices back in the day having that sort of read ops.

The reason we have it afterwards was for something like:

	while (!(readl(&status_register) & DMA_DONE))
		data = *dma_buffer

to ensure that we don't read stale data from the buffer. You might also
need this for systems with spurious/early IRQ delivery for DMA completion.

You'd have to throw in an explicit mb() if you wanted to order prior writel
before the side-effectcs of a a later readl.

> In general, I though the model offerred by x86 and thus by Linux
> readl/writel was full synchronization both before and after the MMIO,
> vs either other MMIO or all other forms of ops (cachable memory, locks
> etc...).
> 
> Also, can't the above readl_relaxed leak out of a lock ?

No, it's ordered with respect to the release store to the lockword but
that doesn't mean that an unlock does anything like ensure that the read
has been satisifed (in particular, for your scenario above where it has
side-effects then unlocking the lock doesn't guarantee that they've
occurred).

Will
