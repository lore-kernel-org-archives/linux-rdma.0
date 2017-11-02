From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/5] IB/mlx4: Increase maximal message size under UD QP
Date: Thu,  2 Nov 2017 15:22:26 +0200
Message-ID: <20171102132228.20985-4-leon@kernel.org>
References: <20171102132228.20985-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102132228.20985-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Maximal message should be used as a limit to the max message payload allowed,
without the headers. The ConnectX-3 check is done against this value includes
the headers. When the payload is 4K this will cause the NIC to drop packets.

Increase maximal message to 8K as workaround, this shouldn't change current
behaviour because we continue to set the MTU to 4k.

To reproduce;
set MTU to 4296 on the corresponding interface, for example:
ifconfig eth0 mtu 4296 (both server and client)

On server:
ib_send_bw -c UD -d mlx4_0 -s 4096 -n 1000000 -i1 -m 4096

On client:
ib_send_bw -d mlx4_0 -c UD <server_ip> -s 4096 -n 1000000 -i 1 -m 4096

Fixes: 6e0d733d9215 ("IB/mlx4: Allow 4K messages for UD QPs")
Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 3e030ae6ca4f..6bd5a23c30ae 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2220,7 +2220,7 @@ static int __mlx4_ib_modify_qp(void *src, enum mlx4_ib_source_type src_type,
 			context->mtu_msgmax = (IB_MTU_4096 << 5) |
 					      ilog2(dev->dev->caps.max_gso_sz);
 		else
-			context->mtu_msgmax = (IB_MTU_4096 << 5) | 12;
+			context->mtu_msgmax = (IB_MTU_4096 << 5) | 13;
 	} else if (attr_mask & IB_QP_PATH_MTU) {
 		if (attr->path_mtu < IB_MTU_256 || attr->path_mtu > IB_MTU_4096) {
 			pr_err("path MTU (%u) is invalid\n",
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
