From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [rdma-core 2/3] libbnxt_re: Display FW version using ibv_devinfo
Date: Wed, 31 Jan 2018 09:51:50 -0500
Message-ID: <1517410311-23623-3-git-send-email-devesh.sharma@broadcom.com>
References: <1517410311-23623-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517410311-23623-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Need to expose the 64bit fw version received as an o/p
of ibv_cmd_query_device as a string. Fixing this in the query_device
verb.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/verbs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/providers/bnxt_re/verbs.c b/providers/bnxt_re/verbs.c
index 2e88304..6c07646 100644
--- a/providers/bnxt_re/verbs.c
+++ b/providers/bnxt_re/verbs.c
@@ -58,12 +58,14 @@ int bnxt_re_query_device(struct ibv_context *ibvctx,
 			 struct ibv_device_attr *dev_attr)
 {
 	struct ibv_query_device cmd;
-	uint64_t fw_ver;
+	uint8_t fw_ver[8];
 	int status;
 
 	memset(dev_attr, 0, sizeof(struct ibv_device_attr));
-	status = ibv_cmd_query_device(ibvctx, dev_attr, &fw_ver,
+	status = ibv_cmd_query_device(ibvctx, dev_attr, (uint64_t *)&fw_ver,
 				      &cmd, sizeof(cmd));
+	snprintf(dev_attr->fw_ver, 64, "%d.%d.%d.%d",
+		 fw_ver[0], fw_ver[1], fw_ver[2], fw_ver[3]);
 	return status;
 }
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
