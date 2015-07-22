From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 39/43] IB/core: Add arbitrary sg_list support
Date: Wed, 22 Jul 2015 09:55:39 +0300
Message-ID: <1437548143-24893-40-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/ib_verbs.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d543fee..cc83c39 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -133,6 +133,7 @@ enum ib_device_cap_flags {
 	IB_DEVICE_MANAGED_FLOW_STEERING = (1<<29),
 	IB_DEVICE_SIGNATURE_HANDOVER	= (1<<30),
 	IB_DEVICE_ON_DEMAND_PAGING	= (1<<31),
+	IB_DEVICE_MAP_ARB_SG		= (1ULL<<32),
 };
 
 enum ib_signature_prot_cap {
@@ -193,7 +194,7 @@ struct ib_device_attr {
 	u32			hw_ver;
 	int			max_qp;
 	int			max_qp_wr;
-	int			device_cap_flags;
+	u64			device_cap_flags;
 	int			max_sge;
 	int			max_sge_rd;
 	int			max_cq;
@@ -556,6 +557,11 @@ __attribute_const__ int ib_rate_to_mult(enum ib_rate rate);
  */
 __attribute_const__ int ib_rate_to_mbps(enum ib_rate rate);
 
+enum ib_mr_flags {
+	IB_MR_MAP_ARB_SG = 1,
+};
+
+
 enum ib_mr_type {
 	IB_MR_TYPE_FAST_REG,
 	IB_MR_TYPE_SIGNATURE,
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
