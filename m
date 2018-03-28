From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 17:56:05 +1100
Message-ID: <1522220165.7364.110.camel@kernel.crashing.org>
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
         <1522211620.7364.94.camel@kernel.crashing.org>
         <CA+55aFw24R3YAujir59GdG+sBBQOA9WyXySEN3AcEYK99ZHuwQ@mail.gmail.com>
         <1522219376.7364.109.camel@kernel.crashing.org>
         <CA+55aFyaZ=WEXFg4KZ0yCWaR=8Dm_FPK-xcA0EYi3fEzm+KZkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyaZ=WEXFg4KZ0yCWaR=8Dm_FPK-xcA0EYi3fEzm+KZkA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, Will Deacon <will.deacon@arm.com>, Sinan Kaya <okaya@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2018-03-28 at 06:53 +0000, Linus Torvalds wrote:
> 
> 
> On Tue, Mar 27, 2018, 20:43 Benjamin Herrenschmidt <benh@kernel.crash
> ing.org> wrote:
> > >
> > > Of course, you'd have to be pretty odd to want to start a DMA
> > with a
> > > read anyway - partly exactly because it's bad for performance
> > since
> > > reads will be synchronous and not buffered like a write).
> > 
> > I have bad memories of old adaptec controllers ...
> 
> *Old* adaptec controllers were likely to use the in/out instructions
> for status and command data.
> 
> Those are actually even more ordered than UC reads and writes: the
> in/out instructions are not just fully ordered, but are fully
> *synchronous* on x86. 
> 
> So not just doing accesses in order, but actually waiting for
> everything to drain before they start executing, but they also wait
> for the operation itself to complete (ie "out" will not just queue
> the write, it will then wait for the queue to empty and the write
> data to hit the line).
> 
> That's why in/out were *so* slow, and why nobody uses them any more
> (well, the address size limitations and the lack of any remapping of
> the address obviously also are a reason).

All true indeed, though a lot of other archs never quite made them
fully synchronous, which was another can of worms ... oh well.

As for Adaptec, you might be right, I do remember having cases of old
stuff triggering DMA on reads, it might have been "Mac" variants of
Adaptec using MMIO or something...

Cheers,
Ben.
