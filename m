Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794999618;
	b=PHjeQm8mXhQoA0V4gFKCnVZOLRVXUeEmbEHVU9O/WUzapLB7NlClW2cENZj7ywjEI3Ft
	 I5NC8G+Z6b/dBZmOFWU1tUoia9NrGFWod6NJ+K1+EpI8pWXtcY5lQpBVQVmHX4dRgpEVv
	 sRS/QPc40Mds0nXBEA0f332Hylos+DQxRhzn0ARMbyQouJYjRZz2xw8demxRzLf31KgW/
	 V0K1SS7//fiCWN2NuelhYZGvdd6rJukl54aEqxMJLaf1VvqXbWxkNTqZeLaX/64E8N/Dg
	 fhuqUoBapqCeqhQCMGOGTWe7qsRe6aJH53taAsIrnfdT5+yUDxu/lB+QKl7y51VYy/Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794999618;
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
	bh=33fuK9Dw0oSAEUIrfHONJmeLuGQZ6aIbX69U3Lj72R0=;
	b=uNfGdIYOLCIoX991X2qhn2SN32eYf4+zi8LdJxfLZJ9h8hr9+l5T+EBSoRk/2tGvEXpL
	 KGLH3FZsbRAaUFGhIoD+EY2e3ArbyNHAseuI6E1vgVbL5iI9eGKH1tBVf7BqtRcPTkUOS
	 C9/mUgIm1YknLiB1QIUJMzCoFe6gpJ7JtUXXB/GKeXBk64FEBvYN5Bh508EwgUppjDOft
	 im9eYrabNpzZvPI+ILQvkqtsBfpinKJYsKDNmRVorMH77NpKzqlJPnsYcoovnc4Xs+Ryh
	 0r501u7Lq92xsqBGaJJPLqB0exhLgAQEQpkncULPt3vXrvNl7yTqLzsoXpuBp2hbDUA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="t/zKGOXm";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.66
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010066.outbound.protection.outlook.com [40.93.198.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD7A606A32A;
	Wed, 18 Nov 2026 11:00:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AD7A606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=t/zKGOXm
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qWQFcGm0+hWbLrjrDbn8mG/Yg7WjY326cKO79hGXNZcm2rdfhSRntItugwKoTEoB0qNOdS/+jsMD4zNxNnZ5yZPyK5A1lB2J6lTnlF07wCugwOD+Ww2ZoYW6oKH7Ryt1woq0twD1ECWJwN2j87/HmlJgo2EqX83mquajcso6YFABkIMJWtlPDnv9YgHOW9W3nmvecR98JGCXKvUfHENq7o3tq1jTLu0e7TcK3tisdnUEelSdOboDXWe+aeKGlkXpaZvCQbsw54FUBswIBGqHaHhYe/0B7nwndTUcge1v19AvhH5kyxBrRVxuJKKRC6l1jvkQoLsZyRWberQWitEGuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=33fuK9Dw0oSAEUIrfHONJmeLuGQZ6aIbX69U3Lj72R0=;
 b=ReAF2kR86FHJT3dl2eeKmbE75SIpvJT1LpSxXEyliG0DrJka1NNwHryAqT8FsiFkNC4A3PDDkn+9QIfEfwx/CoUVf6v83TQRSQlE4jxgDRKfo0aFZPA0vWirljBdP7Nxyq/ew57Dqx7wm9hooWMNcQonWOrSUvCvRcgx/LrfVZkZbvS6gKZqKQVE47P4gRiRDKVT+xCm1vwIVs0vnXOCsD94AVXaD768yV3hPnpfTuy93lScv03JITfsmqqxxHXAIeQNlBOpR5/KfIfC8Oc8nChZ63+0Ec7ZLEAsAk3YTM2b+LN7Iz0nOCENKJwcNfoqFIFKrDHY5IV++bbeLquSKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=33fuK9Dw0oSAEUIrfHONJmeLuGQZ6aIbX69U3Lj72R0=;
 b=t/zKGOXmjN/Zjb2/Emr3/rZuWRWbm+qxBA5DhA9pzarArawlW8Ifyj/dJRlP88c9dPo01NDhB0jJ3sUCEupY7QuqyKNqkPbCTGU0qCcidqTPymLr2VFiiJ0FtP55pCNd+CAXJkWe89Tcu2jc7UOTX6ROJm9DWwUCE32cawHE2YXHDOGYzyQ4vyCz3xL0hMZcFRlDm6UhSJm6oy5yTewTHGt1oHGGyTkNf5thQQSGSTmRtPYzjECdTW6tToNR1Y44CrUjSr/tZm1Vu54nEideXqKHCGNgaVWGsxWj61zHoLs4ovqKUEkFNLykvaJhsT8k/pF8H1kJk2u3dtNLgyLYtQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by DS2PR12MB9565.namprd12.prod.outlook.com
 (2603:10b6:8:279::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Wed, 18 Nov
 2026 10:58:12 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 10:58:12 +0000
Message-ID: <7a839cd7-2af9-43b3-ba17-2e9bd5f2f7aa@nvidia.com>
Date: Wed, 18 Nov 2026 12:58:06 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4] net/mlx5e: advertise tcp-data-split support
To: Nimrod Oren <noren@nvidia.com>,
 Dimitri Daskalakis <dimitri.daskalakis1@gmail.com>,
 "David S. Miller" <davem@davemloft.net>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Gal Pressman <gal@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <20261111170558.1654691-1-dimitri.daskalakis1@gmail.com>
 <baf3a990-c9a7-4bf1-a1a7-a2b8976591bc@nvidia.com>
 <cc814750-79f5-4eef-9c9b-e7bda86acc78@gmail.com>
 <aa4a9b49-4f63-48e5-9c96-1cfef109d21d@nvidia.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <aa4a9b49-4f63-48e5-9c96-1cfef109d21d@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0018.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::17) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|DS2PR12MB9565:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f139898-5c25-4eb6-7b3e-08df4562d681
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|18002099003|22082099003|261009223027099003|3023799007|11063799006|4143699003|261102123227099003|261026140227099003|261022105027099003|261026121527099003|261021121427099003|261028144727099003|261021135927099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	MZ7OPywpev/hABTn70qZbzN6ydljEZAXPUt48y3RK1p86P6KsRfwoTNPmY9F4U+9BQTkeGfLaBKSSfv+ChschFhnZM02nXiwCk6Td2x4lZ6sXWNdnshsqFerYkjFuW5IEyy7tdu6h/tqhLNH2vSzcObfOD+846aNqI0cdoIjlFxGUn0K11LL8n5HrAzzkRQx7tgNMb3EGSue6i21M3w7Jl+hq0CGU5PNXdiXomrswSmOgaxXtYAqGff0S5O2ClisXV6uWXeW1cWtmD9SpadA5HKtN714XdcayqbRs04lMq2DFLULbXRXi9WhH5hI2oGj1LOVlzwEpzhadhHCKQyU0LnSsRSB7K4aHDZvRJOGxTG3PZhp3R1RVJ/zI6x6/x27fkRoSdG438XleRmGp3qTb3yjdwtpRCMosfBzD14frl9Rcog0CIAnx8Kzgr6WXofKlCwDTVdC6VRa4nQjjXo+5VjZCJ1ZcGOpzZqQh4sKOZpH17mG4bl83xl7keemiLJq5JBIf4e8wQf2ymCAgDB86VjkhBNI1c6acVrHMxejnx+nZs3JrlH4MY1Ukyw8m+Ja0/JitHRvoVlvYtH2sZsCDOn74cu9lsX5Z5hlWBvRI47qQhP64aq6R5KaOz7E87oKpfkl7CdSj8eKd3H5heZcGCvJ8hggdU0zgQDAMxycDWA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(261009223027099003)(3023799007)(11063799006)(4143699003)(261102123227099003)(261026140227099003)(261022105027099003)(261026121527099003)(261021121427099003)(261028144727099003)(261021135927099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RU9MZjdsem1oL1RheHdtWG9od3o2N3dha0RvWEtvWWZ4anQ0dGlmTFdEWVls?=
 =?utf-8?B?VVhlTnlDelhXclhSUlVVNDhwQmRjY0J2ZVFjdFk0ODVjeUE2VFNYUDMzVXFs?=
 =?utf-8?B?a0NENVN2dWxUbHFvWE0zaDcyQXVoUGordXhsYkljbHNmRkZUa2RUNEVxcDhi?=
 =?utf-8?B?ZGNGN3I0V20rZUNQZVpQSnJ1ODcrOERVOS9ZZStuWitTdUxDTUd1bHZBZ1Av?=
 =?utf-8?B?ZnVEQVU3cW9aZTBrRERza282WG45N2p6cUVGVVdKczd2NEFxc3QweE1LWFFO?=
 =?utf-8?B?emR0dU5UWTZueWQ4WUkwKy9MMVRXVWJFU3hSMnB3eVFPU3RXTEZXNzZqYjhs?=
 =?utf-8?B?VmlKdWNsTkU3Rzc5MFFGd1g1bWxkeU92NmVDVnJnRS9lMjUzKzlMUnZqQ0tY?=
 =?utf-8?B?b3UvYTluVDU1WmdXR2M0VXF6eUNVU1BkVkQvcEhTRG4rQzlLcFh2TE5qTmJB?=
 =?utf-8?B?MnBicDl3N3hzVXZiNGdTUXlnaTlBZmdYd3kwMm9aVzYyQmVMUk9lbzllbkht?=
 =?utf-8?B?TkJJUWRaNjRrNGtRbDRCS1B5UHU3Y2tJcWRFK1BqZ1o3YWJTMVlMa1RJMnhW?=
 =?utf-8?B?ZWo2NGM5emFNV0FQdFJ3M1RLMVRmVU1RMDBkOFlzWXpWN09BSVVKa3RpY01Y?=
 =?utf-8?B?K0RsVi9VTjJzRUpHcnZ2SkJkUTJQWXZ3bDJHdHJNUFhNaHV1QkZ5WTVrb1RC?=
 =?utf-8?B?Zk5kaUJ6SDdScnBFWFQ4YWptSjNqSE12RVBkNWtHbzhvaTdKaWdtbmphbyt3?=
 =?utf-8?B?Z1JBOWZ5SGdYNHRNUW5CUVJwcTVCSEQrdXdmcjd6SDBVdWJnRTFmVHBMQm1P?=
 =?utf-8?B?aTV1c1NBWVJHWks3YTNic1ZLWDM1KzN3Q1FVZkZCaVA4c1JWNUczNVBoQkJs?=
 =?utf-8?B?aGQyS3FOOE9maFN1V2dCUnFPY3A0aFd5R0pyK0s1UXcyc0wxSGRaNU0xY2dm?=
 =?utf-8?B?enozcWJRQ2VLcGtTbHdobTMyT0xpaEsvaEVGS296ekU3Y2xxVGlSYnQ2WUZE?=
 =?utf-8?B?a2xHOVl1TndFNVRGSHh3bUhNSVFnWXVUN1BqVmJyZ0x6ZHpuUTBTb3ZhaE9L?=
 =?utf-8?B?Y0ZZRjY3YmlNLzZLaUsrdkdRMWJzYzFPdkpqUlFUc055cmtwVFhwMUZGODJF?=
 =?utf-8?B?M01mODJ3Q2cvMThPME9tZ2xFUWdUM3BpTTJTU1hKVDhZS2pzWTUxSEFuYXZq?=
 =?utf-8?B?SG9BZ3lGQzB6ZEdYS0QyWmxKT0tSTS84c01VcmF4dmpxUXJ2dFlLeWFGWVZQ?=
 =?utf-8?B?SVNqZEtGdFBiWUR1WUw1YXlzdkFNTXYrbDBYbmpoUWhZTW1NRnNBSTNhMWhK?=
 =?utf-8?B?cWMwa1B1Wko0SW9JTU5lRUw0QXZyL3draXo4QWhML0ZFem4zbkpHSk5CSWZj?=
 =?utf-8?B?bnNIcnh1Rm9leWxqMkI0VmE3NVBYZkk1bEJncFYwZUdvbnRiTWl2Q2JMQlVm?=
 =?utf-8?B?WXhMN2gwUE1Cd0N6ci8yYUVIRVR2QjUyeHVFYWhqNE1MQXpYaCtrbEo1eFN3?=
 =?utf-8?B?TU1hSDZiNE1nSTZ6a0RmUWZyelFNdkFTVk9PR0RYNjI5LzBqdElzQnROK2t6?=
 =?utf-8?B?QTVZZEdENmloMElJRXd0aDFwWDNrZFdINm1RNXFYTFdkT2ovMmdvMVhlaDlE?=
 =?utf-8?B?a1U5MkQ5OVhXK215UnI0SVNiWHJ5WGJsT3N3TEFPc3plMTMzMEJBcDFFcmlQ?=
 =?utf-8?B?RWwramU5NUlWMGdiejRvaXpySGduUFFvSmNudmkzMDd2ZzZQdHRZUHJPZG0w?=
 =?utf-8?B?cXVZWjNhWUU4MjVIbVpDckhDSEVWQ2JYVG80cUk2U2xmYVU4dmg5V2FTT0xR?=
 =?utf-8?B?Um45akRRbVNaL3k5T09uVkNjczY0TDc2ellsQWUwditqVEtBTVo3R3FvQlJZ?=
 =?utf-8?B?NHh6ZDBHejVvYittRFlYV2dVdmtPVFRadDM2SHZQK1VNQWpBWHZLdW55bzJj?=
 =?utf-8?B?dEVNelJUbmZvZk5KZy9IYmZSdTFDeGNDOUhwcGoxR2NWVVdHQkRDUTFrWlFH?=
 =?utf-8?B?ZnQxTHRDbDdDZDBGQnAzMzVtN3lQODBlcUp0NFdsenBPVG9tZXI2d3NLajRE?=
 =?utf-8?B?TXpZZUpZWXZlVE1KSUx6NzZOdmZpbGNxUUMyYUdnVzVwSU85OTYweXNZTWty?=
 =?utf-8?B?UldjaUd6a0haamhHVXhMck8rQ2F4RmFLODNmdXVnYzl5LzA2M2R2UnBPdG01?=
 =?utf-8?B?WWdrR2xUbWdPNVc5K21xU1dpa2ZVTFNtN1dKeGhUR1g5YU02UHE1TENyUnRq?=
 =?utf-8?B?aCtIRk42MlBjdnAzU0x1c2JxRG81OVZmMklLeGZRSmlsZW51R21qNWZBUDBK?=
 =?utf-8?B?amwwdGZtVFYwMjdFdXVnd0Z0dGhDUFdmVm9tWEQ1dmR5MG9NTnJPdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f139898-5c25-4eb6-7b3e-08df4562d681
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 10:58:11.9797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y/gBtp2XO+yqNPDCUW1cF5OBzluFWkoUkcpi2K0LvJ2sWcOetTtekq3m5gBpV80EkJ891eD6w+nkLCcHc5+vwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9565



On 17/11/2026 19:49, Nimrod Oren wrote:
> On 15/11/2026 22:59, Dimitri Daskalakis wrote:
>> On 11/15/26 2:39 AM, Nimrod Oren wrote:
>>> On 11/11/2026 19:05, Dimitri Daskalakis wrote:
>>>> Changes in v4:
>>>> - Nimrod and sashiko pointed out that not reporting DISABLED for
>>>>    tcp-data-split makes the feature look unsupported. This conflicted
>>>>    with my attempt to block users from setting DISABLED, locally sashiko
>>>>    found several scenarios where ring changes would get blocked.
>>>
>>> Can you please share those scenarios?
>>>
>>> I think blocking 'disabled' was the right direction. Allowing it doesn't
>>> give users anything new, only a way to pin HW-GRO off, at the cost of
>>> another dependency between the two knobs in mlx5e_fix_features().
>>>
>>> We can still report 'disabled' when HW-GRO is supported but off.
>>
>> I should have saved the review, I reapplied v3 and added an else to
>> disable tcp-data-split if the merge type is not SHAMPO, here's what sashiko
>> reports.
>>
>>   [Medium]
>>   Does this reject a value that get_ringparam reports?
>>
>>   When HW-GRO is off, mlx5e_ethtool_get_ringparam() reports DISABLED. That
>>   is accurate, because SHAMPO is not in use. Before this patch,
>>   "ethtool -G eth0 tcp-data-split off" was accepted in that state. Now it
>>   fails with -EINVAL whatever the HW-GRO state is.
>>
>>   This affects any netlink client that reads the rings config and writes
>>   the same attributes back. The whole request fails, including any ring
>>   size change sent with it. The changelog does not mention that existing
>>   users of "off" will break.
>>
>>   A narrower fix may be possible. mlx5e_fix_features() could clear
>>   NETIF_F_GRO_HW when hds_config is DISABLED, like it already handles
>>   ENABLED. That would also fix the mis-reporting and keep DISABLED usable.
>>
>> Netlink users that call get then set with the received parameters will
>> get a failure. This generally applies to users who save the current ring state,
>> and try to revert back (via netlink or ethtool). A subsequent sashiko run
>> highlighted the manual use case via ethtool.
>>
>> I recall sashiko had more severe feedback, but those cases may have been
>> from the incorrect feature updates I fixed here [1]. The feedback is technically
>> correct, though I'm not sure how much it matters in practice. v4 implements the
>> narrower fix sashiko suggests, so it works for users who write back stored ring state.
>>
>> [1] https://patchwork.kernel.org/project/netdevbpf/patch/20261017005401.1582755-1-dimitri.daskalakis1@gmail.com/
> 
> Thanks,
> 
> I'm not sure the write-back scenario is worth worrying about. The
> drivers/net selftests for example always restore to 'auto' first rather
> than a saved value, which seems like the safest way to reset this knob.
> 
> Still, there may be some merit to the point that blocking 'disabled'
> would break setting it while HW-GRO is off, which works today, even if
> it's not a very useful flow.
> 
> IMO both approaches are acceptable: v4 as is, or blocking 'disabled' as
> in v3 plus reporting it when HW-GRO is supported but off. You can keep
> my tag if you go with the latter.
> 
> Reviewed-by: Nimrod Oren <noren@nvidia.com>

Acked-by: Tariq Toukan <tariqt@nvidia.com>

