From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 23:24:50 -0400
Message-ID: <bf77be28-051d-79c8-9b65-948c8a254d6d@codeaurora.org>
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
 <CAKgT0Uem6HT-Z=HBnSVcC4rnDL0yFyXEbr+FN3YYkJ=ExZpUPQ@mail.gmail.com>
 <1522186396.7364.61.camel@kernel.crashing.org>
 <CA+55aFw2R4pirO0m+jtj4F8AF2-tVi3guEaWOA-EBqNyFmh29w@mail.gmail.com>
 <1522198981.7364.81.camel@kernel.crashing.org>
 <CA+55aFyTeuXPmC5-1JGh2ow-rf5wMA6Vcv0aeS_q0_EnptSK9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyTeuXPmC5-1JGh2ow-rf5wMA6Vcv0aeS_q0_EnptSK9Q@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Alexander Duyck <alexander.h.duyck@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 3/27/2018 10:51 PM, Linus Torvalds wrote:
>> The discussion at hand is about
>>
>>         dma_buffer->foo = 1;                    /* WB */
>>         writel(KICK, DMA_KICK_REGISTER);        /* UC */
> Yes. That certainly is ordered on x86. In fact, afaik it's ordered
> even if that writel() might be of type WC, because that only delays
> writes, it doesn't move them earlier.

Now that we clarified x86 myth, Is this guaranteed on all architectures?
We keep getting IA64 exception example. Maybe, this is also corrected since
then.

Jose Abreu says "I don't know about x86 but arc architecture doesn't
have a wmb() in the writel() function (in some configs)".

As long as we have these exceptions, these wmb() in common drivers is not
going anywhere and relaxed-arches will continue paying performance penalty.

I see 15% performance loss on ARM64 servers using Intel i40e network
drivers and an XL710 adapter due to CPU keeping itself busy doing barriers
most of the time rather than real work because of sequences like this all over
the place.

         dma_buffer->foo = 1;                    /* WB */
	 wmb()
         writel(KICK, DMA_KICK_REGISTER);        /* UC */

I posted several patches last week to remove duplicate barriers on ARM while
trying to make the code friendly with other architectures.

Basically changing it to

dma_buffer->foo = 1;                    /* WB */
wmb()
writel_relaxed(KICK, DMA_KICK_REGISTER);        /* UC */
mmiowb()

This is a small step in the performance direction until we remove all exceptions.

https://www.spinics.net/lists/netdev/msg491842.html
https://www.spinics.net/lists/linux-rdma/msg62434.html
https://www.spinics.net/lists/arm-kernel/msg642336.html

Discussion started to move around the need for relaxed API on PPC and then
why wmb() question came up.

Sinan

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
