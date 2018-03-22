From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Fri, 23 Mar 2018 00:52:02 +1100
Message-ID: <1521726722.16434.312.camel@kernel.crashing.org>
References: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
 <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
 <4e5c745a-8b9b-959e-8893-d99cd6032484@codeaurora.org>
 <1521692689.16434.293.camel@kernel.crashing.org>
 <CAOSf1CFv1HHCL3YOVhRn2U=grdNjaQ=A4m3xwxN2Rek1-_TySg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CAOSf1CFv1HHCL3YOVhRn2U=grdNjaQ=A4m3xwxN2Rek1-_TySg@mail.gmail.com>
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
To: Oliver <oohall@gmail.com>
Cc: Sinan Kaya <okaya@codeaurora.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "open list:LINUX FOR POWERPC (32-BIT
 AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2018-03-22 at 21:15 +1100, Oliver wrote:
> On Thu, Mar 22, 2018 at 3:24 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Wed, 2018-03-21 at 08:53 -0500, Sinan Kaya wrote:
> > > writel_relaxed() needs to have ordering guarantees with respect to the order
> > > device observes writes.
> > 
> > Correct.
> > 
> > > x86 has compiler barrier inside the relaxed() API so that code does not
> > > get reordered. ARM64 architecturally guarantees device writes to be observed
> > > in order.
> > > 
> > > I was hoping that PPC could follow x86 and inject compiler barrier into the
> > > relaxed functions.
> > > 
> > > BTW, I have no idea what compiler barrier does on PPC and if
> > > 
> > > wrltel() == compiler barrier() + wrltel_relaxed()
> > > 
> > > can be said.
> > 
> > No, it's not sufficient.

Just to clarify ... barrier() is just a compiler barrier, it means the
compiler will generate things in the order they are written. This isn't
sufficient on archs with an OO memory model, where an actual memory
barrier instruction needs to be emited.

As for Oliver comments...

> > Replacing wmb() + writel() with wmb() + writel_relaxed() will work on
> > PPC, it will just not give you a benefit today.
> > 
> > The main problem is that the semantics of writel/writel_relaxed (and
> > read versions) aren't very well defined in Linux esp. when it comes
> > to different memory types (NC, WC, ...).
> > 
> > I've been wanting to implement the relaxed accessors for a while but
> > was battling with this to try to also better support WC, and due to
> > other commitments, this somewhat fell down the cracks.
> > 
> > Two options I can think of:
> > 
> >  - Just make the _relaxed variants use an eieio instead of a sync, this
> > will effectively lift the ordering guarantee vs. cachable storage (and
> > thus unlock) and might give a (small) performance improvement.
> 
> Wouldn't we still have the unlock ordering due to the io_sync hack or
> are you thinking we should remove that too for the relaxed version?

Well, the documentation says we don't care about synchronization vs.
locks so we should probably remove it (then we need to make sure mmiowb
works, thus sets the flag).

> > However,
> > we still have the problem that on WC mappings, neither writel nor
> > writel_relaxed will effectively allow combining to happen (only raw
> > accesses will because on powerpc *all* barriers will break combining).
> 
> Hmm, eieio is only architected to affect CI+G (and WT) so it shouldn't
> affect combining
> on non-guarded memory. Do most implementations apply it to all CI
> accesses anyway?

Yes, as far as I know all implementations will stop combining on *any*
barrier instruction.

> >  - Make writel_relaxed() be a simple store without barriers, and
> > readl_relaxed() be "eieio, read, eieio", thus allowing write combining
> > to happen between successive writel_relaxed on WC space (no change on
> > normal NC space) while maintaining the ordering between relaxed reads
> > and writes. The flip side is a (slight) increased overhead of
> > readl_relaxed.
> 
> Are there many drivers that actually do writeX() on WC space?
> memory-barriers.txt
> pretty much says that all bets are off and no ordering guarantees can be assumed
> when using readX/writeX on prefetchable IO memory. It seems sketchy enough to
> give me some pause, but maybe it works fine elsewhere.

I don't know whether any does it, but I want to provide a way for a
driver to somewhat reliably obtain write combine semantics without
having to hand code endian swap and other horrors involved with using
__raw_* accessors.

So my thinking is to define that the combination of WC + writel_relaxed
gives you that, which it does at least on x86 and ARM afaik.

Cheers,
Ben.
