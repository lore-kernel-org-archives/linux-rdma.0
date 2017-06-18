From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 2/2] RDMA/qedr: Notify user application number of supported WIDs
Date: Sun, 18 Jun 2017 16:01:11 +0300
Message-ID: <1497790871-23945-3-git-send-email-Ram.Amrani@cavium.com>
References: <1497790871-23945-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497790871-23945-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The number of supported WIDs, if they are supported at all, can be
limited due to, e.g., BAR resources. Notifying the user space
application the number of available WIDs allows it to utilize them
correctly.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 3 +++
 include/uapi/rdma/qedr-abi.h       | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 6a0acfa..b1bcee0 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -373,6 +373,9 @@ struct ib_ucontext *qedr_alloc_ucontext(struct ib_device *ibdev,
 
 	uresp.dpm_enabled = QEDR_LIB_UCXT_SUPPORT(dpm_enabled, udata,
 						  dev->user_dpm_enabled);
+	uresp.wids_enabled = QEDR_LIB_UCXT_SUPPORT(wids_enabled, udata, 1);
+	uresp.wid_count = QEDR_LIB_UCXT_SUPPORT(wid_count, udata,
+						oparams.wid_count);
 
 	uresp.db_pa = ctx->dpi_phys_addr;
 	uresp.db_size = ctx->dpi_size;
diff --git a/include/uapi/rdma/qedr-abi.h b/include/uapi/rdma/qedr-abi.h
index 2684004..54b6435 100644
--- a/include/uapi/rdma/qedr-abi.h
+++ b/include/uapi/rdma/qedr-abi.h
@@ -50,6 +50,8 @@ struct qedr_alloc_ucontext_resp {
 	__u32 sges_per_srq_wr;
 	__u32 max_cqes;
 	__u8 dpm_enabled;
+	__u8 wids_enabled;
+	__u16 wid_count;
 };
 
 struct qedr_alloc_pd_ureq {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
