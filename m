Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011028.outbound.protection.outlook.com [40.107.130.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401C438550C;
	Tue,  4 Aug 2026 21:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785879321; cv=fail; b=MCjiUgIKgjn+08IczzdYuF1MwavslFP3lLhAQmXTtf8IjHg4SiHTB2xjGrCxpIWp5da9xs0QeuXbjD/hnRFOoCid74R6atFH3yxyuG/YoLDLW+s9Mao7PFsTN6Kt0OxAuFps6Tf+WcTEcR6BRgC8zJy5xJisJymTQbqXLYbvgGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785879321; c=relaxed/simple;
	bh=N69ZPGO8zfvE9pD44jQpo6I38dfiiN6xFro/S7q04l8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=mP/jMmOHoIND/7hSSU90oNWq0wH8fKttx7RZSDtTIocvqoe+RDj4y/X7G0hty+QL71/5DtvEX2uoILIJvyG/FQ5vTBETElpNRvlfzl7hROCi6adVbj17FvD6ScPUe9OD1EiR3lyBv50X8iMzGLOxp4dgfWmr+FuTQOJUjBJX2iI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=CnZVLKq8; arc=fail smtp.client-ip=40.107.130.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="CnZVLKq8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iM4KuodSS+LVOe24CxBO2RpdDFcwdHCy1NhwIjgW1GSmVMCQ2dVQwbYQDxZ29493sslcnQ+cxUVFI4HZ4+F0igPwH6m17EgsTOFqnPMLSMLjQDKPFtHHpSLNev/R9jtfxtGmKP0AOLRLl1G6tSIE8al5D1tgJgNilHQHFF4sqBOEcXd9a5A+YXsNHCiRYayaexKOMyFwYxvzJW78/UEAc2X3fvMpD/1NA4U/w0jcniUN/Ji+ol72qktzfshlpUmxe69dLYKn3s4KDHnB6X1iRMkWrloMVjkQi8mlEW7vh1V5YFM+O6rYoVVu6A+DU9BpNzMnJmVMcA/Hz70l7X07ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8YH4t+4AfXFrSNsVMG+mlZy6fyuz8X+z0QqWnS76xM=;
 b=AqJu2BKEwp72z5g4KgWLLXYy5DUeDncrhTbiVevO5AZKKTQWdT2pd4eT7OFGUazkA1TDf1FSS9vqc6NFRnNHR+ZzQCJv2xgO6TRruox80YzhRklI6qq/WFySEo9nshjY8OFyLmg0dU015jbk2r0tvRc37BDuE6pKlR9SDoiZHNWaMooWYK36imZPapqEwXEdLuZAft/wo1zbc/AujzuAAT9zLtUpTQqbRKQJt+jTCRriWhoFFJtcspq0DFDmaRYMyMTyXd+XCuPj1fLb6LJE+LOReLqIGb0wxwcLqsen+rrd/M4fNUhBcXdz5Pdq83ZPXroudFNLifyGvshLw2ERLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=apple.com smtp.mailfrom=nokia-bell-labs.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nokia-bell-labs.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8YH4t+4AfXFrSNsVMG+mlZy6fyuz8X+z0QqWnS76xM=;
 b=CnZVLKq82K4jtpt0w63A6WcYX2JxbI5J8l2zFkgLnCXS2WqaypN+XRdkPXqdQlp+LO6D+NgHwKJCUe80PPdyqpvZJnUlBzUOeUpQgDa9Vvn1wQXn83VBOWUrwSPUy7L46GZ0NDKCgtxQ6FoREutWhDfCwzjQYVVjxc6r6js7TfoQE1PYJKArUU3OYg4wRrDr/rSyYH6hgyV1GrH1W9VPs2Xf86xNzGqaD6C78HiaaooO7Wb1o0oduGwQvmbDwu0IGiuUj9Mb6W0tEUb/DzzczvMlPFP5vt0pbyRzhoHhsHUfKiCwBjwRQQafTpOZCK6jltAKJPHDnxwFmoN3xYxm6A==
Received: from PAZP264CA0138.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1f8::11)
 by AS8PR07MB9330.eurprd07.prod.outlook.com (2603:10a6:20b:61a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Tue, 4 Aug
 2026 21:35:14 +0000
Received: from AM4PEPF00025F96.EURPRD83.prod.outlook.com
 (2603:10a6:102:1f8:cafe::92) by PAZP264CA0138.outlook.office365.com
 (2603:10a6:102:1f8::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.17 via Frontend Transport; Tue, 4
 Aug 2026 21:35:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 AM4PEPF00025F96.mail.protection.outlook.com (10.167.16.5) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.1 via
 Frontend Transport; Tue, 4 Aug 2026 21:35:14 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (Postfix) with ESMTP id 617711C0033;
	Wed,  5 Aug 2026 00:35:12 +0300 (EEST)
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
Subject: [PATCH v5 net-next 0/2] ECN offload handling series
Date: Tue,  4 Aug 2026 23:35:08 +0200
Message-Id: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: AM4PEPF00025F96:EE_|AS8PR07MB9330:EE_
X-MS-Office365-Filtering-Correlation-Id: 7676262c-6796-4b52-d8a8-08def2704518
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700016|23010399003|1800799024|10067099003|11063799006|56012099006|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	V29OPR7S5XJ4Ne667ynXzjj7eUgpx2Is/YnRDif6kEI2moAY9TFH/Dq7+MTKDKBorPbdma9apYLqU5lgDrBVVBTpwdeRfjvRGLjia2hAU4H1LL9rsUSuMyCVRDkbuVe1rsrFxo9GxUZpL/FdG2dXhMFxyrlF2EJ/ikp9x5FV8smWU0RjXqfTdFUKxKl0MWbz9mxXx++svhDZ4wgeT+jCVsEIx84muBcF+zmCJqtUvj3Gxwu/fi3+uRARQ4skhbTRu3KLVhQHQw0wcO5/GGgBnX2rGbKfUrrd2ZeISEUv/8GeJ72mHzaflWyiauWDz1LyEU+AALpqfebKpfefeF/I5EmcoMsw7yWnhGlsXMpDmSrBOq/FJ58/VwmU/w5O4j1e5jFi/mQAExVcQfYNMgJMvjF6fJrVe5uYGcZRJjfIaxhL8irrJqjyxu1zglaDXWrZvTypYdnsUBowKeuXiu31QtP3jezPt1bJoO1nNcIR5o2XevrsRqDQNkC7WIWU7eMDAuaD1ZsUCE2LDDdcN2ygKCQd/gU6oVlAwD2Jmx2wRpY4u6k43bn6Lzakg/eB84GJE2eZV0Cs2q126av0gix116itDM+hKDyPjRo/X+Gc1W4uIdWI8CRhWXvj2ISV74Z1RvVeGJlOM4g80tQD99vKOxYNC2glEbZ3R4k//oUanrHpnB0qRAaN0xGsQETed0adFycpdPm74PqG3pcCcOcEP8iC3RpcsZ9PtFqjuTat+cjYfGHIZ5Dsg+2c7Y200gUS
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700016)(23010399003)(1800799024)(10067099003)(11063799006)(56012099006)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Yw+nJKSTOms+wJ6nzYhjC5rPwNJ3HozVgJXLpzuwP7qB6+qWJY9ddqX3JjA4kGBuP+/mP4k8nFkoogk+TiH8UvfMQcxUpwaFiuWoQXPmKMXZaze08yXBxQ95DHfPwv6y4bn9omJN4QHAR+P3UgzGxw0N1dTrEGIVKpg7ynPmRU4oYPlbhwqhuNvOAI8aQt7ZaHh1C4NVgZ/hM8eCWcZYUnQKyoila6al0+amFNrlqZPtXKdfNFtkTebPI5wvMvd2MGUMmcyDl9jKyJhQLhK0gNgHLOlMh6FIUiFaxB91Sw3LZ2MIEmwLmfgOUWUqrzb0wpBvOrVRyF7F55U3BIKj3sGrKUMQSJF580FfFy/iOxSi5J3pevJbc9QzDO7+4Mtg1UaLJcPF0w6o1kv61wwUs88v1P9qDpcPJW0W7pM5/F9zPSUX7bxF9uhJ4CBw6yvL
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 21:35:14.2019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7676262c-6796-4b52-d8a8-08def2704518
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-AM4PEPF00025F96.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR07MB9330

From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

Hello,

Please find the v5 ECN offload handling series.
It clarifies the flags of SKB_GSO_TCP_ECN and SKB_GSO_TCP_ACCECN and fixs
the usage of SKB_GSO_TCP_ECN of hns3 in the RX path.

This corresponds to discussions in virtio mailing list:
https://lore.kernel.org/all/20250814120118.81787-1-chia-yu.chang@nokia-bell-labs.com/

Best regards,
Chia-Yu

---
Chia-Yu Chang (2):
  net: update comments for SKB_GSO_TCP_ECN and SKB_GSO_TCP_ACCECN
  net: hns3: fix GSO_ECN flag setting in the RX path

 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |  2 --
 include/linux/skbuff.h                          | 15 ++++++++++++++-
 2 files changed, 14 insertions(+), 3 deletions(-)

-- 
2.34.1

