From: Honggang Li <honli@redhat.com>
Subject: [linux-next PATCH] IB/core: change rdma_gid2ip into void function as it always return zero
Date: Wed, 29 Apr 2015 17:40:44 +0800
Message-ID: <1430300444-29534-1-git-send-email-honli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, ork@mellanox.com, ogerlitz@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Honggang Li <honli@redhat.com>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Honggang Li <honli@redhat.com>
---
 drivers/infiniband/core/addr.c | 13 +++----------
 include/rdma/ib_addr.h         |  3 +--
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index f80da50..38339d2 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -472,13 +472,8 @@ int rdma_addr_find_dmac_by_grh(union ib_gid *sgid, union ib_gid *dgid, u8 *dmac,
 	} sgid_addr, dgid_addr;
 
 
-	ret = rdma_gid2ip(&sgid_addr._sockaddr, sgid);
-	if (ret)
-		return ret;
-
-	ret = rdma_gid2ip(&dgid_addr._sockaddr, dgid);
-	if (ret)
-		return ret;
+	rdma_gid2ip(&sgid_addr._sockaddr, sgid);
+	rdma_gid2ip(&dgid_addr._sockaddr, dgid);
 
 	memset(&dev_addr, 0, sizeof(dev_addr));
 
@@ -512,10 +507,8 @@ int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id)
 		struct sockaddr_in6 _sockaddr_in6;
 	} gid_addr;
 
-	ret = rdma_gid2ip(&gid_addr._sockaddr, sgid);
+	rdma_gid2ip(&gid_addr._sockaddr, sgid);
 
-	if (ret)
-		return ret;
 	memset(&dev_addr, 0, sizeof(dev_addr));
 	ret = rdma_translate_ip(&gid_addr._sockaddr, &dev_addr, vlan_id);
 	if (ret)
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index ce55906..ac54c27 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -160,7 +160,7 @@ static inline int rdma_ip2gid(struct sockaddr *addr, union ib_gid *gid)
 }
 
 /* Important - sockaddr should be a union of sockaddr_in and sockaddr_in6 */
-static inline int rdma_gid2ip(struct sockaddr *out, union ib_gid *gid)
+static inline void rdma_gid2ip(struct sockaddr *out, union ib_gid *gid)
 {
 	if (ipv6_addr_v4mapped((struct in6_addr *)gid)) {
 		struct sockaddr_in *out_in = (struct sockaddr_in *)out;
@@ -173,7 +173,6 @@ static inline int rdma_gid2ip(struct sockaddr *out, union ib_gid *gid)
 		out_in->sin6_family = AF_INET6;
 		memcpy(&out_in->sin6_addr.s6_addr, gid->raw, 16);
 	}
-	return 0;
 }
 
 static inline void iboe_addr_get_sgid(struct rdma_dev_addr *dev_addr,
-- 
1.8.3.1
