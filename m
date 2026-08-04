Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010054.outbound.protection.outlook.com [52.101.69.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB41426D18;
	Tue,  4 Aug 2026 21:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785879324; cv=fail; b=JJJCe8ns/EMQxWje9dMDJ8AmWkYeQ7M+By+updm1bliU22T24N8Gt7q4RMc9VEL2w8kjSqY/8+Lt0WcSK83UTWqGvKE8ILF6AM8A/xRqE7+OA37DgDYPWtazPiX5pRi7+foR4U5FlwMmQFESEzoCFIo9QjpznD1QyWFJzA5jUgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785879324; c=relaxed/simple;
	bh=/92eRHjQInCH3SyL1t03YgoE9ORBelvj/EDrRzwy5Sc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVMLo8QHBXCogpQmhd0HsbXfZ0LYf6l2OhSzu9MlzmaOLrWXo5hrgLVmzp44K4T2SKIGYpUevHNOaHBj/A5hVcUz0jK8G6+9ef2LA9rMDT5Ht5+F8+vMOA6B9olW/u3b86OdBdHNvUgmHKjnVFzLWwH1rT6vYd5aoNDHUd5KpqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=BldlrEg3; arc=fail smtp.client-ip=52.101.69.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="BldlrEg3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VAWsK2dM3G6Hi3uJXB9Opfy60FlRf+8bbKGt8JKsKkFK5jR4quEKMDiD9b1H7iWppPg/2caK3bUY1PnlJrgpVthO+SttPgUKnJfKzSdLnW1/X3WKaTdcwY+d9GG8N/GVcPFj+Y1vYJAPgQCCSUwN2khFZR/qWhnfZGPS6BtE/i+dJQGqr3In1epbB2bLbOwGZSwQStcILpr6jp6X6j4FxuCUg5JANtMK/M2LsFOkIC6KSNbOAIZFKAx/4uVqK3BqPbOgYliZeM3o9A7qswhfHGqKXDx/Dp9HF1IWbggXUbNbXzGFnC7eTD7yQFMYT1MvviA5z4xUJqWVqXhK6BJgaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbJC25GmM3Xpbk9kEzYteSCbTjNFqqiKKLAA+00BXS8=;
 b=HCDRPm/rTwt6zO4zVKW4N85UpXEo9S8AJZS4c/ero7Gl1QzACfmC//N/qjSZMOrrQWVX235ARMgqTfbHU/kfUeGik11UZdupEgbSC7vNLxuNDe0dF9GC3YaOVTX1OwWbVfs2LaMeBXLHmV+HT8OrWnngjECo53y/1o35udSF33Mx2DVvnBsCvFg17Kjsg29yR/SJ0IZS4XC1tCzjTcqlwQbwGuMhRDAvStt3ch4uehhHDrVtIc58XXyEw5Oe8g3791IN3KPrR+0RvZEUuQdFlDbVhOyv48Yma53PD50GmAeSNpil0+A8xp2oWyItLSh3iJPZhVZgm2TvK5SFSX5VSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=apple.com smtp.mailfrom=nokia-bell-labs.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nokia-bell-labs.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbJC25GmM3Xpbk9kEzYteSCbTjNFqqiKKLAA+00BXS8=;
 b=BldlrEg3C+xds8chBiIeVLAQwBzb3JSBTee0vdk6AaLbrljBQlLyg1bqXtivbMfKSAN0vRM5i8mFTj3llLnq1jn/Cn2J7tV2n5we08meeWTl9W1wUIdgcKOjn6SwgC7Qc0KA4wGOmoDnqm4bUYeKPnXuFKhax8e5XL3x9zh27bBmwabBbqNtyGKZItSMIgKWyw+E0oj1P1FWagmqvzt8Zsow/eNa8GqboFvVNRrbPfa5bg1lJmUSo9Jtt3Sz5ZEBBMgDn2I4YCraobau71cd/vCOsVS9MFkOA6o3dI/EKZTHjLh2vm7oEiJxMfNpOLyEoHY9pcJZsWv3ICGx5tmWYQ==
Received: from AS4PR10CA0024.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5d8::16)
 by AS5PR07MB10521.eurprd07.prod.outlook.com (2603:10a6:20b:6c2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.16; Tue, 4 Aug
 2026 21:35:18 +0000
Received: from AMS0EPF00000194.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d8:cafe::42) by AS4PR10CA0024.outlook.office365.com
 (2603:10a6:20b:5d8::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.16 via Frontend Transport; Tue, 4
 Aug 2026 21:35:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 AMS0EPF00000194.mail.protection.outlook.com (10.167.16.214) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Tue, 4 Aug 2026 21:35:17 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (Postfix) with ESMTP id EF2CB1C0042;
	Wed,  5 Aug 2026 00:35:15 +0300 (EEST)
From: chia-yu.chang@nokia-bell-labs.com
To: shaojijie@huawei.com,
	shenjian15@huawei.com,
	linux-rdma@vger.kernel.org,
	eperezma@redhat.com,
	jasowang@redhat.com,
	virtualization@lists.linux.dev,
	mst@redhat.com,
	xuanzhuo@linux.alibaba.com,
	pabeni@redhat.com,
	edumazet@google.com,
	linux-doc@vger.kernel.org,
	corbet@lwn.net,
	horms@kernel.org,
	dsahern@kernel.org,
	kuniyu@google.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	dave.taht@gmail.com,
	jhs@mojatatu.com,
	kuba@kernel.org,
	stephen@networkplumber.org,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	andrew+netdev@lunn.ch,
	donald.hunter@gmail.com,
	ast@fiberby.net,
	liuhangbin@gmail.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	ij@kernel.org,
	ncardwell@google.com,
	koen.de_schepper@nokia-bell-labs.com,
	g.white@cablelabs.com,
	ingemar.s.johansson@ericsson.com,
	mirja.kuehlewind@ericsson.com,
	cheshire@apple.com,
	rs.ietf@gmx.at,
	Jason_Livingood@comcast.com,
	vidhi_goel@apple.com
Cc: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>,
	Parav Pandit <parav@nvidia.com>
Subject: [PATCH v5 net-next 1/2] net: update comments for SKB_GSO_TCP_ECN and SKB_GSO_TCP_ACCECN
Date: Tue,  4 Aug 2026 23:35:09 +0200
Message-Id: <20260804213510.673084-2-chia-yu.chang@nokia-bell-labs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AMS0EPF00000194:EE_|AS5PR07MB10521:EE_
X-MS-Office365-Filtering-Correlation-Id: b683c7d6-e863-4869-0eae-08def2704738
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|7416014|1800799024|23010399003|921020|10063799003|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	IWSIc3NPqkk/kiPWklZtoTXAWrjgiBWD1zo0q336sTn5Yc7IlkFz6GUkJkgAnYo/3vethVWKrQoGqisMnBzCTbEIxlp7yRM2cKlRmnbVtPYqUoOb+LOUknKaVjsUsScBuXAieMmWSiGACluuQ+1qlrt82kJCKIqF+Qpk/0hvJFBq2maI1UZCyVHnOONiLzj7BDXfFvwn5vHCg1wmQYubQ2fKBohyMO5WvyXWOUIRKCto5NC8U8+iOh/+vDljtT7fAYMJx2P0lm6V8OFMkHpMIH09b2I9Y49vrrHhWK7cLxMnJOW/J8q5k5WFWjbWuicSoV9kZ5ERaJSTTePe9lBAv7ygrm/87ed2nt2AWnJVD43xp8ireS2XiXwYbkuTZKpqUTBlxlYZFvYW9YzdQ8h2Z8CvD0JaEdybXGdeRJbS1IQ7dcek/ASQFPday+W+VfIC4PK29/Y30JT7lR9X66oSuY4ChjgOYGFALxTnyY9kyr8BNGuy/5Kaxui0vkdXjLlVCYjqO6z2xqYPIHNH1GkwN9HesqW8oNNApO8LPxZNkQXmKaxICvJysPRsmSVISgWvlyCxAMf0H07hmxn2+CVEdg3otaahdstyfuI1pXuRdluvASeCNeLPdHeWRT0yBohJDP1/PnRTZvi6G8nIiYH5TJ15wbW4GtGjr5Kc1NTKId35tMQNtcVF/9Yjjcir6TbeKw+gFjL13jwTc9cUICHObEILG6HTtjAHIxP92RJLg9zUN0qx/WfxpUW8OdTaXhhW
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(7416014)(1800799024)(23010399003)(921020)(10063799003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yg7ph/fBTz244XFZ5Rye5KyZAUOeTE3r4+c0GFEGIgpzqN+jRb+8koFiKftk4s99//ra8HjGpwf19Fbm9L5ENMr/cgJ79BNtye9PZFDMO+rTDPaCkDMI3WsKORtpKIoyLNSfqffvPu5IBfNy+lTc/AxKQg9Ho4Gu/f6HjLFUIco+YeFMmZ8dA8QnSUWdCafHE4vaROGfJI/zmZejWISmzQF4aRDfNBSV1lMalTnEawSUnscPuTJdoL7ZvVnS2JWT/zcmLTG89liJCVkZDJgEy1alv9CONVSgfRETONjqcZeiFzv5Rqhq/VIRlzHCyNPkWSEzkucnnjt/XxFb8mgOtMouPTpawcZf15zZxKggnIyzPvbvRUEiM93Si4fesSHb5hrnTgSghdV3nf1lYy49jLH2plQkq/jl0OgZ+Y6cxJC2i0B88f30Um3yBy522j+s
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 21:35:17.7618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b683c7d6-e863-4869-0eae-08def2704738
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-AMS0EPF00000194.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR07MB10521

From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

This patch updates the documentation of ECN‑related GSO flags, it
clarifies the limitations of SKB_GSO_TCP_ECN and explains how to preserve
the CWR flag (part of the ACE signal) in the Rx path.

For Tx, SKB_GSO_TCP_ECN and SKB_GSO_TCP_ACCECN are used respectively for
RFC3168 ECN and AccECN (RFC9768). SKB_GSO_TCP_ECN indicates that the
first segment has CWR set, while subsequent segments have CWR cleared.
In contrast, SKB_GSO_TCP_ACCECN means that the segment uses AccECN and
therefore its CWR flag must not be modified during segmentation.

For RX, SKB_GSO_TCP_ECN shall NOT be used, because the stack cannot know
whether the connection uses RFC3168 ECN or AccECN, whereas RFC3168 ECN
offload may clear CWR flag and thus corrupts the ACE signal. Instead, any
segment that arrives with CWR set must use the SKB_GSO_TCP_ACCECN flag
to prevent RFC3168 ECN offload logic from clearing the CWR flag.

This corresponds to discussions in virtio mailing list:
https://lore.kernel.org/all/20250814120118.81787-1-chia-yu.chang@nokia-bell-labs.com/
And it was suggested to clarify SKB_GSO_TCP_ECN and SKB_GSO_TCP_ACCECN.

Co-developed-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Cc: Parav Pandit <parav@nvidia.com>

---
v4:
- Update commit message

v3:
- Update commit messages and documentation for clarity
---
 include/linux/skbuff.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 22eda1d54a0e..6c0d725facf0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -671,7 +671,13 @@ enum {
 	/* This indicates the skb is from an untrusted source. */
 	SKB_GSO_DODGY = 1 << 1,
 
-	/* This indicates the tcp segment has CWR set. */
+	/* For TX, this indicates that the first TCP segment has CWR set, and
+	 * any subsequent segment in the same skb has CWR cleared. This flag
+	 * must not be used in RX, because the connection to which the segment
+	 * belongs is not tracked to use RFC3168 or AccECN. Using RFC3168 ECN
+	 * offload may clear CWR and corrupt ACE signal (CWR is part of it).
+	 * Instead, SKB_GSO_TCP_ACCECN shall be used to avoid CWR corruption.
+	 */
 	SKB_GSO_TCP_ECN = 1 << 2,
 
 	__SKB_GSO_TCP_FIXEDID = 1 << 3,
@@ -706,6 +712,13 @@ enum {
 
 	SKB_GSO_FRAGLIST = 1 << 18,
 
+	/* For TX, this indicates that the TCP segment uses the CWR flag as part
+	 * of the ACE signal, and the CWR flag must not be modified in the skb.
+	 * For RX, any incoming segment with CWR set must use this flag so that
+	 * no RFC3168 ECN offload can clear the CWR flag. This is required to
+	 * preserve ACE signal correctness (CWR is part of it) in a forwarding
+	 * scenario, e.g., from one netdevice RX to other netdevice TX
+	 */
 	SKB_GSO_TCP_ACCECN = 1 << 19,
 
 	/* These indirectly map onto the same netdev feature.
-- 
2.34.1

