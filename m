From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma 3/3] RDMA/qedr: notify user application of supported WIDs
Date: Mon, 26 Jun 2017 19:05:06 +0300
Message-ID: <1498493106-28604-4-git-send-email-Ram.Amrani@cavium.com>
References: <1498493106-28604-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498493106-28604-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The number of supported WIDs, if they are supported at all, can be
limited due to resources. Notifying the user space application the
number of available WIDs allows it to utilize them correctly.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 2 ++
 include/uapi/rdma/qedr-abi.h       | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index d655364..b11da86 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -377,6 +377,8 @@ struct ib_ucontext *qedr_alloc_ucontext(struct ib_device *ibdev,
 	memset(&uresp, 0, sizeof(uresp));
 
 	uresp.dpm_enabled = dev->user_dpm_enabled;
+	uresp.wids_enabled = 1;
+	uresp.wid_count = oparams.wid_count;
 	uresp.db_pa = ctx->dpi_phys_addr;
 	uresp.db_size = ctx->dpi_size;
 	uresp.max_send_wr = dev->attr.max_sqe;
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
