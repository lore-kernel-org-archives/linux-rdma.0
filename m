From: Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [TECH TOPIC] IRQ affinity
Date: Wed, 15 Jul 2015 17:19:33 +0000 (UTC)
Message-ID: <alpine.LNX.2.00.1507151700300.15930@localhost.lm.intel.com>
References: <20150715120708.GA24534@infradead.org> <alpine.DEB.2.11.1507151408570.18576@nanos> <55A67F11.1030709@sandisk.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A67F11.1030709-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 15 Jul 2015, Bart Van Assche wrote:
> * With blk-mq and scsi-mq optimal performance can only be achieved if
>  the relationship between MSI-X vector and NUMA node does not change
>  over time. This is necessary to allow a blk-mq/scsi-mq driver to
>  ensure that interrupts are processed on the same NUMA node as the
>  node on which the data structures for a communication channel have
>  been allocated. However, today there is no API that allows
>  blk-mq/scsi-mq drivers and irqbalanced to exchange information
>  about the relationship between MSI-X vector ranges and NUMA nodes.

We could have low-level drivers provide blk-mq the controller's irq
associated with a particular h/w context, and the block layer can provide
the context's cpumask to irqbalance with the smp affinity hint.

The nvme driver already uses the hwctx cpumask to set hints, but this
doesn't seems like it should be a driver responsibility. It currently
doesn't work correctly anyway with hot-cpu since blk-mq could rebalance
the h/w contexts without syncing with the low-level driver.

If we can add this to blk-mq, one additional case to consider is if the
same interrupt vector is used with multiple h/w contexts. Blk-mq's cpu
assignment needs to be aware of this to prevent sharing a vector across
NUMA nodes.

>  The only approach I know of that works today to define IRQ affinity
>  for blk-mq/scsi-mq drivers is to disable irqbalanced and to run a
>  custom script that defines IRQ affinity (see e.g. the
>  spread-mlx4-ib-interrupts attachment of 
> http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/21312/focus=98409).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
