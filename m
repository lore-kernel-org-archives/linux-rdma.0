From: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/11] RDMA/nes: change MAX_CM_BUFFER define
Date: Wed, 9 Dec 2009 16:37:49 -0600
Message-ID: <20091209223749.GA103256@flatif-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Changed MAX_CM_BUFFER for MPA frame to be conformant to RFC 5044.
This will change it to 512 + 20 instead of 512.

Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index 90e8e4d..118c7c8 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -47,6 +47,8 @@
 #define IEFT_MPA_KEY_REP  "MPA ID Rep Frame"
 #define IETF_MPA_KEY_SIZE 16
 #define IETF_MPA_VERSION  1
+#define IETF_MAX_PRIV_DATA_LEN 512
+#define IETF_MPA_FRAME_SIZE     20
 
 enum ietf_mpa_flags {
 	IETF_MPA_FLAGS_MARKERS = 0x80,	/* receive Markers */
@@ -169,7 +171,7 @@ struct nes_timer_entry {
 
 #define NES_CM_DEF_SEQ2      0x18ed5740
 #define NES_CM_DEF_LOCAL_ID2 0xb807
-#define	MAX_CM_BUFFER	512
+#define	MAX_CM_BUFFER	(IETF_MPA_FRAME_SIZE + IETF_MAX_PRIV_DATA_LEN)
 
 
 typedef u32 nes_addr_t;
-- 
1.5.3.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
