From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next] IB/core: Fix mgid key handling in SA agent multicast data-base
Date: Wed, 19 Nov 2014 11:08:58 +0200
Message-ID: <1416388138-25669-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Applications can request that the SM assign an mgid, by passing a mcast
member request containing an mgid = 0. When the SM responds by sending
the allocated mgid, this mgid replaces the 0-mgid in the multicast group.

However, the mgid field in the group is also the key field in the IB core
multicast code red-black tree containing the multicast groups for the port.

Since this is a key field, correct handling requires that the group entry
be deleted from the rb table, and then re-inserted with the new key,
so that the table structure is properly maintained.

The current code does not do this correctly. Correct operation
requires that if the key-field gid has changed at all, it should
be deleted and re-inserted, fix that.

Note that when inserting, if the new mgid is zero (not the case here
but the code should handle this correctly), we allow duplicate entries
for 0-mgids.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/multicast.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index d2360a8..fa17b55 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -525,17 +525,22 @@ static void join_handler(int status, struct ib_sa_mcmember_rec *rec,
 	if (status)
 		process_join_error(group, status);
 	else {
+		int mgids_changed, is_mgid0;
 		ib_find_pkey(group->port->dev->device, group->port->port_num,
 			     be16_to_cpu(rec->pkey), &pkey_index);
 
 		spin_lock_irq(&group->port->lock);
-		group->rec = *rec;
 		if (group->state == MCAST_BUSY &&
 		    group->pkey_index == MCAST_INVALID_PKEY_INDEX)
 			group->pkey_index = pkey_index;
-		if (!memcmp(&mgid0, &group->rec.mgid, sizeof mgid0)) {
+		mgids_changed = memcmp(&rec->mgid, &group->rec.mgid,
+				       sizeof(group->rec.mgid));
+		group->rec = *rec;
+		if (mgids_changed) {
 			rb_erase(&group->node, &group->port->table);
-			mcast_insert(group->port, group, 1);
+			is_mgid0 = !memcmp(&mgid0, &group->rec.mgid,
+					   sizeof(mgid0));
+			mcast_insert(group->port, group, is_mgid0);
 		}
 		spin_unlock_irq(&group->port->lock);
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
