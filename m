From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH rdma-next 4/8] IB/core: Replace setting the zero values in ib_uverbs_ex_query_device
Date: Sat, 20 Feb 2016 09:47:41 +0200
Message-ID: <1455954465-15141-5-git-send-email-leon@leon.nu>
References: <1455954465-15141-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455954465-15141-1-git-send-email-leon-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The setting to zero during variable initialization eliminates
the need to explicitly set to zero variables and structures.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6ffc9c4..c647d67 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3583,9 +3583,9 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 			      struct ib_udata *ucore,
 			      struct ib_udata *uhw)
 {
-	struct ib_uverbs_ex_query_device_resp resp;
+	struct ib_uverbs_ex_query_device_resp resp = { {0} };
 	struct ib_uverbs_ex_query_device  cmd;
-	struct ib_device_attr attr;
+	struct ib_device_attr attr = {0};
 	int err;
 
 	if (ucore->inlen < sizeof(cmd))
@@ -3606,14 +3606,11 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	if (ucore->outlen < resp.response_length)
 		return -ENOSPC;
 
-	memset(&attr, 0, sizeof(attr));
-
 	err = ib_dev->query_device(ib_dev, &attr, uhw);
 	if (err)
 		return err;
 
 	copy_query_dev_fields(file, ib_dev, &resp.base, &attr);
-	resp.comp_mask = 0;
 
 	if (ucore->outlen < resp.response_length + sizeof(resp.odp_caps))
 		goto end;
@@ -3626,9 +3623,6 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 		attr.odp_caps.per_transport_caps.uc_odp_caps;
 	resp.odp_caps.per_transport_caps.ud_odp_caps =
 		attr.odp_caps.per_transport_caps.ud_odp_caps;
-	resp.odp_caps.reserved = 0;
-#else
-	memset(&resp.odp_caps, 0, sizeof(resp.odp_caps));
 #endif
 	resp.response_length += sizeof(resp.odp_caps);
 
@@ -3646,8 +3640,5 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
-	if (err)
-		return err;
-
-	return 0;
+	return err;
 }
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
