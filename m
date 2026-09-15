Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011035.outbound.protection.outlook.com [40.107.208.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D3449E5F5;
	Tue, 15 Sep 2026 11:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789471205; cv=fail; b=XTn+jy3O+Y4fWspZvbkcsKLHmYniBuhFyfx7Xzp9JzpSaS/Y8YNvBHUXdrBdTax6f1nODcpptaxRYBpQdQIP9mCAgn0kA+mO/5HW8ApWdvdnYI9eHlzUSl0EKUqC+xV9h9rrzQ/Pd6+Ej/pD5NMzCWxeGjDuqcnunEcyTFrhqys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789471205; c=relaxed/simple;
	bh=mdqW8wSqTpbqrcgfzQh5DVf2w8/Yqp5w9VOPyawJ6bA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PJ7PB+e0XpXq45Q1QpiOTQN0yJ0zpMwktJsUVfB4dA0uMwmgkcbs09Wn0efc0gl7Ohnk/Fq++xdRXECu/xo87LztdxMI2SiNX1oDgWCg0fFWlwc20ERgRGTsPq0I3gP9yZrgfa4FC3++J5qZPEkVqRcI+ZAu9VA/1TiZK12okXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YVpECWi6; arc=fail smtp.client-ip=40.107.208.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YVpECWi6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xajNQ4IQ9iMYv41lyigwBHw1Z3/7Csq0/KOjN9beJMA9OPqWE8jdX3CYIXInp4/TC1DrWXqZfkltbAsFhCLPfwKbtWGcbu1wXUv/YZzT3mBKxIi/aYhRN2MsHIjG+loEURMn+HxReL7ugBhM4P3N5fnxuDlAAcEgbu6UjLAY/xFLZGj02RTn/QFb8GU0kW9yBrz5/TFWpYEWcOdLMZzSCSzJuzh+6/BuNM4Ma9EyEBKFrsQbyTcRBLuZv46Uqnat8VPn1Rq1oHuLTiNDGS3zrn4EtM8vXSD29cpO7Pw3JqIHd9kpXQP4FBwJUrNkp5vqs99meUZs2qo5pRZ4Z82CKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bZSx7DvrBwt/7v37s+xH3b78giZR2XId6c4QpjQ6ZSo=;
 b=Z9FbnHeaqUBMpgSjRAsH+r/Tjkj6SNKFccn+lw5yP/bugaecIeOrYPMHDc3iWORXxqq7CxrTnNYZxEfOFYLHb6kuCSl1fDmbNi/JAt7q1wag+XfkhKxLor/FL2apogHUU0DDBl8B/H/Xo1dJ5AdUBY4QEKNDlZxrz0o6FfvHygzIgzD3QbmmEzmvVrXANtDOoTY4hBv6LIjPW+scmAHRCAZPmBL0Evwu/4CY0UdcItKgsX9/carIwE+ZDPdMGBraR/S7Eb96Id/hkURbgrxJtYOLAoL98fFfpsWqG0rEi6MzKWcIxCQE5IWMgAIndMdm2gPykQajoi3yfzlxTV3l8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZSx7DvrBwt/7v37s+xH3b78giZR2XId6c4QpjQ6ZSo=;
 b=YVpECWi6SKhWMlHedj3+nmgZfveIwX+6sylaUDj/EPU7AbXgH0m/ltpDp76HnnAWOZVK/ZMZePeXvyVzXyHJvuQp7OsC4e12b3eZgPSSvPOPnEj0+Rq6Ykz8wvGJ/1gOcIA7A+6PqYATK5p8yqyzOi/vd3tYfcMLNiAi+Gc+6qS+bQA8hVSCd8isbWkIulFJtYS9Kp3omEC+sKYf2LQ7b8LH4h9v716bva44lN3kbRHKAaVan+25+HQwPyonoZN/FggpsKDj7s9bwfgTJPa2hYYAI0nIBRYjTVreXpXwOdtS3I9YIX5RWt6XKr+QJpDMUT/cNRadnsKGZ9Ec6mzQYQ==
Received: from DS7PR05CA0107.namprd05.prod.outlook.com (2603:10b6:8:56::25) by
 DM6PR12MB4060.namprd12.prod.outlook.com (2603:10b6:5:216::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.12; Tue, 15 Sep 2026 11:19:58 +0000
Received: from DS2PEPF000061C4.namprd02.prod.outlook.com
 (2603:10b6:8:56:cafe::80) by DS7PR05CA0107.outlook.office365.com
 (2603:10b6:8:56::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 11:19:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS2PEPF000061C4.mail.protection.outlook.com (10.167.23.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 11:19:58 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 04:19:45 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 15 Sep 2026 04:19:45 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Tue, 15 Sep 2026 04:19:41 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Erez Shitrit <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Yevgeny Kliteynik
	<kliteyn@nvidia.com>
Subject: [PATCH net-next 4/6] net/mlx5: HWS, Add timeout mechanism to draining send queues
Date: Tue, 15 Sep 2026 14:19:10 +0300
Message-ID: <20260915111912.3926585-5-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260915111912.3926585-1-tariqt@nvidia.com>
References: <20260915111912.3926585-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C4:EE_|DM6PR12MB4060:EE_
X-MS-Office365-Filtering-Correlation-Id: c91e07c2-6bf0-4e28-a24a-08df131b46f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|1800799024|82310400026|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PjAfv9nZpX3DIKcUH40/GWlbNzZd3Lc0UGMQBjqe4INGYluSCNQ2V7G4P4vWks+FHBR+aHxDd1w0pIW7zxdghL9yuZXlra09+JXNeyTgxNVD58ij+T4AiUxZ0+GeKLehXlEvGUSuPCf+l7TE4ZdJYGBPRdQrN5v9MdwQQSsJHXCG9nKYyHKuPwej+FPQk4iMIgul6v8y0U+kRypnL5ci3DXhpqU+gW3xCN/mGE8Oo4DGAZZ+/5DYo/H7lwl4KyF7gLhVbDTQpns7Omsz9U0yyOTo4AZaABVfpW0jOm88uMuQj7hq6OirA7hBQSeFT+Jg+ZCYL9nKCkTQyNztzIePrBduCedTyMAMN1kc2JquUuAxzkH7J9OhKIPg5MZYygf+0Zz61tCK3tZMeUU2qkvjZjEZVfn5r3EY40WEdbt4QO8aiND7d6U1uY+0e9+SaaKgcJr/fYChFk100jFIMTqveqgmKU3OWBu2tfPr/wE8GpgoghMmI7HfTjvtwNpmVl1zhyKBNXxtHJjIunw9A8yDU0YenXK/C6HbSCUOfpCpO9Z7hK+omxLAJxBl07up3t9hW9vcgYp7fdKqspG36xzfKdh7chYMX6pbcbZQRoeaCQA7sxdCt247dMTMBBMQ000iiOEEtUPhD8NEiVcKhb3ZUOq26Jq405sUWbOiZwyjIw5HaErjmh7J9GX8qiVxOv9JzwtxmSjgWAKRRDd14ZO9Jg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(1800799024)(82310400026)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fX0rUuVauLFtoLgEWCG64AUWOzBWH+Vybk4cc6WjGUnrbUPNiZuSm7IO3bTsZEPmGkq9R4477hSibwFU5ZKFlaMSstfYk5dUlp8kEc+rWctVs6U7YbCEKaKydXz2IuQmuOCMw7bQVUGtPBLoGxXgX4KOS8ZSqjlb61rbTkOVi5oQ3vpw/f+WgeXZhqum4vgDYhoz//pLaL+pLjXGlQkNse2ZvrkqRNIKTGVQKgbpDhZKFvB4nE/VELkVXyAL6GKbJ5lWyIjZ9SYmGFmp6Bufuij70/P0gCSOMSLN0jn3PN6fb8J8X8nTm5ZIzsPW4JihzXjtIM8JMBvhsKe3h1bom+fCJML0Kpwsx/94gPXRTlUIQCrxTQNc+be82KV7Us11H8ZXuBvekCOFtFPINErtanDns2i0iYjbpGC7AqoPBRjjgJTGD9bFtUGyqLzKFVik
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 11:19:58.3729
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c91e07c2-6bf0-4e28-a24a-08df131b46f1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4060

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

HWS has a timeout mechanism for usual polling for completion,
but it was missing such a mechanism for draining the send queues.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/steering/hws/bwc.c  |  4 +++-
 .../ethernet/mellanox/mlx5/core/steering/hws/send.c | 13 ++++++++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
index 3bcf412a08c4..14a2bb9167a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
@@ -460,7 +460,9 @@ int mlx5hws_bwc_queue_poll(struct mlx5hws_context *ctx,
 		got_comp = !!ret;
 
 		if (unlikely(!got_comp && time_after(jiffies, timeout))) {
-			mlx5hws_err(ctx, "BWC poll error: polling queue %d - TIMEOUT\n", queue_id);
+			mlx5hws_err(ctx,
+				    "BWC poll error: polling queue %d - TIMEOUT (%d sec)\n",
+				    queue_id, MLX5HWS_BWC_POLLING_TIMEOUT);
 			return -ETIMEDOUT;
 		}
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
index 49dee44d0bef..9ff109fc8230 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/send.c
@@ -1192,6 +1192,8 @@ int mlx5hws_send_queue_action(struct mlx5hws_context *ctx,
 			      u16 queue_id,
 			      u32 actions)
 {
+	unsigned long timeout = jiffies +
+				secs_to_jiffies(MLX5HWS_BWC_POLLING_TIMEOUT);
 	struct mlx5hws_send_ring_sq *send_sq;
 	struct mlx5hws_send_engine *queue;
 	bool wait_comp = false;
@@ -1213,9 +1215,18 @@ int mlx5hws_send_queue_action(struct mlx5hws_context *ctx,
 			mlx5hws_send_engine_flush_queue(queue);
 
 		/* Poll queue until empty */
-		while (wait_comp && !mlx5hws_send_engine_empty(queue))
+		while (wait_comp && !mlx5hws_send_engine_empty(queue)) {
 			hws_send_engine_poll_cq(queue, NULL, &polled, 0);
 
+			if (unlikely(time_after(jiffies, timeout))) {
+				mlx5hws_err(ctx,
+					    "Error draining send queue %d - TIMEOUT (%d sec)\n",
+					    queue_id,
+					    MLX5HWS_BWC_POLLING_TIMEOUT);
+				return -ETIMEDOUT;
+			}
+		}
+
 		break;
 	default:
 		return -EINVAL;
-- 
2.44.0

