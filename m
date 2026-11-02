Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658508;
	b=UdVrr+Wg1lu8XbNUQjZJUA4+tSYH6m2ud5gTS8URarsvJv93pY3T3Fgj4d8+YxsMTvZC
	 0E5srKi+EgOryN1vOdBBHeTgYYEIzZkVvK748vKXMWb/FfeZNzDBpbJ0WQXO6dzCNLPEq
	 m0K846hPPBAnqAdj7EEhRfQQtsS9jQt13ImipuADj7vs/71fuBJ+YdAoRhgRwB0trFXDi
	 dYYsWHDSLyW1VqPQbVw/8jvgSu4bjIcyXknugCkgcjI3DOJ20VSr4JBjd0dOQfJ/BaaBQ
	 DM9RbljlnQ+zfVQ/JYo55GZzi5zJYABEiLGhHb7whbiqf+03glRTVthi0SZyJW58nGA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658508;
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
	bh=+/EIJ+aB2AM8JR9lBraoCoxqAC45LQrlYULwDUtNJxE=;
	b=VHlcIG1N4coxSDdghCEEASJdu3WSJY/h62/XnmQ1SG402i2Wun4DZC7PEQci0b5Faa3M
	 GAZjET5m9ac0zWaA+43cfO9Z5h49pIna79BuEpDY97DMbA8ki87Wm0tcUa8qdw0U5c0sy
	 +tYCRmpwuvbupaUqNkrDKt9On4fV9hpOEklTBZfKQ9o7XP7KC3VCrH0ZfCg9v00xo3ACt
	 72VdwvSiYq699/OknftsCsyYeTQEKqdcjG+nyi4QfnkN5XaOACqmmrTvQL6awZLbxrXZb
	 Ri3x2o6jB7h0g5mPKRzF0XdLHwHlg1gOQGqWee1ahLCSdg0xvjoScF3Y71dB4WIJy8Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ZLknbLMC;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.30
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013030.outbound.protection.outlook.com [40.93.196.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5552606D810;
	Mon,  2 Nov 2026 22:28:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5552606D810
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ZLknbLMC
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cDpzNv4U2Ye2TiIUhne7m5hiWRJxZoMcNQ23m4cRm7nKz4SVaOTFIt+qmmKQp5AWQNbcDnvRSHBQugptHn5LswFPMnWLB4or8eQcypjoJ+jXGxAoxicVCQsdYQta9ydNyFrLBDxKSc3iUG63qYQXU0MrYjvtWW2odLCgg0jz7xCz8ludH/X1gsTN9X8Edk8pgS5IMEzLJLKvFis38LuzsGNl/+Mv7SBcTequnQ58eBVZhdH4i5GOXZcJAA7Ry7QtfFuMnurhACepYijg4YJCyThQbQDdtkp9nf6zvSasle675Gho3wmU1GDUxfBluuy8S8Pm4xDKJ/o5JJl8iK3yAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+/EIJ+aB2AM8JR9lBraoCoxqAC45LQrlYULwDUtNJxE=;
 b=YtPTxfl/DTZCdqhReK3xQpIBLjgdNLmipzEBomly8PsJ1xz2XPotM6u7C0Z3ZII5fUATfl1JsU66zoOo7AqurFFqmbjWce7oHC0cIMuMIAoQk8WmDEyoOXxqYsh8KRZ9pz/zOmmZa98dishRHui1EvAj7sVYv+1k1QQHUa17FdDx7pwMAfvzjRkt8i3L9kXlz2K5gSsgb6nNVY8DK3JjGD2koF0xsZAnzCnwm2jCE4xJDbtvNbOitpx2o1KJ+S/AAwwiMt7XfHOKZH4c6WLnFZWqNBMvc77HJJ6icj4jFPz9Uqaji4crdT/OnucgvdeNA4MOv2ZbfobDksaSyTwRjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/EIJ+aB2AM8JR9lBraoCoxqAC45LQrlYULwDUtNJxE=;
 b=ZLknbLMCvl9rKAFMGi6EFWwijUJdhb9icUuFBagVdbDB8rrg2oEA+msAU5DxNX2zDOoFz8q95KVZaeO7cDqQDTiN3TYhY/2u/sMLSD6wXMCupaNdiilWMrrgC09BGMyyEVE6Tn75mm4e1OWzUPQI5pvRHki5QMGfByObO5Bfe3I=
Received: from PH0P220CA0024.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::29)
 by IA1PR12MB9739.namprd12.prod.outlook.com (2603:10b6:208:465::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:28:22 +0000
Received: from SJ1PEPF000037B5.namprd05.prod.outlook.com
 (2603:10b6:510:d3:cafe::32) by PH0P220CA0024.outlook.office365.com
 (2603:10b6:510:d3::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.12 via Frontend Transport; Mon, 2
 Nov 2026 22:28:22 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000037B5.mail.protection.outlook.com (10.167.244.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Mon, 2 Nov 2026 22:28:21 +0000
Received: from [192.168.0.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 2 Nov
 2026 16:28:19 -0600
From: "Nikhil P. Rao" <nikhil.rao@amd.com>
Date: Mon, 2 Nov 2026 22:27:41 +0000
Subject: [PATCH net-next 3/3] ionic: add devlink param for command timeout
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
Message-ID: <20261102-b4-ionic-cmd-timeout-v1-3-2f75c2d0a0c7@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037B5:EE_|IA1PR12MB9739:EE_
X-MS-Office365-Filtering-Correlation-Id: f71d48b7-c7f0-4b2c-3c93-08df39309a3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|1800799024|376014|23010399003|36860700016|6133799003|18002099003|22082099003|56012099006|261102123227099003|261102130727099003|3023799007|10067099003|261009223027099003|921020|261021135927099003|261022105027099003|261021121427099003|261021123027099003|261022075727099003|11063799006|261028144727099003|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	7f0Mf3xwWJ7Yj53PoZiUrUQoJTaFfm/CjjN+Y25BOuwfqabYbV5rxfCVuSXtrzwi0AH270uHXi0Fi0KshWU6RMkdu+IgsVu+12ZjgUnyNKOrOCrbMGvO753FZDx9rlNcGxxV6dFeBoXd+kdkS5W4DjySeWoGzw/WFKfS637tFeVLEhtMtE5XwNZPI//1fYOs3H6MtajBAbJbirZkVCN2KVBJUr4Sl1HzV3KOsR6kCCznUi3jms52ASa4SvvSvF2sFpLDugh/Sdje8/rW09/5aRShBnjXnkemBE83ZYIElX8ok4eQuVwLp512N08Z8ijY4CrJG5TzoVQj+rhsrQ3mzzXa89GINJhhTsv41dTIGf5GnrepookxoLCFiUATY3Ow7+Umm//BwOTjQj7pEPsZv1IdrktVWLCPJNm+TwhatbmCTErTxiQGul6LiBNa6s1tvzhZgE+L+KNDOlBYDC5fSFXegyin4Xcq0bY2o54iWVqUfwQP/cFbv4kaZ2CRGMlIyMgxeYz3G+JcwcyT+PdkWt6DJEqbku8c+4wSLM/0FnvhJkLV4iLP8lPBpR1l1WoM9cSE3MPyf/dfMEgwaIo+c7miup+vz5Tx4i6YIR+lzv43mlcq46+xbBfOnlCqAFDFQRoAvmNwfBNxqjSgPxAxrj5Ulfy/QvwyGT2u6fu9qAG+6aO1jvklwIMY4+dYHxVyqwb5qf5UF+aVnXeocW2LoPYiOXZJeXYQX9d4e5D6KBQkqBSwqnYIgdeD82rJrIi/
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(1800799024)(376014)(23010399003)(36860700016)(6133799003)(18002099003)(22082099003)(56012099006)(261102123227099003)(261102130727099003)(3023799007)(10067099003)(261009223027099003)(921020)(261021135927099003)(261022105027099003)(261021121427099003)(261021123027099003)(261022075727099003)(11063799006)(261028144727099003)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dTVH5RuAD2VPss8V6tpDpYTPpC5Wx1cke6W8WZcH1HiYDOgmGprsDyKQ1epRR0sMqW2iaomWDmu8FXMWiXbKjDCMe3GZBsu60Ia96G4nEnZIrtolzx9OOadZ7n4MIHYZ6j4Yku/e4MQTDTEglZpxS+GOpExJq+axbDMf1arCETJ3/BTYW6ADflP8CGqUUFIFy04DnGtHOHDx5XxADw3U0MaFJ6Rud+PH/djThql89YMnICGphYl7pIsPTE5/WvNo4tuZZyi9K8lqOaQcF3a0+l86ENK6d5/fbrS+i3+Teu6INGmrXrJ9SVRmWKNkRSIrIwwLuVGUkvVUK4DrZSneAlgj5+0MQQ5apMMfcRhVSf1X7iIKxxNamV7RbXe4wBcYnsp6cGeo7/elDV6xIKN+p0+sQp/TIw1D+qaWVAMfGAxO1HgluuP0pswyOE21cTCm
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:28:21.7402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f71d48b7-c7f0-4b2c-3c93-08df39309a3b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037B5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9739

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
not delay the first heartbeat sample after probe or reset.

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
 Documentation/networking/devlink/ionic.rst         | 29 +++++++
 drivers/net/ethernet/pensando/ionic/ionic.h        | 12 +++
 drivers/net/ethernet/pensando/ionic/ionic_aux.c    |  2 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |  3 +
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    | 81 +++++++++++++++++++-
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |  3 +
 .../net/ethernet/pensando/ionic/ionic_devlink.c    | 89 ++++++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_devlink.h    |  2 +
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |  8 ++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  3 +
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |  3 +-
 11 files changed, 231 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/devlink/ionic.rst b/Documentation/networking/devlink/ionic.rst
index 48da9c92d5841..40b280bf15721 100644
--- a/Documentation/networking/devlink/ionic.rst
+++ b/Documentation/networking/devlink/ionic.rst
@@ -7,6 +7,35 @@ ionic devlink support
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
+     - Command timeout in seconds, 0, or 5 (the default) to 255; values below
+       the default are rejected, as the parameter is for cases where the
+       default does not suffice. When set to a non-zero value, replaces the
+       default timeout for device and admin queue commands, and the RDMA admin
+       queue watchdog. A value of 0 restores the default. A larger value delays
+       the firmware heartbeat stall check, which runs at twice this interval.
+       On unresponsive firmware, a larger value also lets callers block for
+       longer: each device or admin queue command can wait up to this value,
+       other commands wait behind it, and RDMA verbs such as QP and CQ create
+       can block for several times this value. A large setting may need a
+       larger kernel.hung_task_timeout_secs. The value is stored in device NVM
+       and takes effect on the next driver probe or device reset. Only
+       available when the device firmware supports it.
+
 Info versions
 =============
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 5c54a0ea10a55..db9800147b081 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -64,8 +64,20 @@ struct ionic {
 	struct timer_list watchdog_timer;
 	int watchdog_period;
 	u8 cmd_timeout;
+	bool dl_params_registered;
 };
 
+static inline bool ionic_cmd_timeout_valid(u8 timeout)
+{
+	return !timeout || timeout >= IONIC_CMD_TIMEOUT_DEF;
+}
+
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
index 3b7cecc7f6dde..50312c1ae9eac 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_aux.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_aux.c
@@ -103,6 +103,6 @@ EXPORT_SYMBOL_NS(ionic_request_rdma_reset, "NET_IONIC");
 
 u8 ionic_cmd_timeout(struct ionic_lif *lif)
 {
-	return lif->ionic->cmd_timeout;
+	return READ_ONCE(lif->ionic->cmd_timeout);
 }
 EXPORT_SYMBOL_NS(ionic_cmd_timeout, "NET_IONIC");
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 74ba923a3f1b6..1ed7e6eb77652 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -281,6 +281,8 @@ static int ionic_setup_one(struct ionic *ionic)
 		goto err_out_teardown;
 	}
 
+	ionic_update_cmd_timeout(ionic);
+
 	/* Configure the port */
 	err = ionic_port_identify(ionic);
 	if (err) {
@@ -455,6 +457,7 @@ static void ionic_reset_prepare(struct pci_dev *pdev)
 	cancel_work_sync(&lif->deferred.work);
 
 	ionic_auxbus_unregister(ionic->lif);
+	ionic_devlink_params_unregister(ionic);
 	mutex_lock(&lif->queue_lock);
 	ionic_stop_queues_reconfig(lif);
 	ionic_txrx_free(lif);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index f14fff4a74278..64f62d412ee2f 100644
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
@@ -689,6 +690,82 @@ void ionic_dev_cmd_reset(struct ionic_dev *idev)
 	ionic_dev_cmd_go(idev, &cmd);
 }
 
+static void ionic_dev_cmd_getattr(struct ionic_dev *idev, u8 attr)
+{
+	union ionic_dev_cmd cmd = {
+		.getattr.opcode = IONIC_CMD_GETATTR,
+		.getattr.attr = attr,
+	};
+
+	ionic_dev_cmd_go(idev, &cmd);
+}
+
+int ionic_dev_getattr_cmd_timeout(struct ionic *ionic, u8 *timeout)
+{
+	struct ionic_dev_getattr_comp comp = {};
+	int err;
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_getattr(&ionic->idev, IONIC_DEV_ATTR_CMD_TIMEOUT);
+
+	err = ionic_dev_cmd_wait_nomsg(ionic, ionic->cmd_timeout);
+	if (err) {
+		mutex_unlock(&ionic->dev_cmd_lock);
+		return err;
+	}
+
+	ionic_dev_cmd_comp(&ionic->idev, (union ionic_dev_cmd_comp *)&comp);
+	*timeout = comp.cmd_timeout;
+	mutex_unlock(&ionic->dev_cmd_lock);
+
+	return 0;
+}
+
+int ionic_dev_setattr_cmd_timeout(struct ionic *ionic, u8 timeout)
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
+	mutex_unlock(&ionic->dev_cmd_lock);
+
+	return err;
+}
+
+void ionic_update_cmd_timeout(struct ionic *ionic)
+{
+	u8 timeout = IONIC_CMD_TIMEOUT_DEF;
+	int err;
+	u8 val;
+
+	if (!ionic_cmd_timeout_supported(ionic))
+		goto out;
+
+	err = ionic_dev_getattr_cmd_timeout(ionic, &val);
+	if (err) {
+		dev_warn(ionic->dev,
+			 "Cannot get cmd_timeout: %d, using default\n", err);
+		goto out;
+	}
+	if (!ionic_cmd_timeout_valid(val)) {
+		dev_warn(ionic->dev, "Ignoring out of range cmd_timeout %u\n",
+			 val);
+		goto out;
+	}
+	if (val)
+		timeout = val;
+out:
+	mutex_lock(&ionic->dev_cmd_lock);
+	WRITE_ONCE(ionic->cmd_timeout, timeout);
+	mutex_unlock(&ionic->dev_cmd_lock);
+}
+
 /* Port commands */
 void ionic_dev_cmd_port_identify(struct ionic_dev *idev)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index db90e39a1442d..06ca7584ee369 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -340,6 +340,9 @@ void ionic_dev_cmd_comp(struct ionic_dev *idev, union ionic_dev_cmd_comp *comp);
 void ionic_dev_cmd_identify(struct ionic_dev *idev, u8 ver);
 void ionic_dev_cmd_init(struct ionic_dev *idev);
 void ionic_dev_cmd_reset(struct ionic_dev *idev);
+int ionic_dev_getattr_cmd_timeout(struct ionic *ionic, u8 *timeout);
+int ionic_dev_setattr_cmd_timeout(struct ionic *ionic, u8 timeout);
+void ionic_update_cmd_timeout(struct ionic *ionic);
 
 void ionic_dev_cmd_port_identify(struct ionic_dev *idev);
 void ionic_dev_cmd_port_init(struct ionic_dev *idev);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 4ec66a6be0738..d775fa5bb43d7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -51,6 +51,55 @@ static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
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
+
+	return ionic_dev_getattr_cmd_timeout(ionic, &ctx->val.vu8);
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
+	return ionic_dev_setattr_cmd_timeout(ionic, ctx->val.vu8);
+}
+
+static int ionic_dl_cmd_timeout_validate(struct devlink *dl, u32 id,
+					 union devlink_param_value *val,
+					 struct netlink_ext_ack *extack)
+{
+	if (!ionic_cmd_timeout_valid(val->vu8)) {
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
@@ -74,6 +123,43 @@ void ionic_devlink_free(struct ionic *ionic)
 	devlink_free(dl);
 }
 
+void ionic_devlink_params_register(struct ionic *ionic)
+{
+	struct devlink *dl = priv_to_devlink(ionic);
+	int err;
+
+	if (!ionic_cmd_timeout_supported(ionic))
+		return;
+
+	devl_lock(dl);
+	if (ionic->dl_params_registered)
+		goto out;
+
+	err = devl_params_register(dl, ionic_dl_params,
+				   ARRAY_SIZE(ionic_dl_params));
+	if (err) {
+		dev_err(ionic->dev, "devl_params_register failed: %d\n", err);
+		goto out;
+	}
+
+	ionic->dl_params_registered = true;
+out:
+	devl_unlock(dl);
+}
+
+void ionic_devlink_params_unregister(struct ionic *ionic)
+{
+	struct devlink *dl = priv_to_devlink(ionic);
+
+	devl_lock(dl);
+	if (ionic->dl_params_registered) {
+		devl_params_unregister(dl, ionic_dl_params,
+				       ARRAY_SIZE(ionic_dl_params));
+		ionic->dl_params_registered = false;
+	}
+	devl_unlock(dl);
+}
+
 int ionic_devlink_register(struct ionic *ionic)
 {
 	struct devlink *dl = priv_to_devlink(ionic);
@@ -88,6 +174,8 @@ int ionic_devlink_register(struct ionic *ionic)
 		return err;
 	}
 
+	ionic_devlink_params_register(ionic);
+
 	SET_NETDEV_DEVLINK_PORT(ionic->lif->netdev, &ionic->dl_port);
 	devlink_register(dl);
 	return 0;
@@ -98,5 +186,6 @@ void ionic_devlink_unregister(struct ionic *ionic)
 	struct devlink *dl = priv_to_devlink(ionic);
 
 	devlink_unregister(dl);
+	ionic_devlink_params_unregister(ionic);
 	devlink_port_unregister(&ionic->dl_port);
 }
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
index 0a77e8e810c5d..02e1ea559a0e6 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
@@ -13,5 +13,7 @@ struct ionic *ionic_devlink_alloc(struct device *dev);
 void ionic_devlink_free(struct ionic *ionic);
 int ionic_devlink_register(struct ionic *ionic);
 void ionic_devlink_unregister(struct ionic *ionic);
+void ionic_devlink_params_register(struct ionic *ionic);
+void ionic_devlink_params_unregister(struct ionic *ionic);
 
 #endif /* _IONIC_DEVLINK_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index e911fad545d67..311d205c5b4b7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -275,11 +275,13 @@ union ionic_drv_identity {
  * @IONIC_DEV_CAP_VF_CTRL:     Device supports VF ctrl operations
  * @IONIC_DEV_CAP_DISC_CMB:    Device supports CMB discovery operations
  * @IONIC_DEV_CAP_EXTRA_STATS: Device supports extra stats schema
+ * @IONIC_DEV_CAP_CMD_TIMEOUT: Device supports the command timeout attribute
  */
 enum ionic_dev_capability {
 	IONIC_DEV_CAP_VF_CTRL        = BIT(0),
 	IONIC_DEV_CAP_DISC_CMB       = BIT(1),
 	IONIC_DEV_CAP_EXTRA_STATS    = BIT(4),
+	IONIC_DEV_CAP_CMD_TIMEOUT    = BIT(5),
 };
 
 /**
@@ -1778,11 +1780,13 @@ enum ionic_dev_state {
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
@@ -1793,6 +1797,7 @@ enum ionic_dev_attr {
  * @state:      Device state (enum ionic_dev_state)
  * @name:       The bus info, e.g. PCI slot-device-function, 0 terminated
  * @features:   Device features
+ * @cmd_timeout: Command timeout in seconds, 0 for the default
  * @rsvd2:      reserved byte(s)
  */
 struct ionic_dev_setattr_cmd {
@@ -1803,6 +1808,7 @@ struct ionic_dev_setattr_cmd {
 		u8      state;
 		char    name[IONIC_IFNAMSIZ];
 		__le64  features;
+		u8      cmd_timeout;
 		u8      rsvd2[60];
 	} __packed;
 };
@@ -1842,6 +1848,7 @@ struct ionic_dev_getattr_cmd {
  * @status:     Status of the command (enum ionic_status_code)
  * @rsvd:       reserved byte(s)
  * @features:   Device features
+ * @cmd_timeout: Command timeout in seconds, 0 for the default
  * @rsvd2:      reserved byte(s)
  * @color:      Color bit
  */
@@ -1850,6 +1857,7 @@ struct ionic_dev_getattr_comp {
 	u8     rsvd[3];
 	union {
 		__le64  features;
+		u8      cmd_timeout;
 		u8      rsvd2[11];
 	} __packed;
 	u8     color;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index b0868ab139dd5..a89f9c72eb39d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -3398,6 +3398,7 @@ static void ionic_lif_handle_fw_down(struct ionic_lif *lif)
 	netif_device_detach(lif->netdev);
 
 	ionic_auxbus_unregister(ionic->lif);
+	ionic_devlink_params_unregister(ionic);
 	mutex_lock(&lif->queue_lock);
 	if (test_bit(IONIC_LIF_F_UP, lif->state)) {
 		dev_info(ionic->dev, "Surprise FW stop, stopping queues\n");
@@ -3460,6 +3461,7 @@ int ionic_restart_lif(struct ionic_lif *lif)
 	netif_device_attach(lif->netdev);
 	ionic_queue_doorbell_check(ionic, IONIC_NAPI_DEADLINE);
 
+	ionic_devlink_params_register(ionic);
 	ionic_auxbus_register(ionic->lif);
 
 	return 0;
@@ -3495,6 +3497,7 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	err = ionic_identify(ionic);
 	if (err)
 		goto err_out;
+	ionic_update_cmd_timeout(ionic);
 	err = ionic_port_identify(ionic);
 	if (err)
 		goto err_out;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 16df13f23c90d..a6a5206d6605b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -435,7 +435,8 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
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

