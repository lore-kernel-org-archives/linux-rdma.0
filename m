From: okaya@codeaurora.org
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 07:41:16 -0400
Message-ID: <b02cc752d90c5e5ae2cc8cc4f67429a7@codeaurora.org>
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
 <bf77be28-051d-79c8-9b65-948c8a254d6d@codeaurora.org>
 <CA+55aFxULkhZGhg-tTBBxBBvXbL7QV7f6zvwW7U2wHFijqGEqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxULkhZGhg-tTBBxBBvXbL7QV7f6zvwW7U2wHFijqGEqw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alexander Duyck <alexander.duyck@gmail.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, linux-rdma@vger.kernel.org, Alexander Duyck <alexander.h.duyck@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org, linus971@gmail.com
List-Id: linux-rdma@vger.kernel.org

On 2018-03-28 02:14, Linus Torvalds wrote:
> On Tue, Mar 27, 2018 at 5:24 PM, Sinan Kaya <okaya@codeaurora.org> 
> wrote:
>> 
>> Basically changing it to
>> 
>> dma_buffer->foo = 1;                    /* WB */
>> wmb()
>> writel_relaxed(KICK, DMA_KICK_REGISTER);        /* UC */
>> mmiowb()
> 
> Why?
> 
> Why not  just remove the wmb(), and keep the barrier in the writel()?

Yes, we want to get there indeed. It is because of some arch not 
implementing writel properly. Maintainers want to play safe.

That is why I asked if IA64 and other well known archs follow the 
strongly ordered rule at this moment like PPC and ARM.

Or should we go and inform every arch about this before yanking wmb()?

Maintainers are afraid of introducing a regression.

> 
> The above code makes no sense, and just looks stupid to me. It also
> generates pointlessly bad code on x86, so it's bad there too.
> 
>                Linus
