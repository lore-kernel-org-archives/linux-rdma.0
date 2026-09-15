Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013046.outbound.protection.outlook.com [40.93.196.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6503B5314;
	Tue, 15 Sep 2026 15:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486465; cv=fail; b=eVPGYjB8TfTczkimYSIvM1KFiq1kMBiB/sx7PvXsEM5UezCgzY8wwHm2ZEtuQYab7qq4/X42n4sPwqEMD60nSJ0wB2ZqM6Qh1BfTtHbQv0OeZ0JSlHbFZbPZ59lXLEMDA+hyR2I3vnGM5/8PxvhcpGhLOiI5/5GUf3Xgg5ORp0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486465; c=relaxed/simple;
	bh=STyrSHmGv5XDw+eLxhC6i4LEPyqaCv+d5oMgRshD3i8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=eS74eu5jveX+eZXYmE1zb82WqsJz6ZHggrpm8i7+vslAbOkWyZ29IdU7r03UZM6Qbeo8tXbTRdO0GFa0tlJIwrBwXasnh0nJ3sqe/KhooEX3pebxIgO0J5/xbW4Y4Ro9Kx87ubNnkvCKaETn20PW9KIGGswwrv5AYJoc/U51Aes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Tio9UZQQ; arc=fail smtp.client-ip=40.93.196.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Tio9UZQQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iiToBqt7Q/7H/OczW850n7RWa7B1XjKmfQFH14O+fC7BglRz/n7WyISAXjOOGgQo2UXNkBU1WDDOxwAXqOIFkPlLH09h1AqEmUJEbOoQJMdQRdilCu5aSndll3BRAoLoZJp0BMkfWznj86Fhm/52f7siURAo33KPMgBYVw4AXA3CHYN3ZGmIMSqOz04YHGhnEkPPO3Ln2b0TUb1dqGYQJyZ+umemavQIMIbpqhNFT7iHTV6LQRr30yhHBVxA5n5cYQIvlbYqMMgb+ojL8Ask4RSVmSjd7IPiN82QaTdLexXh+3lIPv3swZGxl/uXi3WzxfAjEBxmr0UFxuEh8q58mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BUBPPrN4aDVbVHQGgOcnGKzfwx8H6ysL3SEwxpCtH0A=;
 b=ktT5AVn1qnv5E3zqaZ0nWtv9hKlP98RvqIjceziqz0gFNnPlutLFVp2qaj1BDb7UuuHI8yClOyPZRtaLUSsd7zGMa52u2mWKkGglR/JVKgH4TDMUvY6PjMYpkRTWrsLR4TADgsXd325SnHqJJFEqOsnAEqzjjwcjsySkZ6FRBSXPKdBUAY7QQndCj6POjhDAIJYwIOPRO7b4rAsGHAkG2lsJv6rcLtwkV+Xs/imydH8N5EOqxOpflw37yNmUYW9+XHFt7hP7ZEf5JC82J5zKxfEP0njlxlLEwpDNE6P5/l3NLr71L5PEx77zAkcRhT+omflMZzIN+Q1mcZHNDc3iRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUBPPrN4aDVbVHQGgOcnGKzfwx8H6ysL3SEwxpCtH0A=;
 b=Tio9UZQQZeVSN1iJDw8SIWxNpiDOGTL5mWz/qX6FXoOc9yJIa9Rh/afexOonOzAcBdv5jSAn/Ii/m6LSAzYd7m5ER8F6MaooOu5dwlTrIJfzRJKGMK+Rsl3IMRA1K5+Qk+4C5S+NKSI21Q1FJV66HzrK8anm7aiOCEmGjng4ptbhULG6PRt2OzJ+iqCMGEhdATlq5JJ5E2zvErMpg5V8EhDWrjkoJ4c0T+2X93L4HlsunvHi++KHNv0cd9S8kFKSAHkjzO+VrGT5BS0juoAXL87yF4HNKCAT7vvZCDSTASKLk/PTrS64Z1MCxiqHycXboZj1HE4GmGcPydcH+zrJHg==
Received: from DS7P220CA0063.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:224::10) by
 BN7PPFFC4F04B28.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6ea) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 15:34:17 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:8:224:cafe::c) by DS7P220CA0063.outlook.office365.com
 (2603:10b6:8:224::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 15:34:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 15:34:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 08:33:43 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 08:33:43 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 08:33:39 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 15 Sep 2026 18:33:29 +0300
Subject: [PATCH rdma-next 2/4] RDMA/mlx4: Use unsigned comparison in the CQ
 cleanup loop
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-fix-cq-cleanup-v1-2-e991944cf898@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789486411; l=2285;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=qDCVVIuWwQEgw505znA0f/vkbbnQjVwmxxKgONCC/ck=;
 b=Qva+HWFfba7/XrcvEJEwOt13O4AEaP4x3pkx5Y8GlzpeB/9gklVHJbrKCmgJdXgx5LMn4qs47
 mFl+cpJJA6dBH0eWk0JhbkaVGApVc5vZa+tw/UwGGXQRKTYKtA3ezwL
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|BN7PPFFC4F04B28:EE_
X-MS-Office365-Filtering-Correlation-Id: 54d9eff0-074f-46ca-ad3b-08df133ecda6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|23010399003|36860700016|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	HuOnnWIJzWcgcCMZkv6J6nfv5re7DepPxk/TiE0IEkgsCjsZCuL3yAKNAObQ4d9oKVCnn0LoBz7j4bEZLmpWq9F+GAHtLZx4vQn3zX19B4Gwwv4VQyQ8NbGzkUYm1fsUAvY/oJ7uQPfa7yWqVxo8EbsylHVAWUMCPK2XKuEd0A5aqckyMWDMDgCLZYbTGcz9ABy8A3KlGHSKUZInvyAi3BFsd0XSpPvI1LH7NAsPqlMdVQ/hU1YQizn2Kqxdgi+0JX6SsYsJWODrzkXeZrMQuSlEnar+GSkp/BwflDR66q2hiYLkb5sLj/ELCsOOafnMiMXZQxmVHRc/O7J8nWeZpsUd6XD6XIeFcgsvbADf0ZwHuI+46jY9fVmYF6Gzgaz88FQeWHV/okQJwO5Hcc47gGrJpbCORkHC0uu70tTrco1Q6CGqFg5qUZ37T89xlnd5GXESgx0EwtCEvxKWlu1zXPzu5DHJp/w1SKY5jG4u/fsQUwUD2fXyFDzQthglkw0duwoI7dl7ZuDVgkwKUsfexea1VHxA0e/2Sw6frlr2z4YaHy9iNXRYusbJ7vfgsHWIpRfV/P+g3w9C24HK3DCl5cQ1bkMCbQGWd+cL4l3SVf5HbLOpaf2gnfu7k7Rz8Vf7O/cSmbBkhPdsAlZvkkKZmVzE+9dSEGtD/nJRw9T4cb7izD94HjysRDy6W7XPbGfqiW8buHxyZ1sX/8GENUKU4g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(23010399003)(36860700016)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NHfpuHuaut20jgjVztmAmE+u9VwQEn6xrNxaYa957W4vYAggaUEcam/8KtJwkrzh4Xq+GcNgxs4YOp4tkqgIdc0Kt8nJPvkt3NxklMKopchS2nZGEfh+0ciCzKzf36TEugM1y1uoo9Za96s0yFlfPK51ZaxFTZD5HmPd5iY4WpvSBNUpJiRuSvRSVzRhM+gfbsZgPFEDHBkwVNFNbXTf9K3oD9Ei8TBRhNS1xABwieZDygEUS/WL721TXCUVYAtEmHkbWa/7AXNqMA5lDf/K80qSDCnH38mW7BnYT1RBNUTg+mzZjm52iBmwIUyeDB6T5+jVn17gcc5gToqsWozH5iqdH0DyohYYExPcGKYYKmFr8Zrlx0mmnZ7U45waPcci6p4ycpg63Oi0yxO+YflqByK1OL87Z3r5BfeVfCx/duVStw1Po3ufH+FRkTljHTvO
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 15:34:16.7121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d9eff0-074f-46ca-ad3b-08df133ecda6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFFC4F04B28

From: Yishai Hadas <yishaih@nvidia.com>

__mlx4_ib_cq_clean() sweeps the CQ backwards from the producer index
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

Replace the loop with a plain unsigned equality check instead:

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
 drivers/infiniband/hw/mlx4/cq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 8879124697420c2ba03622c2af3b350808dc0aa2..98e3eb5cf96e54efdec6e4d8c588fc865742337a 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -989,7 +989,8 @@ void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq)
 	 * Now sweep backwards through the CQ, removing CQ entries
 	 * that match our QP by copying older entries on top of them.
 	 */
-	while ((int) --prod_index - (int) cq->mcq.cons_index >= 0) {
+	while (prod_index != cq->mcq.cons_index) {
+		--prod_index;
 		cqe = get_cqe(cq, prod_index & cq->ibcq.cqe);
 		cqe += cqe_inc;
 

-- 
2.49.0

