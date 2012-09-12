From: Bart Van Assche <bartvanassche.gglplus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/6] opensm: /etc/init.d/opensmd: Correct LSB header
Date: Wed, 12 Sep 2012 13:49:42 +0200
Message-ID: <505076D6.6090404@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make sure that opensm is started after syslog and openibd and also
that opensm is stopped before syslog or openibd is stopped. This
information is essential for e.g. systemctl.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 configure.in           |    2 ++
 scripts/opensm.init.in |    4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index e48c066..015f74c 100644
--- a/configure.in
+++ b/configure.in
@@ -11,6 +11,8 @@ AM_INIT_AUTOMAKE
 AC_SUBST(RELEASE, ${RELEASE:-unknown})
 AC_SUBST(TARBALL, ${TARBALL:-${PACKAGE}-${VERSION}.tar.gz})
 +AC_SUBST(RDMA_SERVICE, ["$({ for f in /etc/init.d/rdma /etc/init.d/openibd; do test -e $f && cat $f; done | sed -n 's/^# Provides: *//p'; echo openib; } 2>/dev/null | head -n 1)"])
+
 dnl NOTE: AC_DEFINE's and AC_DEFINE_UNQUOTED's which are used in header files
 dnl       MUST have a corresponding entry in include/opensm/osm_config.h.in to
 dnl       ensure plugin compatibility.
diff --git a/scripts/opensm.init.in b/scripts/opensm.init.in
index 9ec08a2..01d2bb9 100644
--- a/scripts/opensm.init.in
+++ b/scripts/opensm.init.in
@@ -7,8 +7,8 @@
 #
 ### BEGIN INIT INFO
 # Provides: opensm
-# Required-Start: $syslog
-# Required-Stop:
+# Required-Start: $syslog @RDMA_SERVICE@
+# Required-Stop: $syslog @RDMA_SERVICE@
 # Default-Start: 2 3 5
 # Default-Stop: 0 1 4 6
 # Description:  Manage OpenSM
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
