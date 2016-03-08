From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 3/9] IB/core: add a helper to check for READ WITH INVALIDATE support
Date: Tue,  8 Mar 2016 19:16:34 +0100
Message-ID: <1457461000-24088-4-git-send-email-hch@lst.de>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1457461000-24088-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com, bart.vanassche@sandisk.com
Cc: sagig@mellanox.com, swise@opengridcomputing.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Steve Wise <swise@opengridcomputing.com>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
---
 include/rdma/ib_verbs.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1e21fb8..cdb9159 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2293,6 +2293,18 @@ static inline bool rdma_cap_roce_gid_table(const struct ib_device *device,
 		device->add_gid && device->del_gid;
 }
 
+/*
+ * Check if the device supports READ W/ INVALIDATE.
+ */
+static inline bool rdma_cap_read_inv(struct ib_device *dev, u32 port_num)
+{
+	/*
+	 * iWarp drivers must support READ W/ INVALIDATE.  No other protocol
+	 * has support for it yet.
+	 */
+	return rdma_protocol_iwarp(dev, port_num);
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid,
 		 struct ib_gid_attr *attr);
-- 
2.1.4
