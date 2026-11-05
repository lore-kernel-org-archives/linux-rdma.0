Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.25
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793860955;
	b=lFz3HsvHS+94x/rUj/V8bS2H3oQdRn+4EUc1ObFsjYQ1eKxiwghg0E9kH/xwfOoccnVY
	 pIDLsUT3Kq9QycXWKBxV9ebvqGLvzn/3cs7s9/Yi/NS2nUT2EeSMYg7qvsDskAlPGrnd7
	 0d3OSHookg7UVROogY7ACus1mfCufpaC4dBNp/JbEMQTyEfYzwehcl2G0hfCLWKgCzDPz
	 w3fHTStrgolJSGipPofbMc/3twf1wonhDOSpl81alrplS08QWiFAa7BcFzEt0OUmb3jco
	 x/1HNoEdk+zD+UzTLIzBoDPTW+s5q3chcCqhNVuIZoYwpRp+mx1vQo4y0jIDFpKH3/w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793860955;
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
	bh=u0MUto+KyclFhz5RTumxv5pSKP6nGwt9+mzKzh06Pno=;
	b=i/L26Vhu3WfMP6qgsUlYFDw/wT4y/pG04lfNnF2XeoY/6O6AJL6D1XXuE0EnDp4WNpyt
	 Yx/B0UWjK3k/IPZYh2Itrqr9iyZkWBtPse5fFhiw6livLsYrqDwYUlbWIUIDv8+R/LvgO
	 s1UcK4GtK4CRRljduiHnJ4tgOM9cMO6CgNGSa/WeWX19WheZf0Q9arEjXCnWSCyCrr8Mw
	 TABp3mhNTRaRol2F2lPKX9vgtZhRWnEA3Fytd6o6Ywa5WymL34jtTYiPg4661YoDWJRcB
	 d6P3dnvhkZhv1M6F/c53y6NM6IKocK6FXbEBuQsJp2HASeZIL/zCixMf1UGqDMFNvgQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NY7PinMk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.25
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011025.outbound.protection.outlook.com [52.101.52.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA5B606A33A;
	Thu,  5 Nov 2026 06:42:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCA5B606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NY7PinMk
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q11N/IvKCDpJCVasd3fiHsAciQhcUO5o95z0lCD7JrH6zOJ90A3RMW573V3CVtEzE1XNx8W9cGmgF9CdUNLl6hhhkhkpLf99pznSiVZoDkCGaouyw77K8yYwXDq089VJjZA/c0mWT66IqvqfvwLUBFb5OXNOuob4Vk8bYK/JDsVEHrCT0Gu6VHDO9Ka+Ckikyun1IRf4yxSF0ilTtTVB+EWKPTeb52GJciBSzhFDFlBK2P1Ua8sMbQXchHwwayNd44S5f8sRLq70aRMS/RyI03qyCHuqvjS9exdGF0/nDNCnWsTXBUtZ9xWT7a2MLvvDznfW5bEX0P7odYQb21ruRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u0MUto+KyclFhz5RTumxv5pSKP6nGwt9+mzKzh06Pno=;
 b=eTtdWZ/1pvVOtyLhvYhuFnYTWmdLlE65FXzS7/WcFveotL/yQjdewBMRM3ciWLjBa1EnFO5W235eibML/pFD5kXauBsEzHnrCkHU92E6xLK/L9oWdxe3EbQYIGEFjzjbRQT9ni7hK3ZodZNoXa58W4JKxEf/26EmIEpPanpAmZwxD72lNrsWxBdIWZpssfPRz4d+XYdkyqgBig/qwb0YcNGdLsiskTQ1x9OLpcPaS6JcW71QOIVupYExe/0FAjiYKsNwflbMoeUUaG8wWL9xzHyvui1ovXL4m4y3LCTvJaYmncGB1CiyC/sG2mVu5UU7kTTu6jP6FXLiXy/9FqrfBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u0MUto+KyclFhz5RTumxv5pSKP6nGwt9+mzKzh06Pno=;
 b=NY7PinMk7k+pVyjs3CSQMZiDUl38zdjXkPaswt7zBsIDdj4H1NB1MKylVs2wT75radqV8d5UweUWmjk/wSdF+DsP5rsez92eMkzk0l3g+2rGJKFZEtIjWpTv8I90yYaJA7uXkB7/TFVa/Tj2RnEfKeP3IUM8/z94vDkqn/jyo08yxU+dJcrJzd5JPLhKon07K7xR+6Xmm4jAcNlnbTwosENZrbBr9mRSIhzjQatnuVSQkJQykm7Lwi4MvdW81EZmhN6UIM9VU3H38xxJDI54VA1/Pk2bntc5s90IGPKGcHrbLdVwcgpf1xLpMZiKlgNN00DOx+wwLm/sFa34bVULzw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by IA0PR12MB8932.namprd12.prod.outlook.com
 (2603:10b6:208:492::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Thu, 5 Nov 2026
 06:42:30 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:42:30 +0000
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 05 Nov 2026 17:40:48 +1100
Subject: [PATCH v2 13/23] accel/habanalabs: Use the SGT_P2P mapping type
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-dma_mapping_type_v4-v2-13-78b8dc9ae80a@nvidia.com>
References: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
In-Reply-To: <20261105-dma_mapping_type_v4-v2-0-78b8dc9ae80a@nvidia.com>
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
 Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org, 
 intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, 
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
 linux-rdma@vger.kernel.org, iommu@lists.linux.dev, 
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 linux-nvme@lists.infradead.org, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org, 
 Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, treding@nvidia.com, 
 jhubbard@nvidia.com, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793860879; l=4290;
 i=apopple@nvidia.com; s=20261105; h=from:subject:message-id;
 bh=qTEViJQuWmi46Xwo2ky4pCUyumkjSvQEnQcbJKKn5Rg=;
 b=3D7c/U5/SXvvRgT6GIAnCK21g8pjt/Kwhvi1R7MPCDmIUmqPMXDoCvJUCfjYlmnsQFV3GGgLq
 6ieI0bqz+DYA36ne3X55t2MJ1ddEuzWNUaemz/oFYA1Zxf1Uf9vEoId
X-Developer-Key: i=apopple@nvidia.com; a=ed25519;
 pk=WdWPT9rAq3YNfXldbGv1NSGVLGxzQGFGJvRUiShhNqs=
X-ClientProxiedBy: SY5P300CA0013.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:1fb::12) To SA3PR12MB598757.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|IA0PR12MB8932:EE_
X-MS-Office365-Filtering-Correlation-Id: eecb1d64-f465-4fd4-b906-08df3b07f706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|22082099003|18002099003|56012099006|261021123027099003|921020|261021121427099003|261022075727099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|10067099003|261028144727099003|11063799006|261102123227099003|261102130727099003;
X-Microsoft-Antispam-Message-Info:
	RmMGQvvNfUACnCgSLJk4B1rE9HRGwRgFTrVHZx/kblTdzoTst6tATYGOCJkDbXKwBGeNEBhNLi+Lo5CPcyFF9QvuDQWA/zYK+gjYf+MKXiYNafg5BC9S3eq7Z5zQn7clOqWk5rtK7jHUSGqbqj+/6vAYV8AordHMqMAv/KLz4UN82n+EqfH7jSEfX5GAFCwwfl6xyLsxqHPZUt/JRMc76bHDFNQEfG8S+pHfjRQkcVu6IXDOHmtgSXzSPsIGdWzuvNQissbb1iTQ1jJhXh9MD+KSQLxifN4vKuf5BICnF7HDD4Z9HYtk02vOzmM8+0z/59cFfI/BfuGyvo8UH9gBHNXoXuJCW3+zCmP8fWWDaBPtiHmapP4+aKyniazpwCu5TF6rCy7oSyhRhWUYWJHUWnsxZXWZI5YGKHfAzFOFWbXV1S0pib+SdXr5zxHH15dU0++/D6kthHu7mljBB+2XXsLxaHUPFjiNWQ5cVj/NTJo6Q8I9+JGoXunGBio9XL2OWcBoOR/DOkoJM9VCEXWuUvsyBK7RQpe6sDbLLR6ts3dW/ByVElYvnoP6zntccX2EWHSExkCOnaUqZfs1ZPZtQFBIH2wPBeRI9ueiG25ldwBO4Ot+ylfPgcZpPy6Tpn3jzwRCfAo8kMcwfu0ASOSWBBoIKdeYjRPGESIS5zD43AidrDMhX0ewtFhetlUrW2mZWJ114f6/AiQiAqqzHuXFQw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(22082099003)(18002099003)(56012099006)(261021123027099003)(921020)(261021121427099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(10067099003)(261028144727099003)(11063799006)(261102123227099003)(261102130727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzVSWVNVa2xKMzRjY01hSkhJWnRTSHpOZ3FZTkRqbHVqaEs5NnJhejE4ZEU1?=
 =?utf-8?B?N2hobWpsTVNoc3pKNmx0RDBLaXB2ZnZoVzN2Z2J1WEFERkpOUkdOUTI5UTUr?=
 =?utf-8?B?VEI5VFJNdFR0TkF3SXJuNnM2bk1GeGRXYmU3THFaSkJHMHhJUFpTeExBYU80?=
 =?utf-8?B?N3E4ODR4bVQ0ZWxtSFZ0VVN4YTdIaU12YWpvVFJrZ1FEaTN6U09CUlRZTTFJ?=
 =?utf-8?B?b3VUUEN2RjAvUzd5SDdUeFFPYmM0SnJ5Z1VaY2ZkQnhMYUJieUFkQ2ZzKytL?=
 =?utf-8?B?dkQrVTQvc2dVZ1Y1WDV3aFVVV2liaHovVkRXSnBpMnZFQ0JGVjlhV2NsSndU?=
 =?utf-8?B?S0F6bTdUN0NZVTdEYU81azhpT0JuR3VQK0RDYW1KU3AzMkhQZmhYOU5ZNHh1?=
 =?utf-8?B?akhEbHpKVDNoTU5XMGM1ZzZ5b3V5a1JNMHN5QjRCTFNBaFhOcGVoM1R1RTEy?=
 =?utf-8?B?amdWMDB0OXpXdCtVQUFLOFhRbW13b3ZMcHAvUEtmQzh0V3o2TXBGaEFXUDdl?=
 =?utf-8?B?WUxtdUkwOEZFSlVXbXAxck8wNHIzd1RUeU1TaHoyU2xlT2swSnpBdm81Ym43?=
 =?utf-8?B?OTFnbHB2U1VCbFRyMEdEdlJ0T3ZiTkNyYXppZDNKSHh1RTdxMk5EcldUODlT?=
 =?utf-8?B?eXl1TXJsNkRrK2cyRDhoeDdzTWlTd3pkU3VNcnQrSzBKclNtUUJHdGJBbkNj?=
 =?utf-8?B?TEc5VEg3MXRTYkNPOStDVklQZ29JSzBlMDJoS2lucG9SQzhTVEd3cFFuWFF0?=
 =?utf-8?B?TkdNbUczbUVUU2JzVTFvVVdhb2VQdFB2M0tNTmN6eGJkWVdiMmNlUVBPV0Jv?=
 =?utf-8?B?aS9TWGdYdmtaUFlkTXpPNlNqcEdzWk5CMDNXcmFpOXVrYVYvcEdoUWZiSWdY?=
 =?utf-8?B?aUl6REtUaEFLMzBjWUhxcTJRMWlTc09YMzZ4a1YvQkd5eTRMVEFQZ2ZFUE1E?=
 =?utf-8?B?TFZnekl4cU9GSFZ3RlZ1WTQ5U3lzMGVvQ1VpQktmNHByKzRscmNJQ1lwYncr?=
 =?utf-8?B?eUNSdllXcnZpSFVFaG04blZCWC8wVkNtdW9zVDNEOG9pQ2hTam1acU1HVVhT?=
 =?utf-8?B?RTQxbWFkWElnbWtkd3dGWVcvaTdLakVCNlRCdmFwallNSGJURkpxNXNjbGlV?=
 =?utf-8?B?U2dHZU40QkRQSlJkM3VKRmZ5aUJqL3NaeVdhelVZZFdxVGFVTHNqNEVPUlJs?=
 =?utf-8?B?WE1MRHhkUjVZRzl0ZFVKclJkVVFmTDZ1Sk8zeW1mYkVtWUx5Q0owYnhSaWxh?=
 =?utf-8?B?SHllRG94VWRSeVRzTjF4TCtIaStTS3hWbUcxMlY2NGRrUUFTZk1sUnBjVWd6?=
 =?utf-8?B?dlhmQjkzNDc2Vys0b2RhNzRGVWlkSWxpWDdyMDVNZUx6clZ6T1lVV3kyZkpU?=
 =?utf-8?B?ajBrMFZzTUxwRWxoK2RabXVMSG9CMllnZk9GZ0xwYStORU5uL3BuWUw2SVhH?=
 =?utf-8?B?UjloZG0ydGFlZmJ4OXdiUG9jd2RsamJ2a0oyZ0xpbStOUS95WnJRUk9sR08r?=
 =?utf-8?B?eXNuK3A0T2c4Uzd2dmJONXF2aFpsTUhiaXcwbkFsWFhaYXg4emZOd1h6aHFM?=
 =?utf-8?B?UlVhK1hzZElxU3I0WXFpOHU4WTVuWmdqZTB5ZXJWSElENU5uMHM2MHR5NmNv?=
 =?utf-8?B?VHd6MkdTZncrcE9JcHl1bkU2N05raUh3Z3lMa21QUHVvMUovT2htaFRxQVIz?=
 =?utf-8?B?YStGSTV2aElmUkU3NXc2RVBDK0dOdGtjZHltZkoxZy9VWDVBNEkvUXkwQk8w?=
 =?utf-8?B?cWNKT1JzMU1sN1hUaysvenV5TmpPYmVVNmRrWFY1NmxMMlhNNzlNOVE3cWYw?=
 =?utf-8?B?amJZK09BbUt0RGh4Rm1HSHREb1EzY3oxUmVFcHNOTnBKa0FQUndSTDNhZk5V?=
 =?utf-8?B?UGJZd3NWWVZXNldWcHY4VkdHbHpTRTdaRW5jaFdqdVpUcTJyb0xwN0l3OFpL?=
 =?utf-8?B?QVY3aUJjTTU5VDdGT1hPZjRwaUlzR3o1RkhoNVBqdVllNWo3S2pzMXNHYjNm?=
 =?utf-8?B?Rk1QM0h3aFdnajNSOUl4WGc2cnQ0aFE2ZzZEZllGZVJ2OFdBaFVhRVJkZnVX?=
 =?utf-8?B?WENpSVFrVGhoUVh0bVBqV1ZnbTJiL0xYTE1JQjJoN3NnZE15QXkrL3B6ZDhR?=
 =?utf-8?B?dVZBNlFSQ0dwSGV2V1Y3THhHZjNWbGFWZ0EyVDFMUkF0UmxNcEo0MHBRMkZk?=
 =?utf-8?B?K1FML1NNWDZMdmx5ek4rd2srNnQwcVFUYlR4dzBZVUVMV2szcjBYbFFTL0x3?=
 =?utf-8?B?ZG96bU5GRzRaM3hxNGxoY0t2QUovSVdRY2RKNE9vcGRwK2FaZUdlM3lFd21v?=
 =?utf-8?B?dGtjT3NKNUE1QUJIN0laVFNXUWlwRXI1UWxHUlBkWmhEb2NseW5MQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eecb1d64-f465-4fd4-b906-08df3b07f706
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:42:30.5667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PxqzJNYr2EUnSBfB7x5iQeqxNKLzr97tiJKMiRs0HKbMpx7eS0Wj+lW6yKPQKs61a1ugDfqDsNAu47c/j8sedw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8932

From: Jason Gunthorpe <jgg@nvidia.com>

habana has special code to check pci_p2pdma_distance() and rejects any
importer that cannot do P2P DMA to its MMIO.

Convert this directly to a SGT_P2P match which does the same check
inside the matching logic.

Someday this should be converted to use dma_buf_phys_vec_to_sgt() which
does the P2P checking correctly, for both direct and IOMMU based cases,
instead of this hack.

Remove the now empty attach function.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/accel/habanalabs/common/memory.c | 54 ++++++++++++++------------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/accel/habanalabs/common/memory.c b/drivers/accel/habanalabs/common/memory.c
index 361cff577381..6745af1328c1 100644
--- a/drivers/accel/habanalabs/common/memory.c
+++ b/drivers/accel/habanalabs/common/memory.c
@@ -9,10 +9,10 @@
 #include "habanalabs.h"
 #include "../include/hw_ip/mmu/mmu_general.h"
 
+#include <linux/dma-buf-mapping.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include <linux/pci-p2pdma.h>
 
 MODULE_IMPORT_NS("DMA_BUF");
 
@@ -1704,23 +1704,6 @@ static struct sg_table *alloc_sgt_from_device_pages(struct hl_device *hdev, u64
 	return ERR_PTR(rc);
 }
 
-static int hl_dmabuf_attach(struct dma_buf *dmabuf,
-				struct dma_buf_attachment *attachment)
-{
-	struct hl_dmabuf_priv *hl_dmabuf;
-	struct hl_device *hdev;
-	int rc;
-
-	hl_dmabuf = dmabuf->priv;
-	hdev = hl_dmabuf->ctx->hdev;
-
-	rc = pci_p2pdma_distance(hdev->pdev, attachment->dev, true);
-
-	if (rc < 0)
-		attachment->peer2peer = false;
-	return 0;
-}
-
 static struct sg_table *hl_map_dmabuf(struct dma_buf_attachment *attachment,
 					enum dma_data_direction dir)
 {
@@ -1734,11 +1717,6 @@ static struct sg_table *hl_map_dmabuf(struct dma_buf_attachment *attachment,
 	hl_dmabuf = dma_buf->priv;
 	hdev = hl_dmabuf->ctx->hdev;
 
-	if (!attachment->peer2peer) {
-		dev_dbg(hdev->dev, "Failed to map dmabuf because p2p is disabled\n");
-		return ERR_PTR(-EPERM);
-	}
-
 	exported_size = hl_dmabuf->dmabuf->size;
 	offset = hl_dmabuf->offset;
 	phys_pg_pack = hl_dmabuf->phys_pg_pack;
@@ -1753,8 +1731,10 @@ static struct sg_table *hl_map_dmabuf(struct dma_buf_attachment *attachment,
 		page_size = hl_dmabuf->dmabuf->size;
 	}
 
-	sgt = alloc_sgt_from_device_pages(hdev, pages, npages, page_size, exported_size, offset,
-						attachment->dev, dir);
+	sgt = alloc_sgt_from_device_pages(hdev, pages, npages, page_size,
+					  exported_size, offset,
+					  dma_buf_sgt_dma_device(attachment),
+					  dir);
 	if (IS_ERR(sgt))
 		dev_err(hdev->dev, "failed (%ld) to initialize sgt for dmabuf\n", PTR_ERR(sgt));
 
@@ -1776,9 +1756,9 @@ static void hl_unmap_dmabuf(struct dma_buf_attachment *attachment,
 	 * a sync of the memory to the CPU's cache, as it never resided inside that cache.
 	 */
 	for_each_sgtable_dma_sg(sgt, sg, i)
-		dma_unmap_resource(attachment->dev, sg_dma_address(sg),
-					sg_dma_len(sg), dir,
-					DMA_ATTR_SKIP_CPU_SYNC);
+		dma_unmap_resource(dma_buf_sgt_dma_device(attachment),
+				   sg_dma_address(sg), sg_dma_len(sg), dir,
+				   DMA_ATTR_SKIP_CPU_SYNC);
 
 	/* Need to restore orig_nents because sg_free_table use that field */
 	sgt->orig_nents = sgt->nents;
@@ -1848,11 +1828,25 @@ static void hl_release_dmabuf(struct dma_buf *dmabuf)
 	kfree(hl_dmabuf);
 }
 
-static const struct dma_buf_ops habanalabs_dmabuf_ops = {
-	.attach = hl_dmabuf_attach,
+static const struct dma_buf_mapping_sgt_exp_ops hl_dma_buf_sgt_ops = {
 	.map_dma_buf = hl_map_dmabuf,
 	.unmap_dma_buf = hl_unmap_dmabuf,
+};
+
+static int hl_match_mapping(struct dma_buf_match_args *args)
+{
+	struct hl_dmabuf_priv *hl_dmabuf = args->dmabuf->priv;
+	struct dma_buf_mapping_match sgt_match[] = {
+		DMA_BUF_EMAPPING_SGT_P2P(&hl_dma_buf_sgt_ops,
+					 hl_dmabuf->ctx->hdev->pdev),
+	};
+
+	return dma_buf_match_mapping(args, sgt_match, ARRAY_SIZE(sgt_match));
+}
+
+static const struct dma_buf_ops habanalabs_dmabuf_ops = {
 	.release = hl_release_dmabuf,
+	.match_mapping = hl_match_mapping,
 };
 
 static int export_dmabuf(struct hl_ctx *ctx,

-- 
2.54.0

