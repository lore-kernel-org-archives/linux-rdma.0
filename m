From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 1/9] IB/core: Fix use after free in send_leave function
Date: Sun, 28 Aug 2016 10:58:30 +0300
Message-ID: <1472371118-8260-2-git-send-email-leon@kernel.org>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472371118-8260-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The function send_leave sets the member: group->query_id
(group->query_id = ret) after calling the sa_query, but leave_handler
can be executed before the setting and it might delete the group object,
and will get a memory corruption.

Additionally, this patch gets rid of group->query_id variable which is
not used.

Fixes: faec2f7b96b5 ('IB/sa: Track multicast join/leave requests')
Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/multicast.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 3a3c5d7..51c79b2 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -106,7 +106,6 @@ struct mcast_group {
 	atomic_t		refcount;
 	enum mcast_group_state	state;
 	struct ib_sa_query	*query;
-	int			query_id;
 	u16			pkey_index;
 	u8			leave_state;
 	int			retries;
@@ -340,11 +339,7 @@ static int send_join(struct mcast_group *group, struct mcast_member *member)
 				       member->multicast.comp_mask,
 				       3000, GFP_KERNEL, join_handler, group,
 				       &group->query);
-	if (ret >= 0) {
-		group->query_id = ret;
-		ret = 0;
-	}
-	return ret;
+	return (ret > 0) ? 0 : ret;
 }
 
 static int send_leave(struct mcast_group *group, u8 leave_state)
@@ -364,11 +359,7 @@ static int send_leave(struct mcast_group *group, u8 leave_state)
 				       IB_SA_MCMEMBER_REC_JOIN_STATE,
 				       3000, GFP_KERNEL, leave_handler,
 				       group, &group->query);
-	if (ret >= 0) {
-		group->query_id = ret;
-		ret = 0;
-	}
-	return ret;
+	return (ret > 0) ? 0 : ret;
 }
 
 static void join_group(struct mcast_group *group, struct mcast_member *member,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
