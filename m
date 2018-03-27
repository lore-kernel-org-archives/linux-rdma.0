From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 12:53:49 +0200
Message-ID: <CAK8P3a0Xep0-EpGS9jnjUf1iJhRxH1WRztGQrvkdrLVaxBPT1w@mail.gmail.com>
References: <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
 <20180326210951.GD15554@ziepe.ca>
 <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <ebb36fd4-62e2-394a-219f-686c45a6dc75@codeaurora.org>
 <1522101717.7364.14.camel@kernel.crashing.org>
 <20180326222756.GJ15554@ziepe.ca>
 <CAK8P3a3a+zUNLjqw9CL5rYkXhJ-GMVTVnBU2XUu2f3njZfrqKw@mail.gmail.com>
 <1522141019.7364.43.camel@kernel.crashing.org>
 <20180327095745.GB29373@arm.com>
 <CAK8P3a0s+kP5=qEqTqAHGwB7j9ydaXD+oQJdLrFz=8swuWaDBg@mail.gmail.com>
 <20180327100944.GD29373@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20180327100944.GD29373@arm.com>
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
To: Will Deacon <will.deacon@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Sinan Kaya <okaya@codeaurora.org>, Jason Gunthorpe <jgg@ziepe.ca>, Peter Zijlstra <peterz@infradead.org>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 27, 2018 at 12:09 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Tue, Mar 27, 2018 at 12:05:06PM +0200, Arnd Bergmann wrote:
>> > -
>> > -     See Documentation/DMA-API.txt for more information on consistent memory.
>> > +     can see it now has ownership.  Note that, when using writel(), a prior
>> > +     wmb() is not needed to guarantee that the cache coherent memory writes
>> > +     have completed before writing to the cache incoherent MMIO region.
>> > +     If this ordering between incoherent MMIO and coherent memory regions

One more thing: I think the term "incoherent MMIO" is a bit confusing, I'd
prefer just "MMIO" here. At least I don't have the faintest clue what the
difference between "coherent MMIO" and "incoherent MMIO" would be ;-)

>> > +     is not required, writel_relaxed() can be used instead and is significantly
>> > +     cheaper on some weakly-ordered architectures.
>>
>> I think that's a great improvement, but I'm a bit worried about recommending
>> writel_relaxed() too much: I've seen a lot of drivers that just always use
>> writel_relaxed() over write(), and some of them get that wrong when they
>> don't understand the difference but end up using DMA without explicit
>> barriers anyway.
>>
>> Also, having an architecture-independent driver use wmb()+writel_relaxed()
>> ends up being more expensive than just using write(). Not sure how to
>> best phrase it though.
>
> Perhaps I add reword that with a simple example to say:
>
>   If this ordering between incoherent MMIO and coherent memory regions
>   is not required (e.g. in a sequence of accesses all to the MMIO region)
>   [...]
>
> since that seems to be the usual case where the _relaxed accessors help.

That still doesn't quite capture what I'd like driver writes to do: in essence
I would recommend them to use writel() all the time, except in performance
critical code that has been shown to be correct and has a comment to explain
why _relaxed() is ok in that particular function.

Maybe it can just be rephrased to warn against the use of writel_relaxed()
here, and explain the difference that way:

     can see it now has ownership.  Note that, when using writel(), a prior
     wmb() is not needed to guarantee that the cache coherent memory writes
     have completed before writing to the cache incoherent MMIO region.
     The cheaper writel_relaxed() does not guarantee the DMA to be visible
     to the device and must not be used here.

       Arnd
