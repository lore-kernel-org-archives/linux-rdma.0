From: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 rdma-next] RDMA/qedr: Fix rdma_type initialization
Date: Wed, 20 Sep 2017 08:39:46 +0300
Message-ID: <1505885986-5873-1-git-send-email-Michal.Kalderon@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: michal.kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Initialize the rdma_type (iWARP or RoCE) which is set according to
device configuration in qed.

Fixes: e6a38c54faf ("RDMA/qedr: Add support for registering an iWARP device")

Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

---
This patch applies cleanly on k.o/for-next-merged

Changes from V0:
- Added Fixes in commit comment.

---
 drivers/infiniband/hw/qedr/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index ca93171..1afc267 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -870,6 +870,7 @@ static struct qedr_dev *qedr_add(struct qed_dev *cdev, struct pci_dev *pdev,
 		goto init_err;
 
 	dev->user_dpm_enabled = dev_info.user_dpm_enabled;
+	dev->rdma_type = dev_info.rdma_type;
 	dev->num_hwfns = dev_info.common.num_hwfns;
 	dev->rdma_ctx = dev->ops->rdma_get_rdma_ctx(cdev);
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
