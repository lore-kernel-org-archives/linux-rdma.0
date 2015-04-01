From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 8/9] net/mlx4_core: Return the admin alias GUID upon host view request
Date: Wed,  1 Apr 2015 14:14:14 +0300
Message-ID: <1427886855-16727-9-git-send-email-ogerlitz@mellanox.com>
References: <1427886855-16727-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427886855-16727-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Return the admin alias GUID value upon a GET request via HOST. We do this so
that the GUID value requested by the admin is returned even if the SM has not
yet approved this GUID (e.g. the SM is down).

Note that this does not create a problem, since the virtual port will remain
down until the SM does ACK the requested GUID value.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c |   41 +++++++++++++++++++----------
 1 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 778de74..bcc6b2d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -936,21 +936,34 @@ static int mlx4_MAD_IFC_wrapper(struct mlx4_dev *dev, int slave,
 				return err;
 			}
 			if (smp->attr_id == IB_SMP_ATTR_GUID_INFO) {
-				/* compute slave's gid block */
-				smp->attr_mod = cpu_to_be32(slave / 8);
-				/* execute cmd */
-				err = mlx4_cmd_box(dev, inbox->dma, outbox->dma,
-					     vhcr->in_modifier, opcode_modifier,
-					     vhcr->op, MLX4_CMD_TIME_CLASS_C, MLX4_CMD_NATIVE);
-				if (!err) {
-					/* if needed, move slave gid to index 0 */
-					if (slave % 8)
-						memcpy(outsmp->data,
-						       outsmp->data + (slave % 8) * 8, 8);
-					/* delete all other gids */
-					memset(outsmp->data + 8, 0, 56);
+				__be64 guid = mlx4_get_admin_guid(dev, slave,
+								  port);
+
+				/* set the PF admin guid to the FW/HW burned
+				 * GUID, if it wasn't yet set
+				 */
+				if (slave == 0 && guid == 0) {
+					smp->attr_mod = 0;
+					err = mlx4_cmd_box(dev,
+							   inbox->dma,
+							   outbox->dma,
+							   vhcr->in_modifier,
+							   opcode_modifier,
+							   vhcr->op,
+							   MLX4_CMD_TIME_CLASS_C,
+							   MLX4_CMD_NATIVE);
+					if (err)
+						return err;
+					mlx4_set_admin_guid(dev,
+							    *(__be64 *)outsmp->
+							    data, slave, port);
+				} else {
+					memcpy(outsmp->data, &guid, 8);
 				}
-				return err;
+
+				/* clean all other gids */
+				memset(outsmp->data + 8, 0, 56);
+				return 0;
 			}
 			if (smp->attr_id == IB_SMP_ATTR_NODE_INFO) {
 				err = mlx4_cmd_box(dev, inbox->dma, outbox->dma,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
