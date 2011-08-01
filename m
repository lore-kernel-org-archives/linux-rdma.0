From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/2 for-3.1] ib/iser: fix wrong mask when sizeof (dma_addr_t)
 > sizeof (unsigned long)
Date: Tue, 2 Aug 2011 00:12:09 +0300
Message-ID: <alpine.LRH.2.00.1108020010060.22153@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The code that prepares the SG associated with SCSI command for FMR was
buggy for systems with DMA addresses that don't fit in unsigned long,
e.g under the 32-bit based XenServer dom0 sizeof(dma_addr_t) is eight.

Fix that by casting to unsigned long long a masking constant used by
the code. This resolves a crash in iser_sg_to_page_vec on this system.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 342cbc1..db6f3ce 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -89,7 +89,7 @@
 	} while (0)

 #define SHIFT_4K	12
-#define SIZE_4K	(1UL << SHIFT_4K)
+#define SIZE_4K	(1ULL << SHIFT_4K)
 #define MASK_4K	(~(SIZE_4K-1))

 					/* support up to 512KB in one RDMA */
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
