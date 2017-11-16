From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH rdma-core 2/2] Add myself as Debian packaging maintainer
Date: Thu, 16 Nov 2017 13:29:37 +0100
Message-ID: <20171116122937.31770-3-benjamin.drung@profitbricks.com>
References: <20171116122937.31770-1-benjamin.drung@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171116122937.31770-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 08286cb5..194a2da0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -40,6 +40,11 @@ F:	*/CMakeLists.txt
 F:	*/lib*.map
 F:	buildlib/
 
+DEBIAN PACKAGING
+M:	Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+S:	Supported
+F:	debian/
+
 BNXT_RE USERSPACE PROVIDER (for bnxt_re.ko)
 M:	Devesh Sharma  <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
 S:	Supported
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
