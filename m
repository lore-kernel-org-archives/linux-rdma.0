Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724117;
	b=tFcu2HAr0hvOf2+09I5MahOKbtlRy4ZTZLG8uciLZv8s/GfxmRqwu0TTs1VGoro0OsbM
	 vKs/QRBI0mW26EBFh3ya/25i2/Xm5nevM/XelwEsZylVDN0iWfsb6mDxAo43/kijPG27h
	 2dqjtI0xYEOSCFcY+oQMCRT79/NGAgOUy9IM9RfM6HGit0mNm79A+wOq18PED7g8pLW5g
	 MrYTzTXdUho6h9jMHXzt0l3gGXo0IrooW7OQL80vp8RDjBocsJyIZ7JiKggVuXZrrs5aE
	 HXZfJyzuA8lIIyQtMJiGkKxc/B0o3IFsKaAfb+NI0h1PEezMaQVNs4sEElPO7QP8v0A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724117;
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
	b=i7Zu+oGlcegKtkuloViI2iWQ5eAx/ZVLcM3tx+esBGPVC7EWIJNZv8ITngn6flVIsjAw
	 gPQWB9t4FiWYW4iLr0LyrE4JTo3+rhfXcGuQf0rd6mgYOgrS+xtJjsZgYEhNKu6zpoBXD
	 1cyURaPCI3b8UxHuXXrhs7EDwoWeX4xlHn4+SgxSMkqbZvxpHpSKUI10sRvT1Vsq2QoFg
	 KlZI7RtTVogNvOUxSY3WpOlL71zRejWWudtTVOJwqVYdu5RkWJup9kC1iH9C0iWUFh1q2
	 hc8y7YWDMs0WqGUZslj392ClKcNEkvwhD5mdqgg3VOy57CM7tpyKWNejV5fJIa4URAA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZXn2Ib7a;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.14
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010014.outbound.protection.outlook.com [52.101.193.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB2B60A2608;
	Tue,  3 Nov 2026 16:41:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8AB2B60A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ZXn2Ib7a
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VU9e9VJsemMoFwaBE4HMi5etHEkW1DXcuu2qUzqSULz5TFf0Z6pGLSSXk/RLg4EC93vWPe34gkI3lHLYLQshoLi4BdakqlqK+Et6QrNLVT9dPTGalQu1wAnmcGpFqaZX+F668WG3ovLd7nNUDP5N9PaZEbNfeoshXdAQ9QM4II+CrGSHH2T4I/+pXq7El3EEo77lc9x+EJ9UdQLvf6wShiSanC3kST1oMo0tKER814X4nhcIeOnU3bCdMexUww7UIqYH+Yu76Bye5O9kyBBu5PTVjmneSAkeZexeJHylGSSz3gPYwN3bOPqX2FtvN7ho2KqNDA1z23ne3eCcDyVIBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pzaf1/bxBhKmbDw8hs4TcZavvXfnzlNeytJ5V5C7KVo=;
 b=lF6dDb23vrC/4ivuWJIOKA/r7JwYQvNseLF9a2pyawhF/Vs/17pHPXixCvZDMPhvk4WxXJKxZXJOMDM34Mfigw3KX6NgMZ8/bv30L/Jr2oLuQuopHHj4cMlicrtNhiPPKw+93VAyAflBsVG3io48kFuYtTGD/yg9AMydcPbqmqOe5FFDPWNtRzq8xLNR8eSftgIK4ifsDfHgt62j/+rTdu1ihjBednlp7veQap/Bb1I6ZVCcycQY2c2I5rq6sVfKdZML7xyJCtxGwLkeA3FrmNF4nAbiepkQm8mmLegWH7D7shVvmP7yqSRuvKa+/VItR9qoelybzGneP7mgLCAMTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pzaf1/bxBhKmbDw8hs4TcZavvXfnzlNeytJ5V5C7KVo=;
 b=ZXn2Ib7aBpuTSEBt8KAZaF+xLBbQkMHxf7lpFbZOAJNaHrw407B8mhWs27k/KcbAPk5G6zkA6+UahLY+Kcd/VOOddkfICHpNZOiGbq8SZdIxC0JzmqruysrGhANNbCXvEjk+Zx6ogJGx0uF9P3JkxaJS2wbLPnvzchaPUhD4MXi5lvB+0jTXeXRF9vv+TDWCIw0TjgtlaXXP0vQzATgn/J8bEJxPI81TWhmMDF2OYBCU3G6qTQHfeu2CogWe9ng5wiWGEI6CguNoueMHjxfUwmZ6p1nIRMDsQP0/IycI2PJJnFy4TvsTX/LU7a7J35EExWEu2CzobvQGlQae1009jg==
Received: from MW4P222CA0002.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::7)
 by DM4PR12MB6326.namprd12.prod.outlook.com (2603:10b6:8:a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 16:41:46 +0000
Received: from SJ1PEPF000037AD.namprd03.prod.outlook.com
 (2603:10b6:303:114:cafe::3) by MW4P222CA0002.outlook.office365.com
 (2603:10b6:303:114::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:41:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037AD.mail.protection.outlook.com (10.167.244.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:41:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:21 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:41:21 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:41:17 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 13/23] RDMA/mlx5: Keep the UMR QP failed once a forged CQE is detected
Date: Tue, 3 Nov 2026 18:39:39 +0200
Message-ID: <20261103163949.1554-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AD:EE_|DM4PR12MB6326:EE_
X-MS-Office365-Filtering-Correlation-Id: 03da2950-8a05-44b9-0afb-08df39c958a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|261021135927099003|11063799006|56012099006|261009223027099003|261021123027099003|261022105027099003|261102123227099003|261021121427099003|261028144727099003|261026140227099003|261026121527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Z1DqbpAPqJPSzXgaPl3OmBlUkAUZ7L4x5EJ8298npOeJSF3tJa0JKj4ZFg6Wty9SU+izNoJ2uEM4pd2ZvcCQZTGwyaMLO7JM/vI5DMU/PwjHjRTVju62L0/fJBHr+zJA4jlm+De5WZ2Ebddqx8y2UAhrL2T4ZvWLydgtNPTOyMU4WHo5HMgOCaEwaW6wHMu49G30UaqNsvcvMCJ9Qip1RPkL+SJRMxt0CMKtDDVJIzHWFhbckB9Iyon/rKof5KARHPbr+gmbxW2+WFnSAWmWswqgOREOGjhPuNtSmY6QffrPFHsmme4539sHNtmc+2qsILW23Gad3gr9YEtjEyECOM33YTOAgTwJ6chIx9jJPPDJD0Mu8Sf0MkkUB2Q/Rm85r7NUdtISiv+PRUcmVaHGTCr3q90XNX4xGkOsXs8O+nlTSpEP0Ky6EZz0/+DlaKyG5X1SBQ+ZpSchy9x8+q0JgNwbleoe0Dssjg7aZCc1r1FQ3JpSuSlXP42Lm2oDtNZZ5LNfHIHSTpG/XjQQuMqhHNo+8hluiPkjvYwYeEX13BfDCF+A4JeCr5ypDbZlxWrB8/UGn+uBfgGR+ch2uiQlY3y5UIGL2Er9LQ/4lo86Wjjx8keAQ6Wg7ZTwNq/IFdoz3I5baZqN7Gv4/TA1lZKuP6zlczbB+6DyGNQ9zjW9FEPFusAtI1Y52vqlRWDTEJxpDoh1DRXp7m4pej5B66OQ1g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(261021135927099003)(11063799006)(56012099006)(261009223027099003)(261021123027099003)(261022105027099003)(261102123227099003)(261021121427099003)(261028144727099003)(261026140227099003)(261026121527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kxUZrsxKnkg3EjxeVLIPcFMiQ6PivqLXYH+R5AMt7BvyPKEe4TkEoS19cTk08vIqOC70yzqtTzZsLNWFVIjgK0/KOSTLVvUBrO5mNx4xTnIQI/9WINg3aEmwOoe2uKAyHPDa3bnsHQWEsr9ItfKgl1ppzHbJWzMgn+jdQFOdPcoidAAaF4ygl/k0F87AYcK11bLGag+9FM8SJ48iAwNUBTFvLAGB5mLkNzDlR0f4t3P/n/DAhM8vzByxWZPfnm8zcZW9NnTpHtfRzEowcU0LLa4zBGnm6p0Q/HXAJAR5BgRc72FdEe3+mVX6LYVJxfbJvF7LSRXn/MbCCcjczku43U/jXY9lyfa+iEqctdXlAuLmI2GeFrLFAr+2BI2TxQ+ytORdxixzcSlfGLrBnBx/J9bdHTv8NWmQIJZb9PXhIjca9DRgxcSLWlYNB1A1lFtJ
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:41:44.7946
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03da2950-8a05-44b9-0afb-08df39c958a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6326

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

