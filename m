From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 22:25:44 +1100
Message-ID: <1522149944.7364.50.camel@kernel.crashing.org>
References: <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <ebb36fd4-62e2-394a-219f-686c45a6dc75@codeaurora.org>
 <1522101717.7364.14.camel@kernel.crashing.org>
 <20180326222756.GJ15554@ziepe.ca>
 <CAK8P3a3a+zUNLjqw9CL5rYkXhJ-GMVTVnBU2XUu2f3njZfrqKw@mail.gmail.com>
 <1522141019.7364.43.camel@kernel.crashing.org>
 <20180327095745.GB29373@arm.com>
 <CAK8P3a0s+kP5=qEqTqAHGwB7j9ydaXD+oQJdLrFz=8swuWaDBg@mail.gmail.com>
 <20180327100944.GD29373@arm.com>
 <CAK8P3a0Xep0-EpGS9jnjUf1iJhRxH1WRztGQrvkdrLVaxBPT1w@mail.gmail.com>
 <20180327110258.GF2464@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20180327110258.GF2464@arm.com>
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
To: Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Corbet <corbet@lwn.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Sinan Kaya <okaya@codeaurora.org>, Jason Gunthorpe <jgg@ziepe.ca>, Peter Zijlstra <peterz@infradead.org>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "open
 list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2018-03-27 at 12:02 +0100, Will Deacon wrote:
>       can see it now has ownership.  Note that, when using writel(), a prior
> >       wmb() is not needed to guarantee that the cache coherent memory writes
> >       have completed before writing to the cache incoherent MMIO region.
> >       The cheaper writel_relaxed() does not guarantee the DMA to be visible
> >       to the device and must not be used here.
> 
> Fair enough. I'd rather people used _relaxed by default, but I have to admit
> that it will probably just result in them getting things wrong. Just a tiny
> bit of wordsmithing brings this to:

I prefer people using writel() by default for the simple reason that
99% of writels out there are configuration stuff for which the
performance difference doesn't matter, and people will just get it
wrong.

Let's focus on the rare fast path for optimisation.
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index a863009849a3..3247547d1c36 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -1909,9 +1909,6 @@ There are some more advanced barrier functions:
>                 /* assign ownership */
>                 desc->status = DEVICE_OWN;
>  
> -               /* force memory to sync before notifying device via MMIO */
> -               wmb();
> -
>                 /* notify device of new descriptors */
>                 writel(DESC_NOTIFY, doorbell);
>         }
> @@ -1919,11 +1916,15 @@ There are some more advanced barrier functions:
>       The dma_rmb() allows us guarantee the device has released ownership
>       before we read the data from the descriptor, and the dma_wmb() allows
>       us to guarantee the data is written to the descriptor before the device
> -     can see it now has ownership.  The wmb() is needed to guarantee that the
> -     cache coherent memory writes have completed before attempting a write to
> -     the cache incoherent MMIO region.
> -
> -     See Documentation/DMA-API.txt for more information on consistent memory.
> +     can see it now has ownership.  Note that, when using writel(), a prior
> +     wmb() is not needed to guarantee that the cache coherent memory writes
> +     have completed before writing to the MMIO region.  The cheaper
> +     writel_relaxed() does not provide this guarantee and must not be used
> +     here.
> +
> +     See the subsection "Kernel I/O barrier effects" for more information on
> +     relaxed I/O accessors and the Documentation/DMA-API.txt file for more
> +     information on consistent memory.
>  
>  
>  MMIO WRITE BARRIER
> 
> 
> If you're happy with that, I'll send it as a proper patch.
> 
> Cheers,
> 
> Will
