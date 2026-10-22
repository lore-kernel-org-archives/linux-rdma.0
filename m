Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792698098;
	b=s73lzBjY+MuiyfSRlybeAMgAhKsjEg1KkVeOsVOiiFkOf2dVvQc6D7auKtypsf1evw/s
	 w/SPivPnd0wI1nwFo5MV0eezI6X0C2CDgYubgKuXNvjHBEfWYPS6UHaPclnzSmjWyRdZ4
	 h7vywGlyOdOg5YlSaMLDXLJmwLpqpCdL5HSmKYfcZN6v5zyPb2hlnzbr0dTG85IVLfO1G
	 +KW7PmHZv/CXKTqrsbC61zGhY2JD0iN62GAtt3aKi7/lwVWN9xXoYxtLBlV+BuqSlkrZ/
	 VNVH0QrEpv9dv1dPIt+wrFKRJSjKSGLwwEaMFcyvvvJKdPJv3GZyOIleIRjyDzhK92A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792698098;
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
	bh=scIbCWElA8RsEn1+2HFD5Z3D+5ZooEx3e8EiCJ4bNsI=;
	b=qJUtzV1z/MeqQ3RiBSoU93M3h55KuMXYHHpJjZcKcys6My3xhiR8ekdJQggbXbpSCAJk
	 LlSBSWlSCIQ5aWMYa15OR/uvwK/MhBU0cRy9yi1YVtfM4i2HlltwbShM0fTNEvy4qt5ny
	 rXPPdtRweRRjF1jGBYJHkYtTYYdKKVFmjg5mHclHGA2/8MygZlDGB0hwywB1xf9FViorW
	 uoIeQJesD2XTgminxsplw/zRTkIULE8/hlLWYiJ0ToySws91RiJ9q+kMY+kQyj8gcTPLp
	 1Qnzqql+yDkJrygiKjFDB2AiwhU0k4g/aVXhjsTa3yDND8AOUHOQIbNebhGfvZar+WQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LpB1pLF6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.9
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F568606A31F;
	Thu, 22 Oct 2026 19:41:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F568606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LpB1pLF6
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nToY9oI8yKsc9eIvv2AzsQIV609HTI6qS5ZlY7/XoTlkvxtLZdktNPY4DNM6VqJsJ2A9tIi3UehejMgEMVT8rP1LHYF6dSX+olItHW4Bi9Y7AbVW/PWd9D1uiCMqEnlTRpH9QsGdGxiWk1jaSseylmwi86aJVUXW5fep76SsT6WIlls974o+0faLHRxn4G8AMUZjVx4DojOjbXszRSzQaoKUmbKtu0du5z1SXuYHv20Iy/sVBBNRtTqhoB5brVb7JZ/qzdseZUPf93TgEf+l4oWP35En3PH1BEO1zuyYiYN19uEv0xiMKrEDDyBTTlPij3Bt5iM9jGr5Ej5Cqnaudw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=scIbCWElA8RsEn1+2HFD5Z3D+5ZooEx3e8EiCJ4bNsI=;
 b=fAtmQNBIkBtf44tFp6IxZcb7nHqzS6304SkMV3QLPGjMq5LatHRZVeggRJbvErlBaCcYIUTd1L/QC/n+p8M+lKYOn3P1sjwTKX6PNh28Iby6dBKazQzvVNte8hAJoPublIUdq5eaab92EZNK2dSfDppTSM4wcNhgFSqLvp5ljz7i79Zkttoz+116JSC25YBWiGxFKvEB+oLhYnmqPU5aettL1c9kg/VvpzFw9pm/nU394BWcZRPJvWejegCLQkoEXFi+wwcbLOsTI65d7Y0rAsFoS+v5shh3CNg1pk5pQ83vOri+oL/N9S4zgNdFDZQt1Jpr9TWC28sV0owIwIcgnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=scIbCWElA8RsEn1+2HFD5Z3D+5ZooEx3e8EiCJ4bNsI=;
 b=LpB1pLF6KgGSWqZPOyUvx8fG0fYD600dfIQgfCRnmSa4X33+BRkJ1R9exs7Jzl9raA8xGg2CoJlozFT5xGPAJr3I4L8NeRKAv1QpJfvXP0ilGBxqcUa3M0QOWs2JFsZlbiYekKzUbAb/XrW7tNSfM6S1NkfORwDdT+YbLUxMvnnbdhZ9EwQJZ7/Dd0RBs3siybRDOaaIUbPSTySSlli1+3zHwQJaYMKRdpvLrw0YD4MBpc9ltYjfQaeh7pQxaTHGzfStDEB2PiJia2Sd13Cbl1zD7kQk5FGuhhIW3lWb65MPFgRjCHzHcMX2hGQs+7CglRKgscGPikkUW+KKHJ8Anw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by CY1PR12MB9559.namprd12.prod.outlook.com
 (2603:10b6:930:fd::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Thu, 22 Oct
 2026 19:41:33 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0546.016; Thu, 22 Oct 2026
 19:41:32 +0000
Message-ID: <c02ee337-7f09-4515-8b38-f39537e3a8c5@nvidia.com>
Date: Thu, 22 Oct 2026 22:41:20 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] net/mlx5: Use generic power management
To: Vaibhav Gupta <vaibhavgupta40@gmail.com>,
 Bjorn Helgaas <helgaas@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Bjorn Helgaas <bjorn@helgaas.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261017194104.2684-1-vaibhavgupta40@gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261017194104.2684-1-vaibhavgupta40@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0229.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::11) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|CY1PR12MB9559:EE_
X-MS-Office365-Filtering-Correlation-Id: dca775aa-446d-454a-2b88-08df3074795d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|7416014|11063799006|921020|56012099006|10067099003|22082099003|18002099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	ZEoD6WNtojkaZ6jp23vg8YPVnRd6E8SUaWcXtcxqZ6mzgHn1xdG6VI/UjJP6PfcQ4+shmApVWqdsLW4SCVJT9NXw/g1A+O2TDG+cGnidnryUNr7zCAOcBIV85iVrqHTDl2DGmA2MF0RtuWvI9Z1cnfEcgY7K9WgPQ0FWVrSMccKbjpMEQ9DKfTNIwQO9vE+cvKRL37OSJ1wRiBFzEaR0udHZMV34BIc4DV0H7bPksB0ahqsFt4EhRl0r1UlPa7fMI7nLIScRfWlXOMFr+ieKvVqjwdv/CszE14gqmpZ7HdOqhXWs9ir7xtcr6/6+EYsleF21BxK1H7PTI+ZFsidCgJEhxSUwLwUsBlbrXYnMPJBzvVSSAbhikkRL+vf+q4AbcdoqHCgmeoxZvCDZZOxhaa/zfJiU2jT/Tgosgz+Qm3sjLhlEPGx2XGaQs2onKyjc9aAvAtu08s05eeExnn7puCgWKLT/JH4hhtSHVQV8ai8WGJ5YQH4C4JQQkgnBQJUjQyIsrCM/sZNrLgCHeH9aUM6dB2JxYy6dn7fky2kwQwaeqKdOQ1FXgMzmSv9mKJe7aYpA/9fxOjc8OPlQ7kAWVUjLR/P36NY+UMyA/+Tgukcaur1UITg7v30S7Hx5jD7zibfFBCVVAXd8FaeuW7rXQQlnYq6zdD1tb5QqFLkYtzDuRbuEsrRZpODMeRM1SYOQ/PrAetA0aHo9CEWFub5Rog==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(7416014)(11063799006)(921020)(56012099006)(10067099003)(22082099003)(18002099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUFiV0o2WjBXZkIwOFpIdDk0bzBLRlEzZUtFMkpTWWRQdCtNNm1TdWRSZXE5?=
 =?utf-8?B?Szc4UjBWa3BrbXk2Z1FaZ241ME1FbnRkVStsWVlwODhaVUNEY0V3KzVkY2o1?=
 =?utf-8?B?YXpaYzRaekN1ZFN3LzgxejkwbTFleVdDQk9pa3d4SmZHczJqTGk3TFd4dkRX?=
 =?utf-8?B?WlZaNmcyUkVkNXplWDgrTmhFQVFCWmFoOU80TVFLelhFU1FndEcweEtZUFQv?=
 =?utf-8?B?ZmYrY0ozbjdva0FKL0o3Sm1SWlBiV3dlNmNLTEtCMjdHcThYbFBIeVFqbTFT?=
 =?utf-8?B?czlNaHlqMWhXeVFpTSs4YVArdG5FV3kreUlBNXBuZTE4c3hOamJVTUV3d0Fu?=
 =?utf-8?B?TERaUDVjdmdJZ204UzdEMTlYeWhySTJJa1Vpb0lpeFIySUtYM2dORUZhMHJp?=
 =?utf-8?B?bS9tRFgyVTNiVmVXWEg5YjJqWlNsSkFDYjNUTFlSUEZPTlB2eCtPZm9LV2wz?=
 =?utf-8?B?Q2VSTmF5Ykx2TWl6V0pWc3REUEVDZUo5UDRQejZ5N2ZqVVhiR3haRFYyc0ZB?=
 =?utf-8?B?NXlIRnZ0ZkVRK3pta2RUT2JKakpGdkNrYmhKMVRGSGZ4TENtdElFZnVJaVhT?=
 =?utf-8?B?TERRWTR1M3lrMnhIZjJlMVd1dmZTaUhZTkJ5WUIwUUZEWkV3ZGJrSUZJaHpq?=
 =?utf-8?B?aTFJeGxTSkRpOGp1YzA1a2tDQlV2MlJwQ21WNENZTGZ3cE95c0JwbnY2Tlpr?=
 =?utf-8?B?TjNKSVJQcjhRWUNHUXIwdkx2L09XY09kdVBReVJhSDdRT1o3emZHMVpEbXo3?=
 =?utf-8?B?Z2o2UTkrWVF6QXJ5cXBYQ1piTkROWkRMYXJGTGRXZGtHOVh1T3d5UkRPYTBn?=
 =?utf-8?B?M3NMWE84WThISnI5NU5nUVJGdlIwMjlPaEVSZkY4YkNpRytwVkdFV2kzSjkw?=
 =?utf-8?B?eUxVa2dDRUxlSnE1NVY0N0FlWFRsK0s4Vm04OUQ3blI4c3d4Q2tWYUFQV2do?=
 =?utf-8?B?NzNVaXRIV2NzMzVoRkRhWHVRVG0yNm5ZN0VJZ1NpY3pnS04ycFR4Y3REN3BB?=
 =?utf-8?B?QnR6dm1NeGpIZEpka3FOQ0xkWGFiK0liSWNRYWR4SjJtajJqTzdSTHArZU4y?=
 =?utf-8?B?SnNnYUlPdU9xUytkL1U3d1c5RDVpcW1xT2dkOGtxQ0JwYnJoZ2hIOUlZTksy?=
 =?utf-8?B?VmprTGI4aE9tdkZVaC9MRlVHUUNZUjNVSTBLSzdkdmdENS9HT0UyWVVQZVd0?=
 =?utf-8?B?cHhjaE1adWJ2ZmN4WnlkZFNsTW1BWGkzcGh4eGpjc3VBbjFOK2lXSGtaOU1j?=
 =?utf-8?B?aG03aEFvVW9lVnV5akdDWlYyd1BaOFl0OWNUcjdONS85M2U5RitGTWZjYmRr?=
 =?utf-8?B?czhzRnhSRUNSV1ZrbmJvVVVQODA5NEx6TlpISG9qZ3ppaCtROHhxOVFuTkhh?=
 =?utf-8?B?aEZSU3dkaVUrQ1Q1a0Z1bjhrYjRDTkVwTHBqUm1GLzdYMUdlSDNrTkYralNm?=
 =?utf-8?B?bEhKMk1OcGZMaHMrVTMwbFcxTUkyd0JyU3ZSbGpEZGE4WlNqdFMzWXBSVlc4?=
 =?utf-8?B?UU5YQWJJb3krU0tiVjg2bkgyOWhLOVljYnpmbXpuZjArcDB0UVZBY2lsM1lY?=
 =?utf-8?B?Z2hoR0F1Q0tlOWx5eFNZNUNQQTAzbGRMT0d6Mzc2QUNMRGsyTjNKY1M1MEVM?=
 =?utf-8?B?Q3F0MVQvT2Fxd2J3a0trZzBzand4RFpwcE9qenBaZkZqemhsYVVWTVVqa3N0?=
 =?utf-8?B?dWVNMERxVjJ3OWJnNkJsV1JEc05KcW9rbjBORmJsYmxtVmtuQ3EvbDh3VmIw?=
 =?utf-8?B?dnYzcGthQ0h4SHRNR0JNVW9WdVV6aHUwdElXT2c4NlBtaC81N20xTXhVMkZK?=
 =?utf-8?B?TE5SVnFpVUNFOFlOTWFYU204MEhaMUpCcGpucGVBTEFQbWFYWktIYkkxcTFT?=
 =?utf-8?B?ZnBKRmU4SE1BdkhwUXQ3d0k3cnBjVE1YZER2RXI3eEYyVTEycEdrVnZ4RnY1?=
 =?utf-8?B?cS9wd1hkaVRiM2o0ank1UVhYZUNCS0pIZkU1TTArQzVYeUZIVlV1SmxCUC9G?=
 =?utf-8?B?RkIwUlFzUnB2SUZYaXowTFd1bStFeGhJcUUwY2VpSnRseWRwNmMzZ1lRYjNR?=
 =?utf-8?B?M25yRnlEdUszZ3dWdE81QS9tU2NmRU1vQzFFS09mZGNTVmNiN3RVTlFESlAy?=
 =?utf-8?B?N2dhZjQvYlFQRU9keG9NZ1ZpMkpxek9xeWx6VzNQNVJzblVHNVpXNEprZlhF?=
 =?utf-8?B?VGwreDhPak45eW1ZZ3l3bi9ZUDVzM09qR202WWNaK3FybGMrbjBHaDNjcjhq?=
 =?utf-8?B?bytzZjEvQThLMXl6N2hoa3NRalY2Nm1kL2IwZ3BsWFVMTGM0aEFkM2NKQzlL?=
 =?utf-8?B?T2VmQVlEeXVHZlVDWGJZMis0VFE4QzFvQ2FLRkQ1cit4bEtUNDFpQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dca775aa-446d-454a-2b88-08df3074795d
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 19:41:32.1046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OwkyLWpB7BBFSFJnLKtQ2WywkYZhz06iwaI38akaMU7zlbRMUu1L3kmlHGCkW9tohAWVhHXJl+ROuXf0PXNT0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9559



On 17/10/2026 22:41, Vaibhav Gupta wrote:
> Switch to the generic power management and remove the usage of legacy
> (pci_driver) hooks.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Hi,

Thanks for your patch.
We need some more time to review this. Will provide feedback next week.
