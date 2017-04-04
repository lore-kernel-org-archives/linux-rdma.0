From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] MAINTAINERS: Update ocrdma module status
Date: Tue,  4 Apr 2017 01:30:38 -0700
Message-ID: <1491294638-30903-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since ocrdma driver is not going to be updated with any
new development activity, except for critical bug fixes
reported by partners or customers, changing the module status
to "Odd Fixes". Also, updating the web page info and the
maintainers email addresses.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 MAINTAINERS | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c776906..7b352d3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11358,11 +11358,11 @@ S:	Supported
 F:	drivers/net/ethernet/emulex/benet/
 
 EMULEX ONECONNECT ROCE DRIVER
-M:	Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
-M:	Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
+M:	Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
+M:	Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
 L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
-W:	http://www.emulex.com
-S:	Supported
+W:	http://www.broadcom.com
+S:	Odd Fixes
 F:	drivers/infiniband/hw/ocrdma/
 F:	include/uapi/rdma/ocrdma-abi.h
 
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
