From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: configure.in; check for more recent
 function in libibmad
Date: Tue, 12 Jul 2011 14:42:29 -0700
Message-ID: <20110712144229.13a3da7d.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 configure.in |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/configure.in b/configure.in
index f41f049..dfb6ba2 100644
--- a/configure.in
+++ b/configure.in
@@ -35,8 +35,9 @@ then
 dnl Checks for libraries
 AC_CHECK_LIB(ibumad, umad_init, [],
 	AC_MSG_ERROR([umad_init() not found. diags require libibumad.]))
-AC_CHECK_LIB(ibmad, mad_dump_int, [],
-	AC_MSG_ERROR([mad_dump_int() not found. diags require libibmad.]))
+AC_CHECK_LIB(ibmad, mad_dump_perfcounters_rcv_err, [],
+	AC_MSG_ERROR([mad_dump_perfcounters_rcv_err() not found.
+	diags require libibmad with mad_dump_perfcounters_rcv_err support.]))
 AC_CHECK_LIB(ibmad, pma_query_via, [],
 	AC_MSG_ERROR([pma_query_via() not found. diags require more recent libibmad.]))
 AC_CHECK_MEMBER([struct umad_port.link_layer],
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
