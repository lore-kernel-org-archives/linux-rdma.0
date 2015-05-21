From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 05/11] IB/core: Add timestamp_mask and hca_core_clock to query_device
Date: Thu, 21 May 2015 17:56:36 +0300
Message-ID: <1432220202-9834-6-git-send-email-ogerlitz@mellanox.com>
References: <1432220202-9834-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432220202-9834-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In order to expose timestamp we need to expose two attributes
in query_device:
timestamp_mask - how many bits are valid in the timestamp.
		 timestamp values could be 64bits the most.
hca_core_clock - timestamp is given in HW cycles, hca_core_clock
                 is the frequency of the HCA and is necessary in
		 order to convert cycles to seconds.

This is added both to ib_query_device and its respective uverbs
counterpart.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/device.c     |    2 ++
 drivers/infiniband/core/uverbs_cmd.c |   14 ++++++++++++++
 include/rdma/ib_verbs.h              |    2 ++
 include/uapi/rdma/ib_user_verbs.h    |    2 ++
 4 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 18c1ece..81eabaf 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -558,6 +558,8 @@ EXPORT_SYMBOL(ib_dispatch_event);
 int ib_query_device(struct ib_device *device,
 		    struct ib_device_attr *device_attr)
 {
+	memset(device_attr, 0, sizeof(*device_attr));
+
 	return device->query_device(device, device_attr);
 }
 EXPORT_SYMBOL(ib_query_device);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 51311b1..11ee298 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3426,6 +3426,8 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	if (ucore->outlen < resp.response_length)
 		return -ENOSPC;
 
+	memset(&attr, 0, sizeof(attr));
+
 	err = device->query_device(device, &attr);
 	if (err)
 		return err;
@@ -3450,6 +3452,18 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 #endif
 	resp.response_length += sizeof(resp.odp_caps);
 
+	if (ucore->outlen < resp.response_length + sizeof(resp.timestamp_mask))
+		goto end;
+
+	resp.timestamp_mask = attr.timestamp_mask;
+	resp.response_length += sizeof(resp.timestamp_mask);
+
+	if (ucore->outlen < resp.response_length + sizeof(resp.hca_core_clock))
+		goto end;
+
+	resp.hca_core_clock = attr.hca_core_clock;
+	resp.response_length += sizeof(resp.hca_core_clock);
+
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	if (err)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 28ec073..6fdb21e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -220,6 +220,8 @@ struct ib_device_attr {
 	int			sig_prot_cap;
 	int			sig_guard_cap;
 	struct ib_odp_caps	odp_caps;
+	uint64_t		timestamp_mask;
+	uint64_t		hca_core_clock;
 };
 
 enum ib_mtu {
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 19f0256..f9b8843 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -223,6 +223,8 @@ struct ib_uverbs_ex_query_device_resp {
 	__u32 comp_mask;
 	__u32 response_length;
 	struct ib_uverbs_odp_caps odp_caps;
+	__u64 timestamp_mask;
+	__u64 hca_core_clock;
 };
 
 struct ib_uverbs_query_port {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
