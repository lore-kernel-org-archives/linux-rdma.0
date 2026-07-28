Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013017.outbound.protection.outlook.com [40.93.196.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9583F0AB8;
	Tue, 28 Jul 2026 11:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785237222; cv=fail; b=tUqmOJ6Is1EmAzQd6UAQvJ5c79tgBSByzyT69Cfp/70h1ap7p4nM6dvgSwhCOht/T5GTX6HFiuj6g8nMTR+dfEHJguthdqoGDSoQEY3c0MvioOz7X32jmDBLYjk8Coe7k3izoKlpKIIkAh1TwpMTK8YNZ8US/11yu4cP1ULKBqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785237222; c=relaxed/simple;
	bh=Tk4XBKCXiYevd+Oz05b0BiCMIPfrkXhxEa/3TCzbm9w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uwr+2G60d0uGDKU7U0dgEFIkrlLvVeC5LLiT9RXmu/M616im8M4m/uFAlb9IzrS8AsG4GEFRbQXjHlU63DbUCI139f6ecbxFsFSZu/lcsCvfQXOiMg+LdaKuEfTm+MGCd4dyyNbpGgdBSGtxSOsCh1vjOEEE9sbsZRYvlooU5nQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EiWV98rE; arc=fail smtp.client-ip=40.93.196.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EiWV98rE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GHaphDVA/sk9Pt9c7TD9ozlrbtICuE1lTMkFWsBNsQt2StzdouNJFad4tVJhUM0TbmUeGKsLPe+Q44oL46T8ty4rLerngtybDh0OerfUo0vARTT9dfu+gVTBsFPG+hy/QhnBhD1yXMieenfld7NSYTqcU5bHppgorYQvlgqTSpBmYtlJgYiPZ9HeiqY/1Lo4sgfuoSsktHoaHKhFqCtLVOZvN6YupzIQofg1AnJrjn7sGWv2mewX4xHIW4RMIa2A1mFZgvIuEbHRQg62xxDCvIKSEUh3hn8rQr2cUasUhvVlObG7HXN5EXkobQuLRoBj9vZsNavZqJjz3eXUE6IGNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGmaC8DaXNWiaAPsiq+nHvWVukVeD6BtQvGuZO/pwAI=;
 b=n77HW/hh4xicBLsym2kFacZglyZ8yZ2y5SevyG0xj4dHVXJPurNZDCYNw0xTcLZO4ft83eZmQBypZBbHcKHn42MMlIjMpBiQ/X6RXQDN3+pWPbMTAWvRAJyrgrtz0w7lTINGXWvFGg+X8PempmIs3bEP0YVAFcsT+ewGatmjvBDUb5VnvCkBuVP3jpK8DtKvv2NLxaWC92PluMP1cXbGP7qpU/fbnbpY7uppEwGhY6pOV+x/gyr0eXUNcOX/wNJlu/l+eSWNQxbnAfb17/Cpi8omzMmLBoKTNxemVLPLE67k7V3li1GcBlwPgh4bUyvOE0yOmxpb9TTXfBtYrRjnmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGmaC8DaXNWiaAPsiq+nHvWVukVeD6BtQvGuZO/pwAI=;
 b=EiWV98rEtpZqNAhm9Tcfkc/S5z61TW2fzVLy7wMELr4nDLvxopzijAZvcc8zoM8SPuN8UzyfDT8Q5Al4Evv2b+ixMoEQpmscvr5kyWYEB4uhlxYtUOekLVdmcEi2HHLQcBpfVaiKUXoQBetlr+arlcnfF6h/r30JPMoOFUVDeuU=
Received: from CH0PR04CA0105.namprd04.prod.outlook.com (2603:10b6:610:75::20)
 by IA0PR12MB7554.namprd12.prod.outlook.com (2603:10b6:208:43e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 11:13:37 +0000
Received: from CH3PEPF0000000E.namprd04.prod.outlook.com
 (2603:10b6:610:75:cafe::76) by CH0PR04CA0105.outlook.office365.com
 (2603:10b6:610:75::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Tue,
 28 Jul 2026 11:13:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH3PEPF0000000E.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 11:13:36 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 06:13:36 -0500
Received: from xhdabhijitg41x.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41
 via Frontend Transport; Tue, 28 Jul 2026 06:13:32 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v5 0/2] Add Reorder Completion Queue (RCQ) support
Date: Tue, 28 Jul 2026 16:43:21 +0530
Message-ID: <20260728111323.2559185-1-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000E:EE_|IA0PR12MB7554:EE_
X-MS-Office365-Filtering-Correlation-Id: 3292edb4-d075-4c11-25fb-08deec994527
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|82310400026|1800799024|36860700016|13003099007|6133799003|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	v46gmBI12s1e1zuIcabXNTzK/fL7Jx7BnnNRPHoVxur79nZ5nzCl9A8tqBTE2wTfDUxDbVKT2XtA8Urgxs7g3cBFrgps+tGa35F+X8WxQiWkDkLDxDXoogDbDl0Yi7uo3uOn7WNNXT+QX4KSK4EOM58pfXMwPNCihy3sbHBY1aB//W8T+895i0uii1IInfjwo3kmBBn76mijLbbtNcr9yZRC2WM8hzyKVKlAOYsStKblGjz2wPZ91W0/lRj7FWaChTMHbldQL/FJ7U9KjDaR8EyNVdI6dwJiV1tA3wsvye639i/4DTqfQisHbJ3Moe99ukXnhkif1zELQxsGbs5k49si4RA1Q4Y54/95SCGbJXmAbbfvMT/Tc/4T1aW0YWEBT8oeccU0NFXzq8anUwHJZsmo0votJc/2JlJC7f1MtovWZWsZT7GnT1VPbvps5mxNFVCareCS6K29lzTDD0VLJmmWhqkwVy9kIL7BDs1RKhAQ+h4Xgb78w7MT1VhXgc+8unFdVcsLvL5THdupCFmZJQDEKmBJ1n1+XuVgO2s1a+PHhRTi3XpAEFv55ClF5QZodoHkUMr0QQeXu3fYUNZORFxBjyxSpS2I78z+7Vhw441uhBGUDUIbDUHWmO43FfUD53vDzfJvVxbsPUtg6HUcp1iIuymoNRaLsoEN6BSjR8wHURgVpA3QdJ89w7d6o/WdxIFBapvHnGr8L7Be/p026g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(82310400026)(1800799024)(36860700016)(13003099007)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WBM1rc84DWFIl0fvQTdCnEEamHU9acR3eU+5byOtWXQ0D3zGLk9+np7tAUcBwuZVBW5HxlPC2frXymgC4fPhflcJx4xGdj6UUYMuGxTZfGS1vKdtyu0Man2CQxfETpS7qvvH7Z4bfmqAIbmjETjisnmyLH6dVHAJc04zNm3qXzWYU9hHawp28NIGtNEWw7+cjW4JOuOUeJXAhuo8R1kpG5pRxXZmmaxLFNaCXRQ1RYcTF27tTHZ1y4pykyPNAyT9VIESVWiW/yUsHbTJaM5cdHmnw+wo5NVO8fk2kevgwS7V08GomTxjJ7ALdYHvJ/DJgaxRL26pg78YKqJ04dYPW7/t5k7U5CNi+wNfHZSyRB0GAnof78K8CPxBcwCiPAk3mtRb47aSwA0lu30mYrLF4FMCKGCtaBmqihr50tUWcNYA4cerrBhe2fFUVmuW5hcM
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 11:13:36.6987
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3292edb4-d075-4c11-25fb-08deec994527
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7554

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

v5:
  - Rebased on latest for-next
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

 .../infiniband/hw/ionic/ionic_controlpath.c   | 19 ++++++++++++++++---
 drivers/infiniband/hw/ionic/ionic_fw.h        |  2 ++
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |  1 +
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  6 +++++-
 include/uapi/rdma/ionic-abi.h                 |  5 ++++-
 6 files changed, 29 insertions(+), 5 deletions(-)

-- 
2.44.4

