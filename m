From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [Ksummit-discuss] [TECH TOPIC] IRQ affinity
Date: Fri, 17 Jul 2015 17:51:07 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1507171655110.18576@nanos>
References: <20150715120708.GA24534@infradead.org> <alpine.DEB.2.11.1507151408570.18576@nanos> <55A67F11.1030709@sandisk.com> <alpine.LNX.2.00.1507151700300.15930@localhost.lm.intel.com> <55A697A3.3090305@kernel.dk> <20150715184800.GL13681@linux.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150715184800.GL13681-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jiang Liu <jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

B1;2802;0cOn Wed, 15 Jul 2015, Matthew Wilcox wrote:
> On Wed, Jul 15, 2015 at 11:25:55AM -0600, Jens Axboe wrote:
> > On 07/15/2015 11:19 AM, Keith Busch wrote:
> > >On Wed, 15 Jul 2015, Bart Van Assche wrote:
> > >>* With blk-mq and scsi-mq optimal performance can only be achieved if
> > >> the relationship between MSI-X vector and NUMA node does not change
> > >> over time. This is necessary to allow a blk-mq/scsi-mq driver to
> > >> ensure that interrupts are processed on the same NUMA node as the
> > >> node on which the data structures for a communication channel have
> > >> been allocated. However, today there is no API that allows
> > >> blk-mq/scsi-mq drivers and irqbalanced to exchange information
> > >> about the relationship between MSI-X vector ranges and NUMA nodes.
> > >
> > >We could have low-level drivers provide blk-mq the controller's irq
> > >associated with a particular h/w context, and the block layer can provide
> > >the context's cpumask to irqbalance with the smp affinity hint.
> > >
> > >The nvme driver already uses the hwctx cpumask to set hints, but this
> > >doesn't seems like it should be a driver responsibility. It currently
> > >doesn't work correctly anyway with hot-cpu since blk-mq could rebalance
> > >the h/w contexts without syncing with the low-level driver.
> > >
> > >If we can add this to blk-mq, one additional case to consider is if the
> > >same interrupt vector is used with multiple h/w contexts. Blk-mq's cpu
> > >assignment needs to be aware of this to prevent sharing a vector across
> > >NUMA nodes.
> > 
> > Exactly. I may have promised to do just that at the last LSF/MM conference,
> > just haven't done it yet. The point is to share the mask, I'd ideally like
> > to take it all the way where the driver just asks for a number of vecs
> > through a nice API that takes care of all this. Lots of duplicated code in
> > drivers for this these days, and it's a mess.
> 
> Yes.  I think the fundamental problem is that our MSI-X API is so funky.
> We have this incredibly flexible scheme where each MSI-X vector could
> have its own interrupt handler, but that's not what drivers want.
> They want to say "Give me eight MSI-X vectors spread across the CPUs,
> and use this interrupt handler for all of them".  That is, instead of
> the current scheme where each MSI-X vector gets its own Linux interrupt,
> we should have one interrupt handler (of the per-cpu interrupt type),
> which shows up with N bits set in its CPU mask.

That certainly would help, but I'm definitely not going to open a huge
can of worms by providing a side channel for vector allocation with
all the variants of irq remapping and whatsoever.

Though we certainly can do better than we do now. We recently reworked
the whole interrupt handling of x86 to use hierarchical interrupt
domains. This allows us to come up with a clean solution for your
issue. The current hierarchy looks like this:

  [MSI-domain]
	|
	v
  [optional REMAP-domain]
	|
	v
  [Vector-domain]

Now it's simple to add another hierarchy level:

  [MSI/X-Multiqueue-domain]
	|
	v
  [MSI-domain]
	|
	v
  [optional REMAP-domain]
	|
	v
  [Vector-domain]

The MSI/X-Multiqueue-domain would be the one which is associated to
this class of devices. The domain would provide a single virtual
interrupt number to the device and hide the underlying details.

This needs a few new interfaces at the irq core level because we
cannot map that 1:1 to the per cpu interrupt mechanism which we have
on ARM and other architectures.

irqdomain interfaces used from PCI/MSI infrastructure code:

  irq_domain_alloc_mq(....., nr_vectors, spread_scheme)

    @nr_vectors:     The number of vectors to allocate underneath

    @spread_scheme:  Some form of advice/hint how to spread the vectors
    		     (nodes, cpus, ...)

    Returns a unique virtual interrupt number which shows up in
    /proc/irq. The virtual interrupt cannot be influenced by user space
    affinity settings (e.g. irqbalanced)

    The vectors will have seperate irq numbers and irq descriptors,
    but those should be supressed in /proc/interrupts. /proc/irq/NNN
    should expose the information at least for debugging purposes.

    One advantage of these seperate descriptors is that the associated
    data will be cpu/node local according to the spread scheme.

  irq_domain_free_mq()

    Counterpart to the above

irq core interfaces used from PCI/MSI infrastructure

  irq_move_mq_vector()

    Move a multiqueue vector to a new target (cpu, node)  

    That might even replace the underlying irq descriptor with a newly
    allocated one, if the vector moves across nodes.

Driver relevant interfaces:

  msi_alloc_mq_irqs()/msi_free_mq_irqs()

    PCI/MSI specific wrappers for the irqdomain interfaces


  msi_mq_move_vector(virq, vector_nr, target)

    @virq: 	The virtual interrupt number

    @vector_nr:	The vector number to move

    @target:	The target cpu/node information
    
    PCI/MSI specific wrapper around irq_move_mq_vector()
	
The existing interfaces will behave as follows:

    request_irq()
    free_irq()
    disable_irq()
    enable_irq()

    They all operate on the virtual irq number and affect all
    associated vectors.

Now the question is whether we need

    en/disable_irq_mq_vector(virq, vector_nr)

to can shut down / reenable a particular vector, but that would be
pretty straight forward to do, plus/minus the headache versus the
global disable/enable mechanism which operates on the virq.

Thoughts?

	tglx


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
