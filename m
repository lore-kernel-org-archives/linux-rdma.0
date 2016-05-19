From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 2/3] Add extended device capability flags
Date: Thu, 19 May 2016 15:52:48 +0300
Message-ID: <1463662369-18395-3-git-send-email-yishaih@mellanox.com>
References: <1463662369-18395-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463662369-18395-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Since the legacy device capability flags are occupied, add new
device capability flags to the extended query device.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/devinfo.c            | 15 +++++++++++++++
 include/infiniband/kern-abi.h |  2 ++
 include/infiniband/verbs.h    |  7 +++++++
 man/ibv_query_device_ex.3     |  1 +
 src/cmd.c                     | 10 ++++++++++
 5 files changed, 35 insertions(+)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index 5da6773..7391b84 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -333,6 +333,18 @@ void print_odp_caps(const struct ibv_odp_caps *caps)
 	print_odp_trans_caps(caps->per_transport_caps.ud_odp_caps);
 }
 
+static void print_device_cap_flags_ex(uint64_t device_cap_flags_ex)
+{
+	uint64_t ex_flags = device_cap_flags_ex & 0xffffffff00000000;
+	uint64_t unknown_flags = ~(IBV_DEVICE_RAW_SCATTER_FCS);
+
+	if (ex_flags & IBV_DEVICE_RAW_SCATTER_FCS)
+		printf("\t\t\t\t\tRAW_SCATTER_FCS\n");
+	if (ex_flags & unknown_flags)
+		printf("\t\t\t\t\tUnknown flags: 0x%" PRIX64 "\n",
+		       ex_flags & unknown_flags);
+}
+
 static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 {
 	struct ibv_context *ctx;
@@ -420,6 +432,9 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		printf("\tlocal_ca_ack_delay:\t\t%d\n", device_attr.orig_attr.local_ca_ack_delay);
 
 		print_odp_caps(&device_attr.odp_caps);
+
+		printf("\tdevice_cap_flags_ex:\t\t0x%" PRIX64 "\n", device_attr.device_cap_flags_ex);
+		print_device_cap_flags_ex(device_attr.device_cap_flags_ex);
 	}
 
 	for (port = 1; port <= device_attr.orig_attr.phys_port_cnt; ++port) {
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 31da4be..f222593 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -269,6 +269,8 @@ struct ibv_query_device_resp_ex {
 	__u32 comp_mask;
 	__u32 response_length;
 	struct ibv_odp_caps_resp odp_caps;
+	__u64 reserved[2];
+	__u64 device_cap_flags_ex;
 };
 
 struct ibv_query_port {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index bda31a8..f45667f 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -127,6 +127,12 @@ enum ibv_device_cap_flags {
 	IBV_DEVICE_MANAGED_FLOW_STEERING = 1 << 29
 };
 
+/*
+ * Can't extended above ibv_device_cap_flags enum as in some systems/compilers
+ * enum range is limited to 4 bytes.
+ */
+#define IBV_DEVICE_RAW_SCATTER_FCS (1ULL << 34)
+
 enum ibv_atomic_cap {
 	IBV_ATOMIC_NONE,
 	IBV_ATOMIC_HCA,
@@ -207,6 +213,7 @@ struct ibv_device_attr_ex {
 	struct ibv_device_attr	orig_attr;
 	uint32_t		comp_mask;
 	struct ibv_odp_caps	odp_caps;
+	uint64_t		device_cap_flags_ex;
 };
 
 enum ibv_mtu {
diff --git a/man/ibv_query_device_ex.3 b/man/ibv_query_device_ex.3
index 1f483d2..01c41eb 100644
--- a/man/ibv_query_device_ex.3
+++ b/man/ibv_query_device_ex.3
@@ -24,6 +24,7 @@ struct ibv_device_attr_ex {
 struct ibv_device_attr orig_attr;
 uint32_t               comp_mask;              /* Compatibility mask that defines which of the following variables are valid */
 struct ibv_odp_caps    odp_caps;               /* On-Demand Paging capabilities */
+uint64_t               device_cap_flags_ex;    /* Extended device capability flags */
 .in -8
 };
 
diff --git a/src/cmd.c b/src/cmd.c
index b8c51ce..b9c5c67 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -189,6 +189,16 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 		}
 	}
 
+	if (attr_size >= offsetof(struct ibv_device_attr_ex, device_cap_flags_ex) +
+			 sizeof(attr->device_cap_flags_ex)) {
+		if (resp->response_length >=
+		    offsetof(struct ibv_query_device_resp_ex, device_cap_flags_ex) +
+		    sizeof(resp->device_cap_flags_ex))
+			attr->device_cap_flags_ex = resp->device_cap_flags_ex;
+		else
+			attr->device_cap_flags_ex = 0;
+	}
+
 	return 0;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
