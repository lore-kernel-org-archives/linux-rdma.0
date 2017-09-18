From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 1/2] debian: Let lintian ignore example udev rule
Date: Mon, 18 Sep 2017 11:33:43 +0200
Message-ID: <20170918093344.11482-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/rdma-core.lintian-overrides | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/debian/rdma-core.lintian-overrides b/debian/rdma-core.lintian-overrides
index 476c1c13..01dea12b 100644
--- a/debian/rdma-core.lintian-overrides
+++ b/debian/rdma-core.lintian-overrides
@@ -1,3 +1,5 @@
 # The rdma-ndd service is started by udev.
 rdma-core: systemd-service-file-missing-install-key lib/systemd/system/iwpmd.service
 rdma-core: systemd-service-file-missing-install-key lib/systemd/system/rdma-ndd.service
+# Example/documentary udev rules file
+rdma-core: udev-rule-in-etc etc/udev/rules.d/70-persistent-ipoib.rules
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
