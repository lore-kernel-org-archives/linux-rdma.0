Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AA03B42EB;
	Sat, 10 Oct 2026 12:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791633724; cv=none; b=U5PPRkdjirgBh26d1zXtbyGfE/P+YW1GdNMXW7sLkDblG2fLzNpo22ribbWKjJOgoImhGStYxlcqzCsThkObF61U6BmlnuG4vLCpvjcsmY29/I0vwMaGfheFYbeNnBeHSJc4YlcVoDCuZZnyFApBc8cmWbKR01K1PDMFBCsVZZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791633724; c=relaxed/simple;
	bh=JXhX9U6Nm99665ug78spc2jmbce//9kXJxeJdFrBFN0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bMuRxKY3Dw6vfocRFySTvMk70ebxQCNLq7HxD+Cm+0qNgJP7qZ8FNxXRQlH1LD20UdVQfRtTGsRQ/Uu2W4fFUZLKBDtZOGFg4qlypTFiaFQFaeJb4tPWQF+H3ejyNX34KCAdepIM7cp5Pe2/0hvLmGccp6kjyJrlkfUrYa9h40k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=WczcF16s; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="WczcF16s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791633719; bh=JXhX9U6Nm99665ug78spc2jmbce//9kXJxeJdFrBFN0=;
	h=From:To:Cc:Subject:Date:From;
	b=WczcF16sIJ65MivGocRLPrCBq5oLtmMr2oltlKMw1HWPIi1JL1UY5JDYSZW0/M/+h
	 +aLNSwSxlmCc+WyQMrI1rIRVqAaewsuHy9TV9miqaqjWJTInUNdJtg/7uiOsVVahEJ
	 HgErus+m+mTgxAg1pLckg/He9GKJuDDeSTblrNkaGa8Q8ZVjL0zXhNvROF9QPVJkFI
	 E1aHABC0GZzFC+5B2bspbvCXtk0om75PRsNjEcn9sOjLNRSMIT8lDHnqxZq6L66dq2
	 fB1GnqnfM9AcoLV61zaaues3c5F/9b3jphmvmIryUVWSIzzqseanR13IVjHQHfOGhr
	 VDTV5TlbJXfgg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id E8F2844C0E76;
	Sat, 10 Oct 2026 14:01:58 +0200 (CEST)
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
Subject: [PATCH net] net/mlx5: HWS, fix modify header pool match for copy actions
Date: Sat, 10 Oct 2026 14:01:46 +0200
Message-ID: <20261010120147.135825-1-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mlx5_fs_hws_mh_pool_match() compares only the first half of each action
since rules pass their values as arguments. Copy and add_field actions
keep their destination in the second half and HWS reads them from the
pattern alone. Two modify headers whose copies differ only in
destination then share a pool and the second rule writes to the wrong
field.

Use the HWS core comparison that checks these actions in full.

Found while checking a Sashiko AI review report and confirmed against
the HWS pattern code. Not reproduced. No in-kernel user puts such
actions on the FDB but RDMA flow actions can.

Fixes: b36315ca69cb ("net/mlx5: fs, add HWS modify header API function")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
Sashiko AI review: https://sashiko.dev/#/patchset/20261008204230.3222198-1-acassen@corp.free.fr?part=2

 .../mlx5/core/steering/hws/fs_hws_pools.c         | 10 +++-------
 .../mellanox/mlx5/core/steering/hws/mlx5hws.h     | 15 +++++++++++++++
 .../mellanox/mlx5/core/steering/hws/pat_arg.c     |  8 ++++----
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
index 86828e329187..cd888756e942 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws_pools.c
@@ -389,7 +389,7 @@ bool mlx5_fs_hws_mh_pool_match(struct mlx5_fs_pool *mh_pool,
 			       struct mlx5hws_action_mh_pattern *pattern)
 {
 	struct mlx5hws_action_mh_pattern *pool_pattern;
-	int num_actions, i;
+	int num_actions;
 
 	pool_pattern = mh_pool->pool_ctx;
 	if (WARN_ON_ONCE(!pool_pattern))
@@ -398,12 +398,8 @@ bool mlx5_fs_hws_mh_pool_match(struct mlx5_fs_pool *mh_pool,
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
index 1ad7a50d938b..13e9cdbc5d47 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws.h
@@ -688,6 +688,21 @@ mlx5hws_action_create_modify_header(struct mlx5hws_context *ctx,
 				    u32 log_bulk_size,
 				    u32 flags);
 
+/**
+ * mlx5hws_pat_compare_pattern - Compare two modify header patterns.
+ *
+ * @cur_num_of_actions: Number of actions in "cur_actions" array.
+ * @cur_actions: First pattern actions.
+ * @num_of_actions: Number of actions in "actions" array.
+ * @actions: Second pattern actions.
+ *
+ * Return: true if the patterns differ only in values, false otherwise.
+ */
+bool mlx5hws_pat_compare_pattern(int cur_num_of_actions,
+				 __be64 cur_actions[],
+				 int num_of_actions,
+				 __be64 actions[]);
+
 /**
  * mlx5hws_action_create_aso_meter - Create direct rule ASO flow meter action.
  *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/pat_arg.c
index 9af449c2b4d5..0120d511c694 100644
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
 
-- 
2.43.0

