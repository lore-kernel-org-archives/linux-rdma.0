Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795721813;
	b=RwYPVG5KMEgSoylhGStvZPMgl93FxQsStObgqe4RDXgtkaL+74vwIoog1PaiiuyOwBOs
	 U+7MNQsM+A0h850NCuRklN2I9JtB4lKHorgwI/h++zkTOzkvJ76SDS6T6WzhVMB5JGPv/
	 ZM5l1DRNPLE3567ZN2ts6/JNVRPAcVc1FJobXri4rNmXBZk/JrRPVhksjTBWIF0RwbhRJ
	 hYeosxHee8dqAA6YrJXaXSY6UcrgUCbwUieF/9OLoAewbxgIe1xLUWD/twoC4nEkDGgqt
	 P/yh+s8429rYVjZSbttWMSla8NOoz4seNSKbDVW/5UAY2I3S8autPt8naFs19xsqxHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721813;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=HIH9NU5hR5Spy0qMQ6Xtoo6KeUDdEdtfK2wxBp3mZco=;
	b=p6u4Jxf6q1HOVpUxaWf8mqyOpnf4EIVigJIX5WiCPbcms55yvAg46s10YLiSqLfmWn+p
	 LHSrPrNnF3ej/BgxArHUFqYKVRf+JHTp8bKwhIrcAEjrAhcxOXN9wbWlHEL75XZB2Rkle
	 8WN3DY8jUDvVkkBmCi19cZkqkso2eIWdkM7cVBSjCFOKWHVEDC7tGP5BNhjpb2BDvqHWb
	 NXKkWipyGj9llQl+A5tFMFNjI0dcKmJ+OayPB2CMYSCAiifIXzdIWfwJ5W8ePHOHQMcRx
	 oIyG1HeUZ2z8pqKOzJMbyTb1yOMqNNIxcnVt5HCDIyyLwXA4LCeMdFfBSY1sH3mejLQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LXGXxc67;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.24
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013024.outbound.protection.outlook.com [40.93.196.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767FC606A31C;
	Thu, 26 Nov 2026 19:36:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 767FC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LXGXxc67
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fAh1Eo1ig5CUa2XB3E5bS4HSL3kgH7DqLz0AMsaZIzcVWmUtyOxuoj799HN8DN+a/Apgk9w6aOjUw0p+J8gP+pB8Sbt0myfXBHeV+Bo4Rrm+pYG1wFGu4CEmeOX2ivUTfDLFKJDj5uirn+N9+gRM0ihA0MMRn1OJBwX1e3M2JHpUOD4PHOiTWyuUAKi03L/7Lf9tTPfvJJQwtJ73xr2s9BhonRaU08xTwgr0bl83XjunXCX2TFYmoVhKpW46+5JtoVCxXYpCL5x9cVJM3jKxMUPDogMI8NAFcgb8kb9ErRljEVNP9F8nf30i9ZNDduVc/KBwikN49H7ajghZ8Of3mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIH9NU5hR5Spy0qMQ6Xtoo6KeUDdEdtfK2wxBp3mZco=;
 b=AEqM3eLM5M7F2NKh/0AMms/U46cUWBlt0dJKWlYV1dDdsxRHuY0Yx+CxNI76R4IQHV9FojFmvdteUqZGdnINsR+xpHOoi6mI8xy4AgjlCE6pL2Sy5lUro4VtwBxrNN3CSNpkD5qIsjAjqH918dU5Lk0+55DKjwog+gSsNoeCDi/mzzhjf+iBv8c2AhVKrphGonBWrhiyze9j/PrZdEgwFM+Pkr3jahpUiPN4KbJqE/kxIQ2s24CHxIv7exYb+UEyAeDb0yr4P2w65pvfgYAeXK6W+ovNmhdGZ/tZ7FBf1qy7g/FVw2ODuhQdiBXALZgs7NfFRtMFOjI9JFruxNakJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIH9NU5hR5Spy0qMQ6Xtoo6KeUDdEdtfK2wxBp3mZco=;
 b=LXGXxc67Y1miGzhS1ZQJiL3Hk50mlWyCbfUR+6rkwkRxyrsK+ykCJaeRrRpah3xERhUXsT1AMwwDRXcKVKw8x3G5MG7u1XXV9jgrqenOjRj0LYNRYr4Nvgc1Ka5k5fbC90hwMazqwPtVWKkXqy30CnoEJVyFiq1xJee1fA+J7hmXdqiUXxLxsc4hOOhgWLorozX4Vc/ZL6ipPeDhMa7O25OMAryjk5wyFpt/JeRGIsUQnPPotygS48ccZiKDxanskVuOo1VUHFjfQwA86nRSxfn03ZC0Ga6PsBOfE9m5XPP4CPTHwfhazA7MgS0CXIdJe4oFKTlQ2tKbwrdI5jMYJw==
Received: from BL1PR13CA0246.namprd13.prod.outlook.com (2603:10b6:208:2ba::11)
 by DS4PR12MB9636.namprd12.prod.outlook.com (2603:10b6:8:27f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Thu, 26 Nov
 2026 19:36:46 +0000
Received: from BN3PEPF0000B372.namprd21.prod.outlook.com
 (2603:10b6:208:2ba:cafe::53) by BL1PR13CA0246.outlook.office365.com
 (2603:10b6:208:2ba::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.688.4 via Frontend Transport; Thu, 26
 Nov 2026 19:36:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B372.mail.protection.outlook.com (10.167.243.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.0 via Frontend Transport; Thu, 26 Nov 2026 19:36:44 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 11:36:34 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 26 Nov
 2026 11:36:33 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Thu, 26
 Nov 2026 11:36:29 -0800
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 0/1][pull-request] mlx5-next updates 2026-11-26
Date: Thu, 26 Nov 2026 21:36:17 +0200
Message-ID: <20261126193618.725006-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
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
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B372:EE_|DS4PR12MB9636:EE_
X-MS-Office365-Filtering-Correlation-Id: d71be0a1-86d0-422e-5a2a-08df4bf49aaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|82310400026|23010399003|261102123227099003|11063799006|10067099003|261026140227099003|261021121427099003|261021123027099003|261022105027099003|261028144727099003|56012099006|261009223027099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Eup6iDbh7Q7/f9amQajTqW41U1DNqdN9cOoavf5IbqrPEfSo7IjoYSW+x9SbHUaol6mVOXP8byoXfO5IK7D2yL4uh6YUcIa5PoF92kSqpzt1PjcNcOHWCvFsYjcG88XknS+lDHLQCuQyma6kSQqVjVCe1CH8lOsLjUNQslqtrC9X4GGP9mDTOjVZUyPXBPN/00RhUUyobND1iamlZGi6WVhrx1yv2+Hh6rsqIkyH5t3j6GCD1G2JYxXsVTnYC9nagF6jFod1+gScyOaih8LkK2PqIUKXNHp1fcnmb1IUBK8+iWtmNTGVG5lS+N4NLwKXz7CfCmH/agsvFcA1uS2Lrw+EPp/p9iFKClph0wgsrSkjboUQw36qcbzM0mRzkTnw0/y03Io7XupHBAkoaZtJFtVHzpgIMQ2xYBDSt9bnepeMud3bSMUTE1UIR0kVP36Xg6H7JeLjGaDf5yx3IHS+wOYgqJ2CyeNE8Z/fkD5kgIvazUkCALAXP5o1n4w0j2hdmcQAMa2MLfGJZqAOPbAZDFvLUMLkuAmKTH03xL7gm2RBe6qZvtoEDR8/Eh7gwR9MpNiaRq0S08bGncFQtEpzy21d+0bIx+CsFPfo/D0A5eQptEiR7pNEwMriRFS/SoVjUAKJyy15Y4qgMYwCZQct3sRO8AX74i/oEGtpR6aGvbJKme0nrRhDGoAQD8USl+w4wu2kPOpRR8s0hATfhKiUfQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(82310400026)(23010399003)(261102123227099003)(11063799006)(10067099003)(261026140227099003)(261021121427099003)(261021123027099003)(261022105027099003)(261028144727099003)(56012099006)(261009223027099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/Kiw5d3XHAJFdJLWD2mR/NFSyvCys+fMVUsbwH6x4QZGTVoTyYoBrpygojh/0xttSfEDNv2rMtt5xqClLEyo3ECzAt5bYyA8OZMijMVDlwJXACY3zrvKvOYRhRMtV6hcH17w4696dg8WdbgF64FWAHo4eVfezL1DJEiavPqWBkITtVqiK+j1PU8PRhbVsfUW0kP5QwhOtxnGHuUItiaau7zxq6xfRcMNQNfjIl2Bsko84uXkSphX2QQfE0+hZRBtQ6BH8JfnpRTFLOxrt//r4GfubGrfWmzB0JE592f7vWrGcKJK2CACJGzvEBphN8meBdBu3axV3spBOoKD+dtICnfGMXCuLu5dtNtztqPBQZDcubvpMdCRWzUZyW9z0E89rjJ8gKGivNFXglnDAezJMZtIAA2Jwx5IFi911x3NTU7lcsZsJz1qvbIEcKZtRCl4
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 19:36:44.7373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d71be0a1-86d0-422e-5a2a-08df4bf49aaf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B372.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9636

Hi,

The following pull-request contains common mlx5 updates
for your *net-next* tree.
Please pull and let me know of any problem.

Regards,
Tariq

----------------------------------------------------------------

The following changes since commit b77e82a6ebdf451c2eb1f0d95085d4ca8446830b:

  net/mlx5: Add MLX5_PCI_PF_TYPE_QUERY_PF to mlx5_ifc (2026-11-17 06:58:00 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next

for you to fetch changes up to 8c7a99ad6d6a9e2ce2e1d705406ba7659352b91b:

  net/mlx5: Add PSP header extension length match field (2026-11-26 13:55:53 -0500)

----------------------------------------------------------------
Cosmin Ratiu (1):
      net/mlx5: Add PSP header extension length match field

 include/linux/mlx5/mlx5_ifc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
