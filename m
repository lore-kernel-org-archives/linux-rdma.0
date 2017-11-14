From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 3/6] debian: Relax dh-systemd build dependency
Date: Tue, 14 Nov 2017 21:02:44 +0100
Message-ID: <20171114200247.25890-4-benjamin.drung@profitbricks.com>
References: <20171114200247.25890-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114200247.25890-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

dh-systemd was merged into debhelper 9.20160709. Thus it does not need
to be installed when debhelper is recent enough.

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 debian/control | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/debian/control b/debian/control
index 403f0527..63231b72 100644
--- a/debian/control
+++ b/debian/control
@@ -6,7 +6,7 @@ Section: net
 Priority: optional
 Build-Depends: cmake (>= 2.8.11),
                debhelper (>= 9),
-               dh-systemd,
+               debhelper (>= 9.20160709) | dh-systemd,
                dpkg-dev (>= 1.17),
                libnl-3-dev,
                libnl-route-3-dev,
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
