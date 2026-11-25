Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.24
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795588044;
	b=M3eXX8/rlLigwPy4J5SWVMEM/v88fGig5Va0eqJpMy68qvbDdU+hxTeUfGMoEsbeSv/S
	 20UKdpaEBPunt2cvhe1MbSRILfbU2m8bgFEX738TWw/r5aasCDBlfmlSHc4E+AQKyzZeu
	 R3t24bmvjCpHxVIOBbOxyrNBo99cTbRoybAp6MzYnz+jS0MlNXG5V82GswqfQcgODtVhT
	 lbRJqlE1j91f8JeYiLEWTHTQoVtZPf9+Q9+YimgLeMWm5WyMk+em0hpBncVnN60yHzlCv
	 X3N+kyOvF7RwmlgKaYbFT/jQZYhPimpsiMjHrX81bj83WbV9xNtLVRgYQivzLL5FweQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795588044;
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
	bh=7NWU+J+3qiytMpbZ+TJPGHTfZ/VwG9hJDctyVh9LLog=;
	b=IYIe2vAQENCLjDNMCDcDubJlhWiyk+fG0ciDMO3tAWcKTdQiqqrqeLZfsykyRbunMNmC
	 LT/bAK+U0WomU4ESV2JnS/JOyeVhTo3NoA+1P0VeAPidroiOPlJIUELuKBxPApHJMD9tx
	 9YNPkZWVVXTV6pgu1tbhugQVJHmLBbtzh8n2PeXnkp4hNmbZMURmBGiZEffmtSvJ9MExd
	 YMscjqkINyVvkM7JGqwTZazu4tRfIpUgLcAF4sim9hJUBXlVOPxY7pJJdLr24d47Kvqxb
	 bgEUQ1hePkhGrelJCstMJElwkNYubBlBlD0xm8+MKDLny/8BgVrFR+5jOTSNHpvmWcA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mhJE9aRT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.24
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012024.outbound.protection.outlook.com [40.107.200.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655B9606A31E;
	Wed, 25 Nov 2026 06:27:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 655B9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mhJE9aRT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n+43B9L4i5PLX/WdiXp+zcKh3aJPmcN/Kh5quXxcWaS2//ts7ZMN1cYeYHr/3QbtfGr1z2cUqnezkaEhPsB2XLskA8nFlL1+Gyx7jZ8kNpA8BtOH/2lFQY0iyXyzIZNDPX4Wh4C1/D4+pieMYYdhdPoL/Lo/99xXLLlAKf3NDy1cOPVs6A1akGiHk3RDyYCN3Xa+Ny+VeP7RUfNMgPM9eQZ8kdR/MO70Hpx6iXWdWZsEm8qPurEmPjnQd+RvEI26PhfG3OiCDqdLpoy+1Et2JxhOSV2kZiHMqIgYdLeJwejxSEmRCA+MnVFAYfxOjdN13AuRGQsyvKfpnkoBaseMvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7NWU+J+3qiytMpbZ+TJPGHTfZ/VwG9hJDctyVh9LLog=;
 b=QvoNzDVGLQx98+j9iQkoHGYEhwYswLnNcCuWRAZV6b7cR93UnWn25MFn6pdmbkNK1k/jnQZcqMcuOF8air5zHYfKJS6LxbAS9nqYR0Leu9D9AJnDClmD8J6mNDZu9w//AvgXc0a56Op1B2QxLh4s1ubpQb55pcVQ9Z2g5xBuoB/Cody5tVjuv9jgxPSlqFksm6ajnXktAgGkZOCpEBZ6rmrjS7O3LFEfPW3vRX6Si1SJ0rqcq90zI8NjxyAM7DoO0WkmrSK9pv1YzxYWOnxYeAzDvDE6/W2NqpWkwVJpNt8z2bc+GOTjU8eA7YsuUakFfQ7Ku1/ilehgmcpgzmh7mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7NWU+J+3qiytMpbZ+TJPGHTfZ/VwG9hJDctyVh9LLog=;
 b=mhJE9aRTS6z41g+9Ny62kqrXH2MqT+EAjj95kMAblUiVKkrEXRhNiyr2tLEpfc2yWLYIuXfQJwufDmWyEmzw1Hqa0TKDhf9j+fCQyfxg+vBDoQm0zv1OoiihkDmAsS/kCMq+FBO7u2cAIqF6c50VKmHk+JRj3mvQjIW4Uo++2S9YtzM7MlvIlfSUprE3tNVM1f2EDYvxSDh5FWO1/KRcyInG3ng3fMtmVIqgpRR0DoynmlrlsLs/vKBPg38yzEzJ+0RFkkmPaOt+P+kdO1j9gI8e1RDIT4M89tSfmrHnhBlhJ0ByK2tyBV0ZJWlObMpj3HfXIChf3cJSbOfxah4l3w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by BY5PR12MB4033.namprd12.prod.outlook.com
 (2603:10b6:a03:213::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.5; Wed, 25 Nov
 2026 06:27:18 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0639.012; Wed, 25 Nov 2026
 06:27:18 +0000
Message-ID: <030911e3-da84-4136-911b-129646f3633a@nvidia.com>
Date: Wed, 25 Nov 2026 08:27:16 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2] net/mlx5e: TX, Do not open a multi-packet WQE
 for a single packet
To: Dragos Tatulea <dtatulea@nvidia.com>,
 Xuanqiang Luo <xuanqiang.luo@linux.dev>, netdev@vger.kernel.org,
 tariqt@nvidia.com
Cc: saeedm@nvidia.com, leon@kernel.org, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Xuanqiang Luo <luoxuanqiang@kylinos.cn>
References: <20261123090200.1284018-1-xuanqiang.luo@linux.dev>
 <3f89c58c-ad70-4d20-86a3-4ba3ac8a2689@nvidia.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <3f89c58c-ad70-4d20-86a3-4ba3ac8a2689@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0030.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::16) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|BY5PR12MB4033:EE_
X-MS-Office365-Filtering-Correlation-Id: ed8958de-c056-454a-9481-08df4abd27a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|261022105027099003|261026121527099003|10067099003|261026140227099003|261022075727099003|261028144727099003|261021123027099003|261102123227099003|261021121427099003|261021135927099003|261009223027099003|3023799007|18002099003|22082099003|56012099006|11063799006|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info:
	S3rIpKgkns1+FvpIG1Yw7fH5Et4CoYnQG2khPwGbo6EFALSnZqotxvV8XYy668jndZoLOvhXKXJSTL1XpBOS8WJT2uWqXvu9WLTY7xGbN/a8qM4t8uBDOgexeJKaSMaeRI/iHC0SUJOsAyvDEJgo6L0ACWwI7b2nFt4Y/CVXKMcy4yLh/6PZ2QGnmIO6LhhZWtYJ+An+OQAxeehyLXm6Ys3rNfoKR9HHwGxjgYLzndyeVLW7SQzP9IjB6+0pNkN7vdwyDVEmLrpzazhdN5h0AAIxncjyvKk4jZqVFUKUbCThxfg3aWNs5u9TyNcthpJF7EFUxtS5LUQ5aoakMastZFvYRNmTyA+t+x3jGovNfnqrTIVfqzMLso6doI2zS/wrH2Gfj7RhVesOoUA1rLYaL1kSLlOluSDB2cEN/mSX75r9Rj7YeUfwuMuPNnkR9cvqtzdd1TjIS4GS1e9C+0+vPRWpTIa5mGisyPfuEJd+UgjRAF0ffaTihUv1f55Sr/3leTkpog8BgbGKBNHFX+fd5DANMokWjcyEyJcTr+s8sGjR4rs4TQ359oC0QEXFla6fbrcpZzcx3iNVjWvcIkkhb7hMIVUDgikXaPUuVgtQ6U5XL0Vu4vBKEEftl2usM4BevId4gww/l5fkuWqVXMCWJsKhe4mflmAYByaCpPmZInM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(261022105027099003)(261026121527099003)(10067099003)(261026140227099003)(261022075727099003)(261028144727099003)(261021123027099003)(261102123227099003)(261021121427099003)(261021135927099003)(261009223027099003)(3023799007)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cU5Ic2t4QmVzREdOZVdxaWJuSnJHbjV0dXIyek1YbmYxWUtSanVGRmxPRzR0?=
 =?utf-8?B?L2ErZ2EvaWw0QmVqVmsvMVJxYmlMS0xUZHliN1R3WDZqYWNKNzRLRXVKVVVn?=
 =?utf-8?B?TnlrQW9aWEtEQnpTSnBsU1BFM2ZEbGRsamRGVDlBTWFybEpnSExzWklZcWI0?=
 =?utf-8?B?L2lienZSTWRGSG5YZ3Rya0w5WGoyb0VUMDRzeDg1eXhRNzdJV0FtNkxGSE5M?=
 =?utf-8?B?MmVmS3FWQnAydC8vSkhlQmVjcGE3TkQwdkx3OGhjWkFXUnExQUlJbHFZM0NM?=
 =?utf-8?B?ZDdWb3NmNHMrYUc5VjlXV1V3dlVLaVRFUFNGamNSWFB6WGN6ZTJEZTd3SUpU?=
 =?utf-8?B?MUMzOUVsZXE2SkQ4b21LaWFXZzRMUmZ3NkhDNU1wbXRVY2lMTGgrWTFxS0ZX?=
 =?utf-8?B?SldKTjBOVW5TVE5OV3JKaGNyZjZjSUc2Z3NvSHJlbkIzS3dOdW1LMEVMSDdt?=
 =?utf-8?B?RUxTd21KWWtXWVNWbzVwanZSSVRLSkZmQmEvcnQ1RGVNc2EzU0s3Z01mR2pJ?=
 =?utf-8?B?NW9wR2wyUnJnMFNRMWpvVFdtcWxpVW9kUTlqcGxuVFFqTFFBbUFsTXMwc21z?=
 =?utf-8?B?dE9XMjVPazJ5dk0rRHdCK0JmRWY3NEVhcWFpOS9VUzZwT3hMOXMyZFhEcktI?=
 =?utf-8?B?T0FNZStSdXE2bURtckNhSjJrdnZ0a09SRFk1S2ljU0JTaVV3Q2lCdStoMW5J?=
 =?utf-8?B?SE9VOFNPOG9BNVc4Z3QzT1c3RVRJbGZ6Q1JEOXpQNWhYN1g2MWt0d3gvekJm?=
 =?utf-8?B?SnJ3M3NoTW1vMktmckZkbHZXTmhhUHRvbHdtZ3NkYmtWTS80NTNpRC9iNzRz?=
 =?utf-8?B?YTVCOUgrZDZlWFFVY0gxcVFYejB6WUdCbXluMlJ2YXJOSEx6bGhrVlZ5R1hQ?=
 =?utf-8?B?dGVtaFhMWkovSjdPRXZsZ3NUSW5UMjN6RHBuTGxuZTh4bkJacEhrQlowZitZ?=
 =?utf-8?B?ZDJCS3RrY2h1b0MrWFhFZzlyQTROK3ZXWFZVaUJTamh5VlhFeHFIdEtHa2hz?=
 =?utf-8?B?bXMvcmJ0LzY1eG9sYm5KMW53Q2NLNjJiVTJ4dzZnbHNRUjVXL0ZwbFJ6TUkw?=
 =?utf-8?B?ODhFWkQwOXZpQnp3cXFmUjBYeWhMWitPeXVCaEhzeXQyeUljTFM5RUNnWkow?=
 =?utf-8?B?SEVnSzltdjAzWFhDMEUvcjRDOUh3Y3B4NWU0WitBNUg2bkZvVzQrOXNCK0pC?=
 =?utf-8?B?c013RW9yMi8rbklyQys5cjZuMk5PbzZZNlgvYUx5cUR1V0xrOEFmSnV3RUFu?=
 =?utf-8?B?RkdqWE9SQ1EweDEycytXenFQRkMwazBpOXEyS0hPRGNRbDFpOFJtMTBmalJW?=
 =?utf-8?B?NkwzVlpZeGF1VVp0UEFmMWYvTTBOOCszRTFCM2taRk1tdEFQTXJ0aThyTDg2?=
 =?utf-8?B?OEFkK0tmYks2bGxLTXNFeHYvdjJSVFJ5aStyUmFxb2NLeFNuenR4Z0J6Mm1o?=
 =?utf-8?B?L2dwd3FJNlErdVBiQ2ZSMStDUnhLTkwyNEZsVWl6MFB1M2xHaHRJdzhNY2Vj?=
 =?utf-8?B?WHJJYnpjQ3ZUOVlZL2FQNVZpYlkvWU96eEViWGxuRVpnUEI0WjJWWkZIK2k3?=
 =?utf-8?B?YjFyZ2gzaFVsOTZNVFUwUkEvU3M4c1BueFNqTFNPRGJDWnZ4TW5RWWsrc3k2?=
 =?utf-8?B?bG1paG5RcUliMVpqbHo2QUhINmhJckdQaUVMUUx5MU1MK3puN05jb1VYa3l6?=
 =?utf-8?B?ZkJUcTBwQUlCRnB5UkxKd2hiS2VsR1k1dnBqOVo4S1Z3dUt6TFlTWXpaN2ll?=
 =?utf-8?B?QkIvQ2pNWkRvU3JFMHg1ek1WTHVRSEJKeS83YU05UXhVQVBhb3NYUy9KUU50?=
 =?utf-8?B?azljcU9iNkxJZmdpYlZhakFKdXBVdjM5QkNPUEd6T012ZDZHMk5JNlJNYlpM?=
 =?utf-8?B?ZzBVVzNnVUJYbFZlV1plRGNLd2wydTc2MTA2L0h3dHNQaktlTHBCYUdLSXRV?=
 =?utf-8?B?N1NOeWJqSjBmajkvUkROZW43SmdQdUp5TWVaRGRkWGRMcTQ2ejhic3N3YldJ?=
 =?utf-8?B?bkx4NTlxcERHVkRSQjNIM0lZY0FCSzdsTE9ESi92TWRabWZVK2JsenZNWjN4?=
 =?utf-8?B?QitBWXYyYUlVUkErajFleVFKKy9HamJ1eGtRWXk3OWpzaHhpWTlmRTJ0SnVo?=
 =?utf-8?B?VW5LUUs4R2t0aTB3UEVEbmdaU1JCcW82MEsrdk02Zm93SUlaTzlvY0dxM254?=
 =?utf-8?B?eW9SSTZhNWRLOXlaR3NjU253WGY3aCtwY3V4MHBjQ1pQZ25jRVNncDh2Z3oz?=
 =?utf-8?B?dUxWYzRlL2hkUkZNb09Yc002cGIyMEVjS285Y1ZUd3ZkN1cvZFFPVzdyUmQ1?=
 =?utf-8?B?L1lpaGxRR1dsWWx4dmpNQ0Y3ZFFqSkRHOFErN1YrNjY5N0dVUWxIdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed8958de-c056-454a-9481-08df4abd27a2
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 06:27:18.6251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wfKMX6ao3YaCu/JAA6/fEaXDFdxeSxdsI4kovMi1irA8WIc+w1CTdMxwT9HTbAiVXCvQ4CUvlZDaRUlbCq1JdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4033



On 23/11/2026 21:19, Dragos Tatulea wrote:
> On 23.11.26 10:02, Xuanqiang Luo wrote:
>> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>>
>> A multi-packet WQE (MPWQE, added by commit 5af75c747e2a ("net/mlx5e:
>> Enhanced TX MPWQE for SKBs")) lets several packets share one WQE, so the
>> control and Ethernet segments are fetched by the device once per batch
>> instead of once per packet. This saves PCIe bandwidth and CPU cycles, but
>> only if the WQE carries more than one packet.
>>
>> With skb_tx_mpwqe enabled, which is the default, mlx5e_xmit() sends every
>> skb accepted by mlx5e_tx_skb_supports_mpwqe() through an MPWQE session.
>> A session stays open between two calls only while the stack sets
>> xmit_more. A packet without xmit_more closes the session and rings the
>> doorbell. Hence a packet that comes without xmit_more while no session is
>> open opens a session just for itself and closes it right away. Such a WQE
>> takes one WQEBB, as a regular WQE does for the same packet, and the
>> doorbell is rung for each packet either way, so nothing is saved.
>>
>> This is the case for the IP fragments of a large UDP datagram and for
>> UDP request/response traffic, which reach the driver one packet at a
>> time. With pktgen and burst 1 every MPWQE carries one packet (mpwqe_blks
>> equals mpwqe_pkts, xmit_more is 0) and the packet rate is 15% lower than
>> with skb_tx_mpwqe turned off.
>>
>> Use the regular WQE path for a packet that has no xmit_more and no open
>> session. Packets with xmit_more still open and extend a session, and the
>> last packet of a batch still closes it, so batching is unchanged.
>>
>> The only visible change besides the performance is in the statistics:
>> tx*_mpwqe_blks and tx*_mpwqe_pkts no longer count a packet sent alone.
>> Such a packet is counted in tx*_packets, as any packet sent with a
>> regular WQE.
>>
> I don't think that this paragraph is needed. Not worth a respin.
> 
>> netperf and pktgen between two 10G ConnectX-5 hosts, 2-socket Hygon
>> C86-4G 7490 sender on net-next, the patch switched at run time by a
>> temporary module parameter (not part of this patch) so that before and
>> after run in the same boot, mean of 3 boots x 2 rounds. "far" is a sender
>> on the other socket than the NIC, "near" one on the NIC NUMA node:
>>
>>    test                                 before    after   change
>>    UDP_STREAM 65507, far, Mbps            3255     3815   +17.2%
>>    UDP_STREAM 65507, near, Mbps           5619     5870    +4.5%
>>    UDP_RR 1 B, far, trans/s              57667    60688    +5.2%
>>    UDP_RR 1 B, near, trans/s             70538    71230    +1.0%
>>    TCP_RR 1 B, far, trans/s              56822    57124    +0.5%
>>    TCP_RR 1 B, near, trans/s             70048    70011    -0.1%
>>    pktgen 64 B burst 1, kpps              1487     1748   +17.5%
>>    pktgen 64 B burst 16, kpps             3192     3194    +0.1%
>>
> I didn't have a setup with 2 NUMAs at hand. But on a CX7 system with
> Intel Xeon Platinum 8380 I measured the near results:
> 
>      test                                 before    after   change
>      UDP_STREAM 65507, Mbps                19755    20455    +3.5%
>      UDP_STREAM 64, Mbps                     496      496    +0.1%
>      UDP_RR 1 B, trans/s                   56317    56386    +0.1%
>      TCP_RR 1 B, trans/s                   54084    54229    +0.3%
>      pktgen 64 B burst 1, kpps              3014     3112    +3.3%
>      pktgen 64 B burst 16, kpps            12530    12420    -0.9%
> 
> And the 16 packet burst is also a bit noisy so the degradation
> is less.
> 
>> Batches do not regress: with burst 16, which uses xmit_more, the rate is
>> unchanged. TCP_RR does not change beyond the noise, its skbs carry the
>> data in page fragments and cannot use MPWQE.
>>
>> The price is that the regular path runs a little more code for a packet
>> than a single packet MPWQE does (mlx5e_sq_calc_wqe_attr(),
>> mlx5e_accel_tx_finish()): the instructions per byte of UDP_STREAM 65507
>> go up by 0.3-0.4%, which the gains above outweigh.
>>
>> Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
>> ---
>> Changes:
>> v2:
>>    - Check xmit_more and the open session first, so that a lone packet
>>      skips the skb checks. (Suggested by Tariq.)
>>    - Run the tests again with the new code and add netperf results to the
>>      commit message. (Suggested by Tariq.)
>>    - Rebase onto the latest net-next/main.
>>
>> v1: https://lore.kernel.org/all/20261117085036.3138779-1-xuanqiang.luo@linux.dev/
>>
>>   drivers/net/ethernet/mellanox/mlx5/core/en_tx.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>> index 14479da98f42..5b5651c14750 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>> @@ -646,6 +646,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
>>   {
>>   	struct mlx5e_priv *priv = netdev_priv(dev);
>>   	struct mlx5e_accel_tx_state accel = {};
>> +	bool xmit_more = netdev_xmit_more();
>>   	struct mlx5e_tx_wqe_attr wqe_attr;
>>   	struct mlx5e_tx_attr attr;
>>   	struct mlx5e_tx_wqe *wqe;
>> @@ -678,11 +679,13 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
>>   	mlx5e_sq_xmit_prepare(sq, skb, &accel, &attr);
>>   
>>   	if (test_bit(MLX5E_SQ_STATE_MPWQE, &sq->state)) {
>> -		if (mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
>> +		/* An MPWQE for a lone packet saves nothing, use a regular WQE. */
>> +		if ((xmit_more || mlx5e_tx_mpwqe_session_is_active(sq)) &&
>> +		    mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
>>   			struct mlx5_wqe_eth_seg eseg = {};
>>   
>>   			mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &eseg, attr.ihs);
>> -			mlx5e_sq_xmit_mpwqe(sq, skb, &eseg, netdev_xmit_more());
>> +			mlx5e_sq_xmit_mpwqe(sq, skb, &eseg, xmit_more);
>>   			return NETDEV_TX_OK;
>>   		}
>>   
>> @@ -697,7 +700,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev)
>>   	mlx5e_accel_tx_finish(sq, wqe, &accel,
>>   			      (struct mlx5_wqe_inline_seg *)(wqe->data + wqe_attr.ds_cnt_inl));
>>   	mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &wqe->eth, attr.ihs);
>> -	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, netdev_xmit_more());
>> +	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, xmit_more);
>>   
>>   	return NETDEV_TX_OK;
>>   }
> 
> The change makes sense to me:
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> 
> Thanks for your patch!
> Dragos

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.
