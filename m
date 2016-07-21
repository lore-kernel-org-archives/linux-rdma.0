From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v12 22/22] MAINTAINERS: Add maintainers for Hisilicon RoCE driver
Date: Thu, 21 Jul 2016 19:06:57 +0800
Message-ID: <1469099217-26071-23-git-send-email-oulijun@huawei.com>
References: <1469099217-26071-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469099217-26071-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch added maintainers for RoCE driver.

Signed-off-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
PATCH v12:
This fixes the comments given by Leon Romanovsky over the
[PATCH v11 21/22]:
  Link: https://lkml.org/lkml/2016/7/14/15

PATCH v11/v10/v9:
- No change over the PATCH v8

PATCH v8:
This fixes the comments given by Joe Perches over the PATCH v7:
  Link: https://lkml.org/lkml/2016/5/25/396

PATCH v7/v6/v5/v4:
- No change over the PATCH v3

PATCH v3:
- The initial patch
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d74837..bc71824 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5422,6 +5422,14 @@ F:	include/uapi/linux/if_hippi.h
 F:	net/802/hippi.c
 F:	drivers/net/hippi/
 
+HISILICON ROCE DRIVER
+M:	Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
+M:	Wei Hu(Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
+L:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+S:	Maintained
+F:	drivers/infiniband/hw/hns/
+F:	Documentation/devicetree/bindings/infiniband/hisilicon-hns-roce.txt
+
 HISILICON SAS Controller
 M:	John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
 W:	http://www.hisilicon.com
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
