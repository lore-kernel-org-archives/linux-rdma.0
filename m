From: Gabriel Paubert <paubert@iram.es>
Subject: Re: RFC on writel and writel_relaxed
Date: Thu, 22 Mar 2018 12:25:21 +0100
Message-ID: <20180322112521.zlfnhnp4qanxqejn@lt-gp.iram.es>
References: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
 <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
 <4e5c745a-8b9b-959e-8893-d99cd6032484@codeaurora.org>
 <8a13375fd8e5439890768b7dd8473099@AcuMS.aculab.com>
 <CAOSf1CHTouXQ+sPxu7ySCtw--maef+knFC9bCQ7rpuk-hf-puQ@mail.gmail.com>
 <20180322082041.hvaneyfpzdwelely@lt-gp.iram.es>
 <CAOSf1CE+gsoZB-YNYdx=oNmrdCje4yxiz76hSb4UQ4F5cL8SqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <CAOSf1CE+gsoZB-YNYdx=oNmrdCje4yxiz76hSb4UQ4F5cL8SqQ@mail.gmail.com>
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
Cc: Sinan Kaya <okaya@codeaurora.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, David Laight <David.Laight@aculab.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 22, 2018 at 08:25:43PM +1100, Oliver wrote:
> On Thu, Mar 22, 2018 at 7:20 PM, Gabriel Paubert <paubert@iram.es> wrote:
> > On Thu, Mar 22, 2018 at 04:24:24PM +1100, Oliver wrote:
> >> On Thu, Mar 22, 2018 at 1:35 AM, David Laight <David.Laight@aculab.com> wrote:
> >> >> x86 has compiler barrier inside the relaxed() API so that code does not
> >> >> get reordered. ARM64 architecturally guarantees device writes to be observed
> >> >> in order.
> >> >
> >> > There are places where you don't even need a compile barrier between
> >> > every write.
> >> >
> >> > I had horrid problems getting some ppc code (for a specific embedded SoC)
> >> > optimised to have no extra barriers.
> >> > I ended up just writing through 'pointer to volatile' and adding an
> >> > explicit 'eieio' between the block of writes and status read.
> >>
> >> This is what you are supposed to do. For accesses to MMIO (cache
> >> inhibited + guarded) storage the Power ISA guarantees that load-load
> >> and store-store pairs of accesses will always occur in program order,
> >> but there's no implicit ordering between load-store or store-load
> >
> > And even for load store, eieio is not always necessary, in the important
> > case of reading and writing to the same address, when modifying bits in
> > a control register for example.
> >
> > Typically also loads will be moved ahead of stores, but not the other
> > way around, so in practice you won't notice a missed eieio in this case.
> > This does not mean you should not insert it.
> 
> Yep, but it doesn't really help us here. The generic accessors need to cope
> with the general case.

A generic accessor for modifying fields in a device register might be an 
useful addition to the current set. This is a fairly frequent operation.

Actually I did add macros to do exactly this in drivers for our own 
hardware here almost 20 years ago. I was fed up with writing
writel(readl(reg) & mask | value, reg), especially when reg was not
that simple (one device had over 100 registers). The macros obviously 
guaranteed that both accesses would be to the same register, something 
easy to get wrong with cut and paste.

> 
> >> pairs. In those cases you need an explicit eieio barrier between the
> >> two accesses. At the HW level you can think of the CPU as having
> >> separate queues for MMIO loads and stores. Accesses will be added to
> >> the respective queue in program order, but there's no synchronisation
> >> between the two queues. If the CPU is doing write combining it's easy
> >> to imagine the whole store queue being emptied in one big gulp before
> >> the load queue is even touched.
> >
> > Is write combining allowed on guarded storage?
> >
> > <Looking at docs>
> > From PowerISA_V3.0.pdf, Book2, section 1.6.2 "Caching inhibited":
> >
> > "No combining occurs if the storage is also Guarded"
> 
> Yeah it's not allowed. That's what I get for handwaving examples ;)

At least it means that, for cache-inhibited guarded storage, there is a 
one to one correspondance between instructions and bus cycles. The only 
issue left is ordering ;)

	Gabriel
