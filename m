From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] verbs: Add support for delay drop ability in a WQ
Date: Wed,  6 Sep 2017 18:11:57 +0300
Message-ID: <1504710717-22707-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Work queue which is created with IBV_WQ_FLAGS_DELAY_DROP won't
cause packet drops when there aren't receive WQEs, but will wait until
posting of receive WQEs or for some period of time that the device
was configured with.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

This patch is the supplementary part of the kernel code that was accepted
upstream into 4.14.

PR was sent:
https://github.com/linux-rdma/rdma-core/pull/213

 libibverbs/examples/devinfo.c  | 2 ++
 libibverbs/man/ibv_create_wq.3 | 7 ++++---
 libibverbs/verbs.h             | 4 +++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/libibverbs/examples/devinfo.c b/libibverbs/examples/devinfo.c
index 2c1e3f1..f03c53e 100644
--- a/libibverbs/examples/devinfo.c
+++ b/libibverbs/examples/devinfo.c
@@ -410,6 +410,8 @@ static void print_raw_packet_caps(uint32_t raw_packet_caps)
 		printf("\t\t\t\t\tScatter FCS offload\n");
 	if (raw_packet_caps & IBV_RAW_PACKET_CAP_IP_CSUM)
 		printf("\t\t\t\t\tIP csum offload\n");
+	if (raw_packet_caps & IBV_RAW_PACKET_CAP_DELAY_DROP)
+		printf("\t\t\t\t\tDelay drop\n");
 }
 
 static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
diff --git a/libibverbs/man/ibv_create_wq.3 b/libibverbs/man/ibv_create_wq.3
index 4a8b83c..a540130 100644
--- a/libibverbs/man/ibv_create_wq.3
+++ b/libibverbs/man/ibv_create_wq.3
@@ -39,9 +39,10 @@ uint32_t                   create_flags    /* Creation flags for this WQ, use en
 .nf
 enum ibv_wq_flags {
 .in +8
-IBV_WQ_FLAGS_CVLAN_STRIPPING		= 1 << 0, /* CVLAN field will be stripped from incoming packets */
-IBV_WQ_FLAGS_SCATTER_FCS		= 1 << 1, /* FCS field will be scattered to host memory */
-IBV_WQ_FLAGS_RESERVED			= 1 << 2,
+IBV_WQ_FLAGS_CVLAN_STRIPPING            = 1 << 0, /* CVLAN field will be stripped from incoming packets */
+IBV_WQ_FLAGS_SCATTER_FCS                = 1 << 1, /* FCS field will be scattered to host memory */
+IBV_WQ_FLAGS_DELAY_DROP                 = 1 << 2, /* Packets won't be dropped immediately if no receive WQEs */
+IBV_WQ_FLAGS_RESERVED                   = 1 << 3,
 .in -8
 };
 .nf
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 922a011..9050e3d 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -257,6 +257,7 @@ enum ibv_raw_packet_caps {
 	IBV_RAW_PACKET_CAP_CVLAN_STRIPPING	= 1 << 0,
 	IBV_RAW_PACKET_CAP_SCATTER_FCS		= 1 << 1,
 	IBV_RAW_PACKET_CAP_IP_CSUM		= 1 << 2,
+	IBV_RAW_PACKET_CAP_DELAY_DROP		= 1 << 3,
 };
 
 struct ibv_device_attr_ex {
@@ -682,7 +683,8 @@ enum ibv_wq_init_attr_mask {
 enum ibv_wq_flags {
 	IBV_WQ_FLAGS_CVLAN_STRIPPING		= 1 << 0,
 	IBV_WQ_FLAGS_SCATTER_FCS		= 1 << 1,
-	IBV_WQ_FLAGS_RESERVED			= 1 << 2,
+	IBV_WQ_FLAGS_DELAY_DROP			= 1 << 2,
+	IBV_WQ_FLAGS_RESERVED			= 1 << 3,
 };
 
 struct ibv_wq_init_attr {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
