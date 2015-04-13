From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v3 25/28] IB/Verbs: Use management helper cap_af_ib()
Date: Mon, 13 Apr 2015 14:35:13 +0200
Message-ID: <552BB801.2010506@profitbricks.com>
References: <552BB470.4090407@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <552BB470.4090407@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Michael Wang <yun.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org


Introduce helper cap_af_ib() to help us check if the port of an
IB device support Native Infiniband Address.

Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/cma.c |  2 +-
 include/rdma/ib_verbs.h       | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 65e41f4..7f5815d 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -470,7 +470,7 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 
 	list_for_each_entry(cur_dev, &dev_list, list) {
 		for (p = 1; p <= cur_dev->device->phys_port_cnt; ++p) {
-			if (!rdma_ib_or_iboe(cur_dev->device, p))
+			if (!cap_af_ib(cur_dev->device, p))
 				continue;
 
 			if (ib_find_cached_pkey(cur_dev->device, p, pkey, &index))
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 29ddd14..dfe33f3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1879,6 +1879,21 @@ static inline int cap_ipoib(struct ib_device *device, u8 port_num)
 }
 
 /**
+ * cap_af_ib - Check if the port of device has the capability
+ * Native Infiniband Address.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return 0 when port of the device don't support
+ * Native Infiniband Address.
+ */
+static inline int cap_af_ib(struct ib_device *device, u8 port_num)
+{
+	return rdma_ib_or_iboe(device, port_num);
+}
+
+/**
  * cap_read_multi_sge - Check if the port of device has the capability
  * RDMA Read Multiple Scatter-Gather Entries.
  *
-- 
2.1.0
