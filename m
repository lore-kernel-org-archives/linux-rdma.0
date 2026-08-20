Received: from outbound.baidu.com (mx24.baidu.com [111.206.215.185])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 08CCB377EA2;
	Thu, 20 Aug 2026 03:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787195323; cv=none; b=q/Q4FFJFHGN5Kt4MGYdNUEXVVrl7Tk2itpHWSo2vTTsw8wWXAZbESZsU1l0Y80m0JkHdsB7DwivFrbvOfm2Azmn3VvT3DQ1SbarEVngxFQ7OAYDBa+rFtg6W+xGz4pugvRy0GWXydPBb/Abl9mlMDjWgsiJaA/3uie4Sk73bs84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787195323; c=relaxed/simple;
	bh=qinbcPkjWI/i4M1//mn/c7Wgz6Yusqo9KIJ1BWhpke8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=b5TLD6mpSLR6keWomtOC9AMI4J5VxDrMwq75DXz4bw+vT4yitA9byGPaMmA9bBk2Tli0ps/3l4lEe1VLhxYoy8mSBvWmbDckBfk7DmyeCC6X57ClZ/v6VVzwft0caXp0TUjfWnfnYV4WPlNvpMnh2PowM8hioKh5PsSSmHhZsxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=jl0JyiJ6; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="jl0JyiJ6"
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH net] net/mlx5e: Order ICOSQ cc update after CQ doorbell
Date: Thu, 20 Aug 2026 11:08:21 +0800
Message-ID: <20260820030821.1731-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjkjy-exc11.internal.baidu.com (172.31.51.11) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1787195313;
	bh=frjw2iB/d4Pj6EgsUUqnI4Rf1ZcwzdNBqHEkWxU6Cr4=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=jl0JyiJ6AUwfdRYV0x8NNIWEtBveV0lGC31v/h1267YgTLuPRotxhP3wy3dxhRoQL
	 ajPAk5T9W49vJ9qD44g2HBj4pYk0FB+E4A1wd/xi6I0z45ASDjKnF8Q2bN3O2Ou80L
	 SlJEIwyQzr7uqh5ev+WasLDGvpU3dzI2BVNa5ETIQw6RtDwoNrlqSyOahbkVdCle1j
	 +KXHRku/RvBI9EDK5Ef2EWU9r/vasWlbhrApbPkgAi82iUcaZDf3IGExz5XXMcXVV6
	 y4bIj2NWbDPzppjL9mK6QH1z1YCK5DEQC3DnxKMKxwVF9yvlU+RldIAzxtiYGBgsKI
	 AcZvakUxAOjZg==

From: Li RongQing <lirongqing@baidu.com>

mlx5e_poll_ico_cq() requires sq->cc to be updated only after
mlx5_cqwq_update_db_record(), otherwise a CQ overrun may occur.

The current implementation updates sq->cc before the CQ doorbell
record, violating this ordering requirement.

Update the CQ doorbell record first and use dma_wmb() before updating
sq->cc. This ensures that the CQ space is released to the device
before the corresponding ICOSQ consumer index is updated by software.

Fixes: fd9b4be8002c ("net/mlx5e: RX, Support multiple outstanding UMR posts")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index f6eff03..01867dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -905,10 +905,12 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 		} while (!last_wqe);
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
-	sq->cc = sqcc;
-
 	mlx5_cqwq_update_db_record(&cq->wq);
 
+	/* ensure cq space is freed before enabling more cqes */
+	dma_wmb();
+
+	sq->cc = sqcc;
 	return i;
 }
 
-- 
2.9.4

