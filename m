Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012018.outbound.protection.outlook.com [52.101.43.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76832481234;
	Tue, 21 Jul 2026 12:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784635860; cv=fail; b=WNGTu5WXxTcra9hF2+HaQT9GW5DZkwqhGPCB6f5eRJqaDnGGUzCx/wTHNZ0z1SB5In8/ZT+vLs3uQvBWgfW5luuyeFfjjJQo0C7hdWXtaHhzpUwk62yO/vBdJnh4zmrBigUTDvvKR+RvfRXntshfUdmjQRkRCp2UnYsFCQZ/H60=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784635860; c=relaxed/simple;
	bh=1uoFSqwMkPAeH6E0t5t6i4vbFL6K6mBJ07h7DYlaqP8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pJzK/0FG/YuVtnebWu29y9nCRyvqNfsClG1TehORppOav+601qkcq3hDf5fISvb6T11Wc2qsL7D983YEk8BXRSfhPvqYRLIfqhuy3rd1TqptgSy4tj7WQwAAJoARBMY7X/aqdAbjjamle2Tu9GH62g4PjFDI42cQitVPZOW+TWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BfaZv+vL; arc=fail smtp.client-ip=52.101.43.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BfaZv+vL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TTEaR52S+ZdgIX+Ak90O41Bz3eCJJpiOT2S8gWaLmZ7o8W4GKbTO4G4oGmTuL7tQajSqrthmU06jekUrkxiVuo7VwPllkRRwOOuADK/2ra7u+Y67R2XjNNgQsT8LQDvq/iCnSs3IpBQT8evbCzVWjC4KmVRcFTEK9Le7cD1Dyb8TvmW1WnWbYDro4UVNokxVaK+mYHysnCuf+UHPy8MJwrGBW+jooAkrGZtp/3GKJpsd1w8S9vWYe4HNWfOWRLIwAH8Va1P3QrKRdTW17hZEgWppRZLJ+FaG48QAe/iC6KtvZpzly9+48W9tGAUQxo9/nvCCPpUVSBupoa2A93Aflg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRGLbDuoaH29cNYLlq3INH7GOGKrc1NK8ZWb7GffHOg=;
 b=mCSFh259cJNh7ZRzfRNWgJopWyTBTL5TdMCvGa2ZfMbkmMfFMAP0qBYe34tIbOaB85e9EaTX0zC5y6PHOMTG04K8xEhnfVAZv3Gg4vsmqoeyX6Gt5j+1PdNhx5WXeCOlLb3nurb4Pv0bDEWOxgjAVWI47ZEpMP9e8LTPHfnW50JDS5OlUI7MsiAdjwCxnDxFXtEDzG8UgxeZJnsqBy9mFNo7ki5msZRgKR2eIjGMUOwDwfH/a/S/zP0yhLynkn4lvNacRSReMCHFFrCh43/5+PNG+W9kTBq/BNPCw7ruQl3QP9pfBhsW3L4aeWhAH+56tu4zqEi7RvU+rrP5HQS+rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRGLbDuoaH29cNYLlq3INH7GOGKrc1NK8ZWb7GffHOg=;
 b=BfaZv+vLZe4b77Bn6yAfXr9ZnqlY1G8gDxJvPlfqGn2wO+TsWYpXeAmUuHfyISOlqAa32e+PACisaGq3BqauPlilS1a7HXP+Gkdcns/gP6v6qdnN2o+d7cTUCnwp5eIHmGWYplF8fuQ4U66OFaEubX3GlhkoKbk3/rQ3VjRKb80=
Received: from SA1P222CA0089.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:35e::19)
 by SA1PR12MB9492.namprd12.prod.outlook.com (2603:10b6:806:459::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 12:10:53 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:806:35e:cafe::88) by SA1P222CA0089.outlook.office365.com
 (2603:10b6:806:35e::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Tue,
 21 Jul 2026 12:10:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Tue, 21 Jul 2026 12:10:52 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 21 Jul
 2026 07:10:52 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 21 Jul 2026 07:10:49 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v4 0/2] Add Reorder Completion Queue (RCQ) support
Date: Tue, 21 Jul 2026 17:40:32 +0530
Message-ID: <20260721121034.1616562-1-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.44.4
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|SA1PR12MB9492:EE_
X-MS-Office365-Filtering-Correlation-Id: 853b2dda-4185-4db9-648d-08dee7211c6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|36860700016|82310400026|1800799024|13003099007|6133799003|56012099006|11063799006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iKRoGFQxBUUrC2gNz2VdNcpEyqMFFZ9AL9AEJO1BiP3mPKIO67zJSVPJ+QJquLi/sDgwSmezkpGyblenOV3tFuUa0n5BlkgG13yV64r4CW5B1d+YD+yuKGTSas1ajSnDzOH9R7VXAD2ZBr2XQ7KNBSkzFoZ36sRzyzK4dDJtN4PrjlDGFU4SSHUiYSAh/qZt6DF8QmG2a0GpgAfqLnVyaOlfayTJflgConyk5HG80srlIT0lyjjI6PNw00sinmrSOjd9UG7txTOkE3H3yo5sYNlW+QUxIzyJX7bQKEMEu5+1eFm6Dbii4x/gOAOM71Lu1zkY3/NsgAP5oADv1fS+mqldGL0Sjjv3rRZcCbKLtiz9yhOfDQQSpURDZDg/e7AcQeVs1UUQCpSFsTZHxUbya9xl1LTIwuapMwJ6+dEPe9pBxG6UujEUsMfIV5vNaGoIojRrsN6CobnPH8ccPfLGAEwXPEqzwv5IHCT5IqodnPgIALeZdfTCoT+Qw0mBr906aTOy7/G8glVeXG9oaPzy8S2tHIMl5j1aKTipDj5+FOnmZ9osTyrNk6+vV+xUiEy0DSDOG48w2g6y+kHAf2Kg1FacY0XGPqc1I5jbrMwXY3C6ruWuhjuzv90KwUL3bkH3ujXnct154vMBJN6y0UviE70vkgBKw28GyxuhHXFwjfcYcXa234fYA9ysl9BcgmMziFA7Gg/SndGY0qysFBPZQA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(36860700016)(82310400026)(1800799024)(13003099007)(6133799003)(56012099006)(11063799006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hf4abp6H4AL6hHpT1Yu1dRIN9T+1BXCcx5joR/kixqAOMJFMy8N4Vi4AJkrdWE8B7B8f7vf6l7kxXIbNbNQRwE5cYoltf1YeQFlpCsLFkhZ4JBtvkwvTYs69zCNt0JyoawGL/Pxc/zsN4SfRjeITsSGJiwPVvM3qCDkzLtMkE1rm7Z9yTW4505Wmj5WdGzSKsclMRbFt44AJV8C0mg6K6HBQ2dIpXHnQIbBDhKQmUmzutKRnX3IUCIDccp0Ltmvv98As7GxOrdalB6GWkNp6mn7O8gYl9Q3AJvcFj7JfUKf1zSndEtYIM/o9yZ3kTkB/4uDhQDoyViCwBNDC6w795Y129oTApt5bEM3EaqeH046K2vX9pBI4kNHsGz16MiLByrTUqbEzecVeU5naT8TLztliopBoaesvxv+kP822RVaggLPdfDY/UmvfSYdbrM70
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 12:10:52.9560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 853b2dda-4185-4db9-648d-08dee7211c6b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9492

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

v4:
  - Dropped robust udata from this series and sent as a seperate patch
    https://lore.kernel.org/linux-rdma/20260717092345.2533564-1-abhijit.gangurde@amd.com/
  - Addressed sashiko review comments
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
2.43.0

