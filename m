Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794935479;
	b=TtctLI4r6sWczFbW6I4iY0DxormpXAnbJDXyzCI3HwvB4ZNkqBlyOO+JMlBp9hMhWK7J
	 JuQDb7tG1tAVJ1HX8AJrL8FPHxRkSjeWJhqGZuC5z1Ihehp7Y59+ead6tx/X+bCpEK4Lr
	 jGHih+m9Vcq/bE2dwbjRCBwKNBqtfsi5DMGC2u6V66zfl8xK25Ajhi8A+xG65qpYOIilr
	 SFXjJEMg5lg8oiB/iqd2p6Xt/w6jVf53Q5Vx3pLiXZ2EGjtHPsP+dtekFOvADsTGWgV6u
	 2u/T1PLHa2Aqz1Z1D7heQlqj4xqPZNvjOkSlgeIOhf0zoCPVO+WfHxZ4RRl1XroiQ5Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935479;
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
	bh=uMzs6oQixnNcpEIKVGkrw5m2QC5F28l9Lju1VmnhMmc=;
	b=jx/upF86jLL0+VcUI0FFah8z7CKGhzZqDalNqs5bOIV8Odq8LyNoNFzEeClFUPRhzdkv
	 mbQRzJlmvTK8SJtBNI6ZVS+W1UDIGxwBooRIfUkK/bM/2PTb1wuj0Xzumw/ixgWTvHpCE
	 2iNnd5ydk1Rm8ZE5LWcUr1ClSRmhGuKsf2ddFr7mStX2wSOS1YwIHR+N8f1LNZEWOMFLw
	 jfTyjVuQb826iRbQVYMvyYYpv1UfxV2ii1tQA7nOHb/cCxo56C12p3wcUWOW+uY0hPSjI
	 vixqjhyFNHHjXTeiv2Tsvp0wDqiIVXH1rpGtk6G8R5ugbOjttCAiCPKwhnwfe81D00A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lagdy2Ab;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.41
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010041.outbound.protection.outlook.com [52.101.56.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B6E606A31C;
	Tue, 17 Nov 2026 17:11:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25B6E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lagdy2Ab
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VO6Xgn3LHn/DjyGDAhYnHtXcA2RDHTaUf8Jy0HTsZ80BCDIDf8WHRlpA6j8fQLbwLAI0jgtrin47JNzsk+GSzHgKRjQaqaXETUtMbUBKL1UegQcOuHv62anjHXKplGrmCJT8IfOSZBzbnLL3qe9owF2sjCB4gHyyzGXdvDn4lAMySyRyo0rxr6aqDCYlzPFbnmi6xCB1+Pq7bX8zLr0jPeMapOwt0VuSYLrPGdWw1J9iSKgj7msc4j+qUTWXIBe2+I2J04Pz4NdxNc7kbQ/22HSuTGUKicfsYMhMfyEgZ8/T7dkAp4KGAt5meDnwDa2/LDXsIoTcqrxk7uJL+0u4Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uMzs6oQixnNcpEIKVGkrw5m2QC5F28l9Lju1VmnhMmc=;
 b=VSHrsax4RiPLI7RG9R5lywwKAvq52JGK0lUiY4FowWVZw3IGHeQFqLUZ2B9A8fMFIkfktLd59kuLF8ulCGUnMo6MAoqz0t8csSNoOvbm5zHARCEvi7j1NiD3k4AotJuv3WDCm0ezJze9h3rTU6eUFocdN3SMYJUOrDasGq/I4cCWaNtD9QZCQX6qBnl8chKHdPOd6VqE1Xd0FB92hGRNaI0PCfuhTQHK1NQMw3sz21GlxtmTFv+eCxXQCjgsemXXPaJNJ0b+cThII5/GF7ApLqz2BsmjWZ6OnGcwMNcqa3tGBrRWHqloGUKI9//tVN+R0FJ2oJOP5GP6TlChCrGe9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMzs6oQixnNcpEIKVGkrw5m2QC5F28l9Lju1VmnhMmc=;
 b=lagdy2AbGsYUxIkbpworboEAKxPo+xaxHe7140Kc0m70hCBaZkWWLLi77U+mM2cQ/Yyn7CHX4SE3Z5UHYFk7qH+AOtjWh6E3y9hcokBGp3m5LdUVqthFC7k3f4esDF2YirgW+5+N9xZUvVdIFVzAVoqM5w/enQ5ylMoIl1rwsVU2LvjHNA3pCRYqtuJsI58wvVxzGssfAVgv/Pi1hjX4rBZHksQQoFM8E17lHlMoS3WhqrHgu6jcsgRmkez0J5EVqot1Z5IcyZBC9VWySTRgVF+atxRk82jk6o7PjZcYgQE/KLAq9LSxSNA+aBit6KPU/f7QrXiORc4qWMrWI58kRw==
Received: from SJ0PR05CA0030.namprd05.prod.outlook.com (2603:10b6:a03:33b::35)
 by DM4PR12MB5746.namprd12.prod.outlook.com (2603:10b6:8:5d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 17:11:01 +0000
Received: from SJ1PEPF00002327.namprd03.prod.outlook.com
 (2603:10b6:a03:33b:cafe::12) by SJ0PR05CA0030.outlook.office365.com
 (2603:10b6:a03:33b::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.6 via Frontend Transport; Tue, 17
 Nov 2026 17:11:00 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002327.mail.protection.outlook.com (10.167.242.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 17 Nov 2026 17:11:00 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Tue, 17 Nov
 2026 09:10:45 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Tue, 17 Nov 2026 09:10:44 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Tue, 17 Nov 2026 09:10:40 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 rdma-next 13/21] RDMA/mlx5: Keep the UMR QP failed once a forged CQE is detected
Date: Tue, 17 Nov 2026 19:09:06 +0200
Message-ID: <20261117170914.27410-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261117170914.27410-1-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002327:EE_|DM4PR12MB5746:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d43e767-1555-4234-3e03-08df44cdc10d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|22082099003|18002099003|261009223027099003|11063799006|56012099006|261028144727099003|261102123227099003|261021123027099003|261022105027099003|261026140227099003|261026121527099003|261021135927099003|261021121427099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	OZDz+wHjGqnxNvwKF2DDZH86QvgELtOKcTTXTVpQVFf0C1IOG7T2usWpaEcyGlGSdGiC86yr9d3HbE/I9qOg7Dt3k2csyJhNYlicoVYV3yNxqEQwaqKjHLCR/UPC3/6Itt9SIW6JQoqFcAHnUMJFOAWmGo3ePkoixHxlZ+t/hH4FFP5cVYeh5kZQy8h23oIlN6SFOPvxfGu1pXJwaR/DQcFsN2mYjzV/HFFI/bNDIjmQrAgp7oyl8qAS+aaZeJAltL3oQze9AdFhfoyz1Gqks6Y+s0paaVaKDDZet0gsnSAO9xgnUxt7wRNqI9keKa+scF8Vz4BCiK30U2SzpJgyPINwV5A+uy1S6KcxWtQE46gVBUt5cHQtR/FK93nTflwYFpBpGGEsJQTDUFPiw10HkACId/m9sftZVZKlLAp31WFupUpwHcc6AV7flHG1OxYMWWgcZIaAybbQPsEdC1zAxJG1XyE/KFpeC62QtITaQA99XQUksdTfPDNnHQySzDKjvWoOyGfVJm5tZowlD3e6bixCsJMoZy/2tNqTT/Fzbq0nbZdpoDP9RN/N8YN9TbdUsgEm9qr5Tpx+wXABpdMh9tO83OHUZ53jJD9CVIl6zeoqIFuzSn9jQwl2My89nociqzqvwdVwpBc04NRisxCe/VG55/807b4OkRW4JcGq+oh6wnzqFAlmFl/9aBlO3ljaCiR82ehIgX9norxIYHbE5w==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261028144727099003)(261102123227099003)(261021123027099003)(261022105027099003)(261026140227099003)(261026121527099003)(261021135927099003)(261021121427099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1atr6ZKrYm2ummUvdyQCpcuiSjFG9gDH6t5wAyYItet4HGPDcPkuExdGhQkxI26GWbSljVwUStZC/W+eYRiOOE+WiqMF5tXQqsRa9Zz89rVqyOxgxfd8yLBy8lT216eMzVcb0uGbt+XK9g9JPgkIHiKtS4o7uFwoXnrPkrEUwMX/y2bvlaEdxzBR+hQUX54VNMNGgN40Z8tLiYkg6K/SeiXfc1qCxfziv+FRwI4ZDLtXxIVTxdgVa9KaUO79rPaxVrFy6Wn91uz6uRcZuIaLJX2oX7W7fEK1kQkjZrhelwEAp4FQrK+JwXGV5RgvmwRQGS66GrXxIv8V4Zq2h85IrS0CrnoCLaU0WCxmTSry+iBD6tgjX0cwhm3FT21pRhOmLAXUF6UqCExmgY804CHweCNveKG1MUVVJlhP45LngMxFsa2XCH4fnZ1rUfsjGZMp
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 17:11:00.7549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d43e767-1555-4234-3e03-08df44cdc10d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002327.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5746

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
 drivers/infiniband/hw/mlx5/umr.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 7b89faec0570..d7dc9ea1e907 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -335,6 +335,25 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey,
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
+	struct mlx5_ib_dev *dev = container_of(umrc, struct mlx5_ib_dev, umrc);
+
+	if (!dev->ib_dev.adversarial_mode) {
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
@@ -353,7 +372,11 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
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
 
@@ -387,7 +410,9 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
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

