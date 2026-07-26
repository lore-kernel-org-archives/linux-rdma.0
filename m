Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010014.outbound.protection.outlook.com [52.101.201.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0FE72630;
	Sun, 26 Jul 2026 09:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785056993; cv=fail; b=E64nCoRKiHPp/Rfq66GcuMUmwtuEhRGazld2gjCbRCogke/6/khsgc4WPC3S94BXQ83IhOTyU3VGA/YXT4wV0pTnT8SIKiAQQQcNiLFjfLEaVM0EfDzjdYOyKgFukVd0XdwVlpp/QALJ+QvMwRUvMvWHiB6+4db8NKhRA1czh+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785056993; c=relaxed/simple;
	bh=mC4w1h9dje4RNzQSstlm8berRaObLSYBbJcHkz6pHqU=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=QtLgBehyj7N+JPQWlOY3klqKmRXnQZkhsiMD9kKEqlDwGi4HZWhreJ9wL/CJ8IAMAhWY36ezUgcH351Rt9tjaTCyfd6ULlQ2X4gcbXs0Nf14cvPblMwAxg7ted6lOxduP8/XWuZO7nh5jOTBcpVZpEvmVDUnx0f/CvfbYvdinlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CTOqISKE; arc=fail smtp.client-ip=52.101.201.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CTOqISKE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qhn0mQMEd3ZO+ChEdycGNQxAldwUFev+xU+84rXAfHZMdsswpf7J69DpZBAEWTpOampRhP98bRVNz1w85UuStzQ7vo+ISznOwTTP+bNvmi7vECOMIr+A6FgmLhYCbvyPqChG8d4Fw7XNW4TMx7oZroS0T2qIRhPj4N+cqj26k7GdSD80HCMEYkCnmu9IknwepHU6NkGvQfTN0oAJERuv6kMeiW2f1gAUSSPsQ538eoFO6M/vxtGLaNXxgmTXo77bBV0yMG1V6TnFncRj/Aa1MdeUzEt8Ifp/LqLVQOdG++X5GoEI0uDN3d0JqWBGpfg6PlsDKDaieqhsnNP9ac3dYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1lUxYZUP3M4VAsIs8NEGHmN31BcQBjAu9NWwF9FG4Q=;
 b=iSMwszdZmWkUadM6zgoBBMAPnJxjniGMUp8MHPF9ew0yrAkGbSBg8fcUKqrEKFkKmDQVND1lGIWnm16rTZP+ZOmkfVHGrQgGV0kAE/0qrbXOhwE5MVaNj6QLzrdgOwbbRz2OjdsJAEUK4WU3cbO47ViuU/3pEADOmnpMH4cFyrQ0K2psYRR5k6HG20PRj78LGoEzgU04Dj5QRNfxeS0dt3bw5iGedh7jQBMo5RoYNF1fcYPTjjnjH2s1AyI7bfg2Q5bqoKY6VE+DDLjrjOiZKiUg8xrkvv7LTJxA6OwK4YhgQmj112Eyl8vMpZb3UBD7b2+mWvL/e+dvZsRuDC30Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1lUxYZUP3M4VAsIs8NEGHmN31BcQBjAu9NWwF9FG4Q=;
 b=CTOqISKE4v2wesA45fo4S93GoaPooiqPq0+pmypYQk2LmnFOtxIk/I5jBl445J8+tjAxURFN+AIXlf277jw3a/vgn2lPiAWGhoO7l/BHAYrFA0ikU7QephheQrooy/nb3sqwqE0lLIqPBHk/7SVT7p/iasqEi+/xCQIaQgVSBFuKdbeo1qBx2fybsvg0gxnoSo2QT/K+dKBtmsHtaAxlvy/VrqgwnPX4uqf7Pcq19XhlO3jrAMI7DPABYRP8ob3InJFCb9mAV/qVZUNmCmBZ/Pa4VGFOePW+xjHcYftxK9tuP+9HMFy1l2M8/B0t1S8CaWwZITT08+Uv13Pqpi8myA==
Received: from BY3PR10CA0005.namprd10.prod.outlook.com (2603:10b6:a03:255::10)
 by LV3PR12MB9331.namprd12.prod.outlook.com (2603:10b6:408:219::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Sun, 26 Jul
 2026 09:09:48 +0000
Received: from SJ1PEPF00001CE5.namprd03.prod.outlook.com
 (2603:10b6:a03:255:cafe::a) by BY3PR10CA0005.outlook.office365.com
 (2603:10b6:a03:255::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.12 via Frontend Transport; Sun,
 26 Jul 2026 09:09:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00001CE5.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Sun, 26 Jul 2026 09:09:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 26 Jul
 2026 02:09:47 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Sun, 26 Jul 2026 02:09:47 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Sun, 26
 Jul 2026 02:09:44 -0700
From: Edward Srouji <edwards@nvidia.com>
Subject: [PATCH rdma-next v2 0/2] mlx5: Deprecate latency-sensitive QPs
 feature
Date: Sun, 26 Jul 2026 12:09:39 +0300
Message-ID: <20260726-deprecate-lat-qps-v2-0-5e0c2ee55046@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANPOZWoC/32NQQ6CMBBFr0Jm7Rg6oIAr72FYlHaUSaRg2zQYw
 t1tOIDLn/f/+xsE9sIBbsUGnpMEmV0OdCrAjNq9GMXmDFTStWyoQsuLZ6Mj41tH/CwBjVZdTUR
 N3XWQd5k/ZT2cD/B20uh4jdBnNEqIs/8eb0kdhT/ipFBhO5h2aOtKXai8uyRW9NnME/T7vv8Ap
 /tXTL4AAAA=
X-Change-ID: 20260723-deprecate-lat-qps-ca1942227499
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch
	<mbloch@nvidia.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, Edward Srouji <edwards@nvidia.com>, "Michael
 Guralnik" <michaelgur@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785056984; l=964;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=mC4w1h9dje4RNzQSstlm8berRaObLSYBbJcHkz6pHqU=;
 b=L+WsUh8maEN59KDt25JytMsqbcPzo0usMKjgEO9+wRMhznB/Jx83PK2oMkBOKdtar2l19hxV2
 /N4F1Zz75KSCJVCygc2KoaaAV/tRANTwqGHSEf914mo37HCS/GSTYv5
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE5:EE_|LV3PR12MB9331:EE_
X-MS-Office365-Filtering-Correlation-Id: 732346a5-23ae-4c8f-15c6-08deeaf5a451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700016|23010399003|1800799024|56012099006|11063799006|10067099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	a8oR7MLOinhF23HPnseqHSBS5bCWWJO5XertaMcPKAvrMnjLW45DRYG/iZYFGRVVCLrDRhdDhb2VUsMyTBd9rug0iSSB0SIwqMPpr9C3y5qccpn2Buhy9VNL62ApqnsrmBF28ogB+fp7cl5DLNsGELSuJSinoJ29f0Nduvhn6wAh3PYDjM5FlHAxGmQ1smBX/8t91Fsm0zj2+Y59rKOCcUJ9yIaPCpsvjOuvA3FToqn+i1CkYoKiUEpZQ4Iu6/KntO9lqyLZmsBXLU7pMu9y26SdOlKhAyogmzhxDFuh4JUTaluQmGENhYcgAObuKruTW/E69G+dp/Ng51Q0bOy7lCy6jJV89ZDUsPxPpOa4GRnpDU5G/nz5tn/k429Gby7JQ87OnsX3LS3lKWG/400VRyh88KckZtpXte5l/BtPuppRIdUMsYDNeLEtJJHeb7qhimlah3hu98CAKuGjNRsQ0HQwqnEwHDxHWwTtCgrUTA3hMt+SNchuddVINSG9AW7wRUPbDbtLrw5H9avn9Or2B+Cc84NdAPCffVNbrfT4ku9MJfFUev2KJaX+txqDWOS5aCOvg9ocRHhRP1MNKdwlxWj2m3N/sV0R6tyy2csNWyMwxs/6ErWp7EILYdAuVS+3luCiSLNL1wh2Uq3vitWKut8Mt52Oh6I/h2Kcy2fJIuXbs/bvDeMskus607FTEb7/6tkeonI5DHQx0KACB+tlrQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700016)(23010399003)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EjPeMzenpadsGNNbUv4G4i+2rWd5BELVj0/O6HQxdhZksRqD6PZ/L4Zof+wzBM+P9QPdMf/YlKiQ81uDJ99X7EmnmnMJDazQkTLoy4wCzte9vDzQpsGA/eUDdo8u5RFCzmaRTG7Mp5XV/tZuEqUgYtprw61oRlyAHBoDmEg0gprHGdYIBVHmVCv7KtixaskTjhV8Wy8bsc/HKbpVX50F9xVafqbj9vJ3eg+TucsS0DLBtQimdN3feCEhGK5KTuKkc3Zm/E+Op2fqPSRCs0WtUgEyL3dMz2QyKKE/7uV2GQ19wT42G3ykWCVAD15Kl8uS2IUqGL2ONYwIOK9mbfYv3BbT0aGEN4bw12OX5AW8hzetPKsbXCD8UMSmocqzOkDBm2CqujuUDHzGjof+WJx8AYJv4LqCPPJ3oIyCOOo8YqfG0WQBDREesQfGN1PoxJ6M
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2026 09:09:47.7620
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 732346a5-23ae-4c8f-15c6-08deeaf5a451
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9331

New HW no longer implements a separate class for latency-sensitive QPs
and advertises this by a new cap bit.
REG_UMR is the only QP that used this feature, so gate its usage of the
feature on this cap.

Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
Changes in v2:
- Split the mlx5_ifc.h capabiltiy bit addition into a separate patch
- Link to v1: https://lore.kernel.org/r/20260723-deprecate-lat-qps-v1-1-8bc8b8431520@nvidia.com

---
Michael Guralnik (2):
      net/mlx5: Add qp_latency_sensitive_disable cap bit
      RDMA/mlx5: Deprecate latency-sensitive QPs feature

 drivers/infiniband/hw/mlx5/main.c |  6 +++++-
 drivers/infiniband/hw/mlx5/qp.c   | 12 +++++++-----
 include/linux/mlx5/mlx5_ifc.h     |  3 ++-
 3 files changed, 14 insertions(+), 7 deletions(-)
---
base-commit: 9b66c9af7172ffcf727214fa0ebe9a5e1ed6eb16
change-id: 20260723-deprecate-lat-qps-ca1942227499

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

