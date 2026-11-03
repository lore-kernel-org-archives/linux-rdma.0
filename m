Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724209;
	b=eT7qwjswWEVvYRfeXxtg5lNCC39QSRRzLErB+ayDBfRhuUmrzxkUrCrRQD5joiIIAuBf
	 lIdI1xUDljixK5ZEL6VZ+C8Hj4p35DliFdlRB+E+K69WQJdDwLkWZ9AeYqLfe0y4slZsD
	 ApHZB4Ao9TPMfDgAS1VxRd1Z8FL4YQHPKsx3sFKXkd11O4rwcS3RxoJFWxX+xvlV5kEMa
	 4l+1MwPKzHZ5smltjvXcLfo7pxXgqqAo5mjb/c6ftFvLan9EyVUARuA8hLtg39fIpnabd
	 OLNizc4YwakfRuu9oPqW50iJTwtcS1Nd9gsmBkUN0So1sEgh7/DHZ2bqv3KddW+iRIw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724209;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:X-NV-OnPremToCloud:
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
	bh=XkX4CS67lZeSQPqMDpnAPJmMxsirceMYaEfcysCjSMo=;
	b=BbHEYoW8RIJvtTssmPFMIkIuDW+uslD7+tTkcCbOjoNVbgSApIJ/nNp7aVQx1k5fbd8y
	 gs6ZdCuWOuEiSvPCROxoi76RWKS1jdZyc4JYs992+a+d0HEsSS0NO2If22smKxCNEGz/F
	 5QQ1vqlaN5WmguvhSVIvzjTu9dIPQNQN1gLAVn1scEfXKxut9cbrtw8uqaDV2dnFd2hf6
	 /SECJ0aCuoeP6S4CLca+oxOz0tB+ekWkwb99LAsT32JpElxLYuqGuTddZYcPkNzn60JS8
	 sl5H6Mg3MNh143l0bV3DYmkAEEdiKAUqwHnqtHzhT8yavrpgbGHPAbFyywn6qUPOTIQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JjFchIqE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.58
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010058.outbound.protection.outlook.com [52.101.61.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FDD606EE9D;
	Tue,  3 Nov 2026 16:43:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64FDD606EE9D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JjFchIqE
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M7RixFV53AtWndDczgtoIxgWlszEwDjRF0XUPDVjf7XXRmv3NyWb65fb9UzvBb4NjNH1u1ybymukvQHgrnmxs8B8JqZMfUfMHmzcY+IYQW5XJZJWOm7rUJkrxgfQTFLJpNxbsQ+e68Q9VFaikFNUJV9u59TsyDGA/ZdyC9tSBRWAZoo9TPAHkFiLoSbfXjxZ03erIvsYXwTqpQWeI9ojg+8KNWLsJG0o8dJ8j6rVjTDXEz0hpRx/JphvwDByBfei5vuoxl9In243gnEkKCfMFOhOe1vzr/6mMEa24CeJ0Ip43ixJ5NQZbwlI1Yn5p1QZT3K2Mon/dZpDCEjN8eQ+nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XkX4CS67lZeSQPqMDpnAPJmMxsirceMYaEfcysCjSMo=;
 b=TrvEglNhx+n37yTBFYZq+Kfx0E3380n8+g0LNByLbFjnaNY+ttUKWH9l0K+MN+0B7zcR3crfOJov5B3AHjGy14mCdLy9SWQ50sX5m2nbrDnUt+RFnze48p8GeXeIqFx7oQXizcE03Io57n9afdCGOuMsLco+ng56y0g9qH/Y476KnC02bssyQOmfEVoqO0ESMWob15zVe9x1EEC3gGB8ShlfaHaL31nz9z1CPAfOIlZl79h4PV9CzZlLy7HRAZi2uSAGtHLcjCLDcIApdZb9dfAbNZZSgXAdXyYUeK8m/GAouYi/VfyoXtQI3SUPuZbg8vysow9gechrjHBXZuZD+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkX4CS67lZeSQPqMDpnAPJmMxsirceMYaEfcysCjSMo=;
 b=JjFchIqEVOnniHpYnMWoBt5VoElJCa6+vgRR+CHhaMVed5x6UNMag8KLORvfo41CD2sWk/8HedHw13cThFkUp792t7rOyan42cRJrcSkW0I2+JCSfnzWGYp+9YZQsqPL7XR1QKTka3RqXL2ek/jdGeZg7gSS4mteAMPNZtZRTenxn+4+1j9SiN0dS7v7pKk7waTX7gEYnZs58lF4+UXAektqfMkC7j4WAdzfXCFROwRldW6HYMKxfz6AMiQlE6am1qJSNbVQSRc/dF8b2FipiiGecX1hwZ4e/TQDF63t78XzD/DwI0BTFdZaHaucCLyzEgUP3uoHLAdqfDwAJRT59w==
Received: from MW4PR04CA0171.namprd04.prod.outlook.com (2603:10b6:303:85::26)
 by MN0PR12MB5860.namprd12.prod.outlook.com (2603:10b6:208:37b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Tue, 3 Nov 2026
 16:42:33 +0000
Received: from BY1PEPF0002695B.namprd05.prod.outlook.com
 (2603:10b6:303:85:cafe::4c) by MW4PR04CA0171.outlook.office365.com
 (2603:10b6:303:85::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.8 via Frontend Transport; Tue, 3
 Nov 2026 16:42:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BY1PEPF0002695B.mail.protection.outlook.com (10.167.244.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Tue, 3 Nov 2026 16:42:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:42:06 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 3 Nov
 2026 08:42:05 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.2562.56 via Frontend Transport; Tue, 3 Nov
 2026 08:42:01 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@kernel.org>,
	<davem@davemloft.net>, <andrew+netdev@lunn.ch>, <dtatulea@nvidia.com>,
	<moshe@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH rdma-next 23/23] RDMA/mlx5: Advertise adversarial mode via ib_device::adversarial_mode
Date: Tue, 3 Nov 2026 18:39:49 +0200
Message-ID: <20261103163949.1554-24-yishaih@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20261103163949.1554-1-yishaih@nvidia.com>
References: <20261103163949.1554-1-yishaih@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0002695B:EE_|MN0PR12MB5860:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b00198e-84aa-4f53-5d6e-08df39c97580
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|11063799006|56012099006|261009223027099003|261028144727099003|261102123227099003|261022075727099003|261021121427099003|261022105027099003|261026140227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	tW3urq9yXad3w9MlR2u4uvQf70tjVgQRyOszd0RNeNbACtOJEZeyAsgIiptrezvTiqUUu6dYFSMJlt98J7ir4C8DgqEYMfDXP7RJQVNYkKV1t59pBszI/TeFLkSi6sybUaU3Y2QRIht9lb4JSPY5OeQFd6/qpO4CmnMei9iFgUYBuz5blanPvRbeTkNUcE+LYm2idZ3O8BnVkaUKpvyJQqiBwv6lx7fxeNJdSNxrzZA6H6pMzRq1QRit8H8U7PRtynWrJCKNi4eVHlSAr10D4BP4fuMfDukaVhQeltthlV/IZfWWHwteah7k4ixEjlLWfd2LPIn8PTbHSRjIRvhtQy4R9y/44gN8tOM7RqEGF8rjsEJo6IqI5siPYw2QI2Rsh22weEOKAA/C8ZarvN4riptw09UdVHYUUO7Ji2t+N80YBtHSa1ZhL0T+D6eXzRQE3qIcT///wW8YAdg1Vjt9Owfs0f1msIbzkRTov9xzodER0PWabral1k5AgHmyfRuTblzSJ/nPSlRFVrfz/Y1a/3cLH1BWyE5+OLzt+Jhiw7VMSs9l3ISKzFRXn1jo9iavIelfZPBK891PgcMsGOHKmQz+INtYE/yUn+zZK6hYyMkR+UnEW6l0BXGbeYck4NmES+ONgp2hpY3BOXuGda2dZX3SrTpkN9wu6ekYQmfVYAyH+IT/LF5eqqNMkvnsmn0dZXQ5c5ly/3dsTZuHLjl40A==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(11063799006)(56012099006)(261009223027099003)(261028144727099003)(261102123227099003)(261022075727099003)(261021121427099003)(261022105027099003)(261026140227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NwFRoJkseds33lGW665vrfwBl5JlpQg/OeWLEkYP6gfhwxYFUZekrVHIwCK/p5J4p8Wl8is7jvuSQWLjfXe4U07rrnlxKVg5g8CZbWqH7+vxsqQ9Dl7AFn577i3hA/+MkYThRXMcHNaGlYg/SjkSV8xmtnb+Yp1uWQMPBdG9rkDrEhF7yaIl4f2JyLzWMU4u+vYFSL15rgRBNsSBF8qBUjr7P1XY0db+m9KpM1fUkcua3MWxdbgT4A6u3VEDessR+IAid+ujD4PD+d1lrDSVO+2sQ8qsxOMokl4Qm4P+2PZQzzRm05VgN/6afdhSnnz5iDZ5FUYve0IUKxmYkL9O4+QuZ3BtC6Xns4+Bur5BFU+WX6AsXxnHxDZlgm09zioDdOuX2k7AK7Y2kTU61Fh/jkfDsLhFpBUBahlQHHgO2/TrEEgOZ4T4QzOhAMkNKA8P
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:42:33.1220
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b00198e-84aa-4f53-5d6e-08df39c97580
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0002695B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5860

Set ib_device::adversarial_mode during capability init so that the
uverbs core layer can report adversarial mode to rdma-core and enforce
that only adversarial-mode-aware userspace opens a context on this
device.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ace4cdc95c9d..f8af90941b53 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4778,6 +4778,7 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	}
 
 	dev->ib_dev.use_cq_dim = true;
+	dev->ib_dev.adversarial_mode = mlx5_ib_adversarial_mode;
 
 	return 0;
 
-- 
2.18.1

