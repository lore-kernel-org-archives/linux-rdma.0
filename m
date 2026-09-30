Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E7C477988;
	Wed, 30 Sep 2026 09:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790760111; cv=fail; b=lAfRcNWz9qsMv5+Qhj+cTeJuJtbGpoYH0X6maoesMPLHtWA1GQRqbG50X1kc38oUp6j4By1VdY9wh50sFZxc5Cij7Sqb1Aq+XDf9dc07sxKXGDe6AZeeL8OPPI3oaJa67is5EcNA3xVgtA9lglD9/g5SfLzqWYsG0qR8KFFnwHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790760111; c=relaxed/simple;
	bh=2JNdX7asrGTEXicAqs1bLbGHUAjMQsgJFYWuJT+ZKYk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rGF6hwbt8FQZyh8EzhxiG5snmf+zCN6deSriO2nvAqHQKfV1AqDCRTTuQODsew6AKM+l0DkTpItCEheGYBICGPcd4pnHNcCqCtaWIXNFAv0ScBWbeUaHYSLTu2kYFzWeZWMghIKSets/2pvt2CQg4wRU+EFLns2rv4QmEn1eSY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WxMgnd2I; arc=fail smtp.client-ip=52.101.43.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WxMgnd2I"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VJSUkw8HZJzCmrOPVYH2IJ2dWA0HsFE1IqeJf7EpTySCojIVMmLwG4jH5JouzFEPez9cLs2lhxGwk0lL+kAVDCq/ixVKOnNkUhIqZo6so6YEhjkrRO3ywM3EHKlZo7EjW1Id5aU+NVcg5W3gd6ZEUC8K6HsKWT26AyJkQzB89WqHEmJWIU2l+cry1db6nBZGFRW5idoAIU4mVtFK5Dlercj1skahIZbqEG8w7Ig2pQA9R64+jo7MKTUEi/wWtoDI9tq2pwRGRIgYkSxJYq5MWqWm0CoWuPc7x6bbQTaaC12XsOhXjtlYR1jYWOOftv6rHEFp7dS9E62b6dRYPNTb4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HdimKOTgsQeTs2FScOujAGH0ON0CtCiReecuqZx3StY=;
 b=heI2FOTODtJZxiN72BxAWXMiRoxgLjpj5LdloUmE67cyQPJSoMAGnRkQ0nfxQ/nF0IHhzscSczcJQdljNreSqJ7cB26tPK29vV2cVG4eBJ3oMsFInGUOMmF5b56eBqQtllkT7M5qI0TEKxAoUozTTE7P/HR1/AuRBkDkIbkcWMA0NA0GrtUXTfxpPFL9CWtkTvEW6E8TqCZjNhKqKXG8DGHhyBBYHBL2fZ8CGhpmE5VmRID1QUQ8VmqAFNbxPhVWLqsKr2dYJRqParNIpew6SvUJQavOGlnJVAb/yg0kvNnGv5mFBFGTI0sBSWWuUgd8MllUNIp+pbg1sPkT1a2eLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdimKOTgsQeTs2FScOujAGH0ON0CtCiReecuqZx3StY=;
 b=WxMgnd2IRY2ZLH06Y0qqO+urdjzdA57aahMpVzDiA0Yv7pnWWkWKsP9Pc0efWhv/4EhaO+UPGRt9D/Xe2EM10mxZexYL5Tbu2uAXAiR0r6kvfSSIh3NxL8Z8JCJqrQyB2XXecUneXn7IKXowjmdEKr0pl5Wg060lvXtUX+4QSfU=
Received: from SJ0P220CA0016.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::23)
 by SJ0PR12MB6992.namprd12.prod.outlook.com (2603:10b6:a03:483::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Wed, 30 Sep
 2026 09:21:44 +0000
Received: from MWH0EPF000C6191.namprd02.prod.outlook.com
 (2603:10b6:a03:41b:cafe::28) by SJ0P220CA0016.outlook.office365.com
 (2603:10b6:a03:41b::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Wed,
 30 Sep 2026 09:21:44 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6191.mail.protection.outlook.com (10.167.249.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 09:21:44 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 30 Sep
 2026 04:21:30 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 04:21:27 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v4 0/5] RDMA/ionic: add SRQ support and firmware assigned CQ and SRQ IDs 
Date: Wed, 30 Sep 2026 14:51:06 +0530
Message-ID: <20260930092111.3176738-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6191:EE_|SJ0PR12MB6992:EE_
X-MS-Office365-Filtering-Correlation-Id: d20599f1-360f-42f7-49f7-08df1ed43eb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|7416014|376014|23010399003|1800799024|10067099003|56012099006|11063799006|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	F7mZSt0Jzmgi+Dyrygjq19rc5UhtEKfmfXcY0y979HwMJH0AxylWH9oqgi8cCYoyAYvGzAIyCqgO8FIkR9zcSmzma+V9fihCJkfLJ8GOsXuT3wHyKipJ/UqMgwkLIhwccq8YvpmfIJAbQEJupRpDWV/5mJvPfjXPR67hFkuzILKuHSpgk+31UBE732FNePuAd6HKcSn/HuUOLIDCYxLMzBjZ+2xycBBhYPo8YYfGkI6dBg310E7jUITyLKZu0hTUX3oummLXGol/tleeFbi9+ygcEK0OdTpNpt4CVnk241eRsjT11Jn3vSMkc31q1OW4qClGaPZEuIDrJznfG2GvERzzNU9/StM0k+Rp2F2kd6irP2Ty2Jztxd9q98cjEGSPVq8pry4Ou7j78OjKCNP5UHvGIg1HlpZ5NYPiRIFF2MbxOjhaoK1WNMkwdyz0tkesj2cFJE1s+2m4lPH1yLTa93SdhsexGvNP7Wn6F+IFFFmb5WIaXBqT4jYLEMN+BD85qLZHOJMEEt8fXl3SY9WW5luhfzcGqtoPBrGWVtNtpB790UNj6hE4/hsXL2viYq3N+LQtodOqVeGL4LcCbkAoq37pks6rGH/lrsgpcDVlHEq10rO+fj+KL9EjDUXI2mamdQYQMPqvAt6sxL5utN5ww+8HQFgH95i7dqJQITYJFkGohdsbnEbmmGDlzFCa4LJ+j0i62j/Y7b8brZq5fVLxtQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(7416014)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(11063799006)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bmnIlWVKPLDH18WgmCylRPBA6Afr4MI3fSPeHVErfqtx6cGmzEaVHMerW2ZxeSH1ztBIpb78s2nIN8SewBORAXx/Gm0cFm7PefA0VHbakIkN6XcPxmWUUm+tXDyEBGTgFiNLU1V8b2aY09bmdJ65L5MhnJT8bjb+izZj7IMS5Vz4FqGpL1ynKdh3oFhneOQuWVZ86c8PCoQsGFFq3yNVvWobaXGf6J2l/bxAZtSdGUuncRSYzyvlqtGZyI+VuncQ8h4XGjD/casgchS1lgD7zecBe26erPWQzNAJdVRNbq8yna32iEFJubo7iRuMoeZCxLWoPQPEpmh4ehnp9dxxU2mFu6WeitiK4ZYu1W4JC2cGohnJHnz65Gl9S9S2p0Y3/Q3rdF5gDPycDJZ4SVz1WuyujXI+q4lmjgAF8ubauDdb0uEQSmE2JjIHO1lQ4Md3
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 09:21:44.2537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d20599f1-360f-42f7-49f7-08df1ed43eb6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6191.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6992

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
common changes pull request:
The following changes since commit 93f51579e7df248780214094418f205253383cc5:

  Linux 7.3-rc4 (2026-09-20 13:48:15 -0700)

are available in the Git repository at:

  https://github.com/abhijitG-xlnx/linux.git ionic-shared

for you to fetch changes up to c73a5f20bc786df0be484af29aa5956e909dc862:

  net: ionic: Fetch qid allocation and SRQ capability from firmware (2026-09-25 11:48:12 +0530)

v4:
  - Rebased on for-next
  - https://lore.kernel.org/linux-rdma/20260925082802.2675902-1-abhijit.gangurde@amd.com/T/
v3:
  - Addressed more sashiko review comments
  - https://lore.kernel.org/linux-rdma/20260922095724.3683011-1-abhijit.gangurde@amd.com/T/
v2:
  - Addressed sashiko review comments
  - https://lore.kernel.org/linux-rdma/20260908090802.152142-1-abhijit.gangurde@amd.com/T/

Abhijit Gangurde (2):
  net: ionic: Fetch qid allocation and SRQ capability from firmware
  RDMA/ionic: support firmware-assigned CQ IDs

Amit Kumar (3):
  RDMA/ionic: segregate rq related fields from ionic_qp into a new
    ionic_rq struct
  RDMA/ionic: add Shared receive queue (SRQ) support
  RDMA/ionic: implement SRQ event handling support

 drivers/infiniband/hw/ionic/ionic_admin.c     | 117 ++-
 .../infiniband/hw/ionic/ionic_controlpath.c   | 781 +++++++++++++-----
 drivers/infiniband/hw/ionic/ionic_datapath.c  |  98 +--
 drivers/infiniband/hw/ionic/ionic_fw.h        |  74 +-
 drivers/infiniband/hw/ionic/ionic_ibdev.c     |  20 +
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |  85 +-
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |   2 +
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |   2 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  31 +-
 include/uapi/rdma/ionic-abi.h                 |   2 +-
 10 files changed, 923 insertions(+), 289 deletions(-)

-- 
2.43.0

