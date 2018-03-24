From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Sat, 24 Mar 2018 12:23:46 +1100
Message-ID: <1521854626.16434.359.camel@kernel.crashing.org>
References: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
 <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
 <4e5c745a-8b9b-959e-8893-d99cd6032484@codeaurora.org>
 <1521692689.16434.293.camel@kernel.crashing.org>
 <CAOSf1CFv1HHCL3YOVhRn2U=grdNjaQ=A4m3xwxN2Rek1-_TySg@mail.gmail.com>
 <1521726722.16434.312.camel@kernel.crashing.org>
 <20180323163510.GC13033@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20180323163510.GC13033@ziepe.ca>
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
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Sinan Kaya <okaya@codeaurora.org>, "open
 list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, Oliver <oohall@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2018-03-23 at 10:35 -0600, Jason Gunthorpe wrote:
> On Fri, Mar 23, 2018 at 12:52:02AM +1100, Benjamin Herrenschmidt wrote:
> 
> > > >  - Make writel_relaxed() be a simple store without barriers, and
> > > > readl_relaxed() be "eieio, read, eieio", thus allowing write combining
> > > > to happen between successive writel_relaxed on WC space (no change on
> > > > normal NC space) while maintaining the ordering between relaxed reads
> > > > and writes. The flip side is a (slight) increased overhead of
> > > > readl_relaxed.
> > > 
> > > Are there many drivers that actually do writeX() on WC space?
> > > memory-barriers.txt
> > > pretty much says that all bets are off and no ordering guarantees can be assumed
> > > when using readX/writeX on prefetchable IO memory. It seems sketchy enough to
> > > give me some pause, but maybe it works fine elsewhere.
> > 
> > I don't know whether any does it, but I want to provide a way for a
> > driver to somewhat reliably obtain write combine semantics without
> > having to hand code endian swap and other horrors involved with using
> > __raw_* accessors.
> 
> Many of the drivers in drivers/infiniband work with write combining
> memory.
> 
> The usual pattern is a desire to push 32 or 64 bytes to the WC BAR as
> efficiently as possible, ideally in a single PCI-E TLP.
> 
> A memcpy_to_wc primitive could probably cover these use cases, no need
> to redesign the IO accessors..
> 
> The WC memory is never read, so read/write order is not important to
> any infiniband driver.
> 
> What is very important is keeping the WC behavior isolated within the
> spinlock. WC to the same addresses cannot be permitted in this pattern:
> 
>    writel(addr = 0);
>    mmiowmb();
>    spin_unlock();
>    spin_lock()
>    writel(addr = 0);
> 
> The CPU must always generate two PCI-E TLPs to the device.

On powerpc you'll never get write combining with writel. So that at
least is covered.

> This is a super performance critical operation for most drivers and
> directly impacts network performance.
> 
> Jason
