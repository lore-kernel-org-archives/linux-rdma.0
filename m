From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/2] rsocket: Fix removing rsocket from service thread
Date: Thu,  3 Jul 2014 15:08:43 -0700
Message-ID: <1404425324-20201-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When removing an rsocket from a service thread, we replace
the removed service with the one at the end of the service list.
This keeps the array tightly packed.  However, rs_svc_rm_rs
decrements the rsocket count before doing the swap.  The result
is that the entry at the end of the list gets dropped off.
Defer decrementing the count until the swap has been made.

In this case, the cnt value is a valid index into the array,
because we start at index 1.  Index 0 is used internally by
the service thread.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/rsocket.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/rsocket.c b/src/rsocket.c
index f81fb1b..e9d12c7 100644
--- a/src/rsocket.c
+++ b/src/rsocket.c
@@ -3947,11 +3947,11 @@ static int rs_svc_rm_rs(struct rs_svc *svc, struct rsocket *rs)
 
 	for (i = 1; i <= svc->cnt; i++) {
 		if (svc->rss[i] == rs) {
-			svc->cnt--;
 			svc->rss[i] = svc->rss[svc->cnt];
 			memcpy(svc->contexts + i * svc->context_size,
 			       svc->contexts + svc->cnt * svc->context_size,
 			       svc->context_size);
+			svc->cnt--;
 			return 0;
 		}
 	}
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
