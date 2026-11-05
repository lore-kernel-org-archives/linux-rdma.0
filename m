Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.38
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793918634;
	b=ptCgUEekjKTHQA1ykjQjohhny1dAbPiboEsx+p30N6BoUe/OSasgWg5aDz/d0Jrxjxh4
	 CwOpXo80M5gSolIjBqFQXzOz6ARNqf3IOADAT1uwclznIMOGsKv8M4LAYzonDm3liLObC
	 cbGPSgpLw1CVCI0eecn1yQe2jBfnAKk5gokQ/eJXarJHY0qRwEtlylKoWo2dj+9HMi4qz
	 TtdApcanAVym2ZQ33nvtuNnul+4yM8UrAMYA6F/7C6BKwf/Zz/F8nYAu4HKMasDbQkCRD
	 7s0nP8pXEFZpuO9flSj16cOzdzj5jnzbwO3T8jfkmW8q0R9fOVctPFnOL3Ql7JX20bA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918634;
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
	bh=wuKqU2tXHfG2rHcrThqX6FBB6nh1Pyh0K/Huv/vPmxg=;
	b=CMfymexWS692bWT2GVt80jGZVpcjJ2DUfTAx8YrInCWySUyfZN6udWQhHWbVvKISNRY9
	 UxioFMojT2JbHWXnP7JD0U35qVo7fGiOetqYVHnpayVU+yY9TJhR087/Wu5v2YGLfBRyY
	 tMY32BqV9VAi0sKgWuYLZYNHva8J4DLEVQwXeeFb/nIDHzMbzviSI5JhKsqXm+LAffxTY
	 NhUvwsEiR0iVIX3AUl4vMWhhTfoJ7jmVSQ1AxudL6FlTAO+sj4sJyAniwD6bfQPYSzka4
	 D05q2J8oSIcyR/lZ/kgvTLBOCbIVk/xxEkccxxUCcpTnu6Y8P14xTNeiXxk+wG0OvDA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=W+QMIec7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.38
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010038.outbound.protection.outlook.com [52.101.193.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C1B606A338;
	Thu,  5 Nov 2026 22:43:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75C1B606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=W+QMIec7
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xakqw9Bv1KHKw5EEPxp849+7QCn9/nHg/E3DufUnoa3jyjrkACVkaeIEZ7wviCM+fClmCOy352ynDXTN6iitc5dWg8FSCW88J+YBYetqnvJ1Jzfd6E+7GYTLcfHhKBOYw+xhkDIWG2A8QqyF/pGTMN8GLcv7rLs2vUOXchskn0CSUF7r05eOBwMBv2YKNZ60MnftI4VOWVur4B6WFejEJbxHVCfqDDgZlb3t2DJT+Ow4EEz/xODsiY4naGjWgMDiLztjbbLrXc5FDte/uDn/QQZ/0xm1HIJBqw/paSI58fL5C66NwJqVfHr3JTuWTc1F2KQhgSHf82p1Z0h+32BPmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wuKqU2tXHfG2rHcrThqX6FBB6nh1Pyh0K/Huv/vPmxg=;
 b=ceAm3elpblIW9w2r9154klNu/Sl6iAQ4JnhrvrIgKZkqKLu0vKMjdTua5G1iWk2ml97RDcR964wHy2ELt2COPGHBH2hBrToDNrXyrBY1RFfLMAcoMpZ77ShK4w6X+qUZCtyFJIlUAkgNUfc6WtuXbRxc44N3asQ5F+6qRZzpJaI6wOkMyivt9u3R0rgZIJutXRiqYw9DL02bPk4q1J4neACoddD07dZSeVAZ5LNMywEKtw0gmLdXETXiwr6gzq3FoySxm7Zt69+xTQsJS21U3H9Z3v1/yO2puEqXjoc0WFDmece7C1pHYo5tK39A0pfNLGElr45AIp++X95uuPVepA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuKqU2tXHfG2rHcrThqX6FBB6nh1Pyh0K/Huv/vPmxg=;
 b=W+QMIec7eyHsqD9GRatHgREzQkFzQAJ64j8RtVOTAHGcSSYfKsYdKlR9Zjqvmi7tMVOBN8IyMrfrRRadzf4hAjaNR0WtI0i0fwyb5jfNj+lBd2FwdVMpfzkrjuHnTJmL5FSLf2R0lr+apwEGDP9ECrgs8xWHmjIUcviblZD5n2I=
Received: from CH0PR13CA0056.namprd13.prod.outlook.com (2603:10b6:610:b2::31)
 by DS2PR12MB9824.namprd12.prod.outlook.com (2603:10b6:8:2be::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 22:43:49 +0000
Received: from CH01EPF000BE94F.namprd02.prod.outlook.com
 (2603:10b6:610:b2:cafe::14) by CH0PR13CA0056.outlook.office365.com
 (2603:10b6:610:b2::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4 via Frontend Transport; Thu, 5
 Nov 2026 22:43:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH01EPF000BE94F.mail.protection.outlook.com (10.167.244.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 22:43:48 +0000
Received: from [192.168.0.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Thu, 5 Nov
 2026 16:43:46 -0600
From: "Nikhil P. Rao" <nikhil.rao@amd.com>
Date: Thu, 5 Nov 2026 22:43:12 +0000
Subject: [PATCH net-next v2 2/3] RDMA/ionic: Use the ionic command timeout
 for the admin queue
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
Message-ID: <20261105-b4-ionic-cmd-timeout-v2-2-35a9a2aa48b1@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94F:EE_|DS2PR12MB9824:EE_
X-MS-Office365-Filtering-Correlation-Id: b84cb7ac-afc7-43d6-284a-08df3b8e41ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700016|1800799024|23010399003|10067099003|22082099003|18002099003|56012099006|261021135927099003|921020|261026140227099003|261022105027099003|261021121427099003|261028144727099003|261102123227099003|11063799006|261026121527099003|261009223027099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	+sitvOc7/0+iJFe9yaqli7cyqdgqadYzWcIlUDEVSpzO3v8qFTFrKsKE9aPu9CgoMssXxKWJ98GAIaS2f6LNpC4XSEV0CI/SZG/rUH4tehVBb81jq41S2WIx5QKqar1QsATyYZ2gOAck096MVCiFSQ3nH47fjxBZ9pZFd6FOD9hWR4Sk7Jyv6QwGOMRSPAyWhOzEI4kHfG7s0socpQeorM8wpCUxWlUpxfhuczXEH7OeND4bSTF4LxRNvd4bF6ObBSmtt1HxcGBS/UcBNKIuK4AVL/7jEScbThgiN1TuMKI80h9C2VW3BjmQIe3DPW3s4ViQ7fPaDVeTJF7lyiZENift7UL0kUzlhqh+I3RaH0pEUkriiplhmFm84ZzXXbSk0V3ZjJf0Wnz030cGqlQx7SOtv2EoO2tBh3QER0E9Lue0p3WqM+LvVuEI2YinpaU9KmD7q3AcctrQudo1mqIpWBBWbuzgLixG1fEA7mUZtWZg/yye38HvkFaglEW4ZsGmmYJLMNMIaQzxYhKYY8XnjsPsY1W6x8ea7wFis+jU6die/BNs8Ukyz4foEorJYHB8rYsp1pqL5VwxzESVamXz9lsN5ArPNElBgbZVi1eXiyi+dAkY+BW6rSFwrn/zl/nQ+/njKTkEx5si7c/AkKA6nnM1J34bF7ZnPDnSMOdiMicP8+a7qBDxI1m6e4NaKJITxNUWUPXUrAt0zUHFaKixoyFOsCInNrIFHSsvShi9vqBkkv9R7c/RYOmEnpF3/8K+
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700016)(1800799024)(23010399003)(10067099003)(22082099003)(18002099003)(56012099006)(261021135927099003)(921020)(261026140227099003)(261022105027099003)(261021121427099003)(261028144727099003)(261102123227099003)(11063799006)(261026121527099003)(261009223027099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gsO+AtC97r4oSDSrOgWfNwfBewGlhhc4G0ivb0MDD9yudPburjx4IWwqWFhm1FQpZx5TKXo1zRJMy/TeHXNz3Z/Q9K23Ayka/gf6a6O5Gq7cGdCCOrNW54ffg8ZC7UKFlZYQ+kiYJQxQQTewD1EzQyqtO60d389F+CRIRTgMt3hBoQKU8S1B0GKQeFOLvfJdjLLfE6OXMJpq+4BvhxGbrZKQ6lj37X4USbiq98ARY/iz8Lzxu5quQtwvp1AYhttybHkOI/YzTunlzVCK2xisqtuwWLM4XM8Bw32M0iWADY0c5INwPBWWJ33LbjUwN/HuFDeHInqkrE6TLAWlsVDBZa+5Wg4FluP3W6ZsoJ5LhCY9zL0VFZ8sW7FE/wdaIPY99z3XG4dN00+ow04PbXg2nwQPE7EKULZew8SCGc93Wfm34+Ny+Cl5LF50hTN+nbiQ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 22:43:48.4511
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b84cb7ac-afc7-43d6-284a-08df3b8e41ca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9824

From: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>

Commit ec8ee714736e ("ionic: stretch heartbeat detection") notes that
firmware can take more than 2 seconds to service a device or admin
queue request, and is only expected to complete it within the ionic
command timeout. The RDMA admin queue watchdog still uses 2 seconds,
and when it fires it resets the RDMA LIF and every later verb fails
with -ENODEV. Use the ionic command timeout, 5 seconds, instead. The
AH create/destroy busy-wait keeps its fixed 2 second bound.

Signed-off-by: Arun Kumar Prakash <ArunKumar.Prakash@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Acked-by: Allen Hubbe <allen.hubbe@amd.com>
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_admin.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ionic/ionic_admin.c b/drivers/infiniband/hw/ionic/ionic_admin.c
index 0ccd869ad8e6..b463ad8b4e80 100644
--- a/drivers/infiniband/hw/ionic/ionic_admin.c
+++ b/drivers/infiniband/hw/ionic/ionic_admin.c
@@ -18,8 +18,6 @@
 #define IONIC_ADMIN_BUSY_RETRY_COUNT	2000
 #define IONIC_ADMIN_BUSY_RETRY_MS	1
 
-/* admin queue will be considered failed if a command takes longer */
-#define IONIC_ADMIN_TIMEOUT	(HZ * 2)
 #define IONIC_ADMIN_WARN	(HZ / 8)
 
 /* will poll for admin cq to tolerate and report from missed event */
@@ -28,6 +26,11 @@
 /* work queue for polling the event queue and admin cq */
 struct workqueue_struct *ionic_evt_workq;
 
+static unsigned long ionic_admin_timeout(struct ionic_ibdev *dev)
+{
+	return HZ * ionic_cmd_timeout(dev->lif_cfg.lif);
+}
+
 static void ionic_admin_timedout(struct ionic_aq *aq)
 {
 	struct ionic_ibdev *dev = aq->dev;
@@ -294,7 +297,7 @@ static void ionic_admin_dwork(struct work_struct *ws)
 		}
 
 		if (time_is_after_eq_jiffies(aq->stamp +
-					     IONIC_ADMIN_TIMEOUT)) {
+					     ionic_admin_timeout(dev))) {
 			/* Timeout threshold not met */
 			ibdev_dbg(&dev->ibdev, "no progress after %ums\n",
 				  (u32)jiffies_to_msecs(jiffies - aq->stamp));

-- 
2.43.0

