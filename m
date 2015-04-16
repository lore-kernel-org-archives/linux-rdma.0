From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v4 09/27] IB/Verbs: Reform IB-core verbs/uverbs_cmd/sysfs
Date: Thu, 16 Apr 2015 10:07:46 +0200
Message-ID: <552F6DD2.9040304@profitbricks.com>
References: <552F6CF2.4000606@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <552F6CF2.4000606@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, hal@dev.mellanox.co.il, Michael Wang <yun.wang@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org


Use raw management helpers to reform IB-core verbs/uverbs_cmd/sysfs.

Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/sysfs.c      | 8 ++------
 drivers/infiniband/core/uverbs_cmd.c | 6 ++++--
 drivers/infiniband/core/verbs.c      | 6 ++----
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index cbd0383..8570180 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -248,14 +248,10 @@ static ssize_t phys_state_show(struct ib_port *p, struct port_attribute *unused,
 static ssize_t link_layer_show(struct ib_port *p, struct port_attribute *unused,
 			       char *buf)
 {
-	switch (rdma_port_get_link_layer(p->ibdev, p->port_num)) {
-	case IB_LINK_LAYER_INFINIBAND:
+	if (rdma_tech_ib(p->ibdev, p->port_num))
 		return sprintf(buf, "%s\n", "InfiniBand");
-	case IB_LINK_LAYER_ETHERNET:
+	else
 		return sprintf(buf, "%s\n", "Ethernet");
-	default:
-		return sprintf(buf, "%s\n", "Unknown");
-	}
 }
 
 static PORT_ATTR_RO(state);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index a9f0489..5dc90aa 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -515,8 +515,10 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.active_width    = attr.active_width;
 	resp.active_speed    = attr.active_speed;
 	resp.phys_state      = attr.phys_state;
-	resp.link_layer      = rdma_port_get_link_layer(file->device->ib_dev,
-							cmd.port_num);
+	resp.link_layer      = rdma_tech_ib(file->device->ib_dev,
+							cmd.port_num) ?
+			       IB_LINK_LAYER_INFINIBAND :
+			       IB_LINK_LAYER_ETHERNET;
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 626c9cf..7264860 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -200,11 +200,9 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 	u32 flow_class;
 	u16 gid_index;
 	int ret;
-	int is_eth = (rdma_port_get_link_layer(device, port_num) ==
-			IB_LINK_LAYER_ETHERNET);
 
 	memset(ah_attr, 0, sizeof *ah_attr);
-	if (is_eth) {
+	if (rdma_tech_iboe(device, port_num)) {
 		if (!(wc->wc_flags & IB_WC_GRH))
 			return -EPROTOTYPE;
 
@@ -873,7 +871,7 @@ int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
 	union ib_gid  sgid;
 
 	if ((*qp_attr_mask & IB_QP_AV)  &&
-	    (rdma_port_get_link_layer(qp->device, qp_attr->ah_attr.port_num) == IB_LINK_LAYER_ETHERNET)) {
+	    (rdma_tech_iboe(qp->device, qp_attr->ah_attr.port_num))) {
 		ret = ib_query_gid(qp->device, qp_attr->ah_attr.port_num,
 				   qp_attr->ah_attr.grh.sgid_index, &sgid);
 		if (ret)
-- 
2.1.0
