Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795589494;
	b=Mz7fJ2QBemtticF8l+81ETZUh0ny5FkApvHkWETdGAeO6+Im071BtSK0nmoM8mw4cQjs
	 q/wK9rMna0Pl6QmSZ/wiOiU7bZ1PEDcJHNtrQR1EA4r++jvtr4U7RE/YH8z0XUJYAxWFX
	 sC/PG6GNEir9py98f81CnsoIMy4DZQy/JJ2ojO2tUesELiVv+EUiXJMgsxZO/RvTc3lhi
	 XYGC1D4xksGkT0GCb7lUP7AhkBiB81q/EkW07jYskODFGGHQUMzU1fX780muxUiWpfhSC
	 Ih0qjhi3MeQU1MeqMxeW3FpBr1HI3F1ZR9BknHtvd9XyBfHS4qehMKOPVQK3T7+58nA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589494;
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
	bh=laUylE1QMNfL5YTi7wW3w64AKcFTfirXagdbXCvY3NM=;
	b=sixmm8wHmJ0gIQ3Dz8aJZ1VY8gVuyIxb1S9p/fvcdxbxbzc1bP82hWyrrmIccAGBsZXi
	 tU0iLvWWJom6KAfKFeqGZLDMobpg0Et28l/h+vOPMJl/+1CRN9h2ftJ8SDDTja1B1DOHp
	 pUWz9pY/F93mnGGbFxA0ucfflbMhomsWGyaAPmaNV/UykmvmfgBAoRZADwgO8t+yaPCMX
	 AemBcq16rVBr6gLA0+H29ODkVDuEIlSfkKfuVSjlo75x0t9r6E7tdQyCN2dQ9YTi90ejg
	 yQkvj8hPpBct93oD18p2YICU86CWug6KcxqJfurfgtpSU0Dj1aHo6yuK6iALgy0DdZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JwkgyLhG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.66
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013066.outbound.protection.outlook.com [40.93.201.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E696606A31E;
	Wed, 25 Nov 2026 06:51:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E696606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JwkgyLhG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xm09bsI1Xmw2z4OEyyfs/vuj45bcH9iRne1V602w4VRyalGYMUukIcz1sRDruiPLS0SFk5qP325BkS4tryxlZ8/3tXNPnWSpf6DXmK1PKP0lHoooB27ilazHhDHV71xJf+8e8cixHXoEsrO89LO2BfuTvpnZv0o8vq/FdLWrQ82KAZNfVzDhrFKkCBzLcRzWfl7uEyH7AqX7/B7vWl0ncXQX8/ff5YBA8MYvG0AtMrgElq8ivUGjV5bTinLfAeUHK7Lqkeuiy1dmB/5pXIU3ASSffR+qXBMXK1SlWvJblcTpan2x7ogr7o59hoyM6Ar6n4q3IsTyoGuQaDGw1oKqpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=laUylE1QMNfL5YTi7wW3w64AKcFTfirXagdbXCvY3NM=;
 b=zHnygHorudSOmSSQn59/pFL8CrYxB3rNObyjiGH0xOCeAepimswn4i5x7YOV2Qxe+8qo6fn3go4rp5K4+w3L/6qOdOZWAZzbUx211DhubHOOwCLfzoIt44ZpJp9w+Gvsx8f1cZ1JwNcuZQM5RXy9AP10OEib4pylGOhNH4gFoZnWod4Byih7oAwVQ8HkLZKBJIgT0YMEmO2TedRW1kkr6WCNmgEkl7kOZX5yljauFKsqu4exsrUMIz1QLrw4VR3+ZYk7FuUIj2WYbaSgOR0fl+gatq5xE8Ow5fEZ9bNMcVaHLpgUN8IoiljHOGnN7v7yqFxcGnRKw58NQUcExJZ/Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=laUylE1QMNfL5YTi7wW3w64AKcFTfirXagdbXCvY3NM=;
 b=JwkgyLhGTAm4Q1XdQmUFXatItxncxo1AzB+f44zPs59HojTSrl96W4SgJS7ZwaWLVZcvD5tYMBnoMgu/3YPmYgLzXPGcn0G+231bWHMClweT0QLBPRUuRYXRc9oJl+pi9Q9X+MPqcmmz1uN7n59Z5jZisqP3Pahment+D8zQG97v7tEjge3PHCws6Q/bGTGkwytZwyMScFKspVnbSE35f18LsRn5huqVdG2thTq1ASbNNblDvgDstcIzAmCQijs/tBRhmr+wiPubpkND2Fg36//QDUMDk5Ay/1/5tNqUzOBe3I2U3pImSjlEmsriypluKEP2RO3B/RkZKPi06Ms6BA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by DS4PR12MB912252.namprd12.prod.outlook.com
 (2603:10b6:8:4f0::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.14; Wed, 25 Nov
 2026 06:51:31 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0639.012; Wed, 25 Nov 2026
 06:51:31 +0000
Message-ID: <45be0f94-53a5-4ac8-b00a-760a28fce293@nvidia.com>
Date: Wed, 25 Nov 2026 08:51:27 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net: mlx4_en: report the actual RX classification
 rule count
To: Artemii Mashanov <ralerrdirsardx@gmail.com>, netdev@vger.kernel.org
Cc: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 linux-rdma@vger.kernel.org
References: <20261121001414.724236-1-ralerrdirsardx@gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261121001414.724236-1-ralerrdirsardx@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0026.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::13) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|DS4PR12MB912252:EE_
X-MS-Office365-Filtering-Correlation-Id: 46e57542-f42f-472c-469d-08df4ac089a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|18002099003|22082099003|261009223027099003|261021121427099003|261021123027099003|261022105027099003|261026140227099003|261102123227099003|261028144727099003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	Wgea+Wf5luwcB36KCYArAz5cH75rpy08iVoAaZKrYY1ipy7yEotqBiZOHom4h/p/nWKv58s6uwm/4dCp+xN6bgDsw5nN7PiN352aHL2PudAj6ObzRy0deE8wNqr2ZeFjBbAGlTvY4o/4Bum0Zf6/1i+c0GBL5auAN7JJFVVryF2BmqP2bsItXIDiFJUTcQqD0cwXygBdC2xA7N4VdUD3aa384kZbZhFD6PvbVS4hQ5ofbnkINhErGB0AwmbRzjkMjjTeHBIOHwdXxMAkIEJ6GI6QnkhiHAm9npZ0ywbUb45/4ZTzv0fStS07WiAmq23FaUC2utWh1qli6M1b3ITdOHom7+gjypGWD9VdS1H1cKppHY4XtK9LdrLm86LmdWCht8uTNfr6VbhzHOb3/oCQxJpMgvAZJaJX4R7ZCGiVnhUw8/RWvWADEGvGVkcOAM/h07nK5DvNTjnQ3a29DAmzwWrgtEfS0ngBrlMNUK6dqdQLli8F2wF6r4SxgzyZsCzOx64OkXchv5AIsJTVHVLEDvvg05Dv8sSrrPktkDTnnw3CAiuxbDzoZTAWrrzL47VpEm1vRA6+wvu+/xQXYS+lkhFesEYUYArDMnXFcjhvecP+x+GFQ3hUqx3bgNbV12haLoQHaZe332TyYvjOjkXvYfI8uaf7lciA/l0MLO6zTUs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(18002099003)(22082099003)(261009223027099003)(261021121427099003)(261021123027099003)(261022105027099003)(261026140227099003)(261102123227099003)(261028144727099003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzBMUGxzbVJPM3NxSm1ENTFGOXhrTXhMS01XNHBGQjhKWjhVVzMvdUZKR1Qr?=
 =?utf-8?B?N2J1eVdVcjlLYW5rMmdLbmxjRXFtSTJ3a0M1QVVsOVdRdjFvSXNDU3Q2SFZU?=
 =?utf-8?B?T21ocDMwa1FVejREZnQwOGwrSXU5MHZ0UVl1V1JHS1J3VkFDNE5NUmFrMmhw?=
 =?utf-8?B?Z2NRQ3FGckZIeHVLY1pheDFVU0Nwa01MaDB2d2NUN01BSG1vc0U3TVFUUFF5?=
 =?utf-8?B?S3grT095K0s4YVdyTXA3RlJkNWpublJMRWV3VDJaV1VxYUU1amZUa3FmN0hP?=
 =?utf-8?B?Rk51TENBeUdNSFRDUUw0ZHR3aVJLcGVLZkJvblhIYjcwZXFvc01Fc3hHbTA4?=
 =?utf-8?B?amN1SHZ5clZTY1JPTFZnUUw3ZVAxSVNLZWVTQTd4S3NBMkNldEJWaGZaNFFI?=
 =?utf-8?B?aW85dE9POUMxdkNKSWwyUkdHU0laWW96TlJIT2J4b2hNMitnWGt6RUZTZFFM?=
 =?utf-8?B?bHorTk9xMUhCRXAzb1JLcXc2VXlEWElVejNZUUpUcGpWSmJ4Zkd1eTkzZ1Nz?=
 =?utf-8?B?NS9keEFHa2ZJYnBLMmtFSTV6MnFybGw1bFFlTldycHdrN3Fic3RSeWUrSE9P?=
 =?utf-8?B?RkQySXNqajZYdUFxeW5lRjlVb3hxbTBIVlJmUCt0bkRMbERlM0RuNGFVVW44?=
 =?utf-8?B?ZGc2NlozV2lMaGo4ZnVWMmxFa3FkL0puQnM4YWtyQVZ2ekswR2FOUUJwajU5?=
 =?utf-8?B?UjVIWnJoM3JGL0U5VGNrSVRwc0ZKeGpjbVRyZU1hNUhkUDIxcG1iTHJtNGpt?=
 =?utf-8?B?d2VzNS82UXJpaU8rR01uMzRnTnBBQ0RmL1lxWXhyai9Ia2pBMGdLRGlHN3c3?=
 =?utf-8?B?NUNRTktUMjNtOEJRcGpLOHY0Umwxb09QR0w4bk5YR05wRTB5b09MM2hKVWxI?=
 =?utf-8?B?M21PekZyM3pvY0s0UzN2eEh2Y1F2VUx3L09seUdFMnc2cU5mQ3JLMEk2OFo4?=
 =?utf-8?B?RHFBblpNQmt1R0dXanV2WnphYlJESmNoamNSNGVxekh2ZHlpK2RpVDlYdDFU?=
 =?utf-8?B?aDhLZmxEN3kyUndFVGc1S0ZWcCtvU2YwS3lhWmxFaWlNMlNVR1lVZERNalVG?=
 =?utf-8?B?eXJnd0NwNXRVckYxckRmZ3VDaFBiVmJZWi9VUG9CSDVMZTJ2dHpyVU91MGJT?=
 =?utf-8?B?eHBzL3dmR25FVnJmOTdrMjZvemRoMUI3RjFOTy9iSGdpQmtnTXBnTkV1RnlS?=
 =?utf-8?B?OGFVaFBROGowZnA5MGJTQzFLSE9PNUE1NllRZGx4V3RUVWhJWkpaazh6NFZu?=
 =?utf-8?B?TlErVVZjaTBWT280SjNVTTQxWEl3QVpPTlQzV2kxVUk1SU12aDZMZ0Y2N2hz?=
 =?utf-8?B?NUN1T1orcnNQVlNUV0pjSllrU3VyeC81eTZrRlJWOElyaDNuU2xpeTNMU3FQ?=
 =?utf-8?B?QVEzS2t2Z3RvS3JnNld5TjhqdVRLa1Z4NzZQMXQzZGkwZFdiRmpHMG40ckUw?=
 =?utf-8?B?Si85ZlJKZHBxYlJtMDdpWGNaOSsyVDRPTXcxSjZqQzA0YnJRQStqcWVKTWxB?=
 =?utf-8?B?VUlsSHEwMUlYeUFVMkJNcGxkc1dQaEtpeDZYSEEzYnFMOG1uMUxkZDJ5OWVS?=
 =?utf-8?B?ck1vUlpQK2hYdENTTjk0SVU5dGpETFB6bGFVdFF3UWVUaFVKMUI5NVF0bFhH?=
 =?utf-8?B?ZjdpZmtZc1VZa09DZk04UUJZWnhoOVYraHN2SXFXTWFpUlBPR0tmMEt2YXI1?=
 =?utf-8?B?RUd4VEdRQXlSNHBsbGZSclBKY0dVOGhwQnVOUGd2Y0IxLzM4WGloc3FMRFpZ?=
 =?utf-8?B?bzA1dGs2amZTTWF3bzNlSzhzUW1nV1JBUXRCakIvR0djV25XNDFCN0NNY3VY?=
 =?utf-8?B?QVJwOVRhV2dHTDhXNEs4VWE3TUt2UlBlQ1dXZEwwUTU2NEIrSER5azd2bitm?=
 =?utf-8?B?NEt1bFR4VmI5T3dmLy9ZNTZoVzJvbnN5YWcvZlZjRG9WQmVhaEFZYlBjNFFD?=
 =?utf-8?B?MFdzUG5Mb3U4VXB0Z2l0YVlzYjc3RGpDbS92VVhmNlRTTUVRRmhTTnRYQ2JL?=
 =?utf-8?B?aXhzMWdhb0VVRXlMcmQ2bEI5enpHdThFVVlWWW5EaWhxcVpEUzM1V3pQL1VO?=
 =?utf-8?B?ZEdEeXV5WEJPa1VCeG9kL2VYNWZpZmRicjFCRGovUFVuWmdKZWtmUzZOb1N5?=
 =?utf-8?B?cXEvNUhmdThrKzVqMnFBcVVMMEhaajRZdUt0eHVBZnN1a2VIQnVDMjgvaUJh?=
 =?utf-8?B?d2Q2V0svSnBWYkJ1VllDN1M5bUJTTG9JTms0TWJ4N2MrUlJ2Ym1SMm9yNWpB?=
 =?utf-8?B?NHNsMlhrUzd1WnFGUEp3SUY1cWRHSmNYNWkrRkllZ2x3blUrUk1acEl1YTRR?=
 =?utf-8?B?NWd4TVNZNTJhTWRWaXpOTnhLRXhXMlprTWFSMzNGeHB1OHAxSTVOQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46e57542-f42f-472c-469d-08df4ac089a4
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 06:51:31.3921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L6AvoxMcXmDYWLubKrzJcEe2eTSXGd+dJsehjs+03xIKhJtlPmPPO+igjO881kE3Boe72XmFu08WuJnc27YckA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB912252



On 21/11/2026 2:14, Artemii Mashanov wrote:
> mlx4_en_get_rxnfc() treats the input rule_cnt as the number of
> rules it needs to find for ETHTOOL_GRXCLSRLALL.
> 
> With room for four locations and only one rule installed, the
> ioctl succeeds with rule_cnt still set to four and three extra
> zero entries. When the buffer has too few slots, the ioctl
> succeeds with an incomplete list.
> 
> Bound the scan by the rule table size, skip empty slots and
> propagate unexpected lookup errors. Return -EMSGSIZE when the next
> rule cannot fit and set rule_cnt to the number of copied locations
> on success.
> 
> The source-extracted ASan/UBSan regression tests passed.
> 
> Fixes: 820672812f82 ("net/mlx4_en: Manage flow steering rules with ethtool")
> Signed-off-by: Artemii Mashanov <ralerrdirsardx@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 16 +++++++++++-----
>   1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> index 4ba1947..463c1a4 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> @@ -1739,8 +1739,9 @@ static int mlx4_en_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
>   {
>   	struct mlx4_en_priv *priv = netdev_priv(dev);
>   	struct mlx4_en_dev *mdev = priv->mdev;
> +	u32 count = 0;
>   	int err = 0;
> -	int i = 0, priority = 0;
> +	int i;
>   
>   	if ((cmd->cmd == ETHTOOL_GRXCLSRLCNT ||
>   	     cmd->cmd == ETHTOOL_GRXCLSRULE ||
> @@ -1758,12 +1759,17 @@ static int mlx4_en_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
>   		break;
>   	case ETHTOOL_GRXCLSRLALL:
>   		cmd->data = MAX_NUM_OF_FS_RULES;
> -		while ((!err || err == -ENOENT) && priority < cmd->rule_cnt) {
> +		for (i = 0; i < MAX_NUM_OF_FS_RULES; i++) {
>   			err = mlx4_en_get_flow(dev, cmd, i);
> -			if (!err)
> -				rule_locs[priority++] = i;
> -			i++;
> +			if (err == -ENOENT)
> +				continue;
> +			if (err)
> +				return err;
> +			if (count == cmd->rule_cnt)
> +				return -EMSGSIZE;
> +			rule_locs[count++] = i;
>   		}
> +		cmd->rule_cnt = count;
>   		err = 0;
>   		break;
>   	default:

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Thanks.
