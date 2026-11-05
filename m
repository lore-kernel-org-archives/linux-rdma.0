Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793918638;
	b=gqFgCq7nTuL8dhFItSzx+yPG5jyEQcropTrBbVFXR0O0A3K+lXtgYG7EGljtuAbZDhic
	 iiustAgQauG2ckkNn1jo4XEEE91DjPZwqYoGsqErjR7Ovn8rVdBz4GiUkCbgPEmFBhakO
	 oZcIHCMZlF0PnLuxI+Pn7CkCNK77s7sHbnhGDLvz/Hx8Y4nlyQEs7kD2Men8MFPSb20lU
	 g2hgWKX0ocrMn2jDowDFGocJbar7X2Fa4ugwZsoWhur/wnBPUbB3mDUnvqj3R9LqrhuJD
	 AFMIyoH9c1QBc4e1hQGlah7k90qNsJLx//PPAvICSjhh+qaHl/xQ0ShsT5KVhUvTCCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918638;
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
	bh=IKofYJygfKVO+sQFlawHKuc66kmB8XeewPaMTGlOPDA=;
	b=v+lSdugBmYMzh0VtnTEqjsxOWUcqANCz7E0e2b0UWyG/xl4rmqcKmdU9Vw/oNqQ2sF9Y
	 I4mZeGjw2LkGWeus2btp+ZyZAzLd6/QpTIM8BUef9Pq2jAiEABd1tNu934THTdjOfixFI
	 hASFgh0/n5XUBSAJfPv2vOUJ0u/Llf7OFn3Fjiywa8/M/52h/i57OFPcRiikAvr6sNOH2
	 t+oTEqfuwSgte5gEcMfim2gDO0ze8etFNOWD2G15yRI2JFWoPFvzroOK3/Gq5c1lTrJUB
	 yf1uCHmPgdS4kw/8bgB1RTdtDPduT5ushwUVkYa4Ba7va6lqKoUbK/HxG9V8aillT8w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=jnPeplNb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.25
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010025.outbound.protection.outlook.com [52.101.46.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F5C606A32F;
	Thu,  5 Nov 2026 22:43:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89F5C606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=jnPeplNb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q6IUoYpAH/xkOnylnRZlhAwVEFJnY3pUOOPubcDOjXkwJY/jsOL2pknx8rilBatO1WCAfurygoJK5yHcNMTfU8RG48zfLbFf0Sq9JOJLIYP2GP2dvRrraP9BmbQ0og76FnDld433hbcb0Nr/oaVTtvPxYysmqf2DnvrwSaPk3cCFYO2MSCjYamEC8PIN+ZHV1np//1F10e61Xne2EM8ND6omdCkGyghlb5wl1659QKV8TJgc6xAqcZ9GCguAI/CUcMuq4egt5DscugXWQWkAY1N2fqh4KNAudE+IiRhez632Ul6kQKgFVBa42bMxkieWYNH9zqzyESn78MZGnRdJcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKofYJygfKVO+sQFlawHKuc66kmB8XeewPaMTGlOPDA=;
 b=YIqdOp2/DtBNBONMJVn/FEeQpONVPe6PFidY5e74+eYVr372R3kv3xFWFE/UTk00wIWRh6Q2zbw3ngwnchTMMg5dUmyqXIWbrJXPfqOneqBqIvNZe3LD+U0ZhFrYL/0OTQKB81B4L6R3i08792xlweOikYaFiGmDIRqoB8tx+xduT5dRYhpIyduB0t570kRvxi3vSOgIU12/46ftzIYoB5UXqeG0ANFibk27XElrWRBFI0coTs/pbF2QR+Pk6movYvMQEQkpg27pZ9/dztlf0cYco99wXuSRsHnFl+WTj8kHyN387wyM+M7FCkJCoK9GnutCgDIucfKQZWJBRCnLsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKofYJygfKVO+sQFlawHKuc66kmB8XeewPaMTGlOPDA=;
 b=jnPeplNblqM/Ue/CYHXxn4ZLmRvVInpU5U4qbF+FV2e3ZlMV3itZfIdT+OLLLaT1DGY1vhuwsd4v3KC3lDZ25SCKrSs4//Z+k1fapXMqXR3k/cvQJb9g9NksXn5ZkNH/vuef2bAfzRmzl1n90/n5xUIaMNlWbhNQObMSF9XK60o=
Received: from CH2PR18CA0025.namprd18.prod.outlook.com (2603:10b6:610:4f::35)
 by MW4PR12MB6998.namprd12.prod.outlook.com (2603:10b6:303:20a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Thu, 5 Nov
 2026 22:43:50 +0000
Received: from CH01EPF000BE948.namprd02.prod.outlook.com
 (2603:10b6:610:4f:cafe::64) by CH2PR18CA0025.outlook.office365.com
 (2603:10b6:610:4f::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 22:43:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH01EPF000BE948.mail.protection.outlook.com (10.167.244.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 22:43:49 +0000
Received: from [192.168.0.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 5 Nov
 2026 16:43:48 -0600
From: "Nikhil P. Rao" <nikhil.rao@amd.com>
Date: Thu, 5 Nov 2026 22:43:13 +0000
Subject: [PATCH net-next v2 3/3] ionic: add devlink param for command
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
Message-ID: <20261105-b4-ionic-cmd-timeout-v2-3-35a9a2aa48b1@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH01EPF000BE948:EE_|MW4PR12MB6998:EE_
X-MS-Office365-Filtering-Correlation-Id: b8ccc74f-2cd8-4f80-f0f6-08df3b8e42b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|23010399003|1800799024|7416014|22082099003|6133799003|18002099003|3023799007|10067099003|921020|11063799006|56012099006|261028144727099003|261022075727099003|261021121427099003|261022105027099003|261021123027099003|261102123227099003|261021135927099003|261009223027099003|261102130727099003|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	rBBjSncnHApIPM9R/4tzbHaAwlev7SQEhMWc3Fyr6E4mHgM7wfWuoNh0FtV/bYlbrdqSG5fW5HnuojGAg45gbiXrJvsTRYxmu+pd6NVwXT+4brffMYEc6A6LTz6q6ZLxifCCfWGtQTPGrlDgAOhaPZJeVTqS0NhksK+TCMfq1NmBKIArEiNu7BDUbUBnpqoxPUABcgeEL/y/ODJ/OyB+WwiGryqJ1mgCHJ3pMMnDg/pleA1P7bBCTxR/BWyK4Qp8HCn2O+95sBEmi28bGoj3FxY+SUzT6+5zeWrxbPnubkpUd1xUt4964pl00yUSwj9PDVcvY47mxIR/qsNbH2UILL+GsT0/t2CNGA6TLXJEoDDqxaMmqLhW4sEvmxTO/uRF733O9A0LMFG0hsCXEwJUSnWcnNmTnZMBPLGNDXeA8hAAelUV2hWxYnQ7QndZMRLMrR3y1jFeowmvTGOCXzPpZ4YegSlgxh0fzuklRygbALt0d+aiMbwwGGRRR0lKmey1fFKGamm4r7U/ymmqMwCRqV0HKk8tGdq1FXP9zG+qTzOm4sXG9ERWBalFyv51euNaRShp5BCctlZi1RV08efY+PFj1x2VIdfemZ6ZBETX2DheX6HNBEvXkLskk92W1siCi2Uu8J7XA0PUdFWj5NGrPq1MLAfqBsnXbPzfr8sLXN8qZCHYSn5VSng/8dy5mMJz/BNi0HrlKPAJJe7z+HVt66noUQ2tfsUKOByMnMJlWwcZuMZL9ndTEcB+QG95X4ed
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(23010399003)(1800799024)(7416014)(22082099003)(6133799003)(18002099003)(3023799007)(10067099003)(921020)(11063799006)(56012099006)(261028144727099003)(261022075727099003)(261021121427099003)(261022105027099003)(261021123027099003)(261102123227099003)(261021135927099003)(261009223027099003)(261102130727099003)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	e5GMdQqY7SbVrehOybD/qobIZqdef9tm7pwFv9e7rxQHPKhyEmdU+nlX08BN3Jnwnn75lx9wCBFI6s4zhl0eKF846mu2MVlpe27HIYS37L3L+FyEBmuMqgaDSDW7GrgPdMwOzxy4yLVpuH3fZ/WoZEMcHROpoThtqu09LjBl46ZE29+/7ERAF0nPq5+i+hY20SGTa4gUOHu7NVbfY77E0EnVEZcvpBZn01ZL3QAD+zzS8+45bxauUPoDqhwkT0Vyk0YE0w8t12t8cyYeruQGSe59Wd9Z1CX6OmJVxawlGALAGN+rcTODLGZ0B5PAzSSy31CkMLB/Nbl0x8mvIntnH3wY4chMD47Dmho6vlKf0PzeNhKCO3IG2XN69TexsYnE68/XESBfmtxseN2z3NnusrKKMFbw8zwP3U7BUWAuI40FKuRvuMgoDybgBDmXHsXv
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 22:43:49.9760
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ccc74f-2cd8-4f80-f0f6-08df3b8e42b2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE948.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6998

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
 Documentation/networking/devlink/ionic.rst         | 29 +++++++
 drivers/net/ethernet/pensando/ionic/ionic.h        | 12 +++
 drivers/net/ethernet/pensando/ionic/ionic_aux.c    |  2 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |  3 +
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    | 81 ++++++++++++++++++-
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |  3 +
 .../net/ethernet/pensando/ionic/ionic_devlink.c    | 90 ++++++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_devlink.h    |  2 +
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |  8 ++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  3 +
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |  3 +-
 11 files changed, 232 insertions(+), 4 deletions(-)

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
index 4ec66a6be0738..c9a07a86aa383 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -51,6 +51,56 @@ static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
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
+	/* devlink fills PARAM_DEL with this on PCI reset; no FW_RESET check */
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
@@ -74,6 +124,43 @@ void ionic_devlink_free(struct ionic *ionic)
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
@@ -88,6 +175,8 @@ int ionic_devlink_register(struct ionic *ionic)
 		return err;
 	}
 
+	ionic_devlink_params_register(ionic);
+
 	SET_NETDEV_DEVLINK_PORT(ionic->lif->netdev, &ionic->dl_port);
 	devlink_register(dl);
 	return 0;
@@ -98,5 +187,6 @@ void ionic_devlink_unregister(struct ionic *ionic)
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

