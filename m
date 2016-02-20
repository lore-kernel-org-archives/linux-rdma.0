From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH rdma-next 6/8] IB/core: Add offload arithmetic operations support
Date: Sat, 20 Feb 2016 09:47:43 +0200
Message-ID: <1455954465-15141-7-git-send-email-leon@leon.nu>
References: <1455954465-15141-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455954465-15141-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The offload arithmetic operations support allows to the user to
benefit from the parallel calculation of several input vectors of
equal length.

The newly added flag indicates this ability.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 3 +++
 include/rdma/ib_verbs.h              | 8 +++++++-
 include/uapi/rdma/ib_user_verbs.h    | 5 +++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6887252..3a3f573 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3638,6 +3638,9 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	resp.hca_core_clock = attr.hca_core_clock;
 	resp.response_length += sizeof(resp.hca_core_clock);
 
+	resp.device_cap_flags2 = upper_32_bits(attr.device_cap_flags);
+	resp.response_length += sizeof(resp.device_cap_flags2);
+
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	return err;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 2ff1fd1..51aabf8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -208,10 +208,16 @@ enum ib_device_cap_flags {
 	 * of I/O operations with single completion queue managed
 	 * by hardware.
 	 */
-	IB_DEVICE_CROSS_CHANNEL		= (1 << 27),
+	IB_DEVICE_CROSS_CHANNEL			= (1 << 27),
 	IB_DEVICE_MANAGED_FLOW_STEERING		= (1 << 29),
 	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
 	IB_DEVICE_ON_DEMAND_PAGING		= (1 << 31),
+	/*
+	 * The offload arithmetic operations support allows to
+	 * the user to benefit from the parallel calculation of
+	 * several input vectors of equal length.
+	 */
+	IB_DEVICE_VECTOR_CALC                   = (1ULL << 32),
 };
 
 enum ib_signature_prot_cap {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 8126c14..e024c82 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -226,6 +226,11 @@ struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_odp_caps odp_caps;
 	__u64 timestamp_mask;
 	__u64 hca_core_clock; /* in KHZ */
+	/*
+	 * Original capability field is limited
+	 * by __u32 variable.  Need to increase this field
+	 */
+	__u64 device_cap_flags2;
 };
 
 struct ib_uverbs_query_port {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
