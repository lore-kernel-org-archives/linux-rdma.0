Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012033.outbound.protection.outlook.com [52.101.48.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6A04EC65A;
	Wed, 14 Oct 2026 10:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791974862; cv=fail; b=OCjtI0sEBdLvJYWA+YK0nWihmHF+ftlcN3SjXZOF8X089Duo5i4E4rQpgnVry/R2Yx6UbISSP/GVt9es1QcELPIA7llhnYLtpKPedaJnT9hpiR4sSUAxi7a7fWxeyKvMQjxtfaBBRboSYH5Pv0fyfsYv12C1d9PD9A3WBX4klGc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791974862; c=relaxed/simple;
	bh=odoFGYOou8mhidm5ZHPeyIVTuK8dpOX8IWOfLY6CrAs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=kkghOd8drQtsRqdnjt9wAbKjhQZhR3flSVP+UQaPeHpE+Mq3T9X5lWqbhforycTMfpnMJz0irFPmGPFGLpWlJ+tlqdyj5UcR5iJW/7dxCFEn1Xo5Za6wnQQGzvRbaqWiu7OzY0rn5Z6UA5ubJDtjsMaRBWlwVGxFe2zyJxB6gmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BITawuU2; arc=fail smtp.client-ip=52.101.48.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BITawuU2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iST8GBE3CWjPP/iqQtgVPefYniVkk85AlIbLXIjpE4rtAcu1/KpzesqTq9tcyMqDKoPjB2zdpa/5WUSd7BrGC/shLOyoEXG8rEtzhCL8QXkMe8vRM0HJIVzcR1XcQZccZiHv38NdidpimUvkXZ+NHdbKEGCUwK/hTu3QRMp9SAXtPQZAGCOe0Lr8zXGLG5AflVc+Z4ICL+x3G8DT/xWaO2zi6XtEKiidfUMTbg2HsINlJ16lIbWzT0vV16+45pwnrKrFLQTILPphcfl8NShNLmYOS/PHQvEi4L/o8EbARH2G1ZP9+V8IjHoowm+02NM/WVaRnmcH59gtNDrS78gTCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ynIcakyXNPj7GTaffTTuB8SROeqKRqQJ4CUaitfYUS0=;
 b=OE7C2gGKP7s4SIx4IO9+MmFs0h9rUb88OZJZEVyh8k35ts99Yuh7knTlOWQUKgKRIcYgN6tUZQPgRfkWZ5qa3Efm6PGY73Wx5PhWgNt0BKsS3kC/5hg4tWvWSCpoeBk87GG0E6/8Hj3vq//4Frh2qmR3ssUj/0kOjSl66tigRu7iQ18RhcV9i6MItS4ZFnxRy3ZuoYpAW5bzZm8aQzoVa7fHLuBDI9n47iVDPYMhvaGi3Cmea/3/43154P0iW8u3/JGr8DiTuzpxj26++t4gkW4R6VvKx92bw+Mbzkq42MbGLwyS7Z4BMmBnrcZGRXAPEk16PJpyNJbmibiYLH4FNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ynIcakyXNPj7GTaffTTuB8SROeqKRqQJ4CUaitfYUS0=;
 b=BITawuU2amVoepwOz0+l+vCWNbkDK5yjZchFuZFvR7lf+PA5byXZ/7pCCmKLkPgveGQLBL1IWibLgf3IPNYjVJl5LL3rjp+VhT9LTJ/BgQ/VVEDrPZZ9C3UXMhDdsi9DocByIVjO8irbc8rdgCWarl0HkZlfItILA7Kb/+byPde/KB6kA2IybPCCvr7oqMZKFFUEjFwpK5Uc4+OW5F1IOawucoXPgE/4/TKCIwE0IlUq7dafGYo5r4Rj0GSKQVjVn//4PGFo6iRdrPiiBUZ7Lx5jt/m1tQmg9aa+lxqQvYrMb4prEgQhus6XP1MolPALrV9zg5TCaUlEvutjj74dJg==
Received: from CY5PR17CA0024.namprd17.prod.outlook.com (2603:10b6:930:17::33)
 by CH2PR12MB9496.namprd12.prod.outlook.com (2603:10b6:610:27e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 10:47:37 +0000
Received: from CY8PEPF00000050.namprd05.prod.outlook.com
 (2603:10b6:930:17:cafe::af) by CY5PR17CA0024.outlook.office365.com
 (2603:10b6:930:17::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Wed, 14
 Oct 2026 10:47:37 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY8PEPF00000050.mail.protection.outlook.com (10.167.247.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 10:47:37 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 14 Oct
 2026 03:47:25 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 03:47:25 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 14
 Oct 2026 03:47:22 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Wed, 14 Oct 2026 13:47:04 +0300
Subject: [PATCH rdma-next] IB/IPoIB: Cancel normal flush work on device
 stop
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261014-ipoib-cancel-work-v1-1-6c0faac016b8@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAKddz2oC/x3MTQqEMAxA4atI1gba4g96FXFR26jBmVbSYRTEu
 1tcfov3LkgkTAn64gKhPyeOIUOXBbjVhoWQfTYYZRqtdIW8R57Q2eDog0eUDbWvTTO3qradg9z
 tQjOf73MA8V+Lgc4fjPf9APqlQxxuAAAA
X-Change-ID: 20261014-ipoib-cancel-work-1d526f705a9c
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, "Roland
 Dreier" <rolandd@cisco.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Carolina
 Jubran" <cjubran@nvidia.com>, John Popplewell <john.popplewell@nmc2.ai>,
	Cosmin Ratiu <cratiu@nvidia.com>, Edward Srouji <edwards@nvidia.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791974842; l=3378;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=zxviG3HaJ2NTMkP2uM+WzKxJ6WYQHlq33U6aLSdsLtc=;
 b=1VpwwToC4SRye7scJKcrz92/GOidvt82NZ7hgWrfiCj2KHQ/bLdpLkbq6KkSS0SOsYGRl8IBV
 q7OTvMP8FgaC7GB6u+hZN0q9VO3iFpHUywMR5FtpFWkhy5YkVP6qWte
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PEPF00000050:EE_|CH2PR12MB9496:EE_
X-MS-Office365-Filtering-Correlation-Id: 113887d3-ff35-4d7d-d450-08df29e08ff6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|36860700016|82310400026|56012099006|11063799006|261009223027099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PrPzuHdjWgy+dxALc8/Qgrc3quoAKiVnh6lCnTZ1onpSUIGDYj69kgbVTtxwUTHejCxrMgkqECQmIWMky9qoNaJAKwheWu7YE7dlPfX00LDjFYmyld306SbXHp85QzIx/a0cBW8TYdUCmCr4gkuCGrMS/sFMTu9Wx4TAjX7oUXRck/rwMJ7J3HQSs0daMH9I79lnnQtMEy+3s+Z80aQfFm6hGxR5MJrFZIckAOUwCiAWCR3Ro8Sx1M9MslIpqYwjxJKQZfg0eaXaC1yYQF8b/GqvOCqB++JOF3o2W8nSyU5HuVa9rnTwdWoni5mCmFnK76MGP6BZseiaxErlCA5/zDeNQ7FH1+3p+nVGhtvZMOJRWUaUSvZwtRgrShFCPeI7H/kv+dgPtAyvAE+1NqIrs2Ko2fBPCUC69zVXmSThkEwWlnvlZubDboFRpZd4C6NyYjA4gCeEWRZ+qeghWQZ0PDW96th4nAssz58d18bv157511EEY1RiZ1FyREgqVPqn4jdG+9+4BYNxxn3a02yZ06JXmwDdi4fIkAe3urYIb8gveoRx0HGKkpQ6e3vO0gaC4nXVDsYRSL15RPgd9oShtJZva3pczvpkkmYTL3JXSxcqisEtFOyEOv9NN+bDhYptljpUQ2jqxzLDjgjCEyeE/KOK+SfxxEEcnpWSTvyDKWQjkAx/FtmN//kMbxtpT7nxM2NoOPGkYtae8cKSNM+RGg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(36860700016)(82310400026)(56012099006)(11063799006)(261009223027099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1LSjL8fhB6dwAcf9kJNpH5+FqmGsV7Iz74eYNag0o02eP9pEFEWaFyGeG8Zs9coOZn/FB6kozlsoqNRoJzgB/64ovL9gOybCvszexORH7usAhYo2Yi3TRJN0KFUxMA+UolTnsTrTZYEZEtlsF3/Cgu/u0lBCEN6U8TxPbxMVq4wpq0kodjRZ1smgNQNOsa0IRPWVSy5TGr1UNqDfqllRZDUtHBg2NZL5CvLj+s86DIZdD3Am+0PUDz/pjbd0k06qtHbK4mhVgQ2gy7rj28rRbfYx8rW/wTAtYT5ErkHgp2XB4D+q/aDPsjxwouIE/QsA7rK7QQIPNi7f1inl0F5qLGFnqRbYNIarU7+8PrH1woxWKYOjEQMIWKHJ7bFUnv2uuEHJw0iPB2tf3aRf3PcyOPvyTylW8E6fDTcSXnZglGubYtVsYSP9lcjhGIFFUcOS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 10:47:37.3381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 113887d3-ff35-4d7d-d450-08df29e08ff6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY8PEPF00000050.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9496

From: Carolina Jubran <cjubran@nvidia.com>

ipoib_ib_dev_flush_normal() can race with ipoib_stop() because the normal
flush work does not run under RTNL.

Before commit a77a57a1a22a ("IPoIB: Fix deadlock on RTNL in
ipoib_stop()"), ipoib_stop() flushed ipoib_workqueue after clearing
IPOIB_FLAG_ADMIN_UP and before calling ipoib_ib_dev_down(). This ensured
that any in-flight flush work completed before ipoib_ib_dev_down()
performed the final clear of IPOIB_FLAG_OPER_UP.

After that commit removed the workqueue flush to avoid a deadlock with
workqueue tasks taking RTNL, a normal flush can continue running
concurrently with ipoib_stop() after IPOIB_FLAG_ADMIN_UP has been
cleared.

The flush may observe IPOIB_FLAG_ADMIN_UP set and continue running while
ipoib_stop() clears IPOIB_FLAG_ADMIN_UP and brings the device down. The
flush can then call ipoib_ib_dev_up() and set IPOIB_FLAG_OPER_UP again
after the device has already been stopped:

  flush_normal (ipoib_workqueue)    ipoib_stop() (RTNL held)
  ------------------------------    ------------------------
  test_bit(ADMIN_UP) == 1
                                    clear_bit(ADMIN_UP)
                                    ipoib_ib_dev_down()
                                      clear_bit(OPER_UP)
  ipoib_ib_dev_up()
    set_bit(OPER_UP)

This leaves the interface with ADMIN_UP clear and OPER_UP set. During
device removal, ipoib_ndo_uninit() waits in destroy_workqueue() while
holding RTNL, while ipoib_mcast_carrier_on_task() may keep retrying
rtnl_trylock() as long as OPER_UP remains set, resulting in a deadlock.

Cancel the normal flush work from ipoib_stop() after clearing
IPOIB_FLAG_ADMIN_UP and before bringing the device down. A pending normal
flush is canceled, while an already running flush is allowed to finish
before ipoib_ib_dev_down() performs the final transition to OPER_UP
clear.

Only the normal flush needs this synchronization. The heavy flush is
already serialized with ipoib_stop() by RTNL, while the light flush does
not bring the device back up and therefore cannot recreate this race.

Fixes: a77a57a1a22a ("IPoIB: Fix deadlock on RTNL in ipoib_stop()")
Reported-by: John Popplewell <john.popplewell@nmc2.ai>
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 6c14246befb1f96483a1c634e533a60c0b171fdb..f0b72d65fdeb71fd1b9680b90342a5a756bcac1d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -230,6 +230,13 @@ static int ipoib_stop(struct net_device *dev)
 
 	clear_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags);
 
+	/* Normal flush runs without RTNL and may bring the device back
+	 * up. Cancel it before the device down transition.
+	 * Heavy flush is already serialized by RTNL and must not be
+	 * waited on here while RTNL is held.
+	 */
+	cancel_work_sync(&priv->flush_normal);
+
 	netif_stop_queue(dev);
 
 	ipoib_ib_dev_down(dev);

---
base-commit: d37e98844afea39a9614cac0de837701263c90f7
change-id: 20261014-ipoib-cancel-work-1d526f705a9c

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

