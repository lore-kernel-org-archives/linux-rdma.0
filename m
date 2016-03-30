From: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] RDS: sync congestion map updating
Date: Wed, 30 Mar 2016 17:08:22 +0800
Message-ID: <1459328902-31968-1-git-send-email-wen.gang.wang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Problem is found that some among a lot of parallel RDS communications hang.
In my test ten or so among 33 communications hang. The send requests got
-ENOBUF error meaning the peer socket (port) is congested. But meanwhile,
peer socket (port) is not congested.

The congestion map updating can happen in two paths: one is in rds_recvmsg path
and the other is when it receives packets from the hardware. There is no
synchronization when updating the congestion map. So a bit operation (clearing)
in the rds_recvmsg path can be skipped by another bit operation (setting) in
hardware packet receving path.

Fix is to add a spin lock per congestion map to sync the update on it.
No performance drop found during the test for the fix.

Signed-off-by: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/rds/cong.c | 7 +++++++
 net/rds/rds.h  | 1 +
 2 files changed, 8 insertions(+)

diff --git a/net/rds/cong.c b/net/rds/cong.c
index e6144b8..7afc1bf 100644
--- a/net/rds/cong.c
+++ b/net/rds/cong.c
@@ -144,6 +144,7 @@ static struct rds_cong_map *rds_cong_from_addr(__be32 addr)
 	if (!map)
 		return NULL;
 
+	spin_lock_init(&map->m_lock);
 	map->m_addr = addr;
 	init_waitqueue_head(&map->m_waitq);
 	INIT_LIST_HEAD(&map->m_conn_list);
@@ -292,6 +293,7 @@ void rds_cong_set_bit(struct rds_cong_map *map, __be16 port)
 {
 	unsigned long i;
 	unsigned long off;
+	unsigned long flags;
 
 	rdsdebug("setting congestion for %pI4:%u in map %p\n",
 	  &map->m_addr, ntohs(port), map);
@@ -299,13 +301,16 @@ void rds_cong_set_bit(struct rds_cong_map *map, __be16 port)
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
+	spin_lock_irqsave(&map->m_lock, flags);
 	__set_bit_le(off, (void *)map->m_page_addrs[i]);
+	spin_unlock_irqrestore(&map->m_lock, flags);
 }
 
 void rds_cong_clear_bit(struct rds_cong_map *map, __be16 port)
 {
 	unsigned long i;
 	unsigned long off;
+	unsigned long flags;
 
 	rdsdebug("clearing congestion for %pI4:%u in map %p\n",
 	  &map->m_addr, ntohs(port), map);
@@ -313,7 +318,9 @@ void rds_cong_clear_bit(struct rds_cong_map *map, __be16 port)
 	i = be16_to_cpu(port) / RDS_CONG_MAP_PAGE_BITS;
 	off = be16_to_cpu(port) % RDS_CONG_MAP_PAGE_BITS;
 
+	spin_lock_irqsave(&map->m_lock, flags);
 	__clear_bit_le(off, (void *)map->m_page_addrs[i]);
+	spin_unlock_irqrestore(&map->m_lock, flags);
 }
 
 static int rds_cong_test_bit(struct rds_cong_map *map, __be16 port)
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 80256b0..f359cf8 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -59,6 +59,7 @@ struct rds_cong_map {
 	__be32			m_addr;
 	wait_queue_head_t	m_waitq;
 	struct list_head	m_conn_list;
+	spinlock_t		m_lock;
 	unsigned long		m_page_addrs[RDS_CONG_MAP_PAGES];
 };
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
