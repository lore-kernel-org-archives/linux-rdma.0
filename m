Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013071.outbound.protection.outlook.com [40.93.196.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0846B4AE8DA;
	Tue, 15 Sep 2026 15:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486471; cv=fail; b=WdleCeCbp5ev4axCySwHM+MW/nmKrQ7vwCl0/SqwLk+azBZT8mSEHdw3bQhAS/rymqkIsrEgM1RMibXfhatgs/HLslsL57n6e9Wmancewowmkkog6qrHaj6tS6Ns+cqMQ5hMGvaXkQRzQNbjpuhY5cCauMG5zPiYD7ixztnfrqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486471; c=relaxed/simple;
	bh=jYqaW8Wb2HPfyozJsKgeEHSCU0Z5ivW+eLUwzkImkcg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=suDWlnfo0vmm3663jPgnahP0kk5TrTfJVVuZ/vmrJagSC2EqLLW9r1FY53RjPsGEe1QRoIdgBPhLl/kmlsZszi9MCpgSMm/u56kArLv+jR1DeqKtkvJ412mK3Y9pq6w6NP5m+scsaI8VW60rhuvyha7f2O7OYNrOSNLWYuYGi58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kLg1iDUN; arc=fail smtp.client-ip=40.93.196.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kLg1iDUN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FyS5xZCVA2H9PCOYGH9ze5TlnvfYEnn71gbrdmIMwXoih3AW4s6FPFhKmzd5YDllMigfxWCDzU1HLHIYdjesKE+kI2BUp2MjX5hOt3wrZpM2DqgrASRRHIAjg4JT0lP5UZ3PaD6BUR9ZE8acU+Nj9PtJooeFwZ8+v+pRYrXpW0Ti36G+0M+VpNz+YGxNBAv0sRC2TnP3sJ1Zba7djlvT9Z4CqndA1JP38J8WfnyyaaRwWaCvify/p9iqCxXCejVtNJ3K7GrzvugZIzErlM5+qCwWiSE3x5kQNkC0jqlu1jd/oHkRNSi68l5OGC+ljBd4ulbE1G5upJODwRS1Posa6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YImFNn3YTktbrZQbyyxB0p4p/XXeMmcwGhTo1rs+r0M=;
 b=uYrP+MwHc+AILdGhG7Us3kufEkrh6kj2lR8vKx9FmkOSEvnb/6y3df5nAbp3Z6FDcGjosv1T9oyfy2N5xGQySXGgM4bHvVkIZ6DP/Ta0B/jgtM5YUIQp5d0JUR8QC67aRk+SP9GU3uqqG14523CXLQgpzFRHLwKkg4msZTFd0pspUiNzFWwlPXO4kLKqfFIe7/agzrn5TVMO0p41NGVHxdxUDQ1d5jIqKPd2pR52MocGJyRnswTUv1+Fkulhk+A9Kw39W0ot0nWP3DGiQsxdgdk6/iA1X3RBfgA2Skp0O1i4G13Fx8ir7X9ho8tQwtQ0jy1urNd67u+r4XNYCoUxAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YImFNn3YTktbrZQbyyxB0p4p/XXeMmcwGhTo1rs+r0M=;
 b=kLg1iDUN9xPh3uOUWFfxE6Tl54Jc/texz4vt9H2gVIZa1YphM4EdoQDsOii+HUVWkIOiKQEv2eCo3TlUBDxg/KhFHTJkot5bqLld7mrTWpd7LqKfpQOsCaZX8DOqcESAoOXkfJ98LKCJtcrJcVla6gVI+4tqmXbup78PKEUJn2FEwwI899sajJvyVpJSQ0EkVUoDsmVRaM2/9hSPHYk7BKrNM8Ub+8HZcAAt+cI1ZM/o8aL96StU4SFv4hRAiE4bPHneH/dvENaXZ1dCtlzJiy+q8t/VkgD3yv3yRDoQZczdN0WOEplzGSN5TIDm8SgBgFpLt021ZdgFYvxS6fmeKg==
Received: from PH7P220CA0039.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32b::26)
 by DS2PR12MB9749.namprd12.prod.outlook.com (2603:10b6:8:2b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 15:34:18 +0000
Received: from MW1PEPF0001615D.namprd21.prod.outlook.com
 (2603:10b6:510:32b:cafe::4f) by PH7P220CA0039.outlook.office365.com
 (2603:10b6:510:32b::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.10 via Frontend Transport; Tue,
 15 Sep 2026 15:34:18 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MW1PEPF0001615D.mail.protection.outlook.com (10.167.249.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.0 via Frontend Transport; Tue, 15 Sep 2026 15:34:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 08:33:39 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 08:33:39 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 08:33:36 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 15 Sep 2026 18:33:28 +0300
Subject: [PATCH rdma-next 1/4] RDMA/mlx5: Use unsigned comparison in the CQ
 cleanup loop
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-fix-cq-cleanup-v1-1-e991944cf898@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789486411; l=2353;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=w3KfI49/aST05m/4SxUHCD1Bldm1TL9vaaDCBBFDrA8=;
 b=4XzuF2qwZIe3UY6gAD9SEe4OPSPr0ULo1yQUdXeKzO8IcygtrfXEqVzljZsnI8DsZCasWneIr
 z8Nfvc8OB6NAt09kZ1NenT0xWnWcXHZwtqbfEctx8h1bullQqoU0UxU
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW1PEPF0001615D:EE_|DS2PR12MB9749:EE_
X-MS-Office365-Filtering-Correlation-Id: 90366cab-3b1d-4165-7fbe-08df133ece84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|1800799024|82310400026|23010399003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gk1PN1+W6iDqSOjGYulVfapYDBeMbrvUOqfJMvXnhqSHmxkaQ30viMcAhATja2Q3dQJjMp075EB+ZKjSwtUM9+tMSomM1/KyBfkW6pukqEQHOmqEvI/mGKZdAnWjzQwPXBet6WzlX37gaoIuHgrGhvzVPMPTZgHmQjiTYq8/uPvQQ++5fRG6zHTOx4KxubL04hXP7F5y6EtUBCp+ANAcm6i3TgjjPJnlIenOmsoIomMzaRc3WwhNI0UzVXTrr3RiB1wQubSITxbqifSScU2koKEn8YhXq6OGuVKgyF8SCi553XdqiL6WGZiv/mE1dgMryKr2kKT1R0ahonixE8r1ra2f0Q7Ih/RYrm0QpdUhkdbjkIQ7EkmKnG06jBrM5VMot+SXHkEzZiKE8PN7w+GCiREfGrKDsUo4Nf9g+8RDkCrWWdJP8Qi3e/CKoR4rHwNsN47wTQL5Wm/M9JGjl1Ej2TmbSJGxCo9JVhEnT2/x1KhRWfvCMd7fLjTtpmUhvVAdMbJ3CEGyk4EGjt5lG73ALh1hjhgGqNkcuitHKLOwl7ajLl22dg2Qvxf1XOThVRtsxIlHCsTtbVxBegYwwiV1+JW6VDbuOfgQLzQrwqUigpGl9D6ceSX7zNr8UxB2RtAgZF9Pcv8ITGU1rTidpbmtYjoVQbAsaEIZbNYQRxgSgkAdWHkTQaYu8Qf7lR6BZ+P3UJotLAubutkRT7h/UFsMOA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(1800799024)(82310400026)(23010399003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Pr0pjSnGBHTJVZ39x0SdV5A7aPVGJSkYpgpCi2b2LUkxy+yDnBEN0iD6+D8JFURHy3tS4cHKI0G3yujSFsTG5USgBIsXhPNGHON7vU46A6vGHPesMVzfpKex1EPTilwFZ60Htath5iodl8AzkdBbPzbgBKCdMlRancjJ7LOx5j2AenReKGiRWGYJvocItBtg12nmSv028e1jns38mqD/nzPcgiO2M6hcdmHA1cn7SYvLMSuKE3lD68EUJ19osp0/qqgTaPekAhE8G9FoXGY6BpD5LX5pU8ubkEy2T1+oD7/63KkjgwG8XG0X6+DfEQ22ZXk6IPQExavBPlh5LqZERNUH3X9F81F7O1j3ZjQAQYWXNH3N0k6K81KGn7iLlaZ95k9X+NdHNbxekaGaXWwEVTEV7nKLl9h1Akq0uj38baE7xIjeZ2cpamf0Jmv8to+l
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 15:34:18.2614
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90366cab-3b1d-4165-7fbe-08df133ece84
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MW1PEPF0001615D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9749

From: Yishai Hadas <yishaih@nvidia.com>

__mlx5_ib_cq_clean() sweeps the CQ backwards from the producer index
down to the consumer index:

  while ((int) --prod_index - (int) cq->mcq.cons_index >= 0)

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

Replace the loop with a plain unsigned equality check instead.

  while (prod_index != cq->mcq.cons_index) {
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
 drivers/infiniband/hw/mlx5/cq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 49b4bf148a4a017079c93a9b267690bf3a23169a..51892911e32a4b1c90c80e36c523e1906feeab8b 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1169,7 +1169,8 @@ void __mlx5_ib_cq_clean(struct mlx5_ib_cq *cq, u32 rsn, struct mlx5_ib_srq *srq)
 	/* Now sweep backwards through the CQ, removing CQ entries
 	 * that match our QP by copying older entries on top of them.
 	 */
-	while ((int) --prod_index - (int) cq->mcq.cons_index >= 0) {
+	while (prod_index != cq->mcq.cons_index) {
+		--prod_index;
 		cqe = get_cqe(cq, prod_index & cq->ibcq.cqe);
 		cqe64 = (cq->mcq.cqe_sz == 64) ? cqe : cqe + 64;
 		if (is_equal_rsn(cqe64, rsn)) {

-- 
2.49.0

