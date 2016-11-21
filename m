From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/3] IB/multicast: Check ib_find_pkey() return value
Date: Mon, 21 Nov 2016 10:22:17 -0800
Message-ID: <950a0611-4aad-9b85-8d18-3dff54db2820@sandisk.com>
References: <94eb11fc-b558-b994-c933-da784caefc53@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <94eb11fc-b558-b994-c933-da784caefc53-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch avoids that Coverity complains about not checking the
ib_find_pkey() return value.

Fixes: commit 547af76521b3 ("IB/multicast: Report errors on multicast groups if P_key changes")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/core/multicast.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index e51b739..322cb67 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -518,8 +518,11 @@ static void join_handler(int status, struct ib_sa_mcmember_rec *rec,
 		process_join_error(group, status);
 	else {
 		int mgids_changed, is_mgid0;
-		ib_find_pkey(group->port->dev->device, group->port->port_num,
-			     be16_to_cpu(rec->pkey), &pkey_index);
+
+		if (ib_find_pkey(group->port->dev->device,
+				 group->port->port_num, be16_to_cpu(rec->pkey),
+				 &pkey_index))
+			pkey_index = MCAST_INVALID_PKEY_INDEX;
 
 		spin_lock_irq(&group->port->lock);
 		if (group->state == MCAST_BUSY &&
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
