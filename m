From: Dag Moxnes <dag.moxnes@oracle.com>
Subject: [PATCH v2] RDMA/core: Fix race when resolving IP address
Date: Fri, 28 Jun 2019 10:49:23 +0200
Message-ID: <1561711763-24705-1-git-send-email-dag.moxnes@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dag.moxnes@oracle.com, dledford@redhat.com, jgg@ziepe.ca, leon@kernel.org, parav@mellanox.com
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
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>

---
v1 -> v2:
   * Modified implementation to improve readability
---
 drivers/infiniband/core/addr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 2f7d141598..51323ffbc5 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -333,11 +333,14 @@ static int dst_fetch_ha(const struct dst_entry *dst,
 	if (!n)
 		return -ENODATA;
 
-	if (!(n->nud_state & NUD_VALID)) {
+	read_lock_bh(&n->lock);
+	if (n->nud_state & NUD_VALID) {
+		memcpy(dev_addr->dst_dev_addr, n->ha, MAX_ADDR_LEN);
+		read_unlock_bh(&n->lock);
+	} else {
+		read_unlock_bh(&n->lock);
 		neigh_event_send(n, NULL);
 		ret = -ENODATA;
-	} else {
-		memcpy(dev_addr->dst_dev_addr, n->ha, MAX_ADDR_LEN);
 	}
 
 	neigh_release(n);
-- 
2.20.1
