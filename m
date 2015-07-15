From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [TECH TOPIC] IRQ affinity
Date: Wed, 15 Jul 2015 05:07:08 -0700
Message-ID: <20150715120708.GA24534@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Many years ago we decided to move setting of IRQ to core affnities to
userspace with the irqbalance daemon.

These days we have systems with lots of MSI-X vector, and we have
hardware and subsystem support for per-CPU I/O queues in the block
layer, the RDMA subsystem and probably the network stack (I'm not too
familar with the recent developments there).  It would really help the
out of the box performance and experience if we could allow such
subsystems to bind interrupt vectors to the node that the queue is
configured on.

I'd like to discuss if the rationale for moving the IRQ affinity setting
fully to userspace are still correct in todays world any any pitfalls
we'll have to learn from in irqbalanced and the old in-kernel affinity
code.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
