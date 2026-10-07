Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E84F4ACC72;
	Wed,  7 Oct 2026 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791383933; cv=none; b=NHZLkicua5QxAkx+FXaItj1SXHvH89Go/En+TTHaUlr1mhULlNHYYXLrLkmogJUtxRr+BJvVhpgPHUqeYUBWFSNwUiAF95jrTJIiCtqNErTIXmwFiEwOVh186aaW4oro5VIb9H7zK7CVpF1thxlzgHBvdKDMpfkY88htQYbJKms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791383933; c=relaxed/simple;
	bh=WOO3OT/UjjR6FkEWqCSZYJZ7+5qVJqaycE609tUHtgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MId9lTNfqMo6m0LMBrGxqc9AuLhxV8Et/xTHMZn8D+eT+A+UYt2b5zaYslZ+xDTtTfMzCh9Qd7e6cVZpakb/2TdRpTg9DOaMWcmEt1ww0T4QJyL4gTCTFkMfEsQ4Tp1ZC+QaxJ6D1hVUhWc/biQD/iiXzzHXs0zxtPl/3OGt2GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=F9WrEnX+; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="F9WrEnX+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791383918; bh=WOO3OT/UjjR6FkEWqCSZYJZ7+5qVJqaycE609tUHtgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9WrEnX+DZsUqzHxxnteVpF6/RmUUcGTj5OvMwWpAs/XzRMEiQqz8xFX2NBmLF8Sn
	 CVWO+RCYEMlA9WYOtgTuTl2UVQO9+0RpoFfmhwmSf8bsXnKS5PN2bV9v2N0BqKtEWC
	 ah3K/OfQVVfQNWiB5ntmaXcj1cfVy5VF3YoMdmtj3AnqLLTM4Ud97DJA2XvB08hNoR
	 z7DtW+DgHOQl4i852yBgYqCPgoT+4kr+kn77BAcPvnRXYcY0TJnMc3XG/x2hCZ+OWN
	 teOryrZyrYBdBJ8dJJKvu1Pj/0zTnBKdff/Ms+3cMbkOMg/1PpwMfuOAZO+/QbRa3k
	 kbejUbOpN0wdg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 6329244C1115;
	Wed,  7 Oct 2026 16:38:38 +0200 (CEST)
From: Alexandre Cassen <acassen@corp.free.fr>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net 1/2] net/mlx5: HWS, release L2 to L3 tunnel reformats to their own pool
Date: Wed,  7 Oct 2026 16:38:22 +0200
Message-ID: <20261007143830.1733583-2-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007143830.1733583-1-acassen@corp.free.fr>
References: <20261007143830.1733583-1-acassen@corp.free.fr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

L2 to L3 tunnel reformats are now released to the el2tol3tnl pools.

Fixes: aecd9d1020e3 ("net/mlx5: fs, add HWS packet reformat API function")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 5a172c572a68..44b311b4532d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -1398,8 +1398,8 @@ static void mlx5_cmd_hws_packet_reformat_dealloc(struct mlx5_flow_root_namespace
 						    pr_data->data_size);
 		break;
 	case MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL:
-		pr_pool = mlx5_fs_get_pr_encap_pool(dev, &hws_pool->el2tol2tnl_pools,
-						    MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L2,
+		pr_pool = mlx5_fs_get_pr_encap_pool(dev, &hws_pool->el2tol3tnl_pools,
+						    MLX5HWS_ACTION_TYP_REFORMAT_L2_TO_TNL_L3,
 						    pr_data->data_size);
 		break;
 	case MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2:
-- 
2.43.0

