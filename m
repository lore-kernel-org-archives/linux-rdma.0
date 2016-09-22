From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] libcxgb4: fix firmware version string
Date: Thu, 22 Sep 2016 12:29:55 -0700
Message-ID: <20160922201503.CFB88E08CA@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

c4iw_query_device() was incorrectly unpacking
the 64b version number from the driver.  This resulted
in ibv_devinfo showing garbage fw verion strings.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

---

Testing out the new process. :)

---
 libcxgb4/src/verbs.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/libcxgb4/src/verbs.c b/libcxgb4/src/verbs.c
index 3d46f0a..aed547d 100644
--- a/libcxgb4/src/verbs.c
+++ b/libcxgb4/src/verbs.c
@@ -52,7 +52,7 @@ int c4iw_query_device(struct ibv_context *context, struct ibv_device_attr *attr)
 {
 	struct ibv_query_device cmd;
 	uint64_t raw_fw_ver;
-	unsigned major, minor, sub_minor;
+	u8 major, minor, sub_minor, build;
 	int ret;
 
 	ret = ibv_cmd_query_device(context, attr, &raw_fw_ver, &cmd,
@@ -60,12 +60,13 @@ int c4iw_query_device(struct ibv_context *context, struct ibv_device_attr *attr)
 	if (ret)
 		return ret;
 
-	major = (raw_fw_ver >> 32) & 0xffff;
-	minor = (raw_fw_ver >> 16) & 0xffff;
-	sub_minor = raw_fw_ver & 0xffff;
+	major = (raw_fw_ver >> 24) & 0xff;
+	minor = (raw_fw_ver >> 16) & 0xff;
+	sub_minor = (raw_fw_ver >> 8) & 0xff;
+	build = raw_fw_ver & 0xff;
 
 	snprintf(attr->fw_ver, sizeof attr->fw_ver,
-		 "%d.%d.%d", major, minor, sub_minor);
+		 "%d.%d.%d.%d", major, minor, sub_minor, build);
 
 	return 0;
 }
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
