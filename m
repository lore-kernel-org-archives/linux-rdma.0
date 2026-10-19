Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792435454;
	b=GYIkKRvT5YiuamMau92Ou7h3ItoYBMSjts44FV/L4UQabtVZzzmuvwbPMS+ZSBMq+KJz
	 2aR/xoairZgvJHzxLHnWMzDxTFksuVZQt4+b14OKXiJ+vxVY1T1WHYU6UHbfm/JHzyyN6
	 4O+1rFnyoO0/eMii6iRh7BrLnG1xyfhBUUFdh1FP9KDdlyvxBtY70aFDH+i6RsYvU+5Qc
	 hJie6xm50JiqX1cNxYmIq3E/vqrXfNRhX0S9W9/WnH/zs6qefYiPKOh8VsnCLgqSuiNTb
	 0nE9mGxRLjiRNG6B4QVxHvfjVp0yDasMYstzc5gLLUkqs3sb6upJFUx8AIB05u925bA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792435454;
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
	bh=84xH1Yx83+lBGTO3uv4rmFQj8uFeYRdxA3QwTQvY37I=;
	b=XQmn+JbZnzBrjX+0ZQ1V6SkPENDM2up5LFW/LoMxrLgwpaUlRh4slg7Te3j0MfG5r6uI
	 9n0hnA6+UmIukq6fOlHDr+0968BtL5BXsjd1MEg/otW5kuwRQlSWYNWGEXVGf2m/Nm5Eo
	 /LSrHVnkvx1KynCdgezpBtxYWQcYA+/+do+xcpJFntT/wVFsRVic9ufEfwSlYxQx8x8hF
	 KZhz0D3VCL/a6m69LlyKIIYixWvcHJ+8Z0nZBWvL4SKJgL7hMiUprx6EzIdqp/eJZuyTH
	 dTJ27aDHOob9dQtYwuOsQSkOfvInFyHEONSyG/GQSb8s77R2L/e1xk3ySFBQeAjVOSg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MDyV9q7f;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011051.outbound.protection.outlook.com [40.93.194.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B43E606A319;
	Mon, 19 Oct 2026 18:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B43E606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MDyV9q7f
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YgHwSt2RPJ/Ugnpy64f3Xsm+sVohwRMxan/vDud1QxqV/ZL8GVZoN7V2uUzZ3gDnxG09Ld11tDRxYS0kYu9VbxBmCtCQiT+D53+eSuAn2QQgcYf4iWT5I4hxJAQRvE1ubN+RUzA4Gd7AgNjr2s6lPIjF2VaiceGavinhRckcD95nH+pDaqIdyuLazknXmitp5/s6DK0rgfOV8mtx7RNMErvHRP3OfGvYza+rMLabzkQ3PdLVn0h5/igP60HcZgn57ULrZjNZYmIgjRM4xzqAYbguhzhFc1CPwLT7wF6tecTvEsF7M7qyFnk3EWmhWZ52jZY8tyuPcW3aGZzk0o/d4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84xH1Yx83+lBGTO3uv4rmFQj8uFeYRdxA3QwTQvY37I=;
 b=l0C7RfjSjSZc0tHDwwl46xZY3D98NI01L3A2hxulYclQArcVz2nlqZXfRybA/4mmAeg++AH8NPeu8oihxqP5vTXLsCT3jyNI93PLYKxVjap/y65dTotjRyJI6HQ/sU5KcyQgfAplWtloG+eVIkUgnxrHFB/EZ1CG1wPlYci15wHpULedoiJyJQijRqdAdM2JHlAkuk145iFZ/2ABNZChGrvH1gSC83xFF418czX0noULRLelFmsZxX8YLkEk5rpafQd9cdzrWIpucPn8OLYS8EVzgjqmxOcmq9CLSHTdYk6DLEcS7acmPICNobQkctVq6AvgxMmbsXt2kq8wdEo3rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84xH1Yx83+lBGTO3uv4rmFQj8uFeYRdxA3QwTQvY37I=;
 b=MDyV9q7fPlBWscKA/ESDQnNFW/SE2hXRi69QuureMVYtS/OdCfOdjW1HNY+gy66XoG7yB2Qaq4jVeHUPrQMvu95uxzNDJ8/DZ84kvp6oqLhg4ZkMKNtaNr/jiF2PkLBrwOjOx4jP9vDmOxx6CIcxa7DjaEQs/5KY2OhNmG8Tzw+7kqmxIsrU4ZgAM8bTl1ObKXy/5qrhodTJg9yPy3kFbIqN5xptrNvHgMEZOvO1fDWJ1QGzCjjwocBQy2RH307tKVWdoabYn1hB3tDX8gjRIQTvmfGZ4q3GD+Qoz8O78GMv3gp5wW44QvLgUInOBf+s5iTmzAT935XpCigdPJFp6g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by SA3PR12MB9197.namprd12.prod.outlook.com
 (2603:10b6:806:39e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 18:44:07 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 18:44:07 +0000
Message-ID: <327efca9-7df1-437f-8040-a244111d719e@nvidia.com>
Date: Mon, 19 Oct 2026 21:44:01 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net/mlx5: Remove redundant memset after kvzalloc
To: Simon Horman <horms@kernel.org>, Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 Mark Bloch <mbloch@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
 Sabrina Dubroca <sd@queasysnail.net>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org
References: <20261012150311.555104-1-ekffu200098@gmail.com>
 <20261018151325.GP503057@horms.kernel.org>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261018151325.GP503057@horms.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0025.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::20) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|SA3PR12MB9197:EE_
X-MS-Office365-Filtering-Correlation-Id: f6677d64-36b0-41bc-c331-08df2e10f4b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|22082099003|18002099003|10067099003|4143699003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Yo6E1URAD1jWkUOX8hcD9o7ReEMYGb7V617BxzwRrbmqthWUaE+59m7Yjd55SMq1LDsmjEQxUlsydUglaR+GOwK9Bsuh3dkw7YaQW3tCo7i+GLZFIzwEK13cB9dTe8lpmaJTq+sopdF1dAy/bGM/yam3alPweK602/tcCkk1HEq0cbIonSZCJfpfFH9DuKYhymK7Gpje0b7plOf7D2Q45zUnkur/9k/YZpg5acvxzXErK6INHxRuYczGEEjeY3hzwvUDiCbwXiRPMB//+hAqyVtZBj0b5WkL7UxdjoXKAoTPFuObWcPforpZxgSlvOdT0lytC5yPjWuHugozBiO3wKwTgMtgXFZ7w/HenPR2+2K+Wxe9wryj0SnY/Uq2bIP1pl2cSygRinitO8wPzGBpkC89sYIwV7ii/PmHcoIYOlhwh7LsyJ5a7WgCr83FoV+RcUR9ugwfhPW+9PlYIBu1Mur8otzV2w9hhACEHXR7nXU8LcX9UNU9BiV8vu8xCS5ambnkp+HdNHrKufffiKXvBcIFtmisdRIvrxYz8IjywJAKCo/xm7K/Pj4iDAFbeUODM8Qep20dsNq8srYDjmnQunTS90mJM+4wwYgl85NBUv/wABaYLr+qYzlD5wdV5C/FWp7NwGH/xagtUvl1jx9VNNYhfleLEOCUyU4Ja6HThoQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(22082099003)(18002099003)(10067099003)(4143699003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NS9kV3VBWGNhaWdSRGRhcFN0QjRLeW9haW1mMlhnZm1wVnR1ckhHR3NDMmF1?=
 =?utf-8?B?Y3dzSGlicmZGR3JXcnJVUklGbmpOWlFzUmNXK0JhU0hDWkswdnpocE5kNzhm?=
 =?utf-8?B?eHVsa0N6VFd5Y0xYYWZsbkRSVzczTFJJQk94alJWY2YxTTNWcllpaWFNU3JC?=
 =?utf-8?B?RXlBdEg0MTczZm9ERkJ4RERVL1ZleVRWa0lLbHc3cHBHMkhSVzIrbkttc1o4?=
 =?utf-8?B?Mmt4eE9tS2VXOFpjeEVkeVNoM3Y2cW1TcDZ4dFB4UWJteWhDN0FkazJjOFZi?=
 =?utf-8?B?WjZVQS9HQ3M0WWNvY05ZQ2FRNTJzNTkwWFQ1RFZ2dXk0b2ZIak96NzgvdHJS?=
 =?utf-8?B?djJCT1NTbjZUU1NRVEU4b2FBcDAxSGdFeU9EeHpuTEgzT0QvWkhDeDZORjd6?=
 =?utf-8?B?KzUrVmlBRXFxL1JNcVUrMXVYUG96QW94a1UwUTJHNDRGVlhTdVNoU2tYVzVT?=
 =?utf-8?B?M0tLQmVCeW5mekljVExJMCtnaHoreXNQT1ZseDVYMjhsN2ZnUmE1NmpyVTBP?=
 =?utf-8?B?eWJ4WmI2WkZBY2ZqaEJKbS9jWUtIcGpMUkhrMlJ6UVRTQy9LN1o3dkRjQlRF?=
 =?utf-8?B?S01seXQybmp3TFpJRXQzSEpxNVBMQW02QTlkWTlYbStEem5Sb29IWXlPKzdW?=
 =?utf-8?B?VTFqMlhtZmUvaU52dHlGaDJQSDNoN2NGSCszRGtiZmw3b0kvY2haK0YyMElu?=
 =?utf-8?B?OGwyRGtCTVkxWkZOaGtLZU1CQXJLTzAxL0I2NThSVlFiSEYwSTA3WFJucGtW?=
 =?utf-8?B?TGsvdWRKVUt5T21oZzhvSjMzaVNFSk44K3kwekI3QmxRTWFGU0NxVXNRaUY1?=
 =?utf-8?B?QlB0bU5VNVJQTFRNTjVBNEpNTkkxZElBcWVZTndxd2o2UjRhbWNZOFhRcFlj?=
 =?utf-8?B?ZFB3RnAwYWwxNVU5RkNzOURXdkFCTWdKNHZ0M3gwMzR2WHg0Z1dJSjJHUEU0?=
 =?utf-8?B?cWNyVk1QSU1maGtBb2pySnNDOW1KUUdFTHpuUmlnaFVENEJhK0tWd1NSMkZM?=
 =?utf-8?B?K253SEwxS0tnTHNGRkRhdk9QbUgwTjdLZmRtT0lvVjhqRTRzRlBqdG1qdmVa?=
 =?utf-8?B?Qk15MUZkMGhXbkcrM25OU3NjS2s5SGdJS085ZEZTRFdrYkxoUGFLNWY5SkN3?=
 =?utf-8?B?T0ZzOGJHNjI0eVB5di9UV3NlQ0JTcEZKbVFpZ3dQd1lCakRUcHNVbkpHazJ3?=
 =?utf-8?B?Ym9XNGgvQzhRWWZVcy9jZkwzbk5JVGh1NGNJL1JMc1pldkdBNWw3Q2ExdVFN?=
 =?utf-8?B?T0FLVG1FeURuY3NGL2RLY2Jxc0NlTkVzU1lReURhVjlBam5PRHV5YkdQK2I1?=
 =?utf-8?B?SFFUM09KMStpT0VtU3pnZXJTSDQvQkJKbFQ1aEN2Qk5INWlkS2FDRmsrTTFo?=
 =?utf-8?B?dTFkZVVRRkRST0RkMmJobm9sUUlJTHVodHRuVUsxS0l3TW1SdTlFOGxGbVlB?=
 =?utf-8?B?SlVkOEFhNEh0eldZTk8xYzR6NlBvLzh2RE9lV0RlWUZTcEpqNDAreWRpU0Zu?=
 =?utf-8?B?ak1PWGg2d3BvTXdXcEhENFFvZEFPcFJrM3BsekV3eENmTnU2RGY3YTNFbGU5?=
 =?utf-8?B?QWd2aEtXd0liQXY0eWFBS3VyN29PSHNwQ25YU0FIaG5qREtieDUvSEVtU0tQ?=
 =?utf-8?B?RWFLRmx6clNvZTdOQ09zbVp2WXc0N1RocGYzbkhOcHdEc0dzN1BKa3ZTUjdv?=
 =?utf-8?B?M0JpaXFDNWRSaFhwL3N5MFBPbytVaHBrVnh2TlZ4VjR4VUo4TEpEUnpqQ0cz?=
 =?utf-8?B?a3ZQUmRVNHg4MlB5WXNYblRXdFlDa3FhSG91cm1FK1JBY0pvUVY3Q1ptRjVN?=
 =?utf-8?B?SW5GZlYwQ2s1bDIrVC9HcEZRY3ZVOVBUZnZGME9FN2x6dVZ0T0EwUklmNzZB?=
 =?utf-8?B?NUFjZDFlOHdqWXZ4SlJzY3JRYTRweDJ1TzhDT1lRZHh3MkNRdzQwMlZwOGNx?=
 =?utf-8?B?Y2hUWUI0UFVhZUR5VVgvTGppbnptZjArbUhreU9wSllLVEFvcEU4a21ZMkdY?=
 =?utf-8?B?Y1c4LzRyZFVvSVFoWkFDeE1scnV3eFE3b3NpNHBLVkpCRlhMdFJhV1ZlcFNS?=
 =?utf-8?B?TkNSU1pCekRhd3JPVkhoU3Z2Q0dNRzdYa3BtS3oyMXFoQ2MxcFFVVUEwaERS?=
 =?utf-8?B?VEtvYkZtUmI5RURNYUVOVEFRTkJPRG5NRTNvS1kwV3ZmZVhqcUpVTURiSGRG?=
 =?utf-8?B?ejloSFliVlhkeDVIMC9qQXhGREdPdHFSRmNRcmtEZ0dVRkhYTWVzUjFFS0lT?=
 =?utf-8?B?cDUxdEd0anBSbGdHSmZvYVpOckU4OU1nczlFb2JVb20zQ21NeTVaazRZSGlZ?=
 =?utf-8?B?QzBDZm1xY3JNeHBIeG9GSERtUUgwS1JwODFsRnMxZTRMemx5MzdQQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6677d64-36b0-41bc-c331-08df2e10f4b3
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 18:44:07.1390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJ0hbeD8rcG/YkFvk3Sa1n6cKmKd3oK9181FX85R+42mFLPisP3u1TGOyvaQ5wOzcFalaINtUfKQ6NhOvjaMZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9197



On 18/10/2026 18:13, Simon Horman wrote:
> On Tue, Oct 13, 2026 at 12:03:10AM +0900, Sang-Heon Jeon wrote:
>> kvzalloc() returns zeroed memory, so the memset after the allocation in
>> mlx5e_post_meter_create_mtu_table() and macsec_fs_tx_create() is
>> redundant.
>>
>> So remove the memset.
>>
>> No functional change.
>>
>> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> 
> Hi Sang-Heon,
> 
> I'm not sure if the value this cleanup brings is worth the churn.

Exactly!

> But I do believe it is correct.
> 
> Reviewed-by: Simon Horman <horms@kernel.org>

Anyway,

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
