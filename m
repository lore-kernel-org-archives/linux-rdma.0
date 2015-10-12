From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Ksummit-discuss] [TECH TOPIC] IRQ affinity
Date: Mon, 12 Oct 2015 12:09:48 -0400
Message-ID: <20151012160948.GD20210@thunk.org>
References: <20150715120708.GA24534@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150715120708.GA24534@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: ksummit-discuss@lists.linuxfoundation.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-rdma@vger.kernel.org

Hi Christoph,

Do you think this is still an issue that would be worth discsussing at
the kernel summit as a technical topic?  If so, would you be willing
to be responsible for kicking off the discussion for this topic?

Thanks,

					- Ted



On Wed, Jul 15, 2015 at 05:07:08AM -0700, Christoph Hellwig wrote:
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
> _______________________________________________
> Ksummit-discuss mailing list
> Ksummit-discuss@lists.linuxfoundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/ksummit-discuss
