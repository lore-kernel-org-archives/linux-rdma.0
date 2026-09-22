Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012057.outbound.protection.outlook.com [52.101.43.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0134E9C20;
	Tue, 22 Sep 2026 09:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071108; cv=fail; b=YOPaC6qrTS4cUYUUMjk19CCZsIl/6jgsPO/V+SS7qMSKY+K50iELNG0tG0a2kULX0rYl0nj5WJ/rX1RJgsAb9u4dozVrQxJUfNCaujsXlw3sf7XNMiJnr64SNLoDh7G2Vbv1dZEXHPlUNy6Xt7PTRNUjqQ1hK4FsrHogUJb699w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071108; c=relaxed/simple;
	bh=9+1C9JJB5hiRTaV1l0WXRoF1NO/whLi07DtAMBbp778=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tZHGBduiBF+ojDeG5Bwin88ax9OKTSkR9rmMIolg5JbkPmLgHq3B4McipH5a0eq9yFEZM1G2AbBwJu0G5rhO+gHpMdKJPTK7SpD5ao+QiWjA+3kXpIyx0hW+rmWfQRC43t8yYNc/FqPwFw5naDxVxsOs0bs1IH6jC/KSqrvHLpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1n2Tr+M7; arc=fail smtp.client-ip=52.101.43.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1n2Tr+M7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GsvJbcgAGnOD8feF0kgXI+gV7/oZJDN+KUMdpgnpasRczj0SQkDHDK5tM7XTzlsrcfbBF2/GsJWBRDQhP2IVuOJQz+TCLwSFsB0umhp12wpqRR8P56yq1Ikp1teyHKXfCVRNHrpOAaz/PfW/CZVW4wmqYX1DoaDT+BEUzI7fajmxmvY8N8M5Kv/b6+4vjtOEp0nk52UvAStrp2fZjPjbaLBKJsHo+0cL171MCSsBbTxWy0OALELmG66/tyknAraHXKzCEQggQFyycMuN98YdmEx8VJ2XVbD1X2Hcsp0MU2OcGoCvXSdjV8eiATaBxaYATGee8PjknECh34uSNCDgLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g2AJsY92B5FiVfWxtT8FDdPOD1R8awnKu8mqI1p5o5Q=;
 b=iQnlQ4eSB7XbFSR6cxBEFYvaFXxlhXHkV19c7M5L81J4q44sx4z4+TU77V3LUUTUPPuw62+79QziQvpmSFVZxJXhYh9lp0NMJuRuijZlxk0hojS7UNVKqHOF76X3j3mGSjn/WBuSnq7VNB/OQa+AGDTAk++SVV/FdfHPJHu/aZpD1585VHhVR3VdUipa9QWHGUr7p5G5oV37jJcFUNpjQ239mbj8wiLnYmkl4RkTMt28nyH8W2LeSehc+ockWopFMqYJnnjNmRLa4ZukDC1ZR/6ZHNPd8RfiktEr+3XsOFnS+S6YE210NJS8KZOV+vxdX08/k39KI54+DL08ekt4AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2AJsY92B5FiVfWxtT8FDdPOD1R8awnKu8mqI1p5o5Q=;
 b=1n2Tr+M7KNnnVuoi/F7IEnPealp6HxpPw2BttiqKeGPYz1VTCeRQeWsa0oamhM/nPB8o46ADmF9XqpcK7W+U6eC4eDPsVSF4Ooftf24EjWAl9EFGPF/8RYHSt+LhrMRIsvOIYwyeBAdub8Ul3U4eO6qxDt4lnHv7LTtOyoDVVHM=
Received: from SJ0PR03CA0068.namprd03.prod.outlook.com (2603:10b6:a03:331::13)
 by MW4PR12MB5668.namprd12.prod.outlook.com (2603:10b6:303:16b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Tue, 22 Sep
 2026 09:58:21 +0000
Received: from BY1PEPF0001AE17.namprd04.prod.outlook.com
 (2603:10b6:a03:331:cafe::60) by SJ0PR03CA0068.outlook.office365.com
 (2603:10b6:a03:331::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Tue,
 22 Sep 2026 09:58:21 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BY1PEPF0001AE17.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Tue, 22 Sep 2026 09:58:20 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 04:58:20 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 04:58:20 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Tue, 22 Sep 2026 04:58:16 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v2 0/5] RDMA/ionic: add SRQ support and firmware assigned CQ and SRQ IDs 
Date: Tue, 22 Sep 2026 15:27:19 +0530
Message-ID: <20260922095724.3683011-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE17:EE_|MW4PR12MB5668:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cf102b3-4266-41b6-e84d-08df189008a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|1800799024|7416014|376014|13003099007|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	kKj3HTn5KMH+qvBw3Hy0YjOUmd7F+1R6BOu5L/jk09vkJTpLfOCe2B5Bl4awHuBxaoeP1H7LHoaMY4dC+VEXujdrJlF3KsQQ8e2R8jDBM283UbLbxUkGvXpS6TrpG7241UvYsJgkP0JlQulvlRs2JksSjzb4tjCVOKjFdHIkx4qfj/V0n9wfQ3MGYS3YcRonzcIm4j3PoHJpHyF+hwfVU+w2jfgo8lxo4CWQz7Qd7CQPkH2sLCt8D9d9pyxIMMMsz8bNnWbXB0pRpszV6VstMQwNA0y1XPU8eadsnhJzbGwDRwSPPQm4AjztEPXt2QPwkXt+65dL2r/pcjyyaYiPgOxsJH6AZN9rGtctr4ej5N2kiwSMUVbiH42nVl1DSD55Jv4N5s1dOP4mXQgqXAFUBqd0RZuHyHEF1ryx0uCFYm8ffzupdVtaw6cVj9UFOLQe6XDEhoHNOAdCeTqNowSujDwhgIjg4//s1VFKdcyV1t7Trplw7Jp/dceCkdMHlOaWteigafwp3vyCvbIeZzaCVugEKLueWpBnliKl2O2Ajg0+8BN7oISqqWHp4ZjTLaUSZVAPHUrBEXC8JCtgOG2Nk4F5KBcZabEFTIVKerPybOg8aCD7ZzfiI91cMR4M5FEwUM6v5be/q72Q28on4/szVA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(1800799024)(7416014)(376014)(13003099007)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	K9THREDifiy0jPVbo28ibdK7JP0LP6AUZ607xTXx4WbAC5R1VKOhywPbFQHfvblsN9zyFuk6bsSv7DTxJXyLF9CEvcsM4I4m3Q33p/eINNXJGDaKVijUAPM18HpwdfpvJkE4RYJlRcqiJcwmTKT/ixHjYkrHpCwbGiIaItcki7Lphznmit0avJwDX8R0LoCamKHhsicQfCopUHW8PhIQEKQuXCZe/yMRH0ZRUkpANNjqVhZ5u7R38aZnnNjHAAtxZr/J2hRSSzbZPfKAtCOxHqFxCzxGOk9aj8QaBkOXj6Gzy/1sdL6bqz8f5cAOW7XW968YVEZmSr5QsWyvYWKkFrYPQBq0UzEUQJBCH6ElA0oG3HX5w8LwKqXG8R+w17SMxTNxsBOme4FRhf6o8zvjFX23YbWyk19l+DDKLlfQZ6vJkGlHyB20/kc0Loh+AoA1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 09:58:20.8639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf102b3-4266-41b6-e84d-08df189008a4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE17.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5668

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
he following changes since commit 93f51579e7df248780214094418f205253383cc5:

  Linux 7.3-rc4 (2026-09-20 13:48:15 -0700)

are available in the Git repository at:

  https://github.com/abhijitG-xlnx/linux.git ionic-shared

for you to fetch changes up to 0de2c94091670f14c33029a793083516d34ef277:

  net: ionic: Fetch qid allocation and SRQ capability from firmware (2026-09-22 11:14:02 +0530)


v2:
  - Addressed sashiko review comments
  - https://lore.kernel.org/linux-rdma/20260908090802.152142-1-abhijit.gangurde@amd.com/T/#t

Abhijit Gangurde (2):
  net: ionic: Fetch qid allocation and SRQ capability from firmware
  RDMA/ionic: support firmware-assigned CQ IDs

Amit Kumar (3):
  RDMA/ionic: segregate rq related fields from ionic_qp into a new
    ionic_rq struct
  RDMA/ionic: add Shared receive queue (SRQ) support
  RDMA/ionic: implement SRQ event handling support

 drivers/infiniband/hw/ionic/ionic_admin.c     | 117 ++-
 .../infiniband/hw/ionic/ionic_controlpath.c   | 782 +++++++++++++-----
 drivers/infiniband/hw/ionic/ionic_datapath.c  |  98 +--
 drivers/infiniband/hw/ionic/ionic_fw.h        |  74 +-
 drivers/infiniband/hw/ionic/ionic_ibdev.c     |  20 +
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |  85 +-
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |   2 +
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |   2 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  31 +-
 include/uapi/rdma/ionic-abi.h                 |   2 +-
 10 files changed, 922 insertions(+), 291 deletions(-)

-- 
2.43.0

