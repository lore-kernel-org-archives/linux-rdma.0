Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795015415;
	b=2k9V3k85/7/uaIFBTD6exVqlq4QNJf0mjmZ0aANlVEsn+LF2Ki6qisPlh0N6uUldrFGA
	 Nz2bstP2A8vKh7PMak3EK3E/4swBLkEDErbWT66wmR8jEdu5VHHA+dngYeYWDOSeRvPpc
	 hXUBoAjNGwOF2AB4Qfz/V8HivGNliGNm15vsdX1pfJ35i2T0B5lXmu9jFOkHsRjDUl/lv
	 A+BRnNbCtHLQoIMEkPXynfmoYX+yV/5VeV+q86NPsB26pyUK0iLMl6/ht3WOq13lIqj04
	 qBohsR7n+P+Djml8DPqvTBF8L/W1TS5MLyMIttu49b8AxsoYPepq8mrdl4RMOFUHP5Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015415;
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
	bh=H/VGSbpa9dl394KXd1qNjB8nqZBCoXS+Myz0NC4zdMQ=;
	b=jI6RwQUXxWdY8VrmYW4lafO2RpksVOJ4mEeMWAdixD80o/n/TrCvnDcRQ/RnFCgHkgK6
	 tRVHjlB5lUHkndxoy6ihZgfGZYz3TcaBfA4PD4XWuoZ24WSDzL8n2cAt6VcT53DUozgBG
	 Krds01zyCan/KF1p6niajOlxbKS5ALQDHsgal1v/MFhgj5P45hx/l1gcXp/x0ie9ofcxd
	 K4BYhxxRCygugwzPelBxxIjZBrafA98XrfxTV97rmqOetWyHk73qHz6H6LfYJ+wUDf9i0
	 zddVvb35pK/eTvynNTrHbp7i1ky7uV7pEsKYFe8L0mTozNrkIt+BKu7VxsmIAE7PbhQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=txRVMkMr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.17
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011017.outbound.protection.outlook.com [52.101.52.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AB6606A325;
	Wed, 18 Nov 2026 15:23:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24AB6606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=txRVMkMr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tPovdC6Ni22J+DeBjEdHtH9IWpiFU4FyMYho6AnCo180k2A4TrzrBkO2dVPtzFnviEi2QC62RYkpvv8QnCc5Bn1Y/9HPMKiRN6ZyCd1f07kQR8EebZgRo9hDdQ3+MLmUSlqInFBK9Ov9o6Xav7gmei8TkEfHtmy9SYAPcgOtxJh4d4ORK55HSl5vhe4BfirdNHvESXXXkDteKUOQCHPIcQvSJ9FQgSnja8umNluhbxqdyIXsoB3LJq4GTvzOubBbV4AzJDf4CJGm1syHvidMJ+h6j8IbdcMXGusQGacNY2uLn9+WejZL1mdmcR8DJLiyw1JYujNxrzUUn0LCBN37Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H/VGSbpa9dl394KXd1qNjB8nqZBCoXS+Myz0NC4zdMQ=;
 b=ofriMkEk00WUp92FgQMnweF/bXD4/v/k9mLxAufnqlte/Tz5TI9ukwu2B+wNjOs/vFLJqoqGIVKjw/LEhP+D+hFV/U2lKz76HOC/AbUu/ws85j1caAfNrNmhwqaN41H5QM4TMbrUcLv1pQ4A+cgGuccRpubf86X+wRJu+cEZgePlkjSMa41IeehnOXNJR6ILeyCIUvGPC5lYq3fwelY+pLFh04BEA0/dVZeWgDVBjS3XVnzTCAazXXHIPzRXGFeDEs940Y8sXM18vr1i8yooue2iv3pqzcEKNTM/kthLAmtcPdF1OUd24u/7f3oHlLOaOrkZMsOO6cSwB9W4t3lbag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H/VGSbpa9dl394KXd1qNjB8nqZBCoXS+Myz0NC4zdMQ=;
 b=txRVMkMrbEAwInMzXW7Yh45nCWiw6sGjCWt7QuJG14idbqc1l17mSTSf4VqwIAW0518JwvkwXfO6W9kFfcONfaZQY7vOsVX/6rgVEQQ4z4If1qVA4YjTFKBtEP5jS2BmouwJWWVry0Y+jQl466+TNlnF/zuAQeNezFz1rW9XkVA=
Received: from PH8PR21CA0010.namprd21.prod.outlook.com (2603:10b6:510:2ce::10)
 by SN7PR12MB7274.namprd12.prod.outlook.com (2603:10b6:806:2ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 15:23:24 +0000
Received: from SJ1PEPF000026C3.namprd04.prod.outlook.com
 (2603:10b6:510:2ce:cafe::6b) by PH8PR21CA0010.outlook.office365.com
 (2603:10b6:510:2ce::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.1 via Frontend Transport; Wed, 18
 Nov 2026 15:23:23 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF000026C3.mail.protection.outlook.com (10.167.244.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Wed, 18 Nov 2026 15:23:23 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 09:23:22 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 09:23:21 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Wed, 18 Nov 2026 09:23:19 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next v1 0/2] RDMA/ionic: Accept CQ, SQ, and RQ rings as umem attributes
Date: Wed, 18 Nov 2026 20:53:11 +0530
Message-ID: <20261118152313.113714-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C3:EE_|SN7PR12MB7274:EE_
X-MS-Office365-Filtering-Correlation-Id: c256f136-28a5-4a40-a920-08df4587e2b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|1800799024|376014|18002099003|261009223027099003|13003099007|11063799006|56012099006|261026140227099003|261028144727099003|261102123227099003|261021135927099003|261021121427099003|261026121527099003|261021123027099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	FO9uxYb6/6Dy3o2nMoeOPrR3sUGVcedsBM9TCDR4ITdqFD2wA0aLJ1IK/25Z9gHgK6Bv+2DMk/EQnCDp1UXYu7kQ32QQQRHa0hg3nD3ieJlOUuBBfPDcimkK78bOA+0+rEQ+2hPGPh4EyII02HiHdb+moSbx2aySBg3zfJXtZXYkJNZqTtWrRM5j7m906DPmNLU9tGQGM+HYNs5rzB8p3PeztxBWJ/h+LpokM2u1gnY4T2o2aVjdfYn2dhn0k9AdD8rf0QUoQsZnTbVa5XJ6zeAbXr4VaLa3QyVXikKP4bEq0o1H/134dhlD7yRaPDDCydzJb0Yx5a2TWYBIDWj0aY3IgoP78HA8Si7naWScf2sDu42MNc0xPDXenW5L0iNwGzkb7OCNxsNIHwTAvFPuQe5wh/wP8wx5T+RxYDNbjiN/KechrdO1moGnSBY1F3bNc9VcltSkYCcaCdEvnpTemv0/kgKj5rp3pLBLmyZsaR7lNBKClKc6RnxA5zXp+d5k/kixfz/QPW7g7YUQXU7SfdEZRM8sKIkWPLwRJt5EqFj4G6etghmC6QeFx9E1FityHK3DLCrJiQ2mw8d2dlDS/SbQ8LZGp1VXhaSdSf8HHaqfqdZ9IIkwGDGwv9pFhD0TR6VsQG4YYn2y5JC3tFWTbBH0T6wfMQKte3pDoSj8nBHtTN1u13aMatVH6p4PXgDqyPiQilA5fuIR1A1syD+jSQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(1800799024)(376014)(18002099003)(261009223027099003)(13003099007)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(261102123227099003)(261021135927099003)(261021121427099003)(261026121527099003)(261021123027099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pWnZX0xfSrqP6FUBDr7o+XGxkjqE3vUyFH4E1Ur38JxhkIc2MYfxXITeEIDIGaUsBoc3SKQ96VbxGfTzjWNYafPhgDDmOw2HxLLEDH7rKrl1RDZ0Z2eQmomP+Mx8/tLFcBYBTImKQGaSymiujDTZLIS3jDnBRq0sf0TnAqw2jiL0ICvOllrIe9HEF1ZqiulhuFCvwSXcAb8s6+8+0CDSxTWl76eZbOLw8WFhsNDIjQoYNmcZrfjycH50ttHZAgLVYYXwRREiL+ijRHQVGB/ppRc+K5EkS6hbcHADQfAJsOoIn1QhCrv20eOZgP9oCM7fFwoATsLcyA69fL3wNQImIfZXrRnX3K8c6WRPg0PdzAf498k82vcVIauTOtRX6uBcDDXFOXytK6+LSX/v517vKoqPn+T9SSYaTWXYTjy3koNzls/RUcX/WFJs4bdllegC
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 15:23:23.4920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c256f136-28a5-4a40-a920-08df4587e2b5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7274

Let userspace hand ionic queue rings to create_cq and create_qp as
struct ib_uverbs_buffer_desc, instead of only as a raw address in the
driver request. A ring may be a virtual address or a page-aligned
slice of a dma-buf, so several rings can share one dma-buf.

The get_context bit IONIC_CTX_CMASK_CQ_QP_BUF_UMEM tells userspace it
may send the descriptors. ionic_cq_req and ionic_qp_req are unchanged,
so a provider that does not send them still uses the existing write
path and ib_umem_get_va.

Userspace: https://github.com/linux-rdma/rdma-core/pull/1862

Abhijit Gangurde (2):
  RDMA/ionic: Accept CQ ring buffers as ioctl umem attributes
  RDMA/ionic: Accept QP SQ and RQ rings as ioctl umem attributes

 drivers/infiniband/hw/ionic/ionic_admin.c     |   2 +-
 .../infiniband/hw/ionic/ionic_controlpath.c   | 183 +++++++++++++++---
 drivers/infiniband/hw/ionic/ionic_ibdev.c     |  17 ++
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |   2 +
 include/uapi/rdma/ionic-abi.h                 |   1 +
 include/uapi/rdma/ionic_user_ioctl_cmds.h     |  15 ++
 6 files changed, 187 insertions(+), 33 deletions(-)
 create mode 100644 include/uapi/rdma/ionic_user_ioctl_cmds.h

-- 
2.43.0

