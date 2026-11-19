Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.69
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795048379;
	b=lUvZpOmqoxm9/gJniomMinv0ZAwTze/p/X24HAnJ9bj/lfvPvyqx2sue6xofD1RaLX4k
	 SGJXKVMAXqBvjCbIQXZpSlKk3wz6rDo1cPnE48gicSt8tyrRBCOkfSnDY7cR0lQDR8Vrc
	 mFmbJeBAqQb9ERBuT46oD5kaDuOg9LY9JTTH4k4lw4UbQ938gawSJQ7s9AQrYVvLYiwTS
	 rWlyQNvGSdP+chhahm81yWC+sucKhOMrQwo6wNAoC/5V8Vc0CeomVIlWzPwy6v3+c1sjB
	 zjaUtzqZC88XScWuQCN3fwO7eCm8Ai1P55FRwPEQgVO34/Omgdsnut4C9xjqCgSiqkw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048379;
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
	bh=GKkaoWriDoWcVPe+ZBg8eZ5UUxDSfn+09cdc8bUh4Bk=;
	b=V1rbp1t4601okyLmn1tGiLC1515kKE3BNzKdJuwnXRPU7Sf1ixHJBZpXRi09VgxBVgDR
	 evhXw2tRnKyYXhFkuH9E5FEq3LeWmPwhbMgC3lVXI/egNi2n8lCnVkh1N1Jj5pqRDJ8pc
	 A3CmX+LwHSp0gBA8WN7r3Yy59x8NMOvHdLDmRHXgIN3B8hEZfN1p6yAAYy7YUfu6C95Qn
	 9AchMsqqVcYsnuEYB3vByHjHPIwmIXFNkY9W0kpk9UI0Z7L35BD+bsfkfPmpZX/pWVgqp
	 EQZooXebYNPN1AU6G6t0dinYJiNju+eSx34gads4iI8/CMy0SBsg27W6tZ+B1dRLBkQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=I9H3gsj8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.69
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011069.outbound.protection.outlook.com [40.93.194.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD7260A263D;
	Thu, 19 Nov 2026 00:32:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AD7260A263D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=I9H3gsj8
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EYCzz/nWtjmU1odF/c6PZxiyuD4kPXMJv7cZ6gvP/LHyW2vyEFmqdKfMBFCHWYsBvBPRsnG9UzdDvSOyvFQYMZ54Znf2y5239dkgxc5lBRFDLm9RitmfwFX6o1hAkIefgd5U05W3YTc9kdLamDL7p8VSqb2K+ky8kVAoP4dVZmA2SDYcIACTHCHzojyOmY7T7d/WuzH20tWQUyvBpme8DFgMP4eDy0laLA+tBGGzppoJtC+N+HnkkJAAQX/ZN8J6xeEemiJl5d8rydvua90M2kb1VOzcWTBIHfqF2WTmjenI/6jAhq5N4uvYYT0kVIhKP6ffPNaOlp2fcaJFlSirsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GKkaoWriDoWcVPe+ZBg8eZ5UUxDSfn+09cdc8bUh4Bk=;
 b=TrzfRKCRvsVmjrXkev2QcRzlXZnRhm9V6Cyeke9fSLIhzIOiN3AmHIg5CpAXV7pPW52HCapnYYwmLb0UjM5SUNM8E0tZIPUN4I/BZSXLqWtQ+H3DRdwX6cYd06G4KTJN34N9vciBUmmTSCuqcJtpR0h6UN/Hnn6MmVB9oxP8Xg+9eC8yyyVVSZZUtWX1dhN68XUnEarrV/78YtGpQI+MaUifDtuDbc5w0SZyfKAlYpk0SE/fYqSa37XGcmIlabL99GBX+Iw9f1aCqAV2x6GCUcB8Fb7SKMwPFZi8zrFcIZN/MT6bhA7/GbT7ZSMIajZDw8NfyErTBHKT1tJGPZtCXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKkaoWriDoWcVPe+ZBg8eZ5UUxDSfn+09cdc8bUh4Bk=;
 b=I9H3gsj8xTZ91tSrHMDOOpBQT4Htnw53TDRlLPjo8MU9MzczVdmj8mJ73MDd58351TBTY+/K9xTESryH0dmyrVTiAYw+YHBXPFH7Ikr68C8Fnt/ugBdTJcqO6n4NLCwuEEWOLArWcpH/zTgYOwerepUcXdv2ijNCQbt3UojwyQY=
Received: from BLAPR03CA0131.namprd03.prod.outlook.com (2603:10b6:208:32e::16)
 by IA0PPF6E99B1BC1.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bd1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Thu, 19 Nov
 2026 00:32:47 +0000
Received: from BL6PEPF0006C3E0.namprd02.prod.outlook.com
 (2603:10b6:208:32e:cafe::45) by BLAPR03CA0131.outlook.office365.com
 (2603:10b6:208:32e::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Thu,
 19 Nov 2026 00:32:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3E0.mail.protection.outlook.com (10.167.249.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 19 Nov 2026 00:32:47 +0000
Received: from [10.11.96.223] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 18:32:45 -0600
From: "Nikhil P. Rao" <nikhil.rao@amd.com>
Date: Thu, 19 Nov 2026 00:32:31 +0000
Subject: [PATCH net-next v3 1/3] ionic: make the command timeout per device
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
Message-ID: <20261119-b4-ionic-cmd-timeout-v3-1-2cdb8fca15fd@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3E0:EE_|IA0PPF6E99B1BC1:EE_
X-MS-Office365-Filtering-Correlation-Id: 0424e7bc-5571-4cbd-845c-08df45d4a2f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|82310400026|1800799024|23010399003|261102130727099003|10067099003|261022075727099003|261028144727099003|261021135927099003|261102123227099003|261022113327099003|261022105027099003|261026130827099003|261021130227099003|261021123027099003|261021133027099003|261022115727099003|261021121427099003|261026135527099003|260925021311599003|56012099006|260925021911599003|260925022911599003|261026121527099003|261009223027099003|3023799007|261026140227099003|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	r6Xs9RfbopdIZMuJMhJCVyItrgiozkSW1/HSlPDy8mzBYc7VSF5efFELVFOkYzM3oaHiofoR13f53l+aMOXk6H9P4F+W0exQRydt6qQG4gw4ChpSspUq1x7y1H1SKLpUc3ioXBcrdIVbMc4caVIE2n8rsN0oAXgddLB217xKri7cA3/vwkN+XsKUMZyt6BS56UXYKjk/yenIVdYWvxte41kroCwb2lk+IUl6pB+oMduWE4rcQLRG6oSO1bZhdk56H9/3ypaey6EGQ8zp+fg3OzRZyT2zB4EtjsoSvrMcCZSfN9CcoktPtgYP36NC/svgswHXyN6N5RHyIhlcPYqkAbN0+feIS5Oir6UD8QXrVYM93f9hU981DIiUB0dkzQyP154949OVk6rvq/QNhOiMrlQEIMLo6QInL5SNae7h2tSlsIA9gZPG/m48QlGEQQudbO7hBcSVXBxFH197dRNqoPvuLHWT1Pt9uoGoXonZOedkqIJ3JVbXjqefFdlFYb22IXPLEOCB7o2J5gVSlvz8Jph5GzyY9IqlqIFmZtsrIH12enXxnRISZbpf9PWfzrC5ODBSkNKP6ehkblvXpXti2dVqI/SIgARRd6rKvsCzcZ8LF7Ar+3vHYU6xg8TynC2trrq0XA98zO9hqeJ+7UXP4I6r/x3DZySktAgMKXu8K/iNEq0xOveS3tHqqSamrI4Oq1nVsznmjEgPoZAy4BsiMpej5XxbrCQrV25QV7m0FVbKHqJsEaNMKphJ3EYyW9kZ
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(82310400026)(1800799024)(23010399003)(261102130727099003)(10067099003)(261022075727099003)(261028144727099003)(261021135927099003)(261102123227099003)(261022113327099003)(261022105027099003)(261026130827099003)(261021130227099003)(261021123027099003)(261021133027099003)(261022115727099003)(261021121427099003)(261026135527099003)(260925021311599003)(56012099006)(260925021911599003)(260925022911599003)(261026121527099003)(261009223027099003)(3023799007)(261026140227099003)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XDdHUpR+IhYHFZuPgoKU3coqYiXwehyV0iT8ESvMuZtZALWmWf0mo2zGyxHw5roarFJ9g2g4mhlBARWDtLPJBq5HUN9qfOMTcFaA0aiWXgsDNcMjOMZuLmtmSGkHAwXz04jWKDc7+BDHRTMqLrdai2oqZaZWrrJP2FHYheuDQj/P71Dfusg9CuPV3Y4LRlpv4TN1c1/h9VVVR5za3gb2NOr2B6XOjK5Eu2XOHT+4SwUHE+cF3tADyX2urMJUT2p1YnCWBrZN5jSsXKtB/VvkrnfZ/xPBg5Bd8wDRFR2fNCnCOsGOzyHJl3fgWU8PNYLSzxjnIHHmKhDUnJLdCSMRLLbSGXCfc6+/U2KiGSQm7h2BThruSKIIQ6N/RU6CEnmi3BaFyc92+YQhiStjWhV7X91ny3Cd8KmP/gm9MP045RaweEjuZguiZTxzjy+ECXkh
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 00:32:47.8501
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0424e7bc-5571-4cbd-845c-08df45d4a2f0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3E0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF6E99B1BC1

From: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>

Device and admin queue command waits, and the firmware heartbeat check
interval, use the compile-time DEVCMD_TIMEOUT. Make the timeout a
per-device value, so that it can be made configurable through a devlink
parameter, and export it to the RDMA driver through
ionic_cmd_timeout().

No functional change.

Signed-off-by: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
---
 drivers/net/ethernet/pensando/ionic/ionic.h         |  3 ++-
 drivers/net/ethernet/pensando/ionic/ionic_api.h     |  8 ++++++++
 drivers/net/ethernet/pensando/ionic/ionic_aux.c     |  8 +++++++-
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c |  1 +
 drivers/net/ethernet/pensando/ionic/ionic_dev.c     | 11 ++++++-----
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 12 ++++++------
 drivers/net/ethernet/pensando/ionic/ionic_fw.c      |  8 ++++----
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     | 10 +++++-----
 drivers/net/ethernet/pensando/ionic/ionic_main.c    | 16 ++++++++--------
 9 files changed, 47 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 814d70b8623bd..39999bdbca55e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -18,7 +18,7 @@ struct ionic_lif;
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
 
-#define DEVCMD_TIMEOUT			5
+#define IONIC_CMD_TIMEOUT_DEF		5
 #define IONIC_ADMINQ_TIME_SLICE		msecs_to_jiffies(100)
 
 #define IONIC_PHC_UPDATE_NS	10000000000	    /* 10s in nanoseconds */
@@ -66,6 +66,7 @@ struct ionic {
 	int watchdog_period;
 	void *hwmon_caps_buf;
 	dma_addr_t hwmon_caps_pa;
+	u8 cmd_timeout;
 };
 
 int ionic_adminq_post(struct ionic_lif *lif, struct ionic_admin_ctx *ctx);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_api.h b/drivers/net/ethernet/pensando/ionic/ionic_api.h
index bd88666836b80..28e6b5e2a2cc0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_api.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_api.h
@@ -86,6 +86,14 @@ int ionic_error_to_errno(enum ionic_status_code code);
  */
 void ionic_request_rdma_reset(struct ionic_lif *lif);
 
+/**
+ * ionic_cmd_timeout - Get the device and admin queue command timeout
+ * @lif:        Logical interface
+ *
+ * Return: the command timeout in seconds
+ */
+u8 ionic_cmd_timeout(struct ionic_lif *lif);
+
 /**
  * ionic_intr_alloc - Reserve a device interrupt
  * @lif:        Logical interface
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_aux.c b/drivers/net/ethernet/pensando/ionic/ionic_aux.c
index 521f3bd9aee15..70f193ebb7ea2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_aux.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_aux.c
@@ -239,7 +239,7 @@ void ionic_request_rdma_reset(struct ionic_lif *lif)
 	mutex_lock(&ionic->dev_cmd_lock);
 
 	ionic_dev_cmd_go(&ionic->idev, &cmd);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 
 	mutex_unlock(&ionic->dev_cmd_lock);
 
@@ -247,3 +247,9 @@ void ionic_request_rdma_reset(struct ionic_lif *lif)
 		pr_warn("%s request_reset: error %d\n", __func__, err);
 }
 EXPORT_SYMBOL_NS(ionic_request_rdma_reset, "NET_IONIC");
+
+u8 ionic_cmd_timeout(struct ionic_lif *lif)
+{
+	return lif->ionic->cmd_timeout;
+}
+EXPORT_SYMBOL_NS(ionic_cmd_timeout, "NET_IONIC");
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 9bedcb7224abc..abadfa11ebdbd 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -239,6 +239,7 @@ static int ionic_setup_one(struct ionic *ionic)
 	struct device *dev = ionic->dev;
 	int err;
 
+	ionic->cmd_timeout = IONIC_CMD_TIMEOUT_DEF;
 	ionic_debugfs_add_dev(ionic);
 
 	/* Setup PCI device */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 648d9d24be856..f14fff4a74278 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -212,7 +212,7 @@ static void ionic_map_disc_cmb(struct ionic *ionic)
 	mutex_lock(&ionic->dev_cmd_lock);
 
 	ionic_dev_cmd_discover_cmb(idev);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	if (!err) {
 		sz = min(sizeof(ident->cmb_layout),
 			 sizeof(idev->dev_cmd_regs->data));
@@ -590,10 +590,11 @@ int ionic_heartbeat_check(struct ionic *ionic)
 		return -ENXIO;
 
 	/* Because of some variability in the actual FW heartbeat, we
-	 * wait longer than the DEVCMD_TIMEOUT before checking again.
+	 * wait longer than the command timeout before checking again.
 	 */
 	last_check_time = idev->last_hb_time;
-	if (time_before(check_time, last_check_time + DEVCMD_TIMEOUT * 2 * HZ))
+	if (time_before(check_time,
+			last_check_time + ionic->cmd_timeout * 2 * HZ))
 		return 0;
 
 	fw_hb = ioread32(&idev->dev_info_regs->fw_heartbeat);
@@ -795,7 +796,7 @@ int ionic_set_vf_config(struct ionic *ionic, int vf,
 
 	mutex_lock(&ionic->dev_cmd_lock);
 	ionic_dev_cmd_go(&ionic->idev, &cmd);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	mutex_unlock(&ionic->dev_cmd_lock);
 
 	return err;
@@ -812,7 +813,7 @@ void ionic_vf_start(struct ionic *ionic)
 		return;
 
 	ionic_dev_cmd_go(&ionic->idev, &cmd);
-	ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 }
 
 /* LIF commands */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 119ac720c0787..29b9a8502b8ed 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -351,7 +351,7 @@ static int ionic_set_link_ksettings(struct net_device *netdev,
 	if (ks->base.autoneg != idev->port_info->config.an_enable) {
 		mutex_lock(&ionic->dev_cmd_lock);
 		ionic_dev_cmd_port_autoneg(idev, ks->base.autoneg);
-		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+		err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 		mutex_unlock(&ionic->dev_cmd_lock);
 		if (err)
 			return err;
@@ -361,7 +361,7 @@ static int ionic_set_link_ksettings(struct net_device *netdev,
 	if (ks->base.speed != le32_to_cpu(idev->port_info->config.speed)) {
 		mutex_lock(&ionic->dev_cmd_lock);
 		ionic_dev_cmd_port_speed(idev, ks->base.speed);
-		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+		err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 		mutex_unlock(&ionic->dev_cmd_lock);
 		if (err)
 			return err;
@@ -411,7 +411,7 @@ static int ionic_set_pauseparam(struct net_device *netdev,
 
 	mutex_lock(&ionic->dev_cmd_lock);
 	ionic_dev_cmd_port_pause(&lif->ionic->idev, requested_pause);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	mutex_unlock(&ionic->dev_cmd_lock);
 	if (err)
 		return err;
@@ -479,7 +479,7 @@ static int ionic_set_fecparam(struct net_device *netdev,
 	if (fec_type != lif->ionic->idev.port_info->config.fec_type) {
 		mutex_lock(&lif->ionic->dev_cmd_lock);
 		ionic_dev_cmd_port_fec(&lif->ionic->idev, fec_type);
-		ret = ionic_dev_cmd_wait(lif->ionic, DEVCMD_TIMEOUT);
+		ret = ionic_dev_cmd_wait(lif->ionic, lif->ionic->cmd_timeout);
 		mutex_unlock(&lif->ionic->dev_cmd_lock);
 	}
 
@@ -1131,11 +1131,11 @@ static int ionic_nway_reset(struct net_device *netdev)
 	mutex_lock(&ionic->dev_cmd_lock);
 
 	ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_DOWN);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 
 	if (!err) {
 		ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_UP);
-		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+		err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	}
 
 	mutex_unlock(&ionic->dev_cmd_lock);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_fw.c b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
index 3c209c1a23373..ceb9751475088 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_fw.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
@@ -75,7 +75,7 @@ static int ionic_fw_status_long_wait(struct ionic *ionic,
 	do {
 		mutex_lock(&ionic->dev_cmd_lock);
 		ionic_dev_cmd_go(&ionic->idev, &cmd);
-		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+		err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 		mutex_unlock(&ionic->dev_cmd_lock);
 
 		msleep(20);
@@ -135,7 +135,7 @@ int ionic_firmware_update(struct ionic_lif *lif, const struct firmware *fw,
 		ionic_dev_cmd_firmware_download(idev,
 						offsetof(union ionic_dev_cmd_regs, data),
 						offset, copy_sz);
-		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+		err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 		mutex_unlock(&ionic->dev_cmd_lock);
 		if (err) {
 			netdev_err(netdev,
@@ -155,7 +155,7 @@ int ionic_firmware_update(struct ionic_lif *lif, const struct firmware *fw,
 
 	mutex_lock(&ionic->dev_cmd_lock);
 	ionic_dev_cmd_firmware_install(idev);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	ionic_dev_cmd_comp(idev, (union ionic_dev_cmd_comp *)&comp);
 	fw_slot = comp.fw_control.slot;
 	mutex_unlock(&ionic->dev_cmd_lock);
@@ -176,7 +176,7 @@ int ionic_firmware_update(struct ionic_lif *lif, const struct firmware *fw,
 
 	mutex_lock(&ionic->dev_cmd_lock);
 	ionic_dev_cmd_firmware_activate(idev, fw_slot);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	mutex_unlock(&ionic->dev_cmd_lock);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to start firmware select");
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 22d1e4b6d61be..267049b768509 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3382,7 +3382,7 @@ static void ionic_lif_reset(struct ionic_lif *lif)
 
 	mutex_lock(&lif->ionic->dev_cmd_lock);
 	ionic_dev_cmd_lif_reset(idev, lif->index);
-	ionic_dev_cmd_wait(lif->ionic, DEVCMD_TIMEOUT);
+	ionic_dev_cmd_wait(lif->ionic, lif->ionic->cmd_timeout);
 	mutex_unlock(&lif->ionic->dev_cmd_lock);
 }
 
@@ -3589,7 +3589,7 @@ static int ionic_lif_adminq_init(struct ionic_lif *lif)
 
 	mutex_lock(&lif->ionic->dev_cmd_lock);
 	ionic_dev_cmd_adminq_init(idev, qcq, lif->index, qcq->intr.index);
-	err = ionic_dev_cmd_wait(lif->ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(lif->ionic, lif->ionic->cmd_timeout);
 	ionic_dev_cmd_comp(idev, (union ionic_dev_cmd_comp *)&comp);
 	mutex_unlock(&lif->ionic->dev_cmd_lock);
 	if (err) {
@@ -3749,7 +3749,7 @@ int ionic_lif_init(struct ionic_lif *lif)
 
 	mutex_lock(&lif->ionic->dev_cmd_lock);
 	ionic_dev_cmd_lif_init(idev, lif->index, lif->info_pa);
-	err = ionic_dev_cmd_wait(lif->ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(lif->ionic, lif->ionic->cmd_timeout);
 	ionic_dev_cmd_comp(idev, (union ionic_dev_cmd_comp *)&comp);
 	mutex_unlock(&lif->ionic->dev_cmd_lock);
 	if (err)
@@ -3937,7 +3937,7 @@ static void ionic_lif_queue_identify(struct ionic_lif *lif)
 		mutex_lock(&ionic->dev_cmd_lock);
 		ionic_dev_cmd_queue_identify(idev, lif->lif_type, qtype,
 					     ionic_qtype_versions[qtype]);
-		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+		err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 		if (!err) {
 			qti->version   = readb(&q_ident->version);
 			qti->supported = readb(&q_ident->supported);
@@ -4003,7 +4003,7 @@ int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 
 	mutex_lock(&ionic->dev_cmd_lock);
 	ionic_dev_cmd_lif_identify(idev, lif_type, IONIC_IDENTITY_VERSION_1);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	memcpy_fromio(lid, &idev->dev_cmd_regs->data, sz);
 	mutex_unlock(&ionic->dev_cmd_lock);
 	if (err)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 9955ab77d86d0..507281f3fc8bb 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -439,7 +439,7 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
 	}
 
 	time_start = jiffies;
-	time_limit = time_start + HZ * (ulong)DEVCMD_TIMEOUT;
+	time_limit = time_start + HZ * (ulong)lif->ionic->cmd_timeout;
 	do {
 		remaining = wait_for_completion_timeout(&ctx->work,
 							IONIC_ADMINQ_TIME_SLICE);
@@ -635,7 +635,7 @@ int ionic_identify(struct ionic *ionic)
 	memcpy_toio(&idev->dev_cmd_regs->data, &ident->drv, sz);
 
 	ionic_dev_cmd_identify(idev, IONIC_DEV_IDENTITY_VERSION_2);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	if (!err) {
 		sz = min(sizeof(ident->dev), sizeof(idev->dev_cmd_regs->data));
 		memcpy_fromio(&ident->dev, &idev->dev_cmd_regs->data, sz);
@@ -679,7 +679,7 @@ int ionic_init(struct ionic *ionic)
 
 	mutex_lock(&ionic->dev_cmd_lock);
 	ionic_dev_cmd_init(idev);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	mutex_unlock(&ionic->dev_cmd_lock);
 
 	return err;
@@ -695,7 +695,7 @@ int ionic_reset(struct ionic *ionic)
 
 	mutex_lock(&ionic->dev_cmd_lock);
 	ionic_dev_cmd_reset(idev);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	mutex_unlock(&ionic->dev_cmd_lock);
 
 	return err;
@@ -711,7 +711,7 @@ int ionic_port_identify(struct ionic *ionic)
 	mutex_lock(&ionic->dev_cmd_lock);
 
 	ionic_dev_cmd_port_identify(idev);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	if (!err) {
 		sz = min(sizeof(ident->port), sizeof(idev->dev_cmd_regs->data));
 		memcpy_fromio(&ident->port, &idev->dev_cmd_regs->data, sz);
@@ -756,10 +756,10 @@ int ionic_port_init(struct ionic *ionic)
 
 	memcpy_toio(&idev->dev_cmd_regs->data, &ident->port.config, sz);
 	ionic_dev_cmd_port_init(idev);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 
 	ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_UP);
-	ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 
 	mutex_unlock(&ionic->dev_cmd_lock);
 	if (err) {
@@ -786,7 +786,7 @@ int ionic_port_reset(struct ionic *ionic)
 	if (ionic_is_fw_running(idev)) {
 		mutex_lock(&ionic->dev_cmd_lock);
 		ionic_dev_cmd_port_reset(idev);
-		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+		err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 		mutex_unlock(&ionic->dev_cmd_lock);
 	}
 

-- 
2.43.0

