From: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 9/9] dapl-2.0:  scm: check for hca object before signaling
 thread
Date: Wed, 19 May 2010 11:25:27 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C983C70130E3@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


There may not be an hca object attached to cm object
when freeing during cleanup.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_scm/cm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/dapl/openib_scm/cm.c b/dapl/openib_scm/cm.c
index 975ffd5..ce0d961 100644
--- a/dapl/openib_scm/cm.c
+++ b/dapl/openib_scm/cm.c
@@ -322,7 +322,8 @@ static int dapl_select(struct dapl_fd_set *set)
 
 static void dapli_cm_thread_signal(dp_ib_cm_handle_t cm_ptr) 
 {
-	send(cm_ptr->hca->ib_trans.scm[1], "w", sizeof "w", 0);
+	if (cm_ptr->hca)
+		send(cm_ptr->hca->ib_trans.scm[1], "w", sizeof "w", 0);
 }
 
 static void dapli_cm_free(dp_ib_cm_handle_t cm_ptr) 
-- 
1.5.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
