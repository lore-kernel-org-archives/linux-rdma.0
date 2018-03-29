From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Thu, 29 Mar 2018 12:59:23 -0400
Message-ID: <48b2698a-8cc6-22c5-551c-88e84cc06a71@codeaurora.org>
References: <CA+55aFxULkhZGhg-tTBBxBBvXbL7QV7f6zvwW7U2wHFijqGEqw@mail.gmail.com>
 <b02cc752d90c5e5ae2cc8cc4f67429a7@codeaurora.org>
 <1522249996.21446.25.camel@kernel.crashing.org>
 <20180328.115509.481837809903086401.davem@davemloft.net>
 <29fe17e0-9978-dc43-d02c-de8fabdc66c2@codeaurora.org>
 <CAK8P3a2qcXmPx-j6XZPGhWZ_K3=cBym8tVFzwcZMSCjVfzMs1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a2qcXmPx-j6XZPGhWZ_K3=cBym8tVFzwcZMSCjVfzMs1g@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Miller <davem@davemloft.net>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Duyck <alexander.duyck@gmail.com>, Will Deacon <will.deacon@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, David Laight <David.Laight@aculab.com>, Oliver O'Halloran <oohall@gmail.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-rdma <linux-rdma@vger.kernel.org>, Alexander Duyck <alexander.h.duyck@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Networking <netdev@vger.kernel.org>, Linus Torvalds <linus971@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On 3/29/2018 12:29 PM, Arnd Bergmann wrote:
> On Thu, Mar 29, 2018 at 3:56 PM, Sinan Kaya <okaya@codeaurora.org> wrote:
>> On 3/28/2018 11:55 AM, David Miller wrote:
>>> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>> Date: Thu, 29 Mar 2018 02:13:16 +1100
>>>
>>>> Let's fix all archs, it's way easier than fixing all drivers. Half of
>>>> the archs are unused or dead anyway.
>>>
>>> Agreed.
>>>
>>
>> I pinged most of the maintainers yesterday.
>> Which arches do we care about these days?
>> I have not been paying attention any other architecture besides arm64.
>>
>> arch            status                  detail
>> ------          -------------           ------------------------------------
>> alpha           question sent

Thanks for the detailed analysis.

> 
> I'm guessing alpha has problems
> 
> extern inline u32 readl(const volatile void __iomem *addr)
> {
>         u32 ret = __raw_readl(addr);
>         mb();
>         return ret;
> }
> extern inline void writel(u32 b, volatile void __iomem *addr)
> {
>         __raw_writel(b, addr);
>         mb();
> }

Looks like a problem to me too. I'll start a thread with the alpha
people and CC you.


> 
> There is a barrier in writel /after/ the acess but not before.
> 

This is the consolidated list. I also heart back from m68k and corrected
contacts for arc and h8300.

arch            status                  detail
------          -------------           ------------------------------------
alpha		question sent		Arnd: alpha has problems
arc		question sent		Vineet.Gupta1@synopsys.com says he'll get to this
					in the next few days
arm		no issues
arm64		no issues
c6x		no issues		no PCI
h8300		no issues		no PCI: ysato@users.sourceforge.jp will fix it.
hexagon		no issues		no PCI
ia64		no issues		confirmed by Tony Luck
m68k		no issues		geert@linux-m68k.org says no problem
metag		no issues		arnd: removed
microblaze	question sent		arnd: some mips platforms have problems
mips		question sent		arnd: some mips platforms have problems
nds32		question sent
nios2		no issues		no PCI
openrisc	no issues		shorne@gmail.com says should no issues
parisc		no issues		grantgrundler@gmail.com says most probably no problem
					but still looking
powerpc		no issues
riscv		no issues		arnd: riscv should be fine
s390		no issues		arnd: Pretty sure this is also fine
sh		question sent
sparc		no issues		davem@davemloft.net says always strongly ordered
unicore32	question sent		resent to gxt@pku.edu.cn
x86		no issues
x86_64		no issues



> 
>          Arnd
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
