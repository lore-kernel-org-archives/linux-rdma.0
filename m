From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 22:46:53 +0200
Message-ID: <CAK8P3a27ohddqaet7=tXk9uS45guxp12KS1W9rmd8QOdOfaAXg@mail.gmail.com>
References: <1521854626.16434.359.camel@kernel.crashing.org>
 <58ce5b83f40f4775bec1be8db66adb0d@AcuMS.aculab.com> <20180326165425.GA15554@ziepe.ca>
 <CAK8P3a1zeMyj+Z-y4ER4moY6Zip9EWNOinf+VnboGOrgiwbBZA@mail.gmail.com>
 <20180326202545.GB15554@ziepe.ca> <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
 <20180326210951.GD15554@ziepe.ca> <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <1522101616.7364.13.camel@kernel.crashing.org> <1e077f6a-90b6-cce9-6f0f-a8c003fec850@codeaurora.org>
 <20180327151029.GB17494@arm.com> <CAKgT0Uem6HT-Z=HBnSVcC4rnDL0yFyXEbr+FN3YYkJ=ExZpUPQ@mail.gmail.com>
 <CAK8P3a0MuGs4ifvJefyuSAxgJum-5dvWTOQNLjHCwo9oe3qwuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a0MuGs4ifvJefyuSAxgJum-5dvWTOQNLjHCwo9oe3qwuA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>, Sinan Kaya <okaya@codeaurora.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Alexander Duyck <alexander.h.duyck@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 27, 2018 at 9:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tue, Mar 27, 2018 at 8:54 PM, Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
>> On Tue, Mar 27, 2018 at 8:10 AM, Will Deacon <will.deacon@arm.com> wrote=
:
>
> 11.10 STORE BUFFER
> Intel 64 and IA-32 processors temporarily store each write (store) to
> memory in a store buffer. The store buffer
> improves processor performance by allowing the processor to continue
> executing instructions without having to
> wait until a write to memory and/or to a cache is complete. It also
> allows writes to be delayed for more efficient use
> of memory-access bus cycles.
> In general, the existence of the store buffer is transparent to
> software, even in systems that use multiple processors.
> The processor ensures that write operations are always carried out in
> program order. It also insures that the
> contents of the store buffer are always drained to memory in the
> following situations:
> =E2=80=A2 When an exception or interrupt is generated.
> =E2=80=A2 (P6 and more recent processor families only) When a serializing
> instruction is executed.
> =E2=80=A2 When an I/O instruction is executed.

I guess I/O instruction is still ambiguous on x86, it may just refer
to 'inb'/'outb' style instructions rather than 'mov' on a device MMIO
area.

Here's a link to a reply from Linus that I found on this topic:

http://yarchive.net/comp/linux/write_combining.html

      Arnd
