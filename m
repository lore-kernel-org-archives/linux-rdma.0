From: Oliver <oohall@gmail.com>
Subject: Re: RFC on writel and writel_relaxed
Date: Thu, 22 Mar 2018 16:24:24 +1100
Message-ID: <CAOSf1CHTouXQ+sPxu7ySCtw--maef+knFC9bCQ7rpuk-hf-puQ@mail.gmail.com>
References: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
 <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
 <4e5c745a-8b9b-959e-8893-d99cd6032484@codeaurora.org>
 <8a13375fd8e5439890768b7dd8473099@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <8a13375fd8e5439890768b7dd8473099@AcuMS.aculab.com>
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
To: David Laight <David.Laight@aculab.com>
Cc: Sinan Kaya <okaya@codeaurora.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 22, 2018 at 1:35 AM, David Laight <David.Laight@aculab.com> wrote:
>> x86 has compiler barrier inside the relaxed() API so that code does not
>> get reordered. ARM64 architecturally guarantees device writes to be observed
>> in order.
>
> There are places where you don't even need a compile barrier between
> every write.
>
> I had horrid problems getting some ppc code (for a specific embedded SoC)
> optimised to have no extra barriers.
> I ended up just writing through 'pointer to volatile' and adding an
> explicit 'eieio' between the block of writes and status read.

This is what you are supposed to do. For accesses to MMIO (cache
inhibited + guarded) storage the Power ISA guarantees that load-load
and store-store pairs of accesses will always occur in program order,
but there's no implicit ordering between load-store or store-load
pairs. In those cases you need an explicit eieio barrier between the
two accesses. At the HW level you can think of the CPU as having
separate queues for MMIO loads and stores. Accesses will be added to
the respective queue in program order, but there's no synchronisation
between the two queues. If the CPU is doing write combining it's easy
to imagine the whole store queue being emptied in one big gulp before
the load queue is even touched.

> No less painful was doing a byteswapping write to normal memory.

What was the problem? The reverse indexed load/store instructions are
a little awkward to use, but they work...

>
>         David
>
