Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.33
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795752531;
	b=TpK0VY419Erk1CPPw/4L057lwZJScme2UbD1JE8Ii/P2yIyfQKCW/tGKCGGC4aXm71d8
	 ya8g5ZyJF1BIgCANbER32pILgfHaFyDRcmNPhmsMMw77t3nJr1uDkcykwDe9WU/EUxiKw
	 +eknxCA9WyBREyQtV13zp2kzy58RebgkUI5CtvRbiOI0O78NOD7/f/4gS4bQbEQ2ELLvx
	 yZaM2EvtWgXbM0Z4jRt1AA14VzcyjMGnk3XzB1DY6jexGmtGNKSaPYxwzb5TcDXAyJDUO
	 Ej0ZAYNcMCCbFxDP8PigNrHVnr14YKK0wNYvVCX1bwlUpYtI7IGEB5IN/c5/UptjdwA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795752531;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Sd+kFHyE2rL/CMMrCG3jYqDDsVQ1eX2zNO7OBbiIsGU=;
	b=jtY8QGTkpGRUQm87S/OTSFxyTOla7DJ+iofC4GvFGY8ZO9zEYC8ndPjRuTiaRfr2RgqC
	 Rxy0MfvLaytmwegsf76yKOroGgvCqy47ICwWC1euUGSrqBON3K0XlOwKjgkFV9QylaioT
	 RbtEAjOr8BW6zkLDHZIK1IeRhGDlB4Sqjwu9C4VFsOofOu6X/TPWsuDO7QAT266XDQNid
	 +mG3oSeZzpw3h01q9bVLk1v3CRC6Mysq3W8FbP6pJWNeB7/hV8rk1g7ukPodjnSjPmZ02
	 m0hrkjEZk2n4Y3BgBssWJhlIl7WKmVr37EhQLRWQfD4/etZckUqHTzV+i6YxMXPeVWw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=NwdDFsBM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.33
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012033.outbound.protection.outlook.com [52.101.48.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E3A606A31C;
	Fri, 27 Nov 2026 04:08:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0E3A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=NwdDFsBM
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JQtTl3DjMeZFtQjiNycOOEPlgwDFGOSEZr9Vnhf4D98z8hcr+aKcxtH7VzTVK5SmCEHTpNRj/Qxn2/A81uncL5z3tehppUY7zKDUscajWIJyL2RwIdJ1x2YInBiWtijnrRMlVVU0bedG84OFJWPjfaJePn/LL6/0yR0po1yEahnULI82Fy5vMYYeZQ/xuYzZNKydA84eKtB1XWlUVyPFMdX1oqbWksI9ByU+KR1xXdwgyzy9iISMzYyJ7kjKZVAbfYZdpGBWbRFyZmOWONcP+RXn8nSRyk3nIqu7EWlk0OnPZMwfZYNIwrNgPor0K1aol5fPi/V1ma1UDYqzyLi9vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sd+kFHyE2rL/CMMrCG3jYqDDsVQ1eX2zNO7OBbiIsGU=;
 b=oJ8yrRV7xhHwk9cqBjFF1KAH/nN5xYkd3Uen4A3VFRD1lcqw6uIzCg3cCwwrato29GmprYNhpxCKtt6RIucaJCg7k33rS/hmPfeC63fHxAXrVR1jTT4CMd239/ZWlmrmgAdS6++qjn7DSYAPXOJ9A+HtqukoWaHwrjcfb8J734UW323nqcgpkYNQlllenbTuzwq/sZKs49DB/oVx4tAtXcvhyvxTLoSWEqqVgHwxbldOEYrJsuflMmSg+xK5KbEb5WW4xaO8nVVwnzc9Z2DHb2lyifsOQsUD15NAxYV6MM2nfHtJUwZ/d1svMOb2t7GooRmqFVhs6g05UlTHwgT/7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sd+kFHyE2rL/CMMrCG3jYqDDsVQ1eX2zNO7OBbiIsGU=;
 b=NwdDFsBMqhv8TTStAkF67JEmpx3L76Ufcuj++JDp71kn+M4KC4v7+wFxFrh5gTr3JwELsMQZ5d0DSKrV702mcfDkrsogHC9S5MHNHzwbNn9EJoC5Zs9+NTMXOxZ9Nkl/tblYBqBbZQYESAyJPx45HaSNRWH6mCbdNTlNYJmKc0E=
Received: from PH7P220CA0032.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32b::31)
 by SA0PR12MB7089.namprd12.prod.outlook.com (2603:10b6:806:2d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.9; Fri, 27 Nov
 2026 04:08:44 +0000
Received: from BY1PEPF0001AE18.namprd04.prod.outlook.com
 (2603:10b6:510:32b:cafe::48) by PH7P220CA0032.outlook.office365.com
 (2603:10b6:510:32b::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.9 via Frontend Transport; Fri, 27
 Nov 2026 04:08:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BY1PEPF0001AE18.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Fri, 27 Nov 2026 04:08:44 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 22:08:43 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Thu, 26 Nov 2026 22:08:41 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next v3 0/3] RDMA/ionic: Accept CQ, SQ, and RQ rings as umem attributes
Date: Fri, 27 Nov 2026 09:38:29 +0530
Message-ID: <20261127040832.16908-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE18:EE_|SA0PR12MB7089:EE_
X-MS-Office365-Filtering-Correlation-Id: 72c16658-b867-4b33-f129-08df4c3c20d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|23010399003|82310400026|10067099003|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261021135927099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|11063799006|13003099007;
X-Microsoft-Antispam-Message-Info:
	uG+cfLXOyKV2GLyQbJq3ounZhgPYMMnZZTBaRhmy4CRnExni1ekE/DWsh0vYMWaQ3UPJdSXzUhGY+S5P3pDIQQIb76FQFghX5Fu8cKIzG2G0exPoERWrKha0bjneKXASGcAhSaraHDsaGtzGNtVzcwMfn0CgLfDfhIxq5rR/WBWX2Wu4gJ3RJJcP8ZNcGRZOvNvsFFmvvJihI+UJEaMeF7W/HU/dKuUNJulQMNlowdAcFKhQd3ey47mPnSCCrE07jevATZZbkPRE6Z9mOlKUdn3K60/tIjvgqGsDBKCLbr9HLLhTTQXgXbzhbbP100nvRZt3WwsiS6CbEp2GbfyUIoc3g6f9Vx1f+G66tlF8S71fS6EHF6J5C2o3v0+4viiF5N7K83O21f+n1e1nNQLtXbkEjip3/XZItV6AJFo2voHTkymB+ywKHBWnEisUfe/+j3UbmyJvC8fFCK/txptShWBcgHNr9M9H89FpHWCuEQ202RIeWjDgLCZjLbYwzhng+Gt4+LKuAl0dUf6vtwTGKzTabT/ZycArLliaR/nVl8GZ49/w+7FRe8pUAk1jVbA0GLEhZAmpWnVvU7vnOJkD2DNBc2z7NKWN2RgEpNiAQpL+EJ+WN3UbTzt1isTGFVuB4kxyvGXouifg31TfPmgVcQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(23010399003)(82310400026)(10067099003)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261021135927099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(11063799006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ClxmZuIDE1AoeRADSUaJ5+v7D7ASOq6iFLu7DkKxqQXz7QCxZj+ovdOT+Vh9rp5qGMW7oKnB4cP9L9BfzJb6MgR3iPWKvbmVwUu3Mbd/DHFbxaz6EFxPu6oxIsORP2nTRzhECD2AvDLMDVF1rzzqgFb0QgDROwGF3pkKAhj3LDGrAlHdfU+0HJEYdRj3/CUyWnnSHhOEfTObgSFfLJcxX5VXVkcF8nclMbSXBRkzbCdnYB3dTASXwD7E19clVxkwGmAWzloq1u0HlqiN8rGDvAERbVbzOmfxaZbDpQ+/yVn8sni31XDDdNJ8nsRL640WX8ldRBXIy3wqnpkBysy88zft51eQ9WyYUNhQRjtKkRg2gGZ14fJ5hin6aqr0ig9g1ncfQialRKGjRMtfvowgQ/OS8sV8mZyjYT21KKD7Jy9EqDoEZlVmSHkK6KsFadyC
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 04:08:44.1543
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c16658-b867-4b33-f129-08df4c3c20d0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE18.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7089

Let userspace hand ionic queue rings to create_cq and create_qp as
struct ib_uverbs_buffer_desc, instead of only as a raw address in the
driver request. A ring may be a virtual address or a page-aligned
slice of a dma-buf, so several rings can share one dma-buf.

The get_context bit IONIC_CTX_CMASK_CQ_QP_BUF_UMEM tells userspace it
may send the descriptors. ionic_cq_req and ionic_qp_req are unchanged,
so a provider that does not send them still uses the existing write
path and ib_umem_get_va.

Userspace: https://github.com/linux-rdma/rdma-core/pull/1862

v3:
  - Move IONIC_CTX_CMASK_CQ_QP_BUF_UMEM from bit 1 to bit 3.
  - Rebased on for-next.
v2:
  - Fix sashiko reported comments
    - New patch 1: bound depth/stride shift counts
    - Reject non-zero qdesc addr for dma-buf
    - QP: pin validated descriptor copy
  - https://lore.kernel.org/linux-rdma/20261126044811.3458258-1-abhijit.gangurde@amd.com/
v1:
  - https://lore.kernel.org/linux-rdma/20261118152313.113714-1-abhijit.gangurde@amd.com/

Abhijit Gangurde (3):
  RDMA/ionic: Bound user queue depth and stride before shifting
  RDMA/ionic: Accept CQ ring buffers as ioctl umem attributes
  RDMA/ionic: Accept QP SQ and RQ rings as ioctl umem attributes

 drivers/infiniband/hw/ionic/ionic_admin.c     |   2 +-
 .../infiniband/hw/ionic/ionic_controlpath.c   | 200 +++++++++++++++---
 drivers/infiniband/hw/ionic/ionic_ibdev.c     |  17 ++
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |   2 +
 include/uapi/rdma/ionic-abi.h                 |   3 +
 include/uapi/rdma/ionic_user_ioctl_cmds.h     |  15 ++
 6 files changed, 205 insertions(+), 34 deletions(-)
 create mode 100644 include/uapi/rdma/ionic_user_ioctl_cmds.h

-- 
2.43.0

