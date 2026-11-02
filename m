Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658506;
	b=IDgzy+fI0wBWZ+v/JB+sftoumkmNydmRZuh6L7Zjt39YhiZIPCrUvKGYJNhtdYGqgE6X
	 zJ6MmPCP443SZbv4yb6fdLio0dYqfK3hrObJdiIVnEwtfM7dWynRW9CzFkgYEI1WfxYLE
	 QtYcM+N+fKauC0Xc9DObHtJ8+WdHDoIJ4pWFNmrXCIKImG4dKUPlOEJyjWcfaVOw0p2RX
	 l/qL2hBBztETCiiXLj2Yg4uCteFEPhkHR8nyUgqBvqnZJaPcAIS57/kzbHbZlmz3QnVSK
	 h5e5Qmeh3RNsr9kxv9HdZs6X6fdC1CcBAA9zoKVn6i1F348bWdtofdzKv/iJu2eWRCQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658506;
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
	bh=+zakp5Z/Qr9IsTEOrDSXVtXDXDgKT7UyAGJ7W53AggM=;
	b=b7yMulxV055/G0y9sfzi7HqMoyh0c3Po+IvZ/G/9sFgBxvjQwCoCs9SMe32vkOv9q+kY
	 WjqVhZfr5k0AoTmtJ41PKXVLHIpjOztlS4i5gkoopp87YoqbexBxA4BSAL9XNnntbgzq5
	 fPMZnRdiYZ59wFFmwiMQ4U5cHQUpQs6E6kxlKrNZn5a9zibtnjxrkohhfc4sNsv5xAzsD
	 5ZwhRuJ0uVLt83Mx0dqYJgvF6ZdDpTLTNtrW/fc+ybSdWLIhptUUjCuHeTOWq2jcJuthi
	 2JxTCEE4Rs6s07hWyJ+a4iDLu4JdxAf5tCN0XBtzFWafcHkQ+/PhsmWeFvQMzqEHjDQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=s5oXRPvk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.50
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010050.outbound.protection.outlook.com [52.101.193.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367BA606A32D;
	Mon,  2 Nov 2026 22:28:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 367BA606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=s5oXRPvk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OYHQaibHxa7JnB01jtxPqeAKR3G2b9Q+9N5tJMURyxhL/wSgTKSGN4d+42AmcRgfycQdeyVwqGqTJ+buBVBHmbidb2LRO3oA5/vV6D8hYF3WrEKRXDXpT0BK9EL89xKjdk6PcHjTiv9pufMewMD7TKNhdPhJQ3/e5HwnlMi+mxuTApYk9Woyl5/SdWW9WxQwy1Jsk5jIf5Bdxezi/cl1lqvBFKT6jbLqUJpMqxw/A9QX3k4aXjYQ+BZUeIRInIcYbt7UicYgfPPfVgoY/e3ENJDKdbOuW/6pKrx1a9IlQ+Mo3KGmOu5CNkQ5jWcaGW2u+FuKvwCURkPmtV/7uI1+Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+zakp5Z/Qr9IsTEOrDSXVtXDXDgKT7UyAGJ7W53AggM=;
 b=WaEsnSnXHq+ZxsaXAqQCY0MlMT8RAfkctkOcNiLtma58+3zVzo/nM/kuBpfEaHjHB5ILNLHGG0MnQIUrqsN2hYzJdk9mOq89Xmd69ecG2kHgdm0AvhVsTM5JfvyGbjtv1SckCic2aS5oyWeC/DowRk3Q4NL5Oo2ymvd3la0H3p1b3aFzrT1mzrgN+EOBcEjbOhHwproZNELxbeAfMW3U5loxtjkiKp9tobcE3c3fh58caJERUOniAfSignvGQNQgCwF9E1yZjLvwAnSaYdrS+JcaHsxr4NhjqfwupfU0Xf80PTY3YU5DDwKb99RxFhk+FLX9V5Z7D8XRHZJMpMWK9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zakp5Z/Qr9IsTEOrDSXVtXDXDgKT7UyAGJ7W53AggM=;
 b=s5oXRPvkbl3ZMt9ZCrRMOQAGRVLdM319U2fRwSRC+4gmC9i/Ny1u/6Dt9X1+S1g8Isqh0YMfoeizUw6LLSgjxOpzNaThFtvqcCYu6XrcW4AVWqZIP2clJQEchcgNIUgSJaEOe+iKcQNFz8YJfAEiinca2nj0CDTD8AV7o1ZhmRc=
Received: from MW4P222CA0026.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::31)
 by DS0PR12MB8785.namprd12.prod.outlook.com (2603:10b6:8:14c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.9; Mon, 2 Nov 2026
 22:28:19 +0000
Received: from SJ1PEPF000037B6.namprd05.prod.outlook.com
 (2603:10b6:303:114:cafe::58) by MW4P222CA0026.outlook.office365.com
 (2603:10b6:303:114::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.12 via Frontend Transport; Mon, 2
 Nov 2026 22:28:18 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000037B6.mail.protection.outlook.com (10.167.244.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Mon, 2 Nov 2026 22:28:18 +0000
Received: from [192.168.0.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 2 Nov
 2026 16:28:16 -0600
From: "Nikhil P. Rao" <nikhil.rao@amd.com>
Date: Mon, 2 Nov 2026 22:27:39 +0000
Subject: [PATCH net-next 1/3] ionic: make the command timeout per device
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
Message-ID: <20261102-b4-ionic-cmd-timeout-v1-1-2f75c2d0a0c7@amd.com>
References: <20261102-b4-ionic-cmd-timeout-v1-0-2f75c2d0a0c7@amd.com>
In-Reply-To: <20261102-b4-ionic-cmd-timeout-v1-0-2f75c2d0a0c7@amd.com>
To: Brett Creeley <brett.creeley@amd.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Abhijit Gangurde <abhijit.gangurde@amd.com>, Allen Hubbe
	<allen.hubbe@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
	<leon@kernel.org>, Jiri Pirko <jiri@resnulli.us>, Simon Horman
	<horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-doc@vger.kernel.org>, Arun Kumar Prakash
	<ArunKumar.Prakash@amd.com>, "Nikhil P. Rao" <nikhil.rao@amd.com>
X-Mailer: b4 0.15.2
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037B6:EE_|DS0PR12MB8785:EE_
X-MS-Office365-Filtering-Correlation-Id: 57227f68-dd84-4611-8465-08df3930983d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|36860700016|82310400026|921020|261102123227099003|261021123027099003|261021121427099003|261102130727099003|260925021911599003|260925022911599003|260925021311599003|261021133027099003|261022105027099003|11063799006|56012099006|261028144727099003|261022113327099003|261009223027099003|261026135527099003|261021135927099003|261022115727099003|261021130227099003|261022075727099003|261026140227099003|261026130827099003|261026121527099003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Hp+hxqKJiPSKTkcoJ63QkoTwEcBcIAUNMm8U8uvqKBSeHhyCdFJiZk6cI4aUYJBW9pSbiH6IQEtxSOFkaEyjopBUANqggsEUk5IGZEj9Y/sQ9zzRRbe+lD8ri8Xr7QGTpvMnE87uqXSk01H/O0G9wImKhAiht18/+8j14b/CnUwtSvqPxTJZt5WyzT2/35YYtr0+sSZlwIED4VGItG4zAHMA0DngAuMC01gkMmjHH+cpofKAfiho2atjqsPsPwiy0Yi8uZHyubbj3kbAgm3sRbnChunS6CBU8p/fsLhCWfMXJ1K+eiuufg9Ov07qclAsSRQxEod+MKXBBvkDo32IumKbEhcFnxYpiif492Ho+3xgw23caXhHe1IDlVQjefS/cDpEWdTqQS/OLK2K8IK7aX+IvX/cq17cf/yQgInLjxsddycFzp213rKciVqjoo1x4IzzaDEOppfAtckv4qycDZ6dBAeAhZ9NFfRL5CeEGKtGDfMto3830aGovc72lI2CbQa+W0osSAP9IwZpI0GwfpLe/91jgIBQI9wQ5ZGimrU5kWPkvuOFTA77abjHEIVpwyErs8iAMevPxPuRUfmIDqdRPwRr8VY3ixkrGHOTpu2znAxXVTMqhtqWQr95vbjOP9PXG0Vdiv2efCHLRs878V4wibIFnWFCNFJFQ055AxTnj7fiiQxB/mSXoJ6k+SN68ZJyIreSG3thszbDPAPWNH1VkPV2dz1fLa8oU29h41QBPFSzbRnl1rI0TbzbI7XE
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(36860700016)(82310400026)(921020)(261102123227099003)(261021123027099003)(261021121427099003)(261102130727099003)(260925021911599003)(260925022911599003)(260925021311599003)(261021133027099003)(261022105027099003)(11063799006)(56012099006)(261028144727099003)(261022113327099003)(261009223027099003)(261026135527099003)(261021135927099003)(261022115727099003)(261021130227099003)(261022075727099003)(261026140227099003)(261026130827099003)(261026121527099003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7aajIDCrHRMlbF7QGIcj2Sx3pX+NRbnlGDQ2d1oaCxwi0QjAC+gpKBY+0c8CxkevkiV8hnjqnqAAUGNlrRu/iGZ55tBlrCzvg7T3BjVMrIw7hObyikLr4mK0JgvKVT19dBJzjtO7/s8jX9WPooPo29QAMfFJ3D4jKXpNEE1mMMKzOtInsxKhRnUIIFSlg3OG7lm94ntHrcJ0DvkDS+EeVdiAKeTXLb8m5G6VilERURtyEUTtMcqLcr1VIQSYhzgxkTh5wCE3KlVdhY3jcU9kgDriTlYKSZDJKibBWBJyTOODfaqRN290QkoDA9jDVvgY6NL4pIaNv1VZH7BdnIRYQdxIZ57f/O7Cold+fHF5yFPzoGX5q8CnGu/eG5KfneuVg52oJYzRwe4sUxKF5dcTOU+7bnOu4gLebdc1koOFvRYRbgH1ewd2oQTsMzxz2HiC
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:28:18.4550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57227f68-dd84-4611-8465-08df3930983d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037B6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8785

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
index 85198e6a806e6..5c54a0ea10a55 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -18,7 +18,7 @@ struct ionic_lif;
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_PF	0x1002
 #define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
 
-#define DEVCMD_TIMEOUT			5
+#define IONIC_CMD_TIMEOUT_DEF		5
 #define IONIC_ADMINQ_TIME_SLICE		msecs_to_jiffies(100)
 
 #define IONIC_PHC_UPDATE_NS	10000000000	    /* 10s in nanoseconds */
@@ -63,6 +63,7 @@ struct ionic {
 	int num_vfs;
 	struct timer_list watchdog_timer;
 	int watchdog_period;
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
index 4f193d0ee87ad..3b7cecc7f6dde 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_aux.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_aux.c
@@ -92,7 +92,7 @@ void ionic_request_rdma_reset(struct ionic_lif *lif)
 	mutex_lock(&ionic->dev_cmd_lock);
 
 	ionic_dev_cmd_go(&ionic->idev, &cmd);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 
 	mutex_unlock(&ionic->dev_cmd_lock);
 
@@ -100,3 +100,9 @@ void ionic_request_rdma_reset(struct ionic_lif *lif)
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
index ddc2f9770df45..74ba923a3f1b6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -237,6 +237,7 @@ static int ionic_setup_one(struct ionic *ionic)
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
index 7f0da2b0defdf..b0868ab139dd5 100644
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
index 38b47b959a114..16df13f23c90d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -435,7 +435,7 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
 	}
 
 	time_start = jiffies;
-	time_limit = time_start + HZ * (ulong)DEVCMD_TIMEOUT;
+	time_limit = time_start + HZ * (ulong)lif->ionic->cmd_timeout;
 	do {
 		remaining = wait_for_completion_timeout(&ctx->work,
 							IONIC_ADMINQ_TIME_SLICE);
@@ -631,7 +631,7 @@ int ionic_identify(struct ionic *ionic)
 	memcpy_toio(&idev->dev_cmd_regs->data, &ident->drv, sz);
 
 	ionic_dev_cmd_identify(idev, IONIC_DEV_IDENTITY_VERSION_2);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	if (!err) {
 		sz = min(sizeof(ident->dev), sizeof(idev->dev_cmd_regs->data));
 		memcpy_fromio(&ident->dev, &idev->dev_cmd_regs->data, sz);
@@ -675,7 +675,7 @@ int ionic_init(struct ionic *ionic)
 
 	mutex_lock(&ionic->dev_cmd_lock);
 	ionic_dev_cmd_init(idev);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	mutex_unlock(&ionic->dev_cmd_lock);
 
 	return err;
@@ -691,7 +691,7 @@ int ionic_reset(struct ionic *ionic)
 
 	mutex_lock(&ionic->dev_cmd_lock);
 	ionic_dev_cmd_reset(idev);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	mutex_unlock(&ionic->dev_cmd_lock);
 
 	return err;
@@ -707,7 +707,7 @@ int ionic_port_identify(struct ionic *ionic)
 	mutex_lock(&ionic->dev_cmd_lock);
 
 	ionic_dev_cmd_port_identify(idev);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 	if (!err) {
 		sz = min(sizeof(ident->port), sizeof(idev->dev_cmd_regs->data));
 		memcpy_fromio(&ident->port, &idev->dev_cmd_regs->data, sz);
@@ -752,10 +752,10 @@ int ionic_port_init(struct ionic *ionic)
 
 	memcpy_toio(&idev->dev_cmd_regs->data, &ident->port.config, sz);
 	ionic_dev_cmd_port_init(idev);
-	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 
 	ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_UP);
-	ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+	ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 
 	mutex_unlock(&ionic->dev_cmd_lock);
 	if (err) {
@@ -782,7 +782,7 @@ int ionic_port_reset(struct ionic *ionic)
 	if (ionic_is_fw_running(idev)) {
 		mutex_lock(&ionic->dev_cmd_lock);
 		ionic_dev_cmd_port_reset(idev);
-		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
+		err = ionic_dev_cmd_wait(ionic, ionic->cmd_timeout);
 		mutex_unlock(&ionic->dev_cmd_lock);
 	}
 

-- 
2.43.0

