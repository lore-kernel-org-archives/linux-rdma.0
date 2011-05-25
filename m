From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] infiniband-diags/configure.in: Support override for IBPATH
Date: Wed, 25 May 2011 08:30:06 -0400
Message-ID: <4DDCF64E.6050702@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Doron Tsur <doront-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Basing IBPATH on sbindir is not always what is desired.
Allow for override of IBPATH, when this is not the case.

Signed-off-by: Doron Tsur <doront-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/configure.in b/configure.in
index 350a11e..c6e8663 100644
--- a/configure.in
+++ b/configure.in
@@ -144,11 +144,17 @@ AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
 
 AM_CONDITIONAL(HAVE_LD_VERSION_SCRIPT, test "$ac_cv_version_script" = "yes")
 
+dnl Define override for IBPATH
+AC_ARG_WITH(ibpath_override,
+[  --with-ibpath_override=<path> define ib binaries path],
+AC_MSG_NOTICE(Using IBPATH : $with_ibpath_override),
+with_ibpath_override=)
+
 dnl Make appropriate substitution for IB script path
 dnl Must expand nested unquoting
 IBSCRIPTPATH_TMP1="`eval echo ${sbindir}`"
 IBSCRIPTPATH_TMP2="`echo $IBSCRIPTPATH_TMP1 | sed 's/^NONE/$ac_default_prefix/'`"
-IBSCRIPTPATH="`eval echo $IBSCRIPTPATH_TMP2`"
+IBSCRIPTPATH="${with_ibpath_override:-`eval echo $IBSCRIPTPATH_TMP2`}"
 AC_SUBST(IBSCRIPTPATH)
 
 dnl Begin libibnetdisc stuff
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
