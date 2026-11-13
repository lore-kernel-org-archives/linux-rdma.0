Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.37
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794582046;
	b=Sx/9OLvPEksifCDJ1VtLP0RkMzpxI72SZCVIDk+ieqtlj81h07bUgjljmSlbZ5slbmxh
	 NT/jDoJGH89U6cCw26Uf68S1PSsz8Cf0rUUEuDkTkbGgTI9CMoHUcJVMG6BdvZwHShD2b
	 Zhn6VzOYeLkoC6yPeoQafP6sAO8EFEHfiX9led+kge0o0/sgcL19+A4ENMXKA575rgYCf
	 hPsx0NnX5FAw7VQmGpTd+IIPH4kO66DZ1f+mwp3bfi6Q5E45npSE5mgMiSpDrPsXNmYVQ
	 O9k+ZHzjZtZtHj9hewRHgfRiA/n4e++xDJ30E8Wh8IFORx+83o5fftSl1+nCaxxngHg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794582046;
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
	bh=z84tTSoE5BhFk8h40bAhW37rHwhW8OQWv0WoJc0Kyik=;
	b=5R/zcwcqhVkdYgulTZyi9ZLBVA5MaWvz7sUwK3MeWU+ce6WUQDmoBom8Wt+mNUxLlInB
	 /A22z5kK1gRzq9dfvHwPROgvYOtnNFIjW7NI1DjnzxfNYxtV9c0yprU7Mebj8LKJ/1Ekp
	 wbIJavvcl/ORVM92ZeeEDQHA/MHAWF4/GOsB8WewLgqdheazj9xnFaYqH4QvO1L7u2KW6
	 tr1bt1WN6DwrEDOP/K8bKycNSAhnib0hpG2+EL8HxBlPfDEOvExAWwJB1MsZytEkbR65o
	 69ix3tGB2BUSMBpOIqKOR9uoqkgtS4lqyA/XQQZD++/i8DWkc2SUf8GpIlvV1u/NuDA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=IdprD2Sb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.37
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010037.outbound.protection.outlook.com [52.101.56.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41A5606A323;
	Fri, 13 Nov 2026 15:00:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C41A5606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=IdprD2Sb
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mEf1LoTyQu3yv93fTOyP8eSSDPTektV1g0ZST4cVWA8gCIyxgAG1fF0XSJFRAeAsg0RsNQz/182P9m3sdgeH2RIvgRycp7ry6UesiyPGZ8XOP9KG6X2PdCma4ZcFeQNbwbpiuMtci0YPKDQqg7HfIEKxwSY7pv6NySYfF+ywVdmhMN49M2JTsUKhHN6UMhf0ID/gm15U4JWEcdDCWARf8qVpe5JpO7C/oRGn54aTo7OZzgvI5ksOZBhOTptIQXlxI/E4wfj0TEBr6pMPs6rqvLcmt+c52skDlCXfM0LsO0codpLKqdeSdHEW2kQ6vSh2mP93Rdqr59TvQn7Cu72Okw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z84tTSoE5BhFk8h40bAhW37rHwhW8OQWv0WoJc0Kyik=;
 b=f0UyhXZfHjDqMyyS1UcQoTBFGw6CkE1MvGr9EddQLiTMqvmOACZa4dqSkuSiK51KrqJeTsvrLuMdNzqr1O1n2pgz+Lu/nVdHZ+3fGvuEOchz/jnBNAEQpP6v98WOFWZolcjzULGtH+/qIcaB4YH0hvmrcuOxhGu2Lt5TRbqKO5798hJ+2Mbwhul2pZu9kAs8tfNB0sRMYnRLe/Y7YpDnB1/HcucjEfGX90WB3LiQB4JtMen40tJfX/Klj+WzF0hnGD4XeoDp2agTe2lIMtoJ8VC996bTRPdtkGe1BjXcgA+r6Y8RHo6AGRti4+bzBYbDJ+U1L8bmW0biO1qhFumf2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z84tTSoE5BhFk8h40bAhW37rHwhW8OQWv0WoJc0Kyik=;
 b=IdprD2SbEZxrv1IDkZD0QU+kpBTmg44n4BstkCh6HaRvJ8Xxh0cXg/TroORcvjwRFhSkhhxMkjsac2WFhC8Vvao8O9qnTnivFRQfSK9R7/ra5fdzQ/ADKZILaNZw957ptOdKOJrsHzqUNDKIzzGaCp3zY6NkOeVI5vksYQh8scq152GCdxhzFU6ZhgRictwRqGxGTibJEnh/9wrR2Gp5tzy03daun3/dosL8UExD8Bntn2bGBiy4zYMvo4yvRy4dap6T45kODvdrvt9+KF3X3//QnbdBFVvbkpRwOY1kfJagkK21xC7pQw0zCsrLiw+x0EzCGvMAx9Tejz0LPgEpLw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by IA1PR12MB6530.namprd12.prod.outlook.com
 (2603:10b6:208:3a5::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Fri, 13 Nov
 2026 15:00:37 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0615.007; Fri, 13 Nov 2026
 15:00:37 +0000
Message-ID: <ebd14110-49f4-4fbd-9dbe-1c39a1706da9@nvidia.com>
Date: Fri, 13 Nov 2026 17:00:28 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 10/13] net: devmem: add
 netdev_has_dmabuf_binding() helper
To: Stanislav Fomichev <sdf.kernel@gmail.com>,
 Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Bobby Eshleman <bobbyeshleman@meta.com>,
 Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Daniel Borkmann <daniel@iogearbox.net>, David Wei <dw@davidwei.uk>,
 Erfan Sharafzadeh <erfansh@meta.com>, Gal Pressman <gal@nvidia.com>,
 Jacob Keller <Jacob.e.keller@intel.com>, Kaifeng Wang <kaifengw@google.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Matt Fleming <mfleming@cloudflare.com>, Mina Almasry
 <almasrymina@google.com>, Nikolay Aleksandrov <razor@blackwall.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, William Tu <witu@nvidia.com>,
 Bobby Eshleman <bobbyeshleman@gmail.com>
References: <20261110183826.2927274-1-tariqt@nvidia.com>
 <20261110183826.2927274-11-tariqt@nvidia.com>
 <avTdfAaW9tlBRM34@devvm16445.scu0.facebook.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <avTdfAaW9tlBRM34@devvm16445.scu0.facebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: OS6P279CA0135.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:e10:3b::12) To CHAPR12MB999248.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|IA1PR12MB6530:EE_
X-MS-Office365-Filtering-Correlation-Id: a243c821-69b9-4772-62c1-08df4196e02b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|7416014|1800799024|261026121527099003|11063799006|4143699003|261102123227099003|261026140227099003|261028144727099003|261021121427099003|261009223027099003|56012099006|261022105027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZDCU5UrUV6WsvpIIbnD/sK0/810bO2Ln6mCUL81y9KxVNdvXgUoPgvaCHPoDDSw7vs1H5dxR+aQ2jFCCb8xkEkljFAZlEVYe/LfFZtBBIeAR1vwhq62QvtshD4d3HMkXoF1exsD+iD7zlL326jjzxmTbntY44f/pysNxKJq3hivLY4ocJglcezGfgzot+wuWzuCROfMQmzZ6ZFabqXNSemj3FTkIWlUBuJKmy8ncUAnQgimx5lJOIPkm9q2JV3w30x5ol+TtJeZDaC82XjG33CO31bF+0AoLdc+qRlRwzpLzio4AyovVVuznVOVn+FOl9Cbt6e37Afm/hIfeh04O0kUDcurMbkvH2mMwyEN+K/pm9q0DmjwPhd3L+42FSg+hlR+2kVTjkUILqo2qHKa6i6lTNTVXEAHrxXdByra2FOKQ+lJV8ZF6KWneFpEfo9pnq2a0UXWJvFKfnyUi2LBt19dpq+q9llwxTWQmW+WyE0UqbCDIY2kgq8G6rTZyUXfNuw8sZ6lPAx1P/RzN1oZbwGUWaQIk6LTWDzntt39GRag8foeiVDWTyGsGGk9DaRBJPq9b+SCMgD2NqzzucXptJZk7qIl4BjIeh6EWd8pTxTFVEe0ogzZAYRF2IrGR8gLCQrTtpuKRaNe1qOytY89+hD2zZFhNGs51zEkaoWaXDAM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(7416014)(1800799024)(261026121527099003)(11063799006)(4143699003)(261102123227099003)(261026140227099003)(261028144727099003)(261021121427099003)(261009223027099003)(56012099006)(261022105027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OU8rMWRsYzBYNE5lNnh1bVg2OGVYcDlEQk5WVjNpYmIzNm14QkwzY1pmaElH?=
 =?utf-8?B?bXRud0JqS1BieWs3MVpTeW9pOTNEbHZVTXBxOEdxdTY5VEc0WWVlalZKZE02?=
 =?utf-8?B?K0V0OGptRDlScnVPSmt1dTZmbmFEWm1zaG1mMnlPWW03cm8ranB1b0prcnR2?=
 =?utf-8?B?dldPVWVKZ0JkUmRBVUxlZ2RJVUJTenplQm1rSUt4eUN1dkIzNFduR254RmdM?=
 =?utf-8?B?QklWTENNbk1wa3dJcVpmQkxTQVZ2NE5oa2w3TitjTmJCMTg1OVFWN0FLa1M3?=
 =?utf-8?B?WUtFQzZURDVxc08rTWgxZC9RK2J0YTBnM0x5T2JjUXJpbU5Lditkc3QvQ2cr?=
 =?utf-8?B?alMxcEJxdXVhR2JkNXN5QS9DTUhVeExqQTBHeTVUV3c1bTRTcEdQNkd1Vmpj?=
 =?utf-8?B?U0krdGc3Vm96V3pFbGR1RFdvU1UzOHA3TUZqakRZRHlsenJtN3p3S3RQZzJM?=
 =?utf-8?B?Vm5hdTQrT2QwTXVzMTQ2QzdUay9sazlRMnFDemxEQlkzZGxEOWZuWVhUcFZF?=
 =?utf-8?B?S0JWZVpZZnFNbmFaNXY3ZnJxQ244aGRueW5MS01JMER1V3FUenF6TTFlRnVp?=
 =?utf-8?B?RkF0Tm5nWEFJNlVUL25lekFpeEorRWo5bUxLS0grQzN5aUJyOGRKYVcrRUpx?=
 =?utf-8?B?QXV2ZnRqT1MvMWdVTGYrenoxK2o4dm95YmExalpRdnMwZW8wdGk2bGZsTlRH?=
 =?utf-8?B?Z1Y4QzFwSkZGQkErQUJ1UUZkNTh4Qlp0OUpLOFA2MXZxSWdNbnBUNUx2emlD?=
 =?utf-8?B?TDhYOWYzTElKTm9WRnAvZWpQY29SaStSeHJXWGtZS0pHTk1IQmhZeDk0OVdh?=
 =?utf-8?B?blBlN1FVYlRORmhBNERCK3F0Q0pMSXlhcm10aHQvbXp3ekNGTnRYb2ljcG9U?=
 =?utf-8?B?RUFDOURCdlF1cWxtSExPUmM5QXZtYkZ1SG9XM2JpQWhUTS9zdGM4UUZ0OWI4?=
 =?utf-8?B?WmVWNVVveHNxK2E5enVJK3pIRGRoQ2dyNlBnNmFwdGc2UVEzVTRpam9ZR1Rp?=
 =?utf-8?B?WjhoL0QydFdaTUJnU2g2YXU0OHBJVDdLZ0dpTm9oejJtWXZ1RkUrYThZMHF6?=
 =?utf-8?B?TXRtZmJUV3lZNGhhSWtPMlppazNIY3ZCZWRQSkFPd3pmWS9QNjBJeDBEYlFZ?=
 =?utf-8?B?VlBqbFYxM3lGdWhKM0V3YlJwZ0c0eDVudFQvRC83VG55OHFLWXZ1cGFOQmV1?=
 =?utf-8?B?MFo1eGoxSnFxWE0xSmhleWhXdGFScDY5cUVqZnVMeXZWMWRRYjFUaHhiUGhC?=
 =?utf-8?B?R3N2VThzUkxIU3c0R0ZXZ0VhbmlKOHg0RlFaUDJRdzdQbktvODFvQmhMZHJS?=
 =?utf-8?B?ZG9zZEpKUldVb0djRGJrc2haWE9YTG1JTFIzV1lBbCtMamJFc3BVR0xkMDAz?=
 =?utf-8?B?cVF2a0I5OTZjMDRCOHQ2YlNzNVptbjdMcE4wVkRKREZhSmlWck9DenJLZTEy?=
 =?utf-8?B?MTVsMTE2dGhQdUtRS2hPdmowdThBNmJoQVg2NFpXT3RySDd6Q0ZBbDZkRkVT?=
 =?utf-8?B?VTBZL1ZDaU5IUkU1VUgya2I5WEMxMk1aR2wxNjBQVHRHbEpDVHJJT0h2QkNC?=
 =?utf-8?B?YVJwbG1tOTU1Tm1Hd2prTHJ1OGxQYVJpN3gwdkcvakFpaWtBVlBhK1B5SDhF?=
 =?utf-8?B?ZkxzY01BUGZ4UjFYTUdsaXNNTFNjQXorRi9BU0JWaWo0U2o3TDVobUlIY1hq?=
 =?utf-8?B?UEFDc21yaHNCZVgzcW5DcWRRK2Fpc2U3R2paK1Z2SUp4d2hKQTJnL1gvaUZX?=
 =?utf-8?B?N1dHRkZUU2lTS0t6a0Q0a0RpRnR1ZnRzc2JuWGJRWnplSnc3bmhjenNvQW9K?=
 =?utf-8?B?LzRLUFk3bTFQOFVydnRyWGw4emU4aXlCc3lld1RJVnd4TU4zL2g2QXAzVGhP?=
 =?utf-8?B?UEFESEM0WmRVaFZCRGY2Y2FlM3duM3ZTQ3FVZVN4RS9UODdCcEUxVW8ycGQ1?=
 =?utf-8?B?ZlE5MFRHdHJvaW1OcmpZYTgwOXhKZ3MyVisrNHU5V2lVWEZHMjlmcWRqelVz?=
 =?utf-8?B?TW4wTU5kLzhCQ2xyZXIwYmZpNU42ZUpUeEd5bGdFcnJ1eHVqOWVmNE1QcGM2?=
 =?utf-8?B?N3Jua0dVVGFZOEl2VmxVMTFIU2ZTSlB0ZHdZK0doYjRvbktkUTFObTArU3Bl?=
 =?utf-8?B?VHhRNTRTdk00cWNxZUp1ckxxNG9YSy9pL2sxNmw4Z080YldqUG9Ub1dmeE9Y?=
 =?utf-8?B?RVNEdEpSVlRlc0kxVk9TOVdkVFlQMG8rZDJwRThJK0xYclozRmRubmgxMkta?=
 =?utf-8?B?cHBZdVUxK3hycU1EUzNzeHRrWFlrdEY0NFF4SFliOE1CUlQ4M2oxRzBXMDFq?=
 =?utf-8?B?ZUsvd0p4MTZ4L2daSGRtK0VFWFBKdzhCU256Yms3YXZpMWRmNytGZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a243c821-69b9-4772-62c1-08df4196e02b
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 15:00:37.2987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nWl+GDHMWKvvqAkpwarkDY+DSi1Cxv5TAhmVoOB17x01q1bPkwGOwASXiWZ0RC1KiAcQ95haV8sjNjaTkwe42Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6530

On 11.11.26 22:46, Stanislav Fomichev wrote:
> On 11/10, Tariq Toukan wrote:
>> From: Dragos Tatulea <dtatulea@nvidia.com>
>>
>> Currently there is no way to check whether a dmabuf is bound on a TX
>> queue. RX side has netif_rxq_has_unreadable_mp() which gives a hint
>> of it.
>>
>> To help with that, add a helper to check whether a devmem dmabuf
>> binding may still be in use on a given netdev, optionally filtered by
>> the DMA device the dmabuf was mapped against.
>>
>> A binding can outlive the user's unbind: it can still be referenced by
>> in-flight TX skbs, whose DMA mappings are only valid for the device the
>> dmabuf was attached to. Reporting such a binding as gone would let a
>> driver swap the DMA device out from under those skbs. Bindings stay in
>> the bindings xarray until they are freed, so walk it and report every
>> binding of the netdev that is still mapped. Bindings that were already
>> unmapped are not reported.
>>
>> This API is necessary for the upcoming support of data direct in mlx5e.
>>
>> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
>> Cc: Bobby Eshleman <bobbyeshleman@gmail.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>> ---
>>  include/net/netmem.h | 24 ++++++++++++++++++++++++
>>  net/core/devmem.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 67 insertions(+)
>>
>> diff --git a/include/net/netmem.h b/include/net/netmem.h
>> index fb693bc1702a..35bb6fa0f719 100644
>> --- a/include/net/netmem.h
>> +++ b/include/net/netmem.h
>> @@ -397,16 +397,40 @@ static inline unsigned long netmem_get_dma_addr(netmem_ref netmem)
>>  	return netmem_to_nmdesc(netmem)->dma_addr;
>>  }
>>  
>> +struct net_device;
>> +
>>  #if defined(CONFIG_NET_DEVMEM)
>>  static inline bool net_is_devmem_iov(const struct net_iov *niov)
>>  {
>>  	return niov->type == NET_IOV_DMABUF;
>>  }
>> +
>> +/**
>> + * netdev_has_dmabuf_binding - is there a dmabuf binding for a
>> + * given @dev and @dma_dev
>> + *
>> + * @dev: netdev to check bindings
>> + * @dma_dev: dma device to check, when NULL it will not be checked
>> + *
>> + * A binding is reported for as long as it is mapped, which can be long
>> + * after the user unbound it: net_iovs of a TX binding can still be queued
>> + * in flight, with DMA mappings that are only valid for the device the dmabuf
>> + * was attached to.
>> + *
>> + * Return: true if a binding is found under @dev and possibly @dma_dev
>> + */
>> +bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev);
>>  #else
>>  static inline bool net_is_devmem_iov(const struct net_iov *niov)
>>  {
>>  	return false;
>>  }
>> +
>> +static inline bool netdev_has_dmabuf_binding(struct net_device *dev,
>> +					     struct device *dma_dev)
>> +{
>> +	return false;
>> +}
>>  #endif
>>  
>>  void net_iov_inc_ref(struct net_iov *niov);
>> diff --git a/net/core/devmem.c b/net/core/devmem.c
>> index 5c7d9640e9d1..dd3987bbd9f6 100644
>> --- a/net/core/devmem.c
>> +++ b/net/core/devmem.c
>> @@ -513,6 +513,49 @@ struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id)
>>  	return binding;
>>  }
>>  
>> +/* The attachment is cleared once the binding has been unmapped. */
>> +static bool
>> +net_devmem_binding_mapped_to(struct net_devmem_dmabuf_binding *binding,
>> +			     struct device *dma_dev)
>> +{
>> +	lockdep_assert_held(&binding->lock);
>> +
>> +	return binding->attachment &&
>> +	       (!dma_dev || binding->attachment->dev == dma_dev);
>> +}
>> +
>> +bool netdev_has_dmabuf_binding(struct net_device *dev, struct device *dma_dev)
>> +{
>> +	struct net_devmem_dmabuf_binding *binding;
>> +	unsigned long xa_idx;
>> +	bool found = false;
>> +
>> +	netdev_assert_locked(dev);
>> +
>> +	/* A binding stays in the xarray until it is freed. binding->dev is
>> +	 * only cleared under the instance lock of that netdev, and the free
>> +	 * takes it before erasing the binding, so a binding found under @dev
>> +	 * stays alive while the xarray lock is dropped.
>> +	 */
>> +	xa_lock(&net_devmem_dmabuf_bindings);
>> +	xa_for_each(&net_devmem_dmabuf_bindings, xa_idx, binding) {
>> +		if (READ_ONCE(binding->dev) != dev)
>> +			continue;
>> +
>> +		xa_unlock(&net_devmem_dmabuf_bindings);
>> +		mutex_lock(&binding->lock);
>> +		found = net_devmem_binding_mapped_to(binding, dma_dev);
>> +		mutex_unlock(&binding->lock);
>> +		xa_lock(&net_devmem_dmabuf_bindings);
> 
> Sorry, my cache is already empty after c4466d2c3e77.. I wonder if it would
> be easier to change kfree(binding) to kfree_rcu(binding, ...) and then
> we can rcu_lock/xa_for_each here without xa_lock/mutex? All we care is our
> netdev bindings, and these are not being changed as long as we
> hold the instance lock (but the other ones are now concurrently freed,
> hence rcu so we can safely do READ_ONCE on the binding)..
> 
> And then the same applies to path 11?
> 
> (trying to keep all the complexity in net_devmem_dev_unregister)
Done. Will be part of v3. Code does look cleaner now for both patches.
Thanks for the suggestion!

Thanks,
Dragos
