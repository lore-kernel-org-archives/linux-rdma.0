Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.3
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793918633;
	b=2CPdlV3Lq3OvoqvYazAMTbyfYQN+hVCnT0Dq5VSFeSctSrvoxikNM3mFENmuSV3OxCSo
	 KKjwiGeIa47McRyP5RuLdqUMDKF5YQix9uwhlUqdZMU/rWzVDhMYdv39YmzTh6XMA0dup
	 Xjr/8YZQGh2gPJpp9o4JuXDwcLksLjlA2X3ysAnvUyxU4rofAzwCQxKg5+XyBSeqqJD9G
	 v3Md9u4Vu6SYE+iNTgduGeWLCPAfzAqh+MsqywQlLIvBKpsr8QlMTEmWzz4+0pU20MdoZ
	 aShD7+sCRs8KPDgvNiIUqGdgLpmT8JNVPAYFeyEFKAdOG4DkeCvvoCAQtjX6CJ/niqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918633;
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
	b=pOLvhCypBabgCDU5CBsCb8ZOg9IRkCWN4gTZQHI3jWm8sfftRF1irnhtIE1DvowddqeP
	 uQ72GNVCnHcCLfRI3nsiewlp98lA0S7fkX86VBbduNtkLf3pD2V5Ze9paJ2ApZY6GXWjb
	 P4xEizF69VQHNEu0nFdz0qkZtltMuPsCJ86z4aVwDoDImsbIxRK9Xf+01G2ypcTSXvb+R
	 0Q4XWE6G6x0U3og861eonzdLIEewTXKe5JUbZ0b6zXdEved5foU4w8fy7rZPHubVO7RQ0
	 bEEEPwp3nqmq2LZs29Oc32MMekD3WtTVFkteY2CX+oAag8rFScKm5kZrVjRzXdmfM4g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=zLHJVIhV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.3
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010003.outbound.protection.outlook.com [52.101.193.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E62606A331;
	Thu,  5 Nov 2026 22:43:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29E62606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=zLHJVIhV
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VKouLmIip9HO57o0Kwz0uoNwn8Dt9dT7Hyndq0o/EgaMOOR7sOZ0MAEbSgaAL0uKemJzt6nUzIfTb1o/hmLwWswYIUPu2guJdMKksl/+ZnergU8JMrIbE2esUA1GKGJkPksGGcTzRwgF5r87Ddi9uYdrfZwToFCl0flQT7fG1mUvXl+XJiimd3KD4ilLmpqJRSWKwc4NQ/BP5XoTQNP04ThTfg/0LrqObsseBkw17hYGVauhiVXb73P3n0J1AuN8wjJ2twZyksgQdgKEoinWyYU1+CBL59kGfdmCZFSkh7cUUcf8EAGbs7Iiz8GlffeYeEkV6VHIuuxryyOtqxn7AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+zakp5Z/Qr9IsTEOrDSXVtXDXDgKT7UyAGJ7W53AggM=;
 b=LJ4yAhWR0OYBLtMe8RldRsRFCXPS1Za8Uui7j/HmNfRpKuVJkBTOij93GqXbLO71TTf10M7OfX6mtcJOvW2rRMrbW1YNdEPf5qvGbTdYJ/yG7Z96N7s9nmCafd9BUnaaWmX7tDLTDo8rqpudZit3RzHLOM581IIehvPD4Xc8yowAu3HgliGYD7YaOD6ufycXBPUW0I2Jwd5jUWrsjzQ7kid/P01JseINFg5i8IWkIuKbVpmG1N4Jk6Hi7GVtQ00afv8NeMFTB/V39spEKdjS3lo369XuGSSpFQynckSl/jGYjBepU4KxRvy5JGyH5UWtT26DIpQEkVpKKxLs/1bvlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zakp5Z/Qr9IsTEOrDSXVtXDXDgKT7UyAGJ7W53AggM=;
 b=zLHJVIhVPZUVUDjBu1P5WGr5ePtj4ETRQEUclYnmhX75LqIKhfDVYnlnyuAmNBiCUTilrauBZy+mEMYDNnC8t3+S8AdRWjRIPrZEOkCvM0IjBTMos4hza1uLGlkOJW2BybdZv8g+CMm07ySD27SkS37yzWsKiU8q65ey1p3QrDs=
Received: from CH0PR13CA0046.namprd13.prod.outlook.com (2603:10b6:610:b2::21)
 by CY8PR12MB7291.namprd12.prod.outlook.com (2603:10b6:930:54::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 22:43:47 +0000
Received: from CH01EPF000BE94F.namprd02.prod.outlook.com
 (2603:10b6:610:b2:cafe::12) by CH0PR13CA0046.outlook.office365.com
 (2603:10b6:610:b2::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4 via Frontend Transport; Thu, 5
 Nov 2026 22:43:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH01EPF000BE94F.mail.protection.outlook.com (10.167.244.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 22:43:46 +0000
Received: from [192.168.0.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 5 Nov
 2026 16:43:45 -0600
From: "Nikhil P. Rao" <nikhil.rao@amd.com>
Date: Thu, 5 Nov 2026 22:43:11 +0000
Subject: [PATCH net-next v2 1/3] ionic: make the command timeout per device
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
Message-ID: <20261105-b4-ionic-cmd-timeout-v2-1-35a9a2aa48b1@amd.com>
References: <20261105-b4-ionic-cmd-timeout-v2-0-35a9a2aa48b1@amd.com>
In-Reply-To: <20261105-b4-ionic-cmd-timeout-v2-0-35a9a2aa48b1@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94F:EE_|CY8PR12MB7291:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c2afc06-b767-4f12-936c-08df3b8e40e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|7416014|1800799024|18002099003|22082099003|10067099003|3023799007|921020|261026135527099003|11063799006|261026140227099003|261026130827099003|261102123227099003|261028144727099003|261022115727099003|261022075727099003|261021130227099003|261022105027099003|261022113327099003|261021135927099003|261021121427099003|56012099006|261009223027099003|261021133027099003|261102130727099003|261026121527099003|261021123027099003|260925021311599003|260925021911599003|260925022911599003;
X-Microsoft-Antispam-Message-Info:
	qREQfqYjeeN+YPhlx6qOxPA2yQkdqcJ228M87rzdGNwS+ROxQXnHNc079V6dEWTt3uN8dWFJY01d0SiFpmLRhKPND3Df7OY4UnHOPac9HKbMkEArDdbT2m1VAIkqihDDa6RfuTnqgHdadPyfclWor5M1065NYpKuk/CGdVhNrRY2aTjG5tBu5dIR1AP7NgGVn2X4op/R639+ak24d/h8pn++flGHjGKSd3uNPLVoj3X3n4kI0Ycr9J0Lnvqdue4rBNcE1WfT3v/ST9sx9K4PpjpkS6o9QXSTT7gAyBzWt3GBsGzEk7fnkx8/T9zkrfLl19lKO/BXLMBpsKoAOUi7zvsc2pjLUNKGtVqUsafPu2xEuhHvsgbnMAOgIoJ8ahhpc4r8e+cQCCGzAxxZNAxd+DWT8QugMrcwRcWkOvLmVeqlrRG69OPDi10+dpV5paNCdJI2aE2QcQdS3S4ANgGg5+tach3Q0QArcz26k8R7lslTBGVMXcow4kPhafwhMc525sCj2i3p1VtoOlOMQt9efBenMzhcNJOh5MX4ok5KP6W/4cLwQsEngSLp64fMRIVqlXmJ7HMVFGtvnrmjTgpYU/HOCXOZEnhKK3a9ivkK5O6pkXXatUHE6oML7S3zKeqzd0TRpywMesFvVlLsiG7BDgmiYHOqYHCs3DG83kITmSx2gHX1TtpRGByXs6UM0qxiUAqV/8ouIlsVG7j3vc/Qh13GIuVL+3X2pD3f7ViAcR/eRdHnRA6DKWGWLGoJtwME
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(10067099003)(3023799007)(921020)(261026135527099003)(11063799006)(261026140227099003)(261026130827099003)(261102123227099003)(261028144727099003)(261022115727099003)(261022075727099003)(261021130227099003)(261022105027099003)(261022113327099003)(261021135927099003)(261021121427099003)(56012099006)(261009223027099003)(261021133027099003)(261102130727099003)(261026121527099003)(261021123027099003)(260925021311599003)(260925021911599003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MBI3IDH1RepRU7d0EhS8A/Iv7TbxG1ApK0QEDylyVL/iM6PLvF57c7uMXW3nB2ee6LZEgO4pCIVAu+v6MPSM+/eublLetv7YPDC76gT/mktDLB5vsh52oqnpiDuk3JvMIgPy8DYzBlyQ9I2fYNg+2PEIflPn6TGRRhWMvPGsD07HhDK29wFtOFc4s7CaahseJbEFAu+9G2s37vkssaINjSIhX/P0Rq25ERciGbRomQ9u8kvJILzXu0k9XzisxonzWgnmUhJVRkvOwKd31CWX9Jwz3hGAqliJ1cgefI7cVveD/aeaBqW3WjMSswAzbtI5ex9Vd7t/gLsrfwE3ICTfq49FpCsQcCCuvvbmWK+UWpPL0TbG4T0qpwu9SIwAfssorfpu4PlbnTHMkpVZhcqKNntrouNEL/3B23nWLDPNNUCNdRZo2P3g5kWrlxpy5BTF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 22:43:46.9201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2afc06-b767-4f12-936c-08df3b8e40e0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7291

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

