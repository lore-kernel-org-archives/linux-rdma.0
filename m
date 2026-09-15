Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010045.outbound.protection.outlook.com [52.101.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FA83BB132;
	Tue, 15 Sep 2026 15:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486465; cv=fail; b=jncULW4dlX2xwIdqcJ1GmKO8CYsHPfca3YoOLdUEOFJg11hmTGw/D2RPi6Iu8DpLBwChmGjlweiZlj/QpI2Z63EZIj9O6ziMP+3eNWR6LKGnJvss3HNPTyISO9G/9EtxhKcYkqPb4Jf0eUcC6nicYlLh2y9bdxmY4AlMcVmeoVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486465; c=relaxed/simple;
	bh=E7yBS9aMZoO3Vt3CDMCUCI8oh6RjHKWriJVU0LH+WJw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=dYZgvqFxm5gA3TRyLPoOKchmDGvax8YOPx/g8gECuxBj0D0+jNLdq5+ewo9tSdDf8/pjRhyUisZjr9KFr66Z8ZZmt39rZsBvT7zhRGIF9345qlcLsGdXeMGzZynmZofIEbUFNAvHEpLjcYDdjv8nAqr9cBJNiH8Jim6OexIPBcg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LgZA7apB; arc=fail smtp.client-ip=52.101.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LgZA7apB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BEDjL27ZMq/swzMntekgdIlgeWNE4riwCd/6951btZxAfeFKQgUCWzlVS8KvgWGhd2hl/kg5NrV4UGeBUDTuxdVHgyE9n64rgYm+pL1Ur3nRR6qcn6SGX2HApUUuVYhmT15ItTtlmZkwgETNa2no9HWvReYSxjZSfv7cIXy1bFuhSyNGFSjC5tzBqm/hcCN/F3llV0EQATcfr60LbghiP+aM/pWIbD//N52isguVa4QsI4qTwNfYalEErNKC4PrnnK6FDgVd0Gu3IyU32RQl2KiwdZqncmFhJJYhO+2JdRj16nObaKVodM6G7d0ZU5xLG6pTF+046e/acOB/bHrr1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5SdFINoCYZ4I0rTn9mfFhBdNIp2fsJBBcWdOrAKwmmc=;
 b=OE0PyOTpVoeYn6ZDKpocFiJfz+JX7icG7Yr4/raxXI2/7Omaqgc4ZS1RDDoX3WNm+EQaidqz5aKPMxYsk1iQdvJWlra0YNpfrGZej15QLN851lOlhlRkjPFbY0QN5dQuo8xcYji96U8bqF7a9NPi30NsY2x7Z+LRxI2PIhutMHUKQL6WbG6OzCF1eVKBVp/YO0N8+h3GXXLOroHSYaGP0KqARt3WzLpX/WKcZ4cipIaAVlIiOxaghrIJ3SWsNiXoRlYELyPNVmhwcdTHuFGE+Ucntzd6gRSbY2ZgqIY1B6qT9rOg8/2jYGSgDUoTvc3osA0j/BtgyP9a5BC7A5LUjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5SdFINoCYZ4I0rTn9mfFhBdNIp2fsJBBcWdOrAKwmmc=;
 b=LgZA7apBdxowcICKf9EGg5nKF42uNQxH2TO6F5EZ4VFztAReM25OWpYdp0f9JYg6pTSNnPH4iqJx2AjuJMSa/BVhTNdvAuTKRbg8JJTDLyW/IWOLFzNuihD1QEJfGacLRqfrm8xjKFLqKEgp/i5C4jMQ7Nk/3dDvFuNIAhBu0O9u3frZuIrD2yY72Cwfele7s30dz1VSypD3+JncKUgHu5N+8nEBEUnONLM1Xwuj/5ovjdXY7Ga6Vst0BCCrJoGMSLfrME+IxR5NacVxo+mUDr6Ht6irTqWR3l3Bas8hgRElx46QWpQZjAiTi10IABggxKbpGb9XV9ExzXEQPiAYRA==
Received: from CH0P221CA0009.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::11)
 by MW4PR12MB5603.namprd12.prod.outlook.com (2603:10b6:303:16a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 15:34:19 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:610:11c:cafe::39) by CH0P221CA0009.outlook.office365.com
 (2603:10b6:610:11c::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 15:34:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 15:34:19 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 08:33:47 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 08:33:46 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 08:33:43 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 15 Sep 2026 18:33:30 +0300
Subject: [PATCH rdma-next 3/4] RDMA/mthca: Use unsigned comparison in the
 CQ cleanup loop
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-fix-cq-cleanup-v1-3-e991944cf898@nvidia.com>
References: <20260915-fix-cq-cleanup-v1-0-e991944cf898@nvidia.com>
In-Reply-To: <20260915-fix-cq-cleanup-v1-0-e991944cf898@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Nathan
 Chancellor" <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
	Yishai Hadas <yishaih@nvidia.com>, Chengchang Tang
	<tangchengchang@huawei.com>, Junxian Huang <huangjunxian6@hisilicon.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<llvm@lists.linux.dev>, Edward Srouji <edwards@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789486411; l=2346;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=m7xNUR84G+12GRtitfEsep8FMplbglDBsqZs9oE+rPo=;
 b=yA/QztXBc2fDbXFdqpOMr0+arQwYYcHEKM51DG+V5baLuqU0KW9TqKQZtrpNd2H2c8rxwiUUI
 bRlJUaLEjmqBjSDmsOFge4ClXy2oBVTTTbODj4bK6/MYdbzLGKe5lj5
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|MW4PR12MB5603:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c1699a4-4e01-422c-8e03-08df133ecf29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|23010399003|36860700016|22082099003|18002099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	UT5YTRKjYymcjJEoj+qL9dOAUuwWT42I0e9j/p1SUArgwn0FeBTEl+IkmrCOVV/jFdrauJ56i11mWW9TlsfmWC0V/QcJNMaDW+YsNn4PyfQ/utOtEzhytawcXnV/dLYxwdQjLDuW/YVUWkF4AEZQkW7eZolQQcCOGAv82bAo/h+ceiQqD0foS20Ez1jXqRUEjl77WMUS9xjdFTW/9nDffREiivIPXQoAcp8VfrfXUZ7W/cP0vpsfcLS04Wkv5124eNuL7/4ROdCcEx6+fxdubYhZbnLMppx/mMSnoewcPqXrkhDa0cv7siFJps6699tdLzy7ejDwLlA1zABQliSFRtMms+j4+t9+VAaP0cISv83EZLp7k+T0Kr9qAbgE5ucClTmn+P7RwBzSM6Oz46+gAudLC5GBrAjcUou9LIVLpA+l1DNmK31kVpnChNi2JvLy8oD92ozsRVYK43eEAlw33Bh7pZtIP1mD9T37Io02wc+BD41Tl4bzaET6AJbBwMy0jlhM7ay2tcqnBu7eTo3OinaK7U9s11vYPqsFhV7jYj7fc5dHvXx8GKzwgSzvWT6USV+nwsf3Q6t+3V3DVUcOsL4ArpqzXSqnwFT/ST2oYRPFBfPi63HZrnIYSxNI1fJQNjVtNQBC7lp8UnVmbWYcjCPuLRxiOe11CXrHzYRJ0BPsgahjtpJ0QlpoE37nQLnhdw0wVgGsyX4CuNZ8FDK9PQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(23010399003)(36860700016)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rC0EgjpdCPuH1zU51O6oHUZ4T6tm6pA54KrYE8vEScyo0f/iAR8Z7zd2lOCNFaDtedAz+n9AtUMCFIAZWT0Tuwtfw3Iky26wwJKYSf0Av+a71KSNa1vUjnFfrD9Pyofe0a6pXn6NK8msf+nIl8I2OPT0z8rJZOXoOGRO3RXizBCD4zlhdxVbc6pPEGz/MtuhS1DU6CrkpEDwdGHKlvmfkZJjjfEErSbekdeFWZfGNVVf3SlMD5o7OX3ahpmUzWrpuwS6ny6Ed3K7WaNaC1Zw0ZZPWxz+KyBWT7ukF0MoaAouHnJxzTKhOmWzcy0zCNxX/B3lExI3Pg7c7nfkhLGgsIDmCwL7zbl9Ep3KH5rbez7Uo2CntqCUd44qEoAehPH48skJxYLhtvN5YvqqdQAxfSP26oCOLgVmaPZcU4DuVxgr1hbJ13zIV+badx/yE0pv
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 15:34:19.2601
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c1699a4-4e01-422c-8e03-08df133ecf29
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5603

From: Yishai Hadas <yishaih@nvidia.com>

mthca_cq_clean() sweeps the CQ backwards from the producer index
down to the consumer index:

  while ((int) --prod_index - (int) cq->cons_index >= 0)

Both indexes are free running u32 counters, so the comparison has to
be done modulo 2^32.  Casting each operand to int and subtracting
does not do that: the subtraction overflows whenever the two indexes
straddle 2^31, which is undefined behaviour, and a compiler that
assumes signed overflow cannot occur is free to discard the
subtraction and fold the expression into a plain signed comparison.
That comparison is not wraparound safe.

The kernel is built with -fno-strict-overflow, so gcc and clang both
retain the subtraction today and the generated code is unaffected;
there is no known user-visible impact from the current code.  Still,
correctness here shouldn't depend on that build flag.

Replace the loop with a plain unsigned equality check instead:

  while (prod_index != cq->cons_index) {
          --prod_index;
          ...

The preceding forward scan starts prod_index at cons_index and stops no
later than cons_index + cq->ibcq.cqe, so the two indexes are at most
cq->ibcq.cqe apart.  Decrementing prod_index reaches cons_index in
exactly that many iterations regardless of whether either counter has
wrapped, because the loop no longer compares magnitudes at all.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/mthca/mthca_cq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cq.c b/drivers/infiniband/hw/mthca/mthca_cq.c
index 26c3408dcacaea9a0187257cc16de1b90f43fa40..39d4ff15849e7f8c2c3d47b4504306a4a4431c5d 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -300,7 +300,8 @@ void mthca_cq_clean(struct mthca_dev *dev, struct mthca_cq *cq, u32 qpn,
 	 * Now sweep backwards through the CQ, removing CQ entries
 	 * that match our QP by copying older entries on top of them.
 	 */
-	while ((int) --prod_index - (int) cq->cons_index >= 0) {
+	while (prod_index != cq->cons_index) {
+		--prod_index;
 		cqe = get_cqe(cq, prod_index & cq->ibcq.cqe);
 		if (cqe->my_qpn == cpu_to_be32(qpn)) {
 			if (srq && is_recv_cqe(cqe))

-- 
2.49.0

