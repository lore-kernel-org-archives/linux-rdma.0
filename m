From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 2/8] Add timestamp_mask and hca_core_clock to ibv_query_device_ex
Date: Wed, 24 Feb 2016 11:41:58 +0200
Message-ID: <1456306924-31298-3-git-send-email-yishaih@mellanox.com>
References: <1456306924-31298-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456306924-31298-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The fields timestamp_mask and hca_core_clock were added
to the extended version of ibv_query_device verb.
timestamp_mask represents the supported mask of the timestamp.
Users could infer the accuracy of the reported possible
timestamp.
hca_core_clock represents the frequency of the HCA (in kHZ).

Since timestamp is given in hardware cycles, knowing the frequency
is mandatory in order to convert this number into seconds.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/devinfo.c            | 10 ++++++++++
 include/infiniband/kern-abi.h |  2 ++
 include/infiniband/verbs.h    |  2 ++
 src/cmd.c                     | 21 +++++++++++++++++++++
 4 files changed, 35 insertions(+)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index a8de982..0af8c3b 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -339,6 +339,16 @@ static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
 		printf("\tlocal_ca_ack_delay:\t\t%d\n", device_attr.orig_attr.local_ca_ack_delay);
 
 		print_odp_caps(&device_attr.odp_caps);
+		if (device_attr.completion_timestamp_mask)
+			printf("\tcompletion timestamp_mask:\t\t\t0x%016lx\n",
+			       device_attr.completion_timestamp_mask);
+		else
+			printf("\tcompletion_timestamp_mask not supported\n");
+
+		if (device_attr.hca_core_clock)
+			printf("\thca_core_clock:\t\t\t%lukHZ\n", device_attr.hca_core_clock);
+		else
+			printf("\tcore clock not supported\n");
 	}
 
 	for (port = 1; port <= device_attr.orig_attr.phys_port_cnt; ++port) {
diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 31da4be..b196a04 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -269,6 +269,8 @@ struct ibv_query_device_resp_ex {
 	__u32 comp_mask;
 	__u32 response_length;
 	struct ibv_odp_caps_resp odp_caps;
+	__u64 timestamp_mask;
+	__u64 hca_core_clock;
 };
 
 struct ibv_query_port {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 99d6265..3ddf07c 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -207,6 +207,8 @@ struct ibv_device_attr_ex {
 	struct ibv_device_attr	orig_attr;
 	uint32_t		comp_mask;
 	struct ibv_odp_caps	odp_caps;
+	uint64_t		completion_timestamp_mask;
+	uint64_t		hca_core_clock;
 };
 
 enum ibv_mtu {
diff --git a/src/cmd.c b/src/cmd.c
index b8c51ce..e22a24b 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -189,6 +189,27 @@ int ibv_cmd_query_device_ex(struct ibv_context *context,
 		}
 	}
 
+	if (attr_size >= offsetof(struct ibv_device_attr_ex,
+				  completion_timestamp_mask) +
+			 sizeof(attr->completion_timestamp_mask)) {
+		if (resp->response_length >=
+		    offsetof(struct ibv_query_device_resp_ex, timestamp_mask) +
+		    sizeof(resp->timestamp_mask))
+			attr->completion_timestamp_mask = resp->timestamp_mask;
+		else
+			attr->completion_timestamp_mask = 0;
+	}
+
+	if (attr_size >= offsetof(struct ibv_device_attr_ex, hca_core_clock) +
+			 sizeof(attr->hca_core_clock)) {
+		if (resp->response_length >=
+		    offsetof(struct ibv_query_device_resp_ex, hca_core_clock) +
+		    sizeof(resp->hca_core_clock))
+			attr->hca_core_clock = resp->hca_core_clock;
+		else
+			attr->hca_core_clock = 0;
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
