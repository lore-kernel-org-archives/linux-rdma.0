Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.26
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658510;
	b=K420Mi3+x7b6t03kTZDC+IWiWbTvau3G8xzrboZtt0cy6dG7fk9KPjQnTwptFR+Wogy+
	 lQwlx0BpftrdfYRhldO2uJ6JgrxIP/N8bIBeZajWtXai/e4cXsPcp5r6O0DH/tosoiMgC
	 yvpil7newUNJRWxYhJ81NSfuNYrV1/Mg0iTFI66NBhusNUAKo8kP6Uqvg1eDBiV0xK283
	 k8DCXhEJ8AycI+sYQnWNGE9JUaHdVUOxNg3VQTZbxWvWygL8mfZdawXs3gWzhgu7O/M5u
	 5SCWTHts2jJhVc2Frsn++Bu88wBJ/DXytzUp6hb8H3mF6gJJWxhqYw5fUkepalwK2Hw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658510;
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
	b=LuvGPSpKylz8WpJSCu4c3LBqlzqY0nG42FCszMWlkvA/asEXp9TulE82t3WL+ptb4Yir
	 W71XT5hxmjILn+qDzGSs3rvwxqjWT1xPXW1or8d2MFrTlbK2flzGjM+Im5A2SqQpoSxOo
	 27g01PfSG5ms78rHWJ8p3L6g88EPte2x8YE5pB4F+eKpFrjSxuh2K8ygvZaNcp2vS/N5z
	 J7DtovqFuMQ8Kt5A2t1nzITEY61SBJ073hW0gGEQsJzBViz/dVfVXnOiZnRG7ZlvDX5d8
	 XcF4jV1C5vpjZUq0maSz8WN4KlAGOKrvtd/ucaKxsZqE2tBZNp2Z7Yiz4qs7oZmwcLg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="2f/Z5L0a";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.26
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013026.outbound.protection.outlook.com [40.107.201.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39E0606D802;
	Mon,  2 Nov 2026 22:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D39E0606D802
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=2f/Z5L0a
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SlpJMQXtsen72p1dWflgE8rJsT/cCo2UoGUPJQvdMYQndbEEQfY4yVKDSZBC/DJWoxW2e2HAe90l5P3TODB/9iE6JUfC1JPL+33pD02K+BnFwrHNgq2pR3+1gZdZdh/GnLLSUquzyoo8MOBL9jLb2yM0JbJHuGeerjkfxrmtubvk3hoacFPges/IK6VZzVyhSlH2YlleUQ+xyx69WeAMFlsJqjyKX6FiJ6ELlG3knm1dUZSRdotPA0QkW9M2BOkYAWbEyu7UJ7fMLhqRJyPIaTI8Szkq2qyYotlJBul4SHypsUhr3FNxZkal8cswCmmv6GR+mpHw5Q4HwNTxZt+SrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wuKqU2tXHfG2rHcrThqX6FBB6nh1Pyh0K/Huv/vPmxg=;
 b=NT1016eBQO8PKpn+rkNF+dkurK3dgH5A2b1onLcbZaLm2I26rcD0NzO4T4f68c2CPvvp2t4TBDG7C3OJ9dIH3DdprlK0oV6XVKxPXx6T24Te88XF8FTUkoaYU0hfQED2UwDp/0VsPGEAaeWPR0DfGXCjXBCh60CiJO8QIYQJNjG4Sh+8y7ISubvNtoN2QYNDlyoAa8GmWNNOpHX0us6VbijFwMrGaT6Kc75/pSRJPanN2VTJJuPXaCMymbbISLDUFLrFnS2zF9CtuJ5PUikUR+pClV+oHmrFNrvgmG1xfx75Hj9cPOX9RYvpdLM5E2v1ibJlFKDPHF9Nm51dd5j77A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuKqU2tXHfG2rHcrThqX6FBB6nh1Pyh0K/Huv/vPmxg=;
 b=2f/Z5L0ay1zC5+p0tTmKRJRMDK7eJlysJ5v1ELkvXvAaVMN77biT1Dl8roXUNBTwgg68egqnyJFRoCTG3EjdlfvfVsVhi3yC4um2xrd4bHXxwkQE5JPu0cK6wCtq5SEoh9d1BumbEmCnIdVWwlv5S8I229XGbD1uxFIbUEQEbNQ=
Received: from MW4P222CA0024.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::29)
 by DM6PR12MB4155.namprd12.prod.outlook.com (2603:10b6:5:221::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:28:20 +0000
Received: from SJ1PEPF000037B6.namprd05.prod.outlook.com
 (2603:10b6:303:114:cafe::8) by MW4P222CA0024.outlook.office365.com
 (2603:10b6:303:114::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.12 via Frontend Transport; Mon, 2
 Nov 2026 22:28:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000037B6.mail.protection.outlook.com (10.167.244.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Mon, 2 Nov 2026 22:28:19 +0000
Received: from [192.168.0.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 2 Nov
 2026 16:28:18 -0600
From: "Nikhil P. Rao" <nikhil.rao@amd.com>
Date: Mon, 2 Nov 2026 22:27:40 +0000
Subject: [PATCH net-next 2/3] RDMA/ionic: Use the ionic command timeout for
 the admin queue
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
Message-ID: <20261102-b4-ionic-cmd-timeout-v1-2-2f75c2d0a0c7@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037B6:EE_|DM6PR12MB4155:EE_
X-MS-Office365-Filtering-Correlation-Id: 1943ee48-3863-4550-a19b-08df3930991b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700016|1800799024|376014|23010399003|18002099003|22082099003|10067099003|56012099006|261102123227099003|261009223027099003|921020|261022105027099003|261021135927099003|261028144727099003|261021121427099003|261021123027099003|11063799006|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	OSs7FTr3XDuQZmNBsm5zmZ0npSa3AlM+sx0ab3w8VCdl4ZEC2nK0ix1T+3F57o9XqBTCHTtbUwBzyDT3EnDXIAjpE2Mp4Adz5oqXnAEPMFEZx1k9ctFdFM9sYvIo17wzti8hLJgkfkJkyL+GV84DxMpXyWOPoAaqHvtv1/ue6Jj12xvrsaAbT1qS88/Bugm+vydWV++uH73NGsKCfPqSdVR5Nf3XETLcsMZ5n5vLZEjxgJOBm928dCUzThdLmIyDSHA01wqEBJOlltaMiQl1+rVZeQb4rn9dtGJrl089GKwFAAiGtkL9RKSRXpDjiigbsk6xYoy6HikOYVTDwoKeCZSNVTNchY86C3veeG5BWvdhn91U54mqUtXgGpuaC0oKpY1Xy/ALDLBFlcHYbIxMztRAElXk9FVkwV6xDOqWo+S0RTxFninHdGMDbUKab+m0swZUAqIALWWBvxYLN3no5hC9OEdjN/Ht+AMMKJuXzaWWfBNWaFsugevm/m+J+53B9vp/+jT0zp+fOyJxB5XJUJWR1q27LbUABGBeX+HEdrIqCRQ39+thg0/QzzgGudFl85KqEvEq7lfPcDnlzG6mn+l6bVNyTdbVWBpjXKaYaffp2SIBh/H6rf9u/KgVlb1QRcdiTWjPRtReUh0Sqg2vcq264+WfNGmAlR8zCEkchdcxK1PDGuNxPqj9MJCBBNJ0GlJsrUheGE0YnRffMTWVyF9CSOdlWWyGm2c5lEL4Mh9tNZUkIHc3DxmmTf2z1gYx
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(261102123227099003)(261009223027099003)(921020)(261022105027099003)(261021135927099003)(261028144727099003)(261021121427099003)(261021123027099003)(11063799006)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Aaj1FKJ4SvdqIKIjU/ZftNN7DQ6BuL3SboBQGD5BRu6fJYZ9UnC9yk4QPmk5lGhYraHnUVnAvS2bpWLHHfCFM1MQHYQLo9zFpv7/O2UbcJklqLc6MuVe3aLQZViTeoSRjTPwgHfYun3rRd0oedMPKhDvt+P9cTEfDY+Tjk/8IW8gA4SBbKKEbUieYvwJbx9AUnj7DHAthiPK++eWwvH3Mcjr5xgyi1bQYWxfXIa4ZxyuVr+DyRyekHF2w1EUJi8HVmQYcfB9WqARGsdR0ZSgVg1zNOZmSwi5qYIPmqmZcSDjGMEsNFBgKvnPcoAF3+CcU02zTzsdLZpe6QfEjbuwMues8ILlp9l7DGiGcU15GAHm+il2p4M1Jnmk0pNAbBT4G3taK+9gxX1TRzhfx1Ji1GUJtJBV6aNN6oSSat94fzGK4zLsIl7vgUbKM5AP4jm0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:28:19.8448
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1943ee48-3863-4550-a19b-08df3930991b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037B6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4155

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

