Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795369190;
	b=lpvUualn38ejnnaDXpvQyM3sZItn6nFajnziLaLiDQjbyMnmSJCQCgQTx2RbGvwBEMOR
	 EhKiNgQLB+EXbjoWGzDbiW+brXPU4m8QZApcY6VXNpqPZ9b6hrchh2ogZ7xooR76OBs5W
	 l7XHDVfLZ8dzSq3mvtpau2HP975I0CNRAs92CS3i466e+76vaNF7XSiMvMj4iWbHKMFRk
	 Mbs753y4hDT4iWDkfEWl5PFcVfFu76fEh11iFSWxyO/vS+ZQYdyLhHk/rYmZZj3Wc7bpE
	 dH4Rzrxk3wQHkw+wjbrtj2ziMI2V4uaekwKWJsZIQibFaKWuivjN+CWXb+FmL4X3+Gw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795369190;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-ID:References:In-Reply-To:To:CC:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
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
	bh=htoGGxJ7b+eKlV0vqhuVveOORSfAQ/QSZELK0DttkKA=;
	b=5VPK18reyiwYS8uVkJFGBqpbvtpUbNXZ2yThmk9vR6Az8aHa8pq7DXOhw4CbWpxebHZV
	 UlGgsDqLKd4fVvLLDyWKqsRM9Rscxqdw/g/DUwxtm+t0esqqIOtdkGcZOMvZso+I7gEnC
	 qQ4ITzWMY6msE195OBBbt2YMmgU2hLoySNGYTe6Wwn76CxX27LWp/3U2aAQSO9GhutfRy
	 WpN4K+ODxvgijVaITot3tOjRPIwHzNSaQXLzZn9BePXyqdXrw/bXm2SoIUzgDyWq4G2uq
	 XwZIerMwSqJ9+j631vvB1kqRd82iYj9XkxCFPbAmudv/uDuFriZq9SpMyZb+XeGr1Eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AV0a9iJU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.58
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010058.outbound.protection.outlook.com [52.101.201.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB74606A33B;
	Sun, 22 Nov 2026 17:39:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFB74606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=AV0a9iJU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v9Hn6tSm+HyGG32orGM4+ZocH+2/1GZu0dd1CQMvJFYGiRsOzYnhU/CoNVNtQx7i3QiNng/+tm02ZU0Dv3ojAZoQQW1zYTriA8AIp7K8Cj2zvi/wwqmJRG4qRGqjVZgf21bmyi6bRzqf5D5EbkPEQ+bpEx7CDLOYPUTsJSpmhv4E2eRV5hlafBS3mooadSyBux2XUXq47RHPWuIWAv8qQ0On1QYb0A2moAIBpkw8I9zN/wEt1x4GXCWqF2TcjL8Q2X68qXWCB345CYD75pc/d6PdA6WlqHGqMVzFqLrzswkK4daSydS6gQX9o06otVoBeLKnS8qbUMnIeHlW3tkFww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=htoGGxJ7b+eKlV0vqhuVveOORSfAQ/QSZELK0DttkKA=;
 b=ZfTRzz9fLdeaGMMwhnixA0E8cxJrj7dvRB1k8g0qSHbl/dklcL91t0Qhlu0BfxzrzqZBaW75IrZWS2eZQyPC/Pw9Ia0dv8G1G8VJf4QjjlxN6oqBBOVE7VUUu6L0fgwnv5jG9c/KF1usf8Q9/GwSxZyF+OvnbFu8ibcxKjUFAbVWDbKz6xPvCl1ILUsnv/N0pY4oRVMOuf5irel0f9yQdTHM/ZdlUYSQi6XAT2RAwgFYv/T+5x07x/BR899fGexNoOeHZqQZ8/lMUD2nDQHrFqJ9/q8H1IyfdJ49Uo8S3IscYUKcaJejj/H7XZ/RaExhaYVjrEEBSu252r/vC1Ruhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=htoGGxJ7b+eKlV0vqhuVveOORSfAQ/QSZELK0DttkKA=;
 b=AV0a9iJUSZwrK/bUK56FcnkCAQsZFAWfM1YKYPvCKjinA9HjLzzf2fzKJfyNw5B9yjArYB9U4VjPsvwwjF/RclVJjRmZAokcrjchaqmtckY4cJQ1oQQLfI5GNz0u5j94qfxxjpA1HCZpF0aEqdOdWhsCXi2D3JigrNA6aX35p/FtDFBCeGECwfVoFEUoTU8i21eDQYrGRLNcBBzBeV680DTBxO/DgXH6Kb/jhXIB/njAVKmcINcmFBXFboP8t7HT4mCStgUCh9v/6j2BoA4CSizLzreP9eFCZBgyfhn/LbUGuTe/Yfrbfj3RBQid3PkxX/qKs9wRLfQTFZUQoDYhcA==
Received: from SJ0PR05CA0092.namprd05.prod.outlook.com (2603:10b6:a03:334::7)
 by SN7PR12MB7833.namprd12.prod.outlook.com (2603:10b6:806:344::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 22 Nov
 2026 17:39:45 +0000
Received: from MW1PEPF0001888E.namprd03.prod.outlook.com
 (2603:10b6:a03:334:cafe::7f) by SJ0PR05CA0092.outlook.office365.com
 (2603:10b6:a03:334::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.8 via Frontend Transport; Sun, 22
 Nov 2026 17:39:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MW1PEPF0001888E.mail.protection.outlook.com (10.167.249.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Sun, 22 Nov 2026 17:39:45 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 09:39:34 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sun, 22 Nov 2026 09:39:33 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sun, 22 Nov 2026 09:39:31 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sun, 22 Nov 2026 19:39:12 +0200
Subject: [PATCH rdma-next 4/9] RDMA/core: Derive enforce_security from the
 cache event
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261122-mlx5-port-events-probe-v1-4-0d54e3d53c61@nvidia.com>
References: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
In-Reply-To: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Maor
 Gottlieb" <maorg@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Maher Sanalla <msanalla@nvidia.com>, Patrisious
 Haddad <phaddad@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795369157; l=1866;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=7qrrG1z5WrELpupW7KC+Rd1O/Zig4MDZNQyTKOdXX/o=;
 b=JWQwMsEHDNuIS+IKQRR8imrGC8Y+7gYyhhK2QvzbHK6tDRiJxvwj+SCfczm4rokfkZ47u+BMA
 0y5/cL2a/+mBfPOXENajps3QrI8HC7JbcT9JW5wIqos/7/Gqy3QKBFH
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF0001888E:EE_|SN7PR12MB7833:EE_
X-MS-Office365-Filtering-Correlation-Id: b01da6da-7a1f-418f-e21f-08df48bf992b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|36860700016|82310400026|376014|261009223027099003|18002099003|22082099003|261009221227099003|11063799006|261102123227099003|261026121527099003|261102130727099003|261022075727099003|261021121427099003|261021123027099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	eLzTyJ8FpkwfrMkuy6bRwn4IFcY6+XCFAXhsi2m5Uby3boOcnYAJhYG2aEGkkDaWJY7hi2kp2airwedmIsASevOL+Ste2jQptoBqjQWKIkpQTtweRuWDAd4LeLEUJLRP8k9ar7z0T0zUz4zO4qY+E4fHYJyZTZMPki37FuNVK1HzYgeRB/jxfq2JOqbnHao/qLfYI4019DGPdOfDomV3BCjIANGN5pSd6HBePnTLK/hazmylRendqmojmfaSz4J1vgNm60SnOFNdoRslpBoLGmM+Z/QAbJ5BOuzl/wheNOtP4Rvaas8VROqHTX3WJK8Vk3JxAm8iVvUWUpGG0SZ8of7/9tHAa0WT5Xs5LSDlV19/OWUYF2tgvNQxZ09e7lUB1A8Z9FmmscgIEga5R5vd4n3+SKnFKmsAlKyYqOjHjwUzYD4GA3dHyaRH/vEqJHS1Q/0BZI84Ba8OgyycpN/3rcltiTvjdx+4R6PCoHsx9fRufxRzCGrTNU50SL4dK0BbdOvnrhbGwGvJ8mjLPiHgIWwbnx0USfWPJ+FTXSWUzIdCHkseCyj/NfDYJ56/eXBsZvegO8HTuwU3rgHsoGi7Cbg//w1oIuqXvYKE1HK9ns79U8JZDSA08/1cQH0yU6iGHK4KR5Rcl4Ny5e7XpR8bs+avjbj4kDCnsDlfG2kZq/D/v25sAUfc7ZC/o2atJaFkj7FQzzIG6DnzHkYZAUApqw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(36860700016)(82310400026)(376014)(261009223027099003)(18002099003)(22082099003)(261009221227099003)(11063799006)(261102123227099003)(261026121527099003)(261102130727099003)(261022075727099003)(261021121427099003)(261021123027099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AYWY8XpaMo6kzBVkP2hujxUvslw3vLIXOmZBvwsaR3KEqZQcOZz77fmd96sOIOTbfCkQqWiEs2Jfd/5k8U6ryEguEOWRL3mA7jGeALcYAvy4rcvFTTC8iQm0RmDASWWIdiZkKfzuQ8YQFGJ50Fp79WTxg0yuJlVhcIdReOjJxMxj5q/ActGV4z1TeEH7V6U29qhhC8sVZABC9f+GOg2EsozDozvuwryGTo2T0KHWtlcsHOsFDGdZBKhCdty8R4/8g7IMDjMD1iA8EB7rAxMMeIduLGrSvz01KZIjOx26rrWerLhAk7QP7fZggJmTYkaMYEmoJc9OjTFNxKm96MngOx0NigTNFFWxDjRHbzGzVIdxskTTkewTJMe7qCrXITFHYuxc+vQBqbaE1Dp13hKWgPswawVwEwuGF2naJWAOHHa7/zOIiM3FPhEbYwl0Oxf9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 17:39:45.4260
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b01da6da-7a1f-418f-e21f-08df48bf992b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF0001888E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7833

ib_dispatch_event() marks the cache update work of P_Key and GID
changes with enforce_security, which ib_cache_event_task() then passes
to ib_cache_update(). The work item carries the event itself, so derive
the flag from it in ib_cache_event_task() and drop it from struct
ib_update_work.

No functional change.

Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/core/cache.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 647a547e2d7fb20721ed5fecdccd723891ba2ef2..c338c2e52d8bd041bdc194ca574b7c35cc9b6d0d 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -52,7 +52,6 @@ struct ib_pkey_cache {
 struct ib_update_work {
 	struct work_struct work;
 	struct ib_event event;
-	bool enforce_security;
 };
 
 union ib_gid zgid;
@@ -1536,7 +1535,8 @@ static void ib_cache_event_task(struct work_struct *_work)
 			      work->event.event == IB_EVENT_GID_CHANGE ||
 			      work->event.event == IB_EVENT_CLIENT_REREGISTER,
 			      work->event.event == IB_EVENT_PKEY_CHANGE,
-			      work->enforce_security);
+			      work->event.event == IB_EVENT_PKEY_CHANGE ||
+			      work->event.event == IB_EVENT_GID_CHANGE);
 
 	/* GID event is notified already for individual GID entries by
 	 * dispatch_gid_change_event(). Hence, notifiy for rest of the
@@ -1589,10 +1589,6 @@ void ib_dispatch_event(const struct ib_event *event)
 		INIT_WORK(&work->work, ib_generic_event_task);
 
 	work->event = *event;
-	if (event->event == IB_EVENT_PKEY_CHANGE ||
-	    event->event == IB_EVENT_GID_CHANGE)
-		work->enforce_security = true;
-
 	queue_work(ib_wq, &work->work);
 }
 EXPORT_SYMBOL(ib_dispatch_event);

-- 
2.49.0

