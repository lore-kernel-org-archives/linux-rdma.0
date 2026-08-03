Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11023097.outbound.protection.outlook.com [40.93.201.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AFD381B1D
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785773507; cv=fail; b=MP7VMwpxqwWJSknBjOJ+0RINNDnBNalx0WLBx+929E869RIUYTnjYj17l8GMHYFTHsVIF2tlh7FqstEEkROhVpHk7O2kkjHSzI7sbFe8ShDkCOXg+Tjf+xGe1vJ7jVW4YplTa3FHXwDrS5K1oGxh9ea52E/Tpi99WpWUkr3EbnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785773507; c=relaxed/simple;
	bh=D+pe/irlr7uYN/IarkqbBUT2sH83DqvSBVo+DUI9HDA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tCICrBvLdTVHI9CDHT2tjBNbzO0yJP+gysz3JQFGRvFQU01ElICUHFEBffF2dfImL17gYiSl4BWEqVZm9ju/553XNj//h4TxCaXgM1LKOf071pSnTSm2dGzoP3HIx+HKSaMKctTn0xTCRO6rMoX9N0xT7fDLBBABj4wvoHA6i90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=dnGDplPB; arc=fail smtp.client-ip=40.93.201.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="dnGDplPB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qwGTyTijUUE0ffyzO9Vwq9u/gmUz2zyQnShIdUeAdHi90lysPpznyXrCC80ZebE6PrFlmNtY/RaGKRYfOGD0E/zyUclTDjfwC5Iw5+Q96RQBfI+9gciH2VyeoM0HI8Oj5+FR1KealyZ/oGxJ2KyMpfTT/xiq4xaexrCsuw4Mv/KHT9T/OWkQHv0zmy8PYbUXEQ7gR9GVCLLXhNio2VJbw8hvM+lx7vrWjUvNddN6jkHET3AbFse6nf+E68j9NTfynivGisqE7BXKmAKZz+8SxZkSCXEpTVyab3PDQ4Zs9G4K0NjDPb9U+YJtyw0tuhtut1PNr2whyuShwEehHkKGvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QREb0o60mpCbwCbm8F9u4yRDrzUFB18LDk126SVU7dI=;
 b=UDnRnBcL0K7N4mMTY/lpWULtzsdI4cB6gqN2BRmwzolG0B6p3qWnh0ry/fA0oDAVGRM3G+5wG7BJUOq21G4Aw/Ak1AxF+iLgSZdk4xW9Eqhk6lCPBPBOo0sni+PNscudXFpjsbmUOzK743jhIWvBxK66jcwxLzXv67Tv8SHi8PL9P0cKycE/4kS706z+diM9IQ3MZHYLkjDaLY2Okm+mdHLaij1YJD+n8FmUlRIfbFwaSXxIw+7mGg4hgDmx5G+d8TpozUWX6juHCcUXTjjLTPUKgD1+gExWhZtNGCR4w6oFh/RCPcM6VRCm5/y6gBHJFDzreqFfo62uNflEpK65Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QREb0o60mpCbwCbm8F9u4yRDrzUFB18LDk126SVU7dI=;
 b=dnGDplPBTRmnEH9jkTK5aK/HtL+9A+DoGY49ehZEJBkMw+cKZMb/iNPMMvfZQboCBcWyZXOfH+4bynWrJ4auUrHzFOyHV8BewiLk71zcI0GfNUHFkgJje6fNZPdz6AIS6fmGGyCrmLpkYqNRsBRLI315vCXa6wGnn3LLzkxfFhv8CgS8yMJHNWE9qvHfavExr0EnWoBJuUTTs+0//oLTJZiB5HIRSKc03vlnpEFxfXzXdpncG+d97HfKYkUL1QIWhX0Xqrxi5QGnJfXH5e9UUftU9TI8z46c8IBk0p47Ed3kkmdTkv371yUwKR1fKtckFcUU5ZMbklJ/CIz2BHjW7w==
Received: from CH2PR20CA0015.namprd20.prod.outlook.com (2603:10b6:610:58::25)
 by LVWPR01MB994700.prod.exchangelabs.com (2603:10b6:408:3c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 16:11:38 +0000
Received: from CH2PEPF00000149.namprd02.prod.outlook.com
 (2603:10b6:610:58:cafe::65) by CH2PR20CA0015.outlook.office365.com
 (2603:10b6:610:58::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 16:11:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=cn-mailer-00.localdomain; pr=C
Received: from cn-mailer-00.localdomain (208.255.156.42) by
 CH2PEPF00000149.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 16:11:37 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 87BF91D7180;
	Mon,  3 Aug 2026 12:11:37 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 8435C1810DF01;
	Mon,  3 Aug 2026 12:11:37 -0400 (EDT)
Subject: [PATCH 9/9] RDMA/hfi2: Remove stale hfi2_destroy_qp() comment
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:11:37 -0400
Message-ID: <178577349751.1793053.11514533065353361217.stgit@awdrv-04>
In-Reply-To: <178577337105.1793053.12662894969464495064.stgit@awdrv-04>
References: <178577337105.1793053.12662894969464495064.stgit@awdrv-04>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000149:EE_|LVWPR01MB994700:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cf437b3-957d-4f31-ca3a-08def179e5b0
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|1800799024|82310400026|56012099006|10067099003|22082099003|18002099003|55112099003;
X-Microsoft-Antispam-Message-Info:
	FcKO38xD5SJZrRWayxrwdt9qxjblgSdZHsp4V1SNSiqENt9/L01IeGNS/9qSxIM3ZaLAocVLJ90vo/G3NDqxEghpMy1pRxFgaQ4YORKDv4j+L09YlyWYv6q4DXOZ75rJZTqlrR+Ge676vJNrena2lUOxDoyZHsjIdjh3/2rkoqqNhf/99A3bW0cbgWjCrs8433KVJ9/nf/FPol1OjiNR5LAL70f1MopVxLlUQPtxklw5YF+4JCYA0UwA8tkQCbIODJQTNOj7b5Bphj/CHg5aHS64CuF4qtdIsgifOr8HUeW/Wl5wvnFRdpmy79RxhtEKZdZgVRoyMN4FzBXXhKWKVXb1yNx9rsxK3Jf62eVgeNdG2p3IdVtxqQOq0IAxGhpJ2F6opgtR8W7Tj6hk9DPY9xsjsF+3xopVdRCp2l93pqkGQft8hm7CvBlkp8ja/gt8v2Kv4L3mmPnS26n9VM1HjO+oA3VSrP1e9duKrypkb4XEBUx3G37UCi6xH/nxVd4XjrsgdqWKYqF86Hok5Iq77td1WPIIvZwGFlGEUuG8HML9mnDCRng1Scl43aeoF27lSedetn5k4pjFipxwIkvrn/FuHYF7bkJzjR/izGB0Vfvof4AfRe47oveyWv6oRP20B9TtRX67c0ACtaYvcZhc9FHAhyuYg4X1yEkn6WCDTQdqb14yqtSvKW7OQoabDHaG
X-Forefront-Antispam-Report:
	CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(1800799024)(82310400026)(56012099006)(10067099003)(22082099003)(18002099003)(55112099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ln0KPrPjAzmdzrXuPND3rNKI0fwtxiJy7K95Al9/B81xyZA6ptsNbBM89VGhGFrZbfO8/hNSOtkO9mwXVgwzWiAhnP/gzHhRjamYsvOIqNTlgAj5Eko9JefYiimTE3b8rQhVnzKi26PhsfzF7gml7pe38fK4ISlmjQFzgqjudhYz6E+YYJUTs/cztE5C6jMyb1inRHmwSHp0UqF/CbA3Fm088P+tUJ7WRFTkmAu/hVFBwUXSc4xEtBOoYfgLj3P7WFoXkHIKnTVX3HdB7XYPCpa6JnPomzKk8MT/P6F1UmhbjCfYDmI4a9mnua+G/c85K9fpFS4EF0O4KOFBcwpPF1kmhj1I0ADR3YFArsXgDauJO7ijAwcqI8eGH3oLTfG+x7AuUwpzlPR2cNami7uRDi5eD6AF2Y5hPAqs8unw2LrSuCFzCHFod/QwTHgP+u9i
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:11:37.8759
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf437b3-957d-4f31-ca3a-08def179e5b0
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000149.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVWPR01MB994700

hfi2_qp_wakeup() has a comment referencing a hfi2_destroy_qp()
function that has never existed in this driver; it is leftover from
the mechanical hfi1-to-hfi2 rename and no longer describes anything
real. Remove it.

Matches hfi1 fix adc09d7fbbb9 ("RDMA: Remove outdated comments
referencing hfi1_destroy_qp()").

Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi2/qp.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi2/qp.c b/drivers/infiniband/hw/hfi2/qp.c
index ad1602ff45a5..2dc222bf5963 100644
--- a/drivers/infiniband/hw/hfi2/qp.c
+++ b/drivers/infiniband/hw/hfi2/qp.c
@@ -414,7 +414,6 @@ void hfi2_qp_wakeup(struct rvt_qp *qp, u32 flag)
 		hfi2_qp_schedule(qp);
 	}
 	spin_unlock_irqrestore(&qp->s_lock, flags);
-	/* Notify hfi2_destroy_qp() if it is waiting. */
 	rvt_put_qp(qp);
 }
 


