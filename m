From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: NFS/RDMA device removal support
Date: Wed, 13 Jul 2016 14:31:10 -0400
Message-ID: <DB921E2E-A0DD-4BF8-B7CC-D6061C6F16BF@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm working on supporting unloading the HCA kernel driver on
the Linux NFS client while there are active NFS/RDMA mounts.
Happily, the Linux NFS server already supports driver
unloading.

I have prototyped adequate infrastructure to clean up RDMA-
related resources (eg, QP and MRs) as part of handling a
DEVICE_REMOVAL event.

However I'm wondering about long-term DMA-mapped memory.
These would be Send and Receive buffers that are mapped and
then re-used for each RPC, using the ib_dma_sync_* API.

I believe ULPs will have to map these buffers again once a
new device is available. But as part of DEVICE_REMOVAL, does
the ULP have to explicitly unmap this memory?

I'm not seeing an answer in DMA-API-HOWTO.txt.

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
