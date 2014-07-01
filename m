From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] IB/mlx4: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Tue,  1 Jul 2014 21:49:17 +0200
Message-ID: <1404244157-24367-1-git-send-email-fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

use macro definition

Cc: Roland Dreier <roland@kernel.org>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/infiniband/hw/mlx4/main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 0f7027e..0dc807f 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -910,8 +910,7 @@ static int __mlx4_ib_default_rules_match(struct ib_qp *qp,
 	const struct default_rules *pdefault_rules = default_table;
 	u8 link_layer = rdma_port_get_link_layer(qp->device, flow_attr->port);
 
-	for (i = 0; i < sizeof(default_table)/sizeof(default_table[0]); i++,
-	     pdefault_rules++) {
+	for (i = 0; i < ARRAY_SIZE(default_table); i++, pdefault_rules++) {
 		__u32 field_types[IB_FLOW_SPEC_SUPPORT_LAYERS];
 		memset(&field_types, 0, sizeof(field_types));
 
@@ -965,8 +964,7 @@ static int __mlx4_ib_create_default_rules(
 	int size = 0;
 	int i;
 
-	for (i = 0; i < sizeof(pdefault_rules->rules_create_list)/
-			sizeof(pdefault_rules->rules_create_list[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(pdefault_rules->rules_create_list); i++) {
 		int ret;
 		union ib_flow_spec ib_spec;
 		switch (pdefault_rules->rules_create_list[i]) {
-- 
1.9.1
