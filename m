Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792690579;
	b=i611RxAID8XlJiwDXPYxpPP7eACZl/PVlJCeh0uA4bFcqWh7fSeN8SdfxRS8g1NMKv5r
	 Fecit2M7xrxH9k/bu/4YzyTphcuQaDIVx/gzX86Dkm4zcyQeNdQ1r9y5N5meBXu8awI4H
	 l4wPnOgYRWV07AMudcxu8YBSyau0MdE+mxa4zFukRZPe7Kw1DmLUJHOwXTGzj1HmGftwR
	 i4kDlS2HgGyHyu6ybfwxOVm2hu4zwWgfEsN/ZoxhCn38hSFJ6jwPEHNKGM1VxSBuOuTJr
	 utwwETQMAVEd06hd6a0vNFAhOBIF6BTquJffa/j9GCg+3kbdrq1Y6lhZOySMFw5RllA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792690579;
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
	bh=ys0ZbqSZjxTcQ8JGafAGIwGRj7KWS9F87pux9gegOGk=;
	b=DqtOs249UcSkY6gUKUpq5uceP0vI+Wq3poXErJ/SXqsKs8KTc60HQ2wZ1fEA9XrCvRKL
	 z2TwWY5pDy1GqJ7pwQ9h8Smed72WzBgjG16afEN/3V7ai7p9bc/7du688Q04rjYCivocg
	 /0obPT3tvS1AQAiQXyTqD7oeDZDRBNh/47MAmUhWapm92QqOIp/d1+W71HZ8RA3rGdkf8
	 Uy/u/rYHi7T6uyGM2zx/ybj+R2qUrcrNOO+IyBF2Mbq9dM26JxpmSurgcAflDmAtt4kHb
	 TNQZG+lIdq97U5/P9GTvMCWjLOnCx1iEOheiMiRwJnVdY+UySSnXt8x2SJJZ5aWkevQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pCHf7NlL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.10
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011010.outbound.protection.outlook.com [52.101.52.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98805606A334;
	Thu, 22 Oct 2026 17:36:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98805606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=pCHf7NlL
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zEAqnfG321FDPuHw1W1lzb5moVcB9gU8Wcn7GBhqqTIvz0c1/6gj0KF52Y26wX4O/8dN+YbRTViAbqNdO13uBgqoPskQKg/Pcc7uQHwiFyUkw0TmX1mXx18LQVV1bQ8Bfg9+54Hlc9EwHSrO5eAZZUllVj6RRowEBJfhG7vmkF2ypLKD18E8Lixg61wnCrV9NZCIVc0Ff1nQOuy158yksdmXKQnLSt3wsmPdvcMGHScPG+t0yW4BfKj4hT8llqHSwbCt6bMwDK9ks9tTulrx3/TuzbjUdJfuKHYlj9PfGlbEmaXPgB7l7S88oLOpPQAz6gba3I1YAyv8roNhVDXbuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ys0ZbqSZjxTcQ8JGafAGIwGRj7KWS9F87pux9gegOGk=;
 b=aSXZwr4w+SgoRpf92mGJJUeiZ+p/JMGXThLNKEdj3nlwcnjz7MCehGb/It/TMvqRL1DFlAgAy/ltOR8FvxLRVYGw+70s8VgbqKxqU1PsW4vUe2QIPSbbjy58Mmh9wYuoAVInASbEvR3DC9++0m8HFIdutelvLbhmWq1B0LtAFzQx14Ore5aEDrmU1nk+cH87ilvusoVxEc1/iiPU3prpLMzrszd2ZITukpTLF4sxc+/2pmcWV7gdbtWmxyhFfUuqGdjwwRcRa3aplzxdWKlMPNDgGgTM7kd2rOikF6Cb80obivTDow0EoQ/EFfalpDdaUdzGkYRvcyqRuBBNjaq9DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ys0ZbqSZjxTcQ8JGafAGIwGRj7KWS9F87pux9gegOGk=;
 b=pCHf7NlLMDA8+bWXcVdyctnLFWedmNIGDLmcusRvHTWdmYUmYb0CpsXDJBdaAdTdccuVTgm4BfmyTjduCzcpk67pY7f69FoqgD6qbqQwY+6BGPcvjk1g4zqDWvGwFEAn/1Xetzk6Eum6Ss8wpxZM49wkk3CdsPAzTfYSPm6Fqqr4GX78S10gYMG3y4qmL/qtz9wDZ/mkzgb/imIN1wf3arjlfmPexr5tpRvxwVar7kgODjLE7d/fPk2oBMV/j6FxRc/3uSGZ+TzKEF95s9WURx8yf/LEXieGp63ffrdn6O2ZHEjuuUzaFUO14QVv58AU4MvzbHaQfaKkvbC4rzT9SA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by PH8PR12MB7328.namprd12.prod.outlook.com
 (2603:10b6:510:214::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 17:36:12 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0546.016; Thu, 22 Oct 2026
 17:36:11 +0000
Message-ID: <66dec41f-a263-444f-b47b-553a63fd4d74@nvidia.com>
Date: Thu, 22 Oct 2026 20:36:06 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net V2] net/mlx5e: SHAMPO: Do not merge PSP packets
To: Daniel Zahka <daniel.zahka@gmail.com>, Tariq Toukan <tariqt@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>
Cc: Boris Pismenny <borisp@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>
References: <20261021062805.3466208-1-tariqt@nvidia.com>
 <DMAG3G194BUB.JJKBBQWZCU5C@gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <DMAG3G194BUB.JJKBBQWZCU5C@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::7) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|PH8PR12MB7328:EE_
X-MS-Office365-Filtering-Correlation-Id: 0976ac73-fe7c-47aa-b587-08df3062f6d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|23010399003|261021123027099003|261022105027099002|56012099006|4143699003|11063799006|261009223027099003|22082099003|10067099003|18002099003|3023799007|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	t9ntS8C2eWUArlLTNLOZGf7U/v6MxWA0kTzQVgf5lcIrLkit/UG+8jQbo0H+SanOlGfQ0VQx+SRis1pCc7ljE8DfHYAd3F5ilcHQuz8W2CqOPbwYNB6DWAHGITcqt1HWosxm+SvZVNjSjruVmkEqjDFCq+HB71Y00QsCGAkYGfSf6qJ3sHzNuqnKz4WEv6zXTgy75UbAtE9Jl4YbN47V2ptM784cKDETRF41vOuwRaKve8Wkw97iU9VMzpYolwGoaQR3RPnT6a0etw2yEQGyIx6uvNL7i1c3Xl7ijykMS3wkz3nmWVk2Yq6m9FJtmkUjWJOkY++PYYK2zGdSOuEyEYAtfOFTWQRg1vZBwkO9rp1Qw84ZUlQK/4DCnzCCm5KZ1IX9mq/TQgSJDNbtZwGJUblvMg+phbDzTqg9zgw2Tr2vRVaLd8UNPi84LccaPLAF/0cIAa7meYrJWNlkHIRUxAUt5E9p0zRLltLmcMlZsjDCleh72Z4FvoYnx8GI9wF856XQgbkWfJvD3gfqDHqWJNkae5s1BjGn2T67n8pOp+amkx0eUs6yD7XRHXo3igNkod6XpjWlJTft90tn6Dp88Jv3xC5qksPJ4Ur1izur8lSWM78scUbVfxlm/gU/voZmMdDsciEmr6D/k/MZ7GMs0LeBtCPkrQDDQ1TAtL2EWGI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(23010399003)(261021123027099003)(261022105027099002)(56012099006)(4143699003)(11063799006)(261009223027099003)(22082099003)(10067099003)(18002099003)(3023799007)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RE43VlY2emRqZnhmUDRwQXNBTks0QmIwVjBQRnc5T1pTU3VMRURPVHA3VTRL?=
 =?utf-8?B?TzFReGNnbXRnQTNMbU0xTSt0MGRkRVpDVEtDZHc4UkxKRlFzbG5IcjVEbzBK?=
 =?utf-8?B?dXQvNWYxL1NsblhIYm0zVEFuUGJuR25EdG01NVpzeUQzblMxS2FpVkc4QjYv?=
 =?utf-8?B?b0o1eVNySFZNd0RNcGd2bHhBL2h0MUFxZjRFY1c5bVF3WkZ3cHp6S3BNeWIz?=
 =?utf-8?B?Vm12Y20zc3dSL1dyRmRIY2RwZkwvZFQ2U2hvOUlPWitMZTN0SmV0YURkenpn?=
 =?utf-8?B?ZWxaTUpqZHpJNnQ1TUZiQk9JUWorY0xQaFEyU2FmcjV3bzRROVUwaUdRMVdi?=
 =?utf-8?B?dUswek1pb0RkUWdWSmtPRVExMGQ2bUUvU3FiUGJ6dDNHTE42SldNMWNBYmI5?=
 =?utf-8?B?MjBpT3J4SkdRcnczTWx1c21YcWNpamNiSnk4NEVQZEJleW1tQlVrb2c4SnlP?=
 =?utf-8?B?NFA4T0ZkSEpXTHBrVjRtKzA0bXVkY25FbFNhSGM2WXpoaE52S0hCSWVublFz?=
 =?utf-8?B?WUdWV2c5QmMzc3dTcDFBZndZRk42UmtXZWZNdjJ4d0F4bmZuU1RoNFlSU01v?=
 =?utf-8?B?S01OTHNuY25aWDNZUHdBOUN1UGxaV29xL0FJanpGcnZYdGlNb0xILzFBRnZW?=
 =?utf-8?B?MUNJTDg2OXhsWjVVY1pNdmcwUllMdVNIeEl2VFdrc3pXZnNjbWR3K2tFSVVk?=
 =?utf-8?B?MmQvV3I1aWJjaUlQbGVWVk80bDM1alRQdGpUaW5LdldsNnlkdUVoNGxVUStu?=
 =?utf-8?B?UVNFd0N0NXA2QTc0VG5EWUJCSjVpVWEySkpHakRnd045RVBkZVFWSVhZL1Nz?=
 =?utf-8?B?NGMrSFhQMUJ2bUNwdXF3enpSSVJTdEFEUEcweW1KS0RmRFhYTGpwdUxuR2kr?=
 =?utf-8?B?WXk4Y1RmYVF0M2c3NXVybzhpbGZpT2JzUDBKbE12ZUJLM1FtUlFBRkJKVUVU?=
 =?utf-8?B?MHoyejl1ZTZQRXJPL1lML2xJazgvemtRd3dzUXlPTkwrbGJadnFhQXJSVnpO?=
 =?utf-8?B?aC8vSkxkUnB5a2lDMFI0RnZuVHhOeVVZSGtpdXh4K1V3T2tNQ2krdXRjbFBE?=
 =?utf-8?B?S2xRUFhBeGkvOWx2VFdhS1BzblJWS2RnbDQ3VnRtWXhHMUVWc29kWDM5OUE5?=
 =?utf-8?B?V0FmN2RzSkJRTGZ4Vm1veStSdjNzdkQwM0pKcWhSUFVCRTBqRC9yck5JMlRV?=
 =?utf-8?B?bCtRNzlhUlhuckw2bzVHcHRyVGFCM0gxNlFwWXA0eXp4RndpaGozaklGYVQv?=
 =?utf-8?B?UFZMYWJmbXB2dVk5VjB4VWMrZFRaWkFwOE5meTdUbkpvNXhodTVVZjl4L0xT?=
 =?utf-8?B?dHhUT0ZnV2VON2VFVnA0OUw2WHN6UjF1QUlYeHJsS2dadDFVRHMzb0FpTnVv?=
 =?utf-8?B?blZGTy9UNTkzVWdUMHFmZWVFTEdMeGFHSlpCeDgrejVVb0xBa2xJQW5iQ1ZK?=
 =?utf-8?B?bUZ4ZWZaT1pLZm5OSVV3eXRGQkw4bXJORkE0T3Fxak5RRW51ZzlFMFphczUr?=
 =?utf-8?B?cnRvUTM3dFZOWnNyVTdzNXk0RkN6N2VJYXd5bzVlYmx0NnlBZHdzS3pscjFj?=
 =?utf-8?B?ZlZPbGFINmhLWTBIL0ZNUllhQjVOeDZobUlRWnFxdTNLMGw5Yk1hMnhCTE5K?=
 =?utf-8?B?cmVkbEQ2RXVUYW5pOHhaUmlzUVZyY3hFZWNicXlVU2dhQlZTL2Jrblh3ZGtw?=
 =?utf-8?B?QUZteEtvNGJ1MUw1SzJqeTZtZEhkVUpCdUFRblM3TkVRTHB3cGlkblc5QXNH?=
 =?utf-8?B?WGJTMElmUENzRFpIc3NNcEovMUFDb2VIMURuSm5wclh2REFiRGZaU1FHZjFT?=
 =?utf-8?B?Q0RvbUYrMUx4RHNQSkRHN1FydVBZanlIUU0yMjdXK2E3SmxKNmxiRVh2WjBL?=
 =?utf-8?B?RTVUb0g4VXhLa2haMjZZNTQxVStWTEQxdHkwcVMxL1ErLzZQTW44MjNuZHdY?=
 =?utf-8?B?TWVzbmZONDhOUk5HUTZ1Z3VnWGgzQXB4VytYeUZBQlVpajRWMW9nL3NRVWQ5?=
 =?utf-8?B?MnIxM0QxZ0JtZnFjcHV1V2JCK3dDbmtpU1JYZkZudHdXYmU1SlNMOEQ4NHkv?=
 =?utf-8?B?YXFHK0RqOFVoWE84b2t5K1NTMmswM0h0a1pKRHcxaUtBN2dsQ054ckVRY2Rk?=
 =?utf-8?B?d1Fzbk0wU1BJanE2WjNnb0pNNTZYdUNNMkc5a3JHTjNwVjhlL1ZSd0tOcDdS?=
 =?utf-8?B?ekFGeFJ4RXI0S0ZDdlNlWVhOZ3VON0NBcWNRbzZ6ZUJsT3Y5VmI1NDFiSVpy?=
 =?utf-8?B?NUpWc3JmakVacDg2VlE5RlQ0RFh0UGZxS0JnemRoNTJCM0svczRoVGxwQ3Zv?=
 =?utf-8?B?cGRGOVYzZXpISThqQUFRSFB5WENMVzNaSXFidXB6YkF0SFdMd2FTQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0976ac73-fe7c-47aa-b587-08df3062f6d6
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 17:36:11.7800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c6acJEZd5XLYvjqwLfvRhtCreuTIfRYZJsy/+GcqVAB0zZ4MshEFYJnF6Nv8ssDAMFIAUjwd+svsdNNmT0Olvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7328



On 21/10/2026 13:30, Daniel Zahka wrote:
> On Wed Oct 21, 2026 at 2:28 AM EDT, Tariq Toukan wrote:
>> From: Cosmin Ratiu <cratiu@nvidia.com>
>>
>> PSP packets are UDP-encapsulated, and enabling HW GRO (SHAMPO in mlx5)
>> makes it possible to merge those packets in a silly way:
>> IP|UDP|PSP1|payload1|PSP2|payload2|...
>>
>> That happens because the HW GRO machinery doesn't know about PSP and
>> considers it part of the UDP payload.
>>
>> Reject merging when the incoming CQE has PSP marker or the pending skb
>> has the PSP extension.
>>
>> Fixes: 29d7f433fcec ("net/mlx5e: Add Rx data path offload")
>> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
>> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>   .../ethernet/mellanox/mlx5/core/en_accel/en_accel.h |  6 ++++++
>>   .../ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h | 13 +++++++++++++
>>   drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     |  6 ++++--
>>   3 files changed, 23 insertions(+), 2 deletions(-)
>>
>> V2:
>> - Separated from the patchset.
>> - Moved the PSP merge check into a helper in psp_rxtx.h, with a stub
>>    returning true when CONFIG_MLX5_EN_PSP is off, and an en_accel.h
>>    wrapper, replacing the #ifdef in en_rx.c.
>> - Also reject merging when the pending skb already has the PSP
>>    extension, not only when the incoming CQE has the PSP marker.
>> - Fixed the commit message diagram and capitalized SHAMPO in the
>>    subject.
>>
>> V1:
>> https://lore.kernel.org/all/20260917175433.4090878-8-tariqt@nvidia.com/
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
>> index 3f212e46fc2f..5a340f1435e6 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
>> @@ -218,6 +218,12 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
>>   #endif
>>   }
>>   
>> +static inline bool
>> +mlx5e_accel_shampo_can_merge(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
>> +{
>> +	return mlx5e_psp_shampo_can_merge(rq->hw_gro_data->skb, cqe);
>> +}
>> +
>>   static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
>>   {
>>   	return mlx5e_ktls_init_rx(priv);
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
>> index 2b080c39cc37..9fd1ee789de0 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/psp_rxtx.h
>> @@ -85,6 +85,13 @@ static inline bool mlx5e_psp_is_rx_flow(struct mlx5_cqe64 *cqe)
>>   	return MLX5_PSP_METADATA_MARKER(be32_to_cpu(cqe->ft_metadata));
>>   }
>>   
>> +static inline bool
>> +mlx5e_psp_shampo_can_merge(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
>> +{
>> +	/* PSP packets cannot be merged. */
>> +	return !skb_ext_exist(skb, SKB_EXT_PSP) && !mlx5e_psp_is_rx_flow(cqe);
>> +}
>> +
>>   bool mlx5e_psp_offload_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
>>   				     struct mlx5_cqe64 *cqe);
>>   #else
>> @@ -110,6 +117,12 @@ static inline bool mlx5e_psp_is_rx_flow(struct mlx5_cqe64 *cqe)
>>   	return false;
>>   }
>>   
>> +static inline bool
>> +mlx5e_psp_shampo_can_merge(struct sk_buff *skb, struct mlx5_cqe64 *cqe)
>> +{
>> +	return true;
>> +}
>> +
>>   static inline bool mlx5e_psp_offload_handle_rx_skb(struct net_device *netdev,
>>   						   struct sk_buff *skb,
>>   						   struct mlx5_cqe64 *cqe)
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
>> index 903af3b3e779..d49f26323b1e 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
>> @@ -49,6 +49,7 @@
>>   #include "en_rep.h"
>>   #include "en/rep/tc.h"
>>   #include "ipoib/ipoib.h"
>> +#include "en_accel/en_accel.h"
>>   #include "en_accel/ipsec.h"
>>   #include "en_accel/macsec.h"
>>   #include "en_accel/psp_rxtx.h"
>> @@ -2268,8 +2269,9 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
>>   	}
>>   
>>   	if (*skb &&
>> -	    !(match && mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt,
>> -							 page_size))) {
>> +	    !(match &&
>> +	      mlx5e_hw_gro_skb_has_enough_space(*skb, data_bcnt, page_size) &&
>> +	      mlx5e_accel_shampo_can_merge(rq, cqe))) {
> 
> nit: we already have the skb from the line above, why go back to the rq
> just to find the same skb again?
> 

Because we have a followup patch to be submitted soon, that adds a check 
for TLS. It needs the RQ, not the SKB.

>>   		match = false;
>>   		mlx5e_shampo_flush_skb(rq, cqe, match);
>>   	}
>>
>> base-commit: b6ef0d965fe8ce0ee4b4dcb58b3511f83003e42d
> 
> Makes sense to me:
> 
> Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>

Thanks for the review.

