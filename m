From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/3] IB/core: Add arbitrary sg_list support
Date: Mon, 29 Feb 2016 19:07:32 +0200
Message-ID: <1456765654-27592-2-git-send-email-sagig@mellanox.com>
References: <1456765654-27592-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456765654-27592-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Devices that are capable in registering SG lists
with gaps can now expose it in the core to ULPs
using a new device capability IB_DEVICE_SG_GAPS_REG
(in a new field device_cap_flags_ex in the device attributes
as we ran out of bits), and a new mr_type IB_MR_TYPE_SG_GAPS_REG
which allocates a memory region which is capable of handling
SG lists with gaps.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 2 ++
 include/rdma/ib_verbs.h         | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 5af6d024e053..16f3fb1b9d75 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1567,6 +1567,8 @@ EXPORT_SYMBOL(ib_check_mr_status);
  * - The last sg element is allowed to have length less than page_size.
  * - If sg_nents total byte length exceeds the mr max_num_sge * page_size
  *   then only max_num_sg entries will be mapped.
+ * - If the MR was allocated with type IB_MR_TYPE_SG_GAPS_REG, non of these
+ *   constraints holds and the page_size argument is ignored.
  *
  * Returns the number of sg elements that were mapped to the memory region.
  *
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 2ff1fd13d4b6..dee13667a405 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -212,6 +212,7 @@ enum ib_device_cap_flags {
 	IB_DEVICE_MANAGED_FLOW_STEERING		= (1 << 29),
 	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
 	IB_DEVICE_ON_DEMAND_PAGING		= (1 << 31),
+	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
 };
 
 enum ib_signature_prot_cap {
@@ -662,10 +663,15 @@ __attribute_const__ int ib_rate_to_mbps(enum ib_rate rate);
  * @IB_MR_TYPE_SIGNATURE:     memory region that is used for
  *                            signature operations (data-integrity
  *                            capable regions)
+ * @IB_MR_TYPE_SG_GAPS:       memory region that is capable to
+ *                            register any arbitrary sg lists (without
+ *                            the normal mr constraints - see
+ *                            ib_map_mr_sg)
  */
 enum ib_mr_type {
 	IB_MR_TYPE_MEM_REG,
 	IB_MR_TYPE_SIGNATURE,
+	IB_MR_TYPE_SG_GAPS,
 };
 
 /**
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
