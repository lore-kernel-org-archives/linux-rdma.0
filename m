From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/5] IB/mlx5: Use kernel driver to help userspace create address handle
Date: Wed, 23 Nov 2016 08:23:25 +0200
Message-ID: <1479882206-31212-5-git-send-email-leon@kernel.org>
References: <1479882206-31212-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479882206-31212-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Resolving a MAC address for a given IP address in userspace is inefficient.
This patch lets mlx5 user driver using the kernel driver to resolve the mac
and get the answer in the private section of the response.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/ah.c | 21 +++++++++++++++++++++
 include/uapi/rdma/mlx5-abi.h    |  6 ++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/ah.c b/drivers/infiniband/hw/mlx5/ah.c
index ecac9ea..d090e96 100644
--- a/drivers/infiniband/hw/mlx5/ah.c
+++ b/drivers/infiniband/hw/mlx5/ah.c
@@ -77,6 +77,27 @@ struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
 	if (ll == IB_LINK_LAYER_ETHERNET && !(ah_attr->ah_flags & IB_AH_GRH))
 		return ERR_PTR(-EINVAL);
 
+	if (ll == IB_LINK_LAYER_ETHERNET && udata) {
+		int err;
+		struct mlx5_ib_create_ah_resp resp = {};
+		u32 min_resp_len = offsetof(typeof(resp), dmac) +
+				   sizeof(resp.dmac);
+
+		if (udata->outlen < min_resp_len)
+			return ERR_PTR(-EINVAL);
+
+		resp.response_length = min_resp_len;
+
+		err = ib_resolve_eth_dmac(pd->device, ah_attr);
+		if (err)
+			return ERR_PTR(err);
+
+		memcpy(resp.dmac, ah_attr->dmac, ETH_ALEN);
+		err = ib_copy_to_udata(udata, &resp, resp.response_length);
+		if (err)
+			return ERR_PTR(err);
+	}
+
 	ah = kzalloc(sizeof(*ah), GFP_ATOMIC);
 	if (!ah)
 		return ERR_PTR(-ENOMEM);
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index ef05a98..1b7326f 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -233,6 +233,12 @@ struct mlx5_ib_create_wq {
 	__u32   reserved;
 };
 
+struct mlx5_ib_create_ah_resp {
+	__u32	response_length;
+	__u8	dmac[ETH_ALEN];
+	__u8	reserved[6];
+};
+
 struct mlx5_ib_create_wq_resp {
 	__u32	response_length;
 	__u32	reserved;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
