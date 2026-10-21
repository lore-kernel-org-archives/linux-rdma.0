Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.56
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792569046;
	b=jvH0aja9L9y6112dJcn579XT7C+UC8dSofx7Xwzcx7p3M9PWomTxncnLXjWp7M1YMv/U
	 RZT5YEC8HT5fkWsXc5Nxr/w2fYvTPzM+JRgHVFFa/NjNOt/f5zOzmxWSUIwsouU/vod+I
	 H885GVPDY6OI80axw8elXm6VrCXiJem4F8ZmIyRjdEFNqsSRy1RcLlOuQFOExgtR1XpEx
	 3r0hM3iPwfbtUtqNJIK5NgtjViSTqWZqXLYro9EsxbkR07Yd8kJgB0YZprg+y1TfXmH56
	 qxNFAdLpkyq8uYoWQNC7v5FuCihJI4EXFXHzIUjcpymQYLRDyi23qqgl1U9/sJOOC7Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792569046;
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
	bh=F8qyGQoLqVA9tjeJuedhEzRo9nRpNubeKggGN8objDw=;
	b=2+qvuo+sc/rs06W4KMew8G3QLhbjQDbm01O5N1atBsT/dKSXiXOI/1DO+LFIB+qAAMO8
	 roIqi09O/vMWlBdanudqqR+MLz0BEN+DkmF2IOylHPwtB25QvjcQjBLA3Q3zLcf/39RSa
	 qDmHjB/5dCFfiUfFc/nOn3fxx/I9udQfPenq+sfLFSUgeq2Je304NPNt2SgyX9JsvH7At
	 cNL9aV2Iv/yi/K7xQbGVQK9rRB0IeJkv0tokN98LzTu1rtssd1prn1z7MCpBXlQMx/qE0
	 Xn9UpUH/I+VzSYLoqoSfy1UaZuz7FmsouhGj3dGLmu2Y7aTtvweqfDbqohIXq+Z8SgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lZCairMI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.56
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012056.outbound.protection.outlook.com [52.101.53.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8744C606A31A;
	Wed, 21 Oct 2026 07:50:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8744C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=lZCairMI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jc5yTZVEksjjdc74WZvM2RR3Tpx4IGrGkPcBHzr4WE3uuXia4vwCdPKjAlY0pPA8cxXWrlXaxgC7/FZEr3nN0EO/tRHrfkQwxPfoaPNRINIMs/esGL7YVLRORThPibq5kompKV13PqDUBxveicKpl+OVw7cbTxyTIpKUg3frvvHej1yDNuJwHcRX1zMF2+iv15cXXrLYjpw593lotVPX7S5w7jGGC8bQg/MJN19Yosqj12RSoeRUPfxdGbOUNxzwO1jgq2uxEfBGx9S14f8RFy/k6vbrQuh95PzVktY7Nx/IsTLdbzwW5pcIR7u7ECLeAHXT6qrsI2GZL2tiWiRmzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8qyGQoLqVA9tjeJuedhEzRo9nRpNubeKggGN8objDw=;
 b=WzhQcZMYS41Ty/y7GcvK7p6FTBduXpnPCNAGCmK0u6mWvZyORMrNz/6P99vnVgAZUYs2whFKGi3Gt5oMWBrRcikkU1S8Zn/PBT45GgCU37goOPLVIUT+pUfw/VqiPpWp0DTFlvlH1QoPLa+/gtUkkICqBeXkGR4mf3doTO+bx9GurhOuY9Zr0rue2+DDTbYVxyloWnzhBsJhw8eKCUQ6IqcLxgPQIEAFx3Wcf+UVUqf1JpdPBI18m4tHHQTlJe5WyNVYZ7DYLG4uH6qoSb/JULiDKoX1WRtqkuc1c/THkvd4PhHolAZebPkfywsva/XsSJCtV+DoojUjy5Hg/40ocA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8qyGQoLqVA9tjeJuedhEzRo9nRpNubeKggGN8objDw=;
 b=lZCairMIUZGb4RM4VQOqUixA35xSbwAMGn/6wshQIS0Jowd4IVOzgpQDPbOBlLyQDQMKnFAlmkqSlkZ6bYyRm6jM9EqHLwtSUAgfWfw6PnRPp6T6b9FyOmpUFDgqbvR9RWp6EDpUxGcMbG25q9S4yknrf/42GaIXu/q5cw+HGPGq56yKGAXOfwLi5AlwfSbdbfYH7CPpqDIJ8x5RIFuGOIww1Tq0qFEdhy7zLeNyf5WUeHBryBihHSIkLJvnxRAihM+wtoJHu3l41tjAgQDMyhcdtwYF/6Zas98EXDRZS2sabiO5o0zcQVXgX1hu234t7OQ21HT1ATBrtmkyi4kxkQ==
Received: from CYZPR14CA0028.namprd14.prod.outlook.com (2603:10b6:930:a0::7)
 by LV2PR12MB5774.namprd12.prod.outlook.com (2603:10b6:408:17a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 07:50:41 +0000
Received: from CY7PEPF000000F0.namprd05.prod.outlook.com
 (2603:10b6:930:a0:cafe::56) by CYZPR14CA0028.outlook.office365.com
 (2603:10b6:930:a0::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Wed,
 21 Oct 2026 07:50:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY7PEPF000000F0.mail.protection.outlook.com (10.167.247.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 07:50:41 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 21 Oct
 2026 00:50:25 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 21 Oct
 2026 00:50:24 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 21
 Oct 2026 00:50:19 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexandre Cassen <acassen@corp.free.fr>, Alex Vesker <valex@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Itamar
 Gozlan" <igozlan@nvidia.com>, Kees Cook <kees@kernel.org>, Kees Cook
	<kees+treewide@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Prathamesh Deshpande
	<prathameshdeshpande7@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>, "Tariq
 Toukan" <tariqt@nvidia.com>, William Theesfeld <william@theesfeld.net>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [PATCH net 2/3] net/mlx5: HWS, Fix heap buffer overflow in insert header action
Date: Wed, 21 Oct 2026 10:49:48 +0300
Message-ID: <20261021074949.3471704-3-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261021074949.3471704-1-tariqt@nvidia.com>
References: <20261021074949.3471704-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY7PEPF000000F0:EE_|LV2PR12MB5774:EE_
X-MS-Office365-Filtering-Correlation-Id: b0b91ef0-c99a-4eed-d6aa-08df2f48010e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700016|23010399003|56012099006|11063799006|261009223027099003|10067099003|22082099003|18002099003|41080700001;
X-Microsoft-Antispam-Message-Info:
	ccO+WlPaH9NY7oZEnjiLHDFghJiA0HLX5DeOZFd+spHBTYOhVj3XDzoOFtC56AstGe2lzLOboZVqnSuP3tHibkC7TTo6QzOuAUZq/y46uX9FPXoVbqFjdOh39HKUv/5tz2Dq4NobICVgZkCB2L5Bli1hSPHISxccEK86bQSQnICVN6xDC4gwIPNvzvCVoW2jqxfXNytThkBkWJKUKJVNhAiF9VFfMC3HZuX9iLg/5Qtd/pgvef/BHlCXersuX79EzsYEeX0+LjkaViF6fRmpPzJY23zoG4NLOsB0ltZKFhVo9aSAgcxToNtGZTbEvNOtarmXsUObrgabeyN95UgeZSsExaSURekU1FjWsEHfLIrCGuNVlCuSZAzTIxnLwXjIJU+imNCH6/f0GOhHNvczg3EyalXI2RnXxzPW/MixO/VxwNBq02CnGw7tiUakydi9dbP1gQ+SJxrHzdMfJ+X3FOjyVCfmW0KzvnqopM8oeFkw12kgeDJEhmRLMMX1FKrAZT50is2MoPqUpFmkSeDL1xD7eB2hB8/nlAw+VxtutvYPX0xLAuPOWiHc+hXzFcdQeyyEvUtUjgVUkhjSsPNa+NVSDeXnu9VXJab706caI45x81xF7tsUpZbXJr+EUfbvUp4GOZnk/DKcPAFIZ6mQjC15YMPxpoZr4ij3Et1Og9xn0qQnKkJ7b2SPF9LvZqTYTUXiyW7qnK3iIR3W3IUu+qdHR8TT4tQX9r22j+n1e074MT/NBcoK4Pu3pAfAmhSynCVy6fcMp2NZuxu5lckc+w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700016)(23010399003)(56012099006)(11063799006)(261009223027099003)(10067099003)(22082099003)(18002099003)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	f6s9W+Z26WbI9LhNKRvrDNOKONI/qLrcMIDLdEpBR/Rga/+QWvS3lS+meNYSbPBEsvsKxGEFpx9O5ybp5ym9+96nR0Mzv/Rhsaj65f6LXNTad6Wd4TBedQ39a/LDAJo2km3qfVmaIym4DT+eC5ahfESxejyqnl5+Y2XJFUj0kEXSRhEtqDUYtxCwQAh67RA28s+oVBKlDQDM16z59qHpi2QK8YruCGihzMQmII73Uc8CQmp8CB8xPHrYTGWD1G+3lFl2FMExN6mstdjJIwKz8oOHJIMuWyZsVI8nzEf6//Ab6FjaEPCn+XZLRn6DHIZvZ4bIGZ190X1wN0nhstNYUPWtzJJearGY6ivZYybpCOqwtIlncuihilTDGJ9OSOi4dUFolwXjZDc3xKUZQcN+H7Cy45FM2RRYMmw1oAxcmtnTyrqGXvy7U5iOiazI82+M
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 07:50:41.0463
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b91ef0-c99a-4eed-d6aa-08df2f48010e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY7PEPF000000F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5774

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

hws_action_create_generic() allocates only a single action struct,
but the loop writes to action[i] for each of the num_of_hdrs entries.
When num_of_hdrs > 1 this overflows the allocated buffer.

Use hws_action_create_generic_bulk() to allocate the right number
of actions.

Fixes: 504e536d9010 ("net/mlx5: HWS, added actions handling")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Itamar Gozlan <igozlan@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/steering/hws/action.c  | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
index 23e86f292022..9caaa34074db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/action.c
@@ -1473,7 +1473,12 @@ mlx5hws_action_create_insert_header(struct mlx5hws_context *ctx,
 	int ret;
 	int i;
 
-	action = hws_action_create_generic(ctx, flags, MLX5HWS_ACTION_TYP_INSERT_HEADER);
+	if (!num_of_hdrs)
+		return NULL;
+
+	action = hws_action_create_generic_bulk(ctx, flags,
+						MLX5HWS_ACTION_TYP_INSERT_HEADER,
+						num_of_hdrs);
 	if (!action)
 		return NULL;
 
-- 
2.44.0

