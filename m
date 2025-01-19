Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1C9157A5C
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jan 2025 12:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737290394; cv=none; b=aqpgn4AdzBcV8LAeqn47hqeqL77PXIu5NS0FDIhPRxC+luKU6siqcBWJc+PgCnvuLE5lydMA9iSo2o5H3yUVcy39AVn45WyWcwltN3Y91MHaRQKL0oFAHSFiNV20wFh+LbprFkuToTL+JSNH356a/vRelXH74pYAyUmi0aUz5TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737290394; c=relaxed/simple;
	bh=KgvRDMSsBT6/u8+zLF5s4vta75mkpkgc+8l1HleUEwA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oeUnzt8TdYdbQKLjqCQwlKrqQvAvxuuCQAmCblLYyNKNiqCAkV6VgEszppfrcXpRiG+S6r978G7cyjTcqd60d14QvmaY/qeOr8AsRsjRehJVT6mfqRUNPX0EKizSPJXT+SpFxZdwEVHpLmjcVmMg5Rsow9N3d7d+lICfbNsjxk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+Peht7V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+Peht7V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96890C4CED6;
	Sun, 19 Jan 2025 12:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737290394;
	bh=KgvRDMSsBT6/u8+zLF5s4vta75mkpkgc+8l1HleUEwA=;
	h=From:To:Cc:Subject:Date:From;
	b=W+Peht7V0dlTpFElFa4muPiFpN1ZZqsB4+KNKB20wrJuvBg0JmdrZML/4DAOX3LgE
	 sQUb0F2SCJbckWgEHkTYE/SRKIej6h72nJgfKAkYDe4FibmVciRwEBHZPDgrci3ipz
	 Sz0MSIr49wqXbmV1SVoVNiO0WUzBZyeTQGj0OPMiCpphhu2j4BISex/J9vnqqdZpb6
	 +jeAHae6ZjsBmxgwUkVvpOTZ0CY/K2d7IFu1miVRig1/as5SYmJTAoGYHy8EDP7vI2
	 5BzhJCeIb5dmmFBuU9AWAGfoPuJ2Tmcy6NvP5IMvq7bvTgnmN+VUk/WbYmc4dvS+C3
	 28rX9Ef0Vz2AQ==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mark Zhang <markzhang@nvidia.com>,
	linux-rdma@vger.kernel.org,
	Maher Sanalla <msanalla@nvidia.com>,
	Maor Gottlieb <maorg@mellanox.com>,
	Mark Zhang <markz@mellanox.com>
Subject: [PATCH rdma-next] IB/mlx5: Set and get correct qp_num for a DCT QP
Date: Sun, 19 Jan 2025 14:39:46 +0200
Message-ID: <94c76bf0adbea997f87ffa27674e0a7118ad92a9.1737290358.git.leon@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mark Zhang <markzhang@nvidia.com>

When a DCT QP is created on an active lag, it's dctc.port is assigned
in a round-robin way, which is from 1 to dev->lag_port. In this case
when querying this QP, we may get qp_attr.port_num > 2.
Fix this by setting qp->port when modifying a DCT QP, and read port_num
from qp->port instead of dctc.port when querying it.

Fixes: 7c4b1ab9f167 ("IB/mlx5: Add DCT RoCE LAG support")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 88b6d9797a33..d0d877e1b499 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4581,6 +4581,8 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 		set_id = mlx5_ib_get_counters_id(dev, attr->port_num - 1);
 		MLX5_SET(dctc, dctc, counter_set_id, set_id);
+
+		qp->port = attr->port_num;
 	} else if (cur_state == IB_QPS_INIT && new_state == IB_QPS_RTR) {
 		struct mlx5_ib_modify_qp_resp resp = {};
 		u32 out[MLX5_ST_SZ_DW(create_dct_out)] = {};
@@ -5076,7 +5078,7 @@ static int mlx5_ib_dct_query_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *mqp,
 	}
 
 	if (qp_attr_mask & IB_QP_PORT)
-		qp_attr->port_num = MLX5_GET(dctc, dctc, port);
+		qp_attr->port_num = mqp->port;
 	if (qp_attr_mask & IB_QP_MIN_RNR_TIMER)
 		qp_attr->min_rnr_timer = MLX5_GET(dctc, dctc, min_rnr_nak);
 	if (qp_attr_mask & IB_QP_AV) {
-- 
2.47.1

