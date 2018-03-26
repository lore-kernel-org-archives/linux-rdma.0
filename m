From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: RFC on writel and writel_relaxed
Date: Mon, 26 Mar 2018 15:09:51 -0600
Message-ID: <20180326210951.GD15554@ziepe.ca>
References: <1521692689.16434.293.camel@kernel.crashing.org>
 <CAOSf1CFv1HHCL3YOVhRn2U=grdNjaQ=A4m3xwxN2Rek1-_TySg@mail.gmail.com>
 <1521726722.16434.312.camel@kernel.crashing.org>
 <20180323163510.GC13033@ziepe.ca>
 <1521854626.16434.359.camel@kernel.crashing.org>
 <58ce5b83f40f4775bec1be8db66adb0d@AcuMS.aculab.com>
 <20180326165425.GA15554@ziepe.ca>
 <CAK8P3a1zeMyj+Z-y4ER4moY6Zip9EWNOinf+VnboGOrgiwbBZA@mail.gmail.com>
 <20180326202545.GB15554@ziepe.ca>
 <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sinan Kaya <okaya@codeaurora.org>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 26, 2018 at 10:43:43PM +0200, Arnd Bergmann wrote:
> On Mon, Mar 26, 2018 at 10:25 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > On Mon, Mar 26, 2018 at 09:44:15PM +0200, Arnd Bergmann wrote:
> >> On Mon, Mar 26, 2018 at 6:54 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >> > On Mon, Mar 26, 2018 at 11:08:45AM +0000, David Laight wrote:
> >> >> > > This is a super performance critical operation for most drivers and
> >> >> > > directly impacts network performance.
> >> >>
> >> >> Perhaps there ought to be writel_nobarrier() (etc) that never contain
> >> >> any barriers at all.
> >> >> This might mean that they are always just the memory operation,
> >> >> but it would make it more obvious what the driver was doing.
> >> >
> >> > I think that is what writel_relaxed is supposed to be.
> >> >
> >> > The only restriction it has is that the writes to a single device
> >> > using UC memory must be kept in program order..
> >>
> >> Not sure about whether we have ever defined what happens to
> >> writel_relaxed() on WC memory though: On ARM, we disallow
> >> the compiler to combine writes, but the CPU still might.
> >
> > If the driver uses WC memory then I think it should not expect
> > anything in terms of how writes map to TLPs other than nothing
> > combines across mmiowb() and mmiowb() is fully globally ordered when
> > enclosed in a spinlock.
> >
> > The entire point of using WC memory is usually to get combining :) If
> > the driver doesn't want that then it should map UC..
> 
> Usually, WC memory is used with memcpy_toio() though, which
> by definition doesn't have any barriers between accesses, and
> is required to get the correct byte ordering on writes to memory buffers.

memcpy_toio is too expensive to actually use for anything performance
though. It is too pessimistic. What the drivers usually want is a
unwound block of 4 or 8 8-byte copies. No function calls, no
branching. Everything is already known to be aligned.

Most of the drivers have a unwound loop with writeq() or something to
do it.

> > The same document says that _relaxed() does not give that guarentee.
> >
> > The lwn articule on this went into some depth on the interaction with
> > spinlocks.
> >
> > As far as I can see, containment in a spinlock seems to be the only
> > different between writel and writel_relaxed..
> 
> I was always puzzled by this: The intention of _relaxed() on ARM
> (where it originates) was to skip the barrier that serializes DMA
> with MMIO, not to skip the serialization between MMIO and locks.

But that was never a requirement of writel(),
Documentation/memory-barriers.txt gives an explicit example demanding
the wmb() before writel() for ordering system memory against writel.

I actually have no idea why ARM had that barrier, I always assumed it
was to give program ordering to the accesses and that _relaxed allowed
re-ordering (the usual meaning of relaxed)..

But the barrier document makes it pretty clear that the only
difference between the two is spinlock containment, and WillD wrote
this text, so I belive it is accurate for ARM.

Very confusing.

> I never fully understood the part about the locks, but from what
> I remember, ARM is still serialized without the barrier here, but
> dropping the barrier on powerpc writel_relaxed() would not
> serialize against locks or DMA.

WC is usually the problem here.. I've been told it is necessary on ARM
as well..

Jason
