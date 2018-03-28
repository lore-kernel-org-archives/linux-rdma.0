From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 16:51:58 -1000
Message-ID: <CA+55aFyTeuXPmC5-1JGh2ow-rf5wMA6Vcv0aeS_q0_EnptSK9Q@mail.gmail.com>
References: <1521854626.16434.359.camel@kernel.crashing.org>
 <58ce5b83f40f4775bec1be8db66adb0d@AcuMS.aculab.com> <20180326165425.GA15554@ziepe.ca>
 <CAK8P3a1zeMyj+Z-y4ER4moY6Zip9EWNOinf+VnboGOrgiwbBZA@mail.gmail.com>
 <20180326202545.GB15554@ziepe.ca> <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
 <20180326210951.GD15554@ziepe.ca> <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <1522101616.7364.13.camel@kernel.crashing.org> <1e077f6a-90b6-cce9-6f0f-a8c003fec850@codeaurora.org>
 <20180327151029.GB17494@arm.com> <CAKgT0Uem6HT-Z=HBnSVcC4rnDL0yFyXEbr+FN3YYkJ=ExZpUPQ@mail.gmail.com>
 <1522186396.7364.61.camel@kernel.crashing.org> <CA+55aFw2R4pirO0m+jtj4F8AF2-tVi3guEaWOA-EBqNyFmh29w@mail.gmail.com>
 <1522198981.7364.81.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522198981.7364.81.camel@kernel.crashing.org>
Sender: netdev-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, Will Deacon <will.deacon@arm.com>, Sinan Kaya <okaya@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Alexander Duyck <alexander.h.duyck@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 27, 2018 at 3:03 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> The discussion at hand is about
>
>         dma_buffer->foo = 1;                    /* WB */
>         writel(KICK, DMA_KICK_REGISTER);        /* UC */

Yes. That certainly is ordered on x86. In fact, afaik it's ordered
even if that writel() might be of type WC, because that only delays
writes, it doesn't move them earlier.

Whether people *do* that or not, I don't know. But I wouldn't be
surprised if they do.

So if it's a DMA buffer, it's "cached". And even cached accesses are
ordered wrt MMIO.

Basically, to get unordered writes on x86, you need to either use
explicitly nontemporal stores, or have a writecombining region with
back-to-back writes that actually combine.

And nobody really does that nontemporal store thing any more because
the hardware that cared pretty much doesn't exist any more. It was too
much pain. People use DMA and maybe an UC store for starting the DMA
(or possibly a WC buffer that gets multiple  stores in ascending order
as a stream of commands).

Things like UC will force everything to be entirely ordered, but even
without UC, loads won't pass loads, and stores won't pass stores.

> Now it appears that this wasn't fully understood back then, and some
> people are now saying that x86 might not even provide that semantic
> always.

Oh, the above UC case is absoutely guaranteed.

And I think even if it's WC, the write to kick off the DMA is ordered
wrt the cached write.

On x86, I think you need barriers only if you do things like

 - do two non-temporal stores and require them to be ordered: put a
sfence or mfence in between them.

 - do two WC stores, and make sure they do not combine: put a sfence
or mfence between them.

 - do a store, and a subsequent from a different address, and neither
of them is UC: put a mfence between them. But note that this is
literally just "load after store". A "store after load" doesn't need
one.

I think that's pretty much it.

For example, the "lfence" instruction is almost entirely pointless on
x86 - it was designed back in the time when people *thought* they
might re-order loads. But loads don't get re-ordered. At least Intel
seems to document that only non-temporal *stores* can get re-ordered
wrt each other.

End result: lfence is a historical oddity that can now be used to
guarantee that a previous  load has finished, and that in turn meant
that it is  now used in the Spectre mitigations. But it basically has
no real memory ordering meaning since nothing passes an earlier load
anyway, it's more of a pipeline thing.

But in the end, one question is just "how much do drivers actually
_rely_ on the x86 strong ordering?"

We so support "smp_wmb()" even though x86 has strong enough ordering
that just a barrier suffices. Somebody might just say "screw the x86
memory ordering, we're relaxed, and we'll fix up the drivers we care
about".

The only issue really is that 99.9% of all testing gets done on x86
unless you look at specific SoC drivers.

On ARM, for example, there is likely little reason to care about x86
memory ordering, because there is almost zero driver overlap between
x86 and ARM.

*Historically*, the reason for following the x86 IO ordering was
simply that a lot of architectures used the drivers that were
developed on x86. The alpha and powerpc workstations were *designed*
with the x86 IO bus (PCI, then PCIe) and to work with the devices that
came with it.

ARM? PCIe is almost irrelevant. For ARM servers, if they ever take
off, sure. But 99.99% of ARM is about their own SoC's, and so "x86
test coverage" is simply not an issue.

How much of an issue is it for Power? Maybe you decide it's not a big deal.

Then all the above is almost irrelevant.

       Linus
