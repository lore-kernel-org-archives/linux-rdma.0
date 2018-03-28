From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 12:21:17 +1100
Message-ID: <1522200077.7364.85.camel@kernel.crashing.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327151029.GB17494@arm.com>
Sender: netdev-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Sinan Kaya <okaya@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Alexander Duyck <alexander.h.duyck@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>, torvalds@linux-foundation.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2018-03-27 at 16:10 +0100, Will Deacon wrote:
> To clarify: are you saying that on x86 you need a wmb() prior to a writel
> if you want that writel to be ordered after prior writes to memory? Is this
> specific to WC memory or some other non-standard attribute?
> 
> The only reason we have wmb() inside writel() on arm, arm64 and power is for
> parity with x86 because Linus (CC'd) wanted architectures to order I/O vs
> memory by default so that it was easier to write portable drivers. The
> performance impact of that implicit barrier is non-trivial, but we want the
> driver portability and I went as far as adding generic _relaxed versions for
> the cases where ordering isn't required. You seem to be suggesting that none
> of this is necessary and drivers would already run into problems on x86 if
> they didn't use wmb() explicitly in conjunction with writel, which I find
> hard to believe and is in direct contradiction with the current Linux I/O
> memory model (modulo the broken example in the dma_*mb section of
> memory-barriers.txt).

Another clarification while we are at it ....

All of this only applies to concurrent access by the CPU and the device
to memory allocate with dma_alloc_coherent().

For memory "mapped" into the DMA domain via dma_map_* then an extra
dma_sync_for_* is needed.

In most useful server cases etc... these latter are NOPs, but
architecture without full DMA cache coherency or using swiotlb,
dma_map_* might maintain bounce buffers or play additional cache
flushing tricks.

Cheers,
Ben.
