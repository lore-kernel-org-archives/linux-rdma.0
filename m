Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658862;
	b=qiLQ/kbpDE0F3VCOAY8sm4egAgq6Y5tIrkU5/XR96HYCkjWTBOMCREc3+3ssNJxI4DOg
	 I6quL25J8gxPoY1nbLdPFMl+d4Oxjo96E1d+l0Cpoot/Pm6NsW9sQooNoVK6BKr1+l4jV
	 NdQH4tNcJenxe01CwLA0mEA694nS+0eHvLD60xmQgeWPuWsXaJGGWreqq8YyMDqIHAanT
	 gpmyTjJAXSrZCEsatiP784vMOZLb+Y0zVcR4EhPn22zJzZfDIzGQIGcSRRztcbw4Zr/K3
	 oQVZIlwk9bcp4D+B5TPlNPzP7TfEwwlXbvtAGrnQKY+1N89tFT1i5QFl8rrhYIRt28g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658862;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=8ZtjDYQ3v/I7x/nz1DDylE4Vj7f/moyV3BFmv20XrWI=;
	b=Xd/olc8msWqWttAPJTKV+bOxNfDLvDflzo+sMfRQa8lPuc71UWslxpivTtJsLzXpAryQ
	 FLJWCohbl2K61BUVO0455voGP/DfZJd5NQSGQzGvP8HAFZRsk4o2gS+/NGgtROOgwnuOE
	 1ZkE/hSKbTu7nWn+VHkrTFYil/SyJ+pzA1foK99smG5vpYDYtz2TTLz50EPmKnBfO+1TT
	 k7b+/eNYeBJjz+7INqkedwSNgQVImcVaEgnyhdIOUMM3tKe+FPMgAqyP5IXWTKo3C7ath
	 AXhU2rSwFS6+J8fUWP4dM0zCiG5h69HbB3RNfOzf6IEktdEJ5nszEl0JzUvbA3OrEVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aoZBzZjH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.44
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011044.outbound.protection.outlook.com [52.101.57.44])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E713606A324;
	Mon,  2 Nov 2026 22:34:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E713606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aoZBzZjH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rs0LP5AJUG2MFP1cZSv3MdhtWs10x7VoZ9haXvYkWpHK58gb0giEwwUzFodTsQpNJCPZK44QEHvruAlv0BWCWk3478qiOF6Q9Wr9zdmC2YaZ00l1Fa/OCSYixpzGKuoxTtajU7HrVF+tAWiFoH/cvRoSXLwNPsU4aX7/Z5Vyb3oPZuFrVwnfpoe85ixpaIJSfWBDZGt2+dI2S1QO6j0hFDP6Jk0tM7hq9yK3mCUMtciB7GLR2eGkyihJcO9v9pGw5UaibH7rvol9bviB1OAvSbelKs61N3c+zbaoJAS3SO26pZODeZlw5ho66/czaUlSg/UkgJKkx+PX3gwagJPGNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ZtjDYQ3v/I7x/nz1DDylE4Vj7f/moyV3BFmv20XrWI=;
 b=JKqvN4Oyzi/gIJrRv8padBiuSGSbp9+GjhYNS49iX28EQdty0eLEaUAK9a2palAxGDpAxdJJD4+cDU8ksKS+fR5zxVufeaN1ylzXGtRWEVqEaqxaadR3PubFRteo2iM67NZbOXZ+EUt8dlMoSIyl9Z6oOVLHPIKAtNhdlBbTwigEQNo7dCMvVOdn8g2iHAr80lmaa6KO8ePM4yLPcXWb642J1sgbi9o5bfGmPWWRpLRVrLccA1n72DmOYKWFLl5G66rWHfdvG7pylmaoYwFFLTJMFRimTQ8qlHOURlzfYSQT3oNdhpiNXn/8sajUPGM8OnKXwNSKSZugoKPAustdmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZtjDYQ3v/I7x/nz1DDylE4Vj7f/moyV3BFmv20XrWI=;
 b=aoZBzZjHixjLoJZHegvf/lYwT1XS61Ric1r/OQYmvNt121EAISZJa2UI9s89MqAmwBdlXIa54crVIOeuvWrfPfyJmc+NBAEY7aM5w+JHxL8vCa/+HOB3PhUUooGECDzoxkK462yhwu2gxP6gY2+XTw6+3SCJU/FatE1EiY0UO+p52c27XvOsIqt5x5DL+5mnVI9IVOKq2JcBAJHqrcteuOdWa2IND8gJleeOivfLJxpJvuOrOQTmPGkdWaB8iboKvERd7Ro5/UwpfTR2cl33yP2hpY+WI7rJ+Jy0Li9JhtxnGBhEvJ6CIjVqfl7y0wKVDejGDxL0eHclc6oHQfhkVQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6478.namprd12.prod.outlook.com (2603:10b6:930:35::19)
 by DM6PR12MB4265.namprd12.prod.outlook.com (2603:10b6:5:211::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:34:14 +0000
Received: from CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b]) by CY5PR12MB6478.namprd12.prod.outlook.com
 ([fe80::51f:ab92:7d1a:441b%2]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 22:34:13 +0000
From: Michael Gur <michaelgur@nvidia.com>
To: jgg@ziepe.ca,
	leon@kernel.org,
	linux-rdma@vger.kernel.org
Cc: Edward Srouji <edwards@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Gur <michaelgur@nvidia.com>,
	stable@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rdma-next v2 04/15] RDMA/core: Allow optional access flags in reg mr ioctl
Date: Tue,  3 Nov 2026 00:32:57 +0200
Message-ID: <20261102223325.2115128-5-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102223325.2115128-1-michaelgur@nvidia.com>
References: <20261102223325.2115128-1-michaelgur@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TL2P290CA0014.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::17) To CY5PR12MB6478.namprd12.prod.outlook.com
 (2603:10b6:930:35::19)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6478:EE_|DM6PR12MB4265:EE_
X-MS-Office365-Filtering-Correlation-Id: 28e3d9a3-2a5f-4755-5093-08df39316bcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|18002099003|22082099003|56012099006|261102123227099003|10067099003|261009223027099003|261022105027099003|261021121427099003|261021123027099003|11063799006|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	t3LYBCdICSL7lCdy5N2EQXngoxWZ+gFQCZuNz3xg5DyqGbb2YGui2tnH45o5Hr4YiZDBPHM8xRB6EJTUrXPMx5z8mROQWM43BStbm3UCGPeMcMxC8yo+qtpSf4ERM68SKTpurf3osQ01Csn4o7U3p/XMj7g0bzgJ/Vbpmi+x1EQHLrra1NB7Fli+BvN9H3PdCO1DLwSOGM1BSGdCS7YC9jdMtWSB+7oadeLhKdrmHNdKj4jazz+4lXvWIvU7tkh/HKXneXg8fHg8Cebv4eToDBexpJMD/bmAVWU6odohTe07TICTfeB3etOsf0I/ylqSl4xdhE25X5BEHN/0t9YS849lI+Mxfm4ATlF88akKyTWTAgrw5cbiPHuV5qR/KccbzoXaCjmXmu5lRHgNYD+W0uhnYpPUvrRcmqERp53DC/DKh9I6Yp+bqH9UICw8zcjivLYf1vJRvfYIONef+8g9R2TU3m6tUrDTIMWpHG6Kjx+HC5pdXCoZotaxzO4qEqcgZxO7EoWAVKGvyKrYmoz/e2xTJ7d1tqZtGbZ/xA0ZXguijkhbcD02MY/eJZXMLGdJgWqG0gJ4IrUARz+hVIgFmfwXA+9UOI43UcjexeQBLMfxiMY31+ie4TJCFPAe8sR//BiL52UkGkvlR99rYKsGJW8CCf7VI/m3EhHwqmzowfM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(56012099006)(261102123227099003)(10067099003)(261009223027099003)(261022105027099003)(261021121427099003)(261021123027099003)(11063799006)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aHZg8FOazeDsdyiPhRPim2Zf3q7MpZbb8g5CGUH2w2oyrMiVeHDuO9B1pTFb?=
 =?us-ascii?Q?iwRnDjGeCMwAyBJWW8U/CLuF8u/kWPqyDKNH+650HhXrKAvalIjNKUm13uXd?=
 =?us-ascii?Q?zKqMIazTvX6n/vl/uweFeNu+dXGzQfLyXyUmBUx75ZSXtD+bDJ7amFawa5ka?=
 =?us-ascii?Q?A+0Yny5JvzEiFtbwTgXkzvW5OQrNw6cB/PpZR4+gc5kS4rBdZCqcY/UwoCOz?=
 =?us-ascii?Q?nxBeers1KQPGlDRKdzRvbXi/eVsHTRz5Qka1c4tUkt62NPpgch7K2bK0f77H?=
 =?us-ascii?Q?zeHgSB/1woygRdVd3vn5uXa/0kekvNYBHz8mZu04uAuia3mmHurApTqTHVA0?=
 =?us-ascii?Q?H0vcH/meigOdzs2/uLhjeqvnVsJ3hm7MTNWLoYkGt/ADWF4W6TYhCSYD+hOK?=
 =?us-ascii?Q?ee0y3oOPkXEZi3/1CBXXvseygwY/56nBKl4smAfKwJf+OJU4ghQ0bMCxuUkL?=
 =?us-ascii?Q?lvdeF9KorJrzHmwGsOvsOW2G6J6ltDwBJrQyM+cIuWxVj6cCCfuAjmOwR1gm?=
 =?us-ascii?Q?Y1LtkeN0qgwzduJErrQaJ0eajTy5UqU4ecI6I26mGaVzVVLaUc+NXDvgmRmv?=
 =?us-ascii?Q?bQ1s127cT7mRY9ygnu+v66NU9Dc8v7NYjF6ORPCiXDwE3mEsBX+cm/O0s4KH?=
 =?us-ascii?Q?4k9gYCLcUXBz0sRm6Bhe2+o61mIUamVG5Db3MMivq+ui02vC/AymJhFpevVN?=
 =?us-ascii?Q?dtovmLy0rvwU5NNxmUNVhWUoduUh5RHX1zQXLJQjLDf7jaDtaK5t+wmjGrjL?=
 =?us-ascii?Q?ET02BiUJXsm6PdiN9hGjintaBz1q6iA5lj34aV8Kh5GLc9y6q4iXX/bJi8WF?=
 =?us-ascii?Q?O8y2ePXAw6s/RWH9Au9ErJ6asCERA/UzezipeZPsf+MGJNFwj6YgZF8ZC+H4?=
 =?us-ascii?Q?FO8aIrKmGfVzgp5Bf5CrIpUFym/R0N89OIoz5v2MPAMlJehtjfR1vEAPCd15?=
 =?us-ascii?Q?A16qxAvRwgaLLhctNcituaoEUKicSPccH6xxjRGis5VeGZzPtod9aSqe787n?=
 =?us-ascii?Q?xSFngt8otvwra/NPuiJ3YlC5mwcalsHnJkRoyICV13qMvh6I2Blb8ntwZgbi?=
 =?us-ascii?Q?K/OYnJMJ6TOuNOjuJtr5YNtJg0OywRGz/94EPbt4YXXr5iGkFyebG3zJK0uk?=
 =?us-ascii?Q?aOtp7D7rN987J8MdyHsaMYJySAL/9jVdiZRpDkGXD1dFJNz94JLiGWWKrpYP?=
 =?us-ascii?Q?vNiGx4S7Pw+6eDr6gZ9g50rutmVPkB4mQxxzB7K18ilrD9OXLD0dQYieqZ7C?=
 =?us-ascii?Q?2coXKnHqtoLNz+MjSIepAXBA3wqHhte9PUXa2WcTAQ12vbzhZ0Di346RYzci?=
 =?us-ascii?Q?jO2o93sDfG/S2Oqor1irJxdzAuAFPixgfNl/u0WhB6uNfktpj40fH5k+HxYI?=
 =?us-ascii?Q?Yxs2fYlbssUwzu7ex+Nl8XtZiHD7cqqYwa6FMW79cWeu4VAgC793JX4HbEMQ?=
 =?us-ascii?Q?gnTF63p+DnyJbK0tnuepZCPdccY/SiG/bvYaWGojY8AWClEasXCWrhqVH3NM?=
 =?us-ascii?Q?HdCfVL1Xr205Ep0xmdpxPOkyH/59H5B8onlSsfrkjVmvB7It28ABgN/m5a4r?=
 =?us-ascii?Q?wnGbhh8CtO0ur3ozCr503IniL8IJCyvHDonlCZbVIQMFp++Wytz/NxvWuURZ?=
 =?us-ascii?Q?xZJufxF+FU4qDCGiTZ/hAaRJOa7ZU+QAI58ebCLTrRjHnpgTwXcBkqsPT6WZ?=
 =?us-ascii?Q?eYi2fnaiU1Oc/5/4fySkLAVW96S68mFnGqTRYW/t+8PxwOixVqlEr2E5JT25?=
 =?us-ascii?Q?LKVmgnf2+g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28e3d9a3-2a5f-4755-5093-08df39316bcd
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:34:13.6032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8pgdPDxafw3G/OyMz46d3CH3YELKE1Jz9HjoNnCRV8Gp6CkO8eIfVTlVu22SsLFMPnkPmZpLs9A50po77w/uRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4265

The uverbs ABI reserves the optional access flags range as best-effort:
drivers should accept any flag in this range and treat the actual support
as opportunistic, never failing registration when an optional flag is
requested.

Add the optional access flag to the allow-list of dmabuf registration
through the reg_mr ioctl. Uverbs users can now request any optional access
flag on dmabuf registrations and mlx5 will apply the flag's effect on a
best-effort basis when supported.

Fixes: 5b2e45049dc0 ("IB/core: Add UVERBS_METHOD_REG_MR on the MR object")
Cc: stable@vger.kernel.org
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Michael Gur <michaelgur@nvidia.com>
---
 drivers/infiniband/core/uverbs_std_types_mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index b6d6cbe448a2..ce6c9aaea95d 100644
--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -332,7 +332,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_MR)(
 				     IB_ACCESS_REMOTE_READ |
 				     IB_ACCESS_REMOTE_WRITE |
 				     IB_ACCESS_REMOTE_ATOMIC |
-				     IB_ACCESS_RELAXED_ORDERING;
+				     IB_ACCESS_OPTIONAL;
 	} else {
 		if (!has_addr || has_fd_offset)
 			return -EINVAL;
-- 
2.52.0

