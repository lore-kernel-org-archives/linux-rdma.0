Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011023.outbound.protection.outlook.com [40.107.208.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC14F368D7B
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481464; cv=fail; b=gX+6Rg3jO7Ws07dxIgeKCkqo/Ak129UD718cB9YGOBERd/Og0wDvMPty7pftLevtN0OBJLKPCrq6eHDEkEdeaeFjrygUVFYm3Pa+Cq+SHEY0HI5HaBe4HPV+0UNDDGGqv7TP0LyJnAIdlsdEgeR4PoKwUqHfGrl+cSY+Vc8Qx+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481464; c=relaxed/simple;
	bh=IZ1QfPhxa9YpOEUUFVcXAvmKVmO6+GnM6Tt131d2QBg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X2uzh8oYoRcfp4/+KAYBA4djwG+Ly35EKDt6gVrgmgF+QimbwD55wl6w4hIJyn6aEhtiAdYv2O6fyDVt0addVeVoLV4o4L7qTNaBYwcMwN1UVrK5GbJRbuZarerhG2IkkQZ2D8GfUUs6UvAYxAuOJy7QYeNhdC3CrSP5K0QLNco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HpEiHhDQ; arc=fail smtp.client-ip=40.107.208.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HpEiHhDQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ssmEWDItFrDr+x/Dp1ENSEJGFk8HtMfPQ5BbVmMEHbG+WF+TIOjBtoHEPiTdefI2pDD7p3KGqFxg38/KejAiMxqIZ4Bo4oHfJ/Ra0lJoj0PfuZFc7wuw0ejHGlHNdchL7taqPYysmI8PFeRzsK6d9Hmj8TrXE09zdkVEUlZwTOvIU0sSpc5EprB8mah6NUjmikcVQfgiw4rYqPwaJxp6K+4se/+wjEHH+nVbLiRfo5T7slm44iydssAB1D6FBBboXX4jIC18nxE3kVBn1uBm1CJkCepx9KK75S+2S5QcJQ4NPnmJUN05Euj0iAk+NGmrJuiI8c7VUX8z7xpQWfscJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YIkpd5T4fuqsLOP6K/9fkD9uARGWSrJjpoTSig4uDt0=;
 b=F5k5JVMoG2jHRfMasY7e5VgRtYNPIswCmDZywKRiL9dhn/ChB8s0HNGbFzcGRmeb2OcAnSosOLBYG3UF48s6n4Cn+mEEYXfw0o4ccW9KmYIBFXcNYxuQHKXTsZ376v55XUiE+bu8X72wArY/j0wJerXPBjjSsTg1hJBGs3mlRlWT5FxRy1tB1jyxdoOKNePsxhtJvXsjOUKgzMALvlwFReTLX4dssy4J89yTVWY4rMvtGLKV4E/TceUs/oWdvJgSJp4FE8jzYO5ZcT+SnExakCWv6pPowtnl+HxUYw8zl91NS3Yhy53f4AXPMvkLJD8U5k6fA+Toah0PCno4vAjeog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YIkpd5T4fuqsLOP6K/9fkD9uARGWSrJjpoTSig4uDt0=;
 b=HpEiHhDQbvGregSwwVMbEnt2fr0KaakrOzvz4k90YItw0Ovg9R67B4BrQz75y/9HEUvvO+4SSiWlFjpp57KW8avRcWBAN88JorqUFVZ8ieoQdVfrKtaD8JyrISoWbW/HjkK7S9bCKrnM1rCJnnKQsXrAb1CqgxLqSZymtpksbBDvNnV183OK1sBXKfrJdNF1jFp0CzE4fbHXpB4/OZaDfmXLZ0zLlVM3inEVsXeRPvx1BDvir3suHAfpbyEOpkgMojLys9vzC5ysU6mX3qZvVe8fYM0EXh2IBCILoChW1zNvCA2dJadObW5yjQHREBuRVE9rE0/iNK3ptQYStWU9jw==
Received: from CH0PR03CA0030.namprd03.prod.outlook.com (2603:10b6:610:b0::35)
 by DS0PR12MB9400.namprd12.prod.outlook.com (2603:10b6:8:1b6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 14:10:52 +0000
Received: from CH2PEPF00000147.namprd02.prod.outlook.com
 (2603:10b6:610:b0:cafe::3e) by CH0PR03CA0030.outlook.office365.com
 (2603:10b6:610:b0::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.10 via Frontend Transport; Tue,
 15 Sep 2026 14:10:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000147.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 14:10:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 07:10:24 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 07:10:23 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 07:10:19 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <selvin.xavier@broadcom.com>,
	<kalesh-anakkur.purayil@broadcom.com>, <chengyou@linux.alibaba.com>,
	<kaishen@linux.alibaba.com>, <tangchengchang@huawei.com>,
	<huangjunxian6@hisilicon.com>, <abhijit.gangurde@amd.com>,
	<allen.hubbe@amd.com>, <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<mkalderon@marvell.com>, <bryan-bt.tan@broadcom.com>,
	<vishnu.dasa@broadcom.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 rdma-next 03/15] RDMA/vmw_pvrdma: Pin QP and SRQ rings writable to match device DMA write access
Date: Tue, 15 Sep 2026 17:09:21 +0300
Message-ID: <20260915140933.40580-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20260915140933.40580-1-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000147:EE_|DS0PR12MB9400:EE_
X-MS-Office365-Filtering-Correlation-Id: 351eec78-8d54-4fba-d86a-08df133326c5
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|23010399003|1800799024|22082099003|10067099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	cF68e5xrvS2iW4usiyzG+o7hz49j43ik/QJowq7RELfY8BUI2yO8K5WO2o3I0iSs2My9RwAAIZwNQ7vhTyVo6pQcDZ+2M8Cj6lY+gwTSirxbMNQblsGHDrgLYDjBlfnnQxS1N08p+q84TjseWDJ2r/953HkgEcAermSniyKLng2gVVwt0k8D7s5pPy7NWMOchq+01UGAtovTtdjK2YSlqFibaGh/lNVFvABrsdR0O7Cgi7Js4YrVVsPb98H4hK+diQ6upsFqJxuTddtEgbAzo6W9a93nu29b/aoOct+wqfmDpL/XJqfwBZROtARgs1Ha2hJ8cCxhPhRUDCdqkf2P7/nzqUkqPfFLtWqfmpY4GplIwyMfS7Q0GteBOvo3ct+jpFdALbC63soOfNC/EUyArZAask8GXp5mk9BJPWhzL/1fRJBRSIqsLHCx84gBPCw+RUXSUFheHff5CeO05f+/gazBW5i3il4rXh+wi64EBzLmDZDe+yAEorZ4J6vQdhYPf+Uxgv5R6HBSsspLBvoyXfNRMQeT3kfsJJFRIB2rbueY7eOkeeLV2ueH6stWsxipk0IP9Iw8avS0t83dD+6dEdVcIxEP2El1CGa762ZICl9MIdM+Wcf2NfeIP7+wXBdTP+Yf1ItM1itBYQ3AoRsaFRQkiBdzUegdikNdoGxTtaVqFrb8fsYquwz8t4bpzSQO5/EtBIz0umWxxKzaXRGWvg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(23010399003)(1800799024)(22082099003)(10067099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	i88v0P2rWanrI3EyhYQKYcfOtAs1qCPf84hHDfIfWEIk9MdL6zvdaAeo8hSlajSXdQ5YSlpgygv0DjLx2FmLqtsOwj9iZvXQ8J7E+HfMWdupahUK8QuLSOSyifJyETROHdBfZPLvvd6cSxwkPkMiROEEmlv4R2g6LheRHooWXtarVC1HPImgmT+mT6DPuaG03f52Dvkcwaq0/IK2ciQQg4BVmNK4opyCSHc6srl8gw3djm1AJErDJFFZymTaH+wEBlHLaCYmDRQAdVwcygclS0sTDnPDehZMrUnGvx4o7+ZshEO22mHoJJiSz89xiRVlW3NSIJKxUWqAjncmbytRTPy3fhykxtMU05xJFQ03IBOcsJn6jgU6EWRm4SdQs+3WtuQMWsmmt2PAGG6rqLNJVNY7RtN3jbaa+TBcBluPMBfcwDnxuoAtOT5Ox1w6T89X
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 14:10:52.3172
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 351eec78-8d54-4fba-d86a-08df133326c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000147.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9400

pvrdma embeds a pvrdma_ring_state header directly inside the QP and SRQ
ring buffers, and the hypervisor writes cons_head into that header.
Pinning with access=0 does not force a private page copy (no
FOLL_WRITE), so the hypervisor may write into a shared page.

Pass IB_ACCESS_LOCAL_WRITE for all three rings. The SRQ ring_state is
not currently used by the driver but is pinned writable for consistency.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  | 6 ++++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index e939cd5ce40b..53cc49f2b8c9 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -270,7 +270,8 @@ int pvrdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 				/* set qp->sq.wqe_cnt, shift, buf_size.. */
 				qp->rumem = ib_umem_get_va(ibqp->device,
 							   ucmd.rbuf_addr,
-							   ucmd.rbuf_size, 0);
+							   ucmd.rbuf_size,
+							   IB_ACCESS_LOCAL_WRITE);
 				if (IS_ERR(qp->rumem)) {
 					ret = PTR_ERR(qp->rumem);
 					goto err_qp;
@@ -282,7 +283,8 @@ int pvrdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 			}
 
 			qp->sumem = ib_umem_get_va(ibqp->device, ucmd.sbuf_addr,
-						   ucmd.sbuf_size, 0);
+						   ucmd.sbuf_size,
+						   IB_ACCESS_LOCAL_WRITE);
 			if (IS_ERR(qp->sumem)) {
 				if (!is_srq)
 					ib_umem_release(qp->rumem);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
index 345ec486a223..3252c2eb405a 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
@@ -146,7 +146,8 @@ int pvrdma_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *init_attr,
 	if (ret)
 		goto err_srq;
 
-	srq->umem = ib_umem_get_va(ibsrq->device, ucmd.buf_addr, ucmd.buf_size, 0);
+	srq->umem = ib_umem_get_va(ibsrq->device, ucmd.buf_addr, ucmd.buf_size,
+				   IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(srq->umem)) {
 		ret = PTR_ERR(srq->umem);
 		goto err_srq;
-- 
2.18.1

