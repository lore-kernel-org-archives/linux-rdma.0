Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011053.outbound.protection.outlook.com [52.101.70.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFCC3B71A4;
	Tue, 28 Jul 2026 16:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785255048; cv=fail; b=f1PGTsrW1Os8r0MXceGgkYLYo/0raHhZKFg0qBmj919lV5ibHJR2o/KCHPGoO+X3EXWzezx1xonm8Vo/2hcO09PWwmjVMhbjkJtgofmxhllNh2oqW9IaOLeyDgLd9sW1nk1qFf5rNO7mmz3/80TZC9dlD6J7CIMEvEp0muZ9uIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785255048; c=relaxed/simple;
	bh=/92eRHjQInCH3SyL1t03YgoE9ORBelvj/EDrRzwy5Sc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=sA3MzozCysoPQJ8H7uqwWnhB3QkYxt50X/j9ttglJbB7AE7/CnNAywIxh/Grw3elHg0dr4l/sIh95hMVPuPFhoibADifqbaHpmcXbpirv4Em40tYf4In78BZFrYsYUqIgdTGIolMMkgCOFlJwdiEA8mnAF2DHfOPJuxPvBxz9AU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=NWjlDdal; arc=fail smtp.client-ip=52.101.70.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="NWjlDdal"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oKoFvmfItZ/h3Ti4+xgmDSmclcqnQvpjD3CwH8zqDD4+9+/wPsLNcbKJZyHmo//sKnBsZR0rQcCJyrfyDYlR3x1kW4AbCGQPlRWtNs5CYF3C68Y4Wio4+U7zYafxAyVw1QrJcyuZF/w8bX93xVuWOH/7FZfzmm0S23ege/9pAC0djKD5Oz7hSKa7pbt4Ps/utlAJNbSdGNZFviXBSD6cG3AWj7DP+hPKIb5aiLKkfDUgfxGxIR1gkLUkiG4tVYP9osG/UJQMJ76BYlBUZl8ludULkPOTfTzngm4OLtDJy1yIemYcheY7P5YjPLbrIAn3oX0Lz2HsZl9eOBY1SrxSFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbJC25GmM3Xpbk9kEzYteSCbTjNFqqiKKLAA+00BXS8=;
 b=NBmwIKGTvJi8zHaMh0oHyJ2uqtndwP+EjW9bqW+/T4j3K0XHNs4PNPuzPBScaOqcXrRPIv9bOVzZRpBOHaGilLkld7hBysTU64dOdHSCoQJUJPBBkYkf3afL5wI0MgtMHOw8jTBrSAjn3LE9DBhHVuQTRSgiurQ9khYcZtTaabTeJfNqzGlUq6Tq6w/8AcKSyHC3bvDCVPEXxE0oOlbcl5KSttbPeqVhxUzPyAN9Ln9FBr5LZ50yBtQAakBSu6onM+bun0VF3cOPG/jCF8VzIYERO5Cve9mNSjxurWJQm+vjBpBwMSnVqOPzAlmLqnRBXW/ZQcuWOkTonMlK6bSvKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.2.85) smtp.rcpttodomain=apple.com smtp.mailfrom=nokia-bell-labs.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nokia-bell-labs.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbJC25GmM3Xpbk9kEzYteSCbTjNFqqiKKLAA+00BXS8=;
 b=NWjlDdalFU0PkotII8HmJbtwv7K4jdPnGF0aHMJqi2Itt49K/9NVMoPM3kZ6yskGuEZEMOlEXrWObl/M5Vti0FkxZHWrhgTwfWIs+XV0DuadbibikZLuzXxr+eT1sH2QIjL7xUIIY4WrEZQTOhimsT4okrWMdM5SlC57d/DJl6A9YtdHH4kFfx7y6kufjXeX92bghDSdnqiAEP1eKA6UQF8E5DdanfDh64i+OfI5fOQBs572toROAdIkJ6oFYf/vvsIwH4UdYAlT5I7Oryc4GNRupIq21HMgvy224Bf+zGa0bO+VmWI0p4MJsc02A9DGzKcwnhw1YlO5G0zwo+XTiA==
Received: from AS4P189CA0028.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::18)
 by DU0PR07MB8881.eurprd07.prod.outlook.com (2603:10a6:10:310::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 16:10:38 +0000
Received: from AM4PEPF00027A6B.eurprd04.prod.outlook.com
 (2603:10a6:20b:5db:cafe::70) by AS4P189CA0028.outlook.office365.com
 (2603:10a6:20b:5db::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 16:10:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.2.85)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.2.85 as permitted sender) receiver=protection.outlook.com;
 client-ip=131.228.2.85; helo=fihe02smtplvp01.emea.nsn-net.net; pr=C
Received: from fihe02smtplvp01.emea.nsn-net.net (131.228.2.85) by
 AM4PEPF00027A6B.mail.protection.outlook.com (10.167.16.89) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Tue, 28 Jul 2026 16:10:37 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fihe02smtplvp01.emea.nsn-net.net (Postfix) with ESMTP id 1F27180000A4;
	Tue, 28 Jul 2026 19:10:36 +0300 (EEST)
From: chia-yu.chang@nokia-bell-labs.com
To: linux-rdma@vger.kernel.org,
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
Subject: [PATCH v4 net-next 1/1] net: update comments for SKB_GSO_TCP_ECN and SKB_GSO_TCP_ACCECN
Date: Tue, 28 Jul 2026 18:10:07 +0200
Message-Id: <20260728161007.650717-1-chia-yu.chang@nokia-bell-labs.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: AM4PEPF00027A6B:EE_|DU0PR07MB8881:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ec4b0d4-a356-4371-c347-08deecc2c362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700016|23010399003|18002099003|11063799006|56012099006|10063799003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	DLnuqZySk2338TfnMLSf3RD2ZtaFFN/cNQnytbs+IVy7dKZXRx0JJwDAQL4VdmVhGJpBbz2CbBYpUYdew0MIRKQfSliqoC8w3lmQ8TFAfngu8KV1wNp03W0vcoiCCToWhOX6rmambvdzZQd0xayuHTZL85ZL7zashna1pGw/E3U6Ak58sXOTUAsbm1uMTe5s6lTAg4NYP6Kiyqm4XYWw2OcCI+rnkJVU1B437KnRdGEP8hyxDxnWSo0qq24AYAhsWCs1+CKF92Zb8fsX2QHpoPZq7cwhukWxR00mwT6WRoXGlclcB9NbSyoYrTfs/Ao/7ggvmTwXjFchy8CBXdIosOZ1kKRDKVCHqyrEkqz2KYJy8rMCB8UTTjxywLFayDx3oKBUJJ1sEOZ1vH9wgDCLwU8sA3hLIySNVVgjEV+42LE4gcjXUv3vv9ibvCcDN3ToNYML0C5P4jepvPLmsJBnpXrvdi+UU+Q4+ENy8kxoOlrZScueEYHZgwgq3KsrL6jCDZrEmUi6TTWn7vwm4531Xz7iEnKMeDh2ENKs1QI+9INhZZCbUzwf2tJMwncaUmVheIwRPzErPhLFysLdrLkG4+eOX159cN7Xwdbcou14gOxeVQB0L1zvW3KmRY6tXEpiJcuk7a2kISkh66A/G69msbYz6/Hu4NArgOaIRUJ+3eQZqmuAO6By9QSLd0qjPvDh2Rc9Q8k6FDmDrB08LjULx5OYP1ZjbF2iOP1BOSUcNcNQu0IO+fZFqdXZjNvB8Zzp
X-Forefront-Antispam-Report:
	CIP:131.228.2.85;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fihe02smtplvp01.emea.nsn-net.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700016)(23010399003)(18002099003)(11063799006)(56012099006)(10063799003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1P16IADuZQ1yPsGuvLmEklGINfYZSZhp/7m92qV0qggk1bPWJp2VXNZ61ZcNrEMY8onn5+QimYYsntlZgpfF24K95vWxz0fGv+sCB2LwykpBI5Q2be1TNDU3t83ODXlmWXrB125nQjNT08cYewzXU+i7Ls+GsFA4+a0A+rPhE7AAXrh323D27Y9g+wQYlH4HQx96wxxBBYgYalljdgx7UTFuNLwjqUn+lnwJteYmDLbT76j0CcsEG/YEcAe3KyUh9+WgqtU6i0kH8EV6dcwSg7nnfnWb/lwb04r7EL7hjvWnyv8VqANRxqBGUK3fIYj9otc7qzZHNus3RD1tCwLuHXNYxfAJjxPapt7qtzxKtBVSGi0ns7A+13Mgil7entl3PP9pZ/BQ7GlveBtVfOFW7kNGkHdJeyYjs6om526WtMQFSgYholgF3rwI+zvq4ywi
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 16:10:37.8287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec4b0d4-a356-4371-c347-08deecc2c362
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.2.85];Helo=[fihe02smtplvp01.emea.nsn-net.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-AM4PEPF00027A6B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR07MB8881

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

