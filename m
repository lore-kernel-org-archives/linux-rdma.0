From: Dag Moxnes <dag.moxnes@oracle.com>
Subject: [PATCH] RDMA/core: Fix race when resolving IP address
Date: Fri, 21 Jun 2019 16:09:16 +0200
Message-ID: <1561126156-10162-1-git-send-email-dag.moxnes@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dag.moxnes@oracle.com, dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Use neighbour lock when copying MAC address from neighbour data struct
in dst_fetch_ha.

When not using the lock, it is possible for the function to race with
neigh_update, causing it to copy an invalid MAC address.

It is possible to provoke this error by calling rdma_resolve_addr in a
tight loop, while deleting the corresponding ARP entry in another tight
loop.

Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
Change-Id: I3c5f982b304457f0a83ea7def2fac70315ed38b4
---
 drivers/infiniband/core/addr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 2f7d141598..e4945fd1bb 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -333,12 +333,16 @@ static int dst_fetch_ha(const struct dst_entry *dst,
 	if (!n)
 		return -ENODATA;
 
+	read_lock_bh(&n->lock)
 	if (!(n->nud_state & NUD_VALID)) {
-		neigh_event_send(n, NULL);
 		ret = -ENODATA;
 	} else {
 		memcpy(dev_addr->dst_dev_addr, n->ha, MAX_ADDR_LEN);
 	}
+	read_unlock_bh(&n->lock);
+
+	if (ret)
+		neigh_event_send(n, NULL);
 
 	neigh_release(n);
 
-- 
2.20.1
