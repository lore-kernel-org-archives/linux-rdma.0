From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 14/15] RDMA/bnxt_re: Sync up the module version to internal release version
Date: Thu, 18 May 2017 21:44:33 -0700
Message-ID: <1495169074-12641-15-git-send-email-selvin.xavier@broadcom.com>
References: <1495169074-12641-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495169074-12641-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Updates the module version. The new version number will enable us to
map the upstream driver to the level of supported features in the
internal code base.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
v2 -> v3:
	- Modified the commit message

 drivers/infiniband/hw/bnxt_re/bnxt_re.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
index 30bff05..9041c23b 100644
--- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
+++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
@@ -40,7 +40,7 @@
 #ifndef __BNXT_RE_H__
 #define __BNXT_RE_H__
 #define ROCE_DRV_MODULE_NAME		"bnxt_re"
-#define ROCE_DRV_MODULE_VERSION		"1.0.0"
+#define ROCE_DRV_MODULE_VERSION		"20.6.1.0u"
 
 #define BNXT_RE_DESC	"Broadcom NetXtreme-C/E RoCE Driver"
 
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
