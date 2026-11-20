Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154263;
	b=BxwW4Uc1FOhn9mdfxQN22QGbEwJzOWZyn9YOMHNulDtTyA62l7ooyGUpe7eGtdesOhSQ
	 7U/7qs9WFONTwZcjLXfGPaqtV3htclo1u28KFcyT7pr6CvTzAzfTVIe0NWxx6rx1Rz1rK
	 9CTNRdTzEVrWtPQC1VUVo/XTFOR84UUbsT9iUMOTDC8Zna3asedmjgY93eKQ4GSSi564A
	 pfYyJlTr/qwnZWljaXb3lFIPIyzwp19ftqjSLttHTN/NU2KXkJD50vLkWozlNjB5EWTcJ
	 SOsgNMJNvZmYIugsTPlOAmF7CdimASlATAUGzalghgMrkxGMeh98P7LqPbcBYAWIrbA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154263;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:Date:Subject:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=iMo+q28BVJ11G8Jb6hXDBtHA9DayjRrXgrruYHeLwZs=;
	b=Ir4QZKawpmbRfHYQI/3zqxtfoU7H7Y0GvWnkv0bMcqw0WmPrktXvzIz5ACPTktXc6hZM
	 qn4vNi43nWNyKD6QccameWBGxS0wYp7W+FpDLo9Mik7zMmNeQn67fPQEGiCOpTCEzwELS
	 qz/D0bS+h6pIjAwJzGMrzhIk1CAGdopU2L0AOb//58T6gStMQ+Oz0dPniUWzkeihdyxZt
	 MgE+rJXN3VJKTF/qh54woG94ac9BUMJXIImIfsw1fWUGDXmBKW5h7M4Lg4+K5I+WED+q0
	 VgL5EQ3DVS/o/i6DLa540zfuC4h5gMbN/n03I0USIqW4/fNpx518QAwiT7pv6DBH4gw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NcLI9kzg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.52
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012052.outbound.protection.outlook.com [52.101.48.52])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E47260A3809;
	Fri, 20 Nov 2026 05:57:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E47260A3809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NcLI9kzg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tm4wEuabISUbhNK5H2RGbPEz6RSEz25iR629WQk8k7oDYq60+6CLnG3y14IGtOo4lgFUOyOLZlBMHHl369ZiO4N1nfcrWZvn3TYAA5t77W/cd3rsm1GP3+RJ8RBS09Woxd8zIFhKqFwf9KNpsrI1z5KRlIW6GY1SHG748frijVFRUa/HR0Kt6rCu1PeYHLiliqCQrtgaAOXuc+A9NgHxkpSQtxVurWvUdNUyEvcmTniNOqOo4wDadXZCBf3OSoqy/SnhNrqIlBDSE9tdcc0GZyAezm+T2rbJnaFxmIDxbnvof8YIe6vp5099KbA8uPkBxM6X9rHkUhM6zievWBRjiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iMo+q28BVJ11G8Jb6hXDBtHA9DayjRrXgrruYHeLwZs=;
 b=TPZtGX0HMGfHbjLG/u1zHO4SewqiXCdfVUnVLyr0Xl7p0+nav5bChJp9NrT8yIuy/ZF8zpw4k+Mk2ErvIveiNXTSlYPzb0mIeZbU4LxR0E9sKUrLbqnaTXY6TKQI7nBdCcAaVtJ2tjfdDFGuRt8plL8QT5ACeuB2jOrLMb8zS65Hv77ucVPXQ/eK3mGBo+9MxpyV4o/7tQkwCihHikdPT9KZoObF/7YVOLPB8Dmln1VktWuZrQDnuaCm4Tahg0l48MjM1SJwLjgHoCuRaJym3b4YnDBeS9ca0nLwaYMOm2Hhy1JH/WpkzZupIaYz3fOT3a1iSXHxJjofCQUgYMVoGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMo+q28BVJ11G8Jb6hXDBtHA9DayjRrXgrruYHeLwZs=;
 b=NcLI9kzgpC4Hwt4Pfhb5FVDe4tII9E6wAJQ/+LNdJyG1RsXAp2s/eQ/iFgHfeuq+VKihX9V/pEo5tJaHVoyqDHw38nJv1+Td1WqvPaLe4/vH+pHn9j/ZGLKe4tWw15sKtkNzcpw418uQ/91ZarnmS0vaZeWRHuJLDX7Fe87cp4TyVe+M5oZHpcpUNe9KOBEt56L6LITGwPgKLgCbedqW5p7vsa3g6EfqJLa0xByMh+RcrfWwj/Cl2J4SJB/miKxc60TEk+MkscBezXFFQp3SUL8NEUWtIdGRReqpGjixHA1DXILGUBcaNB/S1C4EXRL3flDiYOF+jFtFrvoKJ7fB0A==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB7675.namprd12.prod.outlook.com
 (2603:10b6:208:433::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Fri, 20 Nov
 2026 05:57:32 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 05:57:32 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Fri, 20 Nov 2026 16:55:50 +1100
Subject: [PATCH v3 12/24] drm/amdgpu: Use the SGT mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261120-dma_mapping_type_v4-v3-12-c0183a409bdf@nvidia.com>
References: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
In-Reply-To: <20261120-dma_mapping_type_v4-v3-0-c0183a409bdf@nvidia.com>
To: =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Simona Vetter <simona.vetter@ffwll.ch>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dongwon Kim <dongwon.kim@intel.com>, Kevin Tian <kevin.tian@intel.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, 
 Karl Mehltretter <kmehltretter@gmail.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, 
 Felix Kuehling <felix.kuehling@amd.com>, 
 Alex Deucher <alexander.deucher@amd.com>, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 amd-gfx@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, 
 iommu@lists.linux.dev, Keith Busch <kbusch@kernel.org>, 
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Mina Almasry <almasrymina@google.com>, 
 netdev@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>, 
 zhipingz@meta.com, treding@nvidia.com, jhubbard@nvidia.com, 
 chaitanyak@nvidia.com, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795154186; l=14095;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=98kU3Dm8J9lvO7QRSZW2eae9d9/0VLhkptMBOqqwmh8=;
 b=FiMFzzK5rnY8idQ5WSz+zlDKjSCF9yabe+b+fUHrSXIeyIuCrI74mKfy53wpMGJlCdiGQ/Yr+
 W3pJHmkCk6ZBm+XQb+pP0ir+VmLEpSxjOUynHiH6KBynpN46Z0WiVN/
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P282CA0022.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:202::15) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|IA0PR12MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: 408fcd60-c3f4-45a3-08f2-08df46cb2aef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|10067099003|11063799006|56012099006|261021123027099003|261028144727099003|261022105027099003|261026121527099003|261026140227099003|261021121427099003|261102130727099003|261102123227099003|261009223027099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	kEgZcY0a1vvWNdaOogdLj+RzCuUFCimwXlkQ40WRv5pe0FnOhbK+4lHI9SfAaMPOA3IBlChWOkAs1FpKqIfoeP4Znk+D1rXp6U5m4cX9k4+D0/42njnKtD+f0YHLEwpcqXovfuG6pav3IIFPuGehZyaIgiU5rCIQniVx5w7wtWF5wQXngyMBWp2BcuYrIRR/s86z6pXsWU9bUGUAP/Z2Vnf2xv1rU0FgXEBzX4jPyppKOI8+bB0yBs7qdrKjwj9oWgwv6K9iXoVdCMBtsx1cAajtBhDCUlrVHAk4pUnKsrn/C20/5nhyXIoY7uBqFKqcgTKOrOdRMxR2A5jdhg9F/L01n4eTHmsOjXHpHWEm5LtN3J01OLs6B+b9NpmF1uVpgGrAzuNx4lU4hgqQgxEP8b7d93LKAoJ4yGsNcVBHa4Af9pifCLrUoyUDpuDBAntsLdCAX2LmHiKsHEFLbr+JBUdZLbQoVhLb2xKyMyzil7RtRTmIoekqqfjydy97axgP3bcY/dLgD/lLsLBRECbOKcKSbIeyXQbSYNgx9fxgGZCJCaqTJ8rUp7sYxZlWU2U9Mdu4H1J6Wl7kMXO7tPKVJiJgmNBKI2xdN77Kb0B/5YQW6JDCKOuJehmOFlApaF3WF/pXOUaXC2Fc619pbGk74deXb0U2DAj+1oGnBSObu/Vheh3zZmrwPeY+dvDs7JTnrOPIosJ6XwSCkDYKRClMIQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(10067099003)(11063799006)(56012099006)(261021123027099003)(261028144727099003)(261022105027099003)(261026121527099003)(261026140227099003)(261021121427099003)(261102130727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFZUUklzdlZvQ2w1MGtTc29ZOS82eWVhSmlidXR1RDFQSUtIT3NyWHdTRzR4?=
 =?utf-8?B?Y0oxY3puVkg1c2QvSUltWmV0alUxTEJYelBLRkljUi84RWhLUEVzY3FoNk1s?=
 =?utf-8?B?ZTZPN3hKdm1DeHhzSGtBYk9mWWdXS3NqZVR3T1p6dUI0cGdSMi81cllqTVhz?=
 =?utf-8?B?TkhOa0ltSitQNU96UEVaM2c1SGRZV2hYTTVvVVFBRXo3ajBBbVdFNzlVaU55?=
 =?utf-8?B?dmVrMWx5OFR3bDFydWJMRG1hOXhmUzE4Sm9Bbi8wWFdXZmMzTHd1djEwOW5I?=
 =?utf-8?B?ZnZIeFFUMHJpNFViQmVobXE3NHJWZzRjSGZWMnJmTzlOODVlNzZrQ2g2andr?=
 =?utf-8?B?c3FVV3pxT2VYSVRLSEdXK3lYZExmakYzWCt6Q0tCUC9acUZNZ3dLYVdUdmNI?=
 =?utf-8?B?RkZBZFVEQ3ZUaUFQNkEzRjdZT0luS3ZNSVh4THNHRDNqRm13Vi93ZmhBeWti?=
 =?utf-8?B?SU81QjdhRk44ZVhVZnl2dWhOa2RKSTEwVm9Bd0NFNjYzS0srcmJmL3EyV2RB?=
 =?utf-8?B?SFlkRkRFMU8yVWNFRCtaNWs5TGFCVWNpZTd6OFo1REZPeFZhTE05dURLZ2cr?=
 =?utf-8?B?RUdYTDhKYnZ5K1o5NzRoWnJiR3NhanpqaWwvdzFtUmh0QUljclRkTXkvbUNn?=
 =?utf-8?B?TTRNb3MyUWJ6dk5hTG5LdTh0MFNsRzM1ZmszOVZTa2NnZzhpMTIxRlhwNlZM?=
 =?utf-8?B?dUhwazBkbEFFVURZaXFDNzJ5cThvZEUwS1N4YkRQYzkyTThxU004Q1BtUi9n?=
 =?utf-8?B?MXNKaC9mMFB5V3lOTHd3dGdXOXN2WGFxeVlvdlA2eG5oREZINERpak9wSkE5?=
 =?utf-8?B?TTgvZzBlWlM1ZWduNWcwMUt2MlNacjNWQTY4Y0FoanVRT3ZaNlNXUUxyTEtx?=
 =?utf-8?B?a1d3UmhYWUN3bXJ1Y2Vlb0lMUWppVXBkN2RmRjlVWklvYXc2dkNxWmtRRFNM?=
 =?utf-8?B?eFBXbmhmc3QrZFJLNWVITjNFdkgwbElHamRUeFRjT2trZk5maitPZjBWN2Ro?=
 =?utf-8?B?Y2pVUlRZNUJJWGtSMzVlbVhsalhOWXVsYmlPLysyUm5nYlZHMGVPbEx4VTB4?=
 =?utf-8?B?ZUVoWTBqMVNacWZqMGQrOWMxVEVqc3FWYkpPbGRDRFY0bGplNzJ4dWRjNVMw?=
 =?utf-8?B?aG0vZTFOTWU0UXhZMkpvcDlGQ0FNTTduamx1bHdoZmREOWREWTNEV05pOG1Z?=
 =?utf-8?B?emVKekF4M0xlZTA5M0RCZEg5Wm1OeFo1Si9zSU1odjFPbUFIUXQ1ZVJtNEwz?=
 =?utf-8?B?TkdwRWphdHZqUk82NzJyNTVORjVXY1c0THRuUitUMlJPRkRkV0pUZ1JSOENn?=
 =?utf-8?B?S0pwakYvZE42T0lzV0tRaGo4SDlZd3FpUEZaeWZ0MmdIQWhpU3ZpUGt0R2JC?=
 =?utf-8?B?Q1R5ZHlNRW1rZmZUQmNCemlzazVoYUp6UkJrR2hXUS8zMEV4YWJNaGtmMm1Q?=
 =?utf-8?B?YmJxeTZycWdxUURESUd4T09MLzlEWEowMmNoQ3llbkJHMmhXWVlqcUROWjZr?=
 =?utf-8?B?aDAwRGhXTk5rYmR5NU1yOFd6ZG9nM2VleTdoSEtCTmFIbDkvUVQ2RnFONUN1?=
 =?utf-8?B?bnZTR3Z6YTNCQmswYWt0cVI5eUZtaTkwUXdtY2VXQWszcXUzc09JdlVEcWRk?=
 =?utf-8?B?QTQrMnNRZGpieWVockNmRjhMSU51ZGJlWEhseVBqaXZrSXZvVU5aZWJSVlEx?=
 =?utf-8?B?eDc2aHJOakd6cGZKUjZ6YjY0SUU5WFEyRXBGZTdlOUFNTERVdGhub2hncStw?=
 =?utf-8?B?VFJyR3l1ZUQxYXZ5aXFMSmNUVzNFNndaYXBMMWMyWkpyRW5jQ2pCOUMyeW4y?=
 =?utf-8?B?alNkTHpTQ2t0RXVab3prVzlhQmJaR29FR0diK3lhdGFNbng5enk3REFqVk1V?=
 =?utf-8?B?d3hOQ05SajN1OE5aSVNRa1BYQW5xajQwQ09ia0dBSWdsWHZiRDNpeWkxY1pz?=
 =?utf-8?B?UEtMc2ZmQmY4NmhkUXlvdExtU2hjOGxSUXBuMVl1VmZwQ1BHREVGTnNhMlN0?=
 =?utf-8?B?WlJBSWxMc0NCcUhUQ0F3RU01OTZlZko2M0NkbUJBaUZ2SzlpMUhPSEZjSkZq?=
 =?utf-8?B?djZybFpLSWpKbHA5Ty9SdEw3aWpCVWo2RVpiQTd2eFBkYkhtNVhKS013ZEhn?=
 =?utf-8?B?ZFJDL3FRYUcwbTRsMXNDTkRxQUtZWEVFdTQ4Ky93NnIyMU9ST2hPNWtZNjk3?=
 =?utf-8?B?ZHZ4aVJ0UWx2emUxeHNrU3A4UTRpYi9GeTJJcGxRZjZVZ2QrK1UvVXI2ZTFa?=
 =?utf-8?B?bDlYa08vVlFlcDY3SFFZandzYW41Vms0NmFLQU1mb1ZRRzZKL1V5YjlqTHkr?=
 =?utf-8?B?OFQvRld4WDZacVd1ODcyL2dOVHozSHlQTTV1NjdQU2dUYXZiajc4QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 408fcd60-c3f4-45a3-08f2-08df46cb2aef
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 05:57:32.5067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h/mVEl+wjyXihnwlzhlMIcMtLiu2EaJI8HDbJ9oJr5CKZ2MfCPHXyAMTWAxiHH8o4ZN9vUvo9r0cIiuymMinkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7675

From: Jason Gunthorpe <jgg@nvidia.com>

Move amdgpu's map and unmap callbacks to the SGT exporter ops through
DMA_BUF_SIMPLE_SGT_EXP_MATCH() and take the importing device from the
match entry with dma_buf_sgt_dma_device().

The SGT exporter ops return a struct dma_buf_sgt_mapping, so
amdgpu_dma_buf_map() must allocate one and build the table
in it. The GTT path takes over the entries of the table
drm_prime_pages_to_sg() returns, and amdgpu_vram_mgr_alloc_sgt(),
amdgpu_ttm_mmio_remap_alloc_sgt() and their free counterparts fill and
tear down a caller-provided table instead of doing allocation and free
themselves.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c  | 85 +++++++++++++++++-----------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c      | 25 +++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h      |  4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c | 30 ++++------
 4 files changed, 74 insertions(+), 70 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index bbe518757907..7b110405b08d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -41,6 +41,7 @@
 #include <drm/amdgpu_drm.h>
 #include <drm/ttm/ttm_tt.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-fence-array.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/pm_runtime.h>
@@ -98,7 +99,8 @@ static int amdgpu_dma_buf_attach(struct dma_buf *dmabuf,
 		attach->peer2peer = false;
 
 	if (!amdgpu_dmabuf_is_xgmi_accessible(attach_adev, bo) &&
-	    pci_p2pdma_distance(adev->pdev, attach->dev, false) < 0)
+	    pci_p2pdma_distance(adev->pdev, dma_buf_sgt_dma_device(attach),
+				false) < 0)
 		attach->peer2peer = false;
 
 	/*
@@ -203,7 +205,7 @@ static void amdgpu_dma_buf_unpin(struct dma_buf_attachment *attach)
 }
 
 /**
- * amdgpu_dma_buf_map - &dma_buf_ops.map_dma_buf implementation
+ * amdgpu_dma_buf_map - &dma_buf_mapping_sgt_exp_ops.map_dma_buf implementation
  * @attach: DMA-buf attachment
  * @dir: DMA direction
  *
@@ -215,13 +217,16 @@ static void amdgpu_dma_buf_unpin(struct dma_buf_attachment *attach)
  * sg_table filled with the DMA addresses to use or ERR_PRT with negative error
  * code.
  */
-static struct sg_table *amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
-					   enum dma_data_direction dir)
+static struct dma_buf_sgt_mapping *
+amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
+		   enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct dma_buf *dma_buf = attach->dmabuf;
 	struct drm_gem_object *obj = dma_buf->priv;
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
+	struct dma_buf_sgt_mapping *mapping;
 	struct sg_table *sgt;
 	long r;
 
@@ -241,80 +246,95 @@ static struct sg_table *amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
 			return ERR_PTR(r);
 	}
 
+	mapping = kzalloc_obj(*mapping);
+	if (!mapping)
+		return ERR_PTR(-ENOMEM);
+
 	switch (bo->tbo.resource->mem_type) {
 	case TTM_PL_TT:
 		sgt = drm_prime_pages_to_sg(obj->dev,
 					    bo->tbo.ttm->pages,
 					    bo->tbo.ttm->num_pages);
-		if (IS_ERR(sgt))
-			return sgt;
+		if (IS_ERR(sgt)) {
+			r = PTR_ERR(sgt);
+			goto error_free_mapping;
+		}
+		/* The mapping takes over the table's entries */
+		mapping->sgt = *sgt;
+		kfree(sgt);
 
-		if (dma_map_sgtable(attach->dev, sgt, dir,
-				    DMA_ATTR_SKIP_CPU_SYNC))
+		if (dma_map_sgtable(dma_dev, &mapping->sgt, dir,
+				    DMA_ATTR_SKIP_CPU_SYNC)) {
+			r = -EBUSY;
 			goto error_free;
+		}
 		break;
 
 	case TTM_PL_VRAM:
 		/* XGMI-accessible memory should never be DMA-mapped */
 		if (WARN_ON(amdgpu_dmabuf_is_xgmi_accessible(
-				dma_buf_attach_adev(attach), bo)))
-			return ERR_PTR(-EINVAL);
+				dma_buf_attach_adev(attach), bo))) {
+			r = -EINVAL;
+			goto error_free_mapping;
+		}
 
 		r = amdgpu_vram_mgr_alloc_sgt(adev, bo->tbo.resource, 0,
-					      bo->tbo.base.size, attach->dev,
-					      dir, &sgt);
+					      bo->tbo.base.size, dma_dev,
+					      dir, &mapping->sgt);
 		if (r)
-			return ERR_PTR(r);
+			goto error_free_mapping;
 		break;
 
 	case AMDGPU_PL_MMIO_REMAP:
 		r = amdgpu_ttm_mmio_remap_alloc_sgt(adev, bo->tbo.resource,
-						    attach->dev, dir, &sgt);
+						    dma_dev, dir,
+						    &mapping->sgt);
 		if (r)
-			return ERR_PTR(r);
+			goto error_free_mapping;
 		break;
 
 	default:
-		return ERR_PTR(-EINVAL);
+		r = -EINVAL;
+		goto error_free_mapping;
 	}
 
-	return sgt;
+	return mapping;
 
 error_free:
-	sg_free_table(sgt);
-	kfree(sgt);
-	return ERR_PTR(-EBUSY);
+	sg_free_table(&mapping->sgt);
+error_free_mapping:
+	kfree(mapping);
+	return ERR_PTR(r);
 }
 
 /**
- * amdgpu_dma_buf_unmap - &dma_buf_ops.unmap_dma_buf implementation
+ * amdgpu_dma_buf_unmap - &dma_buf_mapping_sgt_exp_ops.unmap_dma_buf implementation
  * @attach: DMA-buf attachment
- * @sgt: sg_table to unmap
+ * @mapping: mapping to unmap
  * @dir: DMA direction
  *
  * This is called when a shared DMA buffer no longer needs to be accessible by
  * another device. For now, simply unpins the buffer from GTT.
  */
 static void amdgpu_dma_buf_unmap(struct dma_buf_attachment *attach,
-				 struct sg_table *sgt,
+				 struct dma_buf_sgt_mapping *mapping,
 				 enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_mapping_dma_device(mapping);
 	struct drm_gem_object *obj = attach->dmabuf->priv;
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
+	struct sg_table *sgt = &mapping->sgt;
 
 	if (bo->tbo.resource &&
 	    bo->tbo.resource->mem_type == AMDGPU_PL_MMIO_REMAP) {
-		amdgpu_ttm_mmio_remap_free_sgt(attach->dev, dir, sgt);
-		return;
-	}
-
-	if (sg_page(sgt->sgl)) {
-		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
+		amdgpu_ttm_mmio_remap_free_sgt(dma_dev, dir, sgt);
+	} else if (sg_page(sgt->sgl)) {
+		dma_unmap_sgtable(dma_dev, sgt, dir, 0);
 		sg_free_table(sgt);
-		kfree(sgt);
 	} else {
-		amdgpu_vram_mgr_free_sgt(attach->dev, dir, sgt);
+		amdgpu_vram_mgr_free_sgt(dma_dev, dir, sgt);
 	}
+	kfree(mapping);
 }
 
 /**
@@ -393,13 +413,12 @@ const struct dma_buf_ops amdgpu_dmabuf_ops = {
 	.detach = amdgpu_dma_buf_detach,
 	.pin = amdgpu_dma_buf_pin,
 	.unpin = amdgpu_dma_buf_unpin,
-	.map_dma_buf = amdgpu_dma_buf_map,
-	.unmap_dma_buf = amdgpu_dma_buf_unmap,
 	.release = drm_gem_dmabuf_release,
 	.begin_cpu_access = amdgpu_dma_buf_begin_cpu_access,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = amdgpu_dma_buf_vmap,
 	.vunmap = amdgpu_dma_buf_vunmap,
+	DMA_BUF_SIMPLE_SGT_EXP_MATCH(amdgpu_dma_buf_map, amdgpu_dma_buf_unmap),
 };
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 30ec5cb9ddf5..9104b36f6184 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1114,9 +1114,9 @@ static void amdgpu_ttm_backend_destroy(struct ttm_device *bdev,
  * amdgpu_ttm_mmio_remap_alloc_sgt - build an sg_table for MMIO_REMAP I/O aperture
  * @adev: amdgpu device providing the remap BAR base (adev->rmmio_remap.bus_addr)
  * @res:  TTM resource of the BO to export; expected to live in AMDGPU_PL_MMIO_REMAP
- * @dev:  importing device to map for (typically @attach->dev in dma-buf paths)
+ * @dev:  importing device to map for (dma_buf_sgt_dma_device() in dma-buf paths)
  * @dir:  DMA data direction for the importer (passed to dma_map_resource())
- * @sgt:  output; on success, set to a newly allocated sg_table describing the I/O span
+ * @sgt:  sg_table to fill with the I/O span
  *
  * The HDP flush page (AMDGPU_PL_MMIO_REMAP) is a fixed hardware I/O window in a PCI
  * BAR—there are no struct pages to back it. Importers still need a DMA address list,
@@ -1131,9 +1131,9 @@ static void amdgpu_ttm_backend_destroy(struct ttm_device *bdev,
  * - Peer reachability / p2pdma policy checks must be done by the caller.
  *
  * Return:
- * * 0 on success, with *@sgt set to a valid table that must be freed via
+ * * 0 on success, with @sgt filled; tear it down via
  *   amdgpu_ttm_mmio_remap_free_sgt().
- * * -ENOMEM if allocation of the sg_table fails.
+ * * -ENOMEM if allocation of the sg_table entries fails.
  * * -EIO if dma_map_resource() fails.
  *
  */
@@ -1141,7 +1141,7 @@ int amdgpu_ttm_mmio_remap_alloc_sgt(struct amdgpu_device *adev,
 				    struct ttm_resource *res,
 				    struct device *dev,
 				    enum dma_data_direction dir,
-				    struct sg_table **sgt)
+				    struct sg_table *sgt)
 {
 	struct amdgpu_res_cursor cur;
 	dma_addr_t dma;
@@ -1156,21 +1156,15 @@ int amdgpu_ttm_mmio_remap_alloc_sgt(struct amdgpu_device *adev,
 	phys = adev->rmmio_remap.bus_addr + cur.start;
 
 	/* Build a single-entry sg_table mapped as I/O (no struct page backing). */
-	*sgt = kzalloc_obj(**sgt);
-	if (!*sgt)
-		return -ENOMEM;
-	r = sg_alloc_table(*sgt, 1, GFP_KERNEL);
-	if (r) {
-		kfree(*sgt);
+	r = sg_alloc_table(sgt, 1, GFP_KERNEL);
+	if (r)
 		return r;
-	}
-	sg = (*sgt)->sgl;
+	sg = sgt->sgl;
 	sg_set_page(sg, NULL, cur.size, 0);  /* WHY: I/O space → no pages */
 
 	dma = dma_map_resource(dev, phys, cur.size, dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (dma_mapping_error(dev, dma)) {
-		sg_free_table(*sgt);
-		kfree(*sgt);
+		sg_free_table(sgt);
 		return -EIO;
 	}
 	sg_dma_address(sg) = dma;
@@ -1187,7 +1181,6 @@ void amdgpu_ttm_mmio_remap_free_sgt(struct device *dev,
 	dma_unmap_resource(dev, sg_dma_address(sg), sg_dma_len(sg),
 			   dir, DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sgt);
-	kfree(sgt);
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
index adb6cfae5052..c20db985137a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
@@ -164,7 +164,7 @@ int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
 			      u64 offset, u64 size,
 			      struct device *dev,
 			      enum dma_data_direction dir,
-			      struct sg_table **sgt);
+			      struct sg_table *sgt);
 void amdgpu_vram_mgr_free_sgt(struct device *dev,
 			      enum dma_data_direction dir,
 			      struct sg_table *sgt);
@@ -266,7 +266,7 @@ int amdgpu_ttm_mmio_remap_alloc_sgt(struct amdgpu_device *adev,
 				    struct ttm_resource *res,
 				    struct device *dev,
 				    enum dma_data_direction dir,
-				    struct sg_table **sgt);
+				    struct sg_table *sgt);
 void amdgpu_ttm_mmio_remap_free_sgt(struct device *dev,
 				    enum dma_data_direction dir,
 				    struct sg_table *sgt);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 249f07f30951..3d245467b983 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -671,26 +671,22 @@ static void amdgpu_vram_mgr_del(struct ttm_resource_manager *man,
  * @length: number of bytes to export in sg_table
  * @dev: the other device
  * @dir: dma direction
- * @sgt: resulting sg table
+ * @sgt: sg table to fill
  *
- * Allocate and fill a sg table from a VRAM allocation.
+ * Fill a sg table from a VRAM allocation.
  */
 int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
 			      struct ttm_resource *res,
 			      u64 offset, u64 length,
 			      struct device *dev,
 			      enum dma_data_direction dir,
-			      struct sg_table **sgt)
+			      struct sg_table *sgt)
 {
 	struct amdgpu_res_cursor cursor;
 	struct scatterlist *sg;
 	int num_entries = 0;
 	int i, r;
 
-	*sgt = kmalloc_obj(**sgt);
-	if (!*sgt)
-		return -ENOMEM;
-
 	/* Determine the number of GPU_BUDDY blocks to export */
 	amdgpu_res_first(res, offset, length, &cursor);
 	while (cursor.remaining) {
@@ -698,12 +694,12 @@ int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
 		amdgpu_res_next(&cursor, min(cursor.size, AMDGPU_MAX_SG_SEGMENT_SIZE));
 	}
 
-	r = sg_alloc_table(*sgt, num_entries, GFP_KERNEL);
+	r = sg_alloc_table(sgt, num_entries, GFP_KERNEL);
 	if (r)
-		goto error_free;
+		return r;
 
 	/* Initialize scatterlist nodes of sg_table */
-	for_each_sgtable_sg((*sgt), sg, i)
+	for_each_sgtable_sg(sgt, sg, i)
 		sg->length = 0;
 
 	/*
@@ -713,7 +709,7 @@ int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
 	 * GPU_BUDDY block(s) if more buffer needs to exported
 	 */
 	amdgpu_res_first(res, offset, length, &cursor);
-	for_each_sgtable_sg((*sgt), sg, i) {
+	for_each_sgtable_sg(sgt, sg, i) {
 		phys_addr_t phys = cursor.start + adev->gmc.aper_base;
 		unsigned long size = min(cursor.size, AMDGPU_MAX_SG_SEGMENT_SIZE);
 		dma_addr_t addr;
@@ -734,7 +730,7 @@ int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
 	return 0;
 
 error_unmap:
-	for_each_sgtable_sg((*sgt), sg, i) {
+	for_each_sgtable_sg(sgt, sg, i) {
 		if (!sg->length)
 			continue;
 
@@ -742,10 +738,7 @@ int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
 				   sg->length, dir,
 				   DMA_ATTR_SKIP_CPU_SYNC);
 	}
-	sg_free_table(*sgt);
-
-error_free:
-	kfree(*sgt);
+	sg_free_table(sgt);
 	return r;
 }
 
@@ -754,9 +747,9 @@ int amdgpu_vram_mgr_alloc_sgt(struct amdgpu_device *adev,
  *
  * @dev: device pointer
  * @dir: data direction of resource to unmap
- * @sgt: sg table to free
+ * @sgt: sg table to tear down
  *
- * Free a previously allocate sg table.
+ * Unmap and free the entries of a table filled by amdgpu_vram_mgr_alloc_sgt().
  */
 void amdgpu_vram_mgr_free_sgt(struct device *dev,
 			      enum dma_data_direction dir,
@@ -770,7 +763,6 @@ void amdgpu_vram_mgr_free_sgt(struct device *dev,
 				   sg->length, dir,
 				   DMA_ATTR_SKIP_CPU_SYNC);
 	sg_free_table(sgt);
-	kfree(sgt);
 }
 
 /**

-- 
2.54.0

