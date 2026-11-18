Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.65
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795001192;
	b=DVCKIttckzPsY4LR2Qny1EogqC31fUuhW4Zp/e5FnpXFbG2YR5BWAyelZydGpbpyvxlh
	 ZuOig62qqDwKBlhJcmam3TNLUWd1oISdnWdwJaoS5LXLGl0u7ybW8CSJ1iJBLuAx2ZsfG
	 g3w5beRTb3XZ4hxlmoNr8f0EvGdMITyiUu6c1LWUeWHtb3ecfBual3MMyqkqSSuZazvDX
	 L5qOV07DZRzxkvyc9H9+9JB9X3iBo8aicqWF6/dp0gtbISViOcfunANq6/NSl34YZTO68
	 NEJnbU3yhpkBKpJlTFHrM/0R8/o8bDrlwWhB1x6bpUpHHUp6pbO0r8yc16mlUpttEAg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001192;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
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
	bh=OcEcSBm6DzCdkI2h76AbUUhQcprcTFWiNpi0Jlvp5sQ=;
	b=iAltY3jvrT/Brltw3EzXaH71OIia8j4DpDZhVMGu+5NHLpgl5AcY5rUMVW1o4NILtCUi
	 iX53XkSiXvS7x2yPovN+iqRrrvRy+o++mcAosvMbZ4Fdkukxg2EYJGfLFqOq2D5GerCnS
	 9Ctpmp8QgewRup2sDtsX99idX8Uzx6KHNDVZUVBlIGkHRUAHvMO+kSa2rP+b6FQRUDsLq
	 lU4uuTpjzvdYjvQMvMxxzjcNDVh+8iZbMjP0zyvu8QkM62mAeTp42hqF7wM2aw00GMORW
	 1QVJBkwl9V2g3uMx3KvR2y02Z4Ijmj4fizwuC5oVbXixFQraNKPsNu/F5v2PO7o5/CA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N+LdF8C+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.65
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013065.outbound.protection.outlook.com [40.107.201.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82A8606A31C;
	Wed, 18 Nov 2026 11:26:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E82A8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=N+LdF8C+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DcoKtRcM8tssgYosEiSSW4IQf6ddP3KyURhNR2/bqkJ8ocRXblZjvYamQ591eTzcp5E95jfbGQ23Bx1R8JxWgS/p77hfTb02Tl43I7xRGu1QsC/gz3U30HCiwvOuCdb22AFXa6BwTVQ4NYLfq3YNx1jGtwWFGsTeGDSKg9HoNNYt2yKh0B5LfXHZNXFwWe6TgM7vh0qayheA6S62X9Q/SDHzXAIUTWa3ozUlMtjLZCplpuW2J3Z00nj6wJJygafA3L0HJ2icZh9yV7nL3rd/wkCQplwpakj8E1dQgXktT+Rw53Dii2GkPy+C8+8Bi1obM4HsKOVMdzAofwoZhuGLsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OcEcSBm6DzCdkI2h76AbUUhQcprcTFWiNpi0Jlvp5sQ=;
 b=d6mmCveSHV5kuyB24IWfebWGJL1ht3AoEIQOY/1zK5s16jOuHhnJIP4BK/krkv03RY2aeRWCXnINlznOAVCv887X5k/o+wQqJ7yBrR3hUZSf75nQDraBwToTtEGRAicmB3DgvwqYy/+eLfpuKw2nIjQBRB+C6r2+FwCXdC5tIJbHbgE4GPbTtcICwdM23FtRQ9+rLt6IFuXRJtDb2BpbLkQWG2xjStg7Ig4BP6S3fAzPtvSfauSarQBNZkvDz2yK92foANovrETw14Uu20LfxhIZAkQuj9G+pqOCJToc+QbRTCgrrmUZEk0gA8xolH5On7OEKCHBpvVSVXzWzBHu3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OcEcSBm6DzCdkI2h76AbUUhQcprcTFWiNpi0Jlvp5sQ=;
 b=N+LdF8C+WMi1n3tXAgJIG4xDXkanK2JfkrYf3G8qbSrexP0oGOYIoLZv69D2RWyxDbIsPgfn/Q1zbKSwp3SkkU4ofGjCadYlakSLQrEbcOXG33sQTK/vdc2BIK3KFkWgYLHfYwexWsxEmekrCi3Y16JeN38QVRfzHoiwxvzt9mkoN1on+h/+eR0Jx/wd0htsGVMkMB3gh6TkYSBq81TQvQBjAZWC0SmRBsi7i17O2nHHr5F8OHCGanod2y9aDLq4agBmjEANIr9rvUlMPzc/36X9UWOVj0eQDJ1uwAv5uaRpD0tZv4C1oJ/xm0E1XBmtGdmyaU5iwULuetRuZaxV0w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by PH7PR12MB8426.namprd12.prod.outlook.com
 (2603:10b6:510:241::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 11:26:28 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 11:26:28 +0000
Message-ID: <2c11ca60-b1c7-45be-94dd-b0fb648109e1@nvidia.com>
Date: Wed, 18 Nov 2026 13:26:15 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: Hold sync_lock while resetting VXLAN ports
To: Changyul Lee <lcy8047@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Moshe Shemesh <moshe@nvidia.com>,
 Aya Levin <ayal@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261113040323.2090829-1-lcy8047@gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261113040323.2090829-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0026.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::13) To IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15)
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|PH7PR12MB8426:EE_
X-MS-Office365-Filtering-Correlation-Id: 6deb7689-8323-4ef7-90cd-08df4566c998
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|22082099003|18002099003|261009223027099003|11063799006|56012099006|261102123227099003|261028144727099003|261026140227099003|261021121427099003|261022105027099003|261021135927099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	XE+INUDSHjUvxn8n5o8sWpuAilDP56S7ITfk/uYB8ytk3Ii/v4aYsCRBbalj/DBMzhkuOsYuh7zkJ5rNPhDpxOWQ1AfviTZI27EJbhbhLE9Ti1Rp+UtIJXDsKNsz9OKe9ObXkkEI8GDgH5TVK90f4adwdnfogZM4dmV/PoOqlP6NvV9abcOYkhGeVGH2rOmxBmrxl0TW4/Ngxt/UBIHCnOmIRZEWMnnLutHlQGkJmr2t1qoBDlXkHAQw3i/cE9fEoLHmHpo0W2Oi8y65VsLYRv+/pJhTc+VcgSBo0wlLWm8+EI1cFXje05CancmfMCWATnNrApe/xgWDbFZHzS+3J8h1lyxzp0HktXG/Gf7UZytasLmFKmurElUW7ouQDTybMNKE/vHleiYIIkVx7AAUNj0YHNzEw5G+Nk+x9OsoqCqjfWA5swxBCK8Atn8OG1Na++TqLbqm7nisbbssm96TvMr5TVAtp8hd1hAu6ntwnM0cjLKzhfCDJXottGxGyIKgsHnDQwsJyGY47RYrJXyt2fvzpp4Y9uMbdXI35Xq7pZ5ppoQJyfumSIz2XzHkf2yyWvWWusUpNB2wiN5LvFJrYZrMmvZo9xhBqyIUib3b3olfT+PNgAikdrr65D9+2cvXIh79hCLOzfSwgM8Bm6VCDal9zpCtfi54fhxFUVtOzDA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(22082099003)(18002099003)(261009223027099003)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026140227099003)(261021121427099003)(261022105027099003)(261021135927099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUR6M0Nrc3REWlJaSkxPdTJKV21sUFdEZytyM0NBYmNRdVRIUWVTVTFwdk5B?=
 =?utf-8?B?aTVjTjNxOHpBc1B5UzZUb3o1ZFBjaVdYVkc3aERvRmU5NjduRUJCRjR2RVk2?=
 =?utf-8?B?QVlkVCtscml6Uk5qdi9sVVJWRUtBSEh0SVJ6VEpXZTJGSXc3RTJJWGw2N3BK?=
 =?utf-8?B?VEl1Y0lQQjdQaUFNUU4yOXBtY3U0eWhISTd1enlqYWZMeGVmSGlJa0IvRXJB?=
 =?utf-8?B?K0RyMVU5THNuL0VNK3RwR0d4SkNvdHFaR2FXUFhicjdlc3FHWWNyVlp0cS90?=
 =?utf-8?B?UXRyY0lHeGY0aHJMZnN6S3J1aVBQd0F3ZkltSTM2cWJEd2JPcUNFbWpTZTA5?=
 =?utf-8?B?dS9nWFkvREJUdlpSZnVQUDZEa3NuTXRXbHAvVmZpUDltRFVBcmt1SC9JdTBv?=
 =?utf-8?B?d3FRRCtEZHpISFVZQnJTWU8rVnk0THZyVHF1YnVBL1ZVam1sVnlSTWEwbmNv?=
 =?utf-8?B?N0tMUTBMNDJnWExBMnNqd3Q2QW5lL1FXUzdSdGlIL3gvRXIydjgvR0NkcjYw?=
 =?utf-8?B?bVErYWliY3Zsbkxsalovbkx3N253MFJ4NXVqTzRjV0MrKzVWa24rSHM4WlMv?=
 =?utf-8?B?NE5XUzN1UVI0VnhVOVc2dGNpVEcvZlY2UjUvcDdsSmZOYUFDekl2ZGZEWlBJ?=
 =?utf-8?B?MWFYYXNTSWIwVTYwajdveTd1czZwanFvRTZDY0Y3TXk0VkFtN0V6TkwybVdq?=
 =?utf-8?B?cEc3WEgyeVgrSEQreVhmMU9qcXJsa0ZQRFpUSGN3dHFDUDdKTzNLLy91THV1?=
 =?utf-8?B?R2puQXRJVEJkdDcvYTBwL0hxYm5mSU54cU1qNnJ0bktMTHR6S1ppYjA5NVhm?=
 =?utf-8?B?NE04WnpxL3ZudlNvbmNLcGg5TkRoZnB0ZW5kNElCMk4vbG9ScGlmSGhXdXJU?=
 =?utf-8?B?NVh0bjdjbGJCWktpdVpXbnNCL3RUTVBvVU9pNFhWdWVzdElwTUd3bjlYazhu?=
 =?utf-8?B?dEdBazhzWHM4WWVuQ3VQNmRmdXhUZGM4MUt2MWMyQ2xGTUpvUkhuWktOcG1w?=
 =?utf-8?B?T2dBcGhhSkgxRVVsNWtmTkgxaXBPQ0NYTzh5WG0zV3FuZXpRdm1mdXlCUytN?=
 =?utf-8?B?UTdGb3lLc2ttYnF2RTUzYklXWlZKWDZpcFBCNW5aMWgyTHZsVzluN1loOTd4?=
 =?utf-8?B?OUpNZXRkM1kvRTlDZ1NOV1lpNGVCSGtSV3VtM2ZVR3dnYjNUM1hQcUpMZ2Vw?=
 =?utf-8?B?QmdQSkVTem1oYjlpM2J3RFFrZFNRak9DR2poL3lHYXJNbnJidGpYRGVqa3JN?=
 =?utf-8?B?MkJVQVBsTEFsZEFXTy9mK0xoY3VFOVZkbjBaYTJ6YlplQkxWZGZHOWRiMjBR?=
 =?utf-8?B?ZjIwdFFVYXdDL0czeDVmUXdRdTd5WEtCL0h3M1YvZG5ZTjBjTzNnZFhRWWVK?=
 =?utf-8?B?UHhlRmlDK2l3N0d4aXNuWjE5ZXAyM0RrbHdYam5KTWI3TEZCNU9pcWgrcDdQ?=
 =?utf-8?B?NU9hc3g1S3cySGEzdHlybm5JSFVrNWJkTVRsRXZhQlg5M3VTMkd6Q2Yxc09P?=
 =?utf-8?B?dEZhZHBtM1VoY0FxYnJHUklCa1NhVmRSQVdMT09KSnRWT3ZYNFJhWmRjb0tF?=
 =?utf-8?B?NjFKY3RuVzlWaHNyeC9YWE14WS9ZampmMDFONXhDazIxV0MrNlc1Mnh1WXhk?=
 =?utf-8?B?bUlzc1J5a3czYmdpYTJyUnBYbks3SzJWcmZoTFZrYWgyaW1ZKzJCWGs0Vjgx?=
 =?utf-8?B?cE84MlhCanVZS1p6NGFPYno3am5VdFhqbFNwaXJ2bTl6RjFoSEU5VDZ3ZG5y?=
 =?utf-8?B?b3l3VlBjWmk1MER3dXd4YUxFYmZob2VkN040MThxL01VZkF3QnM4eTZESFFh?=
 =?utf-8?B?dzNMRklnOUhiQm1qWjNtalNJUVAxeDdOVFJsZGpnM09XeEoxVk5xNDNjdnUx?=
 =?utf-8?B?RWxiaWd2SjA2K3NqQXNWS3BKMUxhMWFmMC9JVmhLdmhiVG1OdWdKdk1qY3l4?=
 =?utf-8?B?WmozZk1oVFBUdzcwZlBYa2wzYks1VU1PQ215RHZETC9pNWtrYVNyZVBqWmpQ?=
 =?utf-8?B?MDRaUjc0UmRaYUUwRXR6Kzh1NzRwTmdhNDlURHQ1aWNxL0hsODJlWGYzaUUy?=
 =?utf-8?B?enBCRWMzNVZUMlBIVUt4N0RYVWcwRDVjbU1TTm8xWk1BVEw2SXYvMElDNkd3?=
 =?utf-8?B?SjA4VGRTTnJsekNwQWdkVGI3eEJ0cFphTUhMbFBxcTBEdkxzdVZkaWZZOFVF?=
 =?utf-8?B?TDgyL09nNGlWTEw4a3E4R3IxYTdHbTBBOU1CbmsxOHpqOC9xMlY1RHhUaWZM?=
 =?utf-8?B?TUpNaGNDaCsya1JwRGVaTk9maVNBeWZDTm1tcjJNOElsRTQ4emVPMFYzN0gx?=
 =?utf-8?B?cDFUc21yK2V4N0tnNFk3Y0NMZ0hBUC9Rcy9oL3hZRmVmTVJSNTZjQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6deb7689-8323-4ef7-90cd-08df4566c998
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 11:26:28.1877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AaeJMGuj1fRFLnROcmun8vbInhSuJPEdYUo31nAZ9SAHo8Ov+tlrB/fHsPdA3lYV2Obf3WKxTu8hk0uc+viGEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8426



On 13/11/2026 6:03, Changyul Lee wrote:
> mlx5_vxlan_reset_to_default() walks vxlan->htable without sync_lock
> and calls mlx5_vxlan_del_port() for each user port. mlx5e_nic_disable()
> and mlx5e_uplink_rep_disable() call it after rtnl_unlock(), so the
> udp_tunnel_nic work can run mlx5e_vxlan_unset_port() at the same time.
> If that removes and frees the entry saved as the next one in
> hash_for_each_safe(), the walk then reads freed memory.
> 
> Hold sync_lock over the whole walk, and add __mlx5_vxlan_del_port() for
> callers that already hold it.
> 
> Fixes: c5eb51adf06b ("net/mlx5e: Fix VXLAN synchronization after function reload")
> Signed-off-by: Changyul Lee <lcy8047@gmail.com>
> ---
> Found with a static analysis tool we are developing.
> 
> Compile-tested only, with x86_64_defconfig plus MLX5_CORE_EN and W=1.
> 
>   .../ethernet/mellanox/mlx5/core/lib/vxlan.c   | 24 ++++++++++++-------
>   1 file changed, 15 insertions(+), 9 deletions(-)
> 
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.
