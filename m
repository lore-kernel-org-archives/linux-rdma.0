Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011037.outbound.protection.outlook.com [52.101.52.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242B7473C67;
	Fri, 25 Sep 2026 08:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790324913; cv=fail; b=fy6gyEyHVaD2BzVIgfGR7BD5gk5/8YMfx+940//RfizspYRYHBtdDAioeT5EgudWjvH04M1CbqkSePLRpGZFqw6NeOquNQX+JUlJEfCC7g0+jpG4IaKNvGJauh2V/7+oTjcBrS+bcauhzmmQJixvbympZJeEaRRiRgAaw6S50O8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790324913; c=relaxed/simple;
	bh=4G0Sdzx7bsxIAYStcuD1h5bY3+zwVDOIheWmUFMY5xA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QXHOEevXGhfubtRtkSeuq9ZmqPV5rmk6N/o7wNYq4/7TvzQkhQ6VkFwcnwgjHPCvxZmFfLlxIOL39TztBEyL2VkU2Fpo3kjPER6SbxZrB5HjHWLuqXN2ges66EoiQ4V8Bp7MhmXNSP8pXsFQ+KOqYNrj53LP5exv1a/NrVsaxb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vf02y70D; arc=fail smtp.client-ip=52.101.52.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vf02y70D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G3ocqVZg/YNI1Q+IUaOqoLqr2FxaGKiNRmypXQYf0Jlla/tLHxlTctaUYsyIOeWmLRq4w4E76b5evc8mG/WKck0er7A2R1f1MfdaQXQidVp+piMkyno0zMNmqOn7X65KJjMnrTBcCSIbDcpivOX5B3RkaSwg6sRIEtE7IpwbWKQrJiLd2SEqMdUJPTmR7e0dhYjHjyfIbvgNCh6eiMYKhS30wKQofFpwHWZHHsCfet6G0s2SGtlGK18dOT13U2yorGYK7fYmoVoLgxDQ3iBzv4Uk9i7VQ/euOScfmenVKU6tZRLOZF3OppwKZSV2MrsdTlvVVNS3gBs355yzFJ6npg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVJsaURX+qhQPX3kFful1AJswIKFHc8eJh35X4j1YTU=;
 b=UjWmz/gxgGysrVUOwe+tfPXEza/ZzRbMUIsDLNEfIxrqsyTdKH+q1RYPiSaaPkdeQ+nEPQjk6X/WZh3AuI9QLTpWD7p4pfAu03iXWxOIxIh5ZaDqplpt3UZUBudo0f8vy7tkaJo/S5XqWPZKDay5bXDMxL6Z5kg6Ou2w8V9KIva08uYC5PQAtLg2sFHRGcyH5cS8lR8/Y92OhnuuA60EVEUf7/i1o8j8WVyE9Tpp/sNQ1syMYikjw3JehDszxKY0u5JlxEaYrYNy15gWTCqjR8oe07O4km9bMFS+gbBsNaP5asofmuUeYZu2CaXboJJKfI67hUu3KkAbt7c8SARqvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVJsaURX+qhQPX3kFful1AJswIKFHc8eJh35X4j1YTU=;
 b=vf02y70DzMLsVqPWHwUms/f0Xu8qaya0484KKrORQdqHR5Tpw0rz29N+X3oGLbYvzHYr9EAW+lcOsXG3wEJwOsn0EH5HidtM58Q9GkTSzs3qCcRFtFUDcADzSpvLqNP+vlvS6hoLSL+gTp2+CZO5dd+1nZraJLwEG7Fh95o4TSI=
Received: from BN0PR03CA0044.namprd03.prod.outlook.com (2603:10b6:408:e7::19)
 by MN2PR12MB4224.namprd12.prod.outlook.com (2603:10b6:208:1dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 08:28:27 +0000
Received: from BN3PEPF00022BCE.namprd03.prod.outlook.com
 (2603:10b6:408:e7:cafe::77) by BN0PR03CA0044.outlook.office365.com
 (2603:10b6:408:e7::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.19 via Frontend Transport; Fri,
 25 Sep 2026 08:28:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF00022BCE.mail.protection.outlook.com (10.167.248.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 25 Sep 2026 08:28:27 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 25 Sep
 2026 03:28:26 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Fri, 25 Sep 2026 03:28:22 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v3 0/5] RDMA/ionic: add SRQ support and firmware assigned CQ and SRQ IDs 
Date: Fri, 25 Sep 2026 13:57:57 +0530
Message-ID: <20260925082802.2675902-1-abhijit.gangurde@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BCE:EE_|MN2PR12MB4224:EE_
X-MS-Office365-Filtering-Correlation-Id: b1f6cec4-b251-4074-3899-08df1adef8fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|36860700016|7416014|376014|10067099003|56012099006|18002099003|11063799006|13003099007;
X-Microsoft-Antispam-Message-Info:
	wcP7xmZD/aNDsoyPu2ZuxbxKlKR+4f0olv7OTFc5D+OlSbO43a1RVGOEE5KleivFBzG1Kibk1H4JwIcRUG3/xueEsSVek2VY6QNTfL51CyVM52u/HF/R5aJBtW9PuGW7LMi+MqLecTa3IqXYm6TfYFrWKSKoobqcENUgmZ7psiVFZx9DLCqG4/kqfDpJKmojZoGh4/MfUQZCHPKufJU4M3EJdl4eQeHCjxbs06TA4ExIllxgtp9iCaOGKb0kgZgLh5I655A8YL0cto8nMUkedgObp+V3QaeWLO32Ixd9zujp/t8wvXzwxWsebqwkFIPe8LIspBOPE3WcewktdRApKea7M2NGL6Ru63qCof+uG8TVouP19q9FVc1YLVEvcECWNVTc9kqXHeuagrH8m8OtevCCw1JSw2ivRHnUcyXcHjIddrMh3PfiKBdpKm9ygDL1bdlBQXW1FUa0SyfYdPiEQN1r+XCmqek8gzS/MQVxBgtYy62YfU3Sq8SwkYrhwMbXMpJ0bQ47m9pSt7MQKgHTDOYltFwO6x9h102icLtyoNXOZ4zyGBz3XvlVIaVBgyFyiGASfPR8a5BFtWedHMmAENQ3F3KqNSaa2wa/RfvxQLtpdp3F4th1mpdisXD7doKqsX3M6T7I6Nz1C8MfCefCVZzZXxh13hGjWAlyV0i/k0CI8NNPr1TJWA0jlSgEwWt8+tYiJpZuhmPCYVx8Hb8MSw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(36860700016)(7416014)(376014)(10067099003)(56012099006)(18002099003)(11063799006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IwFQRou9U6f8csjd5qI7nkil2E8sbkJMPZDiEE0yGsziIZzpiBRN0Nim48NDUMyDTg98DpWFjugUCs2MKTqwh8GAj6xbJACzz4onLKQlbgJlHwP/YA7DNCLG4zfdPi2OuyF38zez7HteqAq52WxOTKp1Q6jcaPk7trsqRv5UIlbsui1yoHbInlaFIEINU9Cv3anbUYDw19cNk2WP1Ehob8WtjSrDVahjrhnzGNHuFSVyIKwBBEndpxwyb7VpqFC//rDYw7r7TK7hgYp1rbJoH7TfakeJKiBGljJcuh2WNgbHDloWcPvslZdm7Vyw1zDlh1C4G7zCpdN9QTV3Vki57ZUdwY1HeY639LmE/4cz7aPvS8uWBs6wB6+JsuRxhV83Ij8gmQjYdYb0ovO4VJ+b8SS42fdF+QPJR4wXfNGSUgyRVg2+GH0ovgbVfNqVI5k3
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 08:28:27.1817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f6cec4-b251-4074-3899-08df1adef8fc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BCE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4224

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
The following changes since commit 93f51579e7df248780214094418f205253383cc5:

  Linux 7.3-rc4 (2026-09-20 13:48:15 -0700)

are available in the Git repository at:

  https://github.com/abhijitG-xlnx/linux.git ionic-shared

for you to fetch changes up to c73a5f20bc786df0be484af29aa5956e909dc862:

  net: ionic: Fetch qid allocation and SRQ capability from firmware (2026-09-25 11:48:12 +0530)

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
 .../infiniband/hw/ionic/ionic_controlpath.c   | 785 +++++++++++++-----
 drivers/infiniband/hw/ionic/ionic_datapath.c  |  98 ++-
 drivers/infiniband/hw/ionic/ionic_fw.h        |  74 +-
 drivers/infiniband/hw/ionic/ionic_ibdev.c     |  20 +
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |  85 +-
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |   2 +
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |   2 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  31 +-
 include/uapi/rdma/ionic-abi.h                 |   2 +-
 10 files changed, 925 insertions(+), 291 deletions(-)

-- 
2.43.0

