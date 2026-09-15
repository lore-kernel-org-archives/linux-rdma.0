Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013023.outbound.protection.outlook.com [40.107.201.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691844AF69D;
	Tue, 15 Sep 2026 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486481; cv=fail; b=G//+tlwBUs6UcJMLf4fSb3q3GAGpkfz2oB61z/U/LFqrdPAj8mhef8Z9Lolspfa+jL2Ftbg/yEvSj47K5rWByOlNuUbqTwdRMwAlTcq7en1x1WZFXeE2uSGdavELfIVXHYzf/B9LpcXqlv5/kzYkhEaprUaNN5dk1PQpjroN55A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486481; c=relaxed/simple;
	bh=yzuaFzlCz2bujTNI7GiyMJzCfFKaFiZZntaHxFyiYCU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=suv1aOCZ4kmljgJq7b4o4iezlpvPgT1Yqx/EU1C7jXZU57feTKosk/X26QId6Tl7z/Wnuh2zqZtt+15vgp1yKQ1FrVmHb9VzaVFNoBQ72XCoa6LtQ2LxkHObEfFLIDGNPUEug9MHFdXJDl6ssZfgds0DWSV0M+ZCqSwa6HsNB0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H4j5+SV5; arc=fail smtp.client-ip=40.107.201.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H4j5+SV5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wbr2F2LScnRAHmAbEkHAzk7ALaRx1Su9lvVaYtrnaBrZzdkW9IqntS9bW89572tB5MUQuEM+TH1hZwwCfdsJsDP3AuGr6EjG0SZzcBvMf0ZdDpPNyuG36Q6kc32l5HLPz0CXt7/Pl8/wu4UYBt/UzyMEqE+pY1B7GumbYJXQxOR8lsGhnYpFJCi6uNmBo3eT1RqUEzRxEPTzSr4/uGOAZ4ceLCBMppS/egkyQ0C1w0bzMp2rTsyLuXviPYoPL6O1CyNArUUENTrcQ1ljYyiReeLODYeLlKR0Y9edzaUOFLti1/GntCymAHxeBHnDqdUuSj74PJxH7sRqagsfZ+CPkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ebxJl3IcxbKP86g2YDnmC+ja54BljOviM2l99UpkSkE=;
 b=JHvdTl2nU+b0qrsBjoBMAFCBf1LT6RwDH1ZtB6yp8SQO7rWU4vIiECdEqWG5r2qbXIrvqbMyivNWfWNU5zqMY3PPPU9rZxDwJMi8WDVCOCKs2OzoGUvLbEddiOs1KXfbegOilVYMG7/X6xmPwOhBBo5YKuubES1Dbqe7m89DXpvBOnwfjTaCpG9v34F86DBw+bb7iIZRYdENbyFznenExv7VUCTk3Nebnjfh8bCIIumH7aUI2dBmmOEtzOjWxg7LqpGJsuI8hMLqC4OTkTius51s+vI6tzuWjvmuC2HPaZRuVvUhpD3PXK7ZEiVQq+p1DkTHbM4eEbQlYwDO9NIWiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebxJl3IcxbKP86g2YDnmC+ja54BljOviM2l99UpkSkE=;
 b=H4j5+SV5MyfE4gn+NMadSq9XzzL/hOTMAljDNfWv+baiQ2ukya4J/YLNS7CiT5uGGQrFc17dmTLc7PY6egVjmlqK0QwbhVWAF7tL7mrh4aNdUT4SKi1t2+mY5dURp/APerZEmNoJCkdkLf6LUDfTz47j1LhsHAHC63TprxgbCN7aNdmbujMH4n9H+SCVVs5SEJopYSdhQKcF9Xg+G9uV6p2mIh3IjRJBGsN9n/YNjbkdl0FmHNkg4UcBuXbqOF9kjrQEE7SwLfX63QRUjlWmYN6iFxplhzuUXaCxldbZlub7AhbVFokecdKO7UDz9PD/OUsAq8G+zPvGA31tD3gVvQ==
Received: from PH7PR03CA0028.namprd03.prod.outlook.com (2603:10b6:510:339::18)
 by CH3PR12MB7643.namprd12.prod.outlook.com (2603:10b6:610:152::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 15:34:30 +0000
Received: from MW1PEPF0001615A.namprd21.prod.outlook.com
 (2603:10b6:510:339:cafe::62) by PH7PR03CA0028.outlook.office365.com
 (2603:10b6:510:339::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.11 via Frontend Transport; Tue,
 15 Sep 2026 15:34:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MW1PEPF0001615A.mail.protection.outlook.com (10.167.249.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.0 via Frontend Transport; Tue, 15 Sep 2026 15:34:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 08:33:51 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 08:33:50 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 08:33:47 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 15 Sep 2026 18:33:31 +0300
Subject: [PATCH rdma-next 4/4] RDMA/hns: Use unsigned comparison in the CQ
 cleanup loop
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-fix-cq-cleanup-v1-4-e991944cf898@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789486411; l=2442;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=pRR2rulT9LjWnfdtRj7ngr1KMqIalpQzFAN80D2qHTQ=;
 b=1BTb5LlVb1E1R8FatWn53LcW0VoDh/XBO0HTcPEY8w7wsteJgIwmMOuISY5VWvZchdZXxEaYv
 jyv2HyBjaBhBBLBq1hiz0ry+0mz1orWBZprxD8++vlV36tsbZJxsVKR
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF0001615A:EE_|CH3PR12MB7643:EE_
X-MS-Office365-Filtering-Correlation-Id: d68ea436-c05b-421f-1ac7-08df133ed40c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|36860700016|82310400026|10067099003|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	CU7YzHu/eD03OWoFy6rd5vjTI+AFYbbPomk3P5r4jHddCUnWKwYS/zHX9d8dzAk2MDdUp5/b46E14msSWYW7CgT1OkvthqJHleVkI4fCMaDGj4/2JA4KYnyeiY0w05WwNKjKOJFbNDPpFcygxHyvqEFwOcWmMHw3tS7+UYd91caXsuJbW9UBnqCS2mu2HyKERi4PuTutjFHh0lyw1CBqbz6ZgqxYQSc/cXdXofsDaGCrvVkxu/WAMZfwx+4HLhMPSIG4fCsoNX4JJxn+LOBVDlW7d/yyH27FZFO+EWj/c2yPlnGbQplJ/eVNr84y+2nM3ZEnWi2pfkGwf9fm8PPRleAe+HfMmHy4W90iXd8x6vFS6GcVFf40Dx5SU11pc36XhT8uCkpdgu+rtBHS/W2Wrmj0J5CVhpebQeyAkS0i78SPU7sUSdlU7wLkyVbQKosV/X3UlXRGsn3UHZzcOZfpdmPxMYiB9Vu+wTSePS/7oVnrVTGymdObUsOzYr60qUS5FgBfBb0ijgb8vmZ9LIuo3yQj9tVKjXTLF7r8YO/isoN3IelVc24n7dLfPkKB2aXkHPefQ7ARwSoBxG+izmejs2VUbTNdb7Ynxbt7Vvh8dH/RdiIRpU0VL3w7ItF3bbhQRAfZ8GEIeyGkZu2fT0tp19isMEdnGdFSONaAAErzO6d9ZmtrdTCuoDqW/rjzdB9XjsSbtsHOjPSNeNWZBNY/zw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(36860700016)(82310400026)(10067099003)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TCNjhlqfyre6CjOSnpHTsYTd3ompa67wKFl6W4z8B5zuhCrIuuWQDPifimGmBq6oSV+1RJZ7Tg8TTNEsT9HW1g6msy/gM+Y/o++vxSd9l/O5JKK4haeHA9Toz4zy7K5V0wZgH/2kBshjyLvTB2aLYFnnx/J6MvI/xc2x5F1aP1i9Hiztr9Iv4KdTdEYGdz3A6bk/58J5Wolo5iUtU08pCiYwuguY77le9DhTfVm4Yjt+sRW21XaWcGTj5KfbGFW6EAdUsajXRevDBr5YKz/YY1fRId3OYZwwlH7GJCUv/f4hWcAv/GWDmotNwlB8anqsCi5PcAkNKs4wpD/NRpf46LNi+0G+QWYNOHnolsmLIGPGcvFYN2hS7yilWM0MRG5d6qPwuaX6+ScZ26q67RDIEEb0GuImg6v+6nCTJ/4G0ASh8AitD0G6SAxsJtJX9xNl
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 15:34:27.6045
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d68ea436-c05b-421f-1ac7-08df133ed40c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF0001615A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7643

From: Yishai Hadas <yishaih@nvidia.com>

__hns_roce_v2_cq_clean() sweeps the CQ backwards from the producer
index down to the consumer index:

  while ((int) --prod_index - (int) hr_cq->cons_index >= 0)

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

  while (prod_index != hr_cq->cons_index) {
          --prod_index;
          ...

The preceding forward scan starts prod_index at cons_index and advances
it only while get_sw_cqe_v2() still reports a software owned entry, so
the two indexes stay within one CQ's worth of entries.  Decrementing
prod_index reaches cons_index in exactly that many iterations regardless
of whether either counter has wrapped, because the loop no longer
compares magnitudes at all.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 1b2504301ebea4279eb0dcb2537c3574d0122d95..35be5b038f6861f1c330739f5c97817a4c3940a7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3828,7 +3828,8 @@ static void __hns_roce_v2_cq_clean(struct hns_roce_cq *hr_cq, u32 qpn,
 	 * Now backwards through the CQ, removing CQ entries
 	 * that match our QP by overwriting them with next entries.
 	 */
-	while ((int) --prod_index - (int) hr_cq->cons_index >= 0) {
+	while (prod_index != hr_cq->cons_index) {
+		--prod_index;
 		cqe = get_cqe_v2(hr_cq, prod_index & hr_cq->ib_cq.cqe);
 		if (hr_reg_read(cqe, CQE_LCL_QPN) == qpn) {
 			if (srq && hr_reg_read(cqe, CQE_S_R)) {

-- 
2.49.0

