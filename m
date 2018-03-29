From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: RFC on writel and writel_relaxed
Date: Thu, 29 Mar 2018 10:40:48 -0600
Message-ID: <20180329164048.GB13656@ziepe.ca>
References: <1522186185.7364.59.camel@kernel.crashing.org>
 <20180328085338.GA28871@arm.com>
 <1522230616.21446.1.camel@kernel.crashing.org>
 <CAK8P3a1E54K2pxw-9J5NazF2xNFNvOY1JsGr5C727zAxaz0K5g@mail.gmail.com>
 <1522231287.21446.9.camel@kernel.crashing.org>
 <20180328101345.GA30850@arm.com> <20180328165732.GA4546@ziepe.ca>
 <20180329091941.GA22926@arm.com> <20180329144515.GA13656@ziepe.ca>
 <4ce6f0338fe04574bd3c0633c522a1c7@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <4ce6f0338fe04574bd3c0633c522a1c7@AcuMS.aculab.com>
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
To: David Laight <David.Laight@ACULAB.COM>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Sinan Kaya <okaya@codeaurora.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Oliver <oohall@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 29, 2018 at 02:58:34PM +0000, David Laight wrote:
> From: Jason Gunthorpe
> > Sent: 29 March 2018 15:45
> ...
> > > > When talking about ordering between the devices, the relevant question
> > > > is what happens if the writel(DEVICE_BAR) triggers DEVICE_BAR to DMA
> > > > from the DEVICE_FOO. 'ordered' means that in this case
> > > > writel(DEVICE_FOO) must be presented to FOO before anything generated
> > > > by BAR.
> > >
> > > Yes, and that isn't the case for arm because the writes can still be
> > > buffered.
> > 
> > The statement is not about buffering, or temporal completion order, or
> > the order of acks returning to the CPU. It is about pure transaction
> > ordering inside the interconnect.
> > 
> > Can write BAR -> FOO pass write CPU -> FOO?
> 
> Almost certainly.
> The first cpu write can almost certainly be 'stalled' at the shared PCIe bridge.
> The second cpu write then completes (to a different target).
> That target then issues a peer to peer transfer that reaches the shared bridge.
> I doubt the order of the transactions is guaranteed when it becomes 'un-stalled'.

The PCI spec has very strong wording on ordering that covers this
case. Stalled bridges have to follow the ordering rules, and posted
writes cannot pass other posted writes.

Since in PCI all three transactions:
 CPU -> FOO
 CPU -> BAR
 BAR -> FOO

Must traverse a shared bus segment, they must be placed on that bus in
the above order, and the bridge(s) toward FOO must preserve this
order.

ARM's AXI has similar rules, I just can't recall the tiny details
right now :)

> Of course, these are peer to peer transfers, and strange ones at that.
> Normally you'd not be doing peer to peer transfers that access 'memory'
> the cpu has just written to.

It is the best situation I can think of where order of completion to
different devices would matter to a generic Linux driver..

.. And there are patches circulating right now for NVMe that enable
exactly this kind of transfer, and rely on these kind of semantics, so
it is a relevant detail :)

Jason
