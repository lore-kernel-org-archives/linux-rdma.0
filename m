From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 04/13] IB/i40iw: Support device FW version string
Date: Thu,  9 Jun 2016 17:53:59 -0400
Message-ID: <1465509248-11324-5-git-send-email-ira.weiny@intel.com>
References: <1465509248-11324-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465509248-11324-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

And remove sysfs support in favor of the core version.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 02a735b64208..39096a246863 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1973,18 +1973,6 @@ static ssize_t i40iw_show_rev(struct device *dev,
 }
 
 /**
- * i40iw_show_fw_ver
- */
-static ssize_t i40iw_show_fw_ver(struct device *dev,
-				 struct device_attribute *attr, char *buf)
-{
-	u32 firmware_version = I40IW_FW_VERSION;
-
-	return sprintf(buf, "%u.%u\n", firmware_version,
-		       (firmware_version & 0x000000ff));
-}
-
-/**
  * i40iw_show_hca
  */
 static ssize_t i40iw_show_hca(struct device *dev,
@@ -2004,13 +1992,11 @@ static ssize_t i40iw_show_board(struct device *dev,
 }
 
 static DEVICE_ATTR(hw_rev, S_IRUGO, i40iw_show_rev, NULL);
-static DEVICE_ATTR(fw_ver, S_IRUGO, i40iw_show_fw_ver, NULL);
 static DEVICE_ATTR(hca_type, S_IRUGO, i40iw_show_hca, NULL);
 static DEVICE_ATTR(board_id, S_IRUGO, i40iw_show_board, NULL);
 
 static struct device_attribute *i40iw_dev_attributes[] = {
 	&dev_attr_hw_rev,
-	&dev_attr_fw_ver,
 	&dev_attr_hca_type,
 	&dev_attr_board_id
 };
@@ -2427,6 +2413,15 @@ static const char * const i40iw_hw_stat_names[] = {
 		"iwRdmaInv"
 };
 
+static void i40iw_get_dev_fw_str(struct ib_device *dev, char *str,
+				 size_t str_len)
+{
+	u32 firmware_version = I40IW_FW_VERSION;
+
+	snprintf(str, str_len, "%u.%u", firmware_version,
+		       (firmware_version & 0x000000ff));
+}
+
 /**
  * i40iw_alloc_hw_stats - Allocate a hw stats structure
  * @ibdev: device pointer from stack
@@ -2650,6 +2645,7 @@ static struct i40iw_ib_device *i40iw_init_rdma_device(struct i40iw_device *iwdev
 	memcpy(iwibdev->ibdev.iwcm->ifname, netdev->name,
 	       sizeof(iwibdev->ibdev.iwcm->ifname));
 	iwibdev->ibdev.get_port_immutable   = i40iw_port_immutable;
+	iwibdev->ibdev.get_dev_fw_str       = i40iw_get_dev_fw_str;
 	iwibdev->ibdev.poll_cq = i40iw_poll_cq;
 	iwibdev->ibdev.req_notify_cq = i40iw_req_notify_cq;
 	iwibdev->ibdev.post_send = i40iw_post_send;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
