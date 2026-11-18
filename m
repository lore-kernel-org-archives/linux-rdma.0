Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795011909;
	b=cUwPgsHd0HGNNzE+26Qfr7yzG94eRTWH+Ivo0lXoTL5h1LmxEJr5bgAluZm2fSAZRI7B
	 vW/amU2ZZUkIFU48Namomk1W0PqtyDwUKib9tHewzsquYSugXcSICT1q47iZ9dt64L9Ny
	 fD1bAI1RIl4F2OUYAm6s6TuzMafYBy4ATrgPqj1Xfl4Ywx5oeOWVboNDUD5Mbx+CqjcYo
	 33+QAJ9H1bXoLVzO5qMHq9Y5Xw8SiVruyNJuXQTzq5N8PXQqVxK2j46JWISPBZNvwiAO7
	 XqfE6nkzhj6RYWhEK26+Zm5oI+Vld32EhNse/014Zp6XOjL4vg/O/XJjKzF01H5s4UA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795011909;
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
	bh=HOkGIpn4D/u4Pt1ak+bWg58+K5y+4w4VFkFPXMULy7U=;
	b=o59dqnkfx7e5b0Y98c2a0LdFvzTfvbI7Nxr+SurGXTed3NEsZCFe+PEcuJA+dgQ9lWBf
	 ubMBDpsDsUsfkSlcXoGlEGFaQPpmQghplcuTDyCfda2+loblqwTd7kZGxAHz9Ubp0g2ND
	 9+9FC2KYn17PAJyssL5itkSmRQeIMj0BDwx3uL4jTvGrQK3Rc+7C+gTn94LFm7nxCF79x
	 HdxXtphTSwEhkfL+dzmvi52tT+j/Tuw3wsOmTKvRoANaUgBXj8+Bjh6ago9phN0gKSSnl
	 vVac6d2KcwjFK63tEdW3Ib37MvDMbiOahC+Lmav/t2HysXFIkbv51/toykRxbiocrbg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VOXMiI39;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.11
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011011.outbound.protection.outlook.com [40.93.194.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8276660A2613;
	Wed, 18 Nov 2026 14:25:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8276660A2613
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VOXMiI39
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fBdt9z5PjyuFaRcHdRCnZQxwh0o1KNMucMTUSrYB97PzlnvAu7xkjOez4tJV1mSwj4mfQfZd595zPtPaduzDG20OHg8m1CQApA1dOIxKxn37xgV0HH9LaYw9BgQhLq3hItSCKiYertPYSqPyrR25Si+GHXMNFgWjm2cyOIfn7bnycb9mDJz77b19pQsBkyPA6vZL0BJgHQmr1SStV91B9PZa+Z03GeEAMroeR3I3eD9vPDmmpDcH9vyhE3OxOXomn+4YIW5Oky6Xzrs8TJmfhb5X1CTcwMYhSA1eYvUb7gPC53IpSR4HM/gvPaAikyZaKPLVelqhdE39EqklNb47Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HOkGIpn4D/u4Pt1ak+bWg58+K5y+4w4VFkFPXMULy7U=;
 b=XHxT5gX+aT3qSI7pfiS/uktc0MCqwPvGuQ6Ppr7Yr7qOmZDVJCiA/GDDMbi4gE0kKCNhmPEO04kCqeTNV2D2vMt2h+QXKvVbCtQOl4gvsGkC8KYveTOL81jOWv9xMPdL485Qi/fZuiO2Xb/5oJJc19EM13GTdO4QYEv8V54oF0I5/NiFzTCOkFmh6g+cjdBvinkvqFkcUCS/VzfEayvgK9IRX5d8zvdXkJLujRZemfUNjig0ebcU62hn5Oyfrj1an+x3QD6+2I9UJhHshu08UGur3vr7jgPzuolCLp35/PdLKN4dYW7CH1o2ziaDwvdd2JoYPEkXdWszRy86dKMlYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOkGIpn4D/u4Pt1ak+bWg58+K5y+4w4VFkFPXMULy7U=;
 b=VOXMiI39bCK3inoQLOjVoPY07bRsW+2KXnpya4XcgjU844AE6wr2WuRY3HY6wukwFGMrf9+GLNfKErjvcGdk3BQnU57CT9MGS1NF19HRpyAjQlFSlnpj2tOZtL8N0dtnuQ6uaewzaCQLqW0uhD+6rVPA8drqOnTRqy6gMRvQFKWPTqLccmLLRS9zPLm2SW+sbNiOwUNt0DjXamppfMksuFgEhKuAvf2oq5MfHvlydrDcHRzUaBBDyqyurbdzdyl7br37110kuN/fcvI1uklufq9iU5cjyLN/2OWMhwu2pk/vuwmpOil2cZkAoe2TdA8TiPxM/ZmaMDLzWr7X9TBHQg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by LV2PR12MB733495.namprd12.prod.outlook.com
 (2603:10b6:408:423::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 14:25:02 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 14:25:02 +0000
Message-ID: <906302b6-facd-43c4-872f-ae40bc59714a@nvidia.com>
Date: Wed, 18 Nov 2026 15:24:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v6 8/8] net/mlx5e: psp: tso: replace only the length
 in checksum seed
To: Todd Freed <toddfreed@meta.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>, Boris Pismenny <borisp@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>,
 David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@kernel.org>,
 Ido Schimmel <idosch@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>, Leon Romanovsky
 <leon@kernel.org>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
 Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
 Sabrina Dubroca <sd@queasysnail.net>, Saeed Mahameed <saeedm@nvidia.com>,
 Shuah Khan <shuah@kernel.org>, Simon Horman <horms@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, stable@vger.kernel.org
References: <20261117203137.804424-1-toddfreed@meta.com>
 <20261117203137.804424-9-toddfreed@meta.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20261117203137.804424-9-toddfreed@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P251CA0029.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::34) To CHAPR12MB999248.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|LV2PR12MB733495:EE_
X-MS-Office365-Filtering-Correlation-Id: 60af73f5-8cee-4658-2102-08df457fbb69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|261022113327099003|10067099003|56012099006|4143699003|11063799006|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261026121527099003|261102123227099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dz0hdrKwQAKUkrgJcperRd30kzfhGWyP2XxEmK465QC0BibnbtTD21Rmhkn/NoV5SZRLaB5qbCsw0us4iDknGCAkeHqX4pnwPvfaYCGMt3PdMP7iiVMFVtiigYrMxKsBmjOovv0duggYlUa8WnwPzPQDX7nG2y71X62C6mj57dd/gjQVKD0rBy+MBiQt0yQaq7zjyRDqeNE7v/4LZI2CAqTD03WPEwk4vQpdZm7z1nvQ730CKCexUB7H5wUM9vf2jUZFQh6c9KPCWn9T8SQvYoEN20J14w+tffRPjBrtyAFxuHowspZd9s+xa6S1OHh148Viq8vRs8dl7TIwVXcROoeCbqIML2ttGlNgogwDho+kunT7DcGwcvWHCe8fSlfqbdhe4m91kj2PT3eLuk3IB+9nscT6EqF7EWoKdfb5o/w3NJPIZIzHaOcTRouoBUceNOz1IwW7ESl99pbhFqbAZcEZLiS1fVfWfTt5ZRITN5jhewckyd+ROSEDTSU7JtVc99k+RVPfCyzvpabchlSVeZWfN/qN10yaKiR97+ifOWMnAOESb6fxj6qbVqsGa9xcJdCT2hvy/Q3dlny22hCTg4GQudGRFvjHZmQEnhyTcnvARJady792FVFAgy6M3HMyIyH6maKY8kRcRFeJDxtUXQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(261022113327099003)(10067099003)(56012099006)(4143699003)(11063799006)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261102123227099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTcxaHVEWVp0Tm5rWUljbTFtZk9oUnZLVWdwSm53TGgxeFFkZXpLOU1GMEZ1?=
 =?utf-8?B?ZFNsQkNPZlR2NDI4L0xqRXU4ZDJXVjhqbWpOREQyaDdIOHBqNmNZenI5OW1y?=
 =?utf-8?B?L2tkaU5mR1d6VTlEdS8rSXY4VVFmUFJCNkxGTW9QeHpJSWxYR0ZKVDAzYzBr?=
 =?utf-8?B?U1dwUUhWSXdBeUhkU0JEVlZTTlFlTm4yLzhITXNITkpLbW0rNURyWWNEcHV5?=
 =?utf-8?B?QjVRem9weEhOWHdBclR5T2ZiSjJPa09qKzJvTmdxalg2Zm4zd1pJQjhENmlW?=
 =?utf-8?B?aFZMVkVsWkZDTFpJUE1BSS8wMFI5bnlnS1dIVC9RT3JQdEh5d3QwMXRlek1K?=
 =?utf-8?B?WWhham50YXdwMU9oZzB5Z08vQW5jNnlnb3A0OUFYTU1kUXJtTldBWnBjSzk2?=
 =?utf-8?B?cENiTGNheTd4bkFna3YyRjVDTjJKb2tOeXhMcnNpWFdzK2gvWXpQMEdqZk1B?=
 =?utf-8?B?RjhtbS81SnRaeHRNK2Jmb0FGTmFoVzN5NXpLcVZ5MnRPTXZFemZXY043MXZw?=
 =?utf-8?B?RUFadGw1R3Y2ODR1R3NjNzhyR2FRTmdoYk9od1ppWkRjSnlsY25ZdlRsRFJL?=
 =?utf-8?B?cXlOSFJuL2J3dU5qM3J2M3VwWDB5d3N3UWpkVkhHMmtwWlU5QkdTZGN4b1NK?=
 =?utf-8?B?NnVRU3lHc0dsVVVNd1FhRE4rUkphcEpVNkdHcFJLYTlyMW16Wk01eGdkdVVY?=
 =?utf-8?B?dkt5c3ZuWDlVbEFnQVZ0cUdORmhVM0dCcXVwTjNoT2RpV2FIT1FmV1hoUzhN?=
 =?utf-8?B?KzNuN3c5WXJhRmZUZUdTTmVObXkzb0l6QXp1Yk4ra3UrSlRianVIRUp4QkF5?=
 =?utf-8?B?TUYzNkxqSjB5U1NvMVpNZVZISUlrcTlrY1U0V0gvLzZmb0lBc0EvTUo5UUxB?=
 =?utf-8?B?NUhLM2N0eVpENkFEajJrSm00cXFZdktWMzY5MUcxMTdrVEZFZ0VGUXZ4Wnl2?=
 =?utf-8?B?bDFEUW1nR3BUT0VUb2VTNjk2OEVKSDdmOCs4UVJxdlYzMUM5K0kyY2prQk41?=
 =?utf-8?B?aGVKaEJULzhLQkVZZjAxSSthSnhMZHgzNG9nZHh1WVVHdXhITjBaTUdvWVRU?=
 =?utf-8?B?dWJuMTZkVU93THZpTjh1MUg2TjdZWWtVS09LVUU2WTJFLzRraGcwQmhxaTlO?=
 =?utf-8?B?R3kydEpFck5DNXhlU2k5cFVKaEk3aVBuWnhzZlpKY3VtenFmVFVSNFM3akpw?=
 =?utf-8?B?NGxjVGJNcGUxNm1RQkRCL3RSV3BEVi82aHFMLzI4NVI5S3ROZ3V1YnYrK2lL?=
 =?utf-8?B?dkExRDBmUUtPMW1KNHVWNHhpLzFyL0Vvd3hwTHpySHJETFpuVlIwa2hIOGxT?=
 =?utf-8?B?RTh4OStZLzNROHNZWVJ2QW1VWUdMaXBXWmJiNm8zeXhjRmtyM0VIVUFaajhn?=
 =?utf-8?B?Q09DYnJ3R2VhNFJGMzB2QVFtYUlhLzZNTHBHOElURWp4WkNDRnVERWtwZURk?=
 =?utf-8?B?dGZLandtYjRKQ2tkQi9CN1BIWmtBYjJxZHdWRjk3SzJLM01BYkhqcUFHL214?=
 =?utf-8?B?L1ZKaGNPSVM2UGJsK3IrdjV3RTBtUmNMb3NCeVJQRGNPd2pZb2JHUzI4NldM?=
 =?utf-8?B?NjdRV1BFRUlvUFgrSFN3d0ovb3dwdDkwQTU0d1VLd3E1STZpR2E4MFVBc2pH?=
 =?utf-8?B?bTlYSWNsR0FrMmU2U1h3MlJ4WGU2cllVQUIvZFYrOW4yaE8zd1BDSEd0TlFn?=
 =?utf-8?B?NmI3NlpKVEpOcGJVeTlCRE1nd1libEQ0VWN5Z2NpM3dPZWZ6NjZucnN2TDhU?=
 =?utf-8?B?UVduTXl4aFJwZHN5NW44TDkrdHoyL29wZUNxR0VWaXNMM1BEVVhYcHd6cTlG?=
 =?utf-8?B?M3lnZkFlb3VDdjc2ZjZGM2RHR0wxbXFDdEE1YUI5OEk2ZmtOV2dhSHNEbHJZ?=
 =?utf-8?B?UW85VFVSTWhmZGdHT0V3QkVyeW1KNDlma1ZiTkE3ck5BYkhkTG1ZanNubmp5?=
 =?utf-8?B?bkdoM2RUVlY2amUwUHAzaVhkWHVodGpJaUxQSmo2SEhTa3lyMkpHT20yQzFl?=
 =?utf-8?B?ZHNYbUo3WHVkZkVIL053OFR1VTgrSndXaVNDaVlFV3psdnJiN3Q1WTkxaTNT?=
 =?utf-8?B?QUZXNStzaHNvY3BibmRhYnJBc2FhVmpGRzBKbFlXNFB1N081UjBYeFczdkhW?=
 =?utf-8?B?ajkzNzV3VWIvRVkxK1k1dWdsWDFSM2pVaVN5a1ZYeFNzcE5uS2p6T2ZHVzBL?=
 =?utf-8?B?bEp3azdUQWtZNGVsdVJyU0pVR3FLWXJGa2h1TjRoTDZGWTNJVzQrbm1CMFBP?=
 =?utf-8?B?azNsNlJCeWlTdTVaWSsrK2JmdEx6ckZ5dHBUU0xNTUcxUGU1UW4rLzAzeENz?=
 =?utf-8?B?bTI4ZTRZSGJ3aW1OQmxXa1c1UVdydmY0cVU4ZmxKbURZbnJteGtZZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60af73f5-8cee-4658-2102-08df457fbb69
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 14:25:01.9311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I9cTPXKuDQ5UDbv63ffZl8J7PNZLY2euS8enOl+6LbihLsPgyIJaj3vIv4IW1kAzrzk/cwF1ngF6M4syXJ6DzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB733495

On 17.11.26 21:31, Todd Freed wrote:
> for psp tcp with tso,
> 
>  - __tcp_transmit_skb() -> tcp_v6_send_check() or tcp_v4_send_check()
>    computes the checksum seed using the addresses on the socket and the
>    total length, then
> 
>  - mlx5e_psp_handle_tx_skb() recomputes the checksum seed using
>    addresses from the packet's l3 header, and the length of one segment
> 
> the length difference is expected by the device. however, the difference
No cap in first char of sentence makes reading the commit message
harder. For example is this sentence standalone or a continuation?
Sorry for cramping your style.

> in addresses is incorrect in cases where the l3 header daddr is an
> intermediate hop, for example,
> 
>  - ipv4 source route option (IP_OPTIONS with lsrr or ssrr)
>  - ipv6 IPV6_RTHDR header (conceptually ; ipv6 extension headers are not
>    properly supported on this path yet)
> 
> in these cases every segment of the tso packet to go out with a bad tcp
> checksum
What did you mean with "to go out" here? Goes out? Or is a verb missing?

> 
> the fix is to replace only the length in the seed which tcp had already

> computed. this is also what tcp_gso_segment() does.
> 
> tested on connectx-7, with a psp tcp socket whose ipv4 loose source
> route's first hop isn't the final destination, and the peer checking
> tcp checksums in software.
> 
> Fixes: e5a1861a298e ("net/mlx5e: Implement PSP Tx data path")
> Acked-by: Daniel Zahka <daniel.zahka@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Other than that:
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>

Thanks,
Dragos
