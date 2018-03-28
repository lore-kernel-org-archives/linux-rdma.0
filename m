From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: RFC on writel and writel_relaxed
Date: Wed, 28 Mar 2018 10:57:32 -0600
Message-ID: <20180328165732.GA4546@ziepe.ca>
References: <CAK8P3a0Xep0-EpGS9jnjUf1iJhRxH1WRztGQrvkdrLVaxBPT1w@mail.gmail.com>
 <20180327110258.GF2464@arm.com>
 <bba5ebd8-0643-6f09-9367-419b49e53535@codeaurora.org>
 <20180327143628.GA10642@arm.com>
 <1522186185.7364.59.camel@kernel.crashing.org>
 <20180328085338.GA28871@arm.com>
 <1522230616.21446.1.camel@kernel.crashing.org>
 <CAK8P3a1E54K2pxw-9J5NazF2xNFNvOY1JsGr5C727zAxaz0K5g@mail.gmail.com>
 <1522231287.21446.9.camel@kernel.crashing.org>
 <20180328101345.GA30850@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <20180328101345.GA30850@arm.com>
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
To: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Sinan Kaya <okaya@codeaurora.org>, Peter Zijlstra <peterz@infradead.org>, David Laight <David.Laight@aculab.com>, Oliver <oohall@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" <linuxppc-dev@lists.ozlabs.org>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 28, 2018 at 11:13:45AM +0100, Will Deacon wrote:
> On Wed, Mar 28, 2018 at 09:01:27PM +1100, Benjamin Herrenschmidt wrote:
> > On Wed, 2018-03-28 at 11:55 +0200, Arnd Bergmann wrote:
> > > > powerpc and ARM can't quite make them synchronous I think, but at least
> > > > they should have the same semantics as writel.
> > > 
> > > One thing that ARM does IIRC is that it only guarantees to order writel() within
> > > one device, and the memory mapped PCI I/O space window almost certainly
> > > counts as a separate device to the CPU.
> > 
> > That sounds bogus.
> 
> To elaborate, if you do the following on arm:
> 
> 	writel(DEVICE_FOO);
> 	writel(DEVICE_BAR);
> 
> we generally cannot guarantee in which order those accesses will hit the
> devices even if we add every barrier under the sun. You'd need something
> in between, specific to DEVICE_FOO (probably a read-back) to really push
> the first write out. This doesn't sound like it would be that uncommon to
> me.

The PCI posted write does not require the above to execute 'in order'
only that any bus segment shared by the two devices have the writes
issued in CPU order. ie at a shared PCI root port for instance.

If I recall this is very similar to the ordering that ARM's on-chip
AXI interconnect is supposed to provide.. So I'd be very surprised if
a modern ARM64 has an meaningful difference from x86 here.

When talking about ordering between the devices, the relevant question
is what happens if the writel(DEVICE_BAR) triggers DEVICE_BAR to DMA
from the DEVICE_FOO. 'ordered' means that in this case
writel(DEVICE_FOO) must be presented to FOO before anything generated
by BAR.

Jason
