Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795668509;
	b=iOID1wysgZBfF4D1G5hlpr4zOsEsqQoupxnTH4AM3WasNHyp9TfnUlNEb4GdAdEvBlhA
	 PFnSsS9qSfASqQgsDVlFKP7yZfZzysOm5q63MR0g/0RmRUcpghJjCQy2PBJMG98ACLoBR
	 fImECQDoWDzCPL6TPMlVMJ3YHB46lVcQnfwdsV/qESS/RlV7tm+3rMTcFyFMJlDJMBjDW
	 3CMwfbiRgvy33c79AhkJBhQJ+54Qf+vPYBN3OELrhhdKt6/fzafZboynfJGFRsZbBzwUk
	 TxNz7HlBKtGEtc+T0TBka1xWPtD4RfXcfFnfPiLYPaYloMqeDmq6ID8GqFS2jZuw8/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795668509;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
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
	bh=t46/frKB84oMOXWaY0bZfTbUAiQZCi4vZI9dZMxOfzM=;
	b=ePfonDEX54tDlAIiAc7Udv62XcM4Mtlczn2cr5Rr7vrRrXVLtSkeEtx59t8QdjseCvKx
	 RsuzpZt4DwKsrL8hJFoFMKmciLoVqXj8SGXruQJSUjgcTH8u9N1kd9APW5H2JwWM6Lbop
	 pXa9SpPTmvTJwaP1+gfOCOKk9ZP78rnIyPufxlxQVC2yEDLcwxRF5jAVdaddSqkNTXZvB
	 hpUU0jvI6iUEAjc/earkn20+d5r6HKpEAhHy/XoMwl00g5NeEShQIxGNMG5Q+/Hil+U+2
	 PGJF/Tpofg42mbYfjKNivJY5rDMXzL2lI1wcLMk2Uys5et37b+t8KV8VyNFp4aXRCNg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=YKJLd2d+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.44
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011044.outbound.protection.outlook.com [40.93.194.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DA9606A31C;
	Thu, 26 Nov 2026 04:48:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29DA9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=YKJLd2d+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dS/ZsTOReGnrch/Ic7ppr93IMiBE5OzZ7l7aLmJOb5mxJH2yvezUZKhAi/28SyyoqU8zxEE3YwfjMFjiVuHsJ4PEMhNRroJLEQCRGjFjxzBshsw5JBUmhVaci0Y9IoOMrctsYFDJl7i5lXjMQ04ihLVw1lmicbE1NLKyXm3/QYDgeBTjTBGBTQki93W8i5CVqYP7rB/Vyuxr5tPHiHhDz3975iZbAIKm26kzbuxSXkNqOLP17+WUIjAsx+LR+M7DGIUP9bgYLoKrTY/nQQaSnrEH2JVdOzM+h2aE9Ngq+NfqHnaUYc+YCfHM5erwSaUlJGnVozHi3YhUReUgQzswhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t46/frKB84oMOXWaY0bZfTbUAiQZCi4vZI9dZMxOfzM=;
 b=LTJphRsNhmm0hy9XfB9n7qCT97tJCPKjrn+kXWIBEWVJuO+MO44f9a3muW+VmJpbgywWAE/n3nqmSHVTn7BedsMTmS0Fu/eKHNNSo0RtFwPjFdHLSshWcd8hD18Hx7qivWA+rMuxdrks6wfZvMYjb47jbMdXd4euO9cEWdFNTd0Fx8lIzT0yZdOkJCLnY5F43NEBM3hgLftaOaZCUm7VPNGpi00U40JBe6yTVEUehhc4y09wuszTT85lfDtp0me40qSGfTx08C2b+wMqabV/9l942I4Uc1FInlc627Q7vMvWL/a+UcMs6wI+YTwTgdJlSenjJI8GIRW1RFSL5nZ6tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t46/frKB84oMOXWaY0bZfTbUAiQZCi4vZI9dZMxOfzM=;
 b=YKJLd2d+f/sNX5oxZ38Ik4WGbzZiIgKyYfFMlY3/BM3MdHjstZ+va3emaT9v7r72M9XdnLOPu4Qe/7yQo6e7NFTuLJdtbP0OdCXFrQ9N+gv/dAxuy227n8R0kX3L/qgd+NUIrAzxoCFwDVP+MupoeM6s/cCBG4p6L2mGN2AO4IE=
Received: from MN2PR08CA0011.namprd08.prod.outlook.com (2603:10b6:208:239::16)
 by SJ0PR12MB6925.namprd12.prod.outlook.com (2603:10b6:a03:483::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 04:48:25 +0000
Received: from BN1PEPF00018072.namprd04.prod.outlook.com
 (2603:10b6:208:239:cafe::ad) by MN2PR08CA0011.outlook.office365.com
 (2603:10b6:208:239::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 04:48:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN1PEPF00018072.mail.protection.outlook.com (10.167.245.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Thu, 26 Nov 2026 04:48:24 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 22:48:24 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 22:48:24 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 25 Nov 2026 22:48:22 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next v2 0/3] RDMA/ionic: Accept CQ, SQ, and RQ rings as umem attributes
Date: Thu, 26 Nov 2026 10:18:07 +0530
Message-ID: <20261126044811.3458258-1-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00018072:EE_|SJ0PR12MB6925:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f712f23-537f-45bc-f3e1-08df4b788167
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|82310400026|1800799024|56012099006|11063799006|10067099003|261022105027099003|261021121427099003|261021123027099003|261021135927099003|261026140227099003|261026121527099003|261028144727099003|261102123227099003|261009223027099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	SuCzM8tK2lTmIT9E8ftH5vmRENa3KBZ2+zlnXj6nuBoL73VC+GY/FT7+vNGvJSOkn3qXT8z5wfOkE8zINCzNm4V+MCSxmDS0DhWiDSqZAjx6Bkc4QxPSUrhQNi9lk4FBnPtYHzAPh7ZBPC6niMgb4Pndnouva2Mtu1xMRh5rqa8lIbfM2pcHlVGTgynH+IzSGNJqDtrSJQzXIMKlx/hc2q0Pj5eqRfK0tnoYmGiFhcxSqw79h7NiB7h5Wl763BRWsW7G1KPoUpaA6rP6NM8tNzhy9ZST/I/GMvcNi/fjL51puiNq/CYlBuKLs7KYuViU6k+Lz08BqFwgHSonGAzpkL07Hj5HFhy/8Vx99SKRPbqIZi0X2SpbXNo9N7BrsXzHSF48Mb7N/0dQBi8lbjfUNPz3N3qu+9+PkXmFoUdqbR+Bg0RR+VKVFVyw1N+d405yYHOFPcfTEoMLvSY764GnVQ9nK4lKlwYIOixZFEHxv6AqvwqzKb3pFxPhSGx0s/axKEnmdBEUHAb5HfhnGY/Hl4IMa0zLrgiONmXey/Y4ayjw3CNmg20jKPnwAEF5lsXbm2lP4taS3M+dLl1Gt7bZA0BMgaEm/Pw9gDpHoelDGQIQgDDxTodinQbH0Iv6cYu9knenxFjfOSu+OACtAYooog==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(82310400026)(1800799024)(56012099006)(11063799006)(10067099003)(261022105027099003)(261021121427099003)(261021123027099003)(261021135927099003)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	h4ra96Voof0VqHSumtn9kgBfjfL+yZYibKJBV4CJ+3qtLHnQORJ2giH+xpyWuyqXRnmvRYF3nJ+sOq/lcSe6Ns6fDP35B6/oyjbqtekvbijlSehN9QXK6hqjyBG2yOqOF/WtmTTaW351/KHlEsE45rS2FCmF9DATe/eycpAKaFIaaeZZ3SvlXAIttx0KFb5xU/qOv08uFoKpkUQIJrGjfgkUvBnNcew3cQft6yRBvO/wEXOm7K7WGoRhX4D+OyVnQwCoiVSnXNPZ3woOMSr8mqpeSG+cs9Vq6Bub5ZbDc9zYGUxmCiArnltveHunAveu9qgioknvEyBIcTIAZU4WXjJyf96pPJvEmN97kh7wjqoCx/yVI/LlEQC/Pz//WNGdCvo7EPRWxxlq1lYf7tLFWB2esRELD4Zu43WhOG+EU5W269+ZXuBrhYQkl4196CgN
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 04:48:24.8732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f712f23-537f-45bc-f3e1-08df4b788167
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6925

Let userspace hand ionic queue rings to create_cq and create_qp as
struct ib_uverbs_buffer_desc, instead of only as a raw address in the
driver request. A ring may be a virtual address or a page-aligned
slice of a dma-buf, so several rings can share one dma-buf.

The get_context bit IONIC_CTX_CMASK_CQ_QP_BUF_UMEM tells userspace it
may send the descriptors. ionic_cq_req and ionic_qp_req are unchanged,
so a provider that does not send them still uses the existing write
path and ib_umem_get_va.

Userspace: https://github.com/linux-rdma/rdma-core/pull/1862

v2:
  - Fix sashiko reported comments
    - New patch 1: bound depth/stride shift counts
    - Reject non-zero qdesc addr for dma-buf
    - QP: pin validated descriptor copy
v1:
  https://lore.kernel.org/linux-rdma/20261118152313.113714-1-abhijit.gangurde@amd.com/

Abhijit Gangurde (3):
  RDMA/ionic: Bound user queue depth and stride before shifting
  RDMA/ionic: Accept CQ ring buffers as ioctl umem attributes
  RDMA/ionic: Accept QP SQ and RQ rings as ioctl umem attributes

 drivers/infiniband/hw/ionic/ionic_admin.c     |   2 +-
 .../infiniband/hw/ionic/ionic_controlpath.c   | 200 +++++++++++++++---
 drivers/infiniband/hw/ionic/ionic_ibdev.c     |  17 ++
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |   2 +
 include/uapi/rdma/ionic-abi.h                 |   1 +
 include/uapi/rdma/ionic_user_ioctl_cmds.h     |  15 ++
 6 files changed, 203 insertions(+), 34 deletions(-)
 create mode 100644 include/uapi/rdma/ionic_user_ioctl_cmds.h

-- 
2.43.0

