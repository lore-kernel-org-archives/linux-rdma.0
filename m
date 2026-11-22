Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795369191;
	b=Q7XqyDmnoohacZNNt3EXxXpxRqtGUxXDvDS4eweJMvclHN2xhRm/rGA668o/+Hdd3ozp
	 gJiNZaAji8NND9g03mGI8ftZGAcwBpqXTr2MShTb3ikIPqbyyoQV/CfhzTIUd1PvbgWJF
	 x9FZS1H75KQ7OnqrZqFwssHxGmGvdHWJ2k2jodE+vnMpQzYh0SIOWCFD89oCcnCqBl6gJ
	 9+Dqhk8LwMZu+bR2YhWbvcR5LN4xMJXlrX3BnQw+aVB8DjfzksN+VAnstSqWs0pLlVnBn
	 tTX3H0vH+VlwCvtSODBgV1nU8a6ALzLwjdVDO8FPdAMhENojELm3Q8ns/WO1PzGvQFg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795369191;
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
	bh=QlcKZSTPR/55pj2J4aaMNr5tYIWm4NJGOPn1bHR8b20=;
	b=ULes8G+UE5GLdAdeHHWRQLJ/Gi78NtO1ct916iE99gkTtkEoL33OeYK3K4FlV9hGidJ2
	 HzA5QioyEn5msZPeDyrCzmFzPnCm70ufG8rX07JRxKxQQaoJinT+MlrepVCWK0dtdztZq
	 1wueUMI2xvfVh0J8aMWsCWhYdR8zb5TAO11Sf/72VIBFfsU7hn3jA4IAVrQHWiSOC1v/+
	 kGMh8vttvvmoaiQdhy5ubPY0vPONtU5Xla3QCe/9VT7JifqGQK37qB/w1/0fn4CzNZw1O
	 0mssVLcXo14hsJjM+4x3qGH3v/mfHEpqe+qJ2tsQGb/fzNhuhPFvLaOceQafy0zErcQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dA5HXbSP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.12
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010012.outbound.protection.outlook.com [40.93.198.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1829B606A684;
	Sun, 22 Nov 2026 17:39:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1829B606A684
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dA5HXbSP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BjhOjEoWvL5g2JyIpyPIiQdYsDKZ9aMbUPomASS3kUstO7Fs7Z9VEv3WuCi4zV4TH912OKUWJ4TCUBYk9Ug6otISRUWA8XjK9Lq5bYpaQOPSyFjeek+pcJg5I0UW/Y/O0NNrVRFV0pXmVthnGfuGDb/D/bGPZuU5cRbBktBgt1FvCSRhNNghjuXDQa7kZhoeRiBPOhPF/O6CodVJKf92GvIFv/tEm8L1ENH+45WI62z7ABDp30RwQFKQ4KjsvZ2htLNv6RQL5QP5feKlmKY9ShfWzNcE+BuNaHX5t6NjCLp0ilf6Aq3SZxro+x2IKkQ/c2s+O4yxl+uZIYBFFvv+IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QlcKZSTPR/55pj2J4aaMNr5tYIWm4NJGOPn1bHR8b20=;
 b=tib7a1lQpCMpe2jUAHueWROPq3VErZWb8PaU3fVGJygfbSOSpf6Ao3f1Gd39zGbtiKjQ+MBI/RGOEuUuZLk2pCP2a7qYgSllrvOLmjZTcSciYwAOLPONfJmuSajb0sw2MEk6KWA30eZsUwe2VmbKlHsUk1FpNFrVn9c8dn51IhPa8eyK4BiL5h7oN4IuXfFFo42/k+TEJ6ugbKt3Tn04LrbO3ZyBeoMY//jkkiTldGRqyXLLBcggSeN4JD1Pk9ZlCqD/90JiuMsxcKW/kyAAYuFnuc3pGTakHD3ULEXXrs9oEZaUfZJ1wB4cSLYcX993xL9nHSfPoXdBuu0lPTijOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlcKZSTPR/55pj2J4aaMNr5tYIWm4NJGOPn1bHR8b20=;
 b=dA5HXbSPs8EDVuhEy9ItDChrCEvYknNTxGtECXDCjGeTdNfx0GeeTGsBNBfQLe7meoJ3w96X9pKfc3s2sFwT2yMrZOgXV5L6eBKh80tbVNWJnXjSJgQoHiq6FzcT+s1DRKW6SuZgGiX9V7BiSUzjRaPJtq0fZue53zZaimsSSQaiNoM19dmXJwDvaero3+fEWv5SNuTIAfYUlIY4uI8L+Fiuc3AcZL4hM8cPXHKOIokOYG5jXYn5rhxkSQew09l6oF5Yf447cnPsp5BccCizdyVqhLVCIlg+CFFRO10vi5qmoogsmBl9m0uBHmz6nyHdUreSdOlpv/UKyDy04gHZwQ==
Received: from PH1PEPF000132EA.NAMP220.PROD.OUTLOOK.COM (2603:10b6:518:1::2e)
 by PH7PR12MB8107.namprd12.prod.outlook.com (2603:10b6:510:2bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Sun, 22 Nov
 2026 17:39:43 +0000
Received: from PH4PEPF0000B60E.namprd21.prod.outlook.com
 (2a01:111:f403:c95d::9) by PH1PEPF000132EA.outlook.office365.com
 (2603:1036:903:47::3) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Sun,
 22 Nov 2026 17:39:43 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 PH4PEPF0000B60E.mail.protection.outlook.com (10.167.243.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.0 via Frontend Transport; Sun, 22 Nov 2026 17:39:43 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 09:39:27 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sun, 22 Nov 2026 09:39:27 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sun, 22 Nov 2026 09:39:24 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Sun, 22 Nov 2026 19:39:10 +0200
Subject: [PATCH rdma-next 2/9] RDMA/mlx5: Don't let a slave port mark its
 master active
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
Message-ID: <20261122-mlx5-port-events-probe-v1-2-0d54e3d53c61@nvidia.com>
References: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
In-Reply-To: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Maor
 Gottlieb" <maorg@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Maher Sanalla <msanalla@nvidia.com>, Patrisious
 Haddad <phaddad@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795369157; l=1828;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=KoptPjtudLFmagSfielD/EEbsEAF341xHYgaycVcsnA=;
 b=1VS7CRe+qjVqrwmbrq7YY8Chacz3cAkDHkDPjhTpCKYA/DujzfSbLVlgyEiqTwAiq8SVvWXAd
 90rm/QUk4NxA0Zj+3b1O1X17O9kBp959P5xJMucsZ/rdhvzpNJdQkI0
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH4PEPF0000B60E:EE_|PH7PR12MB8107:EE_
X-MS-Office365-Filtering-Correlation-Id: fc006410-df67-470e-0ad1-08df48bf97ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|376014|36860700016|1800799024|18002099003|22082099003|11063799006|261026140227099003|261022075727099003|261028144727099003|261026121527099003|56012099006|261009223027099003|261021123027099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	V2p9ZmcvHma1DtN8W/xSi1CLXs9P8WPianU17QRZ+kRCNEBG88az9lAbX5EUCT3LCWyAaTEg60a/K7yGh3zw2TbysKQjdinaONB+FeuS5fEzxukfORb7Y9aO8SUjxDFdSe3p5D1GYGFGxux9qO7ZbbOE99x8OC3h1rFT8ySbWUmGybkWTpx5Mpmg9w2i5xtvkrydu6jz6atyTmPcwdf2TABXW0yehttrmIMPFdMveaSdTXmXS+D65FcstOJp9QWqmYE22pHRKma6jvk0xiuOnaygCxWe2eWs0DJOO9yagb5Ts8IT2XtOIweqXILDPVSVVwxPXnZiiFFr1Vdr7jdrCAdRLvtIeiBaj4oLolk3mkraOnVusDS8FQdL39QSLIxV5JuGRTULxQxuFvcalqDUnzXXSIKI4piNpn/WIy2N2z7Yo+tJMZdge2eehAlxS8s/xqppQgPN51tYc+DLrJiEo8ykXOyI4xuIn/cPQ5i0OTUoHFALgLxNuuSmSiIiXeshm6HeaUWg1PZzA86G7/hQ1xYjcGYZ43EF8DCAsWZ9HLA+qYweM+/vUgxwcfHhLkEGbOt3nMuCRFAspohSWt/VOfkfjlPRixzdqJghFFV51xhKUEAgKAgnG1CFEdbLk/sjDGY63jMjFnPtdndPAjcIlgrryVT1YKMi4pCMGiWpEZr0u4e1b8iwnfp2uS+ceGiimVJeKLbI0iUqGR8FfOIOdw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(376014)(36860700016)(1800799024)(18002099003)(22082099003)(11063799006)(261026140227099003)(261022075727099003)(261028144727099003)(261026121527099003)(56012099006)(261009223027099003)(261021123027099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ifbzww4DUd1HCaSaLWb0l4amiqdRY+JegYcpNITQj45e1JMMVWng5bc/VVEZLRfmqdcXJXFZVxnVHk48YOBeb5ivgUH6As1Zjn/ovPPwD6G8ef64r+lH1ocskC3IQG1P3aeFwZOKE3CLy8yDt/ieYy9YvqfgauCSPNHxUvDbBWXe6OPv/T+Oy5HoIifnzp1A1WkScPgXJh6cmNPqaaqsBGX2S47n5ThGxrZn8SvbtLJMYeEeI4QXKV9ZSSSLEw9ggBsIfIHrxkKcu+KHerkg5Ubmuq5L+yc0qzHT8zm4svyVnbc8vyVrnOIIWiELk0VXtRQBZf+69JNAWlad15m2yyqn7FrVrMdOvbv/eCBBNF9D/7mGrbt/G06vNzkBmPXkGogpC1pVD4bMaUj6qMiy2eki1o4hUHWmPx3t4WE7c/j1Z2JvpEPLa9HAyKqE2Ip0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 17:39:43.3943
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc006410-df67-470e-0ad1-08df48bf97ee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH4PEPF0000B60E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8107

mlx5r_mp_probe() sets ib_active on the master a slave port binds to.
Commit 97f30d324ce6 ("RDMA/mlx5: Recover from fatal event in dual port
mode") added that because a fatal event on the slave port used to
clear the master's ib_active. Since commit ebc2164a4cd4 ("RDMA/mlx5:
Fix UMR hang in LAG error state unload") system errors are handled by
a notifier on the master's own core device, and an error on the slave
no longer deactivates the master.

A master is on mlx5_ib_dev_list from MLX5_IB_STAGE_INIT until its
cleanup, while its ib_active is set only once probe completes, and a
slave port can bind to it at any point in between, as binding only
needs a free port slot. Setting ib_active on bind can then activate a
master that is still probing, is being removed or has failed, so that
events are handled for a device that is not registered yet or is being
torn down. Remove it.

The bind itself, and the rdma_roce_rescan_device() that follows it, can
still race a master that is probing or being removed; that is a
separate problem and is not addressed here.

Fixes: 97f30d324ce6 ("RDMA/mlx5: Recover from fatal event in dual port mode")
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 789e17bd317a48db502937a6816e95aa22f48e6f..4504ba112034f4a5cfad16183602f209941c8835 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5297,7 +5297,6 @@ static int mlx5r_mp_probe(struct auxiliary_device *adev,
 
 		if (bound) {
 			rdma_roce_rescan_device(&dev->ib_dev);
-			mpi->ibdev->ib_active = true;
 			break;
 		}
 	}

-- 
2.49.0

