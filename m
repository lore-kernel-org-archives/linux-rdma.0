From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs 7/9] ibv_cmd_create_flow(): explicitly clear fields
Date: Wed,  1 Oct 2014 13:49:37 +0200
Message-ID: <8b641d9acad075b54092dc7a44ff987ec49fc9b5.1412163687.git.ydroneaud@opteya.com>
References: <cover.1412163687.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There's no need to clear the whole struct ibv_create_flow
+ struct ibv_kern_spec with memset().

This patch removes call to memset(), adds explicit
initialization for reserved fields, set comp_mask
explicitly

Link: http://marc.info/?i=cover.1412163687.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Fixes: 389de6a6ef4e ('Add receive flow steering support')
Cc: Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/cmd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/cmd.c b/src/cmd.c
index f9e4a03fd84d..dc155d6bf4c7 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -1289,6 +1289,7 @@ static int ib_spec_to_kern_spec(struct ibv_flow_spec *ib_spec,
 				struct ibv_kern_spec *kern_spec)
 {
 	kern_spec->hdr.type = ib_spec->hdr.type;
+	kern_spec->hdr.reserved = 0;
 
 	switch (ib_spec->hdr.type) {
 	case IBV_FLOW_SPEC_ETH:
@@ -1337,15 +1338,17 @@ struct ibv_flow *ibv_cmd_create_flow(struct ibv_qp *qp,
 	flow_id = malloc(sizeof(*flow_id));
 	if (!flow_id)
 		return NULL;
-	memset(cmd, 0, cmd_size);
 
+	cmd->comp_mask = 0;
 	cmd->qp_handle = qp->handle;
 
+	cmd->flow_attr.size = 0;
 	cmd->flow_attr.type = flow_attr->type;
 	cmd->flow_attr.priority = flow_attr->priority;
 	cmd->flow_attr.num_of_specs = flow_attr->num_of_specs;
 	cmd->flow_attr.port = flow_attr->port;
 	cmd->flow_attr.flags = flow_attr->flags;
+	cmd->flow_attr.reserved[0] = cmd->flow_attr.reserved[1] = 1;
 
 	kern_spec = cmd + 1;
 	ib_spec = flow_attr + 1;
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
