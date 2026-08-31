Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0C75867D5;
	Mon, 31 Aug 2026 13:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184220; cv=none; b=TktPgR8KGu0O8tcPA1xhCCXUMKL1J4j/6PFBbFndsLEY4nAZ5T7QLWUFGQte/C5VVlIwe2vCueBvDoMVnwbw+tGO9XwfMrIV9ySw122mUr8yjUasbscHGginkhSCDXjM1rFEhj6YC/6QniaSDdf3qOlU4YCLaLdJWm4plMRwSDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184220; c=relaxed/simple;
	bh=dlqJS75pc9r36XeZzV0aXAaWO5RTF9CkX6hS/orui5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShVXt3awVvqqDfEy9yJTOdRPJ4UPVLMhZJluP41U8HsjOYLCFYuG9mXOvIQ/BEMRulmboxeUTXnNjEFKG71RBNadBQbTaLVep9o5tBBoNjO69Lq1e7NO46LNUXoqBncEn3dtBL5oNkstpAPQJNApCtgd/wvP6B/mz1Wtv31n9Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3FLl2/p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3FLl2/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062531F00A3D;
	Mon, 31 Aug 2026 13:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184218;
	bh=BTyedSN3YbOUiJKzZA2msjsF7CSOouyfNx25cmftEjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o3FLl2/pB4NrE/yXtf21vsYZPeB0ZpZj66oENL6q1WHtfZjOVnyUiWOIbfGSkZo4D
	 XMZ2EOxzJcjAC8Av7tePSWGnG5Rrvlqyb7pqNcB7qP+jT59fHykm624UFJy4VMs189
	 xNEJbERcgo76jkUaBJLor4octlfideC0/4txB8B4aelDaz/iiDGjgVuy7xDI/aSCWn
	 bIr/0sDez2FUm8ouroaAYFO5Z1RmIpUGyPefGChRZ1OhbiSDAyGXdvflSPjYpnCzWb
	 6+tevY2W2G5fOMHStQpAKT0mxfZdGkWJ9nVbYfhwyQUcLMGTKXpSkbBVFID15gUWqe
	 56QZjCickNzEA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	saeedm@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net/mlx5: Switch vport HCA cap helpers to kvzalloc
Date: Mon, 31 Aug 2026 09:29:50 -0400
Message-ID: <20260831133314.4125787-562-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 62af408fd772ba0194c007170f9e930ea71e01ea ]

mlx5_vport_set_other_func_cap() and mlx5_vport_get_vhca_id() allocate
command buffers that embed the HCA capability union, exceeding 4KiB.
Use kvzalloc/kvfree so the allocation can fall back to vmalloc when
contiguous memory is scarce.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260518071356.345723-5-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
The background author-history search finished. It found one relevant
prior commit from Tariq Toukan: `ca11b798998a6` (`net/mlx5e: Convert
large order kzalloc allocations to kvzalloc`). No Moshe Shemesh commits
touching `vport.c` showed up in that query.

That fits the earlier analysis: mlx5 maintainers have already moved
large command-buffer allocations to `kvzalloc` in this tree, and this
patch closes a remaining gap in the vport helpers. The backport
recommendation remains **YES** for linux-6.18.y.

 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index a44214c660b03..fd10018b25807 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1279,7 +1279,7 @@ int mlx5_vport_get_vhca_id(struct mlx5_core_dev *dev, u16 vport, u16 *vhca_id)
 	if (mlx5_esw_vport_vhca_id(dev->priv.eswitch, vport, vhca_id))
 		return 0;
 
-	query_ctx = kzalloc(query_out_sz, GFP_KERNEL);
+	query_ctx = kvzalloc(query_out_sz, GFP_KERNEL);
 	if (!query_ctx)
 		return -ENOMEM;
 
@@ -1291,7 +1291,7 @@ int mlx5_vport_get_vhca_id(struct mlx5_core_dev *dev, u16 vport, u16 *vhca_id)
 	*vhca_id = MLX5_GET(cmd_hca_cap, hca_caps, vhca_id);
 
 out_free:
-	kfree(query_ctx);
+	kvfree(query_ctx);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_vport_get_vhca_id);
@@ -1306,7 +1306,7 @@ int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap
 	void *set_ctx;
 	int ret;
 
-	set_ctx = kzalloc(set_sz, GFP_KERNEL);
+	set_ctx = kvzalloc(set_sz, GFP_KERNEL);
 	if (!set_ctx)
 		return -ENOMEM;
 
@@ -1335,6 +1335,6 @@ int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap
 	MLX5_SET(set_hca_cap_in, set_ctx, function_id, function_id);
 	ret = mlx5_cmd_exec_in(dev, set_hca_cap, set_ctx);
 
-	kfree(set_ctx);
+	kvfree(set_ctx);
 	return ret;
 }
-- 
2.53.0

