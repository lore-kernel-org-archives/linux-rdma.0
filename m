From: Christoph Lameter <cl@linux.com>
Subject: Re: [TECH TOPIC] IRQ affinity
Date: Wed, 15 Jul 2015 09:38:36 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1507150936560.3158@east.gentwo.org>
References: <20150715120708.GA24534@infradead.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150715120708.GA24534@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: ksummit-discuss@lists.linuxfoundation.org, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 15 Jul 2015, Christoph Hellwig wrote:

> Many years ago we decided to move setting of IRQ to core affnities to
> userspace with the irqbalance daemon.
>
> These days we have systems with lots of MSI-X vector, and we have
> hardware and subsystem support for per-CPU I/O queues in the block
> layer, the RDMA subsystem and probably the network stack (I'm not too
> familar with the recent developments there).  It would really help the
> out of the box performance and experience if we could allow such
> subsystems to bind interrupt vectors to the node that the queue is
> configured on.
>
> I'd like to discuss if the rationale for moving the IRQ affinity setting
> fully to userspace are still correct in todays world any any pitfalls
> we'll have to learn from in irqbalanced and the old in-kernel affinity
> code.

Configuration with processors that are trying to be OS noise free
(NOHZ) would also benefit if device interrupts would be directed to
processors that are not in the NOHZ set. Currently we use scripts on
bootup that redirect interrupts away from these.
