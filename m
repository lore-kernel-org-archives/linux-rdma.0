Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011041.outbound.protection.outlook.com [40.107.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BCC526A93;
	Tue,  8 Sep 2026 09:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858610; cv=fail; b=IgS43V/6LSSHXSgnfqKqfzkusU38k9yZaD/E2jQ5OHvrXkSw+qyHuNby2YpviZVh2s5s8ThHA/d9Of7Pxjiy0/XYTCGkml5P8rWWq5Q9M2xOZoTWVJwxWx5Kg1NhVu12zc1pbawIq+3BQjbQMJdsSuGWuQYtUHempWEKJGHIRIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858610; c=relaxed/simple;
	bh=rZcKvHi0QRdRY8huIX0N3hxoVnb1HeINqsEgVY4dlfU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qY07SgJhYy9zXP5wUP02wmByr5d3K/EfJRDEoymMP7ftwC9BKVJyYzSxcH3EZ7yqOqxW98jwRpm0npmUBe16QfLelhMk3JwacqSptDaalYJy6VyH1WxOgzWFjQq/Is9hMJC8hlCk7TLHXeUBy/POae0inABYVqnjh3qvNZgMM9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fnZ6mRkr; arc=fail smtp.client-ip=40.107.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fnZ6mRkr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uVQTU8/t0BpXQe0kPZpL2q83e5F3L6Yqkw/hECO1uBiZEjQ4upae+ZHj8HG4HG7vme956i3C9Hd9doB3Q+NKdVnZsNhIgkd3Ku/x5O3FJbzWLITiY9ohfimYZO4OO86gaceKkM4nmwmY8WXQaXbRhE98ALY9e8rhpp9gRe4+hJmnxN++JeKZhXbkR96sALEOU5PLSd1LnDHsDCD5B45YnLy+4yyzyRSm61p4D5P0Cbp5JpQE7o1jPc7uIGG8r8U9I+VK+G62duT08Wg8cAWPA2q0RlzOwDRk0wdq/Vln1K4q0omNH0TfbmFKEWZbbLCcF7anRirMs+SOxpSvXUPsRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z7Sc8T4dR6PoIvnv89UiSo98QDWsj/oilX6WBzax2x4=;
 b=XT+nxUa0tK8Z3snZ0Xr8Qm/ibvih2qTIeNn3CkeFlOQ7SxJr8lanQjYXsdrDmwY/e7yV/Rrqtn2BepOC4aCHkwyLgGLWtMFs1+QfS4MSpvW+QiAFnRnmMS+aK5gWtsjuG3TDmzgThdo7n76t+7GQke+QRkpP5ivOjWiAqHmUff0uKb9Whhpoh6FdY8EhReO3t9zea5mt0Bf+Z0C9tLXPvXWA+8IcfB0HeLWHOPeKLNg7a0fIgJuh2Jun+t+ZJoeC4a92a1dq6gsCRohGVoxoVWsxj3/+ALqtLvmxRrunAa3yjbtFLlf6go9scagtYVbX2KG2ebfnZpfK5n+HNu5zQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z7Sc8T4dR6PoIvnv89UiSo98QDWsj/oilX6WBzax2x4=;
 b=fnZ6mRkr2JmmVTZHKEw/f2CDj6uWqUsZdpalGB/L0AWQz7pRHwnjPQlasjsvGwWouFVO3yIpkVa+3RihqqG3SCs2zbMj9aO356rpP1NCqj2CZElmTfyZOew5pf6UbeoQz15havf2Zr2i2dVKPN1Dfayo2BV2n8Ozka3omC+hRYI=
Received: from SJ0PR05CA0132.namprd05.prod.outlook.com (2603:10b6:a03:33d::17)
 by DSVPR12MB999171.namprd12.prod.outlook.com (2603:10b6:8:388::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 09:08:53 +0000
Received: from BY1PEPF00026959.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::a8) by SJ0PR05CA0132.outlook.office365.com
 (2603:10b6:a03:33d::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.5 via Frontend Transport; Tue, 8
 Sep 2026 09:08:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BY1PEPF00026959.mail.protection.outlook.com (10.167.244.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Tue, 8 Sep 2026 09:08:52 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 04:08:52 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 04:08:51 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.46 via Frontend
 Transport; Tue, 8 Sep 2026 04:08:47 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v1 0/5] RDMA/ionic: add SRQ support and firmware assigned CQ and SRQ IDs 
Date: Tue, 8 Sep 2026 14:37:56 +0530
Message-ID: <20260908090802.152142-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF00026959:EE_|DSVPR12MB999171:EE_
X-MS-Office365-Filtering-Correlation-Id: 996915d8-2d85-4f06-e5e4-08df0d88cdd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|376014|7416014|10067099003|18002099003|11063799006|56012099006|13003099007;
X-Microsoft-Antispam-Message-Info:
	EEeJgL4eVduSBIZf8pnpxse/xzPr0cd3JmFDqVNLyyYHnU0IPC28OOHBmjMgHyoKyBCuX/DsMaasbTh2Tj8MbAwrghixSEc145XrhtnHVsRcQEEnCNApi+rh3Qnl21WLM9NrDVIEnlAXJkHUJ23Mjs1tdowcAJ1PnvS8mGd5Vb6d/XiG74ZyKeIjSrY0nLCIFncDafXgzsAWVM7S7TzjzvkviTYqxiq4GWiE6J+Lw864j2AijC26HTzl7UJ8am1XHvYogcuoMRVENecUZCRjeA1zq+KG2nCE9Mb7mRu3OeKFsG1JoCnfs0jUrHRLWi9Xz9LjFPeDp+s9CKq9Olp2akmg0i2sVRkplSX6L5il9jdIKgnBuVPWxfedWttAEt9KQ5a6k7EzGiXIKgh3fj+A4MQqvV3mnk+bmDIG3m8kycG/IFZjPM51JJxI7RwKac8SFwNQdCLzKFAD73TIgIhReoIKZL7jxinxdgE8/ys6z7Qzw8SL3GvT8omjtm8aXnnzvoe62ZHwhfSbWf24gbt5n1e1kzoLWljRJs3LVALISgArFN69Mc2r27C37d9XowMY+K7M1A0h5lnS0rVEc9WMSFHvI0hd8DnK0IA2RiL7JJ0BPh8HVlJp1AB2J5YpThmgXXpV8GDI1fp5pEtntG2QRzBPdlBrO3kCc501irDDdjMIfrpHpPd/LieTeTT/ZtZXmrn4vIoWv5VAFtdXE2I0jQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(376014)(7416014)(10067099003)(18002099003)(11063799006)(56012099006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rqOLnT8dFDrFuwLGI5GejDdnS1gcQZ3BAyqjCAQh0vlCQNbXVb/oW77gIpG8qS0Dijwjf8uZwKH326AGbmZeow8MpVUu7bYSTKuPTaUJSCDHTsdPYrxaO+4Qadp6vdgX1dYynag+BqKqWrZkeTImvXrv0+2xXHkKka3QKL0H1gBcVJRgBO+GceiIWfzkIPnZEMtiYCCV5Rra7GLDTNxNIAZkckIFmB4OkrzlAP7WhHMYr3PJDOuCTCBT8LcwrSBoZg5KaX+Z1G/vmjp+pER+6rSkqvcTsaBn3tNeA6QrkombXrD7P3/zJT+MiJiB1CL1DkCQbTHSdufsZmGqA3m7BrrOcFSXEG4Z+UikhVqQkv92oEeEIQwnXlmp2SwD4XYMMP4r4WdJ1M6fmxA6vYr3m+eYonyswfizLUD62smpzEdn2OfsQLMjWDZ4ZDdqcFGS
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 09:08:52.8408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 996915d8-2d85-4f06-e5e4-08df0d88cdd1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF00026959.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999171

This series adds ionic Shared Receive Queue support and lets firmware assign
CQ/SRQ IDs when the LIF advertises qid-allocation capability.

Patch 1: extends the RDMA LIF identity with SRQ qtype and alloc_qid_cap.
Patch 2: uses that for firmware-assigned CQ IDs and splits CQ create/destroy
so cq_tbl is updated only after the ID is known, and removed before the ID
is returned to firmware.
Patches 3: Refactor RQ state into ionic_rq so QP RQ and SRQ share init/destroy.
Patches 4-5: add SRQ verbs and EQ events. Userspace ABI field srqid is new
with this series;

rdma-core PR: https://github.com/linux-rdma/rdma-core/pull/1799
Net changes pull request:
  The following changes since commit df2908090cda368b01ff43709f51890076c56157:

    Linux 7.3-rc2 (2026-09-06 15:07:20 -0700)

  are available in the Git repository at:

    https://github.com/abhijitG-xlnx/linux.git ionic-shared

  for you to fetch changes up to 4d77450be558f140997fe23b362e4049c0ff0d74:

    net: ionic: Fetch qid allocation and SRQ capability from firmware

Abhijit Gangurde (2):
  net: ionic: Fetch qid allocation and SRQ capability from firmware
  RDMA/ionic: support firmware-assigned CQ IDs

Amit Kumar (3):
  RDMA/ionic: segregate rq related fields from ionic_qp into a new
    ionic_rq struct
  RDMA/ionic: add Shared receive queue (SRQ) support
  RDMA/ionic: implement SRQ event handling support

 drivers/infiniband/hw/ionic/ionic_admin.c     | 117 ++-
 .../infiniband/hw/ionic/ionic_controlpath.c   | 771 +++++++++++++-----
 drivers/infiniband/hw/ionic/ionic_datapath.c  |  82 +-
 drivers/infiniband/hw/ionic/ionic_fw.h        |  74 +-
 drivers/infiniband/hw/ionic/ionic_ibdev.c     |  20 +
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |  87 +-
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |   2 +
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |   2 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  31 +-
 include/uapi/rdma/ionic-abi.h                 |   2 +-
 10 files changed, 907 insertions(+), 281 deletions(-)

-- 
2.43.0

