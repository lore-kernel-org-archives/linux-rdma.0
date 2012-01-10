From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] infiniband-diags/configure.in: Fix typo
Date: Tue, 10 Jan 2012 15:22:58 -0500
Message-ID: <4F0C9E22.7010308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/configure.in b/configure.in
index 5a596dc..215c1ea 100644
--- a/configure.in
+++ b/configure.in
@@ -65,7 +65,7 @@ IBDIAG_CONFIG_PATH_TMP1="`eval echo ${sysconfdir}`"
 IBDIAG_CONFIG_PATH_TMP2="`echo $IBDIAG_CONFIG_PATH_TMP1 | sed 's/^NONE/$ac_default_prefix/'`"
 IBDIAG_CONFIG_PATH="`eval echo $IBDIAG_CONFIG_PATH_TMP2`/infiniband-diags"
 AC_SUBST(IBDIAG_CONFIG_PATH)
-AC_DEFINE_UNQUOTED([IBDIAG_CONFIG_PATH], "$IBDIAG_CONFIG_PATH", [Define the path to configuratios])
+AC_DEFINE_UNQUOTED([IBDIAG_CONFIG_PATH], "$IBDIAG_CONFIG_PATH", [Define the path to configurations])
 
 dnl Check if we should include test utilities
 AC_MSG_CHECKING(for --enable-test-utils)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
