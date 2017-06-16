From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 01/19] ib_core: Enable and expose force_mr module
 parameter
Date: Fri, 16 Jun 2017 11:20:29 -0400
Message-ID: <20170616152029.14210.50090.stgit@klimt.1015granger.net>
References: <20170616151535.14210.34926.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170616151535.14210.34926.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The fourth parameter of the module_param_named macro is a set of
file permissions. Passing 0 there means that module parameter is
not created and that adding "options ib_core force_mr=1" to a
modprobe.conf file has no effect.

The default setting of rdma_rw_force_mr continues to be 0, or false.

Fixes: a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/rw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index dbfd854..1cc8f07 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -23,7 +23,7 @@ enum {
 };
 
 static bool rdma_rw_force_mr;
-module_param_named(force_mr, rdma_rw_force_mr, bool, 0);
+module_param_named(force_mr, rdma_rw_force_mr, bool, 0644);
 MODULE_PARM_DESC(force_mr, "Force usage of MRs for RDMA READ/WRITE operations");
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
