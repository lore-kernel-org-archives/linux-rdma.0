Received: from outbound.baidu.com (mx16.baidu.com [111.202.115.101])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 0A5BD470E8C;
	Tue, 18 Aug 2026 12:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.202.115.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787055984; cv=none; b=cJOKkQCxPSqKb6GYfj5B9vUbozAI2qryj1TL5BMTdjiKza5RptEwZxzlgdiUFE/MDHO+boDvgzLAYvw23Mmjb7jaC7U4LpFeMP1Gzx60IVyWE26igzaywBYyvN3qlO8E7gnOKGwE9xdOxoKFWgqiol57kPRVv8QySl1wgn2BLaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787055984; c=relaxed/simple;
	bh=l4oilj3pklHTohEIxYJcX9YNcefRn1Wybnlq+apO7Zo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DWMAi8RRag7MRzaTeRNdo7BakDIxqAXsnogl99LFn+aSD6AGijhV4sIYz/hsl7rfPr1Gf5wpc5S7RKz7hRg5utL/pEpexqoHU7Edy0PLcpZCKEf3m5p2Cis3sD3lkswOHke+G+zolA/izmFEWK+CUb7rd4gdLStLzHw3cZ3WfJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b=eBxtgNw+; arc=none smtp.client-ip=111.202.115.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baidu.com header.i=@baidu.com header.b="eBxtgNw+"
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
Subject: [PATCH, net-next] net/mlx5: Use kfree() to match kzalloc_obj() in mlx5_events_cleanup()
Date: Tue, 18 Aug 2026 20:25:30 +0800
Message-ID: <20260818122530.1726-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc4.internal.baidu.com (172.31.3.14) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1787055942;
	bh=VqwHp8Rz8O6HJunEnlZZ2wIJnnfHdMhus09zZg0PDRk=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=eBxtgNw+oyTANZg/sVKvkjd+Xl3CW+5l7bGW/h57XhUqEKurqHKQAvx7zvEQd4oEQ
	 lGUvLWIgQcCo2XXzdpFr5BBdq4ErcbSBd/7w/70vfuPuiNg5z3buoVm2Y1KeGTZtO5
	 kG9lTbvwB9H0tk5+FZzkU5+JNq7zZBsTGWd1TY/i15VAojCiybym1E3mpwsblOe/0n
	 QVCPR9ymhvPgZlHsbmj8aqsJsv9baf6+TlV4MTFAzYqSP6gOb6pSVaYabO3/Sr+IDM
	 mGCa2f0SBPYmFFMbZ7uUu2PHCJgj5UlP998EAPSxj8C6Qc7bS/JgPSyzyZAsbgKvB8
	 hCvPnsClm26ww==

From: Li RongQing <lirongqing@baidu.com>

dev->priv.events is allocated in mlx5_events_init() with kzalloc_obj(),
which is a kmalloc-family allocator, so it must be released with kfree().

kvfree() happens to work here because it falls back to kfree() for
non-vmalloc addresses, but it is semantically imprecise. Use kfree() to
correctly pair with the allocation and to match the error path in
mlx5_events_init(), which already uses kfree(events).

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 4d7f35b..fc5ecce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -396,7 +396,7 @@ int mlx5_events_init(struct mlx5_core_dev *dev)
 void mlx5_events_cleanup(struct mlx5_core_dev *dev)
 {
 	destroy_workqueue(dev->priv.events->wq);
-	kvfree(dev->priv.events);
+	kfree(dev->priv.events);
 }
 
 void mlx5_events_start(struct mlx5_core_dev *dev)
-- 
2.9.4

