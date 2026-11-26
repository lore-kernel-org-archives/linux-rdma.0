Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.61
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795718127;
	b=J3/8LQ1XnmLi7B7rIy+LaXTz9gPk7F0fboKoqr0wthNJGkhvwsXzHxAOR4vomwLrQnJ+
	 OP6APbXiQ2bwhwVLKCIfMT0sKUOtmEcBbRz/szgCRGmcSTQYK917+r9XQKDvMNYf0h6N6
	 iTDtEe70V1uNTxh6PQhsILLzPbPYmBAt73tXpxgRGsm4Gwi/yTxjttsBOjoiFse+MsW4K
	 dBbXJVJ4sVfm/Svii48T+/BlaUKTNSa3IW71VWYaZNorunyvuWLlv2bxC5okW7TFPHWDk
	 cmE1Vu0LCk/gkNIfm/WOJ7leilh2PkOROTzrzlckpjkNvMH/s2dIcy1Vv2HtqvcY17w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795718127;
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
	bh=dtNGikoQZBwXBTRU0hKkPA0/G37rLWHt+tuMUfY3VC0=;
	b=datZNokkAq4mNGsvQZQ6Fz2OYRIe0+ffhPyOSNbh/Z3DJ6XSyKiSfmEjPUMJG8ceGil8
	 b+5NrJRqVQb0u4LsTzRdEXCY+QHiRKCPq/bijNvjXTXLLtzGvp10/653m35eoqqV1cgoP
	 2nwSN/3UK90BMQa5aWwlGux/9tG8mtgTsj3LR2mC9nhZg29jXpzNz0heTYvnjSXWZpKWB
	 t3uQIVqNjCMC6WKelzLG25ZpkEuOe4mWXNMQqJN/SDg8KXkBWwzA48EfaELG9LOb7vA21
	 HDYmqRKdG4ux7MJ3/+lDglN2hBJFoBcmwizNsySJJtjq5ngFH9NK3LvvmXCzmy9pPaw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uqwR9ZaT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.61
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012061.outbound.protection.outlook.com [52.101.48.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54887606A31C;
	Thu, 26 Nov 2026 18:35:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54887606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uqwR9ZaT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wEXKW2g6C5Sp6W7vs7vz9hxNPpc88XpfufOHv1FgpkAyn78oZ4xjqf3E+ee0VelHHZbLcRqKRNWU5Fkkr3WKv0MxLFpXZN8ENQZ1Q+wY+BGINQ1u8+mjgKWoCwqEkNAzOTwchugr/ZMe4lX12c8OkKHRuSxzH2gT/Fwqo93wt+Pdp39Ep4AhP+ZDEOhOrvs8OO+80gZUusd+r+rodMYoUkOg7FZUT3Ia9EEpLxsZttXqSSMtIJHlfZYhxdpP6engeAu0mjX3iRAY5cIyyKL0LAh7gchrgRecTlkl/vMaDiuH253kv/VsC0uNUofl3t8YSYiSvB9S9J8/B3LYuE93Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dtNGikoQZBwXBTRU0hKkPA0/G37rLWHt+tuMUfY3VC0=;
 b=Wl4oZMkxSOzHwwlthWlebl6+EpgtWZIE6nCAg8oJwxdgrEU5BmxUrjoT7RkID5OZvu3MZaZClgOHs22KwwlOBnnWE9MO/i58w1Nt7Rn2ITRLuXLqDYwaShVh+q0vbHiC5+kajl/ERdWBnDKmMRpFz+YtcZQVqNIDq6eUnO2TwIm/VXPB7rhGOpTHVYY8QtITjs433qynFT4YFoQGy6vBTr/gcpXxQx7KGfgNHeszHjciCVjf8crf3bxrRxhT4/xVEsRCMFDMRkM9pRC8dAA1UpzEU48M+fur8U7NqaYaNlYuT5bYZPSqqsu9vhCeU1kK6TL0meI84oPhJIgxOkeosw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dtNGikoQZBwXBTRU0hKkPA0/G37rLWHt+tuMUfY3VC0=;
 b=uqwR9ZaTLg+wc/RhYibvG4qy3uayF1TCi2B39oz01HOzq/1zmIBVLh3ngAVKGOaLnKgjkI0VDewzEu5wrv8CkA2QU6Hsf6wseDMlmA0C2DzpjuoJLEy/309JNAe9oeig2qym0Wdw6q/SjJ413sT9EqTnpqZra3RQ2aWdiCLMS+cYbNrA5WLkiK3Of+qSdKx2Xw3chSPnJtmGta3xpBHno2/YQ+VEGvEjr6p23AbiAxIb8k90t3r64AUGFxSP/1akdNFujwUvKug29QUM+HgneX7mQq7g7Lbk6OSYbq+dQo4xG+Icp3JVeEA4Um9zUD3ZihsDVy1NX20YxTCLxr9i3w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13)
 by SJ0PR12MB7067.namprd12.prod.outlook.com (2603:10b6:a03:4ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 18:35:23 +0000
Received: from SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c]) by SA0PR12MB4367.namprd12.prod.outlook.com
 ([fe80::2815:8a95:1a44:be1c%6]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 18:35:23 +0000
Message-ID: <3680bfc9-8309-4eec-a35a-217eada75ae8@nvidia.com>
Date: Thu, 26 Nov 2026 20:35:20 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/mlx5: Free the table after storing failure in
 mlx5dr_domain_get_recalc_cs_ft_addr()
To: Wanhui Fu <fuwh1120@163.com>, saeedm@nvidia.com, leon@kernel.org,
 tariqt@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com, kliteyn@nvidia.com,
 muhammads@nvidia.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261126132229.4028110-1-fuwh1120@163.com>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20261126132229.4028110-1-fuwh1120@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0012.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::16) To SA0PR12MB4367.namprd12.prod.outlook.com
 (2603:10b6:806:94::13)
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
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_|SJ0PR12MB7067:EE_
X-MS-Office365-Filtering-Correlation-Id: 793ca73e-019e-479d-a1fa-08df4bec085e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|921020|261026121527099003|10067099003|11063799006|56012099006|261009223027099003|261021121427099003|261021123027099003|261102123227099003|261026140227099003|261028144727099003|261022105027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	z21XsEg3D0afXGJ+M60HRmGYbdmOXN071Y6suILy3P2fj3VxNzEGAf3dYYiUdrYnkzVkdBFjqE6r+NLH5xbT85979PbeAqx3DKdYTGr0AJpFPzy3mck4pyu5d9WbBfKy3c1lQBXkUqb/a39AOzaz+iFjb0AhCvrzFxXNmqB4CNwRS2KU4FvZVhnqci/b0H/5zuV+rDW8sD0boF0lxaQpYiarBwcDzPDUPE1rkOg+HKYzWzHZ+Flp1KFYcHrbIwfmyD128kMNFUUVTh8JooG/oyPFZp80POopM2Qc0EgSrqmdW7HlIt3saCBGi8th8RrX37R5f17KBs8UUPG8bwW9RLuT49fEu1D6xKB6GL0NiD1laCdEp0simHUXlsQgpMWidDbw2Gfr3zZXMEs+iRgwpkf4bH4L1+2OS1IsimuLaC94BNgfTPcTDIk0UBBaRW5LPaGafjv6R2sSQiM7tMbWFb8xPjS0Oo3JFtpFa2AYcoOo5pVqDgI0FKqUaPPW1n7L5fah9O+Ou13nx8oSvy7T+iiicKYi1A303kvaQpB/XA9drA7tkmqLtfUCprxE01jRLqsqmdwIEMiTcZac2pdpeH2uQpO1w4pmJcMjLOyacSt8PS4S+yXq/SuZ36Qq+SZqx7iuBNUu7WoBG4d0t3guOm9cx73gEvYcGWc6YXnSP4J8hG0mbimox/CkDcPSrU+mq5iM9DnuxFVkPmfV/JYZ5A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4367.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(921020)(261026121527099003)(10067099003)(11063799006)(56012099006)(261009223027099003)(261021121427099003)(261021123027099003)(261102123227099003)(261026140227099003)(261028144727099003)(261022105027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTlSazlNRnJtWnZqQjU3RUR6bkg2NTZMVUt3WEoyY051a1RVMlFxdFJRN3lX?=
 =?utf-8?B?RW5uSkVNNU0veUFibFgzSGNucDNUTUNKemxSSEdZbXdvRVlWcXVSUFl5d3M0?=
 =?utf-8?B?blA5b1B1RW50cHV2dDJ1aUkvVGhlU3htcTg1a3BEdzU3K2VSa3BCRkMwaEM5?=
 =?utf-8?B?L091S2pJRzJUWDdtcmplaGV1MG84Q3JScm9DYm0rY0YwOFVMNTB1YkpwYTVh?=
 =?utf-8?B?c2VkZ3FpcHRkWkhFVlltN3NrdmYrNmFFYmhINUNuR1NsSm4yK1p0UmRZMmgr?=
 =?utf-8?B?VnYxbE1IRTI2U0tBeHczRGt0SGIyd1M3MUpIbm0zQW92QXdJVDRUNDd4NGFR?=
 =?utf-8?B?QUMyV0FqWkNFa20xZGp0S3ZSMFVhSURPVEU4dy9PTjVpT0NHUmN2VzQ4cFpV?=
 =?utf-8?B?TnQxcmJnTTE0YzNrWHV6YTFiWW5EQ2ZONXhZVDVNNWNjQTRvb1A4R0F4b3Iv?=
 =?utf-8?B?TElvUlVlalZ5MGRva1lMZXpTRitFcHNCdFZJSWhCSE1MSWtrRVZ3LytQdWIw?=
 =?utf-8?B?R2hDNzVQK25lV20zNmx0aDc0dzlXVjgvQ0duSm9SUEVhL01QNjVmTzJ6bVVu?=
 =?utf-8?B?Z1pGVUM3M3BqYVhLNURjSEQrWWFvSHZIeFRndktjZTVsZS94QUMybm4zVVFi?=
 =?utf-8?B?NFUweU9zdFdMM2pjRDlpNEViOWFMRDM3Mmd3WFJaaTMzUEd4aWEwODgxSjIy?=
 =?utf-8?B?c3Q4TDNOQVlyNHg4K0RnZGh1Z2tNREhjaEpuL0tnZVVNVmczdE41MjNQS2c4?=
 =?utf-8?B?UFl2VWtpY01mbzZyVnVLUzhlNjJNWlNQQTFTWDQ2cUVhQjNvKzFsKzFTLzEx?=
 =?utf-8?B?bSs5eG8vem1HUWdnMVoxZnNESUIvSzQxYXhmTmZtamlOYXNxRnVrNkRoeFhj?=
 =?utf-8?B?U2dmRTVQendCOTkrNHZab09JQ1NoeHNPM1J1NkZCNllUV0Y3THlVcnU2eUpR?=
 =?utf-8?B?c1B1cWtIdXRvcFVCV0ZTZFBVSjBoN1ZIRGo5bkFqUjdTZUkwaHlGYkEyYlJj?=
 =?utf-8?B?amt1dHNHeG9hb2JlT2Rjckk4bnJFWnRKV1QzdmIvZGNSZ2xraFRiNnlmQ1NW?=
 =?utf-8?B?bjBiN2tGV3phelZNZzBsa1IyeG0xUDErVjcweTFDR3FrNmdXZlpCdWpPRHlZ?=
 =?utf-8?B?K1RIK2ZzQlhjY0NmS21YakxrQ2FxV2NES3huUnpaS0svaHJWZDNubERKMm9P?=
 =?utf-8?B?KzFsb3VUY1ExTm14ODJpbjlDeThvNjl6UXY0QWFpVnhQQVZYUFlWYWNWMld6?=
 =?utf-8?B?elBid1pjV0JtTmovb0tiQURQZFRFOEFLSFU0TWZ3eHNuWmpwTjludW81bHo5?=
 =?utf-8?B?c1FkNXZsVXNienZRSkVVV3ZOdmc2QktJakRUUDRmSk8zS2tvVlVDZmVxSkYv?=
 =?utf-8?B?YXYrTEcyRWQ4ZTlkemVLYzVCb0IwcEwvRHhKTUtWeDBQM3JDZUZTUVZxajBJ?=
 =?utf-8?B?cWtMSmtBbG9nOFltTlJoaVdpcmY5b2RLTVA5Qy9aTTFaZ29ERnJUZlQ1V1ox?=
 =?utf-8?B?c3ZoeVZYdUZxYjdzclBueklnSzgxVVluUTc2Mi9PcEovTXErL0YvVXA4VzNi?=
 =?utf-8?B?UHF1T0NQL2d6NVF6aVJzZWhTN28rb2oya05kZkhwQTFndnVXNU5uZWs1MUd2?=
 =?utf-8?B?cjV1TEsreTY5N1Ara3NkdUVZenp6K2N4anZZS2dxclFJNmhUK0FGTllScUl1?=
 =?utf-8?B?Wmhkakp6OWE0d1BnWTNjUEx2a2NkajRkWGd4U1cwb1hZQ1psRlZWNmZjZklG?=
 =?utf-8?B?MnhCTm91RWIzN0ZPamx3Qk54aURtTk4xbVNzRUdISzNkNkwzOTJxTG1iVWNH?=
 =?utf-8?B?S0luai9wVUl3eEJxRXRXV2QvR3hFVEZRbFJwcmFTcFFqZHpnMjV4WitSVnpI?=
 =?utf-8?B?MXZ3VVZROU9lQjc5QlBNMlpPb2lieEhCYVJoc3F2KzBSbjJ4KzFvbUNmcXJz?=
 =?utf-8?B?Zk0xS1BSdXJlQy81TWRKUE9ObDFpTVRlemo1QWllQTJoS2p4Sm9sbXB6cnYx?=
 =?utf-8?B?T0JWZmRRbjhaSFFNRWl0R05vRnozdjMvbUE1dVl5SkVvSnhBbERlZGV5UDlT?=
 =?utf-8?B?dHlyb1hDUURyZnFWVDRhZ1RlWlJDcTV0QUhvTFFrRjdEVDhDUktoc09VTThX?=
 =?utf-8?B?YVBYek5GTm1TYzFtUTFiZ1VwTWdSSUpXcTh1UDdMakxsWGNlMzBndUNxZUto?=
 =?utf-8?B?bGMweE4yYnJkWFpKQ2dKN3gyWUFwUHlwQjQrZE1zQTQraTVzdTdKbU5acEg0?=
 =?utf-8?B?eHMrVFZOZFl1OWdoQXFHb1ZVRm9PSDlHMHVSOVlLUkRXeWFEMXJiQUZPRmNs?=
 =?utf-8?B?SHhGMnZSU1RpTzNYcmkva09XMFRuNFBjNlducDAxWDhEcUI5YWpzZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 793ca73e-019e-479d-a1fa-08df4bec085e
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4367.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 18:35:23.6361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h33xhP0e+ZItpshrnYvXOmSeEW+r3bM740BDqGvdfOTFXG2KTUlNdYLftuioo4ue2zpEVXPXvrICIWWY0SBTfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7067



On 26/11/2026 15:22, Wanhui Fu wrote:
> If xa_store() fails, the entry recalc_cs_ft has not been stored in
> XArray. Therefore dr_domain_uninit_csum_recalc_fts() would not destroy
> this entry. Just call mlx5dr_fw_destroy_recalc_cs_ft if xa_store() fails.
> 
> Found it by a self-developed static analysis tool and compile-test passed.
> 
> Fixes: c0e90fc2ccaa ("net/mlx5: DR, Support csum recalculation flow table on SFs")
> Signed-off-by: Wanhui Fu <fuwh1120@163.com>

Thank you for the fix,

Reviewed-by: Mark Bloch <mbloch@nvidia.com>

> ---
>  .../net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c  | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
> index fedefb565a21..3747c217b61c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
> @@ -87,8 +87,10 @@ int mlx5dr_domain_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
>  
>  		ret = xa_err(xa_store(&dmn->csum_fts_xa, vport_num,
>  				      recalc_cs_ft, GFP_KERNEL));
> -		if (ret)
> +		if (ret) {
> +			mlx5dr_fw_destroy_recalc_cs_ft(dmn, recalc_cs_ft);
>  			return ret;
> +		}
>  	}
>  
>  	*rx_icm_addr = recalc_cs_ft->rx_icm_addr;

