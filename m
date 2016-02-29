From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/9] IB/core: add a helper to check for READ WITH INVALIDATE support
Date: Mon, 29 Feb 2016 23:20:04 +0100
Message-ID: <1456784410-20166-4-git-send-email-hch@lst.de>
References: <1456784410-20166-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456784410-20166-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: swise@opengridcomputing.com, sagig@mellanox.com, bart.vanassche@sandisk.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/rdma/ib_verbs.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 2114929..267f11e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2286,6 +2286,15 @@ static inline bool rdma_cap_roce_gid_table(const struct ib_device *device,
 		device->add_gid && device->del_gid;
 }
 
+/*
+ * Check if the device supports READ W/ INVALIDATE.
+ */
+static inline bool rdma_has_read_invalidate(struct ib_device *dev, u32 port_num)
+{
+	/* iWarp requires READ W/ INVALIDATE.  No other device supports it yet */
+	return rdma_protocol_iwarp(dev, port_num);
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid,
 		 struct ib_gid_attr *attr);
-- 
2.1.4
