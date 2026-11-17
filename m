Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794924128;
	b=39voLLgndb1Bjq4rJJH4VxoWfnMaFQTJcLIVTACQOn3VrYa/4K0dXGPCR39zQWMz/95k
	 V7JF+8YK1MmUHFmCLC23miR3bjjdx/2OTAvl/YUtU4AF3HGCMdJ1eH17TsP2HS/JPCpXn
	 3CrrHvUvVTsTZEBPLDn1GslZx1UW7llAPkOrR4VJevBfdEANG1YCp8iRugc/Y/YFZh3oG
	 M+4aQdJqpe/OyoCZ+KtBmBwkcSAnmmDcoOkB3LY1FhIqGPlrZQeNxnsDdOeQc98Kvfaku
	 b0Mm/hI/aenRW7nLToI+3Kni0R67M8L/huFVnHgW7jdU3ul/7QrgzDq7UTBGL5KMIrg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924128;
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
	bh=hM58qe0F3p600xyLhQNeJCb/mAcyDOsXoRdWsTjBxCk=;
	b=NNOc7XCGaA3pHrbx30r01XKEfrbjkw6I7UuVoI1E5v7YQflRyVKIgnLyzTr8ihet1z8n
	 Cd3YE6h49I3O3bpau8wre7LAfkpzpuL6MndAsG1K9SYLCYs3qDpNlPK95DpQdqBrXgGbt
	 kQ2GdDOobukU2WZ93TAEbmXUXh9+hL+K1eJ2kwBTS8OycSurW3n5w3ZmYzL+UGE8wRT3J
	 lHGwITWKT0kTWfkFTCZSPsoZbLzVy06zBIJ1TdjRpSrka1nhUFrDmFIef0+LiCblOgBzp
	 JXxUKl5/kQ1psIzB8/KKIZ0vmmhLQFv4pBTH+ZJ1zAgHaRN6KP97p9+frK3TmxPqjwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=I4z7NJNd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.27
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011027.outbound.protection.outlook.com [52.101.52.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94109606A32F;
	Tue, 17 Nov 2026 14:02:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94109606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=I4z7NJNd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFGU7vtqdR77598wZKGlymxVo5gOyi4jXivJ2KRivRZtAeV2cdyNrvsW3NlxB1rxixaXrQesF9Rov7jHnc3bUI64mup6ifJLe1+nkxMPvSlQpW71opTdHu5hBBw/GxWpAhZWZomuy2++9YtEEN4UrzHIlj2azY4rbSxy7ATLxxRZB8yT+DhJnJolXeePCwLB60KnZiwg7mWpZyUHe3wBHD1UC27LMh3jYMKIbDLHmYY6HpFSe4WEsE2+pcNTrrXjQaagxghu0duW8MbzwIVbZa8h2RbsG022YFib1+L+CSOOuopQXqniYAQJ4QNksth/SJGmBqn+/15YiHCg3RIU8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hM58qe0F3p600xyLhQNeJCb/mAcyDOsXoRdWsTjBxCk=;
 b=xa9RshjzvM3d8s9H8XbIYvFhVsZ4i1EXuCbuhNueft4N4hEqfzuToIGBDXT88mjUxHhbqHyHJl5rukaAE8w9/T08NskweQvbPjeBcFIjpd4JMfyLHYjTwE8A785es5IoxuZ+J7w1bfKE56fkX4lrxp2mDjdNmZn44tYeQu9GGQm0fZBcGCivvT0dPS/YqEbzZxTP+VciU1BsWos4PhmG4QX62u0h8Kt/sVKgvSk6djyDlU3E0PO+jTvksQG+ceXCbI2i4wBYUyNvr0VcTAVVCep1ESnBYINPGGd1BD1yj7sd3NacLHkbOHR47Ch4Jr0kFUZ9tI8UczDWY/u/jvolUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hM58qe0F3p600xyLhQNeJCb/mAcyDOsXoRdWsTjBxCk=;
 b=I4z7NJNdj8jcCodutV1i0jmifiSVer41qXMjvRJuTR0iZdWoWtBExMV4W5e3+pl0RmXnkuu2rfatzlIDrK0JxBGSj6eHEOZE4TXQcBmoQrK++eRMTZPrbkLlS/uTqp2m9yqCBozHJyYpGPS7/v8dbfKYyhrN43L74S82xLJB3Gdrfb12OLmaVzz8Aci3g5biqKXxGGoyFyh7ldSWzNMP4+q4rbb6PbRuWhauqzsOvEnC3vAACI7jPuYp7hX8wxyYVwqndWYQCX1s8PljZiZ4BEUNRllPWx492zyxj4j/zWTmWjHC5FHNIsNgJRQlQA6JYm0kWI2Xhuw7weJB/gK/BA==
Received: from CH0PR03CA0216.namprd03.prod.outlook.com (2603:10b6:610:e7::11)
 by LV1PR12MB049288.namprd12.prod.outlook.com (2603:10b6:408:511::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 14:01:58 +0000
Received: from IA0PEPF0000003D.namprd03.prod.outlook.com
 (2603:10b6:610:e7:cafe::10) by CH0PR03CA0216.outlook.office365.com
 (2603:10b6:610:e7::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Tue,
 17 Nov 2026 14:01:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 IA0PEPF0000003D.mail.protection.outlook.com (10.167.249.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Tue, 17 Nov 2026 14:01:57 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 06:01:29 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 17 Nov
 2026 06:01:28 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 17
 Nov 2026 06:01:26 -0800
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 17 Nov 2026 16:01:14 +0200
Subject: [PATCH rdma-next 03/11] RDMA/mlx5: Select the PD and SRQ core
 device through the PD
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
Message-ID: <20261117-mlx5-sd-prep-v1-3-8efd124c7895@nvidia.com>
References: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
In-Reply-To: <20261117-mlx5-sd-prep-v1-0-8efd124c7895@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Sabrina Dubroca" <sd@queasysnail.net>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, Edward Srouji <edwards@nvidia.com>, "Akiva
 Goldberger" <agoldberger@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794924076; l=25131;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=EQQ6hjeAkZyeuNVsTpr6F2wqM5dNndA3xJteUMpsUeI=;
 b=lKR7CZ34Wl7RIZDhQMrA2gPkbZXZdjcDR33A+cFvfjrcQUhILdlLxhy7tBSjA2P090wBlDWho
 oEwEVMLItSDChKfTrb0PuGgcDZ71E5Z/zI6CHOdYr5pmE3T2ekgLZ06
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PEPF0000003D:EE_|LV1PR12MB049288:EE_
X-MS-Office365-Filtering-Correlation-Id: 19bbbc24-5270-43b1-37fd-08df44b35847
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|23010399003|376014|18002099003|22082099003|261009223027099003|11063799006|56012099006|260925022911599003|260925021911599003|260925021311599003|261026135527099003|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261022075727099003|261026130827099003|261022105027099003|261022113327099003|261021123027099003|261022115727099003|261021130227099003|261021133027099003|261021135927099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	3Lug5fRxv9+yWeTyDzSgWAHQsinkF0+r2rS3m17JZXxxobmA2OVG2vyBVL2i9vB0De9EstCCY6DA8lTOuVMfJsVI5ugATkgg+XyIQ+tZ9+2+zKU6j5w1YUBcsdhPHck2F5FyJulTRhOyOYpd00M3M+/XncwUYnEUWrfhLTWVg0oP96tSYrUDU0RBULW7dfKiJ2e6ZnMy1tWVmXsEdr+l+ZNq1NFR6X3bU50c8tz3i4mpwTB5rxuNjthAojYZ1Oayw1k1SruVXhvYxb2YNspOsQOMb+XiV3Og6v0vQXVsLsz3GGjOcKsLdBYzDbYWaEeilQWyA+GvVLLA6/e0NT7DfCipQIG7rEM3gaCqGJG5Pjx9eZaLrHs/WSopU35Hx3rRWZqvbnJ5Gr7RWRDhPbHuS3pKR1LD0tTNuIVe5PwRlRqk2x+x/LK15+bD/TT//3JwPaPh2DoDsIgcrgIezP3r1xkr+vcD5qXSDq5a096D2QiHOqtnEQIvFOjO745+iX52/CEnZMBVMR+Qz6W6dAM8RJRb5C8g9RSPPCVq6rNnpAeqk3HmOvdWtdP5Q5nbd7lEaFXVe9x54nqM3Zxt+poLOeU/vAPEkM3U9WoccDJ2nbSye5jdUDZOaq05orLDdAMpSjLUcyVNlPIGQaJJDz76SXk+ckZTpr7uxgIKxDV+iyVNMhLq/T3ebkir9aMra8/j4bTaMpNo6PS2kw4GaD2l3g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(23010399003)(376014)(18002099003)(22082099003)(261009223027099003)(11063799006)(56012099006)(260925022911599003)(260925021911599003)(260925021311599003)(261026135527099003)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022075727099003)(261026130827099003)(261022105027099003)(261022113327099003)(261021123027099003)(261022115727099003)(261021130227099003)(261021133027099003)(261021135927099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1S+azwlpCu0lN01R0LUrF1ImfbZsFgMevYDPJNuOkS7uf59+iE9tUR7AkZBFb+Gf1LeAaccirbc2G5zdXTBi/e2T8lHAWLy5wG0Gq8rDpBio6FCQKzcqFMNj3upf6UMA4fLl6SX73zde1Zsm/8VVo4AELdFIWaOCPvzIBCaYD4nkyG52saqnfrPVW3a+OMXqc7iYWRdvKARQQelNiDySD6jlNAbOx+1BXtnbd2knRlzl6I7yqnJ+OTMcf6nivTzY6gOjqA4ZeU1bMHNOSiVv9hYgY+icU4+N6Y8RSV4NvIPn3+BKl048ZFg8p+6ZcnPjQriHCkk3BY7XXyWqIapENtetHbzq2Mc0iGtVIoC1Cojt4VYolZ/tb1jXDLkIKftnBkUNR9LdVRa8sYvlnkw304G+0nqqwa/Cv80vkmff5tgkdqUYWcFrHjDjIARAlpFu
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 14:01:57.9073
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19bbbc24-5270-43b1-37fd-08df44b35847
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF0000003D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB049288

From: Akiva Goldberger <agoldberger@nvidia.com>

An SRQ is tied to a PD when it is allocated. Use the SRQ's PD to select
the backend mlx5_core_dev for all SRQ flows that require it.

Add helpers pd_to_mdev() and srq_to_mdev() to replace dev->mdev
references in the SRQ flows, and allocate and free the PD itself on
the core device pd_to_mdev() returns.

Also, enforce a single naming scheme for dev/mdev resolvers in mlx5_ib.
A resolver is named <resource>_to_mdev() or <resource>_to_dev() after
the resource it takes, as the helpers renamed in the previous patch
already are. Where several resource types have to be accepted, as an
ib_pd and an mlx5_ib_pd are for pd_to_mdev(), the resolver is a
_Generic() over per-type helpers.

No functional change.

Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Michael Gur <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c    |   8 +--
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  27 ++++++++
 drivers/infiniband/hw/mlx5/srq.c     |  42 ++++++------
 drivers/infiniband/hw/mlx5/srq.h     |   4 +-
 drivers/infiniband/hw/mlx5/srq_cmd.c | 124 +++++++++++++++++------------------
 5 files changed, 115 insertions(+), 90 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a78418699e90d6032dec949d1e0d8462d11c1239..28a2d75b3f37cade52130da86d011965823352bf 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2793,7 +2793,6 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 static int mlx5_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 {
 	struct mlx5_ib_pd *pd = to_mpd(ibpd);
-	struct ib_device *ibdev = ibpd->device;
 	struct mlx5_ib_alloc_pd_resp resp = {};
 	int err;
 	u32 out[MLX5_ST_SZ_DW(alloc_pd_out)] = {};
@@ -2805,7 +2804,7 @@ static int mlx5_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 	uid = context ? context->devx_uid : 0;
 	MLX5_SET(alloc_pd_in, in, opcode, MLX5_CMD_OP_ALLOC_PD);
 	MLX5_SET(alloc_pd_in, in, uid, uid);
-	err = mlx5_cmd_exec_inout(to_dev(ibdev)->mdev, alloc_pd, in, out);
+	err = mlx5_cmd_exec_inout(pd_to_mdev(pd), alloc_pd, in, out);
 	if (err)
 		return err;
 
@@ -2815,7 +2814,7 @@ static int mlx5_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 		resp.pdn = pd->pdn;
 		err = ib_respond_udata(udata, resp);
 		if (err) {
-			mlx5_cmd_dealloc_pd(to_dev(ibdev)->mdev, pd->pdn, uid);
+			mlx5_cmd_dealloc_pd(pd_to_mdev(pd), pd->pdn, uid);
 			return err;
 		}
 	}
@@ -2825,10 +2824,9 @@ static int mlx5_ib_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 
 static int mlx5_ib_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_dev(pd->device);
 	struct mlx5_ib_pd *mpd = to_mpd(pd);
 
-	return mlx5_cmd_dealloc_pd(dev->mdev, mpd->pdn, mpd->uid);
+	return mlx5_cmd_dealloc_pd(pd_to_mdev(mpd), mpd->pdn, mpd->uid);
 }
 
 static int mlx5_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8e2b354ef239e72b6e1da1867f508ec9cd4eddc8..bbb73314921bdec91186bf5e855850fcb2b30632 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1240,6 +1240,33 @@ static inline struct mlx5_ib_mr *to_mmr(struct ib_mr *ibmr)
 	return container_of(ibmr, struct mlx5_ib_mr, ibmr);
 }
 
+/*
+ * Device resolvers.
+ *
+ * Each helper is named <resource>_to_mdev() or <resource>_to_dev(). Where more
+ * than one resource type has to be accepted, the interface is a _Generic()
+ * that dispatches to one helper per type.
+ */
+static inline struct mlx5_core_dev *__ib_pd_to_mdev(struct ib_pd *pd)
+{
+	return to_dev(pd->device)->mdev;
+}
+
+static inline struct mlx5_core_dev *__mlx5_ib_pd_to_mdev(struct mlx5_ib_pd *pd)
+{
+	return to_dev(pd->ibpd.device)->mdev;
+}
+
+#define pd_to_mdev(pd) \
+	_Generic((pd), \
+		struct ib_pd * : __ib_pd_to_mdev, \
+		struct mlx5_ib_pd * : __mlx5_ib_pd_to_mdev)(pd)
+
+static inline struct mlx5_core_dev *srq_to_mdev(struct mlx5_core_srq *msrq)
+{
+	return pd_to_mdev(to_mibsrq(msrq)->ibsrq.pd);
+}
+
 static inline struct mlx5_ib_mw *to_mmw(struct ib_mw *ibmw)
 {
 	return container_of(ibmw, struct mlx5_ib_mw, ibmw);
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index a52fd1811956196a6f0c1b63c1e2608b2e5b1ff6..9f03cb7619bdf78bf031801af092ffd3d47de75f 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -90,7 +90,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	}
 
 	in->uid = (in->type != IB_SRQT_XRC) ?  to_mpd(pd)->uid : 0;
-	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
+	if (MLX5_CAP_GEN(pd_to_mdev(pd), cqe_version) == MLX5_CQE_VERSION_V1 &&
 	    in->type != IB_SRQT_BASIC)
 		in->user_index = uidx;
 
@@ -105,18 +105,19 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 			     struct mlx5_srq_attr *in, int buf_size)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(srq->ibsrq.pd);
 	int err;
 	int i;
 	struct mlx5_wqe_srq_next_seg *next;
 
-	err = mlx5_db_alloc(dev->mdev, &srq->db);
+	err = mlx5_db_alloc(mdev, &srq->db);
 	if (err) {
 		mlx5_ib_warn(dev, "alloc dbell rec failed\n");
 		return err;
 	}
 
-	if (mlx5_frag_buf_alloc_node(dev->mdev, buf_size, &srq->buf,
-				     dev->mdev->priv.numa_node)) {
+	if (mlx5_frag_buf_alloc_node(mdev, buf_size, &srq->buf,
+				     mdev->priv.numa_node)) {
 		mlx5_ib_dbg(dev, "buf alloc failed\n");
 		err = -ENOMEM;
 		goto err_db;
@@ -151,7 +152,7 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 	srq->wq_sig = 0;
 
 	in->log_page_size = srq->buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT;
-	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
+	if (MLX5_CAP_GEN(mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
 	    in->type != IB_SRQT_BASIC)
 		in->user_index = MLX5_IB_DEFAULT_UIDX;
 
@@ -161,10 +162,10 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 	kvfree(in->pas);
 
 err_buf:
-	mlx5_frag_buf_free(dev->mdev, &srq->buf);
+	mlx5_frag_buf_free(mdev, &srq->buf);
 
 err_db:
-	mlx5_db_free(dev->mdev, &srq->db);
+	mlx5_db_free(mdev, &srq->db);
 	return err;
 }
 
@@ -181,11 +182,13 @@ static void destroy_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 }
 
 
-static void destroy_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq)
+static void destroy_srq_kernel(struct mlx5_ib_srq *srq)
 {
+	struct mlx5_core_dev *mdev = pd_to_mdev(srq->ibsrq.pd);
+
 	kvfree(srq->wrid);
-	mlx5_frag_buf_free(dev->mdev, &srq->buf);
-	mlx5_db_free(dev->mdev, &srq->db);
+	mlx5_frag_buf_free(mdev, &srq->buf);
+	mlx5_db_free(mdev, &srq->db);
 }
 
 int mlx5_ib_create_srq(struct ib_srq *ib_srq,
@@ -194,12 +197,13 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 {
 	struct mlx5_ib_dev *dev = to_dev(ib_srq->device);
 	struct mlx5_ib_srq *srq = to_msrq(ib_srq);
+	struct mlx5_core_dev *mdev = pd_to_mdev(ib_srq->pd);
 	size_t desc_size;
 	size_t buf_size;
 	int err;
 	struct mlx5_srq_attr in = {};
-	__u32 max_srq_wqes = 1 << MLX5_CAP_GEN(dev->mdev, log_max_srq_sz);
-	__u32 max_sge_sz =  MLX5_CAP_GEN(dev->mdev, max_wqe_sz_rq) /
+	__u32 max_srq_wqes = 1 << MLX5_CAP_GEN(mdev, log_max_srq_sz);
+	__u32 max_sge_sz =  MLX5_CAP_GEN(mdev, max_wqe_sz_rq) /
 			    sizeof(struct mlx5_wqe_data_seg);
 
 	if (init_attr->srq_type != IB_SRQT_BASIC &&
@@ -269,7 +273,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 		in.tm_log_list_size =
 			ilog2(init_attr->ext.tag_matching.max_num_tags) + 1;
 		if (in.tm_log_list_size >
-		    MLX5_CAP_GEN(dev->mdev, log_tag_matching_list_sz)) {
+		    MLX5_CAP_GEN(mdev, log_tag_matching_list_sz)) {
 			mlx5_ib_dbg(dev, "TM SRQ max_num_tags exceeding limit\n");
 			err = -EINVAL;
 			goto err_usr_kern_srq;
@@ -316,7 +320,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	if (udata)
 		destroy_srq_user(ib_srq->pd, srq, udata);
 	else
-		destroy_srq_kernel(dev, srq);
+		destroy_srq_kernel(srq);
 
 	return err;
 }
@@ -324,7 +328,6 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 int mlx5_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		       enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
 {
-	struct mlx5_ib_dev *dev = to_dev(ibsrq->device);
 	struct mlx5_ib_srq *srq = to_msrq(ibsrq);
 	int ret;
 
@@ -337,7 +340,7 @@ int mlx5_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			return -EINVAL;
 
 		mutex_lock(&srq->mutex);
-		ret = mlx5_cmd_arm_srq(dev, &srq->msrq, attr->srq_limit, 1);
+		ret = mlx5_cmd_arm_srq(&srq->msrq, attr->srq_limit, 1);
 		mutex_unlock(&srq->mutex);
 
 		if (ret)
@@ -349,7 +352,6 @@ int mlx5_ib_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 
 int mlx5_ib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
 {
-	struct mlx5_ib_dev *dev = to_dev(ibsrq->device);
 	struct mlx5_ib_srq *srq = to_msrq(ibsrq);
 	int ret;
 	struct mlx5_srq_attr *out;
@@ -358,7 +360,7 @@ int mlx5_ib_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *srq_attr)
 	if (!out)
 		return -ENOMEM;
 
-	ret = mlx5_cmd_query_srq(dev, &srq->msrq, out);
+	ret = mlx5_cmd_query_srq(&srq->msrq, out);
 	if (ret)
 		goto out_box;
 
@@ -384,7 +386,7 @@ int mlx5_ib_destroy_srq(struct ib_srq *srq, struct ib_udata *udata)
 	if (udata)
 		destroy_srq_user(srq->pd, msrq, udata);
 	else
-		destroy_srq_kernel(dev, msrq);
+		destroy_srq_kernel(msrq);
 	return 0;
 }
 
@@ -409,7 +411,7 @@ int mlx5_ib_post_srq_recv(struct ib_srq *ibsrq, const struct ib_recv_wr *wr,
 	struct mlx5_wqe_srq_next_seg *next;
 	struct mlx5_wqe_data_seg *scat;
 	struct mlx5_ib_dev *dev = to_dev(ibsrq->device);
-	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_core_dev *mdev = pd_to_mdev(ibsrq->pd);
 	unsigned long flags;
 	int err = 0;
 	int nreq;
diff --git a/drivers/infiniband/hw/mlx5/srq.h b/drivers/infiniband/hw/mlx5/srq.h
index a7e3dc5564ac90ec8ddc536480e7ea5201e06cd5..76d389ec6b08f188a74cd555c9477dccb4f2368f 100644
--- a/drivers/infiniband/hw/mlx5/srq.h
+++ b/drivers/infiniband/hw/mlx5/srq.h
@@ -58,9 +58,9 @@ struct mlx5_srq_table {
 int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			struct mlx5_srq_attr *in);
 int mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq);
-int mlx5_cmd_query_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+int mlx5_cmd_query_srq(struct mlx5_core_srq *srq,
 		       struct mlx5_srq_attr *out);
-int mlx5_cmd_arm_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+int mlx5_cmd_arm_srq(struct mlx5_core_srq *srq,
 		     u16 lwm, int is_srq);
 struct mlx5_core_srq *mlx5_cmd_get_srq(struct mlx5_ib_dev *dev, u32 srqn);
 
diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index c1a088120915c5741f37ed44fd2e8139bcb6802e..944b53074f69dca3a1b25b2dc8a41dae7546dcac 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -111,7 +111,7 @@ static int __set_srq_page_size(struct mlx5_srq_attr *in,
 					MLX5_ADAPTER_PAGE_SHIFT, page_offset,  \
 					64, &(in)->page_offset))
 
-static int create_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int create_srq_cmd(struct mlx5_core_srq *srq,
 			  struct mlx5_srq_attr *in)
 {
 	u32 create_out[MLX5_ST_SZ_DW(create_srq_out)] = {0};
@@ -150,7 +150,7 @@ static int create_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(create_srq_in, create_in, opcode,
 		 MLX5_CMD_OP_CREATE_SRQ);
 
-	err = mlx5_cmd_exec(dev->mdev, create_in, inlen, create_out,
+	err = mlx5_cmd_exec(srq_to_mdev(srq), create_in, inlen, create_out,
 			    sizeof(create_out));
 	kvfree(create_in);
 	if (!err) {
@@ -161,7 +161,7 @@ static int create_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int destroy_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
+static int destroy_srq_cmd(struct mlx5_core_srq *srq)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_srq_in)] = {};
 
@@ -169,10 +169,10 @@ static int destroy_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 	MLX5_SET(destroy_srq_in, in, srqn, srq->srqn);
 	MLX5_SET(destroy_srq_in, in, uid, srq->uid);
 
-	return mlx5_cmd_exec_in(dev->mdev, destroy_srq, in);
+	return mlx5_cmd_exec_in(srq_to_mdev(srq), destroy_srq, in);
 }
 
-static int arm_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int arm_srq_cmd(struct mlx5_core_srq *srq,
 		       u16 lwm, int is_srq)
 {
 	u32 in[MLX5_ST_SZ_DW(arm_rq_in)] = {};
@@ -183,10 +183,10 @@ static int arm_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(arm_rq_in, in, lwm, lwm);
 	MLX5_SET(arm_rq_in, in, uid, srq->uid);
 
-	return mlx5_cmd_exec_in(dev->mdev, arm_rq, in);
+	return mlx5_cmd_exec_in(srq_to_mdev(srq), arm_rq, in);
 }
 
-static int query_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int query_srq_cmd(struct mlx5_core_srq *srq,
 			 struct mlx5_srq_attr *out)
 {
 	u32 in[MLX5_ST_SZ_DW(query_srq_in)] = {};
@@ -200,7 +200,7 @@ static int query_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 
 	MLX5_SET(query_srq_in, in, opcode, MLX5_CMD_OP_QUERY_SRQ);
 	MLX5_SET(query_srq_in, in, srqn, srq->srqn);
-	err = mlx5_cmd_exec_inout(dev->mdev, query_srq, in, srq_out);
+	err = mlx5_cmd_exec_inout(srq_to_mdev(srq), query_srq, in, srq_out);
 	if (err)
 		goto out;
 
@@ -213,8 +213,7 @@ static int query_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int create_xrc_srq_cmd(struct mlx5_ib_dev *dev,
-			      struct mlx5_core_srq *srq,
+static int create_xrc_srq_cmd(struct mlx5_core_srq *srq,
 			      struct mlx5_srq_attr *in)
 {
 	u32 create_out[MLX5_ST_SZ_DW(create_xrc_srq_out)];
@@ -255,7 +254,7 @@ static int create_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 		 MLX5_CMD_OP_CREATE_XRC_SRQ);
 
 	memset(create_out, 0, sizeof(create_out));
-	err = mlx5_cmd_exec(dev->mdev, create_in, inlen, create_out,
+	err = mlx5_cmd_exec(srq_to_mdev(srq), create_in, inlen, create_out,
 			    sizeof(create_out));
 	if (err)
 		goto out;
@@ -267,8 +266,7 @@ static int create_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 	return err;
 }
 
-static int destroy_xrc_srq_cmd(struct mlx5_ib_dev *dev,
-			       struct mlx5_core_srq *srq)
+static int destroy_xrc_srq_cmd(struct mlx5_core_srq *srq)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_xrc_srq_in)] = {};
 
@@ -276,10 +274,10 @@ static int destroy_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 	MLX5_SET(destroy_xrc_srq_in, in, xrc_srqn, srq->srqn);
 	MLX5_SET(destroy_xrc_srq_in, in, uid, srq->uid);
 
-	return mlx5_cmd_exec_in(dev->mdev, destroy_xrc_srq, in);
+	return mlx5_cmd_exec_in(srq_to_mdev(srq), destroy_xrc_srq, in);
 }
 
-static int arm_xrc_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int arm_xrc_srq_cmd(struct mlx5_core_srq *srq,
 			   u16 lwm)
 {
 	u32 in[MLX5_ST_SZ_DW(arm_xrc_srq_in)] = {};
@@ -291,11 +289,10 @@ static int arm_xrc_srq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(arm_xrc_srq_in, in, lwm, lwm);
 	MLX5_SET(arm_xrc_srq_in, in, uid, srq->uid);
 
-	return  mlx5_cmd_exec_in(dev->mdev, arm_xrc_srq, in);
+	return  mlx5_cmd_exec_in(srq_to_mdev(srq), arm_xrc_srq, in);
 }
 
-static int query_xrc_srq_cmd(struct mlx5_ib_dev *dev,
-			     struct mlx5_core_srq *srq,
+static int query_xrc_srq_cmd(struct mlx5_core_srq *srq,
 			     struct mlx5_srq_attr *out)
 {
 	u32 in[MLX5_ST_SZ_DW(query_xrc_srq_in)] = {};
@@ -310,7 +307,8 @@ static int query_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 	MLX5_SET(query_xrc_srq_in, in, opcode, MLX5_CMD_OP_QUERY_XRC_SRQ);
 	MLX5_SET(query_xrc_srq_in, in, xrc_srqn, srq->srqn);
 
-	err = mlx5_cmd_exec_inout(dev->mdev, query_xrc_srq, in, xrcsrq_out);
+	err = mlx5_cmd_exec_inout(srq_to_mdev(srq), query_xrc_srq, in,
+				  xrcsrq_out);
 	if (err)
 		goto out;
 
@@ -325,7 +323,7 @@ static int query_xrc_srq_cmd(struct mlx5_ib_dev *dev,
 	return err;
 }
 
-static int create_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int create_rmp_cmd(struct mlx5_core_srq *srq,
 			  struct mlx5_srq_attr *in)
 {
 	void *create_out = NULL;
@@ -371,7 +369,8 @@ static int create_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 		memcpy(pas, in->pas, pas_size);
 
 	MLX5_SET(create_rmp_in, create_in, opcode, MLX5_CMD_OP_CREATE_RMP);
-	err = mlx5_cmd_exec(dev->mdev, create_in, inlen, create_out, outlen);
+	err = mlx5_cmd_exec(srq_to_mdev(srq), create_in, inlen, create_out,
+			    outlen);
 	if (!err) {
 		srq->srqn = MLX5_GET(create_rmp_out, create_out, rmpn);
 		srq->uid = in->uid;
@@ -383,17 +382,17 @@ static int create_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int destroy_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
+static int destroy_rmp_cmd(struct mlx5_core_srq *srq)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_rmp_in)] = {};
 
 	MLX5_SET(destroy_rmp_in, in, opcode, MLX5_CMD_OP_DESTROY_RMP);
 	MLX5_SET(destroy_rmp_in, in, rmpn, srq->srqn);
 	MLX5_SET(destroy_rmp_in, in, uid, srq->uid);
-	return mlx5_cmd_exec_in(dev->mdev, destroy_rmp, in);
+	return mlx5_cmd_exec_in(srq_to_mdev(srq), destroy_rmp, in);
 }
 
-static int arm_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int arm_rmp_cmd(struct mlx5_core_srq *srq,
 		       u16 lwm)
 {
 	void *out = NULL;
@@ -427,7 +426,7 @@ static int arm_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(rmpc, rmpc, state, MLX5_RMPC_STATE_RDY);
 	MLX5_SET(modify_rmp_in, in, opcode, MLX5_CMD_OP_MODIFY_RMP);
 
-	err = mlx5_cmd_exec_inout(dev->mdev, modify_rmp, in, out);
+	err = mlx5_cmd_exec_inout(srq_to_mdev(srq), modify_rmp, in, out);
 
 out:
 	kvfree(in);
@@ -435,7 +434,7 @@ static int arm_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int query_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int query_rmp_cmd(struct mlx5_core_srq *srq,
 			 struct mlx5_srq_attr *out)
 {
 	u32 *rmp_out = NULL;
@@ -457,7 +456,7 @@ static int query_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 
 	MLX5_SET(query_rmp_in, rmp_in, opcode, MLX5_CMD_OP_QUERY_RMP);
 	MLX5_SET(query_rmp_in, rmp_in, rmpn,   srq->srqn);
-	err = mlx5_cmd_exec_inout(dev->mdev, query_rmp, rmp_in, rmp_out);
+	err = mlx5_cmd_exec_inout(srq_to_mdev(srq), query_rmp, rmp_in, rmp_out);
 	if (err)
 		goto out;
 
@@ -472,7 +471,7 @@ static int query_rmp_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int create_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int create_xrq_cmd(struct mlx5_core_srq *srq,
 			  struct mlx5_srq_attr *in)
 {
 	u32 create_out[MLX5_ST_SZ_DW(create_xrq_out)] = {0};
@@ -521,7 +520,7 @@ static int create_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(xrqc, xrqc, cqn, in->cqn);
 	MLX5_SET(create_xrq_in, create_in, opcode, MLX5_CMD_OP_CREATE_XRQ);
 	MLX5_SET(create_xrq_in, create_in, uid, in->uid);
-	err = mlx5_cmd_exec(dev->mdev, create_in, inlen, create_out,
+	err = mlx5_cmd_exec(srq_to_mdev(srq), create_in, inlen, create_out,
 			    sizeof(create_out));
 	kvfree(create_in);
 	if (!err) {
@@ -532,7 +531,7 @@ static int create_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int destroy_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
+static int destroy_xrq_cmd(struct mlx5_core_srq *srq)
 {
 	u32 in[MLX5_ST_SZ_DW(destroy_xrq_in)] = {};
 
@@ -540,11 +539,10 @@ static int destroy_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 	MLX5_SET(destroy_xrq_in, in, xrqn, srq->srqn);
 	MLX5_SET(destroy_xrq_in, in, uid, srq->uid);
 
-	return mlx5_cmd_exec_in(dev->mdev, destroy_xrq, in);
+	return mlx5_cmd_exec_in(srq_to_mdev(srq), destroy_xrq, in);
 }
 
-static int arm_xrq_cmd(struct mlx5_ib_dev *dev,
-		       struct mlx5_core_srq *srq,
+static int arm_xrq_cmd(struct mlx5_core_srq *srq,
 		       u16 lwm)
 {
 	u32 in[MLX5_ST_SZ_DW(arm_rq_in)] = {};
@@ -555,10 +553,10 @@ static int arm_xrq_cmd(struct mlx5_ib_dev *dev,
 	MLX5_SET(arm_rq_in, in, lwm, lwm);
 	MLX5_SET(arm_rq_in, in, uid, srq->uid);
 
-	return mlx5_cmd_exec_in(dev->mdev, arm_rq, in);
+	return mlx5_cmd_exec_in(srq_to_mdev(srq), arm_rq, in);
 }
 
-static int query_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int query_xrq_cmd(struct mlx5_core_srq *srq,
 			 struct mlx5_srq_attr *out)
 {
 	u32 in[MLX5_ST_SZ_DW(query_xrq_in)] = {};
@@ -574,7 +572,7 @@ static int query_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	MLX5_SET(query_xrq_in, in, opcode, MLX5_CMD_OP_QUERY_XRQ);
 	MLX5_SET(query_xrq_in, in, xrqn, srq->srqn);
 
-	err = mlx5_cmd_exec_inout(dev->mdev, query_xrq, in, xrq_out);
+	err = mlx5_cmd_exec_inout(srq_to_mdev(srq), query_xrq, in, xrq_out);
 	if (err)
 		goto out;
 
@@ -597,32 +595,32 @@ static int query_xrq_cmd(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return err;
 }
 
-static int create_srq_split(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+static int create_srq_split(struct mlx5_core_srq *srq,
 			    struct mlx5_srq_attr *in)
 {
-	if (!dev->mdev->issi)
-		return create_srq_cmd(dev, srq, in);
+	if (!srq_to_mdev(srq)->issi)
+		return create_srq_cmd(srq, in);
 	switch (srq->common.res) {
 	case MLX5_RES_XSRQ:
-		return create_xrc_srq_cmd(dev, srq, in);
+		return create_xrc_srq_cmd(srq, in);
 	case MLX5_RES_XRQ:
-		return create_xrq_cmd(dev, srq, in);
+		return create_xrq_cmd(srq, in);
 	default:
-		return create_rmp_cmd(dev, srq, in);
+		return create_rmp_cmd(srq, in);
 	}
 }
 
-static int destroy_srq_split(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
+static int destroy_srq_split(struct mlx5_core_srq *srq)
 {
-	if (!dev->mdev->issi)
-		return destroy_srq_cmd(dev, srq);
+	if (!srq_to_mdev(srq)->issi)
+		return destroy_srq_cmd(srq);
 	switch (srq->common.res) {
 	case MLX5_RES_XSRQ:
-		return destroy_xrc_srq_cmd(dev, srq);
+		return destroy_xrc_srq_cmd(srq);
 	case MLX5_RES_XRQ:
-		return destroy_xrq_cmd(dev, srq);
+		return destroy_xrq_cmd(srq);
 	default:
-		return destroy_rmp_cmd(dev, srq);
+		return destroy_rmp_cmd(srq);
 	}
 }
 
@@ -643,7 +641,7 @@ int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 		srq->common.res = MLX5_RES_SRQ;
 	}
 
-	err = create_srq_split(dev, srq, in);
+	err = create_srq_split(srq, in);
 	if (err)
 		return err;
 
@@ -657,7 +655,7 @@ int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 	return 0;
 
 err_destroy_srq_split:
-	destroy_srq_split(dev, srq);
+	destroy_srq_split(srq);
 
 	return err;
 }
@@ -673,7 +671,7 @@ int mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 	if (WARN_ON(tmp != srq))
 		return xa_err(tmp) ?: -EINVAL;
 
-	err = destroy_srq_split(dev, srq);
+	err = destroy_srq_split(srq);
 	if (err) {
 		/*
 		 * We don't need to check returned result for an error,
@@ -697,33 +695,33 @@ int mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 	return 0;
 }
 
-int mlx5_cmd_query_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+int mlx5_cmd_query_srq(struct mlx5_core_srq *srq,
 		       struct mlx5_srq_attr *out)
 {
-	if (!dev->mdev->issi)
-		return query_srq_cmd(dev, srq, out);
+	if (!srq_to_mdev(srq)->issi)
+		return query_srq_cmd(srq, out);
 	switch (srq->common.res) {
 	case MLX5_RES_XSRQ:
-		return query_xrc_srq_cmd(dev, srq, out);
+		return query_xrc_srq_cmd(srq, out);
 	case MLX5_RES_XRQ:
-		return query_xrq_cmd(dev, srq, out);
+		return query_xrq_cmd(srq, out);
 	default:
-		return query_rmp_cmd(dev, srq, out);
+		return query_rmp_cmd(srq, out);
 	}
 }
 
-int mlx5_cmd_arm_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
+int mlx5_cmd_arm_srq(struct mlx5_core_srq *srq,
 		     u16 lwm, int is_srq)
 {
-	if (!dev->mdev->issi)
-		return arm_srq_cmd(dev, srq, lwm, is_srq);
+	if (!srq_to_mdev(srq)->issi)
+		return arm_srq_cmd(srq, lwm, is_srq);
 	switch (srq->common.res) {
 	case MLX5_RES_XSRQ:
-		return arm_xrc_srq_cmd(dev, srq, lwm);
+		return arm_xrc_srq_cmd(srq, lwm);
 	case MLX5_RES_XRQ:
-		return arm_xrq_cmd(dev, srq, lwm);
+		return arm_xrq_cmd(srq, lwm);
 	default:
-		return arm_rmp_cmd(dev, srq, lwm);
+		return arm_rmp_cmd(srq, lwm);
 	}
 }
 

-- 
2.49.0

