Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795369178;
	b=GG/0567iDrzSmllyTElWRg+64CGOMlso7/T/4Iy0SbqeawOxw2SyrSxz/NSbIPojOTUH
	 3NU6bweyKF5uBPX/yGteQwsPgHyustT/ysep2TAzZtKcajF9GoOaG/4pToegCwr+o/APA
	 ltQqhRp7orx99Qh4fCexWMY4lCap0PjVp0tCpM9hb/HP+jEQrvx3Nuh6249bbQ/xADp27
	 cYw70FO0ntDJ0k2xx0k8s5GzpzQvdV8fFFUZTG8uGgMHdwd7sbTop0FapT588nsRiVMzo
	 CrrBtk3MTHxOHQ4v1Dud1VPxi07NpwB43l4EEmBCx7ipjWYTrGxax2In+9gPo2lqATg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795369178;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 CC:X-Mailer:X-Developer-Signature:X-Developer-Key:X-NV-OnPremToCloud:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=YZIQwsnzlVwRoJueSCB/TOkAKSM12qGoNoVYoHzr3Kg=;
	b=IBjNvwk49KXVpjOte6L5YJR7pTM7bxb1GekDhEr+u61BAc8V5vRKzikttS8EbBxVfndP
	 XMB2ogxyuYQd/gDE8D6tgqqIUTXNTuq6Va2wNyX++j0oYk29Q6g/XG8TNECW6myBkW1g2
	 r6aDs3AE2A+QtLG+aSae1a9+9K6uy3cfj2tSQw7lMHFc2+B57DwoYQcp56ciTluu3WMH2
	 yiWSWnBGT4ykfA3iLOkIXa46znT+1A1fkQDaf11fSzRhLMJ8PizekfxDWvJvgM3Il0Kvv
	 OcvB68Qw4Eu0V2e0D+HcjYq6xx3klzVS6kNc/9rSdpMZTASpzxJYhhjBrvwIGN8wBoA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=EVvy0KcN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.65
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010065.outbound.protection.outlook.com [52.101.56.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF65606A320;
	Sun, 22 Nov 2026 17:39:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DF65606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=EVvy0KcN
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ePzLkqIxAS/xB0lIc8JCzIPrhL35iRMXjESPJIITiCZxDuckQmk55d9Vn1pEigGEZQL3dkcmKbrSI/P490n1GV8PawJUm4qF+GMg8lRZqbeBrNs2Qym0UsKfLHNZR1rIv+bBXCTKVlwuJgBXk+ZyBvtzMxfiiBOmq8k/lnk2ooejkJLZWhakT6zRH60t68gy/gBaYmbJQ4JfwYnGRpDtPJZ2LoABvBd6fBofOVPn9X7+KrL3wV5dXde4JWJGFa6ztZVz4aYm49lXgb3P8XmIz0cHsefVzSsTmOHTKWqR1IP2w+Ou+ZpRykXrAeIPNphPwksFOy6u+TslxbkLVynZwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZIQwsnzlVwRoJueSCB/TOkAKSM12qGoNoVYoHzr3Kg=;
 b=ZhDTHVgm1L3LjmSkkZGi0tOflmCShkyDPdLgqr5v3AGM+W+iZYMiGlc79tI7H/kxm0s+rZ+hEtWuV4lpkprk2N+dn05eyfsJ2SAXEQwkU4q3ShS5vBL//K3dFH09ysoW6fEm8SMyAzpW891mTzqhvkuXa8asY8p9QVlkbq3bREcBUBg75lVNiIxhYr/yKd5seFC79qRvXpPsgJYBh5Ctxa5SVFQC582IWh2xQ/Pm58Jk0OxPLjxpWDJbhLIIc4JbuxkxtDAGG0HAzzGhevl6jlxyTUERqVlQvWqAIerRiyHnZX96WYNR+3zwZQ/+IC3J6aMTFV0vzjbZV86+F3Bkfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZIQwsnzlVwRoJueSCB/TOkAKSM12qGoNoVYoHzr3Kg=;
 b=EVvy0KcNQtKkRnQQ/O4qc1m5lX3AQxYQxXO21ruk72j+kEEG9S9ZIuUIr5Yf3z2poHMOxYpIVuLKIEMB84p5qn4B/jN1SqE5VNZvRuyasIZ9nnTfG7VLqfknhKtPxw/t8KzTgUVQNGAulQfPSm3nMwFHUwScDp9pLW4AKDcExrRaEVEcIer8lThrF8gRp1EQ4CrDRESp1x9f4vx+3yQuvKvMpON+jqyce9QuG0QUU2e+qFKFqpevul5fPpuyMg/NG3XLpQoShiPco8CxljI5fLj1H/5Rw5chlzykSNUFvneMlUCjcDrcwjj8I9bPTnUhXkl8XvCadmpo7EOSV6NdDQ==
Received: from PH8PR15CA0006.namprd15.prod.outlook.com (2603:10b6:510:2d2::14)
 by SJ1PR12MB6362.namprd12.prod.outlook.com (2603:10b6:a03:454::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Sun, 22 Nov
 2026 17:39:32 +0000
Received: from SJ5PEPF000001F7.namprd05.prod.outlook.com
 (2603:10b6:510:2d2:cafe::74) by PH8PR15CA0006.outlook.office365.com
 (2603:10b6:510:2d2::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.639.14 via Frontend Transport; Sun,
 22 Nov 2026 17:39:32 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001F7.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Sun, 22 Nov 2026 17:39:31 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Sun, 22 Nov
 2026 09:39:21 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Sun, 22 Nov 2026 09:39:20 -0800
Received: from [192.168.122.1] (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.57 via Frontend
 Transport; Sun, 22 Nov 2026 09:39:18 -0800
From: Edward Srouji <edwards@nvidia.com>
Subject: [PATCH rdma-next 0/9] RDMA/mlx5: Don't lose port configuration
 events during probe
Date: Sun, 22 Nov 2026 19:39:08 +0200
Message-ID: <20261122-mlx5-port-events-probe-v1-0-0d54e3d53c61@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALwoA2sC/x3MwQqDMAyA4VeRnBcw2aqwVxk7dJptAW1LWqQgv
 rvF43f4/x2ymEqGZ7eDyaZZY2igWwfT34efoM7NwD0PRMy4LtVhilZQNgklY7L4ERyp98PomO7
 uAS1OJl+t1/gFNq8eg9QC7+M4AYBlY+5zAAAA
X-Change-ID: 20261122-mlx5-port-events-probe-710a67521354
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Maor
 Gottlieb" <maorg@nvidia.com>, Chiara Meiohas <cmeiohas@nvidia.com>, Mark
 Bloch <mbloch@nvidia.com>, Maher Sanalla <msanalla@nvidia.com>, Patrisious
 Haddad <phaddad@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Edward
 Srouji" <edwards@nvidia.com>, Michael Gur <michaelgur@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795369157; l=2570;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=PSaDFfKznFDb1evRiAjnz8zqjdyzKAJdvBSwAyNZEIg=;
 b=muw12acKW0I4PsW08AVfh6AkWTnVSVAKkjbTykQu3GjkOWbv5GhI9NKhXinZ5W/1dPmCQOfFz
 IZ2WMarQYNbBkhayXCizlmhcMo+gJ/hsPsO+69hYHNS9cYHMXwDWTFi
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F7:EE_|SJ1PR12MB6362:EE_
X-MS-Office365-Filtering-Correlation-Id: 08c61322-542d-4047-ef4d-08df48bf910b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|82310400026|376014|10067099003|56012099006|11063799006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|261009221227099003|18002099003|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	WuJLECnzpCfZRVmnsEWRkyAdVSHSK4u+xupmC2UsSHky00brvrWcoVG3tkq6tu6t1i2uWkd3cK8/s19YSMwW87/TYFgFqNB3t47mFKRjDfpt8up0LfHjj55L79IK5VT5zDKYZcZ82pjDolFbEt3LhXS54SZG85qDC0o3xfO+Keq75cB/jdxUNFmj1aG+jcLBf3QSFk8JTiV9MShbxUkjWBcN873CDhTCtVXO1MN6pEgIjYZd8af+W5wivm+6Q7sV3wPW3DNxLUrpfAxPX/Wpi57nWT7MCNOXng1bPGF6n6Fll3iEVXrKkYcsRsNj9OY/bLAtzF0XGXZCdsOpzazKkiw503ertFqT69qOC7qjuU7S7JoXFHmNcRWbxWbMQP6/aGJQON8xRtuNwh7N6vwHaPe4V+rv9DuCnbdhh/noLpeQf/fxa/30U0o1f/jKYN5C7rOm6xmC3hLe/1yLt7f9RwhBnZmf7sTFawdJmutLlkH/bBjoEqM29Hr8NFRb0GS2hx8REzsCusZgjGCPhgzVWwSwIEdYD6sFbu19drt5VKbL3PiJ+EjYIaw4vaacvCfzV01q2U7flHTj6jpR/5WN1QGYIVjaySa4UtHPmR10pWbmF4/bf71068b9gtJVby8buWyFlmuwTpoeAPp8w+XxPnKCArE2gtO7hQNXweA8XkvuNfZlz9gW+0p5Eh9s6BWFg6xVKB5MYjuTzO5p+76lgQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(82310400026)(376014)(10067099003)(56012099006)(11063799006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(261009221227099003)(18002099003)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0MyzaaNcH6K+WUcerlC77VylxLL2skDPfxJiNTSWolhscb34AlOlenqKlBz+w94Qzoq3O9DQ2iM4lEa0MQ4dhNr2PAel9WgzJHNASj9o37Nb7Ky5cQvOyGM78oO1iG4e/oz24pSBAHzTDWlLZXqYmywi4YHOQD0Wk/pL5bCPOIOnGDCHH4ibYETl6/3mHEpfZQJxjHhLgsROA7yfsEf7gdGyaBlSugGAspdmrAJ+6/7b7k/evrMEHrBJVt2CthSMWl05en5AUh9c/816ESfw1LWfteLbes6KpI/kZd1VwvAwNklB8c4S6fTuM5NxucpmxTDgwjRwnZevjZGPL7wesqf2HG9I6dLgqM5iUNkfMuxFpzYKRC9vhHeNmGlbWslkC9xfKx7NxyUF0xOKLg5KuxqPz7mt/3SP5zBpWTrHRImvNO69FRIZsKNJ/8BEubqb
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2026 17:39:31.9184
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c61322-542d-4047-ef4d-08df48bf910b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6362

mlx5_ib registers its event notifier after ib_register_device() and
dispatches no event until the device is active, so a port
configuration change that races with probe is lost: ib_core and the
clients keep what they read. A lost P_Key change leaves ib_sa on a
stale P_Key index and IPoIB without a carrier for good, as OpenSM
writes a P_Key block only when it differs from the one on the port.
This is hit on hypervisor setups, where the SM can program a VF's
partitions while it probes.

Patches 1-3 fix the event handling the rest builds on: the port
number taken from the EQE is validated before use, a slave port no
longer marks its master active, and the work of the system error and
slave port notifiers is flushed once they are unregistered. Patches 4-5
add ib_dispatch_event_sync(), which processes an event before it
returns, and patches 6-7 prepare mlx5_ib. Patch 8 records the
configuration changes of InfiniBand ports while the device is inactive
and replays them with ib_dispatch_event_sync() once it is active, which
lets patch 9 register the notifier before ib_register_device() and
flush its work before teardown.

Patch 1 overlaps with "RDMA/mlx5: Validate EQE port and GSI port before
indexing devr.ports[]" from Yishai's adversarial mode series [1].
Whichever lands first, the other can be trivially rebased.
I'll drop my patch if that series is applied first.

[1] lore.kernel.org/r/20261117170914.27410-1-yishaih@nvidia.com

Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
Edward Srouji (9):
      RDMA/mlx5: Validate port number in handle_port_change()
      RDMA/mlx5: Don't let a slave port mark its master active
      RDMA/mlx5: Flush system error and slave port event work
      RDMA/core: Derive enforce_security from the cache event
      RDMA/core: Add ib_dispatch_event_sync()
      RDMA/mlx5: Pass the port and subtype to handle_port_change()
      RDMA/mlx5: Activate the device in a stage of its own
      RDMA/mlx5: Replay port configuration events after probe
      RDMA/mlx5: Register event notifier before IB registration

 drivers/infiniband/core/cache.c      |  67 +++++++---
 drivers/infiniband/hw/mlx5/main.c    | 246 +++++++++++++++++++++++++++++------
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  17 ++-
 include/rdma/ib_verbs.h              |   1 +
 4 files changed, 274 insertions(+), 57 deletions(-)
---
base-commit: 7404c82cbf1246e0e84e2ec21834d23c26f9a8ed
change-id: 20261122-mlx5-port-events-probe-710a67521354

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

