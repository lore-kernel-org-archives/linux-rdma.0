From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 1/3] Fix typo caase -> case
Date: Mon, 11 Sep 2017 13:28:19 +0200
Message-ID: <20170911112821.2094-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 kernel-boot/persistent-ipoib.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-boot/persistent-ipoib.rules b/kernel-boot/persistent-ipoib.rules
index 416284d5..f8d700a3 100644
--- a/kernel-boot/persistent-ipoib.rules
+++ b/kernel-boot/persistent-ipoib.rules
@@ -7,6 +7,6 @@
 # bytes of the address or else the address might not match the variable QPN
 # portion.
 #
-# Modern udev is caase sensitive and all addresses need to be in lower case.
+# Modern udev is case sensitive and all addresses need to be in lower case.
 #
 # ACTION=="add", SUBSYSTEM=="net", DRIVERS=="?*", ATTR{type}=="32", ATTR{address}=="?*00:02:c9:03:00:31:78:f2", NAME="mlx4_ib3"
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
