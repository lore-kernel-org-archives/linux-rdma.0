Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011065.outbound.protection.outlook.com [52.101.62.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D5E44781A;
	Thu, 13 Aug 2026 10:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786618255; cv=fail; b=dCmCwUGCFiwMoTQhZVktWtTC+LldeLch9VT23H8opj2xG5nkdWef26b3ec/zUC7f6vermtfLI7z3qrtcIQnHwfY32IlKsTHFjlJUxje88l65tKUhKz863z0e2CvpJrOLrYstZ2THmCsXxk8W5G07qVsGVenePP1ebu7Haqc/dj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786618255; c=relaxed/simple;
	bh=jtNQpjFFsj5GBpO4aKpgZj9Diwy4GtZgr7UdX0TIIOI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EbmNVjPn8t8UVOIfda1abmq44MPJahPO329uyOsKzzzjYrCtkNKaucphqhzAB/ezE8SI8zhthyqzsppFgtQG8Xe5z922nQlcdhjAopgbRZYmRJ8Ujm+r0eeXTDA3rET10LqCT4aOSvFdGHhX+gfsPnsZlX3q8pxqfXtAQsq2aH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0Mzuu52z; arc=fail smtp.client-ip=52.101.62.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0Mzuu52z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hvJCDzzwFoxE9aCOsQ9z3DDDyGCLEDSHavwaAaHaEW7Nc36MWWFQ4BnONYAUumW7/zgS5FFORbYuq81xHsDMd8m1T3Z6rDU2UGxiz18r7zLe1NS1/S4H0H8zu3X6OWAQDq3PPGko96h5m2NsupllmSoHm5pdfdXBFHILtUnfAQkGs1a9tqd/C7KjxkGqQPyqlQciSJvIENpbritKjJk86CNesmKEsqgZ94bHDJ2RYo84iR8P5SJvZwrvkt8Jjtb6w4q+uu1AMVqXinMebUaUBWKqa/YL5a6DCILFGlFcoar7coidvsT7+5wwbDnLX/9e53mPNfMCDeCziSuP8e6W1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NfUsOemL9TJsK643hysKjQyP+oBWafNO2xoTG6fZGvU=;
 b=rlIiQAdtosIHZGIELr7PrbpLW2acFrub9QHykka4AJjHVk6x8a5J4/wVMwE7LBIQW74ya54PEFTgp9i/MYihthc6siXiXz2wECZPVZ43v7xkAhqzhUnmEJEU3TT/gLKuIPH8pHRkz4sbIGcIXagsQUr38SEIMXQZa56AqcKzomXMR3iBO7e7QcUjrEboqMYuMui0jTKHnNxWR4iaw5Da3DK3CI3m2YuybV2fSKZB1z7w9OXJ3pik3N0/PUs8TfjLfBi4kymhVizSA/fxVOZJFNVhM33iktp5h/P3Y2ix1++qzaJkIzmMzVLuKSURqsz2JjxXPKUv6/zR02qVT6An7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NfUsOemL9TJsK643hysKjQyP+oBWafNO2xoTG6fZGvU=;
 b=0Mzuu52zeH/4kQ5ht2bdtAHrPkOIZUQDCTX6JyvAAogwx+8oAUcEe5H+OhSTtbmD0nSEEgP3MKPjPh0j5iDW6XI2FB/FZa2VjOGD8XmRuYQYwL4E/4m28ZJnFNaGu4Nveg3iUYecjKsP5pu2oBAD6Q6u2OxRrSbjbnzX6O2T0nM=
Received: from DS3P220CA0002.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:45f::16) by
 IA0PR12MB7650.namprd12.prod.outlook.com (2603:10b6:208:436::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Thu, 13 Aug
 2026 10:50:40 +0000
Received: from CH3PEPF00000016.namprd21.prod.outlook.com
 (2603:10b6:8:45f:cafe::2e) by DS3P220CA0002.outlook.office365.com
 (2603:10b6:8:45f::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.15 via Frontend Transport; Thu,
 13 Aug 2026 10:50:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF00000016.mail.protection.outlook.com (10.167.244.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.0 via Frontend Transport; Thu, 13 Aug 2026 10:50:39 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 13 Aug
 2026 05:50:39 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 13 Aug
 2026 05:50:39 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.45 via Frontend
 Transport; Thu, 13 Aug 2026 05:50:34 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v6 0/2] Add Reorder Completion Queue (RCQ) support
Date: Thu, 13 Aug 2026 16:19:52 +0530
Message-ID: <20260813104954.319065-1-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000016:EE_|IA0PR12MB7650:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d62d4f9-71ef-4c21-6344-08def928b762
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|23010399003|82310400026|376014|7416014|18002099003|56012099006|11063799006|13003099007|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	/jCAB4kib9OWfR01pUS1rk3pQ3K0Z5fzl9U3Ea9AnAcfhieE2+Hzj51hXoN3uqJXmgJSJaVPXfaivQxIsCa7IHqFdn/gPZR/g4lR7gExbqvxktYm1yna+Grdgz4eq6vGUOR635fXOUgpY4GcWTFUmA96m1ELqYWVkHN9J1cEP4X/XmXTfbQnjWRaU4wC5X8IfbeuvbBbrWv8hyuLuHo78cBhCN99g7PJJUAYPpDMtaTqDC7gTI7NsT5rErIpZIBiU+F7A5Q/4P/IcbVPY51eOnX29gfVyGQen04+k9/wSeAvMKWRymlUFQzc1MEJcaSW+Dy0m4xvEcPSb8wv9QrWBBJGAC6kfd3k4286byJWgPUwAsJhOY/TPFd0pxrANGnmFSpYee54ubRydJt6EDi9dMQEv0/rT1efR2KOiTVoT0R+RItpwfCYXs4gh7T1l4eNOUNgInMzOk75EOtvBzL04fkL9BTmVFaFIIr5g94iQfBQ1jQXQM0Dw44cs32hAkceixRR64A8G8P7TrAAQWnQDN6G+gpgaKJxD5Fv2wsKOOSYl875KXiSjCk+kCnpoXGZ2d5Pyz4lUuxGK8YcmwBrN2eiLLlvB7/eLVC9W7jvcplh061N0Yv4x/mDb4sbSxXqzJhsgU52hkTE9ocraE9jEbMbsO4aQlEi+9Kz5l1fudZakFy71FL1dCnzu0QjIhm7fosZcYpddRauZsddHgml6w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(23010399003)(82310400026)(376014)(7416014)(18002099003)(56012099006)(11063799006)(13003099007)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nqCrNM36rNxhO8osAWxyvKQ4kbqkBlfbRD2ewtZ4ljIr4szVr/gONF8wGTubDSRqHeu/cMHcAyU+ppkElHP37MDx+MVazugSCBjdQPhskPxq0Comlz2tUzFIz9fcw+I2A2tjOTOtFHgZYtIXzV8Vem2oQwv880+lVvBZTJYqQHlUy87FTSCMSzUxDGsg7C1FFx8m+78KiSJGatEaZ2slX+jrR8MhfESGv0drY38wcVrZNTMm76LzgZpPVNjgq9cKjpP6iTYCcBgZnOVrTeT7cWF58naIOTmnlSAd4KVApc2/z55JUwsezAzbs0uFimfvCZMXsnERaEbFwZdOu/DpAqzByEnsqJwtXBBMMzmMD5amN3Pm4e3Fnjt9mehBibjAp/F6l9nk9p+jUnkLS1imUQRUacyx2+ulm32rLcVwN/EnSVSw9GN0F6GR7hnfAhmx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 10:50:39.8629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d62d4f9-71ef-4c21-6344-08def928b762
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000016.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7650

This series adds userspace support for the Reorder Completion Queue (RCQ)
feature in the ionic RDMA driver.

Patch 1 extends the net/ionic firmware identity structure to expose the
rcq_sign_bit field from the RDMA LIF identity.

Patch 2 plumbs the RCQ sign bit through the RDMA driver's LIF configuration,
exposes it to userspace via the ucontext response, and allows userspace to
specify ionic specific QP flags during QP creation. This enables rdma-core to
discover RCQ capability at context allocation time and configure QPs with
RCQ support.

PR: https://github.com/linux-rdma/rdma-core/pull/1733

v6:
  - Rebased on latest for-next
  - Added comp_mask in ucontext response
v5:
  - Rebased on latest for-next
  - https://lore.kernel.org/linux-rdma/20260728111323.2559185-1-abhijit.gangurde@amd.com/
v4:
  - Dropped robust udata from this series and sent as a seperate patch
    https://lore.kernel.org/linux-rdma/20260717092345.2533564-1-abhijit.gangurde@amd.com/
  - Addressed sashiko review comments
  - https://lore.kernel.org/linux-rdma/20260721121034.1616562-1-abhijit.gangurde@amd.com/
v3:
  - Added robust udata compatibility checks
  - https://lore.kernel.org/linux-rdma/20260617132605.1888205-1-abhijit.gangurde@amd.com/
v2:
  - Dropped QP transport mode selection
  - https://lore.kernel.org/linux-rdma/20260611092544.783731-1-abhijit.gangurde@amd.com/
v1:
  - https://lore.kernel.org/linux-rdma/20260430123931.3256130-1-abhijit.gangurde@amd.com/

Abhijit Gangurde (2):
  net: ionic: Fetch RCQ sign bit from firmware
  RDMA/ionic: Add RCQ userspace support

 .../infiniband/hw/ionic/ionic_controlpath.c   | 20 ++++++++++++++++---
 drivers/infiniband/hw/ionic/ionic_fw.h        |  2 ++
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |  1 +
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  6 +++++-
 include/uapi/rdma/ionic-abi.h                 |  9 ++++++++-
 6 files changed, 34 insertions(+), 5 deletions(-)

-- 
2.43.0

