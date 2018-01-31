From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH rdma-core] iwpmd: fix double mutex unlock
Date: Wed, 31 Jan 2018 21:07:51 +0530
Message-ID: <1517413071-20438-1-git-send-email-bharat@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

pthread_mutex_unlock() is used twice and this patch fixes it.

Fixes: be3fbf85b ("iwpmd: use ccan list.h for pending_messages")
Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 iwpmd/iwarp_pm_helper.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/iwpmd/iwarp_pm_helper.c b/iwpmd/iwarp_pm_helper.c
index bebc151f329b..b8c230189d50 100644
--- a/iwpmd/iwarp_pm_helper.c
+++ b/iwpmd/iwarp_pm_helper.c
@@ -578,7 +578,6 @@ int add_iwpm_pending_msg(iwpm_send_msg *send_msg)
 
 	pthread_mutex_lock(&pending_msg_mutex);
 	list_add(&pending_messages, &pending_msg->entry);
- 	pthread_mutex_unlock(&pending_msg_mutex);
 	pthread_mutex_unlock(&pending_msg_mutex);
 	/* signal the thread that a new message has been posted */
 	pthread_cond_signal(&cond_pending_msg);
-- 
2.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
