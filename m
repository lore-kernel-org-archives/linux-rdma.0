Received: from outbound.baidu.com (mx15.baidu.com [111.202.115.100])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 574963BF685;
	Sat, 13 Jun 2026 15:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781365018; cv=none; b=IYhh66E93yzSudYxEpBSfB2+PVmvjbUJIa+NayVPLp+U+GacY0mfzQ2V7PDO0UXEsqkanHZA6F/E7pms5BPfEaQW2nRmbUpGO88WoscLr455NZah5run/ct2p9gzJJBeEaJBv6hzwDD7m5A5Ql69yhNrgXlYgk9YO6vBhreo/h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781365018; c=relaxed/simple;
	bh=gm1vbwawVjM37r4oupYhif/1oaDCRwgPyzuN+/phpyM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=vAnO1A6c4EmETJZVnvMde/ZYFyQtxGmEJEEZvq1vF4ZopK2XWp1St+ugjF2aFB72yMIDp1TIy1IwZRHi8pvIPdLjmjqydBjcwl/2FC/ymhqI0PiQNJY5cfmQvTAMsC2RltWFi4Nt/uJphsQ6axWuh/Neck950LRgSAOOlsZuysk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=NVTgd/gL; arc=none smtp.client-ip=111.202.115.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="NVTgd/gL"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] net/mlx5: Fix L3 tunnel entropy refcount leak
Date: Sat, 13 Jun 2026 23:36:31 +0800
Message-ID: <20260613153631.1752-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc11.internal.baidu.com (172.31.3.21) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1781365003;
	bh=ltnOPbf4u5wXNn6TlECUDzO13cAthcx4skZw9/6ODOg=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=NVTgd/gLLBWPEpwtcreLDiv0Zea61CBcjjs6ZyX/VIXE7qwJKRHXYEWLGjE4EzF4v
	 8F0tBeXToSuqSXMhTJChL36mMD4mUHs5W8Cnf38e/9xBqQhXNZiKdAMOYLkhxbyQq7
	 XKAALJR7y7FkpVCpjFV9fuh2aPQ+B7eGmTkUY8xdtnB038TujdsTSfLdD/fK8TFmg3
	 EujGK0JPYrTuv2uvueqFJpfHOMRWxod08e32zxNWQtM3IyYqxCerxPKsBaw9NabllR
	 7mUwkQz9YQ9Ng1DAP7bRIwUWG9GjU2hvQH83ofvLKz4/3QJD3hFodYU0FVEKGUYr2J
	 Co+ld4R5OpzEg==

From: Li RongQing <lirongqing@baidu.com>

mlx5_tun_entropy_refcount_inc() counts both VXLAN and L2-to-L3
tunnel reformat entries as entropy-enabling users. The matching
decrement path only handled VXLAN, leaving L2-to-L3 tunnel entries
counted after release.

Handle MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL in
mlx5_tun_entropy_refcount_dec() as well so the enabling entry
refcount remains balanced.

Fixes: f828ca6a2fb6 ("net/mlx5e: Add support for hw encapsulation of MPLS over UDP")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
index 4571c56..97f6097 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
@@ -176,7 +176,8 @@ void mlx5_tun_entropy_refcount_dec(struct mlx5_tun_entropy *tun_entropy,
 				   int reformat_type)
 {
 	mutex_lock(&tun_entropy->lock);
-	if (reformat_type == MLX5_REFORMAT_TYPE_L2_TO_VXLAN)
+	if (reformat_type == MLX5_REFORMAT_TYPE_L2_TO_VXLAN ||
+	    reformat_type == MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL)
 		tun_entropy->num_enabling_entries--;
 	else if (reformat_type == MLX5_REFORMAT_TYPE_L2_TO_NVGRE &&
 		 --tun_entropy->num_disabling_entries == 0)
-- 
2.9.4

