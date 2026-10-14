Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05770357D00;
	Wed, 14 Oct 2026 07:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791962845; cv=fail; b=oSkzjmdmqtjy7OXZlfUXU3/fmY0cQTegOEDFmf7HiWklTB80pWKgGyavElcq+orjb93FpDo7rKeb21fh+oIMN3LnQ6XdAVMBCsFTdeWyosph+PY/be1To9jLnY+K5Tf/ZW1HK8bbM2e/NVfP00UO2WAi8glDS+cxOZLcM02AWrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791962845; c=relaxed/simple;
	bh=ypZoc0zV36IIrWct9JnEEFxuiShufMU5tH90WdO30/I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l3763q76szB+sgkSocJ0BPXCNErK38L6lSyMSl23aZ2Lecvpt2WKbuAHnZyNuQ8PDUbPRq4ICl2iQ1L4SpIVybEe4WLH3522/65XjFNqvFNVnQEujD7iWyH5uZbvAbiMzIHLFSOJ0+iwqicR8A7M3fXeKhAVsYsWrvVwmLKDpJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NUv9Oh+F; arc=fail smtp.client-ip=40.93.201.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NUv9Oh+F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z7Oo4iB1buUrpI8p30uPOMmFTATG+2/J5YK6OqWSwZy6Sz2HphuYppNeY2rr//A6kidZ5+BuAzj0+gmSgIGkjmBEFdKNjH+T0iXL7OOXn/CGrgIqLkhD8PS3h8kXfqK00UqSzqfJtXA2pOlEQfMyL+NhW3aftU1Kdmx6eYBJUlQzpSreJwlYB3tfXKiWBzcLwuz+VopOnyokS/5rHF8ZI9KUfW/ViLExLHZbskQRTgWt4EBfi2ty2OrvERL2w8ZIRDDWOX7cW4IVmX9DiYjG7WeTb6l7z5Hdgkot4YkdWcrgQ829YmXRl0EVmdWm/MNEU573ERIo60OaZILcC19htA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jiBjNir8LzebezuuulyaoPeEnhBTesROLfDD3uvXU4s=;
 b=LFDUX+9YJyYBK4UnVBnQuckE6mU1xR8P5ZVRtyqBx5Io1jBy7EFO73CRbnfknHz+floMt77Hv6pwrSRNEiz5NBTu3SyQiDwzDDDTQUeBBVVriUgYy83pvzG5JM4swn0iEZT+UBn9FX/Uuk8RN0U/64i9H+fBOu+8eOfc4GAcI/fYV6p2+zRrzgW4MLmAizfL/Wk6WwBnhpxzk5q8ArAoFETF/+u9H+A45bzH63tJJaMXHX95Z6ckMcMavbegQlNCObJNbmloP226PHnIu2KBn/ltcX2GZSWZ2OHQl4d353MdqP34VqXjsgurID74uojaLPRrQJxflG1TnMryF9YRnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiBjNir8LzebezuuulyaoPeEnhBTesROLfDD3uvXU4s=;
 b=NUv9Oh+FkLVd1WzZ4Sc1QzfvVPBVJLnlA3AhKBkD/m9rDr6ubiulelrJB0Ta/Cv1uDpL69KsUC9JEjb50sEIR5ORgwQrJoDkohpLjv2vkxsb+oMFJjOFfS8yCKfqm91n/8uuzA1BZLcQAtjZJqlGzUQtgSynXwAplDzwEfFigfuNnpm+HmfW6VBZ9RjbfRKl/00UJc7Z3RR7G6n93gG2AVkxrPTeuwikUbCCc37TaENEc8vdVKdsZpcRtZvA4yYKjEvTYywskHkJ5AWFVQS+GM2tZZP+lB21q4bnFolVoKapoDQ+uf/vQCnfR1pyRvtBtoDT/4PNpDlTPTtLrOipgQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 (2603:10b6:806:4e5::21) by MN0PR12MB6245.namprd12.prod.outlook.com
 (2603:10b6:208:3c3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 07:27:09 +0000
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761]) by SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761%4]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 07:27:08 +0000
Message-ID: <416d383d-bbc7-40d7-b2f3-7a971ba648c6@nvidia.com>
Date: Wed, 14 Oct 2026 15:26:58 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: Attach late uplink netdev to loaded
 representors
To: Paolo Abeni <pabeni@redhat.com>, Tariq Toukan <tariqt@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc: Cosmin Ratiu <cratiu@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jiri Pirko <jiri@resnulli.us>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shay Drori <shayd@nvidia.com>
References: <20261006110219.257714-1-tariqt@nvidia.com>
 <6bd52b02-e701-4589-824b-87c1475bc4cf@redhat.com>
Content-Language: en-US
From: Jianbo Liu <jianbol@nvidia.com>
In-Reply-To: <6bd52b02-e701-4589-824b-87c1475bc4cf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0130.apcprd02.prod.outlook.com
 (2603:1096:4:188::8) To SAVPR12MB999143.namprd12.prod.outlook.com
 (2603:10b6:806:4e5::21)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SAVPR12MB999143:EE_|MN0PR12MB6245:EE_
X-MS-Office365-Filtering-Correlation-Id: e6327e79-986a-4483-b101-08df29c48e19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|56012099006|11063799006|5023799004|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kNIJ6xnyflYV+nwn3PMURu8ssSi7He8ru6C4OYAkUMl+pyCvBkNk89gIeDUSgM3ufQwjage2vxCPw8qdAD4bdeti3MCilb0ZT5NMHJiItnkSj00wUL8BNVNW+/4vB64196NYsMfGlrbqXIZb4hpYcbnlchehXRhDZVJFkrvlN9rB5xNlFhJevJ96t+Btl+2F11nCDS+gUqGVe5JFDC8cQqLtQOuDIviUAyh57rlOiZz/FCu0qMk4/+708sQF7xo0P94SVrHrY9zuTVmwOpjbwL6p6K49XAtl+dlVb/+f/nUhxo7P7W5oMia+d6kCJPoKuceRjkTbd9jE/7ezoVIXwZiixrks1gbrViu1XufJipI1kNhDx1iHfXsomrVjf42WvxSsSFXTtESEm2+g/dSV9JEOMC+1FN1a2SM2Wzby/H2W9AD7Bo7bHmMEYlUwtdO91jBaN44LHVxsxF5xIkt3xuLJ2YoD4WAzKAJsOAhXpY7mhcpektQH4nOEnfbfBh/s/3ELnl0Cs9dkWr8SK2RHfYZnn2y2+Gw5zBpz/jEl0KbmAjNRY+9kcfirzQa3S1WOHxiCu0DGqwI5Kg9Qhqh+lX8csI3GA8pp5+r3gFxP1ycKoqqlHkCMcdxBQVDF1zCkwXe0pLH0xQNmtZPVY7rdl8pfO7mwPjBsJAMFGO51faI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SAVPR12MB999143.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(56012099006)(11063799006)(5023799004)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEoyeTdjaGV5NU5QZzA5cDNCbzROM3ZxeVJZRjd6NUNxdHVycUovVWVJVTRh?=
 =?utf-8?B?cXNPSktObmJQMnhBWXFvdUpvcTl0cEFCeXpTVXU0dStZYTVEV2tjZVB6SVF2?=
 =?utf-8?B?RjRGa3hoSkVWaWdINlA3Y1EycHpIZHRYY3VCdmwzZFlMSk95TEhLaEoxSGkx?=
 =?utf-8?B?R1NqVU5PdUpWbmpSb0J4MEdydllFMWkzbGEzZ2IwYURhcmhNejhNNnpTeDBS?=
 =?utf-8?B?YXlPYmk3VWgvS3QrbDJ4T20xZjA1T1VVL0p4dXl2NkZTZzlJK2EzYXU5Y1Vr?=
 =?utf-8?B?SkRyMkN1UTJvY0RYWkpIMnRyTHN6bnhwWmtMN0plSWtZY0czQm9ERXZGREV5?=
 =?utf-8?B?bXd5S1FkUjF1WFNzZ1NZM3Y1WXZ3aVlDY05OemVuclJHbkl1Q01aMGEyc2p0?=
 =?utf-8?B?bEl2TXFFclY1aGFYNllWM3Z5cjV6L3U0bUNyTGxORTh3UVZtWE1WVGRsNVY0?=
 =?utf-8?B?SzZ3NXZTZ3RUYWZHdStUVjJaRDh6TzRCZGR4Q2UzR0xiTm5yVnZFdkNZUC9Y?=
 =?utf-8?B?VnZqTnplU1YrS2RBUDIyVmxKTDhMakV2SE5UK2ZnR3dJa1BRZVV2Wkg2R05U?=
 =?utf-8?B?SkZ2SG41eEFabVFKVUsxU2M5K2JwR0lrRlhuZWdtWVpEY2FqbDJ3T0ptM294?=
 =?utf-8?B?aDJNNHR0NVBaN0M0aE9pK0FpcVZyWVVOSzBuWlpGa1VKNUV6RGV3ME1BbUlJ?=
 =?utf-8?B?M2daU0V2RHpJaWM5emRpSm81UmZuZDJMSU1qSkZkQjJ0STkvakdodEZEN243?=
 =?utf-8?B?Z0s0bEp4SG5rb1E3ZmE5ejJoVnVRdjNsMVI0MitydFdKSkpSRVpGQ29CV2RF?=
 =?utf-8?B?TjUxdHFjWGtOaFNDTHlYaGRhQ0Q4aE9aenpGRExINzA0UEJHZFFtS2Zsa3du?=
 =?utf-8?B?enR2ZjROTGs0VUx6dWZTOTJMUGxGYVVGRGs0UFlZVlZYc0wvOU1nWmd3clBp?=
 =?utf-8?B?QUpJZVRBc09GejFUQUY0T1NJL1ljd0VYaTRXMmgxUEJJQ3lNMktWTG5GeEVo?=
 =?utf-8?B?S2l3MzB6S2diOWhkWW9ZYzVEd3FOQlJ5a2NTZ0I1bU9EbkhBeTBSYjU2b2VD?=
 =?utf-8?B?WmhNdnFXM1o2LzFPMFI1cm9zamEzRWtPcUptTTNjNFdmT1lHRTlrbU1LVjBz?=
 =?utf-8?B?aWQ1cFR5OUtvd3YxNi9JRVF1bDNXalY4Q0NEb0t5Y2pYQTRsTnZVS0VwK1VT?=
 =?utf-8?B?L1BLZGdUYW8vazVqb0paWitrN21OS0VLRzM0eDVsc0F3ZEpEWFNNdmp0b1Zj?=
 =?utf-8?B?K2xGaElma09VNXZTOEtsTWJjaGN4aC9nRnRnTzlJcUZ5dlhMWit4SGxlZGF5?=
 =?utf-8?B?ZDluSnlFTHhzWkVaYTlrTnpZeFdPM1RaQTlBZEtjeXFKWE5KVjZCeFlCYmJ6?=
 =?utf-8?B?VFZ6ekNSOXFmNWdOQTRJNk9yS2hmYnFNZW9GdXZXTEZvU3QyVVhZYUVPY3ln?=
 =?utf-8?B?bzNZeXE5R2RqK3RNK2ozMTZXYTh4ZzFDaUd2Z1Bka0pUalZNNVVVREY1cTQz?=
 =?utf-8?B?RzNDdXdFQWJyM1paWGJpdEpma1JHYkduMHpXcVJDelBKS20xdlJ3Q3JIZmo2?=
 =?utf-8?B?REJEd0k1bjJOVE1IZ2syRDF1a3hLSGxyLzJaTXZNNHhwc1VsTHFjSXJoT2lF?=
 =?utf-8?B?R1FKeVg2TDUySnNlMlZRZWZOU05oOUlXWVVCbWFwYlkwUkVrVjBtRHRGNHB3?=
 =?utf-8?B?cytmNHNnZnBCMlRnSE5Qd1hHbFg5Z01wT1MycnNXQldjZ3AwYWliejgydENO?=
 =?utf-8?B?dzc3dklSUVB3dFg5NmpQY0JVREZ4V3Nyem44YWVlME9teTh3ajNIdXAwMXZq?=
 =?utf-8?B?UG9oQzYvWjNRamM4ajFzWjlaWlR0MHhlS3N3azY4aHRhSnhFTFBITTNDeDB1?=
 =?utf-8?B?d09oVnZlemE4L3ZBN0paVmkxVXVPL2hTU3pHRC9EdlRqRFFjV2lrdUt4R3M5?=
 =?utf-8?B?MjU1TlE2UUlJQjNRQzdQaUpxZGFDK1JIcExnME1QSXU2MWdudnpCU3pYRlQ1?=
 =?utf-8?B?aUpybGluZFNaQUFqUHJKWHRqVzZhay9mNkt2WHJ5SmNERFBBcC91QjVBeU1R?=
 =?utf-8?B?RThxVW9nMTBDRXRaZHdwUE5aVFNUcVJlMFdUR3ZTbVlKeTNJcEtXVHIwQVQ2?=
 =?utf-8?B?UlpxK2VEcTZ1ZHdWU3BrNVRlWVV6WStVMTYybnVOVTdkb1FRbTZ4bmcxR1o3?=
 =?utf-8?B?K0FWUHdpUjBTVmZRTFgvb1pLUUxuUklsazlRUHBsam42MGw1ODFyczkwSUtR?=
 =?utf-8?B?aFlrZ2o5UWdzYWZNM0hwbmxjYzBtSHUzdUxBODd2VDhwUTF1bFJadXloUUQ0?=
 =?utf-8?B?TkdTTzlzL2xVeTVxNUQ1WFZGd0hhQmtXSE1VaWorN3ZSUFBFVGluZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6327e79-986a-4483-b101-08df29c48e19
X-MS-Exchange-CrossTenant-AuthSource: SAVPR12MB999143.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 07:27:08.5371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e78VECiQvvFfry/Pzq7XRMSZA7HFqw/236Iaq1aAfGuQBOkXbhjrGW4f96edDaDMIdWgTU5wB0FbmiHcgmenrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6245



On 10/13/2026 7:23 PM, Paolo Abeni wrote:
> On 10/6/26 13:02, Tariq Toukan wrote:
>> From: Jianbo Liu <jianbol@nvidia.com>
>>
>> mlx5e_vport_uplink_rep_load() returns success when the uplink netdev is
>> missing, so the ETH rep is marked loaded with a NULL netdev, the IB rep
>> copies that NULL association, and nothing repairs it later. Unbind
>> mlx5_core.eth.<N> in legacy mode, enter switchdev, bind it again, and
>> rdma link show still reports no netdev on the uplink port. The netdev
>> also keeps the NIC profile instead of the uplink rep profile.
>>
>> Add an attach_uplink_netdev rep op, run from the existing reload-reps
>> work once mlx5_core_uplink_netdev_set() reports a netdev. ETH re-runs
>> the uplink load, switching profile and setting rpriv->netdev; IB redoes
>> ib_device_set_netdev(). Deferring to the work keeps the devlink lock
>> out of probe context.
>>
>> Fixes: 6b4be64fd9fe ("net/mlx5e: Harden uplink netdev access against 
>> device unbind")
>> Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
>> Reviewed-by: Shay Drori <shayd@nvidia.com>
>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> The AI feedback looks relevant, also this looks quite too big/dangerous
> for net at this point of the cycle.
> 
Agreed. The missing uplink netdev is a corner case rather than a recent
regression, so I will retarget v2 to net-next. It also relies on
mlx5_esw_add_work(), added this cycle in 2a110ee54e89 ("net/mlx5:
E-Switch, introduce generic work queue dispatch helper"), which is newer
than the Fixes commit, so it would not backport to stable as is.

I will address the Sashiko bot comments in v2.

Thanks,
Jianbo


