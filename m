Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794449641;
	b=nJjmLT265wj8fvdRuijE/aWxCLhg3uw+MambzsSn/A+YOZ+Z3oi+msbEPGRsburrWMD/
	 ShbknAANTepLlsvzl82J8t0bl8TpJtVoqM95KuibPEeEpKWLKvNXU1N8nPKwFGYSgjx17
	 nT2JvQPRyLxLFFjIsDL+xLVApWWcjJCBYVijmnimrrq6hKXC2LH+2avMq+nCSw0YqZOSX
	 gXeoVSjijwzrIBt+eXs8CI+RZDgXtxzOfmJuelpVXVx+fiuw4bxh1cOeq2gOoBlXo+B5M
	 6sXfj52CEzd34kU60fkNSjD5FTnPcFt3J3zQVrt3sulnjoccd0yzomm8dZWRXZz2cpA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794449641;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:DKIM-Signature:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:WDCIPOUTBOUND:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Bul5Xa04I2CSgYv/txAFKpvjGCn6mvE63bO1tp1zGoM=;
	b=lnwOK1HuNrZmD+dXe1wHu/Eb1W+KeAgPDypqvPeLnkV+y26s8A2qjYi/qEwiRw11zvN4
	 70f4ZnRTT/sKq5vX+GQrWfeB2HyQvJt38UoNfsfDWahfEd5amH1tWv24+5zZjUKfbhUAL
	 EgyJ1cQtzh3r0NyaJhSNZWRN5HLlLtAa9AVCJI5POsb/WwczrSt8BszcjFuqdaHSPGjzK
	 pbFC2Wpk5SWmZXydr8OZIpJnt/HYTZWuVw/iCLkl7xVr3+QxoEGL95sAsPkxtTF7iI0Da
	 76+l9iaVPV1BGKQ0TzM/eSGKCmGw/s+zM6/bNPdCi81va8oyV+F+7PiseCf+AH9r1Lw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wdc.com;
	spf=pass smtp.mailfrom=wdc.com;
	dkim=pass header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=L2Je5fgD;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=jx4usppH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=216.71.154.42
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CA7606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 02:14:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09CA7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wdc.com header.i=@wdc.com header.a=rsa-sha256 header.s=dkim.wdc.com header.b=L2Je5fgD;
	dkim=pass (1024-bit key, unprotected) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.a=rsa-sha256 header.s=selector2-sharedspace-onmicrosoft-com header.b=jx4usppH
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1794449648; x=1825985648;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sLMr/H5+IB4m4MeaAWT61JOo3OSX2SGtsRWI1pCFlWU=;
  b=L2Je5fgD5sLEndRJYpv924uBbtK3OUiE8HjmsdBvtIc71N3YwpClgLzv
   bETBfBGsTQaxOO5O0gGk4ioAGO+BiISGjfnMBSejNHaU9Tx7wbbD2KLHd
   JmGUcb3t8Iw/DzLm9SqqMFFrbzgC7GQ5HW6qlISp3AT0ZojDT+jGdjUGM
   ndFIVA0vaL/LQ2KAO5eaSTu3AVSeL4TaKbYqe0HlqZlAdWiPigD6IleLH
   yb/KeCn6cNnjUKoF5cX9wE8vQS9lmpd/pI3ju91lxJxw03KNQqqfR1kgQ
   uj10Uy0oEhwUdbg4jDp8WqQliCRCbK/2G8dlGPNtv+6v2wfJRLPw5bF8t
   Q==;
X-CSE-ConnectionGUID: Yg8Hk1VhQdmLHygHpYSQtA==
X-CSE-MsgGUID: ODhadR5iS/qBLG1r220fGw==
X-IronPort-AV: E=Sophos;i="6.27,208,1786982400"; 
   d="scan'208";a="156453866"
Received: from mail-westus3azon11011028.outbound.protection.outlook.com (HELO PH0PR06CU001.outbound.protection.outlook.com) ([40.107.208.28])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Nov 2026 10:14:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UW/dEl6Pk8orhWt0mEy17/H+/kYPsp669IUv6HueqnKbGKK578jq2djMBRPtVLLOrzg7PWmxZnUb+LlF1iv65+Aa74sZA0PesfkW6Nkd3if2HtiTTVtKBk1PMUmwAs5D80g7VgCbINbPhyu1KrpxYNM0EhlHGsglWt7cnFAOTKNkQUPcfA1zc31gPk5cWBG4ilhcS+36QwliMpt6ZYo3pS5ZL1gdyePg7WhwcEHzGwPg6gSvQ1RP3lIioSiUFo6oZvxBea4gtzPLpb3XMWjfoeWH1CNA8P/1DehOGGo0FWpz8exDJcXqIu8J+EAhKx52h/LLZkoNmUXy1mnlYnS4pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bul5Xa04I2CSgYv/txAFKpvjGCn6mvE63bO1tp1zGoM=;
 b=DF+r9mXHTLmSb3bT9QXxrkyapz2ruGVE603Xpb3yERleQCt01JbH0k24xzPIKeok2w+z/RaRF6v7JTr20CqfV1M7BLUKbRFlJ7oolmj6Wc8MhUd2DA2dthLoeCZXbPJg8H9z4gf6MiJilglngdlNNd75uRCZN+NDysLBL5/VJUXM9Qcxu+oyzCrjt7HkC/ek8bib7qaAlxClMKYnlmPYb7nMsqBH/wrkbSzvSN8rTwfoyQJYLruTx9GZw6GHxZg+W12+XwWm8rez6/VgDm959Yj8QxV76LFQ5n+uw1ll6QTJn3EsB39WEvQ3KLId0QbKshDBF2OP3hRmRi3q1oCK8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bul5Xa04I2CSgYv/txAFKpvjGCn6mvE63bO1tp1zGoM=;
 b=jx4usppHaZrd3i7N0ENnBpFaVS7ehw8TeZe9yB13XwWS0DFrpXnl+2S0GAAU/6IdzLSEXFKq+UCUJZjH7ApRPaZ1TVf+ZuiECy1bM7xfA3kl16xvQCba+ab/mtrKQrKVP9Niwv86UVCwUeFbbl7lFqv1DQ0LiTavx9yNdhPSubE=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14) by MN2PR04MB6334.namprd04.prod.outlook.com
 (2603:10b6:208:1a2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Thu, 12 Nov
 2026 02:13:57 +0000
Received: from SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85]) by SA1PR04MB10065.namprd04.prod.outlook.com
 ([fe80::9b98:bf8a:b0b1:ef85%5]) with mapi id 15.21.0615.007; Thu, 12 Nov 2026
 02:13:57 +0000
Date: Thu, 12 Nov 2026 11:13:51 +0900
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, 
	Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Keith Busch <kbusch@kernel.org>, Surabhi Gogte <sgogte@purestorage.com>
Subject: Re: [PATCH RFC 2/2] nvmet-rdma: use a separate lockdep class for the
 listening cm_id
Message-ID: <avUgRda_hV069fNl@shinmob>
References: <20261108120154.148824-1-shinichiro.kawasaki@wdc.com>
 <20261108120154.148824-3-shinichiro.kawasaki@wdc.com>
 <20261110003243.GS663069@ziepe.ca>
 <avP07JWvBtMboL8k@shinmob>
 <20261111153712.GA2532299@ziepe.ca>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111153712.GA2532299@ziepe.ca>
X-ClientProxiedBy: TY4PR01CA0096.jpnprd01.prod.outlook.com
 (2603:1096:405:37d::19) To SA1PR04MB10065.namprd04.prod.outlook.com
 (2603:10b6:806:4dd::14)
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
X-MS-TrafficTypeDiagnostic: SA1PR04MB10065:EE_|MN2PR04MB6334:EE_
X-MS-Office365-Filtering-Correlation-Id: 144a8883-29a3-45e1-4f04-08df40629b9b
X-LD-Processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
WDCIPOUTBOUND: EOP-TRUE
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|19092799006|376014|23010399003|18002099003|22082099003|10067099003|56012099006|4143699003|261028144727099003|261009223027099003|261026140227099003|11063799006|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	8WfnTNfjoFDV9SLe3eut5apwQh+DMm0/DcpDdJRgbnPh6hoXAUumH3Y+x3Mrp3f7tQILBcaXDt9veoUIy2TlScDuomyEda7pWSKYTGsOrDnSvM0uKMbRnwtgv5Qjc624EWfHlRmSu/SCmwa3vNOBZEu5nTYeBqHEpqH2zvok1rFpCLxX/LbOgfYsqydbpRYy+RMc+OOK0/FlIyUJ5pNZ5HbRSrzvk4qX06HNV1ZGEiH3qqiWLQsSwGQVr3byQnytjM7twfmFO0PfneGDlE+dZqgF9LoL+UDTzK9NTNpW2Gtesy/1M01EYcvrkkTSEbLc2HZJ9t6CeCvnrbyK2DQRz+MElrMkX6hc3IZj3nOPG48sS3mStHtJsSIAMFin1hYXPU4Qs4I8xjzpmPpCgj51MyHJtoHaiAT1dVZD6HguGIJB6eXoUMAMW+Mu7mC7+Y/K/KH05QbePZ4yZmKUiNKZK2ru8mlQphQaK07w8HPlvzIOCPOG17Hl6fhJmpia4qe0zfeKujFZYbq/f5G6+iqPMVZRDNXMDzyrfMIjx5KxVBc+EZ3aCm5R2gkzXgUkbb1fxDHOWKKpqZUJd3lTrxCK1cdRedAmwucunJMDv7Wgg0zApu4ueSizU5xgsP/PeL+xQeTwINZ0WsH5z66eVpmogmQ5+FgJA6qrX2oI7ZS0vck=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR04MB10065.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(19092799006)(376014)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(4143699003)(261028144727099003)(261009223027099003)(261026140227099003)(11063799006)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H7IzFIg7BVAkSj0WM8TjDfvaf0OX3jNULA/KoTID6wqMDdBRtt+09YUnW1k8?=
 =?us-ascii?Q?NNPI0uiEBbvKhEMQuBZccjt3xwsnTFaN4NF05f8abPEh0tFQ5y89ZmmongOU?=
 =?us-ascii?Q?zMND5LWaqBJrSMFrLHlzc9eQ++rQ6fzGFhz162xa3d6cGMcQsU3YGidHsEpY?=
 =?us-ascii?Q?K0h8yRXV/R+vsEFYQoloG75d1AM6ZONa2syWLJW85959Q5f07PhfiZvaq1PI?=
 =?us-ascii?Q?kUlJ/35qkkODBlps164CXCW/6+CAaoxDEi731jxkGAnc4efY5FSPD3ZtLSrv?=
 =?us-ascii?Q?eGpuSeSyXx3qQpe7I2nkDq86I8jv9bv42ZbGLI4KNfOPf459ZNEUiAWdK4eY?=
 =?us-ascii?Q?WdTh7YtRur/LWVpz5zev2dKMcRvWQ5C4rtEzB7jrzJ0V7b1TW/w4uzYX38cU?=
 =?us-ascii?Q?ZsWax6zK/NKvOVP/CGiopY2+m+qUyKOP+U0L8r27xf2RQZ6K1/gXDuAw17xI?=
 =?us-ascii?Q?YAMWQrTjt5rTGN3Z5g3806GYFV7lSDDWT/G5aKd7ebizZfLYSw8VUjNTWSwW?=
 =?us-ascii?Q?nMbZXYpA8eS9kSr3tcgIvxBRXVG+qs+ifpbf9GW7gI1cAcAHhue9D6NWWc2F?=
 =?us-ascii?Q?FtR8sO6igeQSRS1maHZ2CnM1/yWHtZY0n2fTCpJ0R1yZkRbf6xI+x4Ntf5HD?=
 =?us-ascii?Q?RGJYQ0j15v6R5+MZ415lXsxTvkyPHB5NEKUBz0m3opEyBW/XOW4lQTANk4te?=
 =?us-ascii?Q?vgqnXE0ZAxJ+VIBsMRH3d8o/DvGA/VM63w5VdhONk4tKH7IkhZ+QWWEY9ARa?=
 =?us-ascii?Q?xphxZbHP9qB2UHZZs+3WWParluiWdB02i7rzDZxoGqTfNsM/64oAVRa+hx4d?=
 =?us-ascii?Q?ekPnj1H7bEMxWcVVN1OlPF7+Nl/9jIfE4gjfYXzXlnfnKzsdipQtFz0AY7rj?=
 =?us-ascii?Q?3BYRZWjXz9oQrq58NzwW8Tq/3Tb+iyascYU1YeZ7djDx7EIRlLsLZcpLKe0J?=
 =?us-ascii?Q?GXg4e/NtwLSjek/x6OfcBcm7CtlZHG2Qqdtr8uH1h35b2QVoR2TefP9mP8q2?=
 =?us-ascii?Q?UZ0iW3osAGeEV2j/IDHmT9RQA1/Qj1w4QJkOC2o4PuV3KpSPaWOCi0l4Vyic?=
 =?us-ascii?Q?lvkmuGSYyjyJOWnvxrHPRWqfk1PdvQTmbZnqsXRvzTwT3G7gmpoi+Z5r8n40?=
 =?us-ascii?Q?7dsy+jB5XgbAOsG8WuKLU5H4T72Y/U8PCBHUhquEtr4+hVRAr6aU29SDMywJ?=
 =?us-ascii?Q?MyjM6wg5GtZU8wcD+9Ux9px2ANUNKEojvSdrf6ZGecobXypt/YqVaUASRGVu?=
 =?us-ascii?Q?tA+/Wxyh+jTVpqiNA3ymMCviUMxpnUzKyQxkiFlruu5y9mMgIBQoJLkTX18v?=
 =?us-ascii?Q?jtmwH8jXXZ43OuQALxnnebUZW0vtA3N/KkeX+0LatP8AG5ljpY52kSDThSkr?=
 =?us-ascii?Q?RbiF9fbnt80uDV/P1Jr8/QKRgzDizpsG4kR7LWzRevLWirFlhru9Zr3DMWKJ?=
 =?us-ascii?Q?SSFsES+pqJoI5v+xTxg2uqvjkNGe9du50rAmPj8qRjQC7MV/0hMDi98ZaWLO?=
 =?us-ascii?Q?U9fFhQvsUAEAOVRIDju/psD2NbMPECucMLYBLBvQ323tSpQyfrq410bjiVNp?=
 =?us-ascii?Q?K6XCLpyJAhzQOcTWYvTVJkHYeFgnW6mHelfg+ONjZSyqrtgvUxdomDLcewp/?=
 =?us-ascii?Q?dRDAuDpiHyy3PNAFX5wlJ453T6q/3lEZWkOzwiDyNRpoO74sNEJlERSXX1fq?=
 =?us-ascii?Q?FbVmcOIkEOjx9ahvHrqlLutWK6OJnDOwonzdrH+LzTk6ayf0uo0e/s3Gs25Q?=
 =?us-ascii?Q?v64tHY65pZqlxyIkxeIQw3nLuFQwkIk=3D?=
X-Exchange-RoutingPolicyChecked:
	cPn5UsvGFgOOwYEOR12/HNUWUv66w6mYyslRJCk/2EqFZ01zNul2eqJ1tVFi4P7P/YOUtn7wQdRyWRx3+wOavAhUKPNFhk/gpQ74mCFQIyLR9MT+kIqR+ArOYIJJ4WC8/32ZvMkGX367H4AynWMWLID/X78zNaWCYlq5Dq5bM/fEptw5hByJm33IGXmvAn1AFlpkx7CvgbPhd+spZJThCDL06QOHX15XX2nyZc8Pi5uqsFp+etXf4hL+B8yhRfch+wy9Q3PPa7ui3qeDv2dVreBlMtl+Z6rcCv7pH5mne+Jg2Eq5JeiB+NUwcl4+3nIJ5JOYDNo6Ff/gGkr54tTjOw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AJ1TauLED8vvVGt8YWqOmFeLBmHqfthfV1p9VU+REeKbnHSNlS+DAExJDwt8P0kxQsdra5ILNgGX8s18gJQMji+KSKJ7tQmAlq9hN6soIeJO9jL4+q8OxDcwvSoN6EbcDJ2wL/NwyfGSCq+IX8gM+ADrOm1MD9rz+xa/jOXuaojhEQqORsQoqj9gTSZT+phfndVKKtUeAB8W1y+0SEexDDGrF2BRahWjNBaUFr2boYevVIU6zgSFBHerFeY/xUJJk3U5DwMIvkAF8zvIBCXJ07tL3UVU9pACGJ3ddol+0gImzwE4HvSWRa3hyHHbXdJs0yN9TaqxxisFVwC99u4uKV1fD/twrsjdpBNOCSczT6mlO/7lN+RFEiIqq3xBE9lb3FswG6ZfNur9V18OB6a7Qc1bve6baFfZrCktlE9lvuwxarYduxlZHy9ZPsLG4xo1TiZS4FA5xxWDViq0DvYnnzXn90ovQ764DuQGLJgUwhOVFutYi8YFUI25OgZ/WFoXBbMEF/ADLGKu2VgtQCwSe9ltnxjvIPGBTWIR8T1EbGF9fvFvT3huj7BD+8Qzrmo7KFASGjR7V/8N2uoRiq80y02zbpN1toWEt/wyix3aN5DddQgUTJJRN8cfPiTx46NF
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 144a8883-29a3-45e1-4f04-08df40629b9b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR04MB10065.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 02:13:57.2497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1zxQMsiNrdNBOdBraWsnVRQFajo1I9qn5HhRodvgMdeLv+nmbrAm2mwjW/Jr7KgXXkLUyPrIEmnv9W4+aAmworbyGAlFmfPAek70xwcKYio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6334

On Nov 11, 2026 / 11:37, Jason Gunthorpe wrote:
> On Wed, Nov 11, 2026 at 02:01:58PM +0900, Shin'ichiro Kawasaki wrote:
> 
> > diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> > index 337a49d1acf7..334f39c2f5e5 100644
> > --- a/drivers/infiniband/core/cma.c
> > +++ b/drivers/infiniband/core/cma.c
> > @@ -3949,6 +3949,12 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
> >  		container_of(id, struct rdma_id_private, id);
> >  	int ret;
> >  
> > +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> > +	static struct lock_class_key cma_listen_handler_mutex_key;
> > +	lockdep_set_class(&id_priv->handler_mutex,
> > +			  &cma_listen_handler_mutex_key);
> > +#endif
> > +
> 
> This seems OK, I think we already have examples of this in CM IIRC?

Yes, I think so. siw and rxe drivers use dynamic lockdep classes for their
sockets:

$ git checkout v7.4-rc2
HEAD is now at 7475ea8b5861 Linux 7.4-rc2
$ cd drivers/infiniband/
$ git grep lock_class_key
sw/rxe/rxe_net.c:static struct lock_class_key rxe_recv_sk_key[2];
sw/rxe/rxe_net.c:static struct lock_class_key rxe_recv_slock_key[2];
sw/rxe/rxe_qp.c:static struct lock_class_key rxe_send_sk_key[2];
sw/rxe/rxe_qp.c:static struct lock_class_key rxe_send_slock_key[2];
sw/siw/siw_cm.c:static struct lock_class_key siw_sk_key[2];
sw/siw/siw_cm.c:static struct lock_class_key siw_slock_key[2];
