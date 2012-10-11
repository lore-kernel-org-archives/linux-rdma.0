From: Animesh K Trivedi1 <ZRLATR-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Subject: (R)DMA in userspace
Date: Thu, 11 Oct 2012 17:34:06 +0200
Message-ID: <OF84B00CFA.7F1CDA02-ONC1257A94.00545627-C1257A94.0055881A@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Animesh K Trivedi1 <ZRLATR-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hi all,

It is a curiosity question rather a bug/issue report.

Linux DMA subsystem wants streaming DMA buffers to be synchronized before
accessing them. This is
achieved by calling dma_sync_*  family of functions. And, I see that these
functions are used in kernel clients
(e.g. xprtrdma, and iSER). This is all fine.

During memory memory registration, userspace buffers also go through same
API calls (dma_map_sg_attrs(...)).
What I am confused about why no such synchronization primitives are
required in userspace before accessing
an RDMA data buffer just after when an incoming write/recv (DMA on it) is
finished? Who guarantees data
freshness?

Thanks,
--
Animesh

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
