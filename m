Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724210;
	b=RUBOJ7Rn+zDSpPxaUysit4jq3LZ0pPHjq85IUAXtzTjOb+EMpklNajAU5OjvG7dCZVyU
	 DDisttlvH3E2f3NxdqkfqaaAAlqRT7xGbnJnrLQfepmdISqi0RGL8o1nvZ43Taj0Lr0/u
	 QSb/4M0DvK9wzYL9iett912afNVufhzPtRaTPTuo/ZKwa0EG9DYkT2sty66E0kO9IoInE
	 deIxmxG0eFR5o2J6AdE4t7dC/RVrrfheX2wbcnqiOPj9LrVC2C00QGMOQ0bn+KaWKUG9n
	 TB4r8r5m/UKLRHCOWUGcSeqfNW2+VIbVuSM692+J4Qp2xPRFjz1sAvC5IWg5aGHSWag==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724210;
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
	bh=ELfCpWTrvkd1iGqxiStXSVVrPcbQHLMgr2JQB9o+q2E=;
	b=nDl0unRivCexSnSkXe25iJbjnBZyp98RpY7Gn1zymY+qjR8RS6Ury9hxT1G9T1ryQEBc
	 eFhbkpgRRvSrrC08jnBDuKTVNQQaOPPY1gal9oMNLOh+H6OZ3onBjgODJM7tdr8nI928f
	 HOOhKde7dAFRQlOOM6tNDDoqT9D0/10x/dr3ke2cBnxchrTsx5VmfNRT+G8yopg+tpCr5
	 IdUlHUSHENZSxPZLpuMY9UoDe8lSE3F12heU/8cFm8SYl12NjILWYW7VddD5HY45ekeHv
	 K/c2vbxN3CPvtsUQE5fSa80XEyfUmYUPXyMTfdVqoMl3Js3Sec7+7ElUb6rtrFExfiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FSt7zdNW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.9
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012009.outbound.protection.outlook.com [40.107.200.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B961606EEA9;
	Tue,  3 Nov 2026 16:43:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B961606EEA9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=FSt7zdNW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YPpqTJndb77Ygh4asDo2f6n4yZTItaGGrsVym1jUWEW0IePaM6EfAyhUlTLQW4eT1up0pwHN2hFo2P7iwwcjpMJgEUt85WQu3nALPnsZuUI93iiN53On997ZaCXSYMOmdZ/6igDALqhLT/yFT5GO+dDxtXqQKR5x2XPZX345A82SYVAx5GE76VJN4yCYYe4BPGYVgibkKGHnIAlrJwb+7fXhJHRw+h3dpWzgr/9cVb3vH/fz2E9GJBr/FIquQ8PEHkKDHFb2a7DGqqrRBE0J+uGM9z7ke6JNsKspnqPwCd7omCiPASYHy5FP9H7z9PjPPCJTzLIDvqUClpFKv+r+/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ELfCpWTrvkd1iGqxiStXSVVrPcbQHLMgr2JQB9o+q2E=;
 b=uXXXnUmYvClh/JOF8D2rv89kwAEKdfeB27Wraz8RfA0Mida8l3VEcLxKXnpYn/jvWKzjm/FdHsTC1vlzX4VuqZe4CZmgZj6AiYwk1Zagx4yhmSWh96LgpG8R2w+9OdZq3QPQJ7oSKjJ+jqHvnmIEdbri5DcAjGk5qr4AfUM5onjkDDYp0OHMlhLofXuJXXAGBotd5hLdIvTc50EPWLlmXUGRb+o5yxsWiEMNBNQqTfQ8gCRNNCIFZ+KjwS2V1UJs6SvkNl7hRFTaakmvmqIiZPj2y8WskjklW8QkgQ2tRfdY9+5tkBYk84Gl9+zgPdR+Ox7OuDd/ESrNSSnLQvKcYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ELfCpWTrvkd1iGqxiStXSVVrPcbQHLMgr2JQB9o+q2E=;
 b=FSt7zdNWr/3QuW9R/csGSvo+iX7KiyqCrhB185SyOyBB4SDP8JAmm2ulBawfp93FzqKDB4RmyvmKiiewcI+8uWDnmY/1iuUQP0FM3DP5X4qbILPV2B7F0vD6yHG0rBeDv+qmLY/thPfrF/JKi3RK2oqdWMq5xX8lP4sU0cjvCdZZe2xxHEyQvLFmeMs1YwYSmCD4USTRc6/78+QXxPPTtCGa+Vv/FWJG0RVutP1sUfHHXK+CCoWSAgVHsQDfCQK1oYW06SHGHgLgFGFZx1LW0TzETNcX+FqkfWUkkz8T/vmc+/2UTlY8CqFkwsHloT4YBBwEBppFmC37F3yViucwQw==
Received: from SJ0PR03CA0089.namprd03.prod.outlook.com (2603:10b6:a03:331::34)
 by PH8PR12MB7231.namprd12.prod.outlook.com (2603:10b6:510:225::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:41:21 +0000
Received: from SJ1PEPF000037AC.namprd03.prod.outlook.com
 (2603:10b6:a03:331:cafe::4d) by SJ0PR03CA0089.outlook.office365.com
 (2603:10b6:a03:331::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Tue, 3
 Nov 2026 16:41:21 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000037AC.mail.protection.outlook.com (10.167.244.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:41:21 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:54 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:40:54 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:40:50 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 07/23] RDMA/mlx5: Derive mlx5_ib_adversarial_mode global from mlx5_core adversarial API
Date: Tue, 3 Nov 2026 18:39:33 +0200
Message-ID: <20261103163949.1554-8-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037AC:EE_|PH8PR12MB7231:EE_
X-MS-Office365-Filtering-Correlation-Id: cb56eda1-9849-4b4d-1db4-08df39c94a88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|36860700016|82310400026|11063799006|261022105027099003|56012099006|261009223027099003|261102123227099003|261028144727099003|261021121427099003|261022075727099003|261026121527099003|261102130727099003|261026140227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YFHCqYm6HIv+JAHMX3H60hFOwxJX6VejB80c7TVWsu+Ys4IJtyHdPPWEx2nJtACUA1PIlHgoDgbPElk1dOuZkVG+wY/RZM+XYqCa8ojCm14F5jH2WwwTNkViXyRhePwK3DDfLIt/n8YKW6LUgTc8e3L9mlDuntEBX5WnQpqCePnNA6w6eWuzzvxsFT/eu/1nfKTGOVc/bAlYvw9cUu6vwJs0wkdwH01ehuYuCcY4JXJYqeoLf00xfSU8Hf6JOoqiXsLyCrXQauaXttbBO/RsmTAHw4P0ARlbYfkI3W2xOsanmw/VAF9MdJeENyIBp0dDuNeH+OroAaPrY49PiFXyQXY04g5GPW/0zW7KGeTO718SBMLmzmOM5M34KgXpksX4IWVZ3XDJEQXZEKVBEgaxaJ1ayCzJ4Dr6q9BIbeFKhdS546YeYp3pZFQw0XaxrAR57LJ6jFkVq8bLI8btKiVeRu1AhEEkDP1uz9yoDQIDvn6Iy0mftraPqrNswBv9eLlNI5L5y49+YIJ+N8FwysHT2HGydjolEyaAsDVFFYMrLnC8nbrc6OvhBheJO60bHSVQP32m4A6FVZp9Ua18iZj/ErVZUN1c4XqHyotnGjY5gpvCy6Wyy4NRMouA3aq/y9TZnO4ExcyrUQETZS289OXeZ7a5GK7/TlJORkXRbdiRfZ/bV9HjYeJvmOAox79jfOSBjQM1lOLVV3RXPOzeGDtM9Q==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(36860700016)(82310400026)(11063799006)(261022105027099003)(56012099006)(261009223027099003)(261102123227099003)(261028144727099003)(261021121427099003)(261022075727099003)(261026121527099003)(261102130727099003)(261026140227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	e0lM+tOebGDIlYXOxDgIl2wQfgJpbWYkGIXgeLF7PiVdytLyXrQJxOdHGPkn3t58+5IsFV8g6J0FtWg+HHSgYJKBj3jjGttwi7kPaB4LLCWGimGXcfcyNezIwzFG7zuhzxvwmROHd2RG8GpqH9r2HsDNDQB9Lg3rNoH/VCiAucNpm0AN960cSHRtqpwwW/2t9++aY7sEH5T/T3YzxpZMxao5xJNpEZmv72YmH+C2L4mMQfpchBTDSJ1neKeWtfeFXC8waus5BotA3yf5dn3xWLzY/6Qr9v+1Jh/k2MXMjMkV3WkfhjBa/o+rC/FQJCWTOGQPCT6hBxWOD46bK+/od6DmWc9arooXYu3kLbDaBS5KdOK4n9NoaAKuGobzOru3yHctUvc8Sl0+y3RpqWgtcLTe+zx4uIcODldfTx09YpdV49RoqBApF092f/oiNegK
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:41:21.1231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb56eda1-9849-4b4d-1db4-08df39c94a88
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7231

Use the mlx5_core mlx5_is_adversarial() exported API to set a
module-level static bool mlx5_ib_adversarial_mode at init time,
instead of a per-device bit field. This avoids propagating the flag
through every mlx5_ib_dev pointer and makes the module-wide policy
clear at the call sites.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c    | 3 +++
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 65455aedd559..f4f2ad80e76c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -76,6 +76,7 @@ enum {
 	MLX5_ATOMIC_SIZE_QP_8BYTES = 1 << 3,
 };
 
+bool mlx5_ib_adversarial_mode;
 static struct workqueue_struct *mlx5_ib_event_wq;
 static LIST_HEAD(mlx5_ib_unaffiliated_port_list);
 static LIST_HEAD(mlx5_ib_dev_list);
@@ -5431,6 +5432,8 @@ static int __init mlx5_ib_init(void)
 		return -ENOMEM;
 	}
 
+	mlx5_ib_adversarial_mode = mlx5_is_adversarial();
+
 	ret = mlx5_ib_qp_event_init();
 	if (ret)
 		goto qp_event_err;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 4a6ee14ffd7d..0f81b8aa487e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1582,6 +1582,7 @@ static inline int get_uars_per_sys_page(struct mlx5_ib_dev *dev, bool lib_suppor
 }
 
 extern void *xlt_emergency_page;
+extern bool mlx5_ib_adversarial_mode;
 
 int bfregn_to_uar_index(struct mlx5_ib_dev *dev,
 			struct mlx5_bfreg_info *bfregi, u32 bfregn,
-- 
2.18.1

