Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022118.outbound.protection.outlook.com [40.93.195.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCD0373BE7
	for <linux-rdma@vger.kernel.org>; Fri, 17 Jul 2026 03:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784258453; cv=fail; b=cPI9SghOyAaWTzaOjiKWfw/H1MwPFUcjoeqH/jdWaw6wk1VbRfWvcKJ2pelGTETx4P7UrKu+FHn6Zii7Wz9fnTxYQyvWtOOTszN9NRaMH3iNR9obiJWXKUqyw+zSVmC8FBro1JkSdNMOKLHSWrzNP5tbbIptFoZAhVgDniEch98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784258453; c=relaxed/simple;
	bh=UqrpeRsErRfrQZMFTDiRb1D99vHfbRF2IaGDhTGx/2g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oZ2KL4F0xpDsdfr/kALtjRjg/dHO4E4c9KGlOyluyX/xgrA1COWm8VBfr8t7F7TbV6v6uokKa1GeNo86jpS7jZ2Ob/nBfDjfv6P6cLlIPeGRF3VQVMDdGvclW6MM23G6BA5EqemWYaUFpgec08HJu4yHZw9O5LhfOulOtZTOw2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=10dqFFi8; arc=fail smtp.client-ip=40.93.195.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="10dqFFi8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u5ccN3sS32IMgi+cEs69sfcS+o+g8YuFhYOm9cLQ7uco162/AQ+FHdlSXgmG9GZSy1hsTwFBZRe1XkrfWvL+kBiNGZQha6QEvdqrA0otxxlwdVXzxqA9A4gzIifcII6Iq2iXCgAYuPRtINrWH7JQ770S4wLFTOA35WprZDRdWJB+rYsXiGkeYVymxCF7WhIZPwK6r9NmlkyRXNOgkCzxOsi2J43PeRK4C647CNDCbEvfuBApQJiI7QETHU2Qv4dSzngOcQp/XkcpqoEgKPCirXlDCPHSJgv7rugFJoQ+vzH/5n/V9dIq9b1E4xp9zYQAnKApYIt0iWyZm5YboTfEYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=krShj0TgT2Qqhig90i1tEwsE8HdbIvekGOIz7x7hJnE=;
 b=lTf1crcexB8LI5XT4TePHXy0GWXzrxj+MOieIhQOA7KEHGHwY0rhKmcG6OTcJagvxahXB+mWXtrutraKs7TqKW5PosLfQC2hNFik2CiqXNeX0l33c1CmKjyb2QFQMUO7sNDBWT/yJAAU5/kajxM2U3dd9o80YZjX129OiQschDptWfVFcppC0iExS3NEfL/lY3HNb+WSneuYYbnnYwPx9De2mh6ScYF9oIKzUuwS0U+S9OjE0TIWqRFjzd7UwUbLyKAU6e2pg70r8OpR1u7ka5mqfRXzev+ocdhoYfKlovm4WpWrwmRBBQrX3uAcaXHxdYFoHHpdmJvLbv7XFJyUfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krShj0TgT2Qqhig90i1tEwsE8HdbIvekGOIz7x7hJnE=;
 b=10dqFFi8azfANDRbvFeVSsd06YDnxsV77DCEA4/BN5+plHJc13LCTdSy5ZT5NyhSp4qjHs44SHQzDG6CI6P26j8zotqvPZMi1TqTB6RQSVshAxQECr26xCwTF0+58LZyt+HBrlQcpcs6f1/e4c0JZtJnlZOgA6G+u+Fz2CiA5JjxMFSglJeQ41u2ZnOJRn06RtjmIYMLuhakQdy1VYtj41+zLma4L8mdcV56+VQwPBv+FWdlEauuNG5+ggazHiAWFNE1sCSUbta8UZvM13ZAjHKsY3yR1IEcrk6/6qaSNLkvPFPqom4Buhl6queDvnvM8bqmWNG8BMQ5hBFeNZga6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 DM8PR04MB7992.namprd04.prod.outlook.com (2603:10b6:8:7::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Fri, 17 Jul 2026 03:20:47 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 03:20:47 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: Michael Margolin <mrgolin@amazon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org
Cc: Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>,
	Marco Elver <elver@google.com>,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 1/5] RDMA/efa: mark mmio_read seq_num as guarded by mmio_read lock
Date: Thu, 16 Jul 2026 23:16:54 -0400
Message-Id: <20260717031658.477397-2-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260717031658.477397-1-timday@thelustrecollective.com>
References: <20260717031658.477397-1-timday@thelustrecollective.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0010.namprd08.prod.outlook.com
 (2603:10b6:208:239::15) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|DM8PR04MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 25cbc43f-8698-4625-1642-08dee3b264b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|18002099003|22082099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	/3Kvqu1lt0r3NKSWi7j1NPALc9gIpPnowXlRmGv6tI5ZXAnlc1WX44bjoz4c301V7esvRJLjds8EERVnCeYFqQlhgdVfMJUFori6PvnTF0eqQu1IaFBa9gcsVURqJYgAcQcUvtsDLawvtvEhAftHev6klySbJmS96fiTPtY9+8cLyaDTxCI6W3vfwyQ9WSvSsH1+yqHRgclikrGbxSDtCqhKKNtNgVQGu8U1Yp9OiSaDKVxKLGpQkL62mkWYSBMWxj7Ekq9SiUAquzn/Rdeiq/iG+zSgPo8jGeC6RvVkbo4SPrntueyZ1q3/c7f8idn9Vs71CeAwQ7L0RkQFXAIr2ZaXRt3lIgIS8OGKDZ0/G/gso27YkL4ibDnkUcMVcr9bFTUlO/iRB0qEumqMNAnZzvpY3CNBvp1pSDL7kbxL//FFC/xFXq9F9p0TvtzgQOfI9l5qt+PBJVqVZnAYGSbZKDXao+rQ52Bt5VAdmMOOfxVSLXtLy6z2VEKcjQFpw/2dHRIDNkqbQOOiCwWk8stdlx6ipIM3mi9w67Sclue3z08oVbIiBIp19PMYJ5KXJqg6KB1/OG7wcSaohOwLk8PhCHMmVm0QdoncQBUf8swFd+nd61OLUHJ3DXtZGJpdRuczd+2y3P1pqHqOnnv5LnegjtWtTbsRfQMpb37ZXOQktk4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(18002099003)(22082099003)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PCqVKzNAHOBjUwM1wiExzH3a+hk/PNZJ4OOs5/iP5XJcO/dQ6DJDdCZUdaX4?=
 =?us-ascii?Q?hNHRXpyJkOFbEXFKvgSi0GX/nvSq327Oey30rFXzreCeKTDw58WAJVjOxMm0?=
 =?us-ascii?Q?0juOYTPypie7GxoobFVmQJIWdlWrBlrlPMfnH+EdTXKCe0Sj12GE03op0pGo?=
 =?us-ascii?Q?68hOmhFeIBTU2JD9GELuuQbe0mwKxYGzX9DW2VZFuzbhpdVJ+VKY79xJmiwV?=
 =?us-ascii?Q?6A6wqxB4Sh9kYlu8E1mSMk+5WAHA1txzLP9RUPxOF4GI8Zednes3BHFJmeUL?=
 =?us-ascii?Q?ECg2aMj0k7/efh+I+j7mdzYyXGLjIuQKNtZDns3czpK1qp0j/4UAJgOQh5Z3?=
 =?us-ascii?Q?NW5UgyFNSvpsicwVIS8TXfKh1Nd0R2dNXfDrTxhJmma0XUgOQ5dY0ggLUuPb?=
 =?us-ascii?Q?WzDGRNzCXuJtdR10/HFmJYTuNre4bIk1IVyFBQgXlhEJXT8c1rH3UXDigfEz?=
 =?us-ascii?Q?LU+s2Bd79a8TZeGT5erFFFBmYRLCpyikI/XrYmHlrmcBPL19NojZxrKOyICS?=
 =?us-ascii?Q?JZS9BkKCxrAVQoxjCgOiQ8aVxtJOoMhZk+We5rLY8YxVxIEhRiuNmkotCC7L?=
 =?us-ascii?Q?r4kYV0u2NdmR6EaWvz+nQG2xAAZzLIsylAb6yxNsaWDX3WxZ1BZeIS+oUVpD?=
 =?us-ascii?Q?S7pL+xHjpFBmL3nxoCiMSDaPTA6I9fXJUMfAfdj2Jl1tssCwhlAV3Soj3/x0?=
 =?us-ascii?Q?JocXPm0CBTs3/7KS9ygmZ1o5TmCV8mCxKJQfUCnoOpcx2UsStqsgDeXm81zB?=
 =?us-ascii?Q?WrJkttM8dRxTTOAZheQf4VWcKF/TE6rj82ge1kyyUY1UdqdeUwkD4xjdfbdo?=
 =?us-ascii?Q?+G0WLT90YBUNxxicDlucg1afLi8wIXb0PC6he/+IlvBQv+oEstgL6A52eIFF?=
 =?us-ascii?Q?/tc1g5vISk8EHLRRMRVkjbhGXcjb3gFS8HTbzEra4y9G034YoHHMsjin8I3F?=
 =?us-ascii?Q?a+tOY0ubLq9nDaxfiUWB3hEYCjxznp4w7yunu32rruZU2rsSyzofIA71Vshl?=
 =?us-ascii?Q?/8sPk74O9gSti5VqilT8Kr3l5afqiJH+OzDzRvGHg7pu3vsSnkOHL8J3YZ++?=
 =?us-ascii?Q?OasqGqiTrIxhm2KTbzlVK+LbBf7439tc7Y7cC+rL2lROZCZcxFBtDL6Ua/IL?=
 =?us-ascii?Q?9AC95W49+mH3oWWQVumV6AWGYyaxMBh7aB7raDlXpESWvwnpLP+5iXtmBfSE?=
 =?us-ascii?Q?HeZBgyOhxP33rKujaeFMldQPeQlr1Vo0BwhEQT2s6yTh6K+yfFBmDiZt4Hri?=
 =?us-ascii?Q?aztJJMCkzFr+HBAd+86T1U1agpZtPjyC6YP1S9MT8rTa4L+JTLxS8eWf/925?=
 =?us-ascii?Q?FrKQv2xwcQbdb2nz+4eO0u+XD8LcE9yW8UE80Btapd4b0gpZflsQnLRtdSTw?=
 =?us-ascii?Q?AaDsKT50oJAdKZzG44ns3PB8dpTjhQmV9vdtzyBBku8gVBx2mLOI1ZKnxPk6?=
 =?us-ascii?Q?WLDjFLYUojfZ/BYh+cfIAoNYy/3TcfkZbPzNpldTwuRIuwKlDXCqQ5pUStCd?=
 =?us-ascii?Q?OXjokXVOAZkyhxpCnPDOCUy8F7HdyOH8+AouRXAoyxZDyY/E41cydPTPd2ze?=
 =?us-ascii?Q?7yzA/FYF7xDyKxxkNuLn3BAc8iBm0zm4WwIjPGQmYRtmP7UgAeWeFhkImQ0p?=
 =?us-ascii?Q?za82+/m9s5yi6Ejltb4Y3x4kOp688aOS90yZ84ghAVJi3W+P/Wfp7KQmBMmS?=
 =?us-ascii?Q?3ug4XGaf6ixepPKlUICH+paGhmPkkChbD7Ci7YjchP66FCxxDlI6VygDhhgN?=
 =?us-ascii?Q?iXNLVSFA/UEVt1sw28CwKo0O2Y1/kRQ=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25cbc43f-8698-4625-1642-08dee3b264b4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 03:20:46.7246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KqC0x3wUtGFlwpE2cyYN3vmkRLrB3eZ/xhJxNwn3+Y0wkc8UjkD5m3IUNEON1a/6T/0ICjipL6Uy+OVCcvf0NJuF0T8UzIbgi3RDsQ8HNkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7992

seq_num is only ever accessed while holding the mmio_read lock,
so annotate it with __guarded_by() for Clang's context analysis.

The mmio_read lock initialisation in efa_com_mmio_reg_read_init()
is marked with guard(spinlock_init). This covers the mmio_read
seq_num initialisation (later in the function) that is done
before concurrent access is possible.

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 drivers/infiniband/hw/efa/efa_com.c | 2 +-
 drivers/infiniband/hw/efa/efa_com.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 7097d1c2f23df..c48971595d5ef 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -956,7 +956,7 @@ int efa_com_mmio_reg_read_init(struct efa_com_dev *edev)
 {
 	struct efa_com_mmio_read *mmio_read = &edev->mmio_read;
 
-	spin_lock_init(&mmio_read->lock);
+	guard(spinlock_init)(&mmio_read->lock);
 	mmio_read->read_resp =
 		dma_alloc_coherent(edev->dmadev, sizeof(*mmio_read->read_resp),
 				   &mmio_read->read_resp_dma_addr, GFP_KERNEL);
diff --git a/drivers/infiniband/hw/efa/efa_com.h b/drivers/infiniband/hw/efa/efa_com.h
index 599db9d583bf5..cd1c68cdc5c43 100644
--- a/drivers/infiniband/hw/efa/efa_com.h
+++ b/drivers/infiniband/hw/efa/efa_com.h
@@ -99,7 +99,7 @@ struct efa_com_aenq {
 struct efa_com_mmio_read {
 	struct efa_admin_mmio_req_read_less_resp *read_resp;
 	dma_addr_t read_resp_dma_addr;
-	u16 seq_num;
+	u16 seq_num __guarded_by(&lock);
 	u16 mmio_read_timeout; /* usecs */
 	/* serializes mmio reads */
 	spinlock_t lock;
-- 
2.39.5

