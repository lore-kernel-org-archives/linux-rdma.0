Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7C34F649A;
	Mon, 19 Oct 2026 13:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792416730; cv=none; b=YRdE3E9py41A1za7MgFLUpwE5k2gqPvDidosLEOkXbIPk0bY7msTWJNiy5CRJYPlFScZqO6yMAis59edqoc6qcEJWgHaiQBoBf4fvR2PNZtt+jv8wnnm8U4n+ZrND8vn2OhjvNs4ljRZNkF1dUTOqYCFg2OzLMPcuz+lUXkRG38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792416730; c=relaxed/simple;
	bh=Yf7uZcw5trvHqRaW+zxSNUDQmN28+JZFHzYBnfUC5eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndvboEHAahd01RBjp0Bn55K5yfLzSnUVPmF04FJnekiM0OQHk7xjL+0Kmu3OcLUF5H2DxWhJWyVkCf6zG2yadyRax0ggGwfEXyXEcpxKDcJ1C33sS9bKvF2MabnwuDziJg29ibC0jQE3Olers401gqRLxlF+/P+Xc7PQhrUb0wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=De7OA3Go; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="De7OA3Go"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1792416726; bh=Yf7uZcw5trvHqRaW+zxSNUDQmN28+JZFHzYBnfUC5eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=De7OA3GocYo1ipdq6IwgFdb5RBR+SATOYOCmdDq6uHowVsIO0gKaAx9iSFA0FPI+R
	 Nll6i0zyjGy3oRulGq/H1U/6kLLzrdQn/MacauklqUlWJr0rDPBPi9ZocoGzl0SkgS
	 cyODbc8k6RIKFEW2fl64tqlK6d0A228qMe6/Ad7B1kkfCJxWMErEtYRIk7fZPfhwEK
	 /N7TRyDPSD4lcFcrMYghRUAn47xhFm/NRFSeV4Py/gUPR4U2RwPIwAVQoJWbVsj9T3
	 j2TRuJxmnFkyfajkdHrsBW0iO0NEXjMJMmDo+5M+33/Hj5a5lslwrrj9uVKGafiBfQ
	 vMYrz6hF2Lg/w==
Received: from localhost.localdomain (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id F27F844C0F33;
	Mon, 19 Oct 2026 15:32:05 +0200 (CEST)
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
	Simon Horman <horms@kernel.org>,
	Moshe Shemesh <moshe@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Hamdan Agbariya <hamdani@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net v3 2/2] net/mlx5: HWS, fix modify header pool match for copy actions
Date: Mon, 19 Oct 2026 15:31:57 +0200
Message-ID: <20261019133159.1742411-3-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261019133159.1742411-1-acassen@corp.free.fr>
References: <20261019133159.1742411-1-acassen@corp.free.fr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mlx5_fs_hws_mh_pool_match() compares a single dword of each action
since rules pass their values as arguments. Copy and add_field actions
keep their destination in the second dword and HWS reads them from the
pattern alone. Two modify headers whose copies differ only in
destination then share a pool and the second rule writes to the wrong
field.

Use the HWS core comparison that checks these actions in full.

Found while checking a Sashiko AI review report and confirmed against
the HWS pattern code. Not reproduced. No in-kernel user puts such
actions on the FDB but RDMA flow actions can. Tested for regressions on
ConnectX-7 with firmware 28.48.1000 on a little-endian host.

Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../mellanox/mlx5/core/steering/hws/fs_hws_pools.c    | 11 ++++-------
 .../mellanox/mlx5/core/steering/hws/pat_arg.c         |  8 ++++----
 .../mellanox/mlx5/core/steering/hws/pat_arg.h         |  5 +++++
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
index 86828e329187..05aa143fa088 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
@@ -3,6 +3,7 @@
 
 #include <mlx5_core.h>
 #include "fs_hws_pools.h"
+#include "internal.h"
 
 #define MLX5_FS_HWS_DEFAULT_BULK_LEN 65536
 #define MLX5_FS_HWS_POOL_MAX_THRESHOLD BIT(18)
@@ -389,7 +390,7 @@ bool mlx5_fs_hws_mh_pool_match(struct mlx5_fs_pool *mh_pool,
 			       struct mlx5hws_action_mh_pattern *pattern)
 {
 	struct mlx5hws_action_mh_pattern *pool_pattern;
-	int num_actions, i;
+	int num_actions;
 
 	pool_pattern = mh_pool->pool_ctx;
 	if (WARN_ON_ONCE(!pool_pattern))
@@ -398,12 +399,8 @@ bool mlx5_fs_hws_mh_pool_match(struct mlx5_fs_pool *mh_pool,
 	if (pattern->sz != pool_pattern->sz)
 		return false;
 	num_actions = pattern->sz / MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto);
-	for (i = 0; i < num_actions; i++) {
-		if ((__force __be32)pattern->data[i] !=
-		    (__force __be32)pool_pattern->data[i])
-			return false;
-	}
-	return true;
+	return mlx5hws_pat_compare_pattern(num_actions, pool_pattern->data,
+					   num_actions, pattern->data);
 }
 
 struct mlx5hws_action *mlx5_fc_get_hws_action(struct mlx5hws_context *ctx,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
index 512299b59fd0..a49115f04025 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
@@ -96,10 +96,10 @@ void mlx5hws_pat_uninit_pattern_cache(struct mlx5hws_pattern_cache *cache)
 	kfree(cache);
 }
 
-static bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
-					__be64 cur_actions[],
-					int num_of_actions,
-					__be64 actions[])
+bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
+				 __be64 cur_actions[],
+				 int num_of_actions,
+				 __be64 actions[])
 {
 	int i;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.h
index 7fbd8dc7aa18..2be7787104e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.h
@@ -49,6 +49,11 @@ int mlx5hws_pat_init_pattern_cache(struct mlx5hws_pattern_cache **cache);
 
 void mlx5hws_pat_uninit_pattern_cache(struct mlx5hws_pattern_cache *cache);
 
+bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
+				 __be64 cur_actions[],
+				 int num_of_actions,
+				 __be64 actions[]);
+
 bool mlx5hws_pat_verify_actions(struct mlx5hws_context *ctx, __be64 pattern[], size_t sz);
 
 int mlx5hws_arg_create(struct mlx5hws_context *ctx,
-- 
2.43.0

