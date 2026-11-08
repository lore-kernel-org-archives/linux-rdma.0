Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794153412;
	b=ltur4NPGaZvQhD8GwngtDKKTopC9A4PL6JIeKo/YYFTfPuNON6x4ezp4UGSa40t/neaf
	 kPPwTuzoRuedwV7IFlp/88GPdoxujUdzHMZIMUfNKV40vCTZP+PGdT+NiwrxD04Ztv3eM
	 cW7KTZgfsyV/Tsj8A80Rx2GKAPOgCJaFRiGgJPL6JFpL5mD9JS6iIWgYO/gPyS3S/LxYD
	 iBG+ofPrDqzrZD1YPzfjWWROhUqMcObtj59Yvk4ke4kw/un6+/tdwJ13hYYUi6xtMxh3R
	 U90iqZVhkuAa0sWWJRXDtnScoBQ8PuRKKRJ4JJM8+GmaB/bDZwapFj7r/juRgUIF8Zg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794153412;
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
	bh=7QGbWOdntKDgX9LUqeLb/jirmOLkNSXgFegdJvwdrHQ=;
	b=HkiAN+mJ0tHPpagLb0hzH85g6ono10VJtN18Br+aqFb+xnASKsal7vmvFP+Ns2c9tTZF
	 DJOTBo9berR8WluLm7iRwQTJ8hiUyAuzxxZqfEj03w81ORUx8HtR4p8Id8liKuoNseMMN
	 5vCxsQ/8Z0V8855urPNWmDA2xwcD6a/8zO0wDat+p1e73nQPk25dERDB18+lhg6Vtefyc
	 mX1EguHeNi2rgyVCtz17z1jHkqDJ7MRVI2v7esuU40FCNJFkrOQDDR7p3Sb4ALeSh1GlI
	 M+NyyhIHjXdVZJLygV6+iV2xpugl5l7it9z3UiuyZFf8EsKBj28Nl92ClBod4dagIDw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NNHBq9eH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.15
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013015.outbound.protection.outlook.com [40.107.201.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28276606A31C;
	Sun,  8 Nov 2026 15:56:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28276606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NNHBq9eH
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gr8M52Yghgmrz4HTc9Nd1zo6PyQwRHkqDBVh01ITEeZBcQ/7YQ4bgf3C55UHqw+aa+W9udN7xYGR0dW0rL85+hw0a6GBNtBAI3YHJA4Ieid1akJwS8DXFA70mXyFfj0STK2BXwREjaUL7+PSOmzQ4Kc/DVUHCcdVDTDtqDPhlZV0yaCw1dWxkwAiewuiLqbLSGBaHGxy4KWmwET8M+47yZyL3eRyQ6uQxDXojJFeSpHBfGdIGYvB3xhR/rnlkzzBP5yDjEr1ah6t5wJC62L5DkSElmaeRpRY1EX2xfpAbDSnYUBqL19TLni74QveFHMoPO/uHiya5ZxUUa/FU/BapA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7QGbWOdntKDgX9LUqeLb/jirmOLkNSXgFegdJvwdrHQ=;
 b=hc0GxeTvJ4tqa15QcmP+tMzyNWXuftntNV7gqTSNdLacREIsWQJYXl5Z5RYpN4OXl7pam6b+O680rUpAmFG+HUEhsKtrxj+PmNT8DN9K9Hqmll4vw0tjXtoKRkN9Fv1SQJvqKk9ajEdhrHc29GlZHiw01QORmEaaeGO2bFdRWort9S6Oyz4/tmiVvh7ZIMtjwwsEsw9hrlmie+3clyo05YDJ9FoaVV9kHoZmUbQIcrq/lT7HoRvWqIzWBs18fWTCQqbSR3r2IeHFX9ugGAQfngEpGYArlOcXRIZXOyDgTXJIdYcAr92EQ5KVHHhHCmdDC8ZUC3okw9+atp3HVZAm/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QGbWOdntKDgX9LUqeLb/jirmOLkNSXgFegdJvwdrHQ=;
 b=NNHBq9eH64qR9q3JuK4mviSzsfkmIWe2wXbONp+88f1mK/92Ev6DRiGJei8gKPut6uftcaaMp2ajjCZcZXp05POUF5Ns/OTDRwAMxDSYimCkgyre6RWw9Y/aBmvoH7N1qzPHL09Zyi1HZEJ5qRKu6AhZLpGj4FmIIOinGwiy7txpdDXkdwY84NKqd2JqFOoz0HrWZ9QKTmteRtlfwZzrt63L74cjyPowPYi21drz2CXJZ2nSs99Em7cFrr7rU7T0ltFhwexZQRvOPkmB5n+2VNEOALMxuh1Gd8G2oM65nNKstLdsYyZLvwc0o4IA03lm13z1d4md2J202A3Ak2OljA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16)
 by SJ2PR12MB9140.namprd12.prod.outlook.com (2603:10b6:a03:55f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Sun, 8 Nov
 2026 15:56:48 +0000
Received: from BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81]) by BL3PR12MB6473.namprd12.prod.outlook.com
 ([fe80::778:72e1:e792:df81%6]) with mapi id 15.21.0592.010; Sun, 8 Nov 2026
 15:56:47 +0000
Message-ID: <69f86783-ec77-4042-951f-998e7ae0ac77@nvidia.com>
Date: Sun, 8 Nov 2026 17:56:43 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Free software WCs left on wc_list at
 CQ destroy
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
 Haggai Eran <haggaie@mellanox.com>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>
References: <20261103-free-sw-wcs-v1-1-3885ce449012@nvidia.com>
 <20261104140106.GE478286@unreal>
 <4b02dc55-7362-438c-9595-19818a60cbf4@nvidia.com>
 <20261105194222.GK8298@unreal>
Content-Language: en-US
From: Edward Srouji <edwards@nvidia.com>
In-Reply-To: <20261105194222.GK8298@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR1P264CA0032.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::19) To BL3PR12MB6473.namprd12.prod.outlook.com
 (2603:10b6:208:3b9::16)
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
X-MS-TrafficTypeDiagnostic: BL3PR12MB6473:EE_|SJ2PR12MB9140:EE_
X-MS-Office365-Filtering-Correlation-Id: b58ca63f-c435-463e-c453-08df3db0e4eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|5023799004|11063799006|4143699003|56012099006|261021123027099003|261021121427099003|261022105027099003|261022075727099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|261102124527099003|261102123227099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4SE8zvGd4QW3MJCKieMEijLBaKC1p35vAgmeBt/DiD+/XUh5/7w3Yvz4982E5dN9v8yBcFWmrffuZvikhOfVajaqiueR8IWvlm0QI94x8FnkThZ5vopFdYAldFZ7DIoDcJxZ1HLqsOa2SZel3u/qYHfF+rtzei0/BiZn5P9fLSzxfEbGyj+Hp2rtePyiXOfpalYO8IGD/d7oKbnlRN7W+8f2SNJUsajFcOHy1XqFq5JKbpwyZF/xACEN9qhs8ksMAN2h/LmsovopDupOgPG5BJbFbJ+Ts323fvaR4BQxjRWdFmO9D69+NhsBc4ue9uOEdnR9AsUIt3KGZIrx4tdZtwiqXDTjAxOGXN2ZkegxE5LWNuYe+oxecTr8bgBsv9EVoI+rRAHJvOBFqx4f+A/ai/HXRfcGPNzwe+jjGEWYAlI+otZstHv61MtO7jGAbIN7tcWbORlPYrRKuKZv7X+1NLsw358VcRJZf4wwIIuyw94cxD1qclhl8QMPYnvdfYN7qIJCpNPc3XbiC+92b7F3DG9y/VtPZJx9CWCiqnBDTXMwCTpMGh8bZWT9qMkpjjbBUtb+TRocG4Tyhs3YwiPHfslzvaGB9ZQckHV4UuXuJpt00UKGFQAqWYLKOdXjXT7QD3A1jWX9Sm9VJSoA/IEmiXZIxpEMUg8puzoPOqjEpMQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB6473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(5023799004)(11063799006)(4143699003)(56012099006)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261102124527099003)(261102123227099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0QxU0hjSGR3VmZFMmNLUHFWQjdobkgwTXl5YUE3dkpOOWRKSWR2YkxCYkEv?=
 =?utf-8?B?c3JRQzRncnZZdjZVd2FnZjBhRGZLTEVMSTlIMExaWEdsRG42dXNPZjNFMUQw?=
 =?utf-8?B?LzY3SWJ2eUw1amJjYytNb0VHb0Y5cjJwR01pbS8yKzJhaTlXSmUwNFQ0eVF6?=
 =?utf-8?B?QlZka05FRXlvTDh2TUtqcHA4ZHJOY29RVXpVRWV0UjZHQjd5VytQWkFUSGg4?=
 =?utf-8?B?aTFVOSt0amNUdXZrMlhDak5SMnF0QzBiNnovUXJuejR0c0N3WjZrNTQwWmNX?=
 =?utf-8?B?THozK25tUWkvYktleXVrWnZWcTg3Y0NpV2JYQUg5MHQvK1plM0JvZ3V0d0dq?=
 =?utf-8?B?QXRncldsK3ZPSWxSa2drSTVCT1owWDdZUmwyTnd2aTZUVjNwSGlMclEySVFU?=
 =?utf-8?B?MnFnQ0dNMWlySXhRbDl2dWJ5RXYwNzFSdzBHLzZzeEMyMk9iSDl6UDZUL3dV?=
 =?utf-8?B?dUN4YmNxRjJ5OGpXN3RsUi83ZFNYM1hteE90WVUwN2p1RlVJRVlJN2hZK20z?=
 =?utf-8?B?YVdPMGJZRUV3Qyt4bDY0b1hkNUpwbWFldDY1ZmJNcGVIYkNUa2dJNmEwcWtn?=
 =?utf-8?B?dk51VWtkQTRsZ25CRGg2SG9QSGhtZ016WWJod0JnOGRTSXlzZFY0c1RPVDFE?=
 =?utf-8?B?OEpEM0FWVWFNU1Mzdi9FMnZaMHlYRHU4Y0RVT2hsZzl5aEhiQjg2TG9yZVJY?=
 =?utf-8?B?aFFycjlwZ2RXeGFvS0ZyNjZlTFZ6c2c1akUva0Zsc2ZhR3pOdWFsT2VNRW1C?=
 =?utf-8?B?amV2K3Voa2pQR1NpYU4xdVJ6TFBKcnIxcFJYNUpVOFNpTXlZL2tVWTBWSHJT?=
 =?utf-8?B?Y1pPMXpNMk5EbGM2cXdUMHBmbUhnY251em5LVDc3dW5NZnhNUjlmaHVwcXBN?=
 =?utf-8?B?MFUvMzgrMU42Y0ttaFNHNmZjbzlVRUhNUkJzdzhtd29xWERlRHNnbFlRa09l?=
 =?utf-8?B?VHk3VG1Va0NwTFhDYnduN1FTUW9BZytERVJFQ1hlcHNhQkZ5bGlPZ2VIemhj?=
 =?utf-8?B?UjE5U0RUZFZ3VmFoT0dZQ3BjbHVnUVJXdnRvbVBCTnVrNkZrbWJvaENhTzh1?=
 =?utf-8?B?Q3UyREJvdXhtNHR6VjFOLzZub01pbC9JelgwcTc5SVdNWXBGUWlXdnZ4ck1R?=
 =?utf-8?B?RG5JbEZIMzNEZm9rS0E5aW5lMEpTeWo4Z1VnUVFqQkM2M3dpUU5wZEE5US92?=
 =?utf-8?B?R2ZoeWV4ZHZENFJORkRiR29ZdXNZQ0g1K3N4VFJGN3gvOWJWejJtdEtNblA2?=
 =?utf-8?B?NjU4dFh1RGI3QlJ6T3k0QnFZL2FFR2d2Y2MxNVBDTHpGUVNmZjEwU1hxTE9w?=
 =?utf-8?B?QzZyb1Y1YTFka2NOSkFPMVB0ODYvUy9reWs2cGhWQlFvNGtlY1BPRUw4Rmgy?=
 =?utf-8?B?cnJIYkE2YzVxbDF2MkV6Z1M2TFZldDkzTVZMZ1Zlbmc5eTZvOXIrQUlZR2Ja?=
 =?utf-8?B?WUJuSGZDQ1FtQ2tqYkJVU0hiLzZSYlRwaDZuWmwyWTBSUE5wWURldUp3aUdG?=
 =?utf-8?B?cXNDT1lFcGZBOFh3MWMwZEwzVW5zUHBmWGZ0WVlubExJYzhJV1pRTThUVm56?=
 =?utf-8?B?MkV1Z3YrUzBJVkJUNFpOUHZyVFN1RisySzNmdzJnM05yVThuUVUwTk9lakNh?=
 =?utf-8?B?RzR5N0pkUExpVWY3T1pXbUlhSWE1bmhEdm9EaFRXVW91S3ppQXVRVVQzZjFt?=
 =?utf-8?B?RCtmUmNrSmloZ3VlVjdZS3lyWTY0cDFNbFd1VmdUdVoyZGlUcjFRT0lERHps?=
 =?utf-8?B?TGxoVlJ4MGxPd1dJQXc2VXQxSWF0NE92dTVYelJTYTFNb25wank2S0tXanFx?=
 =?utf-8?B?c3R0NWNHWHUrWG5pejR6NFVjbmQ0QXF4MGp1WGx0bW5ySTdtTmdNWHBOZXhW?=
 =?utf-8?B?b2x3ZENDZkRpRmlUQnU1WTJ1UzB1NUpXd3NmSlZkWjFjZ0ZId1lVb28ycHlZ?=
 =?utf-8?B?ejZCVTdBUnZRUUpXWEEvbU4vVHl1SVZrVms4WUZGVjFnSFJYdWJWKzNhc0d3?=
 =?utf-8?B?LytNUnBQWS9QbUxySmV0NUFobUNPNk53d2NvenBBUWxmcGtzMU5YaUY0VE1R?=
 =?utf-8?B?MXNoSU90MnlvbW1FVU5tQ2JtWklvYTF0bzZZK0tyZWdDOG9jd1FnZG9KT3Az?=
 =?utf-8?B?bXhTTVlRTmZoRGNyYnc5SDBxNGVvQ2U5MkR3ZVpndmlSRnRPYVdabUh4VjZ5?=
 =?utf-8?B?QUNFV3FtdFIyL085UEgyUkkzWC9sUkxDZXRWdkpoMW8rbWk1b0tuUit5Mnlq?=
 =?utf-8?B?bU90MUpHMVlxZTBXbU5jMFdydVROMXN5RG5JRVVzWXFVZExrYTlvQTdMMm1v?=
 =?utf-8?B?a1Flc0dlMEZYTUx5R1RHOFJlYXpuZC9nMEk2a1VUeU5QOHhBNlNWUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b58ca63f-c435-463e-c453-08df3db0e4eb
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB6473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 15:56:47.5738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lyNEO9KZBneHjWimtwWe9XkX3bUahf9xKbzbOawmJM4tMZByp4ILwMDNHsam1SAOMbO7lIFcjx/4umEFfyVCnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9140



On 11/5/2026 9:42 PM, Leon Romanovsky wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Thu, Nov 05, 2026 at 12:05:47PM +0200, Edward Srouji wrote:
>>
>>
>> On 11/4/2026 4:01 PM, Leon Romanovsky wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> On Tue, Nov 03, 2026 at 06:55:19PM +0200, Edward Srouji wrote:
>>>> Software WCs generated by mlx5_ib_generate_wc() are allocated one at a
>>>> time and linked onto cq->wc_list. The only thing that ever frees them is
>>>> poll_soft_wc(), i.e. a consumer actually reaping them. If the CQ is
>>>> destroyed while entries are still linked, those allocations are leaked.
>>>
>>> Is this real issue? Just put WARN_ON(!list_empty(...)) instead.
>>>
>>> Thanks
>>
>> Yes, it's a real issue reachable on a normal device removal.
>> E.g. ib_mad destroys the GSI QP and frees the CQ without polling it (while
>> it may have unpolled completions).
> 
> "may"? Does it have unpolled completions or not?

You were right to question that in first place :)
On a second look it's really not reachable in practice (wc_list is 
always empty as unregistering MAD agents waits for every posted send to 
be polled, and only then ib_mad frees the CQ).
I'll post a v2 with your WARN_ON() suggestion.

> 
>> I'd say that this is a complementary fix to
>> https://patch.msgid.link/20261008141209.6923-1-prathameshdeshpande7@gmail.com
>> Before it, a pending notify_work still ran and polled from freed memory,
>> which was the UAF it fixed.
> 
> Do you have dmesg stack trace?
> 
> Thanks
> 
>>
>>>
>>>>
>>>> Drain the list in destroy_cq_kernel(). Nothing can be walking wc_list by
>>>> then: the poll context is the only walker, notify_work the only thing
>>>> that can re-arm it, and both are stopped before post_destroy_cq() runs.
>>>>
>>>> destroy_cq_kernel() is also the error unwind for mlx5_ib_create_cq(), so
>>>> move the INIT_LIST_HEAD() of wc_list up next to the other list
>>>> initialisations, ahead of anything that can jump to err_cqb.  The driver
>>>> object is zero-allocated, and list_for_each_entry_safe() evaluates the
>>>> next linkage before testing the loop condition, so draining a wc_list
>>>> that is still all zeroes would oops.
>>>>
>>>> Fixes: 25361e02c448 ("IB/mlx5: Generate completions in software")
>>>> Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
>>>> Signed-off-by: Edward Srouji <edwards@nvidia.com>
>>>> ---
>>>>    drivers/infiniband/hw/mlx5/cq.c | 13 ++++++++++++-
>>>>    1 file changed, 12 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>>>> index 55ffd7d4de517e6ce3f04c98b4edcd94b12e43b3..2f7ac350c3d8f179ad1d4d8c1181b93f3151c7ce 100644
>>>> --- a/drivers/infiniband/hw/mlx5/cq.c
>>>> +++ b/drivers/infiniband/hw/mlx5/cq.c
>>>> @@ -933,8 +933,19 @@ static int create_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
>>>>         return err;
>>>>    }
>>>>
>>>> +static void drain_soft_wc(struct mlx5_ib_cq *cq)
>>>> +{
>>>> +     struct mlx5_ib_wc *soft_wc, *next;
>>>> +
>>>> +     list_for_each_entry_safe(soft_wc, next, &cq->wc_list, list) {
>>>> +             list_del(&soft_wc->list);
>>>> +             kfree(soft_wc);
>>>> +     }
>>>> +}
>>>> +
>>>>    static void destroy_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq)
>>>>    {
>>>> +     drain_soft_wc(cq);
>>>>         free_cq_buf(dev, &cq->buf);
>>>>         mlx5_db_free(dev->mdev, &cq->db);
>>>>    }
>>>> @@ -1067,6 +1078,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>>>>         spin_lock_init(&cq->lock);
>>>>         INIT_LIST_HEAD(&cq->list_send_qp);
>>>>         INIT_LIST_HEAD(&cq->list_recv_qp);
>>>> +     INIT_LIST_HEAD(&cq->wc_list);
>>>>
>>>>         cqe_size = cache_line_size() == 128 ? 128 : 64;
>>>>         err = create_cq_kernel(dev, cq, entries, cqe_size, &cqb, &index,
>>>> @@ -1102,7 +1114,6 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>>>>         mlx5_ib_dbg(dev, "cqn 0x%x\n", cq->mcq.cqn);
>>>>         cq->mcq.event = mlx5_ib_cq_event;
>>>>
>>>> -     INIT_LIST_HEAD(&cq->wc_list);
>>>>         kvfree(cqb);
>>>>         return 0;
>>>>
>>>>
>>>> ---
>>>> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
>>>> change-id: 20261103-free-sw-wcs-8cf40aa66fd8
>>>>
>>>> Best regards,
>>>> --
>>>> Edward Srouji <edwards@nvidia.com>
>>>>
>>

