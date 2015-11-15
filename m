From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/9] IB: start documenting device capabilities
Date: Sun, 15 Nov 2015 19:05:54 +0100
Message-ID: <1447610762-3781-2-git-send-email-hch@lst.de>
References: <1447610762-3781-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447610762-3781-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Just IB_DEVICE_LOCAL_DMA_LKEY and IB_DEVICE_MEM_MGT_EXTENSIONS for now
as I'm most familar with those.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 include/rdma/ib_verbs.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 45ce36e..6034f92 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -120,6 +120,14 @@ enum ib_device_cap_flags {
 	IB_DEVICE_RC_RNR_NAK_GEN	= (1<<12),
 	IB_DEVICE_SRQ_RESIZE		= (1<<13),
 	IB_DEVICE_N_NOTIFY_CQ		= (1<<14),
+
+	/*
+	 * This device supports a per-device lkey or stag that can be
+	 * used without performing a memory registration for the local
+	 * memory.  Note that ULPs should never check this flag, but
+	 * instead of use the local_dma_lkey flag in the ib_pd structure,
+	 * which will always contain a usable lkey.
+	 */
 	IB_DEVICE_LOCAL_DMA_LKEY	= (1<<15),
 	IB_DEVICE_RESERVED		= (1<<16), /* old SEND_W_INV */
 	IB_DEVICE_MEM_WINDOW		= (1<<17),
@@ -133,6 +141,16 @@ enum ib_device_cap_flags {
 	IB_DEVICE_UD_IP_CSUM		= (1<<18),
 	IB_DEVICE_UD_TSO		= (1<<19),
 	IB_DEVICE_XRC			= (1<<20),
+
+	/*
+	 * This device supports the IB "base memory management extension",
+	 * which includes support for fast registrations (IB_WR_REG_MR,
+	 * IB_WR_LOCAL_INV and IB_WR_SEND_WITH_INV verbs).  This flag should
+	 * also be set by any iWarp device which must support FRs to comply
+	 * to the iWarp verbs spec.  iWarp devices also support the
+	 * IB_WR_RDMA_READ_WITH_INV verb for RDMA READs that invalidate the
+	 * stag.
+	 */
 	IB_DEVICE_MEM_MGT_EXTENSIONS	= (1<<21),
 	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1<<22),
 	IB_DEVICE_MEM_WINDOW_TYPE_2A	= (1<<23),
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
