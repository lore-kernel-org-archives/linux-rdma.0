From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 10:46:58 -0400
Message-ID: <1e077f6a-90b6-cce9-6f0f-a8c003fec850@codeaurora.org>
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
 <20180326210951.GD15554@ziepe.ca>
 <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <1522101616.7364.13.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522101616.7364.13.camel@kernel.crashing.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Alexander Duyck <alexander.h.duyck@redhat.com>, Will Deacon <will.deacon@arm.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>
List-Id: linux-rdma@vger.kernel.org

+netdev, +Alex

On 3/26/2018 6:00 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2018-03-26 at 23:30 +0200, Arnd Bergmann wrote:
>>  Most of the drivers have a unwound loop with writeq() or something to
>>> do it.
>>
>> But isn't the writeq() barrier much more expensive than anything you'd
>> do in function calls?
> 
> It is for us, and will break any write combining.
> 
>>>>> The same document says that _relaxed() does not give that guarentee.
>>>>>
>>>>> The lwn articule on this went into some depth on the interaction with
>>>>> spinlocks.
>>>>>
>>>>> As far as I can see, containment in a spinlock seems to be the only
>>>>> different between writel and writel_relaxed..
>>>>
>>>> I was always puzzled by this: The intention of _relaxed() on ARM
>>>> (where it originates) was to skip the barrier that serializes DMA
>>>> with MMIO, not to skip the serialization between MMIO and locks.
>>>
>>> But that was never a requirement of writel(),
>>> Documentation/memory-barriers.txt gives an explicit example demanding
>>> the wmb() before writel() for ordering system memory against writel.
> 
> This is a bug in the documentation.
> 
>> Indeed, but it's in an example for when to use dma_wmb(), not wmb().
>> Adding Alexander Duyck to Cc, he added that section as part of
>> 1077fa36f23e ("arch: Add lightweight memory barriers dma_rmb() and
>> dma_wmb()"). Also adding the other people that were involved with that.
> 
> Linus himself made it very clear years ago. readl and writel have to
> order vs memory accesses.
> 
>>> I actually have no idea why ARM had that barrier, I always assumed it
>>> was to give program ordering to the accesses and that _relaxed allowed
>>> re-ordering (the usual meaning of relaxed)..
>>>
>>> But the barrier document makes it pretty clear that the only
>>> difference between the two is spinlock containment, and WillD wrote
>>> this text, so I belive it is accurate for ARM.
>>>
>>> Very confusing.
>>
>> It does mention serialization with both DMA and locks in the
>> section about  readX_relaxed()/writeX_relaxed(). The part
>> about DMA is very clear here, and I must have just forgotten
>> the exact semantics with regards to spinlocks. I'm still not
>> sure what prevents a writel() from leaking out the end of a
>> spinlock section that doesn't happen with writel_relaxed(), since
>> the barrier in writel() comes before the access, and the
>> spin_unlock() shouldn't affect the external buses.
> 
> So...
> 
> Historically, what happened is that we (we means whoever participated
> in the discussion on the list with Linus calling the shots really)
> decided that there was no sane way for drivers to understand a world
> where readl/writel didn't fully order things vs. memory accesses (ie,
> DMA).
> 
> So it should always be correct to do:
> 
> 	- Write to some in-memory buffer
> 	- writel() to kick the DMA read of that buffer
> 
> without any extra barrier.
> 
> The spinlock situation however got murky. Mostly that came up because
> on architecture (I forgot who, might have been ia64) has a hard time
> providing that consistency without making writel insanely expensive.
> 
> Thus they created mmiowb whose main purpose was precisely to order
> writel with a following spin_unlock.
> 
> I decided not to go down that path on power because getting all drivers
> "fixed" to do the right thing was going to be a losing battle, and
> instead added per-cpu tracking of writel in order to "escalate" to a
> heavier barrier in spin_unlock itself when necessary.
> 
> Now, all this happened more than a decade ago and it's possible that
> the understanding or expectations "shifted" over time...

Alex is raising concerns on the netdev list.

Sinan
"We are being told that if you use writel(), then you don't need a wmb() on
all architectures."

Alex:
"I'm not sure who told you that but that is incorrect, at least for
x86. If you attempt to use writel() without the wmb() we will have to
NAK the patches. We will accept the wmb() with writel_releaxed() since
that solves things for ARM."

> Jason is seeking behavior clarification for write combined buffers.

Alex:
"Don't bother. I can tell you right now that for x86 you have to have a
wmb() before the writel().

Based on the comment in
(https://www.spinics.net/lists/linux-rdma/msg62666.html):
    Replacing wmb() + writel() with wmb() + writel_relaxed() will work on
    PPC, it will just not give you a benefit today.

I say the patch set stays. This gives benefit on ARM, and has no
effect on x86 and PowerPC. If you want to look at trying to optimize
things further on PowerPC and such then go for it in terms of trying
to implement the writel_relaxed(). Otherwise I say we call the ARM
goodness a win and don't get ourselves too wrapped up in trying to fix
this for all architectures."



> 
> Cheers,
> Ben.
>  
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
