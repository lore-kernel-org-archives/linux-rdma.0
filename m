From: David Reynolds <david-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] librdmacm: Fix incorrect return value/type in a few man pages
Date: Fri, 30 Jun 2017 18:30:26 -0400
Message-ID: <20170630223026.57939-1-david@omnibond.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: David Reynolds <david-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: David Reynolds <david-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org>
---
 librdmacm/man/rdma_dereg_mr.3              | 2 +-
 librdmacm/man/rdma_destroy_event_channel.3 | 3 +--
 librdmacm/man/rdma_destroy_srq.3           | 3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/librdmacm/man/rdma_dereg_mr.3 b/librdmacm/man/rdma_dereg_mr.3
index 1fe936b2..893eb14b 100644
--- a/librdmacm/man/rdma_dereg_mr.3
+++ b/librdmacm/man/rdma_dereg_mr.3
@@ -5,7 +5,7 @@ rdma_dereg_mr \- deregisters a registered memory region.
 .SH SYNOPSIS
 .B "#include <rdma/rdma_verbs.h>"
 .P
-.B "struct ibv_mr *" rdma_dereg_mr
+.B "int" rdma_dereg_mr
 .BI "(struct ibv_mr *" mr ");"
 .SH ARGUMENTS
 .IP "mr" 12
diff --git a/librdmacm/man/rdma_destroy_event_channel.3 b/librdmacm/man/rdma_destroy_event_channel.3
index 5bc982a7..5c5d663c 100644
--- a/librdmacm/man/rdma_destroy_event_channel.3
+++ b/librdmacm/man/rdma_destroy_event_channel.3
@@ -14,8 +14,7 @@ The communication channel to destroy.
 Release all resources associated with an event channel and closes the
 associated file descriptor.
 .SH "RETURN VALUE"
-Returns 0 on success, or -1 on error.  If an error occurs, errno will be
-set to indicate the failure reason.
+None
 .SH "NOTES"
 All rdma_cm_id's associated with the event channel must be destroyed,
 and all returned events must be acked before calling this function.
diff --git a/librdmacm/man/rdma_destroy_srq.3 b/librdmacm/man/rdma_destroy_srq.3
index 5c633a8d..75c23c73 100644
--- a/librdmacm/man/rdma_destroy_srq.3
+++ b/librdmacm/man/rdma_destroy_srq.3
@@ -13,8 +13,7 @@ RDMA identifier.
 .SH "DESCRIPTION"
 Destroy an SRQ allocated on the rdma_cm_id.
 .SH "RETURN VALUE"
-Returns 0 on success, or -1 on error.  If an error occurs, errno will be
-set to indicate the failure reason.
+None
 .SH "NOTES"
 Users should destroy any SRQ associated with an rdma_cm_id before
 destroying the ID.
-- 
2.11.0 (Apple Git-81)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
