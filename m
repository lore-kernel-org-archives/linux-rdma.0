From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc V1 2/9] IB/mlx4: Check gid_index return value
Date: Thu, 10 Nov 2016 11:30:54 +0200
Message-ID: <1478770261-5775-3-git-send-email-leon@kernel.org>
References: <1478770261-5775-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478770261-5775-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Check the returned GID index value and return an error if it is invalid.

Fixes: 5070cd2239bd ('IB/mlx4: Replace mechanism for RoCE GID management')
Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/ah.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 6be7dc3..8dfc76f 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -102,7 +102,10 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 	if (vlan_tag < 0x1000)
 		vlan_tag |= (ah_attr->sl & 7) << 13;
 	ah->av.eth.port_pd = cpu_to_be32(to_mpd(pd)->pdn | (ah_attr->port_num << 24));
-	ah->av.eth.gid_index = mlx4_ib_gid_index_to_real_index(ibdev, ah_attr->port_num, ah_attr->grh.sgid_index);
+	ret = mlx4_ib_gid_index_to_real_index(ibdev, ah_attr->port_num, ah_attr->grh.sgid_index);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	ah->av.eth.gid_index = ret;
 	ah->av.eth.vlan = cpu_to_be16(vlan_tag);
 	ah->av.eth.hop_limit = ah_attr->grh.hop_limit;
 	if (ah_attr->static_rate) {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
