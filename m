Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.29
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794650065;
	b=eo0kuxiALY3tDY6pKzPzo2uA9KozDIMnDezPVnw9fIf45NAhaGn5uc/yATCPYBEZBInf
	 7tEHvogVTzP3GclVv0bNYGJ106yvyJ2RkZUkw+zWv1iwVjsiSt/5mztra0685lRjOe3rj
	 w+nI0JFL8k7ItZ4kieT0NvKK9f0n1reB6jxcmwuzq/JzdTo0oTiSb716DUDRYRSp3wDNX
	 ed6WpLnrXAC4lXEo/krDjZ12Np9xfBSgNdGjHiaQ6phaTADuw+Ewz4A8/vKh1ALNBfCme
	 5a78gT9Emfe9p825p0AiZhqKossve8ey43TthzZOSTDxlbLqIhuCnWl6nBsxh9xpfjA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794650065;
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
	bh=38ZQTxfKQ5kRv0ZrqbPEVD7lZCKftZ471Tj80sbWrXk=;
	b=d35zdet6//emJqsOevl1f307hWDCJu9n3ieblj2cZVBGXT47S8FQpmLvym1cgono1jhc
	 D3cX6cdZyc7Lcsp0zmwIXLUiy7/DJXoupy3S/y8y2kItnfwECq0qUMHmJKTgCyKpcFI+2
	 m1CfAcIH0s8awqUWDpRtH/6p3LCVh2/rfgtWm/j9QL98rGsGXllJa6LLj6iCllXtkiN34
	 9stYkxr+nMEDLwGVmV1E7vkjTPat8OyDM+0BVc8nmQxQu2t1u6f1YNN4bCI5/RRG+CIbX
	 jImawysPa/fT0kp+n8ySX4XPopqnTs9W1l5kcUfjRjIY4U3hBfylGS5v6rqD3VXNqLA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CvifQxZP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.29
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010029.outbound.protection.outlook.com [52.101.46.29])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71526606A32D;
	Sat, 14 Nov 2026 09:54:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71526606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=CvifQxZP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JkNwc81PQIvMAeypLB1fKiLBQb6p7LYPon8T3dpLP97VEvBA0S5Y/S/NoYFyFczi6lAFeDEoW+ahbM8WK8rzamO5PspjEKRBclzoMCjRwheH7WHXxqMd26WG4mTAgB8v1e4SAJRRVnX3iRDJ2T3OSlVtrVBRqfuJdWOK+awVV8fBRFxVjfsugMSi4hjavjC1nPDlckgHlLR8L8OwBULwlK21gRUohrS+r1zNvbuBvrZ7toE/EhaX6IuAUkbKfJzNiOwaeKn4KXS/n5s8jl85euMlbWRaPxe6XjtE3SXzxhi7ncOMBK1X6UV5kx/obRP5diqV1IauXqVlGqVAQk+rgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38ZQTxfKQ5kRv0ZrqbPEVD7lZCKftZ471Tj80sbWrXk=;
 b=vexxbO/uU2A+AMsOdMNV7gTPKiYiWzof5I3DGPI9LTDKM7cvjU0AAy7NcNoQ3O9iTni5JLd4N0MeHiazduWOByktOqw7ypJ3PpW8bDcR7w6jiIHbAHJyWBAJb02tiaNQdhc6MhELCqjUmUzMCKrM9gUbec6W3bkeXjLBXS3f1cF1l42OaX0nckpg8t70n9sl468ci89N3CRF0O2h1lXGL+1tXL9uhlTwizgi3A3UeV4TV8zHT/L1UscFTDc7NfZoJP1kvlKKCKDxZdgXhfAz/c35JkvTAPFVSiWAFhBTQ3Hea40xXsJb9gL6tUFtF0avxETRiDwq71yq5grxYxCxqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38ZQTxfKQ5kRv0ZrqbPEVD7lZCKftZ471Tj80sbWrXk=;
 b=CvifQxZPpZCj7saJZA+XQEENuPOG5kWRiYka+UF9dYsgeAfRXWPEB1F6WparvybVj5zVAeyIPWUhZxcrgxOFkdHd9pHceyfCpwc+iqBQX/makfzQ1ukInlRd40bKaFcRaa88s8OKmHma8TLonW6x+DN5tozK0X8+c4wMxa42sX87EiyqWK6q+uWyTR+kC4WVks5xW4FTa12FHEwxFHGKFOTk2xr0fnY+WIAbfWuHKUnBEKDXrl8ZWRPhDawijviTmDLuIoEH8wBnX0rMD6DK8J2Iv+i9AEDO9enPxVqnlMXEpFZfgBkD45lGZHcxFBngMvrRzPa/IDRmR/mYeXEpBA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by CYYPR12MB8730.namprd12.prod.outlook.com
 (2603:10b6:930:c1::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Sat, 14 Nov
 2026 09:54:22 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0615.009; Sat, 14 Nov 2026
 09:54:22 +0000
Message-ID: <318f00d0-e635-4be9-b40a-aa84ae713085@nvidia.com>
Date: Sat, 14 Nov 2026 11:54:12 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 12/13] net/mlx5e: Disable data direct on data
 direct device unbind
To: netdev-bot+sashiko@kernel.org, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 bobbyeshleman@meta.com, cjubran@nvidia.com, cratiu@nvidia.com,
 daniel@iogearbox.net, dw@davidwei.uk, erfansh@meta.com, gal@nvidia.com,
 Jacob.e.keller@intel.com, kaifengw@google.com, leon@kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, mbloch@nvidia.com,
 mfleming@cloudflare.com, almasrymina@google.com, razor@blackwall.org,
 saeedm@nvidia.com, horms@kernel.org, sdf@fomichev.me, sdf.kernel@gmail.com,
 witu@nvidia.com
References: <20261110183826.2927274-13-tariqt@nvidia.com>
 <179447641740.2199510.285792504757822678@kernel.org>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <179447641740.2199510.285792504757822678@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MM0P280CA0074.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::28) To CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22)
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|CYYPR12MB8730:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b1e3486-eb8f-4b6a-0e42-08df4235420b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|7416014|18002099003|22082099003|10067099003|4143699003|261026140227099003|261021135927099003|261102123227099003|261009223027099003|261026121527099003|5023799004|11063799006|261021121427099003|261022105027099003|261028144727099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	HM+J8bGK09MCahAjH7309EljzVaH9qA+1rLhORch7zWefpEO9O05oLWPzNkAVwtD9463DUKTWCrPhSSlOMheDDUf+OPxOxOSw0gWWToOaAHSR258tR1elcKBvPmn6NFmraza1Sim2TsAI4HGNbb/F/MN/Vz0MRlKZtn5Mkm0TzaXC1y1X3eVB7MV4Z3zVeF54v/dSLvCw+3+wtsFnuTyk+9qI6rhfE0UFKpvbzx6BTXFHyXa6P8ZnWLqbgxbNTw5TOH39ViK5VsJlzVjIyuoa6zq401xYwVcEy5bAb3vOcK1zbzXKlG8qT5tw2dtoEfgoxFyxnJA6Hy9OivaEc4fxj8dRdo+kgGJtIr0sPsOAHaIT9usjHcZgwDOrQbNsChg31hYyP+0mv55oPaRreluslLkNYU/KSfkmRYWhtfch7LA/12auzrc6n+oXXhg1bhlvvtfTZwYQGhHpTjh5Yc5g6czeK0sHbZdSrcrXKXkaw/e1eJrcCewVzYQRBM6j28R/OG8NWM6R5Bn3xLRSyqdFfMaPOPptIb0FZi5brcRs3YWBwEBms+8Nc93JfgyyCPE13BRaWhl2t1BvaHxOVAK9E4QyDo9NDpSo2n+T2Zg4lvVR5rCwlsXUCvjwF3tbIfq1C8l1HodeUhCnDLxYToScsxUcMP4qMrxWZzdHrkwrrw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(7416014)(18002099003)(22082099003)(10067099003)(4143699003)(261026140227099003)(261021135927099003)(261102123227099003)(261009223027099003)(261026121527099003)(5023799004)(11063799006)(261021121427099003)(261022105027099003)(261028144727099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wk5kblRmdEo5NzNLVklTTWxYMHBkYjV1SFFKb1Bvcm5nRXVFdnlEbDdsaVdh?=
 =?utf-8?B?VTJpVm5pWVk1Y3BvdkI3VjllcGpsaDkvRFF3aC83S29hRjAyeUJwVDRJNWhy?=
 =?utf-8?B?U25pSG1WcXB4WWQ0WGFEdTNSbEt1RTk0TWxKUlJxVWZNYXFSczRQK0Jxd3Zv?=
 =?utf-8?B?SUkwT2F4ME9Qd1h3Mm4wcWNZbk5yQ1BUU0NrZmlYWFdwcUZQL3FtbVlXY1c5?=
 =?utf-8?B?QThFRkJDMHpVUnlZMEZFL1lVQWdtRUx1dVpqaElLRVpqc2x4eGQ3V0VtbC9V?=
 =?utf-8?B?dld0eDBiK0pOTVRXd2NXV3dvNnhqOFFoeGQvcVd5S3UvbzdqVkEwZDVjVUtq?=
 =?utf-8?B?Zm43dDlZUFZkRjJBZ1NKV3pjZlk3MGlpZDBsdjJCbnFMTFpQMVJNVmErODRa?=
 =?utf-8?B?U2FBZCtQSGlmL2ttTEN1czNGenhQUWVSK2ZuYk9GWmJHYlFrbGE2VVR4WjVm?=
 =?utf-8?B?blA0TmtBcmgwWC8rYTEwOHh1eWMyOXlpTkt4cFRnWU9ydGYvMVkrRzFqUW9C?=
 =?utf-8?B?UTBnaGprWHRzVnhzU3djYUtqeVU1bnFEeDAxU2xsNEUxTlRuWksrUGltbi9O?=
 =?utf-8?B?cFpmeFlzZDk2eVQrWUxVOUVTRmMvUVdOK2lTTi9qT0xnV2tHTU5INURDb2J4?=
 =?utf-8?B?YmRGQzdZZE84RTJwTFF2U0hjZktiMnc5dUtYMEFiMEFnWVUzMXVJcGpIdjAz?=
 =?utf-8?B?REVkSU9JNDRoVk5mQzNzNEhnTGlPcGZhT3N3VkVSRkZJcTJKMmsrdWJycGNO?=
 =?utf-8?B?NWNoZUQ5bUJHVTNqZlg4QjJ3eXQ3b1p4Ukw5bjM4NEJqcjBhZFA3c2pkcU9k?=
 =?utf-8?B?TkV1WlN2RjBtZ1lOOENCdWpROFpSeTRtOFFNV29sM1Jqc3RRUGdHMjY4cUtC?=
 =?utf-8?B?SnM4RW45ZXhTYm5kS1ducnJLYk1mM1FCZENPMWV4endnMzBjK0JJU0w2d1Jy?=
 =?utf-8?B?VWtwdVN0QmZZKzZqd2o3YzZLL09kUUN3czM0VUt0ZWJFbnhHd20rT20vVEw1?=
 =?utf-8?B?UjdJcmtvT2JpVkU3OGFkWkVoUWttRGo4eW5iY2cyQ0Z2RkwwYUI1VGZscndP?=
 =?utf-8?B?MGRNalFUWnZBanVrU3VMT2w3ZFpFWEplVTB6dkd3Rjc1V0FiYzgyVkJXaS92?=
 =?utf-8?B?aS9GbVAwNHRMRFQyUUNZbHd0b2NLbXFGZlRkTFBxdGJGRjNiZUhiRE5VQmdM?=
 =?utf-8?B?QkVJcnZwMGlVYnRNRnRyQisxN2E0aEUyT0FWemZuOGxjVXRXVW9CUGpPYVNN?=
 =?utf-8?B?ZlgrUWYxOTRuQ2haV3BVTVU5V1hDa2xwc0l1V2tzanFOT0dnbDJubVYvUVJy?=
 =?utf-8?B?THQrZHVCdkVVdUJUZVA2dDFMMXN1YWRsUlY0QUJZaUtiTFBlcER3Z2hJOXh0?=
 =?utf-8?B?dng5eUhOUXZ3Lzg2VS9YSTVOWTN4ZjFxdUUyV2NENTI2eElGcnprVFI3Z2dt?=
 =?utf-8?B?NXlrb2FqcmVWN0ZzU3gza3JEUGFyeDFRaytNS0k3NVhyaUwxR3J3bnJBSkly?=
 =?utf-8?B?TnJ5UWI4eDhaQWFZS2pyNDFvMTI3ZzZzVCtySEI4MW1wMVBUMDJvZzRSUi8r?=
 =?utf-8?B?LzRadWFtMTdKREVackp6aXFFZG5DK1A2aWg4QUVNcS9UbE1Ick5JajdmTyt4?=
 =?utf-8?B?S3dYSmlHU0xHYUZTRG1WdFhjQjJoR01PTnQ3TnJFOWcxNUMyeXdocHBIOFdM?=
 =?utf-8?B?N1JmQWFRSEtRQ0VZb1dSRjNZdmcyMnNHam96cmFBMzhNdGtpakorWitHYmdF?=
 =?utf-8?B?QnRTZjY0dDJjRDZjUmpZRVlFRXlFSTRnYk9YcTRpSjBRbDdoRU9sbDFrQnMz?=
 =?utf-8?B?eFd3azZHbW4zTTFaTVNMc2MrU1lKK3IzbDVDTHNHZWU4bXVYNU1RUGhMdVFu?=
 =?utf-8?B?c2RHTHBEOE9ydXZkYk5BVWY4TVJpUDN0YzBaV3psVjNQc1BMTENPVkZDSmJn?=
 =?utf-8?B?ZGVtdjJ0S3B3VzJGQUJ6MWZXVFd3ODhGNGg1bkVGcm51Q1NIUllwdjRNWE12?=
 =?utf-8?B?cW9hRm8zdUpMczJ4Yzg0b1k2R2Z0Y3UxcEFTUEJyalZhMU90WmVsaXZUK2pQ?=
 =?utf-8?B?dEdXOFJQWmZkaURJWEJaT0lEeHJ6a3JkUk5kaFVkb2FYUU8yalRmb1lxQ0Jn?=
 =?utf-8?B?SFo2YUhidy82NVVZVStIbDFTVGVGbmdXREQxYVRGZXh4dXFsTVlvL01USThl?=
 =?utf-8?B?K2U3VWN5ejl1cCtGV3lKdzFHeXRLS2hrZ3d6Vlk4dWFKR043Qk9jbS94aGtu?=
 =?utf-8?B?ZWpPTkFKM3VmQ0J3QVJLREw0disxMkFpTTdMSGZIRnJOemM4dHUvSVJOVHpa?=
 =?utf-8?B?ZjJreGtWVENIM0lvRWxRYUQ1d1FsdW5pandlM0l3aCtEclFKRGJIdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b1e3486-eb8f-4b6a-0e42-08df4235420b
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2026 09:54:22.0937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q4LNKtwuQ79+eBLrqm2D+p2zBXFX2P5k57mlPczS+Kka8M8lZ4L4XeuCb4qHXlyGuVOYcPD+RXM2l3KOLYcrGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8730

On 12.11.26 10:40, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 4 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 2 · Low: 2
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The suspend teardown and the notifier teardown leave the
>   data_direct private flag in different states.
> - [Medium] mlx5e_data_direct_event() can run against a netdev that
>   mlx5e_nic_disable() or mlx5e_nic_enable() is in the middle of…
> - [Low] Socket-direct gap: both new paths only look at priv->mdev's data-
>   direct device, while mlx5e_queue_get_dma_dev() picks the DMA device…
> - [Low] Notifier payload contract: mlx5_data_direct_do_unbind() now
>   passes reg->dd.dev as the UNBIND payload.
> 
> --
> 
> net/mlx5e: Disable data direct on data direct device unbind
> 
> When the data direct device is unbound, the notifier handler now stops the
> netdev, releases the providers bound to that DMA device and clears the
> data_direct private flag. The suspend path also releases those providers,
> because the notifier is not registered while the device is suspended.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
>> index 7db94b8a5b79c..246a03f44afd3 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/data_direct.c
>> @@ -198,9 +198,11 @@ static void mlx5_data_direct_bind(struct mlx5_data_direct_registration *reg,
>>  static void
>>  mlx5_data_direct_do_unbind(struct mlx5_data_direct_registration *reg)
>>  {
>> +	struct mlx5_data_direct_dev *dev = reg->dd.dev;
>> +
>>  	WRITE_ONCE(reg->dd.dev, NULL);
>>  	blocking_notifier_call_chain(&reg->users, MLX5_DATA_DIRECT_UNBIND,
>> -				     NULL);
>> +				     dev);
>>  }
> 
> [Severity: Low]
> This isn't a bug, but the UNBIND payload is now an implicit contract. It is
> not documented next to enum mlx5_data_direct_event in
> include/linux/mlx5/data_direct.h.
> 
> reg->dd.dev can be NULL here when mlx5_data_direct_cleanup() calls this for
> a registration that was never bound. mlx5e_data_direct_event() dereferences
> dd_dev->device without a NULL check.
>
This can't happen. So I won't touch this.

>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> index ebd41f24330d0..63d91ef0dda80 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> @@ -6170,9 +6170,53 @@ static int mlx5e_data_direct_event(struct notifier_block *nb,
> 
> [ ... ]
> 
>> +	if (action != MLX5_DATA_DIRECT_UNBIND)
>> +		return NOTIFY_DONE;
>> +
>> +	rtnl_lock();
>> +	netdev_lock(netdev);
>> +
>> +	mutex_lock(&priv->state_lock);
>> +	enabled = MLX5E_GET_PFLAG(&priv->channels.params,
>> +				  MLX5E_PFLAG_DATA_DIRECT);
>> +	mutex_unlock(&priv->state_lock);
>> +	if (!enabled)
>> +		goto out;
>> +
>> +	reopen = netif_running(netdev);
>> +	netif_close(netdev);
> 
> [Severity: Medium]
> Can this handler run against a netdev that mlx5e_nic_disable() has already
> detached? Nothing checks netif_device_present() before netif_close().
> 
> On the disable side, mlx5_data_direct_do_unbind() sets dd.dev to NULL. The
> handler then blocks in rtnl_lock() while mlx5e_nic_disable() holds rtnl and
> runs:
> 
> 	if (netif_running(priv->netdev))
> 		mlx5e_close(priv->netdev);
> 	netif_device_detach(priv->netdev);
> 	...
> 	mlx5e_data_direct_unbind_dev(priv);
> 	netdev_unlock(priv->netdev);
> 	rtnl_unlock();
> 
> 	mlx5e_nic_set_rx_mode(priv);
> 
> 	mlx5_data_direct_unregister(mdev, &priv->data_direct_nb);
> 
> mlx5e_data_direct_unbind_dev() finds mlx5_data_direct_get_dev() == NULL and
> returns without doing anything. mlx5e_close() is the ndo-level call, so
> IFF_UP and __LINK_STATE_START stay set.
> 
> Once rtnl is dropped, the handler continues with the pflag still set and
> reopen = true. netif_close()->__dev_close_many() clears IFF_UP and
> __LINK_STATE_START and sends NETDEV_GOING_DOWN/NETDEV_DOWN. Then
> netif_open()->__dev_open() fails with -ENODEV because the device is
> detached.
> 
> The profile can be enabled again later, on resume or for the uplink rep
> profile after an eswitch mode change. At that point mlx5e_nic_enable()
> checks:
> 
> 	if (netif_running(netdev))
> 		mlx5e_open(netdev);
> 
> That check is now false. Does the interface then stay administratively
> down?
> 
> The enable side has a similar window. mlx5e_nic_enable() registers the
> notifier before it takes rtnl and before netif_device_attach(). An unbind
> handled in that window would do the same close and failed open on a netdev
> that is still detached.
> 
> Is a netif_device_present() check needed here, or some other handling for
> the detached case?
> 
Since this is low risk, I accepted this as a potential issue that the
user could fix by bringing the interface up again.

But after the necessary suspend/resume fix there is an easy way to fix this.

>> +
>> +	err = netdev_unbind_dma_dev(netdev, dd_dev->device);
>> +	if (WARN_ON_ONCE(err)) {
>> +		netdev_err(netdev, "Failed to unbind dma device, won't reopen netdev, err=%d\n",
>> +			   err);
>> +		goto out;
>> +	}
>> +
>> +	mutex_lock(&priv->state_lock);
>> +	new_params = priv->channels.params;
>> +	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_DATA_DIRECT, false);
>> +	mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, false);
>> +	mutex_unlock(&priv->state_lock);
>> +
>> +	netdev_info(netdev, "data_direct device unbound, disabled data_direct\n");
>>  
>> -	if (action == MLX5_DATA_DIRECT_UNBIND)
>> -		mlx5_core_dbg(priv->mdev, "data direct device unbound\n");
>> +	if (reopen) {
>> +		err = netif_open(netdev, NULL);
>> +		if (err)
>> +			netdev_err(netdev, "Failed to reopen after data_direct unbind, err=%d\n",
>> +				   err);
>> +	}
> 
> [ ... ]
> 
>> @@ -6407,6 +6451,24 @@ static int mlx5e_nic_enable(struct mlx5e_priv *priv)
>>  	return err;
>>  }
>>  
>> +static void mlx5e_data_direct_unbind_dev(struct mlx5e_priv *priv)
>> +{
>> +	struct mlx5_data_direct_dev *dd_dev;
>> +	bool enabled;
>> +
>> +	dd_dev = mlx5_data_direct_get_dev(priv->mdev->data_direct);
> 
> [Severity: Low]
> This helper and the notifier only look at priv->mdev's data direct device.
> mlx5e_queue_get_dma_dev() picks the DMA device per channel:
> 
> 	dma_dev = mlx5e_get_dma_dev(ch->mdev, dd);
> 
> Here ch->mdev comes from mlx5_sd_ch_ix_get_dev(). With socket direct, would
> providers and dmabuf bindings mapped to a secondary PF's data direct device
> stay in place?
> 
> This appears to be resolved later in the series. The patch "net/mlx5e:
> Enable the data direct netdev feature" makes set_pflag_data_direct() return
> -EOPNOTSUPP when mlx5_get_sd(mdev) is non-NULL, and at this commit the flag
> can't be enabled at all.
> 
Right. So no need to change anything here.

>> +	if (!dd_dev)
>> +		return;
>> +
>> +	mutex_lock(&priv->state_lock);
>> +	enabled = MLX5E_GET_PFLAG(&priv->channels.params,
>> +				  MLX5E_PFLAG_DATA_DIRECT);
>> +	mutex_unlock(&priv->state_lock);
>> +	if (enabled)
>> +		WARN_ON_ONCE(netdev_unbind_dma_dev(priv->netdev,
>> +						   dd_dev->device));
>> +}
> 
> [Severity: Medium]
> mlx5e_data_direct_event() clears the flag, but this helper only releases the
> providers. MLX5E_PFLAG_DATA_DIRECT stays set in priv->channels.params. Can
> that leave a stale flag after resume?
> 
> On PCI PM suspend the path is:
> 
> mlx5_suspend()
>   mlx5_unload_one(dev, true)
>     mlx5e_suspend()
>       mlx5e_detach_netdev()
>         mlx5e_nic_disable()
>           mlx5e_data_direct_unbind_dev()
> 
> While the device is suspended, mlx5_unload()->mlx5_data_direct_cleanup()
> frees the registration, and the mlx5e notifier is unregistered.
> 
> The data direct PCI function could go away in that window. The commit
> message says such an unbind "would go unnoticed". In that case
> mlx5_data_direct_init() finds no matching device on resume, and dd.dev
> stays NULL.
> 
> mlx5e_attach_netdev() and mlx5e_nic_enable() keep the old params.
> mlx5e_nic_enable() registers the notifier again without checking the flag
> against mlx5_data_direct_get_dev().
> 
> That has three effects:
> 
> - ethtool reports data_direct as on with no device behind it.
> - mlx5e_queue_get_dma_dev()->mlx5e_get_dma_dev() returns NULL for every
>   queue. Devmem and io_uring zcrx binds then fail instead of falling back
>   to the PF DMA device.
> - mlx5e_alloc_txqsq() keeps creating SQs with MLX5E_SQ_STATE_DATA_DIRECT
>   and the crossing mkey.
> 
> The commit message says "To prevent further use disable the private flag",
> but the flag is not cleared on this path. Should the suspend path clear it
> too, or should mlx5e_nic_enable() check it again?
> 
Although there is a small possibility that the private flag remains set,
data-direct won't be enabled because the channel open code also checks
for the presence of the data-direct device.

Thanks,
Dragos
