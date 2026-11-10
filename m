Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794335970;
	b=C0OkGgzIff5bboghtwDp6z5k1EQPP7gIs6sRBJ5jmNwKWwRl5t90hpt/1PU/f7wBhEhz
	 muFNSToUEXT3xWc43vI12tRjEtbYPL6dnxG9Z4pqk4+w1xE/OQB9Fbn62wQycWz/zIubJ
	 x5hwO08IN4gmkcfI4iXBXNDtcVVbaJFOF2b3PoGU2T4emNt4SE8iEcScPPxNphMmUeo7n
	 bVIDexph3KV+Np4dy2wsn9sCF+8oyYDlyi6cgCcuwey87iugMlB9/CsgCbZ6bebX88YEJ
	 KY279czg0rbFgTj+Acj4rb3IogEZxSu7uVw/LlwWIZGIl2LTyWOmGxj/F0e8mJKJR+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794335970;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=DksALdhP3vutVP27JTVSlzsqgQGP/+DlwEno3+HFUCs=;
	b=C/hK0Wu8Jz9Eh6nWLQVO3u0UCxicOepoyseBqpn1UM6+OyUAT6FN89mJdKirtggeBm8s
	 9+o+pGi8CiG2DOKlpL8D/kBF4VLFr/sEaig2kb814jvkLdTQv4KxkkXUnK9J8SF5xlPQu
	 kSVPKDTg7woJtMlEWSi4PBGiHlEpOWgx0xAM3JsrAoa1KG/aObgqjvWB+4x7apkPiwnfz
	 S+RxLTI18v1IA8qBQCcx4xBTs7X0IfCu+042a+Oxy/x+isvSoBtJfn4XgtqPKBFtXN+B5
	 eRDMMlOf8TQrKTscxhMVRsTbwx5aluNa+4pj2jjYo0lL6UBaWXNmcSYEkc5gXXhIzmA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OC6QxUio;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.9
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010009.outbound.protection.outlook.com [52.101.201.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74F6606A336;
	Tue, 10 Nov 2026 18:39:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E74F6606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OC6QxUio
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X2I3bSyenoAz+yugCdpy6zkvhePJAcINwl4168icb9FP7U8fiGe/bnR4RQviK1Er51Qna0qGbS0MvbbYN0lHErMXl1SYtEK7QuaedhscviAKUDB3MSbQjLDxNHKzr3CjElRG/pJWfQebyw/9D+lLopy1eUPDkZGeDiDqi0afBIZ1DpUnBqpagVQELxrU6ymRS3wnGfipCTaT9YvuhbrA9n42tlHOduuNbA40jnaO/j14vOBtfohTtV3KArxkWFRRvxnbgkvHwHZovH52R2tKcIDJqx8DxD6BZuRA0yZrsW07hO5XOEoKkzh05l4+ROwDTZRAtG8p0SQvRv0J5OKmuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DksALdhP3vutVP27JTVSlzsqgQGP/+DlwEno3+HFUCs=;
 b=Mfk2G/LLGf6iJ6IXdetDkunvNfHnGKcLgfd3hXcnvTOlQCQ7PEIwN+nMoqXG69DcOPleSbinHgEXg/DdG2oAfaQ+hL44UiHnALXXnAaDMPpfzXI3Reh/KTMhPU6s6s66/smQHP6H1AvXjcpUeHR0ecJhr0bqDRN9YhcpbX8sYDikvG+dI87f/KJXc7nUTM+DEeGJRox7vHfmXVfutYIDXXHvE3osOC1aYNhBZXUeB85si+BlE2y+hKMw1TUI+X1KxF+B79i124zSRb8JM8IsXs72RClfIlE2EOUJJ99N+22R75lCORaXwBuJb6JNkwt5jhhRQPl+/u8oq1tS5T5EaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DksALdhP3vutVP27JTVSlzsqgQGP/+DlwEno3+HFUCs=;
 b=OC6QxUioifdTtF5GA//TYmwa97D/NrqInsAMand94fcnpQUTbnLHRtVdgD7KhRVQBC8iGh/mIwY1EzIcPp8rvJKQ4Dq6UDwfAAi9LJVcz4OycFc1RkpEo79+YS/5SmttR1jKru7sC7CzGpKxCKCGu5/t+u61ouyy+VHlin0O2Vy9ygOnV2Ph8vmd1swhaMTEVaR84pRSQeAYYsu9me2vURJvVlthzzvn03L8X5MJoA1hOsIOiphx/grEOB/lZ1yfJv1ZDl4B/Xl2RJN3/h99xXbPTTmA75n3eyFtyHN0z/M+lf4/2XnVQR/EQxpe26oA9ZFHnZg+m+YIXpnUuf3xEQ==
Received: from PH8P222CA0025.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:2d7::16)
 by MW4PR12MB7285.namprd12.prod.outlook.com (2603:10b6:303:22e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 18:39:25 +0000
Received: from PH2PEPF00048915.namprd05.prod.outlook.com
 (2603:10b6:510:2d7:cafe::51) by PH8P222CA0025.outlook.office365.com
 (2603:10b6:510:2d7::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Tue, 10
 Nov 2026 18:39:25 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 PH2PEPF00048915.mail.protection.outlook.com (10.167.243.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Tue, 10 Nov 2026 18:39:24 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:03 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 10 Nov
 2026 10:39:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 10
 Nov 2026 10:38:55 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Bobby Eshleman <bobbyeshleman@meta.com>, Carolina Jubran
	<cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, David Wei <dw@davidwei.uk>, Dragos Tatulea
	<dtatulea@nvidia.com>, Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang
	<kaifengw@google.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
	<almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>, "Stanislav
 Fomichev" <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>,
	"Tariq Toukan" <tariqt@nvidia.com>, William Tu <witu@nvidia.com>
Subject: [PATCH net-next V2 02/13] net/mlx5: Detach auxiliary devices on attach failure during load
Date: Tue, 10 Nov 2026 20:38:15 +0200
Message-ID: <20261110183826.2927274-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261110183826.2927274-1-tariqt@nvidia.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: PH2PEPF00048915:EE_|MW4PR12MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: 102c6bf4-58f9-46e5-c653-08df3f59f1ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|82310400026|36860700016|11063799006|56012099006|261021121427099003|261026121527099003|261022105027099003|261026140227099003|261022075727099003|261102123227099003|261028144727099003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eMH6Rh2vK9Vk5qngelLRB+SB9fiL3JlghEpotsk7MGmLDzllLQ2U+EGZVQl0JlOqV6E44QCvp5+Q/ifs0LG2hB2hCQ0IvSWpJ1n2nPtw8A0VTPtdqcHpkqFxvBYd8mGNig7OlViQ4N5HPjr6iLFRN7roMA66p4tIOs6FzkWKQtGu2snCvrbvbFy4vD9Xhhv4D/gUA73t0C7NpPqweXK3XofeZkEc1+TSqOHpanuxt40NGcsEVe4yOeuxHe3GLqgJ8MmymZ7xM6fGLer+i+HAJeHU9RSu56ODGApaC9SbxkMISNeeYkuI+xjtCtcgSUSHGGPao+PMZNEfUqr2wQyYpi4HzUluQ/G5ulXFqziBLrOvqTY1WFTnNZm60OZY3IlMpxroR4DCK6LPqtz1ux8E+/8QwpN37lh4Y49FTdOvDIwDHbFm8SznWGiNzQPnuyEr8y4jUfVkBRx/PpZUTiYclQgPzY07TcPuUZg+99nTpwyNJr/xQR/pnGU2xS3UZ1xgoinfLi8t1yQQGlOYnos0OqOuOunoOOM+cB0OGhJOOV3wNboGRxjpA0iveY0h6lucYwmLIbNX4YoMyhzXo8P0NwdHpVPX0oq2NOKM/SVonEZWVEJs8NC0tcseFRSRz9GNU9WjGWACZtvi//zBW6pm/ScgKKPMGdO3EcJKuRhkEcuq/us24B+wPEIGgSjZW6wgXmxa4ImdRbjUrcD8dnCIDw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(82310400026)(36860700016)(11063799006)(56012099006)(261021121427099003)(261026121527099003)(261022105027099003)(261026140227099003)(261022075727099003)(261102123227099003)(261028144727099003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yFydH4S5H65DWQt8e5j84xAnevdvxIXIYIxbbhZvCLf8npOyzk/2LEgthwxHFQMzXTW8QFYblZW/IhnijLFDlmTemdGndXRSMTMGg0Qd/T94Kifu/zMrMbOk4GiBdTSjOHb9bXFAz0zfEAQhQJL+yYfyWp6BYI/PgRmjEUk+AO7tHDwk2+tlrQzD7LamfHk3uDQJDgqLzWqHkNlw2TUARgMO0pI/xqLOvJZMffuXkVmN61c2BAJ4ctR4aSBY50BYvF+3mPonnn2tzlpAx5ib3enQmUwr1SGJRRfdnJ0z/bcWbXlKqXLjtGY1MlMCeFRz0iODgcCJrMePKvIJiyPdjY7mibOxhxiYJuc0IDYJDuHYfwqEbms6cLGGoxb669Jkc/1HHczwPsQ3IPLJT7Gyndlm5Mf94tmZfKws3R5w1XXBZlphSYTQYwv+vw39vWTi
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 18:39:24.9177
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 102c6bf4-58f9-46e5-c653-08df3f59f1ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH2PEPF00048915.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7285

From: Dragos Tatulea <dtatulea@nvidia.com>

The device attach phase fails in mlx5_load_one_devl_locked() when
the first device fails to attach. The error path doesn't detach
the remaining devices that successfully attached.

Fix the above condition by properly calling detach on the error
path.

This issue was found during code inspection and was not reproduced.
Hence it doesn't deserve a Fixes tag.

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 1a45474ce03d..7e762f72b19e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1547,6 +1547,7 @@ int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery)
 	return 0;
 
 err_attach:
+	mlx5_detach_device(dev, true);
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
 err_load:
-- 
2.44.0

