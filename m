From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Ksummit-discuss] [TECH TOPIC] IRQ affinity
Date: Thu, 16 Jul 2015 09:13:37 +0300
Message-ID: <20150716075454-mutt-send-email-mst@redhat.com>
References: <20150715120708.GA24534@infradead.org>
 <alpine.DEB.2.11.1507151408570.18576@nanos>
 <55A67F11.1030709@sandisk.com>
 <alpine.LNX.2.00.1507151700300.15930@localhost.lm.intel.com>
 <55A697A3.3090305@kernel.dk>
 <20150715184800.GL13681@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150715184800.GL13681-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 15, 2015 at 02:48:00PM -0400, Matthew Wilcox wrote:
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

It would definitely be nice to have a way to express that.  But it's
also pretty common for drivers to have e.g. RX and TX use separate
vectors, and these need separate handlers.

> _______________________________________________
> Ksummit-discuss mailing list
> Ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/ksummit-discuss
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
