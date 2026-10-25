Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792940412;
	b=0CNHUebpk3uBuR1pipr6VMklGnTbjZWo3/Jz63EcQi7mAFZqRfNDynbiYW7WPGfRYtoH
	 jXyf9dGdQmPsr46l5UcrXgzdFYIjCaP3lQZekm8Fid16Homlr/4WedwTTLpKyWVzYV1G1
	 FFRjeI+PzRQQF1hzfwGSmTqWRmRJCiLglJn7KOhpd6jFXEDrTudo1F7jCOmu7SqSYD9XN
	 XXYbp2/ITRv64fWLL8kuFXou6BwxuYckPkFMTD8Cro8KNNzcm9v+QyWDqgkgwwnLCuxPc
	 w727rkEGnroYX9lMaqw7wcPizQ5eFzTu7RgRRJYGpWE3949Z6mXVf8zS0eK3VUrLJCQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792940412;
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
	bh=yoi7pTZWiqh/3/2/22hV8VfKPyvcRryUsVLOiSfAcuY=;
	b=kP1+WOoxtLRyRn9HueQYjr5rhfVI1gvR59ri559l99w5+oT3m9kU7WVc+6eEHxWl1m9C
	 h5xlyZsu/uIGO+NbdZUEqjSpTGl9+eIImnHX7LNw9/5DeDoWE9ApHkaFNNUyCEQ95Nlgs
	 1NE8BD6gKPmFI24Cjcg5Wz228jvRCTsgstGN6ddarHZzGFAXsCyKlITXQGM+JatcBY0Z/
	 wK6RHe5/ePKBK3SopAGuhobNeUQP+liHMULVRt+9dzukELDchbyc3ryaTLF82xJ/CJRrl
	 frLEbmsEC9VV68IPp7eHSqQuPJ2KpO2mniYmqB6/wrDt+JKIcQkWsQYyPGtGXKDz2ZA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uo8pghjW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.64
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011064.outbound.protection.outlook.com [52.101.57.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4AF606A31A;
	Sun, 25 Oct 2026 15:00:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED4AF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uo8pghjW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lDY2ul1U8gpOgLYNNZOljIc+8P1WgBlxjD/b0YqNpH7thPzxAybpscUDFaLgNomfD9GtWUgJIOjHxMcO2iTrQaZnW8AjNAKeO+bOY1WTel2c/irb6Fi/m3stecmLZrD+lSfNbSErZhrN96ZFWFKnHyg7pAlwRJvaoRNBO5QHY61/9+TGmxgz7KlIidYEvzslIDSTZGFwKqV9BweLu2UhHQs+y6rO6KxzoPGa06UYXytVJCPdb+xj0w8TCIHNBQKFlpoA7ZkibQb0ooNtpscHMh6RwtQdeJt54lskS69kLwWwI+cB/aKvTeJLHi22gp7nbPYt0TahCNFOnkPpFCDJ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yoi7pTZWiqh/3/2/22hV8VfKPyvcRryUsVLOiSfAcuY=;
 b=SOrGlnTgOM2HjKg9ixOP7kB/KWHXWWqWwWb/DbkMOEs3Ohck4OQioaXYqIsemqH2YvgFFII60vwkvuLyjZi52q+QsNj7Y8lFEIU+q32NNtUN1vDYwHOPdN1vP5FxTDQT/LP+tOtl0SYe650RQcHTcffwRHAfNt1FcHXmMiGMik0F720SFxxmWgSUCZ5q8C37lzZvvyCVcY1yU0HD9jwI5M7Yi7cdhUjxf1fAbIwZ6DArcdyrjrFfppimDi3UK0m9zvs1uE0OKUNocTiaKsQxV2XyBm8wVHlm8qTnN1hhfdBSgSiEGQH2FGmoa7N+P27LqYTx0V7bmVswX1OjL3UZ1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yoi7pTZWiqh/3/2/22hV8VfKPyvcRryUsVLOiSfAcuY=;
 b=uo8pghjWHEXzFxD9mEkePfNsAmexZ0Zfh1OrrV0SQNaSvf5XJEuie/eClxQLRehqLHCKEaUKXx5CPPif3jt/tT97/gR3ZZ5W1IW8NS0yR6Bd5iOPhnoKX1vt5aiv34Jw96xsg88U+SlLkUPJEIMc3I45tn9IFAL8hSf4rHvmCvnsAKypk8bvmj0UyAtI8GKJvMgCyEkB6034Ioox4rOfWqN6t3+X6WiNpSSlUTQzq4w+cNP9SugMdFpyettp7G2SgIrjkC7Il5Ymtq7KthvTpBpIpQidIevO7fkJ4+Y3z0n3Rtp7/inA8IQwnocp7O38MKYqZm9gI+jjKBLeDCWnfw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7) by SA1PR12MB8118.namprd12.prod.outlook.com
 (2603:10b6:806:333::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Sun, 25 Oct
 2026 15:00:08 +0000
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c]) by SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c%6]) with mapi id 15.21.0546.021; Sun, 25 Oct 2026
 15:00:08 +0000
Message-ID: <76d59f51-a3fb-4297-bcbd-9fb72a00d67c@nvidia.com>
Date: Sun, 25 Oct 2026 16:59:59 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net V2 0/4] net/mlx5: fixes for LAG max_tx_speed update
 flow
To: netdev-bot+sinfo@kernel.org, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org,
 Maher Sanalla <msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
References: <20261022193053.3815866-1-tariqt@nvidia.com>
 <179269787533.3290.2556599268261931387@kernel.org>
Content-Language: en-US
From: Or Har-Toov <ohartoov@nvidia.com>
In-Reply-To: <179269787533.3290.2556599268261931387@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0009.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::10) To SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7)
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
X-MS-TrafficTypeDiagnostic: SA3PR12MB239779:EE_|SA1PR12MB8118:EE_
X-MS-Office365-Filtering-Correlation-Id: fbc0b97d-21f7-436b-8cca-08df32a8a8f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|6133799003|18002099003|22082099003|10067099003|11063799006|56012099006|4143699003|261021121427099003|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	sknuocWBlpVVXxB80a/koK0VaqYqf79wdhK6xdVcsZGJNDtytY+2MbPAW+J6SgVr0uS6Thq/1dM6+50meEqK6La2yIujzXjvJ6sL70JJd7STXWbdIhBrdKhgZGTkxXpy7///gwJvB/Re76jlpySF7QXDU3zQXixWTDF1mSf86uWJgJzdCBPt/QvSyl3t0obd/8a56UgT2Kj5obF9KHxWZu1QgG5K+YCE34/YaYW9k1F8eSdwtjxb0OP/qQ+O+E4ctZU+M64zJ+lBrrkTcGeOJVfSYmVyqStLRFEOKfFajBlBCHF0ZH+r0RdvJI92uSK5cjSHo+sOZRREuwvsH0mdnDk6Wads5H6aluYYUEmUYZnbMm3tR4/Z24Vq6l1ZDMUabQijmxsld4Gdf8/DrJSNFn3G5DL2oZ7yTCrwwuZ5PHM5ZHqoEyMeIvQR6XEoTUPcEKSp2Td3VwyIb7QOLrQwOvTfNDSQcG2C228kp+CgkbD3zU6mJ/3ZgIDe5SN29xbOFu7IRuHtUSYI9C2gW1L7llp6xlhwowrtvzs2N4ZDZHwdE0/tTV8/rwZU6aIpUXVkx+nx+Dyn6hsAj8R8XAvuZZP74brN2xnQfze2s2QDDuUi2Xg4IN/nHlHG9EN7lM31BlRN9RfjrqhdA+yjwxnWpsraxWtV7j03wKPSdCzhxNY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB239779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(6133799003)(18002099003)(22082099003)(10067099003)(11063799006)(56012099006)(4143699003)(261021121427099003)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzRzWGtDeXd2Y0dnam50SE9BVTgxb29Dd1FERTRZTThyTExBdUFIdnYyR3l6?=
 =?utf-8?B?bEVVTG1Zd0NOeHh5NTQwUDRMWmlhVWh1VnRabTBDaDlhQVpQOUlPTXRMaUJt?=
 =?utf-8?B?VXY1R3R4Y0ZsanRyUGhTMVdaUU02N0lPVk5mVnVubERkOW1rdnZYdGhvbzRC?=
 =?utf-8?B?aklZK1RLMjB1YVNiQVFISmM4Nk50TzFPQTdUQ0paZmI3TWhKS2NkWlF1OGRB?=
 =?utf-8?B?V3FGR0IvT21Pd09PUHpaNk5IMVExcTNKVGNTNjcwcmQrYjkxcWI4UzN6YXBC?=
 =?utf-8?B?Q1JvVE1abGgxSkYrTmpnc0VycE1hU0xlUGVha1lSWndQMzRGdzhaLy9TcFZl?=
 =?utf-8?B?eDBTbVZYeHY0T05NSHk4cytyU3hLSFpMMkpkTlhOc285cXd5NVBDMHEvTGdJ?=
 =?utf-8?B?YmtvTlV5eG50K3JibjlYME00QVVYNEZvQnlKbUlNdVkyTlV2L3lIMFFIaEto?=
 =?utf-8?B?aHUzbndIS1RZVmY0M1MydUJ1OEtPdUJYU3NEeVdsOVlRenptekZCNUJWM01n?=
 =?utf-8?B?ZmVVMTFtK2JORmIxMDBWczVJaldBend1UWVrNzdjMzNBMXd6ZXZTVDdrbGtx?=
 =?utf-8?B?cFZkU2hneDBsWXR3WXJFZmx3U0gxTjI0dnlJMkpDZzBLU1dMbDVoZkdEMlBx?=
 =?utf-8?B?WlhWdWlmYk9oRDFwQ1ZORkVUMndMZVZib0tNOUJRRWpnZGExQkEvV2JUMktr?=
 =?utf-8?B?RDAvaTY4V3BoNEQrM29mSFdVcUtLRjloSmVnbTZrUXpseUR2RVY0cjhhME41?=
 =?utf-8?B?ZkJacXozMTU4OUcyMWZORFNMZkRkTkhtTXlQaWNpYzNzM0I0WkF2ME1NTTJj?=
 =?utf-8?B?S05Jd2d3YWhVQXdWM241WXBCRWxyVDFidmpqUmNwVHNReW05VU9HTU1lUlQ0?=
 =?utf-8?B?UGtLSEFmd3dtS204TTBsY0VrWkYyTGhXcWgzeTJEYWdhNGkrU3pSK2NITzN2?=
 =?utf-8?B?aFdYYldydWVYVjBFYUJxbzRqdlhmRHR6OFJ4YWdiRlU3UW9uanZpMUd1aU50?=
 =?utf-8?B?Vk5WUjBTVWhoRm9rZEU4NGhmZWxVTnpoU1Z1enEwOFhyb0FXTUNOQ0NjbGJQ?=
 =?utf-8?B?M2xTT1NCSXlzS2ZuUGxHRHVzVHJSQm5lNEhXazZaQ2NUazIySTlrYkpPRnZw?=
 =?utf-8?B?L3Q5WXcrQThtU3lGUWJYYlptQ0VHcDdsbFE1a1dFSCsvNmpvckNHYjhZU0Jm?=
 =?utf-8?B?M3RvOGVVbk5tWWQzRzRoVXBjRW1jMjhaS3dEQWxQOUl1VVl0cGpwc2lUckZC?=
 =?utf-8?B?blpzd3RuZndsTExmanM0alpudUlvanhQQytwL2RFRmVPQ3YvWm1Bb1cxOEFo?=
 =?utf-8?B?QURpemRuWHBmenlFcGc5NUVkMWVTcldLbE1RV0tYalpPak1GSW5KbkRQWmJ3?=
 =?utf-8?B?OWNHVVcxeWtabW1mSWZDMGpCbkRMV1FWV01uOVEvMW56MHovMHNncVg4QmxP?=
 =?utf-8?B?ZU9NZ3lrQmR6UG1ZNEhmRUhScEdLd0UzTUduNjJpTEtSYWRwUTl1aGNBTzMr?=
 =?utf-8?B?WHoxVFdjUzZScU8vMENYU29tdThoTkJUd0RKSVpjT0pCRFpycjNaenArdDZ0?=
 =?utf-8?B?WEgrcG1YUnlsMDJOZXFjbUdBdVBDN0p2dFZPZWVxbG9hNGxoOFFvNVlOS0lT?=
 =?utf-8?B?U1pia0gwS1lJMGJ4WThwb0xwZnNsNHhzYVdrRzVjTXJTS0VKV2dxdFFjc2Ix?=
 =?utf-8?B?S3FDL1g1R1JFSGtjL0QreW5wVUxUNlFiajVCdWR0SzdjbmxxV3MxT2ZJVnll?=
 =?utf-8?B?TmQ5TmUwd1dhN3o5Y2pqQnRqZVlHMUxLcW1YS0ZmSHlZbWNzTTcvNThROXVh?=
 =?utf-8?B?MStMVUd2M3ArQU04NVplSk14QnBMblRQcWxERVRDT1J4c0RiS2ZoM1RzSEh3?=
 =?utf-8?B?eGtXU2xTYjJNUG00OHhFM0xrNUdod1RveEVjSUJiSTFwYmN0bnh0dmloMlha?=
 =?utf-8?B?RHo1M1pzT09OZU10bzNhRXNNS1RoMkQxSnlQd1JaekdIRmFmS0p4ZWF6ZnN1?=
 =?utf-8?B?ME1ZbFd2QzJOamJwV0YrdnU2MHlJK2UzVE9Gd3prOGFaY09FZGZWa1FhUzU0?=
 =?utf-8?B?WDErU3ZWbzhwRzdodG5TMXcwV1dWVms2T2ovZE1oWUREZkZidmEyZW00WGxF?=
 =?utf-8?B?OXllOGdhcVpCb3ZuajdpMElYTWY5Tit6K0dKSlNYeGNtRDI3MW5vT1R4OWM5?=
 =?utf-8?B?N0M2SnNuUWcwMnc4bTZyS1h3RS91MEdTVE5jS1lidE9Xb2R4S2NIMHlNQ002?=
 =?utf-8?B?QWh2dkU3U0x2cHd5ZEowZGtxeVR2KzlCY2NpWFhhajh2UkxaanNVdjljRnhC?=
 =?utf-8?B?OHdKakYrZjdKZUNRNC9SUGJuM096NVlQT0VCNk5IZlVrNDJlVWxCUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc0b97d-21f7-436b-8cca-08df32a8a8f3
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB239779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2026 15:00:08.2614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIHMWQ4CSglNsKo7Zp8JnQFItJoiEi3MKBigPTaxT2ctuoGv0lrh2UB6s/fa7TqXCklzCGOetOpebGlEU1ScCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8118



On 22/10/2026 22:37, netdev-bot+sinfo@kernel.org wrote:
> 
> 
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>   - How the issue was discovered, e.g. hit in production, hit during
>     development, syzbot report, manual code inspection, LLM or static
>     analysis tool scan.
> 
>   - Whether the issue was actually triggered, or is only theoretical
>     (e.g. found by code inspection). If it was triggered please include
>     the symptoms, like the stack trace or error messages.
> 
>   - What hardware the change was tested on. For driver fixes please
>     mention the device (and if relevant firmware version) used for
>     testing, or say that the change was not tested on real hardware.
> 
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
> 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.

Hi,
Bugs 1 and 2 were found during internal integration and testing of the 
flow added by 50f1d188c580 ("net/mlx5: Propagate LAG effective 
max_tx_speed to vports").
Bug 3 was found by sashiko.

All three were reproduced on CX8.

Or

