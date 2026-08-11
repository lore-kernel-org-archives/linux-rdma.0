Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010034.outbound.protection.outlook.com [52.101.201.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBDD3815D0;
	Tue, 11 Aug 2026 06:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786429790; cv=fail; b=dZ8DRtMUM7KF7xVHaZmq5N43z3KdraEMWdcoht20MOILnwkT/1iM1/fsdJjVHWUTYrSK6LBck5ikvIlOXDu5kJfjBLfuOI2UF3CwuXV+Q1q57QeCVc4Z9lTLEMlm0WCPVmtkv3/WNZrcUHPB+9DEVOn4N6BeNmiD8I+AiBvKkXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786429790; c=relaxed/simple;
	bh=dlQZeGH1eA1vEIlA3MtufBHkazu+eGBC8V8VOwZbcVw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=muMCL/WHIGtKjqLAqiD+E/ILlfk4Z2VtoLg0rhBIZc8mhcNd98JQUwWhRQe8UA9Pd/cPstKooLdQV5Y3xygie3R5puP4Kb3stijCK3/dyuM0cCJp3GJlyrPEqo77kvqMr/7FhKFXI5RbxUQdFSOLKqA3W4jWmZ3JEBAZvJehylM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MKEKRnnL; arc=fail smtp.client-ip=52.101.201.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MKEKRnnL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XvKT2JvuuxDj/39FDbYlwxVhsNohYqH5HTN5PImd5tlkuR4t7BSkInTxs08jZaCHfA8YyHU/ydIqOR+opOvhvqpWwFxuP1CCaSNLmxDrUJUfl5aVZvtdUBHpnQPdSAIc+wdbg+4x1dCYkdpq7wocGcpRYyL8j62qRHMZmTmdDAb1nFP5bELpW31nHsVtSLwLlVie6mrziUGvAVXi/G1Q3l75T975TXMip5zT4sg4v0XigtoYL03d/Dz0BieeEG9CLhpQwsN+f08FYkX0pHw8iW1kasQmpwA/39ZjBWoLAgwLjFXT/8Jq7pPS7ie0KMJAngx0prcHkDhdWskUlPV1HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uy68fWQm0ezSTXmsmKdY8+fFLimvVaVt5P9FPND2qwM=;
 b=FzfOPMRw5bi018LHdFvanx+L4lp9mFmvgSfxEUFu40fHso+fpnM+Zphx8xghdP9gCzXXbEOWSDsmxDZVgrUijkJawsewuvjVCH9JMDg1Cq7wFZFVfVdAI1+w5sfeRs2UIWaoars2JiLGJuMGM+Vg9nAV4TD+zL1Gv5DtgA0JZfOZ6NUzESnrYnnw6syEX8cCbeqmBB2K1sD56XzDjDJZkTEPEOrj3pek1hQovdlNoWm98wItQhmj4OlZUwy9WrDimiEB6Cr1Xyc5NgTpIjiKFmXcaX1RFM+ib24tEWs3bRC1vv/QuSXn7Cmvc14zbXEWd8pChInxFpYWUdjSbfz88Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uy68fWQm0ezSTXmsmKdY8+fFLimvVaVt5P9FPND2qwM=;
 b=MKEKRnnL4CbyoiEauBfQmU4Khpg1qeAGXxf3bhGb3Fxd+uCrh5R/Khd6PwIT/jolx5ATwluIWr7DLQe4zlXUcAmUOcPuF5ZzOI1su55JLmclxL5Kw7aG0pZQmUkgpG5FINLn8P0dlbAowkTMJWI5JHkpjgYBpRW9B8zNVrGFK9bgpItA5/5mm/a0xCvN/XIXTe+HJtKwnM3iHURWXjXsbnxjOm3M5p0W3H5mz05eKMo8JN2PXomz731oMCgn4B+bD+adS5o6TR/JlWHDPicYhyvh1uzHe2gYLfuIbZFvGMXQFEmGgQmyx82gEdRV93w7sdqbKDn1BRmqfICgbAPpwQ==
Received: from SA9P223CA0014.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::19)
 by DS0PR12MB7725.namprd12.prod.outlook.com (2603:10b6:8:136::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 06:29:38 +0000
Received: from SN1PEPF000252A3.namprd05.prod.outlook.com
 (2603:10b6:806:26:cafe::1a) by SA9P223CA0014.outlook.office365.com
 (2603:10b6:806:26::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Tue,
 11 Aug 2026 06:29:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF000252A3.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Tue, 11 Aug 2026 06:29:38 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 23:29:25 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 10 Aug 2026 23:29:24 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 10 Aug 2026 23:29:20 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Frederic Weisbecker <frederic@kernel.org>, Gal Pressman <gal@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Li RongQing <lirongqing@baidu.com>, liyongkang
	<liyongkang01@baidu.com>, Mark Bloch <mbloch@nvidia.com>, "Paul E. McKenney"
	<paulmck@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
	<tariqt@nvidia.com>
Subject: [PATCH net-next V3] net/mlx5: Expedite notifier unregistration during device teardown
Date: Tue, 11 Aug 2026 09:28:37 +0300
Message-ID: <20260811062837.3196902-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A3:EE_|DS0PR12MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c516658-80aa-4821-5704-08def771eb8a
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|7416014|1800799024|376014|18002099003|56012099006|10067099003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	SEGJpKEjOrTgIo5M1njjaeaTPZC9qvmlYuEoip7XXtx1M1Mf0RaAWFBKA8SoFEVzPFHgFt2sI+XLZvkPNtD/yN62zntDCKJT5NT/FVw7eUyYopQdFxJevbj+C/ar7bZoKKkhMIdMUQIoDBhtSENP51R53/JI2Mmpi5EvEWD0/pRs7+fauYifYvubr/yauLK/1oVxxROICj0yd/yDG1JE19tjvtMj+Mr21BxXXrsUTcN9xtAjDIsztHzyRf3EQpQHQgWCC/hb5tWiK07o7IscyVJBRVPwWSQ7szBrJ51TDFBya6R8r1mNP4sDjaNoxw/JzKedin0LS7Pb3gWcQfhmfX4iYS04xjdPMTebW/hMApbVBCn3YddCQhq75ubO2ATqJLOloo5uhs+Mi3v+717GIuo3OvZphP9ielVVUG1wM1kTWFq+3A09KmDy/RxwBcSJez0/FyCGuMrmTUZxAxSRZFu7AllITwW3Yvs1JPSvzxXQMN/zZZT6Fkyhs6w/2fq8BKeRRqWgS6pBw2GXlKNNlY+8nxTTgs9/IzI3usP9bz94LPeM3Cuset/I+pq9k9gKzf/rM1wEo1QiAFRr4+USgGbttFGK89fwCFhg7cJEaOADr/jGp0nGz7/UmFatz5QcryhnssaYXir6/1voW0iH7R+sA54wshWUmkXmhNnGhK7VTkK5b1PW95bKZd/7XTdMdnPPFcfB/8n2bJ7EDxVBvg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(7416014)(1800799024)(376014)(18002099003)(56012099006)(10067099003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BKshiPPOmP9tujavSXzYUDiYvFs1mXdBaq0XWUcKVnnB6hroKGj+f0uxnNt9D2oo3mTjhpeQLYyKD1iL7ZeKJjoQp48NTb3yZMM+CHdHyErjYMv+wefS1iyx7Gf5OpOaeTadBdwsEUF2SDOq3gSaodefFOWzfbc3I5eBKBf23uof7I3Ds5k/Iw7XkPWr+Z6J7mnqcXmzKVgPsRuBH8Epr6WCKXKzs328nhERmaeYHkvy+tpKM39nzKBLfnVkFoSU7ChBBPo4lZQwK9E1O5eaLTbGlJYj2j7BX6pHIc7b/Vp+qe06CNKLs/R4dTT6Y8qtbvsgbyYrxOrr9zI0ZZMwliFpvLrfUYqGpOvTQT5AHEX3bGiK6gaTKp8MEevkByJIuXRJxmeMvRB0n2zO7OnGNApPWlNx/rZZT+LPbFaneELMxClD1d8UtLS1ld5BBcAV
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 06:29:38.6987
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c516658-80aa-4821-5704-08def771eb8a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7725

From: Li RongQing <lirongqing@baidu.com>

During device hot-unplug, the mlx5 driver expects quickly unregister
notification chains. The standard atomic_notifier_chain_unregister()
calls synchronize_rcu(), which introduces significant latency and
can become a bottleneck during mass resource cleanup.

Introduce atomic_notifier_chain_unregister_expedited() to leverage
synchronize_rcu_expedited(), and use it significantly reducing wait
times in the following paths:
 - Event Queue (EQ) notifier chain
 - Firmware event notifier chain
 - IRQ notifier chain

On x86-64 with HZ=1000, 64 networking channels:
- Average teardown time: 3.59s -> 1.9s (47% reduction)
On x86-64 with HZ=250, 64 networking channels:
- Average teardown time: 5.5s -> 1.9s (65% reduction)

Co-developed-by: liyongkang <liyongkang01@baidu.com>
Signed-off-by: liyongkang <liyongkang01@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
V3: rebased.

V2:
https://lore.kernel.org/all/20260317003544.2583-1-lirongqing@baidu.com/

drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/events.c  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |  2 +-
 include/linux/notifier.h                      |  2 ++
 kernel/notifier.c                             | 24 +++++++++++++++++++
 5 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index d11ec263d53c..c86090cb58c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -1243,6 +1243,6 @@ int mlx5_eq_notifier_unregister(struct mlx5_core_dev *dev, struct mlx5_nb *nb)
 {
 	struct mlx5_eq_table *eqt = dev->priv.eq_table;
 
-	return atomic_notifier_chain_unregister(&eqt->nh[nb->event_type], &nb->nb);
+	return atomic_notifier_chain_unregister_expedited(&eqt->nh[nb->event_type], &nb->nb);
 }
 EXPORT_SYMBOL(mlx5_eq_notifier_unregister);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 4d7f35b96876..753cb15cdeee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -436,7 +436,7 @@ int mlx5_notifier_unregister(struct mlx5_core_dev *dev, struct notifier_block *n
 {
 	struct mlx5_events *events = dev->priv.events;
 
-	return atomic_notifier_chain_unregister(&events->fw_nh, nb);
+	return atomic_notifier_chain_unregister_expedited(&events->fw_nh, nb);
 }
 EXPORT_SYMBOL(mlx5_notifier_unregister);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 0f5b8bc7861e..cb31e8c7a244 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -343,7 +343,7 @@ int mlx5_irq_detach_nb(struct mlx5_irq *irq, struct notifier_block *nb)
 {
 	int err = 0;
 
-	err = atomic_notifier_chain_unregister(&irq->nh, nb);
+	err = atomic_notifier_chain_unregister_expedited(&irq->nh, nb);
 	mlx5_irq_put(irq);
 	return err;
 }
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index 01b6c9d9956f..156d958f98f0 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -159,6 +159,8 @@ extern int blocking_notifier_chain_register_unique_prio(
 
 extern int atomic_notifier_chain_unregister(struct atomic_notifier_head *nh,
 		struct notifier_block *nb);
+extern int atomic_notifier_chain_unregister_expedited(struct atomic_notifier_head *nh,
+		struct notifier_block *nb);
 extern int blocking_notifier_chain_unregister(struct blocking_notifier_head *nh,
 		struct notifier_block *nb);
 extern int raw_notifier_chain_unregister(struct raw_notifier_head *nh,
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 2f9fe7c30287..9b35822fc2c0 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -197,6 +197,30 @@ int atomic_notifier_chain_unregister(struct atomic_notifier_head *nh,
 }
 EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister);
 
+/**
+ *	atomic_notifier_chain_unregister_expedited - Remove notifier from an atomic notifier chain
+ *	@nh: Pointer to head of the atomic notifier chain
+ *	@n: Entry to remove from notifier chain
+ *
+ *	Removes a notifier from an atomic notifier chain and forcefully
+ *	accelerates the RCU grace period.
+ *
+ *	Return: 0 on success, or -ENOENT on failure.
+ */
+int atomic_notifier_chain_unregister_expedited(struct atomic_notifier_head *nh,
+		struct notifier_block *n)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&nh->lock, flags);
+	ret = notifier_chain_unregister(&nh->head, n);
+	spin_unlock_irqrestore(&nh->lock, flags);
+	synchronize_rcu_expedited();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(atomic_notifier_chain_unregister_expedited);
+
 /**
  *	atomic_notifier_call_chain - Call functions in an atomic notifier chain
  *	@nh: Pointer to head of the atomic notifier chain

base-commit: d67e5dbda22604d0fcde32fce58c65f88676e676
-- 
2.44.0

