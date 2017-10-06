From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 18/47] IB/hfi1: Define hfi1_handle_cnp_tbl[] once
Date: Fri,  6 Oct 2017 14:33:04 -0700
Message-ID: <20171006213333.6721-19-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/driver.c | 6 ++++++
 drivers/infiniband/hw/hfi1/hfi.h    | 5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 85a425ef740e..b4f69c07ca2a 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -433,6 +433,12 @@ static inline void init_packet(struct hfi1_ctxtdata *rcd,
 	packet->numpkt = 0;
 }
 
+/* We support only two types - 9B and 16B for now */
+static const hfi1_handle_cnp hfi1_handle_cnp_tbl[2] = {
+	[HFI1_PKT_TYPE_9B] = &return_cnp,
+	[HFI1_PKT_TYPE_16B] = &return_cnp_16B
+};
+
 void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 			       bool do_cnp)
 {
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index cb74ae8b0991..b96a36616c5f 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1535,11 +1535,6 @@ typedef void (*hfi1_handle_cnp)(struct hfi1_ibport *ibp, struct rvt_qp *qp,
 				u32 remote_qpn, u32 pkey, u32 slid, u32 dlid,
 				u8 sc5, const struct ib_grh *old_grh);
 
-/* We support only two types - 9B and 16B for now */
-static const hfi1_handle_cnp hfi1_handle_cnp_tbl[2] = {
-	[HFI1_PKT_TYPE_9B] = &return_cnp,
-	[HFI1_PKT_TYPE_16B] = &return_cnp_16B
-};
 #define PKEY_CHECK_INVALID -1
 int egress_pkey_check(struct hfi1_pportdata *ppd, u32 slid, u16 pkey,
 		      u8 sc5, int8_t s_pkey_index);
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
