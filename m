Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012013.outbound.protection.outlook.com [40.93.195.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325A041834A;
	Thu, 13 Aug 2026 10:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786618286; cv=fail; b=eoVaZrbB/wQChY8hrL1mCUd1xhmoxIBPPbSdhG4eVdAHvSWXqqTl8uUj/cG6wwpc5ejYV4nS4tJEAw67//8PYNDm/OrfCZn3Grt8h/y60XxDmB5eH3gSg2ZZjvzHJi1o9zdPygKEKX58xMuBlMm0hWPGNTZy3buEQpZrzoduIdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786618286; c=relaxed/simple;
	bh=y+F0Do3SCgSI16MPnwcUbgrr1BpQyJ/Ty5m569L32uM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K43F7HWtMcRGfI7nvT9ZWVQt5rFGqcfL9sTJgneRm3a+gyLlnP+JOYNn5SaQBmhY6ZMeWdRKqvUf32HLQx7mW8IK9/hcESz9kLciDEJ8FqoVqCpeucFYkvQHn47fl8xkSrNT2pO3bG/cuY/jLsMfE5hk5mkJKUjq/ZolpIPDACM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SpqbRJ8R; arc=fail smtp.client-ip=40.93.195.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SpqbRJ8R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DPuIcwV0dfR8xpnB2wB8KjW33Dgo8meaunxy8MEIavTHvMHPqe5rH2ZR2Mm5XKMkXEOyO4I/XWpWxLo9IMED3F07tiWRwtA9s03MVQmQPbodvsXi771Qiqzz4hsXZKTFK/JbexzyibDdcTADMUuqZR5sEbsT+w5W2aZ/4I1yF3new7PRxMIPmYXwW26d4GZS5FgElRJAKpsIEGvNuZ0A4KfwY6Uzf5kXKCbbRSvokxRPikWt2w3O8jfE2GJOOdNWdu1R8CQSUJWoATKx3LQ1wKbGLvtCCim0qiBe4DcOgmhgCLCGAgXdX6JY+RosCLETJgOwqZqZmZFvB9cv5N+Y1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SS/g07cYxQg8ba+t6RO9ZNbQLTd21D6MGaCunWpepXM=;
 b=qAgr6rJuaHlOrTZkOxj3eqeheAlsjVEI6LW4m6/VOo4QZ2PbePbKha3Xj66DEnSKsXBxsHxqBkY+KA4ob+TZtNSw2v9OQH2QjtN0+4CS+sB/uRU7yrlcLmPuqWq6/8ixoAFIg3s68mD5pb/T4dlOGX3VbAOnp/mPUMf4+4iiMRl3GD5tVI6Ov1ym6thS5noO6HpYv4Y+YQEjkP2o2AZUXCf8v+r99BaUYDZV5cND92/XpORXL9V/FX0u7N6t5mhq0bOOjga0qen1CfRY2TDN87kzPlMUjIgoREkmRNWS4Ew7DY8LxhHZFEK7nUb3nwoL/x7I3AOn5xN7nl8LuFv2aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SS/g07cYxQg8ba+t6RO9ZNbQLTd21D6MGaCunWpepXM=;
 b=SpqbRJ8ROvOki7m0/Ou9MYist1O+qkqT4R2AzTyAs6u/+ZZtKlRRkI00WjMjE8TKaHiM+4V7XaW0piR18e+3j7x/eRc1Kg0TjzGrEp3LZBhyLoE1YElWlwORfpgMpZ/FQebQsH8K0o0CqfalbkLKXO6fCHXTkbADNVBv7UpTbNU=
Received: from CH0PR04CA0010.namprd04.prod.outlook.com (2603:10b6:610:76::15)
 by PH7PR12MB9073.namprd12.prod.outlook.com (2603:10b6:510:2eb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Thu, 13 Aug
 2026 10:51:13 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:610:76:cafe::31) by CH0PR04CA0010.outlook.office365.com
 (2603:10b6:610:76::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.14 via Frontend Transport; Thu,
 13 Aug 2026 10:51:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.0 via Frontend Transport; Thu, 13 Aug 2026 10:51:11 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 13 Aug
 2026 05:50:43 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.45 via Frontend
 Transport; Thu, 13 Aug 2026 05:50:39 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v6 1/2] net: ionic: Fetch RCQ sign bit from firmware
Date: Thu, 13 Aug 2026 16:19:53 +0530
Message-ID: <20260813104954.319065-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813104954.319065-1-abhijit.gangurde@amd.com>
References: <20260813104954.319065-1-abhijit.gangurde@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|PH7PR12MB9073:EE_
X-MS-Office365-Filtering-Correlation-Id: 45d46432-d147-468f-1ef6-08def928ca41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700016|23010399003|22082099003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	lcHbPNH83fuTDp5Wa4u+1AkOH040MxCll0m2sqfns65wGBHGHaXpTW0wBJxYmjC7oM4OmDGh782t90v8rgaqJh3La6s9PZmPZmfV8cUAIFOp5Cnxs8FBRV4Bf4LSaXMDBQsxcZfU2552XKXyfXwsPbt+hUdEQ7Pqk3xixVfV3o9B/x2UmqiOb8a1Y06lNZBp4yvKl34CgIZ7CKHyCNb2pbZaQZgXdFT5U/9irMOR3vV6vzt/HH0+ItQyFFy/LMZG3d3QejVI2Ww0rjVgMO27wnwWLerevmEGH06JHAHhKJpJKJ4356JBeSQuqDunTY6bTIJNdNIrbU+bg4qbm/1To8x/JbUGa342kWT/Y8HPRSMARoK0WQMhOFbrrTvaJE9sLWWzcsXtYwLERY16+LQaewjwTeYN/QXI6begefsSx+Vzubz8O5l3R2bGWVtl++v/FR5EjMwK94X3mmoGD+Co+xaLg2kCfI/mCe1uPWvlNy6y6f4IQpmqf1Dr2xhUYrLX1egz4bSWzge8HJe5nZy7dgQjXTT8+zl9h50cRHksPeaTD/dwcD7SPSfj+2Zavxi/zZUcA2H/Jd+/7Ac0hFjsim7NDAdnghg1vkHqbzIlsidfZLCyFpWyDRPl+242XQxmqKr2YbT/EkgP/KeoRHwUL44G2nNwBUOA+8Xhu5DyD3qpbKnmGOpsq/NbdyKF6kKGiyEHKRcZ3nmA6QZPtjZ0Hg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700016)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	by7qem+jnwSzEAg7s8ZyA3GT/fhlJtqtCznmvX1zbMF16HtKB3iQ49f11IvEYd0pxpw4ga5c2u+ZoUJ9v1YzlLQZ5SvDsdjkXvxbVWSsasFHOWb1aE+otZM9zLwCqDvhZyhKhWjWRShcErwWazdWd02+nbMetjCdURHN9UEjLZAQ646rUgB1X9RnSKEJF5Z5RZmJzI8VMNXrr9kv8VDXKTXIHlyJkz4abJ5dg73OfGgZStY64hZv7bgCsI9Nkwz5/l670eNgaGwZb0JQMfo6QirJdrqW2J68p4ect4gpsbeCbq640aO96L9UrfO97hLpRNNvNVyac1DPpJsmac9wOWJWXMdvp85hoi4/gQ0YEcWPHNE0l+yIozuYsagV0nnk9+sRQiRh/GfxLo07/jjP1oPq0nlo9TeKfgvZqlNqGhgXsfvuez7NndDPit9EFJZf
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 10:51:11.5234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d46432-d147-468f-1ef6-08def928ca41
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9073

Read the rcq_sign_bit from the RDMA LIF identity reported by firmware.

Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_if.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 6afc1fc3c7ed..15f2bc3f4043 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -555,6 +555,8 @@ enum ionic_lif_rdma_cap_stats {
  *	@rdma.eq_qtype:        RDMA Event Qtype
  *	@rdma.stats_type:      Supported statistics type
  *	                       (enum ionic_lif_rdma_cap_stats)
+ *	@rdma.rsvd:            Reserved byte
+ *	@rdma.rcq_sign_bit:    RCQ sign bit
  *	@rdma.rsvd1:           Reserved byte(s)
  * @words:               word access to struct contents
  */
@@ -600,7 +602,9 @@ union ionic_lif_identity {
 			struct ionic_lif_logical_qtype cq_qtype;
 			struct ionic_lif_logical_qtype eq_qtype;
 			__le16 stats_type;
-			u8 rsvd1[162];
+			u8 rsvd;
+			u8 rcq_sign_bit;
+			u8 rsvd1[160];
 		} __packed rdma;
 	} __packed;
 	__le32 words[478];
-- 
2.43.0

