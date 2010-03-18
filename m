From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] librdmacm: document/clarify the delivery of connection
 established event
Date: Thu, 18 Mar 2010 16:13:29 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1003181612390.25589@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alexander Nezhinsky <alexandern-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Applications based on the rdma-cm may assume that established event
is always delivered by the the kernel stack, clarify that.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

diff --git a/man/rdma_notify.3 b/man/rdma_notify.3
index 7114ac4..82e1008 100644
--- a/man/rdma_notify.3
+++ b/man/rdma_notify.3
@@ -24,6 +24,8 @@ necessary, however if connection establishment is done out of band
 QP that is not yet considered connected.  This routine forces the
 connection into an established state in this case in order to handle
 the rare situation where the connection never forms on its own.
+Calling this routine ensures the delivery of the RDMA_CM_EVENT_ESTABLISHED
+event to the application.
 Events that should be reported to the CM are: IB_EVENT_COMM_EST.
 .SH "SEE ALSO"
 rdma_connect(3), rdma_accept(3), rdma_listen(3)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
