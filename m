From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: RFC on writel and writel_relaxed
Date: Tue, 27 Mar 2018 21:54:50 +0200
Message-ID: <CAK8P3a0MuGs4ifvJefyuSAxgJum-5dvWTOQNLjHCwo9oe3qwuA@mail.gmail.com>
References: <1521854626.16434.359.camel@kernel.crashing.org>
 <58ce5b83f40f4775bec1be8db66adb0d@AcuMS.aculab.com> <20180326165425.GA15554@ziepe.ca>
 <CAK8P3a1zeMyj+Z-y4ER4moY6Zip9EWNOinf+VnboGOrgiwbBZA@mail.gmail.com>
 <20180326202545.GB15554@ziepe.ca> <CAK8P3a3fc43ZcW626hmsd3DVcLw7hGkdUMxp7s4Rn3mdkziwMQ@mail.gmail.com>
 <20180326210951.GD15554@ziepe.ca> <CAK8P3a2UU1xAM0NLo7Q4-Xgo1SzY3De1uqpFudr+2ZW7nHEPmA@mail.gmail.com>
 <1522101616.7364.13.camel@kernel.crashing.org> <1e077f6a-90b6-cce9-6f0f-a8c003fec850@codeaurora.org>
 <20180327151029.GB17494@arm.com> <CAKgT0Uem6HT-Z=HBnSVcC4rnDL0yFyXEbr+FN3YYkJ=ExZpUPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAKgT0Uem6HT-Z=HBnSVcC4rnDL0yFyXEbr+FN3YYkJ=ExZpUPQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>, Sinan Kaya <okaya@codeaurora.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Alexander Duyck <alexander.h.duyck@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 27, 2018 at 8:54 PM, Alexander Duyck
<alexander.duyck@gmail.com> wrote:
> On Tue, Mar 27, 2018 at 8:10 AM, Will Deacon <will.deacon@arm.com> wrote:

>>>
>>> Sinan
>>> "We are being told that if you use writel(), then you don't need a wmb(=
) on
>>> all architectures."
>>>
>>> Alex:
>>> "I'm not sure who told you that but that is incorrect, at least for
>>> x86. If you attempt to use writel() without the wmb() we will have to
>>> NAK the patches. We will accept the wmb() with writel_releaxed() since
>>> that solves things for ARM."
>>>
>>> > Jason is seeking behavior clarification for write combined buffers.
>>>
>>> Alex:
>>> "Don't bother. I can tell you right now that for x86 you have to have a
>>> wmb() before the writel().
>>
>> To clarify: are you saying that on x86 you need a wmb() prior to a write=
l
>> if you want that writel to be ordered after prior writes to memory? Is t=
his
>> specific to WC memory or some other non-standard attribute?
>
> Note, I am not a CPU guy so this is just my interpretation. It is my
> understanding that the wmb(), aka sfence, is needed on x86 to sort out
> writes between Write-back(WB) system memory and Strong Uncacheable
> (UC) MMIO accesses.
>
> I was hoping to be able to cite something in the software developers
> manual (https://software.intel.com/sites/default/files/managed/39/c5/3254=
62-sdm-vol-1-2abcd-3abcd.pdf),
> but that tends to be pretty vague. I have re-read section 22.34
> (volume 3B) several times and I am still not clear on if it says we
> need the sfence or not. It is a matter of figuring out what the impact
> of store buffers and caching are for WB versus UC memory.

Here is what I found regarding the store buffer in that document:

11.10 STORE BUFFER
Intel 64 and IA-32 processors temporarily store each write (store) to
memory in a store buffer. The store buffer
improves processor performance by allowing the processor to continue
executing instructions without having to
wait until a write to memory and/or to a cache is complete. It also
allows writes to be delayed for more efficient use
of memory-access bus cycles.
In general, the existence of the store buffer is transparent to
software, even in systems that use multiple processors.
The processor ensures that write operations are always carried out in
program order. It also insures that the
contents of the store buffer are always drained to memory in the
following situations:
=E2=80=A2 When an exception or interrupt is generated.
=E2=80=A2 (P6 and more recent processor families only) When a serializing
instruction is executed.
=E2=80=A2 When an I/O instruction is executed.
=E2=80=A2 When a LOCK operation is performed.
=E2=80=A2 (P6 and more recent processor families only) When a BINIT operati=
on
is performed.
=E2=80=A2 (Pentium III, and more recent processor families only) When using=
 an
SFENCE instruction to order stores.
=E2=80=A2 (Pentium 4 and more recent processor families only) When using an
MFENCE instruction to order stores.
The discussion of write ordering in Section 8.2, =E2=80=9CMemory Ordering,=
=E2=80=9D
gives a detailed description of the operation of
the store buffer.

       Arnd
