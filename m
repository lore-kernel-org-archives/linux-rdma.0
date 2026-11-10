Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794305883;
	b=LeJ8K+GlYmF2xXlpY9hLTRVEv106KlXXGwID+vDOtutRZfm6nUMhIEYK4paRBtiy+sA/
	 oChBjIcYnqBMLBfjRVlHXfsnpauY2kvUqzsw6nblYTx0Hlu4UmwNAn3//lYludkTAfE+x
	 NRTLS815xkq6JlqZvY78XRo+kaXFVBUKPO6v0I9n6oycKEgGmDjMyvILyJaSPq2l5FOzM
	 uJbqT5/+PmL1tygIS0U2qc18vtQtGQdNjqfli7sA+vXXLvOodWJms1ZyvN0SzweJJwh8a
	 sOwh2aeGXSZQxLA0Lic+sX1MqcLIgMdEJ0tnqb45u5YO8PTQtSyIltXGzHwPXFGrAdQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794305883;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=kEgiTWIbSoBITTpBWrPePkWXvBPwetzFKfjFaHfjBgI=;
	b=aHJ/+/qJn2/dB+GSBlf3zpBdZVbLxGFY5OOA96uU7jkUspjoZAxHp1bcvqQEyaGztOfK
	 hgiry4kgFawztPjcOusTD9WlLgjumXQJgkaLKP90GpXT1oDwiiiDf7hxORKZwEekA5RA/
	 sd3VKd+A5azyebPjt283fa6ynn4ezCGIzAKmgLqLA2PkM5WonAsTTJubO/J1Sx8QIWcqC
	 Z4HiLCi+ipiJuW80+jYN/KEzpFYl1YY3rrn4c9PRUdsDABLDuI8xPk4Ps8dGqBJU+lTp3
	 w98oalS03Go+gZXPkPEzRCj5D59OqfOqLrPDQb77DO9UpsJrZPVopDZnrPcnfrKbhLQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=icktxFsL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.70
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010070.outbound.protection.outlook.com [52.101.46.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7665A606A31C;
	Tue, 10 Nov 2026 10:18:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7665A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=icktxFsL
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pI0wYIsCib5s0BRvHaxOh07sE5jCydRvBmhG3UYZtnmVf9zsrrsus14jGo2G7E5jriKuSFZH/CZpyU5YZEFbGpH7SkhacGmHSEZg6KrmjxNUK/DNbzUm9TGCYAQpovT7obu3ql5GEzP/64NHlrzpGGoX8Qvsf4WmVtVWCO/9KYkU51M9i9hQM1+0e/8qhT+4fpmiRXu91RBwzRXzkTskRx7kue+O4iA3Xq8eK7+ZDgoH4+zaOZPl/wUFzO8XhnuNtTYue4Bw7Q1j+uC8M4bVCsKyXZiES2kRRQ9spGa/IceIGXlpnVGCduqH5wEVbakLFRX00jFOFiLgKWkFGlLKXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kEgiTWIbSoBITTpBWrPePkWXvBPwetzFKfjFaHfjBgI=;
 b=Y66FIJbkf3yecXYJuHVwLdhYe43sBQRq7X5qaQX2/0BWhVRCuJ6QlsFLHsE1cKnXWjnyrOKqblcqFRalhyvoVaNaXN2fQVUfhR4ZQeBP/hnBzrSMSvMklXulGDrpjWGdRMMnIiuMeKJPyTLy/9pADZECQUvQzoy6+jd/pC0LZHFpk1oeG0j0/QVGwqvhK7zniiHD62TqQ574KGUyzGdGVcHfCabBLn46gadULGtTenTaDSulmskJ1tmh6zLZZHq0CLrIGArIRlOaD/qFugRAYAJQlb3uATXgG9ehZo5b5e3js4sZ8mhl1+d0B/9ytdfXSZSSB133I2Wg07Ox3qIqLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEgiTWIbSoBITTpBWrPePkWXvBPwetzFKfjFaHfjBgI=;
 b=icktxFsLcQHow8wBTFtt6rD9VS0RLHLZlQleum+Nhb1XA0iKMuh3sTWDNUY07ZxST9YFGWO8dLsi8+SMH1L+VQrGCERmx13lnnbYAqL8WWfN36qm390DPb8eiyOzAdbBxQCv+RKym86JsJWhau6Nos5XAnUk9AndOppkGRktA+y3/lel3cybm1S8eG3HY6M/3Cko6VMuVmDBXtnBRNEzgi9DwZc25qVjeEkMkVaMbxEpKRPca45ryYMMQi4+W6LZCAMASycZ/ixNLhFPG59UwpbJarTtTsUQn6EQ5DSAG4NnqhvstXuQ5AgSgpFipRFjNbPFzJHuJ6v4TtEOYpkDSQ==
Received: from PH7P221CA0013.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::9)
 by CH1PR12MB9645.namprd12.prod.outlook.com (2603:10b6:610:2af::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Tue, 10 Nov
 2026 10:17:56 +0000
Received: from SN1PEPF000397B0.namprd05.prod.outlook.com
 (2603:10b6:510:32a:cafe::3f) by PH7P221CA0013.outlook.office365.com
 (2603:10b6:510:32a::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 10:17:56 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397B0.mail.protection.outlook.com (10.167.248.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 10:17:55 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 02:17:36 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 02:17:36 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 02:17:31 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Boris Pismenny <borisp@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, William Tu <witu@nvidia.com>, Xuanqiang Luo
	<luoxuanqiang@kylinos.cn>
Subject: [PATCH net RESEND] net/mlx5e: kTLS, Fix missing error unwind when enabling RX offload
Date: Tue, 10 Nov 2026 12:17:09 +0200
Message-ID: <20261110101709.2589088-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B0:EE_|CH1PR12MB9645:EE_
X-MS-Office365-Filtering-Correlation-Id: a3db2f79-f732-4b92-f045-08df3f13e307
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|7416014|23010399003|56012099006|11063799006|18002099003|10067099003|261009223027099003|261102123227099003|261026121527099003|261026140227099003|261021123027099003|261021121427099003|261022105027099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	hlflFSg1+xlvCp2cCnV6HWswmVtRRr6n2KnONrQU4lNWvAHFdShzIOpRZ6cIqE9dYaH57VH28BCiJrTmrM2g8jPGJqN2a/6D5wKTXJZZsMQDgO3xe02N6ZkgZQPmI2EZY7KnLRjpqJe0basdPqSuXr0a+ZPgPERKh2SdsNBnQiL78vW0K1TE2oiDPLZbQkTkFrP8l5521UMJgzZrhrT/5Y5SD1B26TFtb49a+rCZ+EA940XKHYsliI4pYXRknQEr1v8UH3NkQdPgkU+ElHjWZojnhLWyZJS+OOUFBjSvxDGXpipHPBNSxKtPIT0oPiPepYrL2/XhsLuS32LWwtM3hMp+8iusA1UeKO9owq51pRJJjXYmAhdc2VetbNsUPhE63xYpcSIKNK2/QhS2C6/zNcuzBzzt5tOJORt4zwAWVqKZxHJCmHE3JCW1y3sHclfGL5XHmKFR6c45A2YatDS/d9CoJSlWEPoGE3DYbu+crqCIvph4HnbKO8trW8oGo2EMqWkuOAH5obzDg+5RkkwnqHa6deTtY1vdp9TQ9NY8Z12LfKOXSmreic9IJ9uAdwxkhXZlOhcVMzW5ea4InDgcJNETeTwNKCMzIqnZXR1j5PvX5R4wkCvFAd9CBMQ5i7j7zMtlsGVnkJXCyR2UgP6RQx6zKv8z6ZrfdItXfvjwKRi8pA0cpU+r3OYVQaxI8V8AsrXb2Crd4sWQJwn0v0q+ZQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(7416014)(23010399003)(56012099006)(11063799006)(18002099003)(10067099003)(261009223027099003)(261102123227099003)(261026121527099003)(261026140227099003)(261021123027099003)(261021121427099003)(261022105027099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Z4mi4Mv77AbiYGcCQ/fQ3a5Zv9sIv051HlWLkqZr+cu6mDInra+F7B3I9R2Qnmr/ZwVJlEiGa76gAqN3jfBD4APdGWU2YfP+LvmdXaQe08vXg49/TjCbApRUEqIs93Pu694OP/UCHIThQLkNy2D7QOJV0Z3B9mEOL1yottfcGUFxeGk62oKQ/US26Z9uCvBtuKzEoFL0H5nkWvcFD3DYUKQWK9WM3KqkNT9iEAV3XZlAHBbMGzqRcyDgpWd8Y/E9nfSNlUUYoRQw+AFNwZAdZciSYBREPCVJl3Z0+yWc2z3+H4uMCJLlG6ld0dmYc/4S3gz7PxJmQma7RlF4b6DBc1ohAwqonQru98YwC5HCmqbZALTRh4wjAVM2tLQAMgKo+gRNLysr3Wn99ybVFzeFUuREd/RnusQnMDdGqBk36IDwSoZ30inccYj1R+X4Xqxt
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 10:17:55.4526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3db2f79-f732-4b92-f045-08df3f13e307
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9645

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

Since commit abed42f9cd80 ("net/mlx5e: Conditionally create async
ICOSQ"), the async ICOSQ is only created when an XDP program is attached
or priv->ktls_rx_was_enabled is set. When TLS RX offload is enabled for
the first time, mlx5e_ktls_set_feature_rx() sets the flag and reopens
the channels so that they get the queue, but it ignores the return value
of mlx5e_safe_reopen_channels().

If the reopen fails, mlx5e_safe_switch_params() keeps the old channels,
which have no async ICOSQ, while NETIF_F_HW_TLS_RX is still reported as
enabled. The next offloaded RX connection then dereferences the NULL
c->async_icosq in post_rx_param_wqes(). Enabling the feature again does
not help, as the flag is already set and the reopen is skipped.

Propagate the error, clear the flag and destroy the accel TCP flow
tables again, so that the feature stays disabled and the next attempt
retries the reopen.

Fixes: abed42f9cd80 ("net/mlx5e: Conditionally create async ICOSQ")
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 337201f12895..3cc1213c2f68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -139,7 +139,11 @@ int mlx5e_ktls_set_feature_rx(struct net_device *netdev, bool enable)
 		err = mlx5e_accel_fs_tcp_create(priv->fs);
 		if (!err && !priv->ktls_rx_was_enabled) {
 			priv->ktls_rx_was_enabled = true;
-			mlx5e_safe_reopen_channels(priv);
+			err = mlx5e_safe_reopen_channels(priv);
+			if (err) {
+				priv->ktls_rx_was_enabled = false;
+				mlx5e_accel_fs_tcp_destroy(priv->fs);
+			}
 		}
 	} else {
 		mlx5e_accel_fs_tcp_destroy(priv->fs);

base-commit: b71c101bbb9814d163c00234d43c41f0a17907d4
-- 
2.44.0

