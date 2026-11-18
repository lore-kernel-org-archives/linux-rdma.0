Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795011480;
	b=gonAnVM8SLBDajdUKAUA1w4IsTshsf+eOv+nqdcK3c47HG5fM6mcej6kVzizpe6oLHpK
	 3C0SFWU+0EH64XIHIXTEG7wNWqAous+Pg/JXUi2vI7wr9WFVUHJ6fF9oySuizAp4vQqke
	 K2X3oQKvfOFJGiV3wIT6hcCRVAxp+IdXZB3i1KEaQH0hh/+vd+kSUicRaE82K5kUIXvIJ
	 sgRv7EL2rvFSMQ9/siPkAGvBHUHnhxQG2I2yY39sUs4KnUBDQdsPT25PPdPAHx4mOM1Vs
	 UuQqtqPblCWogXCkhSDrpGI70Cq7gFZ1fAET4VGOuVxWw8MVEUDVlduBAbX++zTik9w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795011480;
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
	bh=n/Ch9L7rve/Erelt9Mmv+0BqM0jGNQxWBvv6uWfOIXM=;
	b=FwtJZs5P+mLS/bSTcyYdeytDlLNif8j/SJ1P5lhwtiA1SHvAp266pT2cd+32s7/BlHa+
	 WVUVqoHiyZVHVz/RaCz0OL97nXLrTY1vJw0H20DQYptJqt0y80qN5VE+zw51H6qBjWxOH
	 tK2UA6MdW25qrv0VC5pwyHPgKnPPPomqbNPefQ/kZSaBoY92mkHFeVIzrFkqh00edDeWz
	 lWpima2j2xgOmw7nf6C1RrCaajqaHWZxJ4iNHSd0G1azIY9qZyhi+OAwP6imT72xtaJVx
	 JmyFBDAbLuO0vreRQtg56Msq8pSyAxRtKbJNzGhTG6i+vPc+l4iTDpAH1/p12v3rFbQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aIJAj17D;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.47
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013047.outbound.protection.outlook.com [40.93.201.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED44760A2606;
	Wed, 18 Nov 2026 14:17:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED44760A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=aIJAj17D
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tbbTj0c0viaPtlI0ZiaxJCvEkCPBdYgKv6njZxHGZYJnfDo/THB2ykjmKgg7sZFf1jg42m/SztSwds5ExHYfCSxjsW0BjmjI8HZ8jB9eKV5iuhvXeKbxML9obNdfGq2zN7YPfg6Ejdg9hrSeZYiBMkvXBz68/2Aav2Cuflrm2oGwhJWToZ/uCQLYSq1iTV6Lj6No/o3LFXH1ajI1p9KZSFKFQ5orwOMpHRvAFaJUUQqjqtgtAAwEp4qhhyDitW0WE59FUTiXE0ku8VwbXWKNgpxH5KJerFRq5/Q6GQcCKELCTNNtyLDMcdkYPvWal3Gy6Z8jN/xhMTPPWLT61qpFeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/Ch9L7rve/Erelt9Mmv+0BqM0jGNQxWBvv6uWfOIXM=;
 b=rHYnnCUKFMdPhDEii09VU3XqSWBfO9Yr0GsEgh21CQFcjuVvV0v1//7WZ17stbiBObdNcA2rvGeFV0RdOIZCTCTocRY7BsmqP9738cSoDOaCBn7NP6ErT/8kEp/1j6ZI+4hr5PrhZQ0xMApB1201QNBasQDbZSVfITLix9D8QacZrBM+f6T4Uk5iuA5n5flnDnPb/+kLuCKNz6ZfxXrtfrJjyeaeGBXogKIOYGuztQOLghk2ySJyXPM8H9wXW8X7a0Pkppybd5DQHeSQazXAk0e5b0x2Jl7TEA7YXmaTF8sm99ljBhw2pcM1RFwjYdO7a6o7Wxu+SQm7iQkw0TdiGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/Ch9L7rve/Erelt9Mmv+0BqM0jGNQxWBvv6uWfOIXM=;
 b=aIJAj17D+ErJVwKfKj3t63hnXH8Mgy+HUrr5w8cLL8CVQNTagj54ieGiKEYRbVEg7Kqg7KNT/U+hLvr0L0DFfkpo+Zwcrr1Svh3Kqf0l6yJCpzRj4T6dAAB3puY2e/reGBDfOO+fEsge1JJMO82+78UxTFwTB7wLkWjCT3bderlYxNVsL9Jh4hYun7f3IVV6JWxoFYMj6PugVg/JpcgeuFZ89jq22lJ7C4fRfUqTClpIHWVVkz/EcjiDs4xz8ApjnyLuR25/rUA7m0H9TojBFsDWw2SkpwfY17CdowdbcVMs5EojrCcEtotlU9565qWAk5FF7v8NQ+Lt0OyidJPadg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by IA1PR12MB6161.namprd12.prod.outlook.com
 (2603:10b6:208:3eb::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Wed, 18 Nov
 2026 14:17:40 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 14:17:38 +0000
Message-ID: <a64c831a-808c-46d9-b6e9-ad1b63577291@nvidia.com>
Date: Wed, 18 Nov 2026 16:17:33 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v3 0/1] net/mlx5e: fix NULL pointer dereference in
 arfs_create_groups()
To: Jinvas <jinvas@126.com>, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, leonro@nvidia.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, horms@kernel.org, alexious@zju.edu.cn
References: <20261118134514.1765-1-jinvas@126.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261118134514.1765-1-jinvas@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0007.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:9::7)
 To IA4PR12MB932075.namprd12.prod.outlook.com (2603:10b6:207:12d::15)
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|IA1PR12MB6161:EE_
X-MS-Office365-Filtering-Correlation-Id: 9acba0d8-2336-4600-6dbd-08df457eb336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|921020|261021135927099003|10067099003|261022075727099003|56012099006|11063799006|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261026121527099003|261102123227099003|261009223027099003|18002099003|6133799003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	OcuEkyZupO2T4VuFxgff/laOuw5OigbP2ZRSp7sbrMqgjlki7jfGkTS6Vc5BAMqQUBgDCy5r6qPLrww2eMLyVQbwCrDMAdcjtppbRABN4UUDVst0OKIaoC0wHh8CIxW5aFVk+Kl0Emf+/vTJn6O40UtM06r0NfWsjLfGyJOERdcLws75kP0LppW5MBs6y2EHK7dp9F5gKTRgsF+2uAjCMQjiFqXv2IL/snAS1kRu5N4HMY+RajeQ7xQ39gU6NXY+ohVHMmvThPA0eDJ9IRWlbFCIESLNVqdMtyoifTbFPuc4XvD+ueGAcb+chYZQEepiEa+DNbkG+Yo7+gOLnaiN5P1uIncS/Dqek5c/QFyAHHTeYT8i9GohTtJdI0Y1tnMmAZvUD/0xvnLw/LMKoJQrpbQrOCY25WziBHZGcv+WPGjBaKQR85qA8NdNyLqz+29eeyN+CM0HImG0EMGyMizKSCQLZsrpcY7bhCCxka6BKu2aYvaxTv4iNFkvDAOwHPgEexlKHPuQYyxmhPdfibCE/pQikMGYc3DXboKHZue3AoatFLh08gbWKIMKdTfNYfCGFlBT/SeAqAtJEMd1J0Zbeb2rPY7ycRPK6twBsCpM/svDUGQCdQG4Qw6FmonkqyJmVIL5SYzYOBa9IevHfRx8I5d6JSzi6+5h4L2e849WVMBOTaXQ+kQqenOBHJmfMhDBr/q4MIKFQxWRNPXERztgmw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(921020)(261021135927099003)(10067099003)(261022075727099003)(56012099006)(11063799006)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261102123227099003)(261009223027099003)(18002099003)(6133799003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?blBTOHVFY2RTSk1hTnFrcFJVSlhwL3FuSTQyWHRaaThWb0xKc1ozQWJRR1g5?=
 =?utf-8?B?UTJuNkNkck5FM3hSVWdXRG0vV3Vtb0U5MTZVK29NUXN3aFJtZHB5L2U5eks0?=
 =?utf-8?B?SnI4dkR3c3hSMUdET1U5cEJuZk5uVlMzQmFYV3hyUDQvT3oxZGlla3BORmEz?=
 =?utf-8?B?ODU5VGh4T2wxVGxVM25BNmxSMVk3eVZiTEk2SkdjQUNoL3RCR2t2ZzRjRUpZ?=
 =?utf-8?B?NFFvaFU4QnRTWlVyNlVWRmRPdUFYY0N1TXNEWEp2VEtNWXQ4Vzh3aHZOeUww?=
 =?utf-8?B?dVl6dHFSdFJPanhkUkJ2ZmNFQklCMGJUSXptWG01TThTQlBoTzVQRm4yWDI0?=
 =?utf-8?B?SFJ4VHJuV3VuYTQ4WFd0Ly9HSjl2TkNBck1mWU1CbUZpUEpsN0dRTmd5WG91?=
 =?utf-8?B?MXlVbDBCRGRHYmNQQ0NQbUYxQXNxYVAzR3cxTnNvdTgyK0dTdUx3RTVLaU9w?=
 =?utf-8?B?TXpuQ3MzYmJBSytnVnF4c2gwa0JFUjQ3S2ZDSXJiWU5qNjc2azVNbDRUS1M1?=
 =?utf-8?B?dnI1Y3RRaUJkczhGWmNGYzRwTEN0TmxrWXExKzl1bFhiTkhMdmdsajh5aElK?=
 =?utf-8?B?S1lYcFJnbjloaGpUQytXK0dabENlT0x2TWpvQXB6TVdaSzFBckZNblNJZnlC?=
 =?utf-8?B?STNXci84WWdHN3VqemhjTUVEWmUwS2JjZnJVMDEvNlQ4QU9KYitxRUthWEQr?=
 =?utf-8?B?ZlR3dHk0YXpxSHF0NDQrMVFRSXgvcFF5OWxlV0RNeUpHdVNNL2c3MnhrS1RG?=
 =?utf-8?B?VW4reG4vQWFhM2JadzdUV2xZeGdhMzVWVW1yOC9SYTRsU3A4c3JVMGtWUGtR?=
 =?utf-8?B?enFyME54YVR6T1BVUXJ2RVRqbFdYOHFvMUc5Uy9tQnZvc2V3ank1NmpCU1Z3?=
 =?utf-8?B?d0g4Mi94bWE3WGdka0FTYWtaWHRNenhvM3FqekUwNVlpQzVtaUIzcE80TFZy?=
 =?utf-8?B?UXdxMENYNE9NRldkVHRGNUlyR09Bd2pzUlZ6QWJ5dzBBQlRTaHRDMzdXdEl6?=
 =?utf-8?B?bmMxMFVyU0dra1VXYytsVE8rQUtBQVlYSGR6L1M4QTlpU3F1Qld2ZVhIOUxP?=
 =?utf-8?B?TEhaUjBkbkl2eGlmazBvZUtRVzZSc2p0UTBkVHQxZk02bjByS1FmMUQ1SjhH?=
 =?utf-8?B?RExyTGRjTXZhYkV6RUk0V3gvNnRSck5iNUx6ODJ1Rnl5eWt2ZG93MUtRdmNN?=
 =?utf-8?B?bi9MZ25pYU93SEhFNVRVL1ZrbXdLVnNFUDIvN3l1SzFqNUFVT2Z2a0FPbEVS?=
 =?utf-8?B?bjZwWmlBWkFRR1A2alpoTjJGNDRSMm94SXgvZTAyR0FKMFg4RjE0a1pxSjFs?=
 =?utf-8?B?TVRNRGpyUHBRcUIwVE82M2pUVWJ0cmRiQS90RUtFNHZSSkYyZi92YUhONGt0?=
 =?utf-8?B?RDduMHdoZG5OY3FoZ3dKLzZQOGwwRGZWOE53d0VrV01tVUJmd2ljTUtSNFJR?=
 =?utf-8?B?cUxHR0ovWFR2WVI5VmRXTUh4MGhLVDNmbzRuV05EZXRhSUtYNklwN010T0wz?=
 =?utf-8?B?bm9qYlcraU5BUEowVXE5djMvcFBxK0pmZnpXNVVwNDdJcmdzZlpIeTNvdUJi?=
 =?utf-8?B?WmZUMVV4N2YwZVZRRzJha3M0UVc1RmJqeHcrb08zSERXSWo5czhlS25JSzVW?=
 =?utf-8?B?OUxteWZCTEVhZVJoMGpnT2EwMWwvNnNpeEc5OGFvUFdyODhRR29CMEF4VHY4?=
 =?utf-8?B?UmN6eVRTYjlIUWlwSlg2ZG9pdGIwdnNjM2VTWlBhNnc3NCtGRzdTV1FMWW9E?=
 =?utf-8?B?UjhNTmw2dHJjR3JOa0xZV2QxL2o2ZGNMSFZHU2ZVVEJaaG1EODIzN0o4OGJO?=
 =?utf-8?B?Z0JVaWVaZUZuWDExZHpBSzBTU2s2M2dNRDQ0Q0xXK2xIL2l4UnZtSmxFRUtF?=
 =?utf-8?B?clhmQmVVcEdVd2ZqY3N6VzVCeTJNQ1REQmJNcDNNeWdBWFJzTzhnTmhyQkZV?=
 =?utf-8?B?dzlZY2RCWFFyMjF3ZlAzUG8wU0FYZnpWeThjZDhUM2tnelVySHgwVnhnbC95?=
 =?utf-8?B?aFVVUFF1N2JPV2RvNXJWeTdDOEdDSzdEN3Fhb2lDVFRFclVCUks1a1RYTGV0?=
 =?utf-8?B?MmdDTjBjeTk3VFR3ZERBdldOTGpiTWo3Q1l2NG1oUTFiZDY0SjJWVDJHUEd5?=
 =?utf-8?B?djh2b1NuTDFFd2I1QU9mbUhoYkJYcjJlOHVWb2dOaVhZaE1yUmlqcnlOc1ZZ?=
 =?utf-8?B?ZnppUjM1UjZWQzNWbUxKd21mbFl2UFpxaFN2eGwzUHU1dGlScFFwbDZBOEV3?=
 =?utf-8?B?b1pobnlSSTRFdHVCSHdhZSthMDdDWnZCMXNFZ24zd2pOd0RNRkwyZGdyMTd3?=
 =?utf-8?B?eGFpQjNqT2dweExEZ3BNaFF0bzdZUHVvUThkVEFEL0U0QThFWVBXUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9acba0d8-2336-4600-6dbd-08df457eb336
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 14:17:38.6693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QcfQ8OH+1iNWP8OTp3jNLSIbPcpyv/rcz42L4lwwR8dSeHAgOpvi6g3Dk/hK0kcdsjO8HPlKPy9OcJohT/dUvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6161



On 18/11/2026 15:45, Jinvas wrote:
> The following patch fixes a NULL pointer dereference in the mlx5e aRFS
> code, which oopses the kernel during NIC bring-up.
> 
> The bug was introduced by commit 3c6d5189246f ("net/mlx5e: fix a
> double-free in arfs_create_groups", in v6.8) and is still present in
> v7.4-rc2.
> 
> 1. What happens
> 
> arfs_create_groups() creates up to two flow groups in ft->g[], and
> increments ft->num_groups for each group that was created successfully.
> If creating the second group fails, the error path frees ft->g and sets
> it to NULL, but leaves ft->num_groups at 1.
> 
> The only caller, arfs_create_table(), calls mlx5e_destroy_flow_table() on
> the error path, which calls mlx5e_destroy_groups():
> 
> 	for (i = ft->num_groups - 1; i >= 0; i--) {
> 		if (!IS_ERR_OR_NULL(ft->g[i]))
> 			mlx5_destroy_flow_group(ft->g[i]);
> 		ft->g[i] = NULL;
> 	}
> 
> ft->g is NULL at this point, so ft->g[0] is a NULL pointer dereference.
> Note that only a failure of the *second* group triggers this; if the
> first group fails, num_groups is still 0 and the loop body never runs.
> 
> The same error path also leaks the flow group that was created
> successfully before the failure, since ft->g is freed without the group
> being destroyed.
> 
> 2. How this was introduced
> 
> Commit 3c6d5189246f fixed a double free of ft->g between
> arfs_create_groups() and its caller. Before that commit, the group
> failure path did not touch ft->g at all:
> 
> 	err:
> 		err = PTR_ERR(ft->g[ft->num_groups]);
> 		ft->g[ft->num_groups] = NULL;
> 	out:
> 		kvfree(in);
> 		return err;
> 
> so the caller destroyed the flow groups that had been created and then
> freed the array. That commit fixed the double free in the allocation
> failure path by freeing ft->g here as well, and in doing so changed the
> group failure path too:
> 
> 	err_clean_group:
> 		err = PTR_ERR(ft->g[ft->num_groups]);
> 		ft->g[ft->num_groups] = NULL;
> 	err_free_in:
> 		kvfree(in);
> 	err_free_g:
> 		kfree(ft->g);
> 		ft->g = NULL;
> 		return err;
> 
> The reset of ft->num_groups that would have prevented this was
> suggested during review, but deferred ("it is a better idea to leave it
> to a refector patch one day"), and that patch never landed.
> 
> 3. The oops
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> Oops [#1]
> epc : mlx5e_destroy_groups+0x38/0x6c
>   ra : mlx5e_destroy_flow_table+0x10/0x30
> status: 0000000200000120 badaddr: 0000000000000000 cause: 000000000000000d
> [<ffffffff80843604>] mlx5e_arfs_create_tables+0x44c/0x5d8
> [<ffffffff80815bd6>] mlx5e_create_flow_steering+0x42/0x6bc
> [<ffffffff808043e4>] mlx5e_init_nic_rx+0x84/0x14c
> [<ffffffff80808a4c>] mlx5e_attach_netdev+0xb8/0x2e8
> [<ffffffff8080f36e>] mlx5e_probe+0x48e/0x81c
> Code: 89b3 40f9 e052 098e 7a7d a011 84be 3783 0109 97a6 (6398) 853a
> Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> 
> The register dump shows a5 = 0, i.e. ft->g was read as NULL. Offset 16
> of struct mlx5e_flow_table is ft->g, and the faulting instruction loads
> from the address in a5, so the faulting access is the ft->g[0] read.
> 
> Note that the bug itself is not architecture specific. It is a plain
> error path in C, and it is reachable on any architecture; the register
> dump above is only from the machine on which it was hit.
> 
> 4. How this was hit
> 
> This was found while testing a virtual mlx5 device whose firmware
> answers host mailbox commands. The device took longer than the
> firmware's own timeout to answer one CREATE_FLOW_GROUP command, so the
> firmware reported the command as failed even though the device had
> completed it. The host then took its error path, and the bug above
> turned a command failure into a kernel panic.
> 
> That is only the trigger though, not the cause: the host oopses on any
> error returned by CREATE_FLOW_GROUP, no matter where the error comes
> from (a device that rejects the command, a resource shortage, a command
> timeout, ...). A firmware that returns an error for the second
> CREATE_FLOW_GROUP is enough to reproduce it.
> 
> A minimal reproduction is therefore: enable aRFS, and make the second
> CREATE_FLOW_GROUP of one of the aRFS flow tables fail. The kernel
> then calls mlx5e_destroy_flow_table() with ft->num_groups == 1 and
> ft->g == NULL, and dereferences the NULL array.
> 
> 5. The fix
> 
> The patch leaves the free of ft->g to the caller:
> mlx5e_destroy_flow_table() frees ft->g exactly once, and also destroys
> the flow groups that were created. This fixes the NULL pointer
> dereference and the leak, while keeping the double free fixed.
> 
> For the three error paths of arfs_create_groups():
> 
>    ft->g     num_groups  what the caller does
>    --------  ----------  ----------------------------------------
>    NULL      0           kfree(NULL), no group to destroy
>    non-NULL  0           kfree(ft->g), no group to destroy
>    non-NULL  1           destroy the created group, then kfree(ft->g)
> 
> ft->g is therefore freed exactly once in all three cases, so the double
> free that 3c6d5189246f fixed stays fixed.
> 
> The patch also makes the error handling of this function consistent
> with the rest of the driver, e.g. mlx5e_create_l2_table().

Sentence was not dropped.

Doesn't worth a respin.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

