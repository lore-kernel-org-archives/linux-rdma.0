Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380D23AD51F;
	Fri,  9 Oct 2026 05:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791523273; cv=none; b=qtQU+aD5gUjfXE4A6KI5moO01pJdBcBJ/h/wBoKac5WUe469TbpIRBzINpZk/CZmXe68eNXUnlXB0X0aNcap0/Obzf/pCIcjNjwHtTWjUXSKtdAlsVQp1TYR7UK7YRBjXgJAODSF/s564+LpkcSNuHW3zfnRqKqpEk0i9kRSp2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791523273; c=relaxed/simple;
	bh=pz58TFCAuIP4QPmrmWFDpK7dvqWPWYc79PUdV+d+uO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXluHjjHyfm7iEHkd/4REZQeJFgv+2K0Cjc0vqS8QmDABisYx0ScsKQAONPPaeU9vc/ocsMlYsLMwfRvDMhtT0f+uHCx2PsyuMuIL8XuTlee6N7wXTfOFwAE70p1KIkAmIL/YQ9zTipyq6lh9ghBrmKBpQd3tRUuhgL9UJNvTv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=HmLPEklj; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="HmLPEklj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791523269; bh=pz58TFCAuIP4QPmrmWFDpK7dvqWPWYc79PUdV+d+uO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmLPEkljrhbGiRMgb/YeD2vM+lah8JpzIttW59yU4/eGdM4gXBv+UhT6UEEyAS61L
	 4CLcrHFQJxFrDaBn09ueTAYFCeU4ZJpiXLEv6tENy9CC9Bw1Ouutjwy4jkgkXTkb7N
	 vvDjzdXXnwn64HmjDnK60dyDihXlKUi8gjE2LpgGiuGnuWXgDwAIxthLvulhAqFmCW
	 vmeTgPfMjnaqQi2PZKAVbpOGOZtlqmRjHmgwYAl83rocer0iD7HJAakM4tAB6K4Ozp
	 SX2fxiCCl8SUyRhOe7xpK4y/iHW/K8WNhqOqAvrKezablUcvbfnDgba4dFPhrYbuMs
	 CHdcwYICARRhg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 6A56744C0B51;
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
Subject: [PATCH net-next 1/2] net/mlx5e: TC, free NIC flow parse attributes after offload
Date: Fri,  9 Oct 2026 07:21:00 +0200
Message-ID: <20261009052103.3621855-2-acassen@corp.free.fr>
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

A NIC flow holds a 4 KB allocation for its parse attributes until
deletion although nothing reads them after offload. Free them once the
rule is in.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c    | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c99e824b4c6d..708b7987ea4c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1414,6 +1414,16 @@ void mlx5e_del_offloaded_nic_rule(struct mlx5e_priv *priv,
 				      MLX5E_TC_FT_LEVEL);
 }
 
+static void mlx5e_tc_free_parse_attr(struct mlx5_flow_attr *attr)
+{
+	if (!attr->parse_attr)
+		return;
+
+	mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
+	kvfree(attr->parse_attr);
+	attr->parse_attr = NULL;
+}
+
 static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 				  struct mlx5e_tc_flow *flow)
 {
@@ -1436,10 +1446,8 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	}
 	mutex_unlock(&tc->t_lock);
 
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR) {
-		mlx5e_mod_hdr_dealloc(&attr->parse_attr->mod_hdr_acts);
+	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		mlx5e_tc_detach_mod_hdr(priv, flow, attr);
-	}
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
 		mlx5_fc_destroy(priv->mdev, attr->counter);
@@ -1450,7 +1458,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	free_flow_post_acts(flow);
 	mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), attr);
 
-	kvfree(attr->parse_attr);
+	mlx5e_tc_free_parse_attr(attr);
 	kfree(flow->attr);
 }
 
@@ -4759,6 +4767,7 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	if (err)
 		goto err_free;
 
+	mlx5e_tc_free_parse_attr(flow->attr);
 	flow_flag_set(flow, OFFLOADED);
 	*__flow = flow;
 
@@ -4766,7 +4775,6 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 
 err_free:
 	flow_flag_set(flow, FAILED);
-	mlx5e_mod_hdr_dealloc(&parse_attr->mod_hdr_acts);
 	mlx5e_flow_put(priv, flow);
 out:
 	return err;
-- 
2.43.0

