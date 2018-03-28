From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 20:26:04 -1000
Message-ID: <CA+55aFw24R3YAujir59GdG+sBBQOA9WyXySEN3AcEYK99ZHuwQ@mail.gmail.com>
References: <1521854626.16434.359.camel@kernel.crashing.org>
 <58ce5b83f40f4775bec1be8db66adb0d@AcuMS.aculab.com> <20180326165425.GA15554@ziepe.ca>
 <CAK8P3a1zeMyj+Z-y4ER4moY6Zip9EWNOinf+VnboGOrgiwbBZA@mail.gmail.com>
 <20180326202545.GB15554@ziepe.ca> <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
 <20180326210951.GD15554@ziepe.ca> <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <1522101616.7364.13.camel@kernel.crashing.org> <1e077f6a-90b6-cce9-6f0f-a8c003fec850@codeaurora.org>
 <20180327151029.GB17494@arm.com> <CAKgT0Uem6HT-Z=HBnSVcC4rnDL0yFyXEbr+FN3YYkJ=ExZpUPQ@mail.gmail.com>
 <1522186396.7364.61.camel@kernel.crashing.org> <CA+55aFw2R4pirO0m+jtj4F8AF2-tVi3guEaWOA-EBqNyFmh29w@mail.gmail.com>
 <1522198981.7364.81.camel@kernel.crashing.org> <CA+55aFyTeuXPmC5-1JGh2ow-rf5wMA6Vcv0aeS_q0_EnptSK9Q@mail.gmail.com>
 <1522211620.7364.94.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522211620.7364.94.camel@kernel.crashing.org>
Sender: netdev-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>, Will Deacon <will.deacon@arm.com>, Sinan Kaya <okaya@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 27, 2018 at 6:33 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> This is why, I want (with your agreement) to define clearly and once
> and for all, that the Linux semantics of writel are that it is ordered
> with previous writes to coherent memory (*)

Honestly, I think those are the sane semantics. In fact, make it
"ordered with previous writes" full stop, since it's not only ordered
wrt previous writes to memory, but also previous writel's.

> Also, can I assume the above ordering with writel() equally applies to
> readl() or not ?
>
> IE:
>         dma_buf->foo = 1;
>         readl(STUPID_DEVICE_DMA_KICK_ON_READ);

If that KICK_ON_READ is UC, then that's definitely the case. And
honestly, status registers like that really should always be UC.

But if somebody sets the area WC (which is crazy), then I think it
might be at least debatable. x86 semantics does allow reads to be done
before previous writes (or, put another way, writes to be buffered -
the buffers are ordered so writes don't get re-ordered, but reads can
happen during the buffering).

But UC accesses are always  done entirely ordered, and honestly, any
status register that starts a DMA would not make sense any other way.

Of course, you'd have to be pretty odd to want to start a DMA with a
read anyway - partly exactly because it's bad for performance since
reads will be synchronous and not buffered like a write).

                   Linus
