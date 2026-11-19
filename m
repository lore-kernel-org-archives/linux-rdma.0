Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795048389;
	b=mtuSYjuNL8UNiiqCpDxziCB4KtmNM4KjkTT/NjNf8ZtVgA3qV/w1gXFm8TXRLUzuWrSz
	 JNa+iqqI83z1WggeRV61RxcMkaMRaDS3BsFKs/qgX3cf1nbbTOsK7X00Ec1gsDSl7jNtd
	 TmZbHLF5PE8MCmjydZFZtgqi4t1LxdkfnNSDwGC0YpOqnNhWVX33bTj85UD35nffOlm0P
	 5SE9BIARRxxvkPn4ijRvxntoAR9h/8wAZYusuZagRSXzixcol3cjZKrcTZqcEo1+ugcHy
	 QwDhN55nRy8gOr6OXK2qjCd0NDH4xh8E+P8aoZ4ZMd+8K5Fcv81yIUfYMXz70sjQWzg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048389;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-ID:References:In-Reply-To:To:CC:X-Mailer:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=iGRUHs97q8HgWsn9IRw7GWaoXESfHf2lQ5Bv7nxKLN8=;
	b=4Saz3kq0Si8ry8kWAktvLKKS1NOZwTkUn5lh7X8wPi4wDHsrP5MitzvUBLSZ3ZFCe006
	 38G5wiR/2F1PBjfhMTu9Ba8VVxuqp/vZDqM/5CYFCC1ddpKdLkP3ZThuZhdBOLpHa9Ny2
	 Q5g2+u0RujmtghQLXkzqNs3TbSwHPCRHy/zu8/0FRCYSup7maPbOrojo7HWovx8xTdgUw
	 amrPLsJ5eitoWEtifp3Sjdq4LhLyvA8UzulW9smEZ3H6sE03Pv199bKI9IwL8Uf2R9VVN
	 Rm+AXKhlYDgZVghY/1UtFif+5OYS23AWbqgDu7BTdpXn1wIJgwYF3ZtQNRetIdSrGdA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=3iMESX6c;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.6
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010006.outbound.protection.outlook.com [52.101.56.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9E0606A333;
	Thu, 19 Nov 2026 00:33:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD9E0606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=3iMESX6c
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ICWi+ojIOfKFMw6ATb9Q7F1LbtCpeY1miaN9eddIdB5jihA3ehiZsTpsMMLoImckTbUE5puxU85QyDZtF/eiqzxAOSKtWoCNlpotnkA4+PuwrL1i1iGLHw4F7aQwzt+cL13DaejFULxxat4LVigh8SglS9/B7x/y8+ocGyIDzgXDV1ABSP30PuFuu6QvA+w4lLJiClxqk1emjeiyyHJvSKcRJOz3XYyyxvHZ5ac3fvTjJFO5W3+UU8nkEAHJIXMaXKYajZrdJYA0y7cmmKx6TYi18YiwYxnTU0UUX0Xby/7jUjnZ3uwdtxYJk4WZVFHFaN7P45XQXv4Kexz+hrd6Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGRUHs97q8HgWsn9IRw7GWaoXESfHf2lQ5Bv7nxKLN8=;
 b=Ak6DOUwvDAKyVKPMiOgE+h9vg3bhwAv6PCzkCexXWR+a051400PYJH0d5oTH1osucPux8wZ9oTM0LtB1pi4iRfVh34IntmXDYokRlEJSN6TgBdQYaPkNRsEAHx2se19q3JDxniwFGEnz0YdUplDw40XkKgSFxuaBfuC4i5Zkjk6BGLfmhIKLf0Bvj24wHm8FHyb7QR1bd2IxkbcofvmeKJMHb37hoQkcpZi8gtMrhW5D97FxHRwcSoQERQJ1P+qxD2YxhhEFbB/R6QGPS7n7E/DoAOY86AyqljnkzNY2zLL5SmzXOmC0+Q+e3Jt7sZv/antniuHbxzKBIA3agnMRdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGRUHs97q8HgWsn9IRw7GWaoXESfHf2lQ5Bv7nxKLN8=;
 b=3iMESX6crEII4uWnf1v8gtswrPL+ebf6OjHReD62kVu4QSKr00VWCr6woQdpvmH1FapVBLVCAWcvN7viLCBrI3cxZkzVnkOqtSwsXmOEHm7233675AO8gLUTjG1tmQy+erBMQKzXkwhdbK6a/JbQuxVOkqtestH/tJtqK0GAVqI=
Received: from CH0PR03CA0095.namprd03.prod.outlook.com (2603:10b6:610:cd::10)
 by SA1PR12MB8985.namprd12.prod.outlook.com (2603:10b6:806:377::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 19 Nov
 2026 00:32:51 +0000
Received: from BL6PEPF0006C3DE.namprd02.prod.outlook.com
 (2603:10b6:610:cd:cafe::29) by CH0PR03CA0095.outlook.office365.com
 (2603:10b6:610:cd::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.13 via Frontend Transport; Thu,
 19 Nov 2026 00:32:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3DE.mail.protection.outlook.com (10.167.249.233) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 19 Nov 2026 00:32:50 +0000
Received: from [10.11.96.223] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 18:32:49 -0600
From: "Nikhil P. Rao" <nikhil.rao@amd.com>
Date: Thu, 19 Nov 2026 00:32:33 +0000
Subject: [PATCH net-next v3 3/3] ionic: add devlink param for command
 timeout
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
Message-ID: <20261119-b4-ionic-cmd-timeout-v3-3-2cdb8fca15fd@amd.com>
References: <20261119-b4-ionic-cmd-timeout-v3-0-2cdb8fca15fd@amd.com>
In-Reply-To: <20261119-b4-ionic-cmd-timeout-v3-0-2cdb8fca15fd@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3DE:EE_|SA1PR12MB8985:EE_
X-MS-Office365-Filtering-Correlation-Id: 54fa0247-413c-449b-4837-08df45d4a4ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|36860700016|82310400026|7416014|376014|18002099003|22082099003|6133799003|261009221227099003|261009223027099003|3023799007|11063799006|921020|56012099006|261022075727099003|261026121527099003|261102123227099003|261028144727099003|261021135927099003|261022105027099003|261026140227099003|261021121427099003|261021123027099003|10067099003|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	aB2xbf/CALm8yfv1Dxgmw16zS61RS5W6hb8ANEYgDcP6DtUYrcHOKmf+TZNwU6eNQq+19ddwGe+A+GfSsqjH64rMt3UzwPHRgA23MTusecPPevfnRXa5Zo0UHd1Ay8wTuzEUIhvv9J0q4SwvjYIw7N0Lfq79zqA+68ejqDj2tG9GbTxpea/rZo7Opf1+cfvUCk+KOYu4/3BtjmLgyI/PTCFPo1ngnv/hJIQLIsIeOPAKNmqfOs1MD9O77ozRMaBIug/FyQh1cf8droralM3cNigqRBDcr/rHISEbDNc4owAiD89QMfyRj125P3mcUp/biRZhzLgoTX3c/MbTSfoZEJpl8rb/93i2Bj2Dyog+GRSmkIhIzI7yRLkA+KPBTHo/CzacIN8j7bgdaByOzQxXzDO8bMksZShmNB+q3tPZqKDeXwVwHw6j1kodeitgLDky2MSF/xNKn0Wug2Zjk/53kQRnjEarMcS13TxstopOCU3MHfqnruatUlPM1vhPkatjLGAkyAP1P7c3BPlWhIgfA3TBdO/eqPmkTpA36FL0z6d7fTv+e3E4682WFi8eGp7zHpFAGtmfdAoozaY9bMQHSSZG4puuksGOY9Hp7a05I5Df81ryGRo0OCL17GjrRPKhGrV+hnvowjmpK/G0u5SKLXjAOdFFq/mr9C018b1xJbUsXyPNxoM1vTpZV0SJOzXX+Pz8iyDp+m2Vwn2NJIFlzbVxvkhE/3psGMzkmcbFhNAfZiHCr5LiMT8EOwp4rK6c
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(36860700016)(82310400026)(7416014)(376014)(18002099003)(22082099003)(6133799003)(261009221227099003)(261009223027099003)(3023799007)(11063799006)(921020)(56012099006)(261022075727099003)(261026121527099003)(261102123227099003)(261028144727099003)(261021135927099003)(261022105027099003)(261026140227099003)(261021121427099003)(261021123027099003)(10067099003)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xGR6nHDFi8wQZWUYXLjS3ybyyan2sHDx+vpVQwFkxZaN7cweruXMZdP6GLyMVqdMG3EChTI/m3a04P6LcqVLB3RczSbUdUVbpV6iliGzbP3ZUWdJ1zZfDFWry+K75pOCxmnHb2Vpxd10cEyAsIBe4ppldGsUbsDAVTtcgI130wchcVNw27urAHNVO6ZdZoCerklGYN5kW62mKEiWwwQLnl4jUEesj05Aa5GZNO/6HNON7Q8O7sG2qwGemgYnCrVfeZM8XdmzSW1kp4kfz4i40yPscb4yHzAqOdKfZxBlUkgC0ouhQR/cY2PoKuYy2uYCFiVd+YAIe7kTGtfBzZtbuEfMOY22JLWDjUQjIJLjEg4vAPS67lBgLumhscZ6JV58wDuVu2hCRpVBDHPLvqQgCWuJVxUMMAe8CeHQl12+QYRUZHTxc9l+ILWXp9QQmEXK
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 00:32:50.8520
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fa0247-413c-449b-4837-08df45d4a4ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3DE.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8985

From: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>

Some device and admin commands can take firmware longer than the
driver allows to complete, for example while a PFC configuration change
flaps the links. The firmware is alive but slow, yet the timed-out
command and everything queued behind it fail.

Make the timeout configurable so it can be tuned to the firmware
behaviour seen in production.

Add a permanent devlink parameter, cmd_timeout (u8, seconds), stored in
device NVM via a new device attribute, on firmware that advertises the
new IONIC_DEV_CAP_CMD_TIMEOUT capability. A non-zero value replaces the
device command and admin queue timeouts, and the firmware heartbeat
check interval derived from them; 0 restores the default. A new value
takes effect on the next driver probe or device reset.

Back-date the initial heartbeat check time by the largest possible
interval rather than the watchdog period, so that a larger value does
not delay the first heartbeat sample after probe or PCI reset.

Accept 0, or 5 to 255 seconds (the u8 range). Values below the 5 second
default are rejected, as the parameter is only meant to lengthen the
timeouts. On unresponsive firmware, a larger value also lets callers
block for longer: each device or admin queue command can wait up to this
value, other commands wait behind it, and RDMA verbs such as QP and CQ
create can block for several times this value. A large setting may need
a larger kernel.hung_task_timeout_secs.

Signed-off-by: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Co-developed-by: Nikhil P. Rao <nikhil.rao@amd.com>
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
---
 Documentation/networking/devlink/ionic.rst         | 27 ++++++++
 drivers/net/ethernet/pensando/ionic/ionic.h        |  7 ++
 drivers/net/ethernet/pensando/ionic/ionic_aux.c    |  2 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |  4 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    | 61 ++++++++++++++++-
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |  2 +
 .../net/ethernet/pensando/ionic/ionic_devlink.c    | 77 ++++++++++++++++++++++
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |  8 +++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  1 +
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |  3 +-
 10 files changed, 187 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/devlink/ionic.rst b/Documentation/networking/devlink/ionic.rst
index 48da9c92d5841..f9c6421375c12 100644
--- a/Documentation/networking/devlink/ionic.rst
+++ b/Documentation/networking/devlink/ionic.rst
@@ -7,6 +7,33 @@ ionic devlink support
 This document describes the devlink features implemented by the ``ionic``
 device driver.
 
+Parameters
+==========
+
+The ``ionic`` driver implements the following driver-specific parameters.
+
+.. list-table:: Driver-specific parameters implemented
+   :widths: 5 5 5 85
+
+   * - Name
+     - Type
+     - Mode
+     - Description
+   * - ``cmd_timeout``
+     - u8
+     - permanent
+     - Command timeout in seconds for this PCI function and its VFs, 0, or
+       5 (the default) to 255; values below the default are rejected, as the
+       parameter is for cases where the default does not suffice. It bounds
+       device and admin queue commands and the RDMA admin queue watchdog, and
+       the firmware heartbeat stall check runs at twice this interval.
+       Setting 0 makes the driver use the default. The value is stored in
+       device NVM and takes effect on the next driver probe or device reset.
+       On unresponsive firmware, a larger value lets callers block for
+       longer; a large setting may need a larger
+       kernel.hung_task_timeout_secs. Only available on physical functions
+       whose firmware supports it.
+
 Info versions
 =============
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 39999bdbca55e..1a50783171af7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -67,8 +67,15 @@ struct ionic {
 	void *hwmon_caps_buf;
 	dma_addr_t hwmon_caps_pa;
 	u8 cmd_timeout;
+	int cmd_timeout_param;
 };
 
+static inline bool ionic_cmd_timeout_supported(struct ionic *ionic)
+{
+	return ionic->ident.dev.capabilities &
+	       cpu_to_le64(IONIC_DEV_CAP_CMD_TIMEOUT);
+}
+
 int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx);
 int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
 		      const int err, const bool do_msg);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_aux.c b/drivers/net/ethernet/pensando/ionic/ionic_aux.c
index 70f193ebb7ea2..2c28969790838 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_aux.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_aux.c
@@ -250,6 +250,6 @@ EXPORT_SYMBOL_NS(ionic_request_rdma_reset, "NET_IONIC");
 
 u8 ionic_cmd_timeout(struct ionic_lif *lif)
 {
-	return lif->ionic->cmd_timeout;
+	return READ_ONCE(lif->ionic->cmd_timeout);
 }
 EXPORT_SYMBOL_NS(ionic_cmd_timeout, "NET_IONIC");
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index abadfa11ebdbd..6177a68bb6581 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -239,7 +239,6 @@ static int ionic_setup_one(struct ionic *ionic)
 	struct device *dev = ionic->dev;
 	int err;
 
-	ionic->cmd_timeout = IONIC_CMD_TIMEOUT_DEF;
 	ionic_debugfs_add_dev(ionic);
 
 	/* Setup PCI device */
@@ -273,6 +272,7 @@ static int ionic_setup_one(struct ionic *ionic)
 		dev_err(dev, "Cannot identify device: %d, aborting\n", err);
 		goto err_out_teardown;
 	}
+	ionic_update_cmd_timeout(ionic);
 	ionic_debugfs_add_ident(ionic);
 
 	ionic_map_cmb(ionic);
@@ -323,6 +323,8 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ionic->dev = dev;
 	pci_set_drvdata(pdev, ionic);
 	mutex_init(&ionic->dev_cmd_lock);
+	ionic->cmd_timeout = IONIC_CMD_TIMEOUT_DEF;
+	ionic->cmd_timeout_param = -EOPNOTSUPP;
 
 	err = ida_alloc(&ionic_ida, GFP_KERNEL);
 	if (err < 0)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index f14fff4a74278..8e8f7d8d174e1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -144,7 +144,7 @@ static int ionic_watchdog_init(struct ionic *ionic)
 
 	/* set times to ensure the first check will proceed */
 	atomic_long_set(&idev->last_check_time, jiffies - 2 * HZ);
-	idev->last_hb_time = jiffies - 2 * ionic->watchdog_period;
+	idev->last_hb_time = jiffies - 2 * U8_MAX * HZ;
 	/* init as ready, so no transition if the first check succeeds */
 	idev->last_fw_hb = 0;
 	idev->fw_hb_ready = true;
@@ -594,7 +594,8 @@ int ionic_heartbeat_check(struct ionic *ionic)
 	 */
 	last_check_time = idev->last_hb_time;
 	if (time_before(check_time,
-			last_check_time + ionic->cmd_timeout * 2 * HZ))
+			last_check_time +
+			READ_ONCE(ionic->cmd_timeout) * 2 * HZ))
 		return 0;
 
 	fw_hb = ioread32(&idev->dev_info_regs->fw_heartbeat);
@@ -689,6 +690,62 @@ void ionic_dev_cmd_reset(struct ionic_dev *idev)
 	ionic_dev_cmd_go(idev, &cmd);
 }
 
+void ionic_update_cmd_timeout(struct ionic *ionic)
+{
+	union ionic_dev_cmd_comp comp = {};
+	union ionic_dev_cmd cmd = {
+		.getattr.opcode = IONIC_CMD_GETATTR,
+		.getattr.attr = IONIC_DEV_ATTR_CMD_TIMEOUT,
+	};
+	u8 timeout = IONIC_CMD_TIMEOUT_DEF;
+	int err;
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	if (!ionic_cmd_timeout_supported(ionic)) {
+		WRITE_ONCE(ionic->cmd_timeout, timeout);
+		WRITE_ONCE(ionic->cmd_timeout_param, -EOPNOTSUPP);
+		goto out;
+	}
+
+	ionic_dev_cmd_go(&ionic->idev, &cmd);
+	err = ionic_dev_cmd_wait_nomsg(ionic, ionic->cmd_timeout);
+	if (err) {
+		dev_warn(ionic->dev, "Cannot get cmd_timeout: %d, keeping %u\n",
+			 err, ionic->cmd_timeout);
+		goto out;
+	}
+
+	ionic_dev_cmd_comp(&ionic->idev, &comp);
+	if (comp.getattr.cmd_timeout >= IONIC_CMD_TIMEOUT_DEF)
+		timeout = comp.getattr.cmd_timeout;
+	else if (comp.getattr.cmd_timeout)
+		dev_warn(ionic->dev, "Ignoring out of range cmd_timeout %u\n",
+			 comp.getattr.cmd_timeout);
+	WRITE_ONCE(ionic->cmd_timeout, timeout);
+	WRITE_ONCE(ionic->cmd_timeout_param, comp.getattr.cmd_timeout);
+out:
+	mutex_unlock(&ionic->dev_cmd_lock);
+}
+
+int ionic_set_cmd_timeout(struct ionic *ionic, u8 timeout)
+{
+	union ionic_dev_cmd cmd = {
+		.setattr.opcode = IONIC_CMD_SETATTR,
+		.setattr.attr = IONIC_DEV_ATTR_CMD_TIMEOUT,
+		.setattr.cmd_timeout = timeout,
+	};
+	int err;
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_go(&ionic->idev, &cmd);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
+	if (!err)
+		WRITE_ONCE(ionic->cmd_timeout_param, timeout);
+	mutex_unlock(&ionic->dev_cmd_lock);
+
+	return err;
+}
+
 /* Port commands */
 void ionic_dev_cmd_port_identify(struct ionic_dev *idev)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 869adb0a0e0c8..3671b099d5338 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -348,6 +348,8 @@ void ionic_dev_cmd_comp(struct ionic_dev *idev, union ionic_dev_cmd_comp *comp);
 void ionic_dev_cmd_identify(struct ionic_dev *idev, u8 ver);
 void ionic_dev_cmd_init(struct ionic_dev *idev);
 void ionic_dev_cmd_reset(struct ionic_dev *idev);
+void ionic_update_cmd_timeout(struct ionic *ionic);
+int ionic_set_cmd_timeout(struct ionic *ionic, u8 timeout);
 
 void ionic_dev_cmd_port_identify(struct ionic_dev *idev);
 void ionic_dev_cmd_port_init(struct ionic_dev *idev);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 4ec66a6be0738..87bf23c3404ff 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -51,6 +51,69 @@ static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	return err;
 }
 
+enum ionic_devlink_param_id {
+	IONIC_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	IONIC_DEVLINK_PARAM_ID_CMD_TIMEOUT,
+};
+
+static int ionic_dl_cmd_timeout_get(struct devlink *dl, u32 id,
+				    struct devlink_param_gset_ctx *ctx,
+				    struct netlink_ext_ack *extack)
+{
+	struct ionic *ionic = devlink_priv(dl);
+	int val;
+
+	val = READ_ONCE(ionic->cmd_timeout_param);
+	if (val < 0)
+		return val;
+
+	ctx->val.vu8 = val;
+
+	return 0;
+}
+
+static int ionic_dl_cmd_timeout_set(struct devlink *dl, u32 id,
+				    struct devlink_param_gset_ctx *ctx,
+				    struct netlink_ext_ack *extack)
+{
+	struct ionic *ionic = devlink_priv(dl);
+
+	if (test_bit(IONIC_LIF_F_FW_RESET, ionic->lif->state))
+		return -EBUSY;
+
+	return ionic_set_cmd_timeout(ionic, ctx->val.vu8);
+}
+
+static int ionic_dl_cmd_timeout_validate(struct devlink *dl, u32 id,
+					 union devlink_param_value *val,
+					 struct netlink_ext_ack *extack)
+{
+	struct ionic *ionic = devlink_priv(dl);
+	int cur;
+
+	cur = READ_ONCE(ionic->cmd_timeout_param);
+	if (cur < 0)
+		return cur;
+
+	if (val->vu8 && val->vu8 < IONIC_CMD_TIMEOUT_DEF) {
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "cmd_timeout must be 0 or at least %d seconds",
+				       IONIC_CMD_TIMEOUT_DEF);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct devlink_param ionic_dl_params[] = {
+	DEVLINK_PARAM_DRIVER(IONIC_DEVLINK_PARAM_ID_CMD_TIMEOUT,
+			     "cmd_timeout", DEVLINK_PARAM_TYPE_U8,
+			     BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			     ionic_dl_cmd_timeout_get,
+			     ionic_dl_cmd_timeout_set,
+			     ionic_dl_cmd_timeout_validate),
+};
+
 static const struct devlink_ops ionic_dl_ops = {
 	.info_get	= ionic_dl_info_get,
 	.flash_update	= ionic_dl_flash_update,
@@ -88,6 +151,17 @@ int ionic_devlink_register(struct ionic *ionic)
 		return err;
 	}
 
+	if (!ionic->pdev->is_virtfn) {
+		err = devlink_params_register(dl, ionic_dl_params,
+					      ARRAY_SIZE(ionic_dl_params));
+		if (err) {
+			dev_err(ionic->dev,
+				"devlink_params_register failed: %d\n", err);
+			devlink_port_unregister(&ionic->dl_port);
+			return err;
+		}
+	}
+
 	SET_NETDEV_DEVLINK_PORT(ionic->lif->netdev, &ionic->dl_port);
 	devlink_register(dl);
 	return 0;
@@ -98,5 +172,8 @@ void ionic_devlink_unregister(struct ionic *ionic)
 	struct devlink *dl = priv_to_devlink(ionic);
 
 	devlink_unregister(dl);
+	if (!ionic->pdev->is_virtfn)
+		devlink_params_unregister(dl, ionic_dl_params,
+					  ARRAY_SIZE(ionic_dl_params));
 	devlink_port_unregister(&ionic->dl_port);
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 271731a35d9f3..e5b2253d2eca2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -280,12 +280,14 @@ union ionic_drv_identity {
  * @IONIC_DEV_CAP_DISC_CMB:    Device supports CMB discovery operations
  * @IONIC_DEV_CAP_HWMON:       Device supports hardware monitoring
  * @IONIC_DEV_CAP_EXTRA_STATS: Device supports extra stats schema
+ * @IONIC_DEV_CAP_CMD_TIMEOUT: Device supports the command timeout attribute
  */
 enum ionic_dev_capability {
 	IONIC_DEV_CAP_VF_CTRL        = BIT(0),
 	IONIC_DEV_CAP_DISC_CMB       = BIT(1),
 	IONIC_DEV_CAP_HWMON          = BIT(3),
 	IONIC_DEV_CAP_EXTRA_STATS    = BIT(4),
+	IONIC_DEV_CAP_CMD_TIMEOUT    = BIT(5),
 };
 
 /**
@@ -1784,11 +1786,13 @@ enum ionic_dev_state {
  * @IONIC_DEV_ATTR_STATE:     Device state attribute
  * @IONIC_DEV_ATTR_NAME:      Device name attribute
  * @IONIC_DEV_ATTR_FEATURES:  Device feature attributes
+ * @IONIC_DEV_ATTR_CMD_TIMEOUT: Command timeout
  */
 enum ionic_dev_attr {
 	IONIC_DEV_ATTR_STATE    = 0,
 	IONIC_DEV_ATTR_NAME     = 1,
 	IONIC_DEV_ATTR_FEATURES = 2,
+	IONIC_DEV_ATTR_CMD_TIMEOUT = 3,
 };
 
 /**
@@ -1799,6 +1803,7 @@ enum ionic_dev_attr {
  * @state:      Device state (enum ionic_dev_state)
  * @name:       The bus info, e.g. PCI slot-device-function, 0 terminated
  * @features:   Device features
+ * @cmd_timeout: Command timeout in seconds, 0 for the default
  * @rsvd2:      reserved byte(s)
  */
 struct ionic_dev_setattr_cmd {
@@ -1809,6 +1814,7 @@ struct ionic_dev_setattr_cmd {
 		u8      state;
 		char    name[IONIC_IFNAMSIZ];
 		__le64  features;
+		u8      cmd_timeout;
 		u8      rsvd2[60];
 	} __packed;
 };
@@ -1848,6 +1854,7 @@ struct ionic_dev_getattr_cmd {
  * @status:     Status of the command (enum ionic_status_code)
  * @rsvd:       reserved byte(s)
  * @features:   Device features
+ * @cmd_timeout: Command timeout in seconds, 0 for the default
  * @rsvd2:      reserved byte(s)
  * @color:      Color bit
  */
@@ -1856,6 +1863,7 @@ struct ionic_dev_getattr_comp {
 	u8     rsvd[3];
 	union {
 		__le64  features;
+		u8      cmd_timeout;
 		u8      rsvd2[11];
 	} __packed;
 	u8     color;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 267049b768509..60d3f8cae07f2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3495,6 +3495,7 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	err = ionic_identify(ionic);
 	if (err)
 		goto err_out;
+	ionic_update_cmd_timeout(ionic);
 	err = ionic_port_identify(ionic);
 	if (err)
 		goto err_out;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 507281f3fc8bb..1ad5f529e6002 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -439,7 +439,8 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
 	}
 
 	time_start = jiffies;
-	time_limit = time_start + HZ * (ulong)lif->ionic->cmd_timeout;
+	time_limit = time_start +
+		     HZ * (ulong)READ_ONCE(lif->ionic->cmd_timeout);
 	do {
 		remaining = wait_for_completion_timeout(&ctx->work,
 							IONIC_ADMINQ_TIME_SLICE);

-- 
2.43.0

