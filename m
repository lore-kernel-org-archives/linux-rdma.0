From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 libibverbs 3/7] Add timestamp_mask and hca_core_clock to ibv_query_device_ex
Date: Thu, 19 May 2016 14:51:38 +0300
Message-ID: <1463658702-9975-4-git-send-email-yishaih@mellanox.com>
References: <1463658702-9975-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463658702-9975-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
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
 man/ibv_query_device_ex.3     |  6 ++++--
 src/cmd.c                     | 21 +++++++++++++++++++++
 5 files changed, 39 insertions(+), 2 deletions(-)

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
index 36a2c8c..a2c0c46 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -271,6 +271,8 @@ struct ibv_query_device_resp_ex {
 	__u32 comp_mask;
 	__u32 response_length;
 	struct ibv_odp_caps_resp odp_caps;
+	__u64 timestamp_mask;
+	__u64 hca_core_clock;
 };
 
 struct ibv_query_port {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index b391353..054d6a7 100644
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
diff --git a/man/ibv_query_device_ex.3 b/man/ibv_query_device_ex.3
index 1f483d2..db12c2b 100644
--- a/man/ibv_query_device_ex.3
+++ b/man/ibv_query_device_ex.3
@@ -22,8 +22,10 @@ is a pointer to an ibv_device_attr_ex struct, as defined in <infiniband/verbs.h>
 struct ibv_device_attr_ex {
 .in +8
 struct ibv_device_attr orig_attr;
-uint32_t               comp_mask;              /* Compatibility mask that defines which of the following variables are valid */
-struct ibv_odp_caps    odp_caps;               /* On-Demand Paging capabilities */
+uint32_t               comp_mask;                  /* Compatibility mask that defines which of the following variables are valid */
+struct ibv_odp_caps    odp_caps;                   /* On-Demand Paging capabilities */
+uint64_t               completion_timestamp_mask;  /* Completion timestamp mask (0 = unsupported) */
+uint64_t               hca_core_clock;             /* The frequency (in kHZ) of the HCA (0 = unsupported) */
 .in -8
 };
 
diff --git a/src/cmd.c b/src/cmd.c
index d292452..777fded 100644
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
