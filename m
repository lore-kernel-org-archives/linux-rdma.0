From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH rdma-next V1 7/8] IB/core: Advertise supported vector CALC capabilities
Date: Tue, 23 Feb 2016 10:25:27 +0200
Message-ID: <1456215928-9305-8-git-send-email-leon@leon.nu>
References: <1456215928-9305-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456215928-9305-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This vector CALC feature allows different offloaded arithmetic
calculations of several vectors of equal length.

In order to properly use this feature, the user space applications
need to know the supported properties, like operations, size and
maximal number of vectors.

The properties exposed are:
* calc_matrix - If set, vector CALC matrix is supported.
* max_vector_count - Maximum number of vectors supported.
* max_chunk_size - Maximum chunk size supported.
* op_cap - Bit mask indicates which vector CALC operations are supported:
	Bit 1: ADD operation
	Bit 2: MAX operation
	Bit 3: AND operation
	Bit 4: OR operation
	Bit 5: XOR operation
	Bit 6: MIN operation
	Bit 7: SWAP_ENDIANNESS operation

This change returns vector CALC supported properties to the caller.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |  9 +++++++++
 include/rdma/ib_verbs.h              | 19 +++++++++++++++++++
 include/uapi/rdma/ib_user_verbs.h    |  8 ++++++++
 3 files changed, 36 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 3a3f573..3618ca5 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3641,6 +3641,15 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	resp.device_cap_flags2 = upper_32_bits(attr.device_cap_flags);
 	resp.response_length += sizeof(resp.device_cap_flags2);
 
+	if (ucore->outlen < resp.response_length + sizeof(resp.calc_caps))
+		goto end;
+
+	resp.calc_caps.calc_matrix = attr.calc_caps.calc_matrix;
+	resp.calc_caps.max_vector_count = attr.calc_caps.max_vector_count;
+	resp.calc_caps.max_chunk_size = attr.calc_caps.max_chunk_size;
+	resp.calc_caps.op_cap = attr.calc_caps.op_cap;
+	resp.response_length += sizeof(resp.calc_caps);
+
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	return err;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 51aabf8..1f74ebb 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -258,6 +258,24 @@ struct ib_odp_caps {
 	} per_transport_caps;
 };
 
+enum ib_calc_operations {
+	IB_CALC_NONE,
+	IB_CALC_ADD,
+	IB_CALC_MAX,
+	IB_CALC_AND,
+	IB_CALC_OR,
+	IB_CALC_XOR,
+	IB_CALC_MIN,
+	IB_CALC_SWAP_ENDIANNESS
+};
+
+struct ib_calc_caps {
+	u32	calc_matrix;
+	u32	max_vector_count;
+	u32	max_chunk_size;
+	u32	op_cap;
+};
+
 enum ib_cq_creation_flags {
 	IB_CQ_FLAGS_TIMESTAMP_COMPLETION   = 1 << 0,
 	IB_CQ_FLAGS_IGNORE_OVERRUN	   = 1 << 1,
@@ -315,6 +333,7 @@ struct ib_device_attr {
 	struct ib_odp_caps	odp_caps;
 	uint64_t		timestamp_mask;
 	uint64_t		hca_core_clock; /* in KHZ */
+	struct ib_calc_caps	calc_caps;
 };
 
 enum ib_mtu {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index e024c82..c88d8e2 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -219,6 +219,13 @@ struct ib_uverbs_odp_caps {
 	__u32 reserved;
 };
 
+struct ib_uverbs_calc_caps {
+	__u32	calc_matrix;
+	__u32	max_vector_count;
+	__u32	max_chunk_size;
+	__u32	op_cap;
+};
+
 struct ib_uverbs_ex_query_device_resp {
 	struct ib_uverbs_query_device_resp base;
 	__u32 comp_mask;
@@ -231,6 +238,7 @@ struct ib_uverbs_ex_query_device_resp {
 	 * by __u32 variable.  Need to increase this field
 	 */
 	__u64 device_cap_flags2;
+	struct ib_uverbs_calc_caps calc_caps;
 };
 
 struct ib_uverbs_query_port {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
