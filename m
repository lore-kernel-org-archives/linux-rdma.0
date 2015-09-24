From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 1/3] IB/core: Add arbitrary sg_list support
Date: Thu, 24 Sep 2015 20:41:19 +0300
Message-ID: <1443116481-14533-2-git-send-email-sagig@mellanox.com>
References: <1443116481-14533-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443116481-14533-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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
 drivers/infiniband/core/verbs.c |  2 ++
 include/rdma/ib_verbs.h         | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index e0368fcf5fdb..fd7c93237774 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1461,6 +1461,8 @@ EXPORT_SYMBOL(ib_check_mr_status);
  * - The last sg element is allowed to have length less than page_size.
  * - If sg_nents total byte length exceeds the mr max_num_sge * page_size
  *   then only max_num_sg entries will be mapped.
+ * - If the MR was allocated with type IB_MR_TYPE_SG_GAPS_REG, non of these
+ *   constraints holds and the page_size argument is ignored.
  *
  * Returns the number of sg elements that were mapped to the memory region.
  *
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index c1b5bfa66b84..e487d66be655 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -142,6 +142,10 @@ enum ib_device_cap_flags {
 	IB_DEVICE_ON_DEMAND_PAGING	= (1<<31),
 };
 
+enum ib_device_cap_flags_ex {
+	IB_DEVICE_SG_GAPS_REG		= (1ULL << 0),
+};
+
 enum ib_signature_prot_cap {
 	IB_PROT_T10DIF_TYPE_1 = 1,
 	IB_PROT_T10DIF_TYPE_2 = 1 << 1,
@@ -236,6 +240,7 @@ struct ib_device_attr {
 	struct ib_odp_caps	odp_caps;
 	uint64_t		timestamp_mask;
 	uint64_t		hca_core_clock; /* in KHZ */
+	uint64_t		device_cap_flags_ex;
 };
 
 enum ib_mtu {
@@ -571,10 +576,15 @@ __attribute_const__ int ib_rate_to_mbps(enum ib_rate rate);
  * @IB_MR_TYPE_SIGNATURE:     memory region that is used for
  *                            signature operations (data-integrity
  *                            capable regions)
+ * @IB_MR_TYPE_SG_GAPS_REG:   memory region that is capable to
+ *                            register any arbitrary sg lists (without
+ *                            the normal mr constraints - see
+ *                            ib_map_mr_sg)
  */
 enum ib_mr_type {
 	IB_MR_TYPE_MEM_REG,
 	IB_MR_TYPE_SIGNATURE,
+	IB_MR_TYPE_SG_GAPS_REG,
 };
 
 /**
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
