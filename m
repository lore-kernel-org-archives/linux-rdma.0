Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794318321;
	b=dlqDN/Wi2ktS73f+C5Qw9xAJBjkYhcm0zwt4nwKul8a+XP20Loxv0cNVgTghfMDsoNCO
	 0jammvD9BAnS7/K96mUNRK9y+hBenA4dAapk0kVG+JSigJ5EodPGhoyU55QaojO3gDbvd
	 1tTQ1yyonLd32+Jg6jlcH+F9oPmhUQiJLehJrgtv8YOXeOXYr5q4GAfRu7ENaW1MhWf4z
	 /d+In1itby1n93AvmnHUiX8GhGuIXl8s+TbAU1VO79tEK831mn3c9tm98ky+NrfPXW6w2
	 Zy7HXrmiDL3jHpU4NNxT7gqxCAUi3svJcNhKcoh0Yk1PMgHJy4e6d/v0yQ5p25A+92w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318321;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=pzaf1/bxBhKmbDw8hs4TcZavvXfnzlNeytJ5V5C7KVo=;
	b=r67zbmpdaVaZP5+2g7BE3BglYD2mrtqvZ198fHOblUq10wlVPAN3dzDWIdjabhQkyphC
	 F0V40WSmLhTUMgZFhyqxOBKifweZSWnlyxf2bcb1uhGMRy5WYdyTmPFKIZJ0f1yws3vmI
	 CT4JShIcr/PlTU01suz3RkSQV33dq4IHlvaYtT9zhDQ4qkdMbRvaHknk0YBflAfNvTfod
	 MDA+xJUeenUhjEMBVxaRvPbPhD/WV5eHYJwToWMPzVx0N9iru1LEatRLv8bwv1vRl46by
	 XMm3x5g890NHvaKSFXfYamK7OZrAvJOrrpTBfo/64DXlZzPKUq2l4ksLaU2gSAk3K1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kDVcKcTa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.53
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012053.outbound.protection.outlook.com [52.101.48.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDEE60A2608;
	Tue, 10 Nov 2026 13:45:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEDEE60A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=kDVcKcTa
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YC2GOiwCfX711+tQtSAvbjTQ9M2qiSHzwAXPTQtQ+pys0NTcJVn9ISngrohTWxXtOy2N3eNyR3tfF1qA2/Zk4Nz4nfUJ4lqqxS82I+IPhZ8ba/oASs35cEMvU3gb0szO0Br+fiNrKDNFKmjUbQv3+Mgy/pzbIGUwtaQVYg9kvexFKmY6bQWkjnL9dV4p2YSl24mLYujRaFj8IcK6QPvyRhv8h/Dz3MkjjQTRUtpFQYyDLFv6NZoehmnxc/3h8il5rEeN/kopnClcNMmZ55kONjphL+Dqj1ggXGml8/pkk0yrBnUSCwMNd81xrUki5qVhJH288IVbUUE2bBopBbzxAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pzaf1/bxBhKmbDw8hs4TcZavvXfnzlNeytJ5V5C7KVo=;
 b=ix6yT4nrXoycHBusmZpG57OR4KszVt3viMFxURIysE8yARh+Fd6obGCb3UE10XBBD1r33ZUV9tMS00d3g9uuxaYrQP4m76IJjxSFR/OEcDtL6cQ+92lNeZrTzZFkJxSEMsngMfVlgaRSEcV/y7iG5Mvuy9BWRJzoxmTl92Nb2XeAILADJ2vLpFgR5LAas+bU0dzqCND5YzzQL4BQ1ZG8pNp6h0vfR8kQDrNxvV3Hwh77XmhpuBXgUTpumHN/YYk0TGcaSd9kA9EIIh/lhUdhrfvihF51yDNa9Mw1tKup1vfqWyIU/GtZoAi1xaRm84JclFs1LuRlf3a4AOcJ1rhpJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzaf1/bxBhKmbDw8hs4TcZavvXfnzlNeytJ5V5C7KVo=;
 b=kDVcKcTafHVMiCsecvzUhvQ6IUcoUgOqvk6901x/zAgX8aBtocJcuj8dacqLmQr3myqRKd19ByXTT900ezP7Kv8fQeqoolT+gDo6MvyS1I41zYfD6lHGkrw70E8A2dIMHAvQxv7p8G7hwMoGCORst1/sZZZTZBW3mJPJxPEQn+b7DlymvOSsp5vXvvolJSQjT5mUKpKgXB125eZ2Q9WyLGW7WVaSVuWNwshDsKCx8XBtQ8TZEMpO5Vxdfp562tlBD/vFWJtmVPSxITdwjgGO+AQPC2HHYdgsxCYEq0EYY+F6gg0xPjKm8sM0avlXuoSfTocZh7nllGfRIxtzcBMzPQ==
Received: from CY5PR22CA0069.namprd22.prod.outlook.com (2603:10b6:930:80::15)
 by DS7PR12MB8082.namprd12.prod.outlook.com (2603:10b6:8:e6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 13:45:15 +0000
Received: from CY4PEPF000392D7.namprd03.prod.outlook.com
 (2603:10b6:930:80:cafe::59) by CY5PR22CA0069.outlook.office365.com
 (2603:10b6:930:80::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 13:45:14 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF000392D7.mail.protection.outlook.com (10.167.247.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 13:45:14 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:53 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 05:44:52 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 05:44:48 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 14/24] RDMA/mlx5: Keep the UMR QP failed once a forged CQE is detected
Date: Tue, 10 Nov 2026 15:43:10 +0200
Message-ID: <20261110134320.34408-15-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261110134320.34408-1-yishaih@nvidia.com>
References: <20261110134320.34408-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF000392D7:EE_|DS7PR12MB8082:EE_
X-MS-Office365-Filtering-Correlation-Id: efc6f0ec-8e6f-45f7-c0d7-08df3f30d96a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|1800799024|11063799006|56012099006|22082099003|18002099003|10067099003|261102123227099003|261022105027099003|261021135927099003|261021123027099003|261021121427099003|261028144727099003|261026140227099003|261026121527099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	8J8gQB6BEXlM/mLUyJen4hG65sGAdgWr1Ppx+i4pxaVnt2jp5TcNOQXXlKRqOf2nKwJfwjyHokUnMpqMMlm2YAjIbeOB5VNZK8+ZFevNv+lHWe40D5vIvMH32YpZ8vf91bPdDswP9t9MouqaWCm91D/EseWVXGnUVtJv2Cobdud0bMZr2l7tDQSGJBMCX7FOtlBhSajKBgNihfMdXCtugjW3csxUWmDVpY2ViZvtXtTCjb+v/h5JLMltNFea04IyriXsZMauq1l4gr8KzxYl/ufn+YfbdQSrTDcl/q2oW6w9DnJTW6kqt6G9Gt6CixFwV444F6oDb7YVaecQo4QUra/e47tn9nPmP09JfRZel2fxIrl+n/rOGfylPP7t7S8yzbShocXR91op8+rNWXQ8BopTwNZPeJ7wPkmKOpg2QwXMf4ZbBkIClxkay4lhkNW+XEuggMNcP7NK1yuc1qICcYGbrDAA3D8X49ryEkl1Tu1e7o/xTXssRiHDh89cA7GODwA6yRHNW1mH3wgzmdfW5Wq7Z8xrwk7DoaEu5rOGLph+7gn+gU8fRGsXKKdFU5WqXCfKy1BvCfOGdtUS0wiRgrUBTK30pchPJJEQ+7Ms7NHEOC7MTri3zH75iWY0oXLPMArZNWa2s2Bhkgb348jYzddR6Mqe5nOzAHcKXGT7bcUX4jKJwVtU+3+ro+74NOog
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(1800799024)(11063799006)(56012099006)(22082099003)(18002099003)(10067099003)(261102123227099003)(261022105027099003)(261021135927099003)(261021123027099003)(261021121427099003)(261028144727099003)(261026140227099003)(261026121527099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	L/ZHeFw/7e6B21yBKztO5M8ZEymYW4aroKxb66FkwJ9LJ/7ewN2Pqk+IE4f2jYJ2dvWEHIpRU/rwpNous4OACn7gmO+0WdPeCaXF9spzbs8Q9pHMfoua2kyWpZynszGwjo0rKuS5MYfsNqx5oTjXPJFDlpr2oE/Q0jFBsgAcynFHv0Mu5DgFWQ6/6hJwZGqZgH+/Ggt+ekJJ1JehyP0MSXBSenAlWOp2XlgtMB0cMvPOShuUcuq8O1qY32hm5UKZZ5bUGquPssunVE+zrtfn4VXZFH0WBgBv2Ru+ia1jj19uzrMPsKy1AxsdBhwkeokrtSe/7iTHMEs1X+QVPhBjWXMr6/rI4MODO7loD/5c8FUKITDe/DjsU6Q2+X5H09ttQHmOOpGaAZafsjo8vat3HNAejrn9llmdYlglGXRnZmzuWc3BFg9l5/5zNBdve0NK
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 13:45:14.7597
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efc6f0ec-8e6f-45f7-c0d7-08df3f30d96a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF000392D7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8082

In adversarial mode MLX5_UMR_STATE_ERR is a final state: the poller sets
it when it rejects a forged CQE, after which hardware polling is stopped,
and it stops mlx5r_umr_post_send_wait() from posting again.

mlx5r_umr_recover() runs concurrently with that and moves the state with
plain stores: it enters RECOVER from whatever state the path is in and
ends with an unconditional ACTIVE. An ERR set while a recovery is in
flight is therefore overwritten, which opens the UMR path again for a
NIC that was just caught lying, with its poller already stopped.

In adversarial mode move the state with cmpxchg() in recovery, ACTIVE to
RECOVER on entry and RECOVER to ACTIVE at the end. If ERR was set in the
meantime the transition leaves it in place and recovery returns
-EFAULT. Outside adversarial mode the transitions are unchanged.

This keeps new UMRs away from the NIC until the forced health recovery
moves the device to MLX5_DEVICE_STATE_INTERNAL_ERROR, after which posts
fail with -EIO anyway.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/umr.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index b0f00d4bc93c..086b397b830c 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -335,6 +335,23 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey,
 	return err;
 }
 
+/*
+ * Move the UMR state from @from to @to. In adversarial_mode ERR is a final
+ * state: it can be set concurrently by the CQ poller, so the move is atomic
+ * and does not replace it. Returns false if ERR was found, and true
+ * otherwise. Outside adversarial_mode this is the plain store it always was.
+ */
+static bool mlx5r_umr_move_state(struct umr_common *umrc, unsigned int from,
+				 unsigned int to)
+{
+	if (!mlx5_ib_adversarial_mode) {
+		umrc->state = to;
+		return true;
+	}
+
+	return cmpxchg(&umrc->state, from, to) != MLX5_UMR_STATE_ERR;
+}
+
 static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
 			     struct mlx5r_umr_context *umr_context,
 			     struct mlx5r_umr_wqe *wqe, bool with_data)
@@ -353,7 +370,11 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
 	if (umrc->state != MLX5_UMR_STATE_RECOVER) {
 		mlx5_ib_warn(dev, "UMR recovery encountered an unexpected state=%d\n",
 			     umrc->state);
-		umrc->state = MLX5_UMR_STATE_RECOVER;
+		if (!mlx5r_umr_move_state(umrc, MLX5_UMR_STATE_ACTIVE,
+					  MLX5_UMR_STATE_RECOVER)) {
+			mutex_unlock(&umrc->lock);
+			return -EFAULT;
+		}
 	}
 	mutex_unlock(&umrc->lock);
 
@@ -387,7 +408,9 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
 		goto err;
 	}
 
-	umrc->state = MLX5_UMR_STATE_ACTIVE;
+	if (!mlx5r_umr_move_state(umrc, MLX5_UMR_STATE_RECOVER,
+				  MLX5_UMR_STATE_ACTIVE))
+		return -EFAULT;
 	return 0;
 
 err:
-- 
2.18.1

