Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.60
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795048373;
	b=MuMkVECpxd+tVhKzuK+H5Z2osMFzpFBcZWDenIH6dt3XnON1Vg3m2TQfHHiheOAFSy/P
	 Ytwkv9lzcXKmaSY+uzL3sLr1F74R2tZR2uNCPlsJX9pFZdBXYEWHLiHrLFdiqiHmGzv5w
	 zReDWPQbSTS0sZbDbqglkH3qNslO/rwRq0YXu5jKquFJ5TtUUP3roxdndiUUDNInlDl1S
	 gFKD1COztFhYOnXMwrT2jNVnBRNoYVRvkuQC0GYInz6tphQVhieDNu7Qiymcal2nDl0lB
	 wKmjUtajRhuCVjaa/0ZgOR5T3e0N1fsIO9POuMrnsLuq4DVXuZ5nbtoRgjkIsZXLZBQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048373;
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
	b=CkeXBah7s7BFqBSuxx7lU2p/lENC176cDxYnqPBPII2RrBRZuccOrFrClbPvjSs4clWg
	 5fQ/PNNa0gJl0GTBYQT5kjeo0bk2gi4bvNXnmSh++qHalCaWDKnmqpTjGS7zGqtIuJnWh
	 YnqE5kmxG35xg2QjccX7d0CY5xtZzAPWOvi9ViEBngwEEJDvlOY995cjpMzVY1yHWNokK
	 XN/u5PeoiWkreqKm2WK1yRqNDuQDtAjDzbOvQ9FfgWMK07yK4khU0SNBG722OhQx0Zwtu
	 Ohq/H8tpBLmZwrCn3hJBSa1txHdMVNHqno48D70Lg5lXF7EsZR/YxXYCKo1aF2Ay4Fw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=wJxT6Q7o;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.60
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011060.outbound.protection.outlook.com [40.107.208.60])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF486606A325;
	Thu, 19 Nov 2026 00:32:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF486606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=wJxT6Q7o
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qKgWb7swUF0a/WqBrtIi2tUL3eFlLJNWV6bObStC1ETxOlEXk6vHHbHTDuzxRMDMVmL96ihOywXrq+R380078cf91+ZdJF37+YwHNj6kopi4/+NOvjSWwjshYU2/oRbXltq2bvj8gVAAINBvvR0rZ1QsudYerGQKqvLxLIRW1L9KIJjhTLftUTNHYfGZ0bZ9lQvjx/LH7YucD6tmvRh/XSEuiUojse/W78C1wA8EYahVnvZ04Bk2wVf9LKD0zeCTiCgUwlKQuU5WrAyRzyq0ZyFT069Tca74Id+wCBP8jQx9dvH52EfF4N6e4uyd/sh2vwkAmtNprMTPor++KwU5lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wuKqU2tXHfG2rHcrThqX6FBB6nh1Pyh0K/Huv/vPmxg=;
 b=CCZyYZK2i9PeGyjmxa+wF0VnUzSllNqDMOXP5bqXZ+sGkfCLKOJ+TWGxEVzWzTaN8BENV94mIPura/zvhGffnHPfU67E8qr5pc6Gi1oosr+MzQxE76LKGO07HKsnGWp/FDEjMkHYvgs9EDkAQuGW5HmXjKrYsRmoDfP9VDWi6jrbhH+n18F4U7xj42F6+tHQksKF5ZtcSH8VpPlrgSvCREdvKFz8esmnsa4v7Ip9ZQXK3KlBO/c2340wbutd9QrVBY7Sp45kMyxukTpellX+8TFZ3L9FubTyhmfKtPAGqyFzak10LMqeKe74qBGdt4SBFTSb3Si06fRAL7z+Zm+f8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuKqU2tXHfG2rHcrThqX6FBB6nh1Pyh0K/Huv/vPmxg=;
 b=wJxT6Q7ovVYH3h0MZ3E7WOFRpao7SygOvf68ABWNftSrBBHgIY/Kc0DI/Z7wauZT64fFG1Egi/WLAS1l3xQTQGW8GLrcgSAwlHbaay/wR/bVpyMZDFM+NSDh8/kYKowttAGs57E1l3caku6HFOXKud3alQXkQbx+tmKygh00E4c=
Received: from BN0PR04CA0048.namprd04.prod.outlook.com (2603:10b6:408:e8::23)
 by SN7PR12MB7021.namprd12.prod.outlook.com (2603:10b6:806:262::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 00:32:49 +0000
Received: from BL6PEPF0006C3DC.namprd02.prod.outlook.com
 (2603:10b6:408:e8:cafe::80) by BN0PR04CA0048.outlook.office365.com
 (2603:10b6:408:e8::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.14 via Frontend Transport; Thu,
 19 Nov 2026 00:32:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0006C3DC.mail.protection.outlook.com (10.167.249.230) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 19 Nov 2026 00:32:49 +0000
Received: from [10.11.96.223] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 18 Nov
 2026 18:32:47 -0600
From: "Nikhil P. Rao" <nikhil.rao@amd.com>
Date: Thu, 19 Nov 2026 00:32:32 +0000
Subject: [PATCH net-next v3 2/3] RDMA/ionic: Use the ionic command timeout
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
Message-ID: <20261119-b4-ionic-cmd-timeout-v3-2-2cdb8fca15fd@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0006C3DC:EE_|SN7PR12MB7021:EE_
X-MS-Office365-Filtering-Correlation-Id: fbf1b255-754e-480f-78cb-08df45d4a3bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|23010399003|36860700016|921020|10067099003|261026140227099003|56012099006|11063799006|261026121527099003|261021123027099003|261021135927099003|261021121427099003|261022105027099003|261102123227099003|261028144727099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RQdw3NC1le5uu5sHfxmviC0FIKqMMTmR1476vqY1DgHOlMzuB/bcc6thJD/DykkkQazxLvZhwPeyBjuNS79eIZHDXqycz1gqp6B/S7Oq4v4zO20+KP90svtNEE/Smev4UFdYsv7TFMMWVv4cbp5pIEITlRiPcz+2/oiF8jTEYRSZVKdORrQEhbuCq/fPHteiNe6HItpgpMcMDYI2TyQwpgRAQ7UO3yhEDYgSGxg8GXTuk6aU/pVepsW2VJJoOHfTPz8Glldjz6t6XQQ49WnuzCi1P3867QDq5LWjAt1h31nRGhJdUQ4XiqLYj3iFHbov9d65SCz+n1IIViu/hQLM8uIqrKLYkJlwkju0zWIwFvL7By7yqZlHZj6WbgchiJACdLt5TMWsFakOlyzN9mNcA5RKCllyckNsiMNrCjHezfrLDCv4fL35Gzw+abrACuuu+cz2QLgotmgPmCUAi1bt9XfZ7nk6TvExkU5grQB6NwtcB+NwSvrEmsZVxuzqyikYVUlelWYvZIcjFH+st06vzfSJMlmuy98vflPuO89PmBZEhVfIfvNlliIuIgEDOvJiH6iqnrLNUvw9kbCiN63310gJU0ebhpJpBnE3eWWuxi1/bn4JJlVJ+Wt/d2MIfog5Clgwywl5j95LBDl1JucNeZAshbr8rLjTGP53nUGRk7gT9Ti156oDDn062nC7UTY5udXSichwrliYrVfvZ4n+QWkgouyZrkrovBp5DnfymyLzT//Vm6QjFSCbikCinouy
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(23010399003)(36860700016)(921020)(10067099003)(261026140227099003)(56012099006)(11063799006)(261026121527099003)(261021123027099003)(261021135927099003)(261021121427099003)(261022105027099003)(261102123227099003)(261028144727099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mbMVd+2TreKegcf6FMoE0PmHVquyshD53IsN8q42gecQ8GamJrpYyqfjvvhsj6qpQE2m/b7r/S4Jhr+HQCtXXyIi8FNgznCoqRPQXCcXqeay2FUgjm2E08Ywgh2hYvXP6kDUlwX+yieq8bOn4fEcjEsPPfpm/KpKy2QAZY6wnEvGZiRAWIITAXL9q/m+AV7wnvmb7XH94STroWxHXSjWgAv6Gr9iaDv+QMKFfV/VDnxn/GLgggpAlybYHP87zrryrvlqjv/n5db5NXiuX8rLrKXbkmH0gC/9cjNZZhJJk4grY8LCLLu/0/t0YhI4VS73tPNbKt023OwgWKLKBY0dyvVZ1mjB1HLxu55jE3HhTUKF8yagd/q8VzM/GledAPqwTx9p+57f/tTaiiywxu2ZQKchRiwoZvoEK/Zs4kGBN4LIWm6J6KSl0eTCTGlG6pd0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 00:32:49.1968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf1b255-754e-480f-78cb-08df45d4a3bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0006C3DC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7021

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

