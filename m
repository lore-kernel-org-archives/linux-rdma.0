From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 54/54] staging/rdma/hfi1: Removing unused struct
 hfi1_verbs_counters
Date: Wed, 03 Feb 2016 14:38:16 -0800
Message-ID: <20160203223812.5923.11630.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It removes the unused struct hfi1_verbs_counters from verbs.h

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs.h |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index a157e64..335e3a8 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -279,22 +279,6 @@ struct hfi1_ibdev {
 #endif
 };
 
-struct hfi1_verbs_counters {
-	u64 symbol_error_counter;
-	u64 link_error_recovery_counter;
-	u64 link_downed_counter;
-	u64 port_rcv_errors;
-	u64 port_rcv_remphys_errors;
-	u64 port_xmit_discards;
-	u64 port_xmit_data;
-	u64 port_rcv_data;
-	u64 port_xmit_packets;
-	u64 port_rcv_packets;
-	u32 local_link_integrity_errors;
-	u32 excessive_buffer_overrun_errors;
-	u32 vl15_dropped;
-};
-
 static inline struct hfi1_ibdev *to_idev(struct ib_device *ibdev)
 {
 	struct rvt_dev_info *rdi;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
