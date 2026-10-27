Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793072560;
	b=COx5MpLrw4btmYvkV38EmWuNDlW65j2rAIxRG0ansKND4HdxHlCfVylBNufYEwn1LI4W
	 rZ2RQRAe/yUQqa9qSVTvzA0uykqMe8GerKdOJomFBECox6ySrwa8cp3cdwtIMyLchhq76
	 W8h4fZFiUtmQvvxqDsKLHg7W2wI9fCejeeBfSsnitFA/1hVz4S+UKnfPpnrfDI14DPfZY
	 k9qh3syJHacBlJkUuA3x8jnOfcXzjb7yC/MvT45vHu1scv459LNu/O/VAPByE+4iDf0M7
	 5jP8up8bg94+NLu9wzjAlJSMdz5z0iiLe4JEEGfGOAd7AuoA7O0ZCyfmku62j+qLfdA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793072560;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:
	 X-MS-Exchange-AntiSpam-MessageData-1:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=bIr823/UzfsG9CRAeLIu2WbktM8BknLKIBPc+Dr9qXU=;
	b=0sO59QrKrudSu1yzEVJfUG5svepQLX4EJqh++LWrVGCYGLG4zXpCGP0wglfv2BkrXdp2
	 NSJ4HYuslScXG+nPHoVtTWJTrI0oImWjii3mvZ3wdHSFcKE0wJCoyieujuedVVwZZi3pO
	 v3LLy5MJe5lBArvHdP17Bo7/xLDQ3Tu1hizgbAreXCKlB/0npR9RRW5TitWpbVd08dwNM
	 YT7Ais5LQvKq8QYkzZzwP8Wspo1SO7udZpp26I9iINc2hLyecuIh3nLTjBbuUYA1zPfQh
	 d9ryGHQLSI63h3T8L2MZfFtC+YAVse92AYUQ8zQBRH52XKdF4q9Ur9lwGGzP1VH+p/w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BOndQ1Hm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.47
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013047.outbound.protection.outlook.com [40.107.201.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1F6606A31A;
	Tue, 27 Oct 2026 03:42:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1E1F6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BOndQ1Hm
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K1bENl+UGN4TfrQI45+YBe0se/6GR7zvWF7f7itucI5C4u9mXPrS87aFi96zFVLh4qUJOv8/QJodQcXbjXfemjT3350PiLInJwG242a4x9E58kqWPRvWv/Z+oFrPeKLFokCy9iHNUJ9zEJQIqIQaD2dvDxXMW/10kR94BvWv6NgX9xxc2GF0ufU3PRADrU5Y8b4B7nRXSYSH6N3IzZFSBWub6AshHKNEqbxCNw0jYHWrACe/HcjcAQaoEoR1AUPeCVxqy5KTQfYfGu+89tnWApb8KLZCF9mOc8w+8O6zcuKmyeOEX/5ha3f3VGh4UDcqmDKwDOZgt3w5QVg0hxgIjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIr823/UzfsG9CRAeLIu2WbktM8BknLKIBPc+Dr9qXU=;
 b=fnPJyGgsBkuIngJvzosgiDbHqs/IpTpRpGlAsdayo4jTDPMtSunaUQfIviiWGx17zIl66g2uLRYFAf1+XfnSgHTEZ+FAxm8HyxdAYlZW4FaGn5Tf/SyT3j1txmFSY9I0zRiVh1UYvX18M1VMAb76zw1LdYyiVww0aAH+ZyG4fx1FU86io+MDCI3KpEEQnjTbuDqDk6TqSOnUWuFYwqSQ+iZz5YAZBZEPdkck/JtjR54HU1bzqYKjJF4iktiKhqi35wilBvZgnplMUA6vgiQd5PEvZLnbPqmk/M1uchf78cI7F+kQVmFMeaMQr3F8G+7/Yd7IQf2wvXFr83FXy5j6gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIr823/UzfsG9CRAeLIu2WbktM8BknLKIBPc+Dr9qXU=;
 b=BOndQ1HmuhqJ7eMDjkK6G8BbGEXMo50YlznzoGH+4VUINexj/O2WLcHYP+Nj2fS/NPddkOKiM8pJK98/YhVed6VKicGzLCj7UN86nRPSLWEgNLGpTYHktg19+ofthrVVV1G9CMyPbVqD98SVfK8fBYPw5KrGbVzLOrInmex1ymUGY//fUIlcrXLUhS+UyyHPjxurl669KpVgm7L0ilFHm4cYAhyHZ+1EGBFVSeLPmoTh8rCRMQglaRDrRStmT1A0WAbNYqrGs3mRqWaQLhJ5Id0HVpzkGi8QHO8CI+pmMMX9OlW2lUoj+ZiH//g4XsEa+BOPlxypz0tcvbTtahyzBA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com (2603:10b6:a03:566::20)
 by LV8PR12MB9665.namprd12.prod.outlook.com (2603:10b6:408:297::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 03:42:36 +0000
Received: from SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017]) by SJ2PR12MB9161.namprd12.prod.outlook.com
 ([fe80::d9d1:8c49:a703:b017%5]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 03:42:36 +0000
From: Mikko Perttunen <mperttunen@nvidia.com>
To: Alistair Popple <apopple@nvidia.com>, linux-rdma@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, christian.koenig@amd.com,
 sumit.semwal@linaro.org, jgg@nvidia.com,
 Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?= <thomas.hellstrom@linux.intel.com>,
 Simona Vetter <simona.vetter@ffwll.ch>,
 Matthew Brost <matthew.brost@intel.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>,
 Dongwon Kim <dongwon.kim@intel.com>, Leon Romanovsky <leonro@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling <felix.kuehling@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>, intel-xe@lists.freedesktop.org,
 amd-gfx@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com,
 treding@nvidia.com, jhubbard@nvidia.com,
 Karl Mehltretter <kmehltretter@gmail.com>
Subject:
 Re: [PATCH 23/26] treewide: Rename dma_buf_attach() to dma_buf_sgt_attach()
Date: Tue, 27 Oct 2026 12:42:32 +0900
Message-ID: <jB0baKUEStaR7DFEykw_Qw@nvidia.com>
In-Reply-To: <auAIO0y09SXk34CN@gmail.com>
References:
 <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-24-apopple@nvidia.com> <auAIO0y09SXk34CN@gmail.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-ClientProxiedBy: TYCPR01CA0161.jpnprd01.prod.outlook.com
 (2603:1096:400:2b1::11) To SJ2PR12MB9161.namprd12.prod.outlook.com
 (2603:10b6:a03:566::20)
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
X-MS-TrafficTypeDiagnostic: SJ2PR12MB9161:EE_|LV8PR12MB9665:EE_
X-MS-Office365-Filtering-Correlation-Id: e798faec-de9f-4ce4-ce5b-08df33dc572f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016|23010399003|261026121527099003|4143699003|11063799006|56012099006|261021121427099003|261022105027099003|261022075727099003|10067099003|22082099003|18002099003|6133799003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	btsvxWYuKcB1hzxqjl/79VqPSfsRwqK9UwoaSlZSLHuP7MeEbTB0he+ds3tuuKGl6FeogV50eOVCMyRt+z++7Y5151nz4ZBRa9e66eJk8x+7ESHsf3YUt2wHEFMbureRlelkL8PyK3mvNNqNaFdjQZpIuYd8I8+vkC01lv2nBoL+XlTrBCPJNc7Sbeb4x/xPx6upo/ZgceciUweUzfuzYrjNnBtHpYRDcolMggRpgQC6Z+cJ+J3XQIvI8DHi7Jw/BD9pJA2QKvYrDzNvFTKOEVbpEVoB6mV+zkuE794hztNtFWRtNEam4n3oPboHNxPcv8w4sRqBpIK0yPk70ufUiKjaIrq+PEjvSqd5rlrUbzARImJEnOnrhT9QDBb1TlvYhsdM9/Yy6/N+P0JjL1Lt+0hRAW5PcJgduAkh5XiJQ+IkjYxqXeBJ8Fe+sPwp7JaxuvDpb9PIuKkDy+DPXFwaTQdvuYIV4QSpyT7BDJbLot4MQfk40P3lKF50SaAN2AfgdBOYVCAoyhvv8KDsvgGe4EyNsF1CeaI2k255I0t03vVHTgGlcnJ6rD5RBGPUdFcUi3ah4tSV5g+0wYtHdRN/ST6opYFrpavQsHXR0zTY8DkuWqm3vWwU4qH7Ipms0L4RpRfhtSfZqicZp8HPIb1v11LZ/wVX9Ch9suE2oizqVP0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB9161.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016)(23010399003)(261026121527099003)(4143699003)(11063799006)(56012099006)(261021121427099003)(261022105027099003)(261022075727099003)(10067099003)(22082099003)(18002099003)(6133799003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0NKSlpaNElMMGpBN2J4aC8yRElZcmlNVDNLN3dyRFVXRmx2U2VTL3dkdkRF?=
 =?utf-8?B?YUVWRG8zNEJITGtZTzMwRmV0TGorNHFDdWJZTURiTWk2MHhqcERQVzJqaW5k?=
 =?utf-8?B?eUdIL05iUnlZdm8wVGZGRUcraXdTTEk0Y0pTNm14ejFFQzJkVTN5Skl6N1I5?=
 =?utf-8?B?WnAxRXg0bDVFUWVKV3JWY0pZRldVMkRTVUd5U01zazVBM1JjZ1NkWE4rbisy?=
 =?utf-8?B?R3JvVnpTWkdmZmZSa0cxbGdaNWJUS0NzNDI0TUZSaEtEV3VIK043anJjVTJY?=
 =?utf-8?B?UnNvUGlCUE1UZWZLWTFpK3FGU01QUjZsRFRhbmo2S2dYMmpWMkhOVURGRytB?=
 =?utf-8?B?YW1qMlljRGhSSENYSThOMjVSa0o5cExIeGlUR2wzRm1KQVhsbllCamlkeXhK?=
 =?utf-8?B?enhTVk9ueXZQL1ZwSW9lL05RKytZSFBSTThIOElTTFFGM25iK0tiM2FkdTd5?=
 =?utf-8?B?VlBXSWR2bDNqMER4STJNMnI3L1VGbmRsQ1hRRjhseDJxM21maXJDaVB2L2tl?=
 =?utf-8?B?M1lJK2VpSFB5ZmtCaU90bnlHSWpUSlB5aVNSTWZVY0dzUjFEK1JTTHBkcHY4?=
 =?utf-8?B?dU1Wb2ZZb0lSd0RQUElaV2oyWHhpTk82aTBGekE0Sklxb1dFYUFqTFRGQmZn?=
 =?utf-8?B?a3R6dGlWdDdkdEM3M1Q2V1JNY0J2eHh2SzNBRUxNalhCcVovOFBaUGNLZVpv?=
 =?utf-8?B?Yi9xeGk3RndCRUlGdWhrdEp5ZHBRYWJIdVRkTHg0MEZUdlhWNUh2dzZtL3Az?=
 =?utf-8?B?VnJsTDcxK1NkS25TYzJRai82OW9hK2lRU3EvYVkxTzc0N1VWb2NTbmFJUGdO?=
 =?utf-8?B?QWxCdTZkeENaQzJOL3BDSkIyby9GQlV5MnFsY2lEWklxMUx3Tk1LYWV1Rm1S?=
 =?utf-8?B?aGFIN0VuazJOckRXZ1ZYWjlIZmhUbG5UQ25PYXFsODluVlRrdGIyc1hKWlBi?=
 =?utf-8?B?d1Rvc1RWbTZKR3ZlN0JIUnBzSGlKb1VTVml1VkVxOGsrYXFTVG1FSWdkeVdO?=
 =?utf-8?B?aGdBSHJjMGhUTXZiTUdzbDBYTzRZSmpDcGlkU3ppanNJT0FuMlh6bW05RXA5?=
 =?utf-8?B?UTFGckcwZkRJMkRDN0RSTGRKM1hiUWdReWR4VVZCeFN4d1FMcTBxNWxJL0s0?=
 =?utf-8?B?ZjFDQklFMjdzWU5GMXB2VlpiaUllRXRNV0twcXZIVGlIWFJNc3ptRUtXS2gx?=
 =?utf-8?B?TDdnK1NBcThHOWVmeG8vL3FuTzlnL1AwcGsrNXVuZ0p5ZVBRWkZrVlh1ajNy?=
 =?utf-8?B?WHpZYUhneGRLR2lGcUdwVVlaVktna0tYeVNjZU4xOThWVWhvWVg5dVRDdkha?=
 =?utf-8?B?bGQ5bnc5WmZsanl4enFWVGlveDErMHpDajliZWxhYk5RemlVTjhkYVl5ZC8x?=
 =?utf-8?B?WDZ3YWpidjMrZHJiTGdKWnlDOHJKRVVCSnJVekxLZCt6a2FXQkRoZEpaOVZi?=
 =?utf-8?B?aXdTTkt3N0VWdGdhSjhNTEdqR29HTDZmeXhaSXRXUVdaK1lJcU1ud2NvSWVj?=
 =?utf-8?B?VzRnU2x1VUFHRnVoSGE2ZHJXMmpyT3doSUJTNnBrL0dWNllmdG51M2tzTkVD?=
 =?utf-8?B?Zmhna203c1FScUtubmUyZWVhandJdGVZOEFLTkhtUEFGMFdCd2drNTlUbmRz?=
 =?utf-8?B?cEgzbThQS1dUS1U3ZCtkcEZ4NTBzSFZ5SFhIL1lxNmxid2JPcTNXaUlPN2JE?=
 =?utf-8?B?UWxOZGJFaS9KdzZoalRXeFN1SEd4a1ZDY0hVQVllaGNQdWRydTFjL2ZGcFVV?=
 =?utf-8?B?L2IwMEdVUHZIVmh1VHNPRnU2eXhVUEkxSDhEMFpsMXIwb0tGUVhydTVCMVVM?=
 =?utf-8?B?OWtyQU13czBQVlNEU05RT3hNVFhRUWJLQjFJekdRV0QwL3c3b01nZThhVy9F?=
 =?utf-8?B?NmVTb0h0bmRKS2IvUkxJMnc2ci90VDhVeHZuamh0TnR2UEtaSnY2NHppWWEr?=
 =?utf-8?B?MDZBNWNBaUFqRkdXak8vemVmRmovMHJHQnUyaGJnZkhVSjk4SU1FTUJNRlQz?=
 =?utf-8?B?dnFtOWNBZGhvaHpHK2RNVmY5NTVBUmlNM1RONnhXRWVhQUVVQ09VUG1wWkxa?=
 =?utf-8?B?ZnhNQ3pOZkVJRWFHdXRVZDNtaFh0YmZTN0pZbnIvMGdIYzZ5eFMzMng4U0t0?=
 =?utf-8?B?RUNhZm1odmVzN3BFdVcvYTIvWFM0elhxR2dkM25HbWVCRXFGNEh0dlJMR29C?=
 =?utf-8?B?ZERRWG1QSDE5UEE4cmtVMzEyVnh1UUxZSU90SVJZN2htQzFLSzZQWDNIUWNj?=
 =?utf-8?B?WWV4Vmp5Tnk4WDVUM2lYTUdpL1BNUDk1c2hhTzcyWGpueGNoOTIzK0F6TjFI?=
 =?utf-8?B?Q1FvQ1pRVkxCdVJDTFJ0WFhZcTBrMEJBbjdVcGVBQ2ZkMyszOG1CVngrV3VN?=
 =?utf-8?Q?uANqSSZEUqFWtcBq8Ox16qaVfwSc5NZ+gifCVn95cDkna?=
X-MS-Exchange-AntiSpam-MessageData-1: B/HnEOwHuQxkxQ==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e798faec-de9f-4ce4-ce5b-08df33dc572f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB9161.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 03:42:36.0242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3s6wqKZeX4bA7FOhFSdvS3A1TGPcl/LsJ0vjFKi3aOCjPhaGCTF+RQBlVebaL5anjN68m1lUY8y1YO9lc7NAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9665

On Tuesday, October 27, 2026 11:15=E2=80=AFAM Karl Mehltretter wrote:
> On Mon, Oct 26, 2026 at 04:36:14PM +0100, Alistair Popple wrote:
>=20
> Testing the series on a Jetson Nano exposed this path. A 3 MiB system-hea=
p
> buffer was imported into Tegra DRM and scanned out over HDMI. With
> CONFIG_DMABUF_DEBUG=3Dy the PRIME import succeeded, but scanout immediate=
ly
> produced display SMMU faults starting at 0x300000.
>=20
> Tracing the fault led here:
>=20
> > @@ -475,7 +475,7 @@ static struct tegra_bo *tegra_bo_import(struct drm_=
device *drm,
> >  	 * domain, map it first to the DRM device to get an sgt.
> >  	 */
> >  	if (tegra->domain) {
> > -		attach =3D dma_buf_attach(buf, drm->dev);
> > +		attach =3D dma_buf_sgt_attach(buf, drm->dev);
>=20
> tegra_bo_import() passes the attachment SGT to iommu_map_sgtable(), which
> uses sg_phys() and sg->length. The SGT mapping contract only guarantees t=
he
> DMA address and length fields. The debug wrapper clears the page-side fie=
lds,
> so iommu_map_sgtable() maps zero bytes.=20
>=20
> Tegra only treats negative returns as errors and keeps the reserved
> IOVA, which scanout then faults on.
>=20
> This page-side use predates the series, so the fault is not itself a v2
> regression. Is dma_buf_sgt_attach() valid for this call site, or does Teg=
ra
> need a page/physical mapping type first?
>=20
> Karl
>=20

Sounds like a bug in TegraDRM; we should be using the DMA addr/length=20
for the explicit IOMMU mapping as the sgt attachment is for the dummy=20
DRM device explicitly intended to give us physical addresses.

I'm currently in the process of removing the whole explicit IOMMU path=20
so if this only occurs with CONFIG_DMABUF_DEBUG enabled, I don't think=20
there's a pressing need to fix this before then.

Thanks for the bug report!
Mikko



