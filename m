From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] IB/srp: Fix completion vector assignment algorithm
Date: Mon, 12 Feb 2018 09:50:25 -0800
Message-ID: <20180212175025.18955-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Laurence Oberman <loberman@redhat.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Alexander Schmid <alex@modula-shop-systems.de>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Ensure that cv_end is equal to ibdev->num_comp_vectors for the
NUMA node with the highest index. This patch improves spreading
of RDMA channels over completion vectors and thereby improves
performance, especially on systems with only a single NUMA node.
This patch drops support for the comp_vector login parameter by
ignoring the value of that parameter since I have not found a
good way to combine support for that parameter and automatic
spreading of RDMA channels over completion vectors.

Fixes: d92c0da71a35 ("IB/srp: Add multichannel support")
Reported-by: Alexander Schmid <alex@modula-shop-systems.de>
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Alexander Schmid <alex@modula-shop-systems.de>
Cc: stable@vger.kernel.org
---
 drivers/infiniband/ulp/srp/ib_srp.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b48843833d69..241c0e72dce3 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3871,12 +3871,10 @@ static ssize_t srp_create_target(struct device *dev,
 				      num_online_nodes());
 		const int ch_end = ((node_idx + 1) * target->ch_count /
 				    num_online_nodes());
-		const int cv_start = (node_idx * ibdev->num_comp_vectors /
-				      num_online_nodes() + target->comp_vector)
-				     % ibdev->num_comp_vectors;
-		const int cv_end = ((node_idx + 1) * ibdev->num_comp_vectors /
-				    num_online_nodes() + target->comp_vector)
-				   % ibdev->num_comp_vectors;
+		const int cv_start = node_idx * ibdev->num_comp_vectors /
+				     num_online_nodes();
+		const int cv_end = (node_idx + 1) * ibdev->num_comp_vectors /
+				   num_online_nodes();
 		int cpu_idx = 0;
 
 		for_each_online_cpu(cpu) {
-- 
2.16.1
