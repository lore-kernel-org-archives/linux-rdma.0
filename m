From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/7] ibacm: Add log message when incrementing SM destination
 reference count
Date: Fri, 4 Mar 2011 16:02:35 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC92EAC3@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The reference count for the SM destination structure is manually
incremented, but acm_put_dest is used to release it.  This results
in an unmatched put message in the ibacm log file.  Provide a matching
'get dest' log message when incrementing the SM destination.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index d52e83a..3590c16 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -438,6 +438,7 @@ acm_alloc_send(struct acm_ep *ep, struct acm_dest *dest, size_t size)
 	msg->wr.send_flags = IBV_SEND_SIGNALED;
 	msg->wr.wr_id = (uintptr_t) msg;
 
+	acm_log(2, "get dest %s\n", dest->name);
 	(void) atomic_inc(&dest->refcnt);
 	msg->dest = dest;
 	msg->wr.wr.ud.ah = dest->ah;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
