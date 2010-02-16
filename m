From: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: is it possible to avoid syncing after an rdma write?
Date: Tue, 16 Feb 2010 15:29:48 -0800
Message-ID: <4B7B2A6C.80101@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Right now, RDS follows each RDMA write op with a Send op, which 1)
causes an interrupt and 2) includes the info we need to call
ib_dma_sync_sg_for_cpu() for the target of the rdma write.

We want to omit the Send. If we don't do the sync on the machine that is
the target of the RDMA write, the result is... what exactly? I assume
the write to memory is snooped by CPUs, so their cachelines will be
properly invalidated. However, Linux DMA-API docs seem pretty clear in
insisting on the sync.

Is the issue IOMMUs? Or for compatibility with bounce buffering?

Thanks in advance -- Regards -- Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
