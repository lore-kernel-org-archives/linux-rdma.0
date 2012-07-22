From: Yevgeny Kliteynik <kliteyn-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 1/3] configure.in: check that compiler supports __builtin_expect()
Date: Sun, 22 Jul 2012 13:47:17 +0300
Message-ID: <500BDA35.1060006@mellanox.co.il>
Reply-To: <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 configure.in | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/configure.in b/configure.in
index b2d07bc..0a56da6 100644
--- a/configure.in
+++ b/configure.in
@@ -56,6 +56,17 @@ AC_HEADER_TIME
 AC_STRUCT_TM
 AC_C_VOLATILE

+dnl See if we have __builtin_expect
+AC_MSG_CHECKING([if the compiler supports __builtin_expect])
+AC_TRY_COMPILE(, [ return __builtin_expect(1, 1) ? 1 : 0],
+		 [ have_builtin_expect=yes
+		   AC_MSG_RESULT([yes]) ],
+		 [ have_builtin_expect=no
+		   AC_MSG_RESULT([no])  ])
+if test "x_$have_builtin_expect" = "x_yes" ; then
+	AC_DEFINE([HAVE_BUILTIN_EXPECT], [1], [Define to 1 if the compiler supports __builtin_expect.])
+fi
+
 dnl We use --version-script with ld if possible
 AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
 if test -n "`$LD --help < /dev/null 2>/dev/null | grep version-script`"; then
-- 
1.7.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
