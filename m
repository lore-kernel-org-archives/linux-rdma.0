Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795048375;
	b=sJ8FTK9dxgg0aoYMjxIc36TMtreky00jDmwMwFfGt9Pe4MpeaiLKfSPy//DEddDUXpjy
	 4/9hkY5g5Ah1nC0ZwxrVJbGLp1g+mhx1HUDsFrc4uI1PRm9XFd+lApIVszoxotvlSROVA
	 tVYDs9kQpAhcKRv70P4x/2eWXYPFI22pUwAoYLWil0oouand92BOxZC7isgvafmZzUo4c
	 SUjFFcYZcj+IC3B5/YRGN1PpJP0c5gyLItNuUCgVcqo+kfQGoL9FbbQyckRDG1AH7tSas
	 7PUzw+jTdCDhFdcUSL67hy/mXWv+GjKPDdYlBbHjThGYG5ZvjVA8A0ip1WG8H40Kjhw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048375;
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
	bh=vHpvwIBliAvJRZD3+MXpPZc9pvRWX+4dqOI+HvUOrgk=;
	b=w4pR/rI0jTiwaVu8qKiMi8uT3YlDhYzPwqU3QYCJMQYj/Fn3Ck5A3f9Vb2xOXLWbYzNL
	 ILc66SuuU3SNv+nMjwVOhuihhAH9UNfR25NVFL11yYXgS73uQDez7Sgkyi2CQA0PrfQeG
	 IRUD9P46dyr7J6w35z0e9YqbwrWqSyY9QSqE227lPJNhI9DpBkwnfCyBVdcT9hcNX5tKj
	 vwiBjU4O83A66v2/24vdkncp6Qlo4lU4eDTIbEdu/0QSaXtQ8J/MeiYGN+BayHP1+taLs
	 Aa0rpN3lbrnsGbX5nGXOEbF+C2lKDr2zVsS+MB/nG2nOUDrECPmvwjD0rImLaE8/9cg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="W/rNb1Be";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.49
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013049.outbound.protection.outlook.com [40.107.201.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBA260A2606;
	Thu, 19 Nov 2026 00:32:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DBA260A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=W/rNb1Be
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=soAQuO9ocQqsrU9lhKHmXTCqjBQIUDBAKFY+DqXKscdffyHCb0681m4kLOkMY+ToASG+S+4nXL5UWWnZIFX4qRjy5Vfc4vsdLOiC0+L+ewQDRpRxp4D5v/XMakP1gy8MRRJoK7iNFeD+giSdTsHfIAGv/p4DburhaxwjW3gbaVyf0IfSyLIuhidhGUGeGnbSUK1fXBvAGtbhlk1MUOHcaox48H3LA/1rR1SEA/3Uhw2EX7oT+J9f5vw3mbWBL+xrToW5qpJoq28I0ybauFj5kdht882dFKz50vV+GcciMbjdaiHokw4HXRVccztkw1DoLeD9qfou7qSo0I3+X4wjTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHpvwIBliAvJRZD3+MXpPZc9pvRWX+4dqOI+HvUOrgk=;
 b=AnrbsABbfMnzNKwergDze/eQNmFxmpRPVIc78/N6kMdEUGkMPE84Nr3yYun2R3VUc6/gk5FZGxdvYXeMP5eVO1lF5e0mFkqpKcMC95X2J6LXk4/v+2XV35w0JZa4MP/n4iz4B2fXhne3XHQbpmy5EN/qvaoP56o4dkJs9d37pMdAm0+ktxkVw2qcDcdeLFbz6XVwyixw+dcyPV6r3Hxj1lLF36K2/pJOyLSxxqy44nvCaxs7hYT/sBfFYGR3pRzzG8688OvPMb9VRArz8f6VS5vsrdkD+on9qLSWveoaHTc49luJVhEQEKjkXHF2iHPQU0wuyIgXGYVTIaE4LVRhhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHpvwIBliAvJRZD3+MXpPZc9pvRWX+4dqOI+HvUOrgk=;
 b=W/rNb1BeOy01X+M5XNgyEZznBY+AzwDrZPG4ujThka+cBxzjFnXKjxuE+XFofq/dKff7Aen9xTTrUHRCcl4a/0UkvrPxmrHGfKhDFpABQVnHTChmEc8mjIrSsWQeZZtbSMBrYmOrSqEHxcmKUw0vho0AkkAPAtx70u7NNj8FQiY=
Received: from BLAPR03CA0124.namprd03.prod.outlook.com (2603:10b6:208:32e::9)
 by MW4PR12MB6756.namprd12.prod.outlook.com (2603:10b6:303:1e9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 00:32:46 +0000
Received: from BL6PEPF0006C3E0.namprd02.prod.outlook.com
 (2603:10b6:208:32e:cafe::5d) by BLAPR03CA0124.outlook.office365.com
 (2603:10b6:208:32e::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Thu,
 19 Nov 2026 00:32:46 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3E0.mail.protection.outlook.com (10.167.249.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 19 Nov 2026 00:32:46 +0000
Received: from [10.11.96.223] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 18:32:44 -0600
From: "Nikhil P. Rao" <nikhil.rao@amd.com>
Subject: [PATCH net-next v3 0/3] ionic: make the device command timeout
 configurable
Date: Thu, 19 Nov 2026 00:32:30 +0000
Message-ID: <20261119-b4-ionic-cmd-timeout-v3-0-2cdb8fca15fd@amd.com>
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
X-B4-Tracking: v=1; b=H4sIAJ5D/moC/32OQQ7CIBREr2JY+w1QsOrKexgXFH4tJhRTKKlpe
 ncpLnSjy8nMvJmZBBwsBnLazGTAZIP1fRbVdkN0p/obgjVZE075njHKoRGQI1aDdgaidejHCLq
 mwsiKika0JFcfA7Z2KtgL6TFCj1Mk17cTxuaOOq7UNdvZEP3wLA8SK43/Y4kBBd7WUnNDFdX1W
 Tmz096VgcS/EfIHgmdEJdVRcaXEoWEfxLIsLw6ZubMVAQAA
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
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3E0:EE_|MW4PR12MB6756:EE_
X-MS-Office365-Filtering-Correlation-Id: 3268a885-49c0-4d84-f3f2-08df45d4a1d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700016|23010399003|82310400026|921020|261102123227099003|10067099003|11063799006|56012099006|261021121427099003|261021135927099003|261021123027099003|261022105027099003|261026140227099003|261009223027099003|261022075727099003|261026121527099003|261028144727099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	ajhasFzxpSptVn4pEVsV0D4vBNCqCi1cYV08fIujkplr9WFzhmXzNHRuBfN+3WbHkg5wQLeNntbimc3A4bgAtfjGCBhsVzvp2Fu18lFZolYOxrKQFdLtS/EbQ+niUnb3P5tsNojwCPlKdrNqGZS/tRtSKuvlZzdjHs1Rm1TIc+WouJKPslrgk5G4IPxuHno2n9bR7p2gHhjmWHtE8DKIMD8C1A+KQ+Nv2EgFU+0wJUUVPXS3WZxzEbdzs/x78vPI3ArB5d0DXVgA2ylvDx4uj0onTqpwC+zrlppkmzdeKhDAW2Bt3X4XFnyNNzIz/3jm/n20Ee+beVwVtqLI7+Y1AOS/gATT8a07Uka7BioAUjYybgvIOWN2R/QVJjJvBYRwqdBUFXBd/Fzl0jb2bOy1zASLy2d1sGte3wlMVSqWvaSyXg84cefVKFs0A+Q3lsWgLe7TxGpHbD8kepXHmQpgI1QgO3QMEAQoZy1SLvvvoyvn9G0jOIWEScPnInoz+mlw7a4TGyDD0dJLFsi3QBWmUsb1LlqEqZpJdGqc+3AtCdzI8Z0PrJXZsKsXZeJugz6zrk9XVh+ACXVFgx6nkAbqD35+Arm/rj0JNst1C5TeCFYIZRtoXIj90u00lHNtPr4Rsga0bbXiT+Fh00aMG0LseRPT0nv+NojLQSJddTSjXWBFBHTaKcfjfgWyDfTfPI89LEua2H5p7Nz7Bkb2gMJLPA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700016)(23010399003)(82310400026)(921020)(261102123227099003)(10067099003)(11063799006)(56012099006)(261021121427099003)(261021135927099003)(261021123027099003)(261022105027099003)(261026140227099003)(261009223027099003)(261022075727099003)(261026121527099003)(261028144727099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UGdxLiaxNq7NV/Z7a/ndg6wszV1aw1b2CXpktHnktXaJO4N4DJTxNYW1gUuhT1GPkLrPEF3anMF8zTM8bW4+Yt1NXqLOgNVgs3tGDp3x62j6BOweu/RwdqN7ZYU//EAUdcp1xue9TFhOo3I6v5VEG/TwcJd75cGANyoCSnYYQGPbSXfAJ1SRYgDzmEGLycHF0Zoj/q10cdiDMQmnl91NGUcWc3xVk3oWy7t5Tjne0NbFgA2ByRipx0DcXNEsodSUW+pvEQcujIkS0DtQPK2QRTfd2ZQTR+dNItmsAcOKYHVGkv60pQX3pmVoGBLck3aJIfTr+2UzhKqfNXCOyVsBnyzHBvtqYZh54nGsiX8lZkzcsQJQdPwuaz3XrEFOboMppuurFk/AQtSy0rSQ4R9WrPRSJKCkXKQqlkdpcBKQrnwKGS2OOzLhg8S8O9hfirvD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 00:32:46.0085
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3268a885-49c0-4d84-f3f2-08df45d4a1d5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3E0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6756

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
Patch 3 adds a permanent devlink parameter, cmd_timeout, on each PF.
The firmware stores the value per PF in NVM, and the PF and its VFs
read it at probe and after a reset.

Tested on an AMD Pensando adapter under KASAN and lockdep: get and set
of the parameter, and the stored value read back after an FLR.

Patch 2 conflicts with "RDMA/ionic: Wait the device command timeout for
admin queue commands", sent to rdma for-rc:
https://patch.msgid.link/20261118-b4-ionic-rdma-admin-timeout-v1-1-39536999a3e4@amd.com
When both are merged, keep this series' version: ionic_admin_timeout()
replaces IONIC_ADMIN_TIMEOUT, and already defaults to 5 seconds.

This series was developed with the help of an LLM-based coding
assistant (Claude).

---
Changes in v3:
- patch 3:
  - register the parameter once at probe, on PFs only, instead of
    unregistering it on firmware and PCI resets and registering it
    again on restart
  - get reports the value read at the last probe or reset, or stored by
    a later set, instead of sending a device command
  - keep the timeout in use when reading the stored value fails,
    instead of falling back to the default
  - read the stored value right after identify at probe and PCI reset,
    so the remaining commands there use it
- rebase on net-next
- Link to v2: https://patch.msgid.link/20261105-b4-ionic-cmd-timeout-v2-0-35a9a2aa48b1@amd.com

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

 Documentation/networking/devlink/ionic.rst         | 27 ++++++++
 drivers/infiniband/hw/ionic/ionic_admin.c          |  9 ++-
 drivers/net/ethernet/pensando/ionic/ionic.h        | 10 ++-
 drivers/net/ethernet/pensando/ionic/ionic_api.h    |  8 +++
 drivers/net/ethernet/pensando/ionic/ionic_aux.c    |  8 ++-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |  3 +
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    | 70 ++++++++++++++++++--
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |  2 +
 .../net/ethernet/pensando/ionic/ionic_devlink.c    | 77 ++++++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    | 12 ++--
 drivers/net/ethernet/pensando/ionic/ionic_fw.c     |  8 +--
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |  8 +++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 11 ++--
 drivers/net/ethernet/pensando/ionic/ionic_main.c   | 17 ++---
 14 files changed, 236 insertions(+), 34 deletions(-)
---
base-commit: 44454974aef9c81949e5858ed3e8cbd08e104cad
change-id: 20261102-b4-ionic-cmd-timeout-c704d5304b4f

Best regards,
--  
Nikhil P. Rao <nikhil.rao@amd.com>

