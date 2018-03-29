From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: RFC on writel and writel_relaxed
Date: Thu, 29 Mar 2018 18:29:32 +0200
Message-ID: <CAK8P3a2qcXmPx-j6XZPGhWZ_K3=cBym8tVFzwcZMSCjVfzMs1g@mail.gmail.com>
References: <CA+55aFxULkhZGhg-tTBBxBBvXbL7QV7f6zvwW7U2wHFijqGEqw@mail.gmail.com>
 <b02cc752d90c5e5ae2cc8cc4f67429a7@codeaurora.org> <1522249996.21446.25.camel@kernel.crashing.org>
 <20180328.115509.481837809903086401.davem@davemloft.net> <29fe17e0-9978-dc43-d02c-de8fabdc66c2@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <29fe17e0-9978-dc43-d02c-de8fabdc66c2@codeaurora.org>
Sender: netdev-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: David Miller <davem@davemloft.net>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Duyck <alexander.duyck@gmail.com>, Will Deacon <will.deacon@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver O'Halloran <oohall@gmail.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-rdma <linux-rdma@vger.kernel.org>, Alexander Duyck <alexander.h.duyck@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Networking <netdev@vger.kernel.org>, Linus Torvalds <linus971@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 29, 2018 at 3:56 PM, Sinan Kaya <okaya@codeaurora.org> wrote:
> On 3/28/2018 11:55 AM, David Miller wrote:
>> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Date: Thu, 29 Mar 2018 02:13:16 +1100
>>
>>> Let's fix all archs, it's way easier than fixing all drivers. Half of
>>> the archs are unused or dead anyway.
>>
>> Agreed.
>>
>
> I pinged most of the maintainers yesterday.
> Which arches do we care about these days?
> I have not been paying attention any other architecture besides arm64.
>
> arch            status                  detail
> ------          -------------           ------------------------------------
> alpha           question sent

I'm guessing alpha has problems

extern inline u32 readl(const volatile void __iomem *addr)
{
        u32 ret = __raw_readl(addr);
        mb();
        return ret;
}
extern inline void writel(u32 b, volatile void __iomem *addr)
{
        __raw_writel(b, addr);
        mb();
}

There is a barrier in writel /after/ the acess but not before.

> arc             question sent           ysato@users.sourceforge.jp will fix it.
> arm             no issues
> arm64           no issues
> blackfin        question sent           about to be removed
> c6x             question sent

no PCI, so it might not matter that much -- all drivers
are platform specific in the end.

> cris            question sent
> frv

cris and frv are getting removed

> h8300           question sent

no PCI

> hexagon         question sent

no PCI

> ia64            no issues               confirmed by Tony Luck
> m32r

removed

> m68k            question sent

> metag

removed

> microblaze      question sent
> mips            question sent

I'm guessing that some mips platforms have problems, but others don't.

> mn10300         question sent

removed

> nios2           question sent

no PCI

> openrisc        no issues               shorne@gmail.com says should no issues
> parisc          no issues               grantgrundler@gmail.com says most probably no problem but still looking
> powerpc         no issues
> riscv           question sent

riscv should be fine

> s390            question sent

Pretty sure this is also fine

> score           question sent

removed

> sh              question sent
> sparc           question sent

> tile            question sent

removed

> unicore32       question sent

Note the maintainer's new email address in linux-next.

> x86             no issues

> xtensa          question sent

removed.

         Arnd
