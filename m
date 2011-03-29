From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] man/rdma_notify: document EISCONN errno value
Date: Tue, 29 Mar 2011 12:10:28 +0200
Message-ID: <alpine.LRH.2.00.1103291209520.30460@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Document the fact that errno of EISCONN (Transport endpoint
is already connected) isn't a failure

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

---
 man/rdma_notify.3 |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/man/rdma_notify.3
===================================================================
--- a/man/rdma_notify.3
+++ b/man/rdma_notify.3
@@ -17,7 +17,9 @@ Used to notify the librdmacm of asynchro
 on a QP associated with the rdma_cm_id.
 .SH "RETURN VALUE"
 Returns 0 on success, or -1 on error.  If an error occurs, errno will be
-set to indicate the failure reason.
+set to indicate the failure reason, value of EISCONN (Transport endpoint
+is already connected) isn't considered a failure but rather means that
+the kernel stack has already established the connection.
 .SH "NOTES"
 Asynchronous events that occur on a QP are reported through the user's
 device event handler.  This routine is used to notify the librdmacm of
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
