Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012056.outbound.protection.outlook.com [52.101.48.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD774ACC6B;
	Tue, 15 Sep 2026 15:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789486454; cv=fail; b=KtzwRqPU8DQG0JD2BYcNyZGLiHh237ZHE4fF0EpZv6M6pwpeJacvEFA7p9FF9L8N0By+pF7gwyskrvrMNsLluRiQ7P4+rARMRXMjnyShw3zKxJ5A7vvIbcEmnN5A25BLwj5lncsQ6dliWzmpJwVs7qKYGn6FiCs6Xl1VMEaxiWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789486454; c=relaxed/simple;
	bh=pSFa2wSFyr6cGMdSkXfO5hqp1weLD1nNW/UJUT1Apdk=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=giM/XfdnmZfR5VvA1dQKlMcBjbpAemsmDchYDClVYJCsgYA7dG7hGDu5D4vX1FcEzClDF0LK4IyY2y+HcpfvjeZniQJ8AVgx68/Wf9CC1Dj9AghW0Qtb/+tYdhPxoYpi1POXoQLQuC31FfGq+CFrLe7Kfdh/zWw14zEGACZXfMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Uuv3Ptcy; arc=fail smtp.client-ip=52.101.48.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Uuv3Ptcy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w4QzM8KrRGUhBmoiYAz6u7om9ozIpPa+mbo60ZH0j0QgvxRaH4TnNAFwFKUWwS9VR7oYKhNeSJRxshMYz5QF3UdqrFlTiySj2Ruo6aICKz4HtHLKNG4E5L9ziAn1iUXfNSvGBpsigGnT8SU1o3Z01at336xPsOeGsH8GtQGnJDyjuixlls0m+Yu9EwxkzM/DnDgztPsVB4Knmo7lpCCv8HejWSDZ/w/ay7vvNiPoUNJ4CH18CCsU4iLhmakT3tOw62U5LtBh/msCVyt6eDjiZQ3cpczFFYWIUfx/UnGvHh1sXm+GifIK7koFtWrMddHV2lPzMt1AA8mp3gQ/03b8Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L22Rf2VjM86i82rgt9wFexwhv1JjA4UKqgAukYL3zLM=;
 b=wOh7jvj2Igr+BroZXWcnsl1lwrp0kJbEiFg2R31TcQjkWrvgijBazwhtaMvZE/1jLYRgr7IwL+B5Nk3hDAHwkgrtyk24QGlv5+vA0iNGqnbrK6R6e+ueZjhsQBuiz/bvheSZ/7n7Q9HDIlhql3li+zaY3gUbTMClXqKPnREo4InqDL/Eny0W8zbjpI8lTgel1RfLKjt6bJT8sYFoMAiK0hzpXiVJzRsJf2HRjd5SZLZjqowN/BIwKikdNTKiI6787nzMdGD3MJyvs2fc64HPS34aVhYhLIaWsnqh8cpVu3K80Nm36ibAvNPdR9xDdJuGrUGekbmYC5Nne5uXO1s7Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L22Rf2VjM86i82rgt9wFexwhv1JjA4UKqgAukYL3zLM=;
 b=Uuv3PtcyIkpDOymqmUdPLyorhW6sxTFGLxRWWeEBg8tX2bTWb+cynItobe8DQemQagqm8mBanod3j5vjyL//auXmxisBs16/EoDUq9CMtlJQmsNYx703j/i7P0EtzPSygMtDU1wGWzlo9RKggKUoLp7TLRy0C1o8zRSR46ZtLJEnYCzjL2ju4Jnzu9l/wQRBCLdR0dh0CK8hDAW4pn72L3AQt0AURXG5hH9FxxBDMWRtBr97bqLfS0vje71IRT/3wsTE9HTAIEIZmkyHjpS6qFm1wwyGbnOndYfcPOMoBByTQb8LXaIHHe/EgKtMI7POXPLxir+r80FcmTP1TqSAUA==
Received: from DS7P220CA0042.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:223::35) by
 BY5PR12MB4163.namprd12.prod.outlook.com (2603:10b6:a03:202::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 15:34:07 +0000
Received: from BL02EPF00029927.namprd02.prod.outlook.com
 (2603:10b6:8:223:cafe::5) by DS7P220CA0042.outlook.office365.com
 (2603:10b6:8:223::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 15:34:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF00029927.mail.protection.outlook.com (10.167.249.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 15:34:07 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 15 Sep
 2026 08:33:36 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 15 Sep
 2026 08:33:35 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Tue, 15
 Sep 2026 08:33:32 -0700
From: Edward Srouji <edwards@nvidia.com>
Subject: [PATCH rdma-next 0/4] RDMA: Use unsigned comparison in CQ cleanup
 loops
Date: Tue, 15 Sep 2026 18:33:27 +0300
Message-ID: <20260915-fix-cq-cleanup-v1-0-e991944cf898@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEdlqWoC/x2M0QpAMBRAf0X32S0bJn5FHtZ2cYthQ2r5d8vjq
 XNOhECeKUCXRfB0c+DNJRB5BmbWbiJkmxhkIVXRihpHftAcaBbS7tpR1ULaqqwU2QZStHtKxj/
 swdtVo6PnhOF9P/gbUTlrAAAA
X-Change-ID: 20260915-fix-cq-cleanup-6512d4346ed7
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Nathan
 Chancellor" <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
	Yishai Hadas <yishaih@nvidia.com>, Chengchang Tang
	<tangchengchang@huawei.com>, Junxian Huang <huangjunxian6@hisilicon.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<llvm@lists.linux.dev>, Edward Srouji <edwards@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789486411; l=1825;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=pSFa2wSFyr6cGMdSkXfO5hqp1weLD1nNW/UJUT1Apdk=;
 b=WHpJZ+oxtZ6CY47Nj8rIJqAex48u5wU35cVk622+a3C3jskUljyt6MFHL608VGspjL7emYMfY
 oJITh1lanqPABrcRRI5Vltbca+HrfJ/eQjAMCUQQN73IgK1gU9EDLqv
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00029927:EE_|BY5PR12MB4163:EE_
X-MS-Office365-Filtering-Correlation-Id: 38bc9f53-89d8-4692-2eaf-08df133ec7e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|82310400026|36860700016|10067099003|56012099006|5023799004|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	jIl/lN59JEqpzS5Ig3Y/1BP+Ohzw0R9Lav8YknQg1LnB0LsMwhBTqi6kZtxVi3lRrlbw4YbPFh2Ka44DtufQ/SujYvxjRVDsllw3fGMc5xZ94gyGIsONra4Fa9pORC7aEEgWFzxD8vPmKSSQ7CKlVTq+MB6Uu1M0iPjZYUi1Xjc3k7iLmFneEnNywJyncUUX3qqfRh4wQEoI+k4LrbUVLyd5Ov5j3MGX+WzRDH1btrgvOLvo/+NfdiYpXd5ZUuH8pWSkv5Y6L730+aHYh5usR8I5XVQ/oUDLUwD43i11WOjTquH8juKpE7SzDKAtBzKHQObyZFH3wJrLnkOyK/Zoa3yfG3K2ln1Rc2E1ca/6jHKUJQYYZ9Aam28S5kr64T5elZ0Q4FtDste58fc2mHTMwWZO5P10QjcskEXcHkfickzwqbAdNemaxV191tNSIt+vndJ4xvoQIsQRlUDXdaaf2aFp3YBDt5lPY+812g4hxP+phV4awM/Vs1YruOICoz5OZ1Y0wHlYCdZC079PKmIke1DZT6gmmEfRvbQtFCku5+5ElY9a4QvbytmhBo1/E1bclJz7Hzraxkspiy0dhRdSoYhyPK7EXcWuvE17elZUnkpTmaGxytf6DDvtERbnE2uvZdnvtAF8OGaaqFrTSiPm9jqISmFyLR8hfmPLCEKodZD0d3i9EB+/qI+OIwrDM+7tN6y2vxE3taLcpJfdSOyyBw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(82310400026)(36860700016)(10067099003)(56012099006)(5023799004)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LtDZJstDUcjKvArvRsvcCGYGkh9VsU10mrF4P2OvKCt/uCUdAK5ykoIr3PHGkGOuYelq1y1c3xDpS/p2DNjHW34jWsKLHK24La0gZnq8Nz9RKrLEe/CXDuinEpa8WXCis7UMv3chvyTHbzDCbBTPFc8yKoNcVprwkkU68Hpa+vnHayMjNAiaZMEa5dScYKjWni0dzU5SO+DzXCuO/hxwJiKDvlO127iNTmB5dlebrz4S+cQjdGjPkXC4rYz7miUU0bL4Hh23B9s6nmCb9cmkrJ9pIQ1OyDSOjwLoWOQmDkPcmbCb8w+shqn+/+R3vB0qOqVzfSe7/pcK5HpCdi30v7BfxCttmmnqMl9mirAVbrJPKjX0gzpjdMW9N8MYbFDncwIGkLV0A7YrRjSb7N138npRu2wj4FWDAFN8xqCPAZWY9s8YVxBPp+QKMKACC5ct
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 15:34:07.0902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38bc9f53-89d8-4692-2eaf-08df133ec7e8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00029927.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4163

mlx5, mlx4, mthca and hns all sweep the CQ backwards when cleaning
completions for a QP that is being destroyed, using the same open-coded
loop (mlx5 shown):
	while ((int) --prod_index - (int) cq->mcq.cons_index >= 0)
Both indexes are free running u32 counters, so the comparison has to be
done modulo 2^32. Casting each operand to int and subtracting does not
do that: the subtraction overflows once the two indexes straddle 2^31,
which is undefined behaviour, and a compiler that assumes signed
overflow cannot occur is free to fold the expression into a plain signed
comparison that is not wraparound safe.
This is not a fix. The kernel is built with -fno-strict-overflow, so
gcc and clang both retain the subtraction, the generated code is
unaffected, and there is no known user-visible impact.  The casts buy
nothing, though, and the correctness of these loops should not rest on
a build flag. The series drops the arithmetic instead:
	while (prod_index != cq->mcq.cons_index) {
		--prod_index;
		...
No functional change intended.

Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
Yishai Hadas (4):
      RDMA/mlx5: Use unsigned comparison in the CQ cleanup loop
      RDMA/mlx4: Use unsigned comparison in the CQ cleanup loop
      RDMA/mthca: Use unsigned comparison in the CQ cleanup loop
      RDMA/hns: Use unsigned comparison in the CQ cleanup loop

 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 ++-
 drivers/infiniband/hw/mlx4/cq.c            | 3 ++-
 drivers/infiniband/hw/mlx5/cq.c            | 3 ++-
 drivers/infiniband/hw/mthca/mthca_cq.c     | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)
---
base-commit: 3e1de7f906ab162b23d6fe0eabccf687a98fa25f
change-id: 20260915-fix-cq-cleanup-6512d4346ed7

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

