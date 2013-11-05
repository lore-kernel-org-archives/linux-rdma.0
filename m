From: Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] librdmacm: Some fixes to man pages
Date: Tue,  5 Nov 2013 19:52:20 +0200
Message-ID: <1383673940-15683-1-git-send-email-guysh@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fix the man pages of rdma_destroy_ep & rdma_destroy_qp to the correct return value (void).
---
 man/rdma_destroy_ep.3 |    5 +----
 man/rdma_destroy_qp.3 |    3 ---
 2 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/man/rdma_destroy_ep.3 b/man/rdma_destroy_ep.3
index b48a1e5..750702a 100644
--- a/man/rdma_destroy_ep.3
+++ b/man/rdma_destroy_ep.3
@@ -5,16 +5,13 @@ rdma_destroy_ep \- Release a communication identifier.
 .SH SYNOPSIS
 .B "#include <rdma/rdma_cma.h>"
 .P
-.B "int" rdma_destroy_ep
+.B "void" rdma_destroy_ep
 .BI "(struct rdma_cm_id *" id ");"
 .SH ARGUMENTS
 .IP "id" 12
 The communication identifier to destroy.
 .SH "DESCRIPTION"
 Destroys the specified rdma_cm_id and all associated resources
-.SH "RETURN VALUE"
-Returns 0 on success, or -1 on error.  If an error occurs, errno will be
-set to indicate the failure reason.
 .SH "NOTES"
 rdma_destroy_ep will automatically destroy any QP and SRQ associated with
 the rdma_cm_id.
diff --git a/man/rdma_destroy_qp.3 b/man/rdma_destroy_qp.3
index aeff667..bb1360e 100644
--- a/man/rdma_destroy_qp.3
+++ b/man/rdma_destroy_qp.3
@@ -11,9 +11,6 @@ rdma_destroy_qp \- Deallocate a QP.
 RDMA identifier.
 .SH "DESCRIPTION"
 Destroy a QP allocated on the rdma_cm_id.
-.SH "RETURN VALUE"
-Returns 0 on success, or -1 on error.  If an error occurs, errno will be
-set to indicate the failure reason.
 .SH "NOTES"
 Users must destroy any QP associated with an rdma_cm_id before
 destroying the ID.
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
