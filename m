From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband-diags: fail configure if glib2 is not found
Date: Tue, 20 Aug 2013 08:12:21 -0700
Message-ID: <20130820081221.4e82045244cfb32c54de9116@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 README       |    1 +
 configure.ac |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/README b/README
index d19e3e9..10a11e2 100644
--- a/README
+++ b/README
@@ -14,6 +14,7 @@ Dependencies:
 	2) libibumad >= 1.3.7
 	3) opensm-libs >= 3.3.10
 	4) ib_umad kernel module
+	5) glib2
 
 
 Release notes v1.6.1 => 1.6.2
diff --git a/configure.ac b/configure.ac
index 4c37259..b43818b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -167,6 +167,8 @@ PKG_CHECK_MODULES([GLIB], [glib-2.0], ac_glib=yes, ac_glib=no)
 AM_CONDITIONAL([HAVE_GLIB], test "$ac_glib" = "yes")
 if test "$ac_glib" = "yes"; then
    AC_DEFINE([HAVE_GLIB], 1, [Define to 1 to indicate GLIB support])
+else
+   AC_MSG_ERROR(glib not found; glib2 is required)
 fi
 
 dnl Begin libibnetdisc stuff
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
