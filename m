From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [Ksummit-discuss] [TECH TOPIC] IRQ affinity
Date: Wed, 15 Jul 2015 14:48:00 -0400
Message-ID: <20150715184800.GL13681@linux.intel.com>
References: <20150715120708.GA24534@infradead.org>
 <alpine.DEB.2.11.1507151408570.18576@nanos>
 <55A67F11.1030709@sandisk.com>
 <alpine.LNX.2.00.1507151700300.15930@localhost.lm.intel.com>
 <55A697A3.3090305@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55A697A3.3090305@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <keith.busch@intel.com>, Bart Van Assche <bart.vanassche@sandisk.com>, ksummit-discuss@lists.linuxfoundation.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 15, 2015 at 11:25:55AM -0600, Jens Axboe wrote:
> On 07/15/2015 11:19 AM, Keith Busch wrote:
> >On Wed, 15 Jul 2015, Bart Van Assche wrote:
> >>* With blk-mq and scsi-mq optimal performance can only be achieved if
> >> the relationship between MSI-X vector and NUMA node does not change
> >> over time. This is necessary to allow a blk-mq/scsi-mq driver to
> >> ensure that interrupts are processed on the same NUMA node as the
> >> node on which the data structures for a communication channel have
> >> been allocated. However, today there is no API that allows
> >> blk-mq/scsi-mq drivers and irqbalanced to exchange information
> >> about the relationship between MSI-X vector ranges and NUMA nodes.
> >
> >We could have low-level drivers provide blk-mq the controller's irq
> >associated with a particular h/w context, and the block layer can provide
> >the context's cpumask to irqbalance with the smp affinity hint.
> >
> >The nvme driver already uses the hwctx cpumask to set hints, but this
> >doesn't seems like it should be a driver responsibility. It currently
> >doesn't work correctly anyway with hot-cpu since blk-mq could rebalance
> >the h/w contexts without syncing with the low-level driver.
> >
> >If we can add this to blk-mq, one additional case to consider is if the
> >same interrupt vector is used with multiple h/w contexts. Blk-mq's cpu
> >assignment needs to be aware of this to prevent sharing a vector across
> >NUMA nodes.
> 
> Exactly. I may have promised to do just that at the last LSF/MM conference,
> just haven't done it yet. The point is to share the mask, I'd ideally like
> to take it all the way where the driver just asks for a number of vecs
> through a nice API that takes care of all this. Lots of duplicated code in
> drivers for this these days, and it's a mess.

Yes.  I think the fundamental problem is that our MSI-X API is so funky.
We have this incredibly flexible scheme where each MSI-X vector could
have its own interrupt handler, but that's not what drivers want.
They want to say "Give me eight MSI-X vectors spread across the CPUs,
and use this interrupt handler for all of them".  That is, instead of
the current scheme where each MSI-X vector gets its own Linux interrupt,
we should have one interrupt handler (of the per-cpu interrupt type),
which shows up with N bits set in its CPU mask.
