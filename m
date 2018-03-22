From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: RFC on writel and writel_relaxed
Date: Thu, 22 Mar 2018 15:24:49 +1100
Message-ID: <1521692689.16434.293.camel@kernel.crashing.org>
References: <3611eabe-2999-1482-b2b4-6d216bbe4762@codeaurora.org>
 <CAOSf1CFmoK2XSn0=qAtiVEO9t4i-DHGgfieiedDfuO6E3tpkQw@mail.gmail.com>
 <4e5c745a-8b9b-959e-8893-d99cd6032484@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <4e5c745a-8b9b-959e-8893-d99cd6032484@codeaurora.org>
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
To: Sinan Kaya <okaya@codeaurora.org>, Oliver <oohall@gmail.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2018-03-21 at 08:53 -0500, Sinan Kaya wrote:
> writel_relaxed() needs to have ordering guarantees with respect to the order
> device observes writes. 

Correct.

> x86 has compiler barrier inside the relaxed() API so that code does not
> get reordered. ARM64 architecturally guarantees device writes to be observed
> in order.
> 
> I was hoping that PPC could follow x86 and inject compiler barrier into the
> relaxed functions. 
> 
> BTW, I have no idea what compiler barrier does on PPC and if
> 
> wrltel() == compiler barrier() + wrltel_relaxed()
> 
> can be said.

No, it's not sufficient.

Replacing wmb() + writel() with wmb() + writel_relaxed() will work on
PPC, it will just not give you a benefit today.

The main problem is that the semantics of writel/writel_relaxed (and
read versions) aren't very well defined in Linux esp. when it comes
to different memory types (NC, WC, ...).

I've been wanting to implement the relaxed accessors for a while but
was battling with this to try to also better support WC, and due to
other commitments, this somewhat fell down the cracks.

Two options I can think of:

 - Just make the _relaxed variants use an eieio instead of a sync, this
will effectively lift the ordering guarantee vs. cachable storage (and
thus unlock) and might give a (small) performance improvement. However,
we still have the problem that on WC mappings, neither writel nor
writel_relaxed will effectively allow combining to happen (only raw
accesses will because on powerpc *all* barriers will break combining).

 - Make writel_relaxed() be a simple store without barriers, and
readl_relaxed() be "eieio, read, eieio", thus allowing write combining
to happen between successive writel_relaxed on WC space (no change on
normal NC space) while maintaining the ordering between relaxed reads
and writes. The flip side is a (slight) increased overhead of
readl_relaxed.

Cheers,
Ben.
