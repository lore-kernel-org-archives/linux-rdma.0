From: <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Wed, 21 Mar 2012 04:09:07 +0530
Message-ID: <24c5b654-d6a5-418d-8187-fba4ad47a3ce@exht1.ad.emulex.com>
References: <1332283154-16369-1-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-2-git-send-email-parav.pandit@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332283154-16369-2-git-send-email-parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

- Header file for userspace library and kernel driver interface.

Signed-off-by: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h |  134 +++++++++++++++++++++++++++++
 1 files changed, 134 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_abi.h

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_abi.h b/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
new file mode 100644
index 0000000..a411a4e
--- /dev/null
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_abi.h
@@ -0,0 +1,134 @@
+/*******************************************************************
+ * This file is part of the Emulex RoCE Device Driver for          *
+ * RoCE (RDMA over Converged Ethernet) adapters.                   *
+ * Copyright (C) 2008-2012 Emulex. All rights reserved.            *
+ * EMULEX and SLI are trademarks of Emulex.                        *
+ * www.emulex.com                                                  *
+ *                                                                 *
+ * This program is free software; you can redistribute it and/or   *
+ * modify it under the terms of version 2 of the GNU General       *
+ * Public License as published by the Free Software Foundation.    *
+ * This program is distributed in the hope that it will be useful. *
+ * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
+ * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
+ * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
+ * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
+ * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
+ * more details, a copy of which can be found in the file COPYING  *
+ * included with this package.                                     *
+ *
+ * Contact Information:
+ * linux-drivers-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
+ *
+ * Emulex
+ * 3333 Susan Street
+ * Costa Mesa, CA 92626
+ *******************************************************************/
+
+#ifndef __OCRDMA_ABI_H__
+#define __OCRDMA_ABI_H__
+
+struct ocrdma_alloc_ucontext_resp {
+	u32 dev_id;
+	u32 wqe_size;
+	u32 max_inline_data;
+	u32 dpp_wqe_size;
+	u64 ah_tbl_page;
+	u32 ah_tbl_len;
+	u32 rsvd;
+	u8 fw_ver[32];
+	u32 rqe_size;
+	u64 rsvd1;
+} __packed;
+
+/* user kernel communication data structures. */
+struct ocrdma_alloc_pd_ureq {
+	u64 rsvd1;
+} __packed;
+
+struct ocrdma_alloc_pd_uresp {
+	u32 id;
+	u32 dpp_enabled;
+	u32 dpp_page_addr_hi;
+	u32 dpp_page_addr_lo;
+	u64 rsvd1;
+} __packed;
+
+struct ocrdma_create_cq_ureq {
+	u32 dpp_cq;
+	u32 rsvd;
+} __packed;
+
+#define MAX_CQ_PAGES 8
+struct ocrdma_create_cq_uresp {
+	u32 cq_id;
+	u32 page_size;
+	u32 num_pages;
+	u32 max_hw_cqe;
+	u64 page_addr[MAX_CQ_PAGES];
+	u64 db_page_addr;
+	u32 db_page_size;
+	u32 phase_change;
+	u64 rsvd1;
+	u64 rsvd2;
+} __packed;
+
+#define MAX_QP_PAGES 8
+#define MAX_UD_AV_PAGES 8
+
+struct ocrdma_create_qp_ureq {
+	u8 enable_dpp_cq;
+	u8 rsvd;
+	u16 dpp_cq_id;
+	u32 rsvd1;
+};
+
+struct ocrdma_create_qp_uresp {
+	u16 qp_id;
+	u16 sq_dbid;
+	u16 rq_dbid;
+	u16 resv0;
+	u32 sq_page_size;
+	u32 rq_page_size;
+	u32 num_sq_pages;
+	u32 num_rq_pages;
+	u64 sq_page_addr[MAX_QP_PAGES];
+	u64 rq_page_addr[MAX_QP_PAGES];
+	u64 db_page_addr;
+	u32 db_page_size;
+	u32 dpp_credit;
+	u32 dpp_offset;
+	u32 rsvd1;
+	u32 num_wqe_allocated;
+	u32 num_rqe_allocated;
+	u32 free_wqe_delta;
+	u32 free_rqe_delta;
+	u32 db_sq_offset;
+	u32 db_rq_offset;
+	u32 db_shift;
+	u64 rsvd2;
+	u64 rsvd3;
+} __packed;
+
+struct ocrdma_create_srq_uresp {
+	u16 rq_dbid;
+	u16 resv0;
+	u32 resv1;
+
+	u32 rq_page_size;
+	u32 num_rq_pages;
+
+	u64 rq_page_addr[MAX_QP_PAGES];
+	u64 db_page_addr;
+
+	u32 db_page_size;
+	u32 num_rqe_allocated;
+	u32 db_rq_offset;
+	u32 db_shift;
+
+	u32 free_rqe_delta;
+	u32 rsvd2;
+	u64 rsvd3;
+} __packed;
+
+#endif				/* __OCRDMA_ABI_H__ */
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
