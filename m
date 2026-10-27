Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793108614;
	b=Hzigp8iS8I8PGAcb/Z0F9kzv/NHb/YJkbTMFX0fEEUF8n1718zQNwvA87qPesiIYRJ1f
	 zYjOrvVoVWCevyTFA/TLUpx/D/I0MlX5/JVmwS54JmOp/rJnvcs65u1aRntd84FKB3l3T
	 kXbsYMFqoF+9tBDWtcbsb+oWu+t7La3cuPzZdnOhC6khFLKZua9aATGTRJ9IluCkQZJEq
	 wMJK0sGay0UTUcLI8zdN9kjRTxYc0DaqK2wQd+ifB8W8+dBJiNNTSk00gncawjLb3m9pS
	 etI1gZ/xsQKM+RBQPj7S8he+DU+RY4R/Rk8FZJHEBW8icYPTRX/OV9WSFNmDWIgkL8w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793108614;
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
	bh=UjdwSN+oDNQxx1eqCxnif8nncHXZexKX3t0nAwz3luM=;
	b=AqL0nuz5hPmLU9oB5pcLwnezjoF83qzeHWDEu023vqeqRMOqh4ys5R2FRfRI9xna7QRn
	 I8cmxNy1cgRfTW/pwxJqa2Wq83lOEi0+Ut00JZDxpLfTuXpONh+rLaem4Al3Iitfze6T5
	 Ql7FauFtdT34bUrdAaJ/QZ2g0DmoWnMjf3H9I8817ScIHG55VYI1Uz+joldXO7LtA7AGA
	 VykXbjMkBBuaTv50pV3oXnVxLspgyQupi5572EmukmH9pMat5gynlkNYn25H6l4E0t6Bc
	 BJQQTUsL1hnVtkBEi2/srKGrY74Lc7+ION6Ll7pgiZWuQ3GkJ3NPyyq/3+8czO+HgWQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=jRvhxt0C;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.20
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010020.outbound.protection.outlook.com [40.93.198.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F45606A31A;
	Tue, 27 Oct 2026 13:43:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1F45606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=jRvhxt0C
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QOQgnjvekEMJlwIeXCP3LxbCykDPDe3bRInJuzcpNpJZof3mzqaF2X3up4ZF9ElgZMs9MfdOTUFPwjitg71iHp8vFB8AANrvi53k4tY/0G4l2/4fC0mKftk3adZHUOU/h5IHD+tgMTEa2YZbMG+HTzoDJtzT3T4yj5JLsDEn1vNZ5TLkzGqh0ra7SYqqGKXO0Oz/7MdH2eWkKUGhzRexjTITGXO7mPmFe8kuVMTV5ed3Uy/V6j+2jcYjKEW7Pg+i9hCs1PrzH8aR5VrPVL93Y3GiEz/d1HStK0bk7fsEVK+LR6Ae7l3/9zM64ediw1buSNJyxrMFmGwufx7DGTD9qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjdwSN+oDNQxx1eqCxnif8nncHXZexKX3t0nAwz3luM=;
 b=phaomx1VQ9xIHsMqmlD1zhOMtPDOqtAjW8dirp2shrszZLDYULsctp1kznO33cYMTSWGb6e8dTfwSFYRUcadyNN+8MdAV6jn65QDnNoWW0y89KgyslaUv0xt7iKqq51oQuvkeZFAKKvzVHPOyJkOS+GP/MKZEy1iv5ut7Ef1Cq8v+Nag83q5ggzloxWX7iOa0wVGM9vflH65qDKJ6kNXfF2zrLGTN+nZeBVOy0pnBfSWZ+a1Ov8daEracL7kmkiKlX/piGS/FNaSNEmmhTTYtYPsbhiyg5EWoUSd2r/RkeFIpVhSh9OQ0OWYRrig+jGVtQLgf4tza5WTzwfg+/uCdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjdwSN+oDNQxx1eqCxnif8nncHXZexKX3t0nAwz3luM=;
 b=jRvhxt0Cr5ousrbyTvymJZbWiqCdz0WRm/uboTngaOrIWUn+KmuUJSowEpBaO9Hwuq4wxXUmQ74LNHqTZS+GY2Ic+aSPcZGuXQtnBIXEPtpK7nYKqHjmlOXeFH3d59cOhZIRS5vHRaNAFGBMjLEvzZW86KbnAdlNr5A+BnuVd8I=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by LV3PR12MB9168.namprd12.prod.outlook.com (2603:10b6:408:19a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 13:43:30 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 13:43:30 +0000
Message-ID: <2d530a22-8817-459c-89f7-66aacfd64792@amd.com>
Date: Tue, 27 Oct 2026 14:43:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 23/26] treewide: Rename dma_buf_attach() to
 dma_buf_sgt_attach()
To: Mikko Perttunen <mperttunen@nvidia.com>, linux-rdma@vger.kernel.org
Cc: Alistair Popple <apopple@nvidia.com>, dri-devel@lists.freedesktop.org,
 sumit.semwal@linaro.org, =?UTF-8?Q?Thomas_Hellstr=C3=B6m?=
 <thomas.hellstrom@linux.intel.com>, Simona Vetter <simona.vetter@ffwll.ch>,
 Matthew Brost <matthew.brost@intel.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dongwon Kim <dongwon.kim@intel.com>, Leon Romanovsky <leonro@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling
 <felix.kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
 linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
 iommu@lists.linux.dev, Alexey Kardashevskiy <aik@amd.com>,
 zhipingz@meta.com, treding@nvidia.com, jhubbard@nvidia.com,
 Karl Mehltretter <kmehltretter@gmail.com>, Jason Gunthorpe <jgg@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <jB0baKUEStaR7DFEykw_Qw@nvidia.com> <20261027123308.GC1671235@nvidia.com>
 <Rajx42GMRO6ivDcA4gzBaQ@nvidia.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <Rajx42GMRO6ivDcA4gzBaQ@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0428.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::11) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
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
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|LV3PR12MB9168:EE_
X-MS-Office365-Filtering-Correlation-Id: 82f8fd8e-8d24-4b87-1c03-08df3430496c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|261021123027099003|261022075727099003|261021121427099003|261022105027099003|10067099003|56012099006|261026140227099003|6133799003|18002099003|22082099003|261026121527099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	ZDviRu5NoPC+UoNMAl65C7GMnmbjchsv4Rh34czYFMGb6ipxr2A7W3EGAY1DT4M8qOT+gqAW4+6QhfhEvV9mct9rlL1cbwMSej24WJaYdpw5knAuZh3fe1TQipO6v6dcZNw63zBiotnier4bt6cWZgp2nBHht3dKvtCFJv1FxCylC4Fi+lD7CO0QyNvuk070Lb8Ytwenezmk/9ZCA92poGUNrHlzqWGGSrzuXLn3SDOPKtQOWaoWxEOJ/U9Q40zm41SJvRyuPY2tnt4KTbYsvHDQgANU0f1cI+6LYmH0r0Ea7TD/gchcp64SvDgCu8MQ2mnolvUHdYsHZiSHn2fSIBCvkblN+NkIv9lJqfNZWCnJ4jH9NyujRRQXO31rcZ6DhzSP0CM/EfX7N0AStsx/FD5pew0cDwvFj2+4J0Tuokfw3D6cR3a6DsyWFg5S0GyJulJzKWJ0UVvCOQl0P+6zmFRCWdnoji3Pu6iTsfQXfENOnmEv2h4Fg/IDseeGCEdhS3FY7zYdj6BsDejZYKo7w2v8ImFE+rkvNuj5zxSod/B/G7a+9rJQbLCxk1tZZ6OC1COKOUiDzdDPjRvK9aJ6y1TMJqRBMebaNIqCNinI7JVFsIJNNF+oRGDruqa6IB4iZwhgq+T7lW5oEw8nirlGk/HRYzknIh3qNaxtkfmw+iY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(261021123027099003)(261022075727099003)(261021121427099003)(261022105027099003)(10067099003)(56012099006)(261026140227099003)(6133799003)(18002099003)(22082099003)(261026121527099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Um5SK3dtbllod3E2OWl2a0V6NmRLVEE0V3VCL1BFeDhkck5FWGdjSGo2cHVK?=
 =?utf-8?B?SzRQWGdtbHBYRGxmNlA4WU1yOVBnSEtOZFhQeG1sb2hOUGZQQzNCdDRoVFB4?=
 =?utf-8?B?OGx6cUxhM2lLL29tYTV1dXhueWIwTThnNlFUbjcrcTJreC9rTnNscW4xYmxP?=
 =?utf-8?B?bzBmMmZzMldVMHhwOTA3SkNmRlppbmRVQkJtODJBN0dMZktIZENBSVh3d3FV?=
 =?utf-8?B?MkNmb1pXaWp6YWpybVpzcW0zVnJ6UklpbGdkNlNJeVppdGJsdXZrUEF0bUR6?=
 =?utf-8?B?a1l5M0lzZ1FKeUJZM01tMnJBYmM1dE4vQmRTV3RJZWREV3lWWDQzUlI5RTN0?=
 =?utf-8?B?S1FCTnFJSlRtcWxDemVQYzlweGk5TlZjZHI3ZHJFWGxDaktsWkxvQXdOZmQ3?=
 =?utf-8?B?U1lGQTM3TWZsYkowZTRZRTBvNjh3cmhaRnkwbW1MUk9LUG1jblhXNHV4YzVQ?=
 =?utf-8?B?QVBCc1BsSkNUUjcwVWp4TVhWU2k3d0xkdHBFUUFRTFF4ZUNjTnF0UEZtWmRD?=
 =?utf-8?B?ckNQTGlNSGV4SlJOenllMWJLYjJ6cHdMNE5uYTNOSFRib0NoUXJwdXlZejIy?=
 =?utf-8?B?S1JvQXhqWmZrclVkeWh5Y0RNNHJQZjhWQUtsV1FrSTFsNjVhQ0F1YUphMVZW?=
 =?utf-8?B?RTlQSFcwM3VycjIvQVNiQ2R5cWVXOC9HdGNCQUtkOG9Ib2pIQzY3bU5aOHV1?=
 =?utf-8?B?TkJaZzlBMGJ3TCtvSFNBRWxWcmpBR3ZNNjVaS0VWenhMOXdERVRWWXJkYWhM?=
 =?utf-8?B?M2JFc3BZY0NaeitVdFJKeE1ZVXdKeGRIZXlpcDVZRnArekdJdXdNZG5LZGNo?=
 =?utf-8?B?ZkZJWkZObkNsMEpNRmQzbWFMMDVqTVN3T3ZPSkNyQkxGYmpPckltNmI2Y3dS?=
 =?utf-8?B?ZVM4YURxRDQzdFZrUXkrWkNmcFBDSGpFNkhhaldiMmdxUkFQd21LQ0xOSlhI?=
 =?utf-8?B?TWlWOHpQNk5mNlk2a3Z3WVVjdWF3L3UraWRHbkd4aC9IVWJzVHNKRXlvV01B?=
 =?utf-8?B?dm4vWGRXeGhDeTdKUVhTbmJoWXg1Qk4rRzlHMG1wQUtBVTJKY2o3aWtaUFI5?=
 =?utf-8?B?SXdHR0ptbVBWOXYxdkhVVDN2eFgyczR6YmtZZXBxWjBFOFF6Vnh5Z0t2a2pU?=
 =?utf-8?B?QzJUMXNJam44MEJYd0xiUDhCOS93bXh2RGh6eWZnNVJ4VTZFeGVRSWRiRFR6?=
 =?utf-8?B?dlVLMTY3YzFQTXgzZ2Q5S21nZXo3ZHpCSzByNlcwaTB4eWtHMFRVb0U2WTUz?=
 =?utf-8?B?YWhYU0owZTBMMWNxdXpzMnl6Tm9XQ2cyQVdNZEhGOG5IbXVWekJVKzV2L0hp?=
 =?utf-8?B?WlZCUnV4TXZFU3ZXdnJjTG5ONkFiWWhZcUNxMjlpa0k1UkNkUmNncHkyN3RF?=
 =?utf-8?B?ZFJBSWRGbzZaWUdiK01XQ05mb05oU1g4cU00czNOU0pPcGdNUDI5TmlrSDZ3?=
 =?utf-8?B?N3pibXIrZm4xcEJIQlJ2c3pUTFpLVEpCTEgrUHMxbDQyUUdhK0xrYUQxdG0v?=
 =?utf-8?B?Si84MWlVcDhHVVZrSmRDN0hqUEgrUUZDNWduY3NHTTNGRXhFWHZSRmUwK3lN?=
 =?utf-8?B?cWlHNUE0UngzOU5LSTVDcFlQQmxCdzBTL2hLcXJxUzIvOWFoMDQ4dzR4cS92?=
 =?utf-8?B?TkVLT0s5NEpkaVF6a1FBVllqaVV5amJPTnpmRXMvOXZ3cGpLQTlVNUpKNzNC?=
 =?utf-8?B?azhqQzFpSEdYMFU2UzRMZHNLak1UWEdIdjJSZlVQcVRTSXQxYjlnWkpwaFlX?=
 =?utf-8?B?TVdqNXRGbXhKdnJaNm1uSTdQcURyUUZ2OVhSVUlXWTVLZE12WlR4QkxhV1g5?=
 =?utf-8?B?ZFA5eE96M3hkckhLTHZueWdNTXJXb3lLNmdtcDBYZjVnMWptNmFhRDMzdFds?=
 =?utf-8?B?U1VMbHlqVllEZEpDbTlvQ0tsS1VnbzRhak9WeTREYUxORkFzdlhsT1pFK21s?=
 =?utf-8?B?M0N6cWdoc1FLblg2QzFQSE01L3A5K0hWV2hMNkViOVBISDRGbklzZEo1cGhU?=
 =?utf-8?B?TFVucENjcWFtUGhDNlhiazRDRGNyYkJxd05KcklnV3lrQmkzdmJQOCtnUytK?=
 =?utf-8?B?THFqd3ZKdVhNTUFVTUNQaDR3c3ZYWWlRZm9vMmJBN1ZLL0liZDVBOWRIQXkw?=
 =?utf-8?B?VU5TYlhyTURMR2lHV2U2Smh3MklzZk1INTdzWUtWOUJMVGVJNTV5NmFJajhw?=
 =?utf-8?B?ZDhPNzNrN09QZ251SDVyc2d0Zjh4bFdLM2RSYmZoNVRla3NIbVEzYVJ3ZzJk?=
 =?utf-8?B?ckpaRlF1eUtVcTM2NTZrb3VGeURZdmdGNGxJbXRRNlJIcC8waGhUZ3JaRDNG?=
 =?utf-8?Q?klnG/tKJr8D0Q2GcV8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f8fd8e-8d24-4b87-1c03-08df3430496c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 13:43:30.6362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XF8ovOZAWGozEZwTeWaFPEpdnB1g2wg9OwFEzxzSx3jvx4ZdpA9+W/jtWyyn58hM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9168

On 10/27/26 14:34, Mikko Perttunen wrote:
> On Tuesday, October 27, 2026 9:33 PM Jason Gunthorpe wrote:
>> On Tue, Oct 27, 2026 at 12:42:32PM +0900, Mikko Perttunen wrote:
>>
>>>> This page-side use predates the series, so the fault is not itself a v2
>>>> regression. Is dma_buf_sgt_attach() valid for this call site, or does Tegra
>>>> need a page/physical mapping type first?
>>>
>>> Sounds like a bug in TegraDRM; we should be using the DMA addr/length 
>>> for the explicit IOMMU mapping as the sgt attachment is for the dummy 
>>> DRM device explicitly intended to give us physical addresses.
>>
>> No, you cannot connect dmabuf to an iommu_domain. It is 100% always
>> illegal. DMABUF does not support this. Do not pass sg_dma to iommu
>> functions either.
> 
> Sure, I agree -- so let's say it's a bug on top of the baseline crimes 
> TegraDRM commits :)

Well the initial crime was to abuse sgt to transport dma addresses, don't document how all of this works and then be surprised when everything blew up.

But yeah don't touch the pages in sgt exposed by DMA-buf, that is pretty much one of the most fundamental rules we have now.

Regards,
Christian.

> 
>>
>>> I'm currently in the process of removing the whole explicit IOMMU path 
>>> so if this only occurs with CONFIG_DMABUF_DEBUG enabled, I don't think 
>>> there's a pressing need to fix this before then.
>>
>> Yes I think this is probably the only way to fix it :| You have to
>> always use the DMA API
>>
>> Jason
>>
> 
> 
> 
> 

