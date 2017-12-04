From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core] udev.md: Fix typo 'le.g.acy' -> 'legacy'
Date: Mon,  4 Dec 2017 16:42:55 +0100
Message-ID: <20171204154255.7067-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 Documentation/udev.md | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/udev.md b/Documentation/udev.md
index 7da3ed94..002340cd 100644
--- a/Documentation/udev.md
+++ b/Documentation/udev.md
@@ -75,12 +75,12 @@ ethernet devices.
 Services that cannot handle hot plug must be ordered after
 systemd-udev-settle.service, which will wait for udev to complete loading
 modules and scheduling systemd services. This ensures that all RDMA hardware
-present at boot is setup before proceeding to run the le.g.acy service.
+present at boot is setup before proceeding to run the legacy service.
 
-Admins using le.g.acy services can also place their RDMA hardware modules
+Admins using legacy services can also place their RDMA hardware modules
 (e.g.  mlx4_ib) directly in /etc/modules-load.d/ or in their initrd which will
 cause systemd to defer passing to sysinit.target until all RDMA hardware is
-setup, this is usually sufficient for le.g.acy services. This is probably the
+setup, this is usually sufficient for legacy services. This is probably the
 default behavior in many configurations.
 
 # Systemd Ordering
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
