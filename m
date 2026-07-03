Received: from outbound.baidu.com (mx15.baidu.com [111.202.115.100])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 75E7D3DA7E4;
	Fri,  3 Jul 2026 14:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783088106; cv=none; b=oF6DyvquZpS1lNCQkB7WsZMk/ljUt9TvZAgdGdgILp0mqsh5TVTd1d7x2R/jfwFL5Ni+gPGvbmeoLNhYxa3cyC41prT3CtJZn1Uf2T5JCqpJ/QvpbVxPiYbLhab6A+d7E5/ilNr2oGvzxylV2bDrkmRWZqX23uRyzXtOFgq6MqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783088106; c=relaxed/simple;
	bh=twwAxQPdUmab4X/guhrl6yiP2j3wT1GqyqKE26e3swc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XURfhHr5KjJHrxhosqyU8fE5eI6U+kO1e4bliaglcBKe1myd1KBZUsmV8gAvALzVt15CahTOXOL9ugDpcYO4P8JY/duCfJYB5TsRCodOtMD/C4QLXReO/Ry6pLZd4XjU2+HGdmS3/U/Yx8pB7dQlO9S6kaMmkHrbhqb28KFbjLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=mZdPJwmG; arc=none smtp.client-ip=111.202.115.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="mZdPJwmG"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Li RongQing <lirongqing@baidu.com>, Simon Horman
	<horms@kernel.org>, Eli Britstein <elibr@mellanox.com>, Roi Dayan
	<roid@mellanox.com>, Eli Cohen <eli@mellanox.com>, <netdev@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH] net/mlx5: Fix L3 tunnel entropy refcount leak
Date: Fri, 3 Jul 2026 22:14:23 +0800
Message-ID: <20260703141423.1723-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc5.internal.baidu.com (172.31.50.49) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1783088088;
	bh=vbfPrz0d7bTAVwsqhRMTbt+9bVqsG0XKEvVVATU9zyQ=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=mZdPJwmGfGlCms0y1sYpKDG6xoyJ1MKSHaxOK+43ff19GUnuErIgM2fgYxWNSg2gs
	 6pH9xF5Oir+Ua0M9DnKluew3bEVYrhFZfS0z+Imv8VTFIf2FQpl55hEkIw0uzwuL3X
	 ws+EamDrtztPTtiD0oD85VFYph9CKfO2VoYomZzbbo8sOTb9QdP4e8NPFP7eBgEvmY
	 OtB1rBxXi/Qjzbbbhl0mghpvnpCexNHrUE2pl2xviGEoB0Kodl5+ncgVuoQBbnVATW
	 moWP4zc+BzNZqiPtXSw6S06uNwGoXhQq2ZUmUV7vYYVzGRKvS5LzQxkExYtDAdcCwV
	 hI3dS+njE6JlQ==

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
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
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

