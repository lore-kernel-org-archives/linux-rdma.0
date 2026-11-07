Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063846;
	b=az8Tl2DC7v8ac2AbIikUSXUNLX8O6vARVfmfd7y7Ofq5BpiEKX+7dGF66k2EtxFBsH4S
	 wEW2pVOlqc2TBWy9fe0p8Z6jQ6VCjTk2mwcTHJN9+Lfb80FiTZ8Yhdby0lPB2ePNju0Hf
	 4YBghI2+LVjHiHTWmlY6+EpFjBt16RvrGk+i30NFDn2tuKgmUxOmZ40eAWXtXAn7VPP0a
	 FRRTKO6YWuBErgFWzY69vLf+k7u8vyCzDvMVzcPCd2BIUf2fMgLD4pBSnQ+ROPVJDmZ/l
	 5lE3mP5x3F5qW8440xcyS5IctU8rsbc2pgX2PlfNwAzpLiUZDj1ZMBq1nQGnsnZkE1Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063846;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	bh=T3zPrCs1gx3n6nu5c+HZlBqtS5+j5q95WVR7Lej540o=;
	b=yvfFXhz2m9nanBpi3NwFB8Hh1fYpVRcZIRv+VyZQjZdBl8YV68HsMs9/0+pOED1OrEYb
	 am3vUsi6rL2w30YPFOFAumJ0zTAKlkzzhE2vAHEv+7FDddzOFcJl44/ol5g0r+n8PLnD5
	 i+36Kpcl110+4j1WFWO4fvN6wyuAJDzU/9NnkLfUJnI4eL/561th9fzBkoyNmoR3f9ll9
	 SpiSjrcllsmQQMPg1F+hL+Yze1uogQZIWuRTdhniRLoBZbeRZLHTIcwPewedt5d2oWHzC
	 cfyewbwblU9nUODpXvCXcJP4XLwCdJqap19VXKXg1P5+Ju925Ciy+ATd7kh5TRhtgNQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=w6apsjC4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.64
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010064.outbound.protection.outlook.com [52.101.193.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3280260A6F6A;
	Sat,  7 Nov 2026 15:04:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3280260A6F6A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=w6apsjC4
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wq8TGYisGdRlyDR0NxZJyEKtrfF4vM1Q+qguj39CtbhlzcdXs0E5Jc6tgmCuGalSSuiNArHGuL9I0k0ijSOrhR/ISDvPuMtN/Yp7Pbh+VmHT4SKx+5n/9BD7cj0XmdhHR6PYZu4fzGF5fEPCk1RqMOcO7x1BmnP/D3Sae6D1l596j/haD4diDVjjkhQHBlXXRaFnVdhcYWQySAn1mtmBWK9YKIE6J/xU/njVvE+Td4a1MFVBDM7byvjbtrvdfLRI5AnFJRd0D7HJD6MK+iY0PH0OU73siUZLEEtE8UewEaUisoL+nGLxWch897C1PdXP86m4rXeVmEnCy4JgnFTY8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T3zPrCs1gx3n6nu5c+HZlBqtS5+j5q95WVR7Lej540o=;
 b=waC1lrFwzYsBBccLoy8UFmPSGrF+7AoOwZLW7XtlF0/yBmugiVGsRXzJhOigDGBA2/eG8CfeX+HSwsQuiL9dc5+cavxUrUM1Xsaj4km8kMJ2K/218S10kbjcnlrtfv3Pp+g05Qy2P3E/hEm8yIAjmGAuJOGomaqczX8UjluIvMJdRIHANEa6BCOkEpGd4DYZ/OPZHwEm7RNq3SXZFBkXWsT2j4AjaRetcQTnuxc0XEt+pPfj05qscMKXJpFE1QqJXMxHD+WMEmZwRROIN5YnU3FIKHLowt/m2gceXjAv7Y+l6fY/ZgL4uWliQiYHfIn+/wgEugZudHikXsyIxTDoCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3zPrCs1gx3n6nu5c+HZlBqtS5+j5q95WVR7Lej540o=;
 b=w6apsjC4vaKWfKsVkOk9bHQdhjk+fthZdJfxAyiUtc+HmyK+zzSWK85K4dUfio/8nco0TDO83nJdv48ONlk9s6hbULYcHE74AXQFL/grNRoXQEm+E2acBoe37Ii5ZO8k1juOWCdNet8a7h9DhASB6X7oLAZv7VMu37s24nXXL6A=
Received: from CY5PR19CA0118.namprd19.prod.outlook.com (2603:10b6:930:64::22)
 by DM4PR12MB6085.namprd12.prod.outlook.com (2603:10b6:8:b3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Sat, 7 Nov
 2026 15:03:59 +0000
Received: from CY5PEPF00000E84.namprd05.prod.outlook.com
 (2603:10b6:930:64:cafe::2) by CY5PR19CA0118.outlook.office365.com
 (2603:10b6:930:64::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 15:03:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY5PEPF00000E84.mail.protection.outlook.com (10.167.247.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 15:03:59 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Sat, 7 Nov
 2026 09:03:53 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Sat, 7 Nov 2026 09:03:49 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <eric.joyner@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next 1/4] net: ionic: add an RDMA capability word to the LIF identity
Date: Sat, 7 Nov 2026 20:32:46 +0530
Message-ID: <20261107150249.1576835-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261107150249.1576835-1-abhijit.gangurde@amd.com>
References: <20261107150249.1576835-1-abhijit.gangurde@amd.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PEPF00000E84:EE_|DM4PR12MB6085:EE_
X-MS-Office365-Filtering-Correlation-Id: cabe1c99-3fcf-49c3-9404-08df3ce05a1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|36860700016|82310400026|261021135927099003|11063799006|261009223027099003|261021123027099003|56012099006|261021121427099003|261102123227099003|261026121527099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kvg12tq263R0mGfydXjt81TGO7OqnN1Dir1HgFSsLp4elBOFQbzt6Aal1tWiZO6qlriwJD4WeUEJm7ccQDEJz67pUaSdjJ/daq//kKLk5MSq8MoeZ8hKST71K5j+tmg9uj/lqFI/WE02hOvPodkKvZx8jDmNbdAMO9/To/A9lNRcAHpBnClHn3cVA3nuyALMGjhwv6dDKduDULsVBvWpF+RhmS6VXWiCOuWaMtvri/OXkMHay5zr48U6WY9w7qEFaYvOEE1pInSEP06RMSlPExp+0ZDgSBSTvA9z0U6uYrl2GezW2AaF4ZXKJU0DZDE2v6gUa7aKflKROlAoJumnZ3aqP5EYT1a/Mwlh4qO7IvLvTOi2Qqzx78GWQ67m3nLQs/FTQT5/b5PtbFn25CECFEGaNnvpO4mqt50Z4t+sfmAZUkALyHX72Z1etG3RYsSCdu+vgjWAxqYYEHL47QY1BlBPjirLEeEuTR6y+jKahMxFIzVH1LoTmTMTeUMDH/avTUhXlccsx2v2sO5zR/Wy4bDFlywTuZU7mvV211LiRPm3Ne3UxbYKKWJTit9TLgCoKna90y2mt/Ej7V5SlTKlYU1Wunms8zwh7WZxLOv1mN9FQOL06LEFIEbsOWEsOu/WdtJnfS7lP33OytyH46Un8V4hmAhki0x+P2Xq/FqAebjz1A8/Wt1rVCPxfHpBUTqGPqlhRhxNYxPbJkcAVIaoTw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(36860700016)(82310400026)(261021135927099003)(11063799006)(261009223027099003)(261021123027099003)(56012099006)(261021121427099003)(261102123227099003)(261026121527099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	C/e+lrt9u9spN2gJ+bfP3zBl8q9Cvqt0H+vQ/9S9YgjvjWb64sbfReimvjSW4flKAaCjn90h2c9iv4p+TP0vGJMMbtQ78Rk40qBnrgY61df+6EQdo2ig/fNFCR0y5YoT0eU26KLcnEdmbHjGj/xLh/igUtYHayfva4tU/kj5bj9gyUEtva+1U+TKmTLQLIsxiCCOaoDJH0ArYmOKf+09Av5HCumQfzbyeEB3uR89/k+uDk5KrKrUTVo+REypdpomF6xwX3FZN2b35l0E1S8EZszXLjbgnDOxBxV9s+yIqSywF2MNI3SPUIwRaqL6lRjSi7QbMZkeDunr1puIb55vKN2/N4SD7+bs8wSyYyXVEK6LWCV059T0ClIKHoE1CXB++YU5Iv+iYSHQeR6jPZ3r9HdyMETwPAZxZztVruC5k1D7ojaGjEVw5NQqAvWk6E+8
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 15:03:59.1438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cabe1c99-3fcf-49c3-9404-08df3ce05a1c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY5PEPF00000E84.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6085

Name the generic RDMA capability word in the LIF identity. The
field replaces eight reserved bytes. The ethernet driver does
not interpret it.

Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_if.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index e911fad545d6..851bb618cff4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -579,6 +579,7 @@ enum ionic_lif_rdma_alloc_qid {
  *	@rdma.rsvd2:           Reserved byte(s)
  *	@rdma.alloc_qid_cap:   RDMA queue type QID allocation capability
  *	                       (bitmask of enum ionic_lif_rdma_alloc_qid)
+ *	@rdma.cap:             Generic capability bits
  *	@rdma.rsvd1:           Reserved byte(s)
  * @words:               word access to struct contents
  */
@@ -629,7 +630,8 @@ union ionic_lif_identity {
 			struct ionic_lif_logical_qtype srq_qtype;
 			u8 rsvd2[5];
 			u8 alloc_qid_cap;
-			u8 rsvd1[142];
+			__le64 cap;
+			u8 rsvd1[134];
 		} __packed rdma;
 	} __packed;
 	__le32 words[478];
-- 
2.43.0

