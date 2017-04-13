From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2 1/4] IB/core: Add inline function to get sg mr type
Date: Thu, 13 Apr 2017 18:56:14 +0300
Message-ID: <1492098977-5231-2-git-send-email-maxg@mellanox.com>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492098977-5231-1-git-send-email-maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ULPs such as iSER/NVMEoF can use memory regions that support
arbitrary sg list mapping in order to allow the block layer to
send us gappy bios and reduce the stack workload. Add an helper
function to get IB_MR_TYPE_SG_GAPS mr_type if the device support
this kind of mapping.

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/rdma/ib_verbs.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 99e4423..dd97169 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3375,6 +3375,23 @@ int ib_map_mr_sg(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
 int ib_sg_to_pages(struct ib_mr *mr, struct scatterlist *sgl, int sg_nents,
 		unsigned int *sg_offset, int (*set_page)(struct ib_mr *, u64));
 
+/**
+ * ib_get_sg_mr_type() - check if the device support arbitrary
+ *                       sg mapping and return a suitable mr type.
+ * @device: The device on which to check support.
+ *
+ * Return: IB_MR_TYPE_SG_GAPS if the device support.
+ *         Otherwise, return IB_MR_TYPE_MEM_REG.
+ */
+static inline enum ib_mr_type ib_get_sg_mr_type(struct ib_device *device)
+{
+	if (device->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
+		return IB_MR_TYPE_SG_GAPS;
+	else
+		return IB_MR_TYPE_MEM_REG;
+
+}
+
 void ib_drain_rq(struct ib_qp *qp);
 void ib_drain_sq(struct ib_qp *qp);
 void ib_drain_qp(struct ib_qp *qp);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
