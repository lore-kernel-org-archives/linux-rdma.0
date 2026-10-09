Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7903D75BE;
	Fri,  9 Oct 2026 05:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791523272; cv=none; b=Qq7/2BrO27A+gO5e2qP1Hgd9HjEd6+CXPfTwebGx8MTjgxAaghm+JO2Yi+1C8xWP7XvQzDJ1jrSX3z327C31cfFCOY6+SJOBt64wXD8gsNi4Inr67CL6qgZBmf4Pb2XBk2cwFfVYRVV81rjhqGJcXwY676cESx4QQBtAV/jiVI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791523272; c=relaxed/simple;
	bh=XnUZKFGT5rrK5PWIHtUkC7qmOwFEvtUg2Dm6fwu6e+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUu8ARuBBwkW/moWWcXIuSNUbtgp2BojagrX8C7seUKWqtEf9fop4qWh3L1CVFnlWUjio2UP1H9oVvAW7I9VqSX2eqJMTyVXeex5AA87yv7aEtG/OzGZYRUVkfTLp3cpQrFoLdKgKCOtM9Eu8hzyGxytgoSpMH+1iOZ1dP4AK3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=hiq1cqdx; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="hiq1cqdx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791523269; bh=XnUZKFGT5rrK5PWIHtUkC7qmOwFEvtUg2Dm6fwu6e+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiq1cqdxadOXVKKYvgXcWzLrLCXZvyJLpBvMH/buZtO4D0gM+IDmQnu2IDFumWr4x
	 wMk951Vu3zs5lxPYw98qJZ+CwqpgScT7ODY2o7oZWQwpF30BzcloQAumjxHu3As53B
	 eDWs3n++J6Jzwmj86dpCnRMHayZutGTTkDj7wwZb2FH+X+8m3k9xyEiF5wM9Sofq9I
	 5RwDnLTxFmqW5Q4xogQnLfVmA7UP9DOuQoJNprY0DDr7VMu77N656noM38U0ZqeKYu
	 sGHwWbsWgA0esOP76GwISJ5LybNAKG3E/AoVn6cOeZn0xTer76bniNJUZ84WtNjUfh
	 MYWFTY/nJzUqg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id AFA0544C0B80;
	Fri,  9 Oct 2026 07:21:09 +0200 (CEST)
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
Subject: [PATCH net-next 2/2] net/mlx5: HWS, shrink FTE action array to fit
Date: Fri,  9 Oct 2026 07:21:01 +0200
Message-ID: <20261009052103.3621855-3-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009052103.3621855-1-acassen@corp.free.fr>
References: <20261009052103.3621855-1-acassen@corp.free.fr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An FTE keeps the actions it must release in the array used to build
them. This is a 1 KB allocation sized for MLX5_FLOW_CONTEXT_ACTION_MAX
entries while a rule rarely needs more than three. Keep a copy sized to
the actions in use.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c  | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 5a172c572a68..da6e57c103d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -746,6 +746,7 @@ static int mlx5_fs_fte_get_hws_actions(struct mlx5_flow_root_namespace *ns,
 	struct mlx5_fs_hws_context *fs_ctx = &ns->fs_hws_context;
 	struct mlx5hws_action_dest_attr *dest_actions;
 	struct mlx5hws_context *ctx = fs_ctx->hws_ctx;
+	struct mlx5_fs_hws_rule_action *rule_actions;
 	struct mlx5_fs_hws_rule_action *fs_actions;
 	struct mlx5_core_dev *dev = ns->dev;
 	struct mlx5hws_action *dest_action;
@@ -1041,13 +1042,20 @@ static int mlx5_fs_fte_get_hws_actions(struct mlx5_flow_root_namespace *ns,
 	fs_actions[num_fs_actions++].action = tmp_action;
 	(*ractions)[num_actions++].action = tmp_action;
 
+	rule_actions = kmemdup_array(fs_actions, num_fs_actions,
+				     sizeof(*fs_actions), GFP_KERNEL);
+	if (!rule_actions) {
+		err = -ENOMEM;
+		goto free_actions;
+	}
+	kfree(fs_actions);
 	kfree(dest_actions);
 
 	/* Actions created specifically for this rule will be destroyed
 	 * once rule is deleted.
 	 */
 	fte->fs_hws_rule.num_fs_actions = num_fs_actions;
-	fte->fs_hws_rule.hws_fs_actions = fs_actions;
+	fte->fs_hws_rule.hws_fs_actions = rule_actions;
 
 	return 0;
 
-- 
2.43.0

