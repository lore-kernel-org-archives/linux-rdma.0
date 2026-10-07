Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7615E3F9F50;
	Wed,  7 Oct 2026 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791383928; cv=none; b=VMSJx95Wgvi1H1wwESAWcql+z/hPNDqsufwVdeqAGd3OzfUkY6plMR/AE7YngP6/QvLYwvnA1HiZyEuYE742UalxJY2zw7+UDA3T8Nvh061XkncmxiILO02fKeNGQqLUkUY6w4r4ho/qcX7V3v/WE5uGqOgmflur/6EeO1Jsa9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791383928; c=relaxed/simple;
	bh=q5ZraEb90zjJzA8ZhRK7+hTfcqX2QdXYoM/jBIwazR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyIqvBit+A4OgBlj9OTJVLz0idvUoelF5qOyjOkqQddHXkWIeQCamL3fFXPBrcGaJgseuMgPSPKijU92kyOO+AVyQgHckSvisu8ZxHESrgaKuOFGEVxyvB9JcvVoaYrMM/yhjApJ1tAKcRKVPvzONrRR2zrnQpZio0qh7z/kvrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=T5YUeQCK; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="T5YUeQCK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791383918; bh=q5ZraEb90zjJzA8ZhRK7+hTfcqX2QdXYoM/jBIwazR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5YUeQCKo4FqstM3mYAAWdb4h+CuyJhpVtwXRfFiHVvYwJxvB9LBkDb63w9ukU3Ll
	 NX2jr7UTps8pR2kCBXBxGqZTBW2RTcC69EknezbF7yK3PK1jt9VXZjKWfFuN39dGN4
	 FwD7wMsUBxDj6O0LKQZxMy2vsyPe5XTqGGiSiRJ/1Uxuy/ooBCekc9bGPeQcRvyi1r
	 hUHAjq8ArK1mfFgMSFn7GputNAZXQjB915qBXXZ2KyFiGOvu1vYSTBgj0lhI5XOXst
	 SwnPniuE1VaTwCqFBjTo5rQ8drvnMsMLgLUd/JSePtRyHYZisKZlKeZDIQiiHK866B
	 OQdkUcoVqbIHg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id A687C44C1117;
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
Subject: [PATCH net 2/2] net/mlx5: HWS, fix flow meter offset within its bulk
Date: Wed,  7 Oct 2026 16:38:23 +0200
Message-ID: <20261007143830.1733583-3-acassen@corp.free.fr>
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

The flow meter action is bound to the first ASO object of the bulk but
the rule offset only indexes the meter within its own object. A rule
past the first object runs on the wrong meter.

Fixes: 82d3639ef7dc ("net/mlx5: fs, add support for flow meters HWS action")
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
index 44b311b4532d..54761754e657 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
@@ -928,6 +928,7 @@ static int mlx5_fs_fte_get_hws_actions(struct mlx5_flow_root_namespace *ns,
 			goto free_actions;
 		}
 		(*ractions)[num_actions].aso_meter.offset =
+			(fte_action->exe_aso.object_id - fte_action->exe_aso.base_id) * 2 +
 			fte_action->exe_aso.flow_meter.meter_idx;
 		(*ractions)[num_actions].aso_meter.init_color =
 			fte_action->exe_aso.flow_meter.init_color;
-- 
2.43.0

