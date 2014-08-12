From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/8] IB/mlx4: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Tue, 12 Aug 2014 19:20:07 -0400
Message-ID: <e43725ba24645298d55960c6c63208f4c52317c6.1407885084.git.dledford@redhat.com>
References: <cover.1407885084.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1407885084.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>

use macro definition

Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 828a37b2481..e1e558a3d69 100644
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
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
