From: Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH rdma] IB/cache: Restore compatibility for ib_query_gid
Date: Fri, 27 Jul 2018 09:54:02 -0600
Message-ID: <20180727155402.GA15253@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Parav Pandit <parav@mellanox.com>, Ursula Braun <ubraun@linux.ibm.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Code changes in smc have become so complicated this cycle that the RDMA
patches to remove ib_query_gid in smc create too complex merge conflicts.
Allow those conflicts to be resolved by using the net/smc hunks by
providing a compatibility wrapper. During the second phase of the merge
window this wrapper will be deleted and smc updated to use the new API.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 include/rdma/ib_cache.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

The resolution Stephen had to make is too complicated, I think we
should go this way instead. Parav can send a patch to DaveM during the
2nd half of the merge window to safely update SMC and delete this
wrapper.

Parav, can you check this?

Ursula, this is only for SMC, are you able to test SMC with it? You
will need to apply it to the RDMA tree here:

https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=for-next

Thanks,
Jason

diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index 1108d422027696..c7e9b42b96e5b8 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -132,4 +132,28 @@ const struct ib_gid_attr *rdma_get_gid_attr(struct ib_device *device,
 					    u8 port_num, int index);
 void rdma_put_gid_attr(const struct ib_gid_attr *attr);
 void rdma_hold_gid_attr(const struct ib_gid_attr *attr);
+
+/*
+ * This is to be removed. It only exists to make merging rdma and smc simpler.
+ */
+static inline __deprecated int ib_query_gid(struct ib_device *device,
+					    u8 port_num, int index,
+					    union ib_gid *gid,
+					    struct ib_gid_attr *attr_out)
+{
+	const struct ib_gid_attr *attr;
+
+	attr = rdma_get_gid_attr(device,port_num,index);
+	if (IS_ERR(attr))
+		return PTR_ERR(attr);
+
+	if (attr->ndev)
+		dev_hold(attr->ndev);
+	*attr_out = *attr;
+
+	rdma_put_gid_attr(attr);
+
+	return 0;
+}
+
 #endif /* _IB_CACHE_H */
-- 
2.18.0
