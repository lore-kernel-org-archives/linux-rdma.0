Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793918632;
	b=iCOWHmZGCO+Rs+Kn5hIL1h8n4arY5wbDu9YXe+dHJQKY2VlT4UzGy7x1k4QNP9FrPCvR
	 tgLhzFdjpvCH7uh98gSUK4+HU9mOw0S7KRKnwdBcJxyA2Y3D+DQ13Cev0DbYJSHDXkSnJ
	 NUPTHUbBFTC9zi+m8EsP5ra9ASeiG92xQtx7ehuYNFuE7AUq7aQR6LXPp7OUkFI7AqOXM
	 F7YVX/9HBfD2pEWPhVMWVTkW3pMkPoWkzTO2uiXZBDah9bPvwzkSzMH064Nyjv5fiQn6f
	 ZUGqT2HIxkEAoLPji+Y0QcSnqp0FygauFAceI6FtFYXDyghFWboThkDTws3YKUQuk+A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918632;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:CC:X-Mailer:
	 X-Originating-IP:X-ClientProxiedBy:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=BkdD/cZMNRZKed7sBfNBzfluVajKzrKiEwZ81jFnQWY=;
	b=zoqJ/Q4lcT1sj92kvvk1w19NsnBurtIDV/Pc/TsSAvGv4KyV9qHu8bKMS7Fa5ywXb6Bp
	 MyntCymMxo7WBJTfA0riA7EgkBB60PLjJNZFnrDQNciBYyQ1Ek0n4i8nsJL7DMbzR1iXn
	 U3yvnbb3yfufgtYmfLwh10RpZXodZ6xC4s5vtX4LQ+2Chk/LcmV/iaG2diSFGESa0XWYx
	 Qd1h4uBvGzdQwigp/38TuR3e4DKytPSIDORiX4ABNLXJKa22gETYd5bjXJubbRBJ5knOQ
	 pHfKwWi3kXNcEjFaD9l0NMRl+YoWuBAMgdWyBtry5Xlh61aQH20pOz4feYyGK25Sz3g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=lhHZtVtw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.26
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012026.outbound.protection.outlook.com [40.107.200.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FB4606A326;
	Thu,  5 Nov 2026 22:43:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47FB4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=lhHZtVtw
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LE1Afsb2MVWU+dHwNq3n5anbkbPipoEuf87PfYITnFsaYfHgn8STCF3x9PtYLuRomJbzpAGjUfX5Bk+yBLl2PUqHV+a2Fll+/wQJMFCRh/F3fBU/OKN8JPFrLTVie0ecOD4pLi4+HVtEmsFW9EcE6IKXxPpWXin31Unl1GLT4k9KYrNcn6P1PAAtY/VxCOUMeGXJoGNWlSTgWc/m6+2xDIu+2uXjFthWLcwNE9uCJ1a+o3DmVdrHJjxX5z/xF43n+zqfzwB/MxwcmA4knTfqA1UPZ8EmlMTOzSHwgP0LgJGcnYZPiNOV+u2B00P1vqOAJpZbMQWHz7EWb66owxseSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BkdD/cZMNRZKed7sBfNBzfluVajKzrKiEwZ81jFnQWY=;
 b=UXo7zXW1dswhBKwQ4PEfuPuuBf3sZDt/qvn63Kff8MwpgJ/JPRu4K766cfo3jiLcYWYmvxwQlILITLhhiL9bPPlq7jrQ8PVvWF/OYoOHnKYx0NbIj1/Dpl/cO0cgebpG9WM/L/5XlZnnrjXhC/JbRJRK10CdG1JBSA0IPVUwsfwkawXSzzfOHOkIeawwPlI3GQlhGK728Cp6TQr3B0ybKBSvi8+UD2BP0DwzOFgcHn5bw+2qE6df0NWUhL0ybMUB2McWTQqShjxNLJjyQdOYIWyZZe7MS8pBY3F8Sk9c8tb5GytpGd2mjvi7K2I5B4LGqMi4hZgZMtYfhS4bRcZM/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BkdD/cZMNRZKed7sBfNBzfluVajKzrKiEwZ81jFnQWY=;
 b=lhHZtVtwzkcTgJicWslDXd8FojQeFVSGL04dwWYl5rBF4stkEOj9pmhOjhOiBvlCON4ml6AivRuLwCqIlHTEjd7Tr0QVNfzn+PyifEJhwvvt4pF2e+9nv138IT+QogMyHcXaMUWm7yTrPzk1RffXOwscpsDF1+hl3qFz6XulcFA=
Received: from CH0PR03CA0265.namprd03.prod.outlook.com (2603:10b6:610:e5::30)
 by CY8PR12MB8214.namprd12.prod.outlook.com (2603:10b6:930:76::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 22:43:45 +0000
Received: from CH01EPF000BE94A.namprd02.prod.outlook.com
 (2603:10b6:610:e5:cafe::24) by CH0PR03CA0265.outlook.office365.com
 (2603:10b6:610:e5::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 22:43:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH01EPF000BE94A.mail.protection.outlook.com (10.167.244.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 22:43:45 +0000
Received: from [192.168.0.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 5 Nov
 2026 16:43:43 -0600
From: "Nikhil P. Rao" <nikhil.rao@amd.com>
Subject: [PATCH net-next v2 0/3] ionic: make the device command timeout
 configurable
Date: Thu, 5 Nov 2026 22:43:10 +0000
Message-ID: <20261105-b4-ionic-cmd-timeout-v2-0-35a9a2aa48b1@amd.com>
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
X-B4-Tracking: v=1; b=H4sIAH4G7WoC/32OwQ6CMBBEf4Xs2TVtLZJ48j8MB2gXWZO2pi0EQ
 /h3C949TmbezKyQKDIluFUrRJo5cfBFqFMFZuz8k5Bt0aCEukopFPYaS4QNGmcxs6MwZTSN0La
 +CN3rAQr6jjTwctQ+wFNGT0uG9uekqX+RyXvrnh055RA/x4NZHsT/sVmiQDU0tVFWdMI0987Zs
 wkO2m3bvvdj9ZPSAAAA
X-Change-ID: 20261102-b4-ionic-cmd-timeout-c704d5304b4f
To: Brett Creeley <brett.creeley@amd.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Abhijit Gangurde <abhijit.gangurde@amd.com>, Allen Hubbe
	<allen.hubbe@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
	<leon@kernel.org>, Jiri Pirko <jiri@resnulli.us>, Simon Horman
	<horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-doc@vger.kernel.org>, Eric Joyner
	<eric.joyner@amd.com>, Arun Kumar Prakash <ArunKumar.Prakash@amd.com>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>
X-Mailer: b4 0.15.2
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94A:EE_|CY8PR12MB8214:EE_
X-MS-Office365-Filtering-Correlation-Id: 312763b5-ecca-42e2-fdac-08df3b8e3fef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|7416014|1800799024|18002099003|6133799003|3023799007|10067099003|13003099007|921020|11063799006|261026121527099003|261026140227099003|261028144727099003|261102123227099003|261021135927099003|261022105027099003|56012099006|261021121427099003|261021123027099003|261009223027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	ecDel00gw2GhefQH5EhTN4rpHfX1ItnpxiOsyTxdrdoAIP9E/cQqmHd2WkMQtCUss4P8/Mx5MRWI/SmZxiwd/LqIGxXzBNZRhPykKmHrjl7V0fZ/cd3xWz7vHhk4DvuXpqnTyCnXuqQ0H7mp/JK3tkSZ8xjcnKP9Or/MrqUtvJIEe/7/RtchdmOugaOeVZDvvJPZMhrDzUO7o3aKwAO59OhjRgyTdrG08Gxx+BrC+MpxoxR2aLo3s6LLuFq6vVqkwLNyLD2cy7P8/NLq8LXQ8EQ4OhHLHC7u8E5PsszoAMuOIDpGKUeELyk+7CwqlGgCi4kL62+HFPPjh/jD/l46RCt2MLSibyC760TQIIQj2hl/b7mmlrJfAtVqc2LxdAf4ewoUIOTeLsvxMIt6C0q7xJtbx0b1z+z9B7rsLm4d/tJPOkgkCwgIiBVf8PxtqIMTnwH/spIZYKv3Jhwkz1NhRFDuxpP5Fh9umTNQL6KA2SBKfXEKZVob6YFWtxpKpQWaBNhA7VyrAJX7f5B/f8Tj5GrFNXUGNA67k6Nct42I6Ql7I6FEAN8DFTZIB168lmArtshNXv+Oyu5Q4WhuCiFUDbqiHJSHVNLSvUoHhwtEnclVRAMmeOj+opvjjV+jZASu9qmcQ+RXK5LLU/zRSjMnBQ0JKJtnJhlcCdYbthGA195I1QKg+WtjfC+urIHXIOFEQ5sTgjTKPnV/b+L9FLLvMQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(7416014)(1800799024)(18002099003)(6133799003)(3023799007)(10067099003)(13003099007)(921020)(11063799006)(261026121527099003)(261026140227099003)(261028144727099003)(261102123227099003)(261021135927099003)(261022105027099003)(56012099006)(261021121427099003)(261021123027099003)(261009223027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ibA07dmtAgWLCnNqVRJvhzQZDBnT84mF4KiDKHSKxIhbP7Q2cpyMbm2W4Uk6/Ton8LHL204Zz1zkkCa/xfnmwDyGNSLsFvLSXorDfim7Rt+0wELOgrVFRZ//H9sO4EFIKPSM9L+8i3lRICHlFDCM8MmNtKOoD1me8iHO5f5jO1UYC1giborgMn/XjfX2Ux8e2dwYJ/4lgKhHGLuIxINENtS3x+Sr7LjiAgLgiy4l8rKDRWytP0ScHGOgErQ1q81T1NixJJxLdtig9Gnrg06KqUIvmAdxe4kOABdhUjvT+zLCEf2fKVAkMnP4kPM3OljmxKK0aliGwKYsViQNCf0Z/qB8hpWuvqN8API/onoupINzHa23ugNudmKEw9WrzaNosh7rcRwIxxxE6oXfWUTzVID56VmPSps6+pKEREPWm6Hjwj2EtYkAXSPGqq0bCzaE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 22:43:45.3453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 312763b5-ecca-42e2-fdac-08df3b8e3fef
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8214

ionic waits a fixed 5 seconds for device and admin queue commands, and
the RDMA driver gives its admin queue 2 seconds. Some commands can take
the firmware longer than that, for example while a PFC configuration
change flaps the links. The firmware is alive but slow, yet the
timed-out command and everything queued behind it fail, and an RDMA
admin queue timeout resets the RDMA LIF so that later verbs fail with
-ENODEV.

Patch 1 makes the timeout a per-device value without changing it.
Patch 2 has the RDMA admin queue use the ionic command timeout instead
of its own 2 seconds.
Patch 3 adds a permanent devlink parameter, cmd_timeout, stored in
device NVM, that lengthens the timeout on firmware that supports it.

Tested on an AMD Pensando adapter under KASAN and lockdep, including
repeated PCI resets with concurrent parameter reads.

This series was developed with the help of an LLM-based coding
assistant (Claude).

---
Changes in v2:
- patch 3:
  - comment in ionic_dl_cmd_timeout_get() on why it has no FW_RESET check
  - changelog "after probe or reset" -> "after probe or PCI reset"
- Link to v1: https://patch.msgid.link/20261102-b4-ionic-cmd-timeout-v1-0-2f75c2d0a0c7@amd.com

---
Arun Kumar Prakash (3):
      ionic: make the command timeout per device
      RDMA/ionic: Use the ionic command timeout for the admin queue
      ionic: add devlink param for command timeout

 Documentation/networking/devlink/ionic.rst         | 29 +++++++
 drivers/infiniband/hw/ionic/ionic_admin.c          |  9 ++-
 drivers/net/ethernet/pensando/ionic/ionic.h        | 15 +++-
 drivers/net/ethernet/pensando/ionic/ionic_api.h    |  8 ++
 drivers/net/ethernet/pensando/ionic/ionic_aux.c    |  8 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |  4 +
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    | 90 ++++++++++++++++++++--
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |  3 +
 .../net/ethernet/pensando/ionic/ionic_devlink.c    | 90 ++++++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_devlink.h    |  2 +
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    | 12 +--
 drivers/net/ethernet/pensando/ionic/ionic_fw.c     |  8 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |  8 ++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 13 ++--
 drivers/net/ethernet/pensando/ionic/ionic_main.c   | 17 ++--
 15 files changed, 282 insertions(+), 34 deletions(-)
---
base-commit: 4dd16e31135ea8437a720222df34e8745f385d6d
change-id: 20261102-b4-ionic-cmd-timeout-c704d5304b4f

Best regards,
--  
Nikhil P. Rao <nikhil.rao@amd.com>

