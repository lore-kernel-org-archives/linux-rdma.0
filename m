Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010007.outbound.protection.outlook.com [52.101.69.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D76447D94A;
	Tue,  4 Aug 2026 21:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785879328; cv=fail; b=DJEOIgq4WuefyvZ17tliLhcp9dFZoloZlJ7b2Z55WUIbWV4REjGVSxqWAdKKxgyxQcNd+a7EDGWEcV2eB1AHZCyUNMcxihGRyiLUWDw/s4WES1zit1wYLhaXRXy6StbyGX3PbSNzB4tcR9htHaAn0DYQO8r1EPDDp6YzfWXRVQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785879328; c=relaxed/simple;
	bh=4jOaZwfp0H0UXI6ftUlkb1/34GT3+i7oFw1ALIklebs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KYZhOxbWPzkUBHTbZxt/puEAKpGpRYZkVa4jRxXPVI7/81+zrSoozxGIPXGTgmMo9aSMNYPBwzkB6MVD98CoRuDCQhDPw86jfjVDxiTY0vMlT12OA00FgkNA9ceTf/KWxPz6FtBak+cZMLZw94peeT84gXGNWJifQTL13/RJNPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=nJV3q3NI; arc=fail smtp.client-ip=52.101.69.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="nJV3q3NI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XoGtuzaDra0oilsbZw2wmBimKX+wV+Ye/3DGQjqhmT0NaaL1EHSuSBWyT+v2hoN1x6qQai11ajJnnF2kHV9PB5VvRG44mC1LTIEOeLnN6ESE1ivsHtmQOmCERAgfJJyaCu6eCYrWlARLn9a6uzNi7X2q896E4wYw1cA96nFOic6Py3R+EB/0OuPLND8akIloHvVwG1zDzFXCLMegJ+iViqob8m1YjCiOF7XSgM52Cv32oIl2H7kYeNxPcmcaiqYr/oXZ1xkM6RfmbiHOtiV1CQdhLyGWoXEZjh1XnLvpY2L/wvm1x4aC0VRo479isjbDcNcWhN9oMXBP8QU/lD55Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4rmvzitUsKC5xazc70vanyEYc+O77bfzPIMvM6IcIGc=;
 b=SZ9RthJXUg5v5vH/iWEzzei4VeG25QCGzgi1TnQRuod1mHgs6Ap8X+HhoAlmS7n5dBRLW3ifI2CElWIGf5HDpoP2x1Eh6X2hLooPryOdqjbjZCmcXZDvm21CXPLVZMKIvK547dl6TYkLkXEWElxRElvVGm4w/P6SDjNP3tFURl7Xj1XlZXdJ3koMe9gQQpfltlhsQio7VUZV0uA6xJE9OrB+zNaB94QFQkOBVvfZ1h8QEZpCQRCpWKyUA6uNeNc7pU5vIgI8OzlegipCLZdzRoxzHJECZDQwMoHI6ytoR2aLC4nxxf+l6+qMNuyDEqN3MTBTtbSIDkfutOki2y34kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=apple.com smtp.mailfrom=nokia-bell-labs.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nokia-bell-labs.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rmvzitUsKC5xazc70vanyEYc+O77bfzPIMvM6IcIGc=;
 b=nJV3q3NIVdUT4+SCPiPv90ClUqMCa1WAG32l781Z5No3o3a/36gFN+fhlBolRfcIQd0d3rWwDiA9KiiUOpmWqBqc/ZTzEgfm1unJihcDoqiL3NYJJR8+N2OZynYNvLgtF51NxTfVwiwXe40xx4jCRAoU3T4eBQYE30OjpSdA90+Vnm4Zlnhhdj6prK63uz3Jk/mlHJit4TOPep5ZRustra/M4tbH02OSgxo9FqYa2u2igSlvV2OMOZ2q8diRw1D19i/RuiEKsojsLdUlg16ojgLFVnod3a9TgQpFdLsotOLTBMPwSjEw0JID2C/bm+aYaeTGFmtdc4wJCpyZY3vf4Q==
Received: from AS4PR10CA0023.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5d8::15)
 by DBAPR07MB6726.eurprd07.prod.outlook.com (2603:10a6:10:192::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 21:35:20 +0000
Received: from AM3PEPF00009BA0.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d8:cafe::a7) by AS4PR10CA0023.outlook.office365.com
 (2603:10a6:20b:5d8::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Tue, 4
 Aug 2026 21:35:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 AM3PEPF00009BA0.mail.protection.outlook.com (10.167.16.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Tue, 4 Aug 2026 21:35:19 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (Postfix) with ESMTP id 3BCA01C0030;
	Wed,  5 Aug 2026 00:35:18 +0300 (EEST)
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
Cc: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Subject: [PATCH v5 net-next 2/2] net: hns3: fix GSO_ECN flag setting in the RX path
Date: Tue,  4 Aug 2026 23:35:10 +0200
Message-Id: <20260804213510.673084-3-chia-yu.chang@nokia-bell-labs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM3PEPF00009BA0:EE_|DBAPR07MB6726:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: e8e8d2ec-3a87-4c9e-7230-08def270488b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700016|23010399003|1800799024|11063799006|10067099003|56012099006|3023799007|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	gQEryuspky913K1veG+KahkhX+IFIyGbXdqLTL7TnNN/woTbY6LNSqI2jTUfxTJ5tCeJjc98jCpnT64q3rHuulIDbkaO94Hh1bPiNKw3qzz/B43T8DAs/4VaV7RIvW5DMeZFcswxoyNgxD+f9PU6c9AofAfl73PfZ1HT2R08Q0BvlD1PFVNoa/reJcUd0qrvlIUoE66YQSnHUXb4OsqwQicv3Hb9NaBk4vU6cxFqM8dDrchDo3altkbN+Bb+jg+BjNwueqVyxYxEYgnOREj83CuzRyTMw+N39pohnqvC+q1sDhfyhO4Z7NPXgXYQwNSYSGglH5fZ85siHI3pdmdsbP5AU98QApzDD/vHp0jZypzUObU8OJMD6TO2iBuE3fv8qRtVdEhG1nwbZ1VAzy394TyDZJcwHNZLBAFL2DaluiTz8spq0BHjD1YAI9SKdppQTn+UR0pkbfu7XiiYps+alvqTv5DCYYu9XGAiHBJQoONklzYhHHEuPM2rCq8gxUA42R12ZJANIyLIm7kPs6eASAnDAVVr+IGPnURvWTPL6EFb79WRGXNEtvDGYHgvup1gstksihkum7Q1ZDL4kcF6I7Ax+X68dkg0+smwLqycYCFVmdybBte26WXcnCdODMGOxtaTWvMKuZ/1TKWnnN54LpbidUWCD2jQKE6D5AD+D0zta0oF+kFzuyT/TBEHFRWfcKXThWHfj09gs7kbcBXLtV+O2FDk4VZ1Xmm/1iTSSc4R2qGozj00P6+nvrnsGXfZ
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700016)(23010399003)(1800799024)(11063799006)(10067099003)(56012099006)(3023799007)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kvw5b51LUwMK9Zw/CZU1S6bOM2mI1orYFnhP37QSO4ovtGW6i2lNw8/6ILv8m/r6+hAIMrd9sPlrPVeB81Ake9ilXHUF+u8xQ1EsTcQEa8mwKVWWtusPmhonNzsKXmYiq9Q7Kp1M1YPizXxDg1BPFcFMaaoV/U5BZ1NN1g1I2to7LafUqyIue8MHOnIoel3ME1FUkVjlIdXRfC/Dzn6+2aNyPa2TmJcwIoLoVpb+dXtuKuseFGzygt+spXc/+STZWr/MOLpiMZq37b7fvRqzh2IR5pDbfTN9LUUl8hsfi5yWVQt6r7SjS3t8YGW0iIyZO9fvXLTvzzdlOB6caPyULrFjxwiroMnpIjq6jdgYnjoXuB+KvemU2g+nNKF/74yGqtHXSozk5TlzAbBoHXUgZlX46skaOzG5wjsUoMBOTnP/gOuYhlDfEncXDnTf+ENq
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 21:35:19.9770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8e8d2ec-3a87-4c9e-7230-08def270488b
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-AM3PEPF00009BA0.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR07MB6726

From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

Currently, the hns3 Rx path sets the SKB_GSO_TCP_ECN flag when a TCP
segment with the CWR flag set is received. This is incorrect because
the hns3 hardware GRO resets the IP ToS byte to 0 during packet
aggregation. Consequently, no valid ECN signals are carreid, meaning
that it cannot support RFC3168 ECN or Accurate ECN protocols. Setting
SKB_GSO_TCP_ECN or SKB_GSO_TCP_ACCECN under these conditions misleads
the upper network stack.

Fix this by removing the incorrect SKB_GSO_TCP_ECN flag assignment
in hns3_gro_complete().

Fixes: d474d88f88261 ("net: hns3: add hns3_gro_complete for HW GRO process")

Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

---
v5:
- Remove SKB_GSO_TCP_ECN flag and update the commit message

v3:
- Rewrite the commit message for clarity
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 6ecb32e28e79..5149eca0104a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3916,8 +3916,6 @@ static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
 	}
 
 	skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
-	if (th->cwr)
-		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ECN;
 
 	if (l234info & BIT(HNS3_RXD_GRO_FIXID_B))
 		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_FIXEDID;
-- 
2.34.1

