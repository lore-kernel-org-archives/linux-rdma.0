From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 17/37] IB/hfi1: Switch from dma_device to dev.parent
Date: Fri, 20 Jan 2017 13:04:17 -0800
Message-ID: <20170120210437.26389-18-bart.vanassche@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Prepare for removal of ib_device.dma_device.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c   | 2 +-
 drivers/infiniband/hw/hfi1/verbs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 6e595afca24c..09cda3c35e82 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -4406,7 +4406,7 @@ int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 	switch (in_mad->base_version) {
 	case OPA_MGMT_BASE_VERSION:
 		if (unlikely(in_mad_size != sizeof(struct opa_mad))) {
-			dev_err(ibdev->dma_device, "invalid in_mad_size\n");
+			dev_err(ibdev->dev.parent, "invalid in_mad_size\n");
 			return IB_MAD_RESULT_FAILURE;
 		}
 		return hfi1_process_opa_mad(ibdev, mad_flags, port,
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 95ed4d6da510..2c9efae72972 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1784,7 +1784,7 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	strlcpy(ibdev->name + lcpysz, "_%d", IB_DEVICE_NAME_MAX - lcpysz);
 	ibdev->owner = THIS_MODULE;
 	ibdev->phys_port_cnt = dd->num_pports;
-	ibdev->dma_device = &dd->pcidev->dev;
+	ibdev->dev.parent = &dd->pcidev->dev;
 	ibdev->modify_device = modify_device;
 	ibdev->alloc_hw_stats = alloc_hw_stats;
 	ibdev->get_hw_stats = get_hw_stats;
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
