Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012071.outbound.protection.outlook.com [40.107.200.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02223BA253;
	Thu, 23 Jul 2026 06:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784789153; cv=fail; b=WLxpnvSDhzXX/u4JXPZjOjBvrKp1+kqS70Wp2CnH9Xphbed8Cmarxok6l03CS0wqfrxlpPr125EUEaSgeA2ByptstZ83NZG/eVbwBmgJjvcSyHIP2Cw2L4hfaFB4D39wjNf/cDGNiOvhZzP0Yw9fjnrMu1TJTmJh2j0qp4a0iog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784789153; c=relaxed/simple;
	bh=6ei+6H1TztlVCpCPpTVV9BouOE7rcag9tutfmWVZHis=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y+gznx5Ab4VnFB/gCqawBZzoGnwvUPSZfLm32bzMYfl/Rp/tz/6ZfqEJ1TKdQXy8l1/vw0jULCXULzTLrJUUjnQPRUcDX3Ysw10B0/qVdGp7eKcTsqQqDnuQ33Y3KyLWKQh6osH+0IREhereA3/rfdnYZHdmOD0K5mfQk9vnKvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X0ikFzxI; arc=fail smtp.client-ip=40.107.200.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X0ikFzxI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GKj0b/hxrMug8/hzir2G5UHcSt98KMj9T7cb0nh0ILksf/4T3/CA+CD7fAeOBjgflrcDXDqlb0HOW6Mx4pLuw2rSvasC0eFYFKunrEYk+RTYpuMb5dzX7wI8r5iAAj8zToet1pf6uRxhk8BXB/TtFm/1KhyLahR0awi96ET1AAXZLG/yNW8vdhx5SkaIQjwSop8aX3BnexsuQunyYRRYCCVhFnyHSuIU6ofZfyZQS/LBViEHB39xI4trT0oevxNuqnzr7gPP4BZ4F540CN4KQtnhNDn4xBpl+AAzyYdnpAQIwG1dYWAq3Kd6g3Z2bSEKk02SeGiClOVMDjarS0gCfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKWULD5ntcqDpx46mkQ8198GjUi2uZgOI2caLWzroAI=;
 b=ykF/tUQRAob7f0jYByYQrDRgCJm66bkDZ57hfze57kOLVcxw4KBlH39I2XxuUOvdQhCDtiVT1c1EvjYpErZzVoEeTUnlUNH6KQMxSFtvw9jHa2eixw5EHMildHT4oSCKMiYSNbKZ/od1pjA2TWZV4kKyTeVYR2y3kOeroBCQx0DzsaYMztS5xSV8e3Mgu9MyO7BNm9cenqG+CLpD9QnuXAKPEe+56QYVZoiw75T2+pNFTbs1JXzyGZZa+UvZmkwia9orzV1bDiz7vKqkwB3V3QdsnOgTQSfPaF7s/LSGbkrWWHz+A+w8/FcSG9AQH0mJv5T6Xh0bxY/5pfhAPkJiXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKWULD5ntcqDpx46mkQ8198GjUi2uZgOI2caLWzroAI=;
 b=X0ikFzxISSnlBNmA9U0qFXhQHOVMQbR7keCjo8gWf2oHqkRTx8jbA+rshmYERqmFYzs8wxpMSPwaDSQnuWQyTBd+xC7eavXHnEIPdCyBvHyjjGGiGxbQ3ozA2cQ4fFRVW8VBdFcwTM2bG2BP84zsWGJ/NE9ur4QJO4wo2e2oXqvhYOsEmwFPtlfT1DAnDyaVrfGZF6nIUsSVTifox1UcEQ+wDVu1LqjMrEsZxT3BwqdNUgNTMBo1XXIKqt07B2Pg7xPSWgMj/v7OjBAUidq1uPn6fUWRhGayG9aHz/CmLoDfHzuTsxvFRplHbFp3PP/2KK8xP83JV8KVYM74oAhvug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by SN7PR12MB7345.namprd12.prod.outlook.com (2603:10b6:806:298::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Thu, 23 Jul
 2026 06:45:45 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%6]) with mapi id 15.21.0245.009; Thu, 23 Jul 2026
 06:45:45 +0000
Message-ID: <ee358aca-dfcb-40a8-9dfe-dce1ebb9c063@nvidia.com>
Date: Thu, 23 Jul 2026 09:45:39 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: Use unique names for software steering
 caches
To: Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Alex Vesker <valex@nvidia.com>, Yevgeny Kliteynik <kliteyn@nvidia.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20260715-kmem-dupliate-name-v1-1-85551c328155@nvidia.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260715-kmem-dupliate-name-v1-1-85551c328155@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0433.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d1::15) To MW6PR12MB7086.namprd12.prod.outlook.com
 (2603:10b6:303:238::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|SN7PR12MB7345:EE_
X-MS-Office365-Filtering-Correlation-Id: 61b5152a-87a0-49a3-ccb2-08dee886056e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|10067099003|11063799006|6133799003|56012099006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	XT5fWrEUMhELDezDGdUnjLAIcjIqpnX3KITMEGw0yKMQxsniV5rghRXsxt6ZBQvXYLV2x3QCxPd8yaUYFdDVCb8xD8DIZTijyZ4UFG+9JdsDk+H+VOlzDc9TIFyoxxsSaZJ5i1RlvXtFZj5KdUJ1Z3A8RwPdiN61PGIXMfx9ZT5oe2ZvuyVIQ0F366Jxd8zqGkgAVmINvrOag3k3hNzBt1k58J66Ekl+N+tS8cPq4xSgMcjFYa3fCznCQDCeR9P/tPk8oB4HAb0n1WTY7q5Y4QAka5Py4Q8OrQ9+ScjRwHWd7aspd/mEm9ibFajgUOna3FX66XsDNHHwYq6mTC8EShixVS0xy4wUomHVN8whY7IXV2KE1Jb2IJV/JM68ogctuElfonlDcO2SphuF0YlnT8o1txGHX4hnnr1NX1h4mJlCW6aaWvsHp6a50s3DAIn0ALyGf0EENRaiBPDvdua7vxwXpu4uSx2e0P57a+m2+pYeJ+a6Pk/2W+Y2X5MYp5c2pDaxsJcPNa6jVQi52T3swecMBxfTThh5KBRArZK/bM/HKWdUnKWyAjXL2tEvfriPbsZLPI32us1c5wljmnARFDN6dWsMZdbnipXLG98NVz49LelC/cfUtonQk8JkL5C3K0jT1tLVqhexBL6dAdere7WyGn3HqzZOY7sK8739L3XxSXd+rrl/dwl0tz3sh/viy4Xi67XnYYtBkwkcZILYcw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(10067099003)(11063799006)(6133799003)(56012099006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0pkY1pmNkFHdG9uTDlTYnR2eUJ2RHpGT0xwdk5XcWlQSHZUZUF6Y1pDSXdl?=
 =?utf-8?B?SGtKdnpKOG5YVE5ZYkhDMjBxY015OE9TVk5uUWJ5LzJ0cWtGUFIrSVdvVmx6?=
 =?utf-8?B?Y2tKdUU2N3p3SG5Ha1ZTS2RJU2FUWWlYVkU5elJsRkEzR2d3QTJmNG5tNysv?=
 =?utf-8?B?cjlSUWdFTU1Cb2ZvY0lCb09qdVlJR0RESHhCa3E4c2JRVnkwRHNVZzNselpk?=
 =?utf-8?B?eHRDVGpRV0luYnF6cG9OYXZVNGRxaGt5dUF0M1FGamVlMVhzendFR0wrcWRr?=
 =?utf-8?B?b0wwU0NRbW5UZ1NtUDh5SFk2SGgvcVBnSFczOVJsckFMemhCMTd1QU5oelBw?=
 =?utf-8?B?Ry9Gakw3anBvbjk2TXdhOXJlaFlKQkF3MlE4eWNEdVB2SU1MaWR0Wm1vVU4y?=
 =?utf-8?B?Wkh6akVoaW1rdFk3VUt1R3FndFYrdXdCY0ZNdU9YYkJhaVdrRzRDWEUvVDJj?=
 =?utf-8?B?UGxsSWRTT1NZR2FwaittbW0zOTRnNERhS1loK2Z5NVBLOEROL1ZiaHpEb2tt?=
 =?utf-8?B?OEVmRkxqY3JQWldjL0MyMWZhVWhRU29LTGRiRDZWYlRBYThteEpRc1YySkFE?=
 =?utf-8?B?WENYUUt2ZGZRdllyNzlZaTk4V1oyaGlGT0szeDcyK2JWWndnNFBSNS9lbU9I?=
 =?utf-8?B?K2VGRTFtTGkwZDVuSFlGV0Y1aUUvaEg1Z0srU1o5ZiswREo5L2t2cFBlY0cv?=
 =?utf-8?B?OGl1ZDdNQkxDMlVBdmlSanpkM0tYeHBsM3VOVjZ6dXZwblFpejR5ckRSQlFq?=
 =?utf-8?B?cG1qM2xRSG5ROUJNNy9WRG5raXJLSkpvbzNFT3ZtMkcyUzczclhxalJvV25Y?=
 =?utf-8?B?NUlxRWtwei9vWGhpMXhvQWxOWTl6MHVrMFZaOSswY2dYNGU1RU5GTkJsdUYv?=
 =?utf-8?B?TndBMEZPY3Z6YkU3cWlFKzg5RjU2MUJsSml6UTBlSUMwQVByN1J5c2huUk5C?=
 =?utf-8?B?dTQ3Mk4xYkFKazk2cXZMZjVJOU44ZC9wUGpCRzFKSWFEaVpFYXhlK1RZRW1I?=
 =?utf-8?B?eWcxa2dQYjdTazIraEtmZUJwMkt6OVQ3ampaQzFBVTFzeE0zWlIrcjV3d2Ry?=
 =?utf-8?B?cmZ1WGRBMnk0YlRjQUxZV0pOMEhWdGwxOHY5eTV0eUZqRGpUd1QzYzhHZUpp?=
 =?utf-8?B?TVZwK3gzUWhVeThqczJ2NllxU01PMUxZczQraGt3Z292NEYyTEdTTTlkc0x0?=
 =?utf-8?B?TG8ySXVWZnBpYnFqUDRSaTVXZkhvYW5XTWx6VndLdlhLSDJ2ZUZqc2p4NjNS?=
 =?utf-8?B?WGF6cHhERVVFYVFic0N6R2xpazVXYWVzcUZITzZDYW54dllNL3hqWG9DdEtr?=
 =?utf-8?B?YWNGVHFPZjRsaUNRQlNYaU5vMFRrV0xaWU5tTHVtelZ3WEpiOVdiNlhuVFd3?=
 =?utf-8?B?eFJjUWh2Y01DSGtoM1V0Z2FwSTd1NUhteWtoait1Undvc0JPY0JaYmVCQTBm?=
 =?utf-8?B?RnBySmlqQjM4WE81ek5JNkZFbFF5YkQvRVFTWWlNRytTUGM2Q1VRaWRnWUN2?=
 =?utf-8?B?Sk9lOG9tQzM4UldSUXpMVk95QXhMRVBlUUxyaHVEWXc4Rlk2ZkVqUk1iZzdj?=
 =?utf-8?B?Rk5SQWpaZkhQTHM3dVFoWnBVQ2pRV3dhdGpFMXYxdzNRYXJsTE9iQ1NrdEgy?=
 =?utf-8?B?RGIzUFFZRGZ6MlB0UncxM25YN0NxYVlicWdvOUlsM09uQXhSRG5uWDJHN0h4?=
 =?utf-8?B?azVMMkwvVHBVVWQwWlk0REJSeUpTYXJxWHZ5ZVg5MEE4aHloY01MazVNVGFE?=
 =?utf-8?B?bkYzdTdxV1M0V0FpMmZnT3NQRG5Id3paNlZaOEt4VllndjdrL2g1czlkTWhW?=
 =?utf-8?B?Y0UzT2E0cVNSTjloeUZsUGFYVkg5dGptbUtuc0ZIVWpXUGRZUDdMUElmS2JH?=
 =?utf-8?B?WCs5Yy9vcFZUeDlNam90SGx5RTgvSnlncGRzdE02RElsWHJhTE1Kc05ySnp5?=
 =?utf-8?B?NXhBYU4zRjVNd2ZrTHZNNkNWc2ltWjU0L3FENzdYT20rTlRnaHBpRVczU3VH?=
 =?utf-8?B?Z2p0cUFHTmtzNTRqbitTVlhmRlorMFpLM2oweEl1ckVlRlJyWEN4UDJrZm1J?=
 =?utf-8?B?U2I2aVQ5cGR6R3pMQnZ4RGY5cDJNT0RSTjl2RnRiTlk5YnZ6NjlRQzRGZW9n?=
 =?utf-8?B?aE1zV1MrMzFEK1RGejF5U05lSXAyL3JjOS9KVlFXUi83TysxdXZ6WVFmN3JG?=
 =?utf-8?B?RU1obGFsbUJmRmhDTGYwNlhCZEJkVkwyWnp1VjdxcHZISFJKYmx0b1VPNFR3?=
 =?utf-8?B?OXhqZldDSjhFMkVZdDNGVWp4YTZqa2t5ZnBRNzlkYkpZeVRxWVF6UnBhT3p1?=
 =?utf-8?B?c0xQKzd1bEpPQVFyNUIrUkVwZkRoWFR5UUZCZURpa09nbVRzekgvZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61b5152a-87a0-49a3-ccb2-08dee886056e
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB7086.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 06:45:44.9072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FY6g8mAoQPJLvQjR/2YO0YBXAeI8MK8/BKxYJ/HBBINvycPFMRQX7sOW1td0gpps3lCtjlsOyjT6p3fZmgmLQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7345



On 15/07/2026 11:22, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Each software steering domain creates its own slab caches, but all
> domains use the same names. When domains for two devices are alive at
> once, the second kmem_cache_create() triggers the following splat:
> 
> WARNING: mm/slab_common.c:111 at __kmem_cache_create_args+0xca/0x480, CPU#18: devlink/331372
> Modules linked in: act_mirred act_skbedit cls_matchall act_gact cls_flower sch_ingress
> vhost_vdpa veth nfnetlink_cttimeout openvswitch macvtap macvlan vfio_ap kvm nf_nat_tftp
> nf_conntrack_tftp nsh nf_conncount vfio_pci_core irqbypass scsi_debug vhost_net tap tun
> vhost_vsock vmw_vsock_virtio_transport_common vsock vhost nft_masq nft_reject_ipv4 act_csum
> cls_u32 sch_htb smc_diag smc ppp_deflate bsd_comp ppp_async crc_ccitt ppp_generic slhc loop
> algif_hash af_alg nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4
> nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> nf_tables mlx5_vdpa vdpa mlx5_ib dm_service_time ib_uverbs_support vringh ib_core vhost_iotlb
> mlx5_core s390_trng eadm_sch vfio_ccw mdev vfio_iommu_type1 vfio sch_fq_codel drm i2c_core
> dm_multipath drm_panel_orientation_quirks uvdevice diag288_wdt watchdog hmac_s390 prng aes_s390
> zfcp scsi_transport_fc pkey_pckmo pkey_cca pkey_ep11 zcrypt paes_s390 phmac_s390 rng_core
> scsi_dh_alua pkey scsi_dh_rdac scsi_dh_emc crypto_engine autofs4 ecdsa_generic ecc sha512 [last unloaded: openvswitch]
> CPU: 18 UID: 0 PID: 331372 Comm: devlink Tainted: G        W           7.2.0-20260712.rc2.git0.e3321fa3034d.300.fc44.s390x+debug #1 PREEMPT
> Tainted: [W]=WARN
> Hardware name: IBM 9175 ME1 701 (LPAR)
> Krnl PSW : 0704c00180000000 0000038139a6771a (__kmem_cache_create_args+0xda/0x480)
>              R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> Krnl GPRS: 0000000000000000 0000000000000000 000003813b7de578 00000380b9eb8974
>              00000276c417f690 00000380b9eb8974 0000030144623348 00000277234a1660
>              0000000000000020 00000380b9eb8974 00000277234a1600 000003813b686d30
>              0000000000000000 00000380b9e9a810 0000038139a6771a 0000030144623238
> Krnl Code: 0000038139a6770a: c02000ebb737       larl    %r2,000003813b7de578
>              0000038139a67710: b9040039           lgr     %r3,%r9
>             *0000038139a67714: c0e5006e2eb2       brasl   %r14,000003813a82d478
>             >0000038139a6771a: a7390020           lghi    %r3,32
>              0000038139a6771e: b9040029           lgr     %r2,%r9
>              0000038139a67722: c0e5006cf98f       brasl   %r14,000003813a806a40
>              0000038139a67728: ec26018e007c       cgij    %r2,0,6,0000038139a67a44
>              0000038139a6772e: 58d0f0a4           l       %r13,164(%r15)
> Call Trace:
>    [<0000038139a6771a>] __kmem_cache_create_args+0xda/0x480
> ([<0000038139a676a2>] __kmem_cache_create_args+0x62/0x480)
>    [<00000380b9da1c70>] dr_domain_init_mem_resources+0x80/0x240 [mlx5_core]
>    [<00000380b9da226e>] dr_domain_init_resources.constprop.0+0x7e/0x2c0 [mlx5_core]
>    [<00000380b9da28b2>] mlx5dr_domain_create+0x132/0x250 [mlx5_core]
>    [<00000380b9dc1e20>] mlx5_cmd_dr_create_ns+0x30/0x90 [mlx5_core]
>    [<00000380b9cd8dbe>] mlx5_flow_namespace_set_mode+0x6e/0x130 [mlx5_core]
>    [<00000380b9d846ec>] esw_create_offloads_fdb_tables+0xac/0x5a0 [mlx5_core]
>    [<00000380b9d865b6>] esw_offloads_steering_init+0x1c6/0x480 [mlx5_core]
>    [<00000380b9d86e8e>] esw_offloads_enable+0x13e/0x410 [mlx5_core]
>    [<00000380b9d7b04a>] mlx5_eswitch_enable_locked+0x36a/0x540 [mlx5_core]
>    [<00000380b9d84ff0>] esw_offloads_start+0x50/0x1d0 [mlx5_core]
>    [<00000380b9d8774a>] mlx5_devlink_eswitch_mode_set+0x35a/0x3f0 [mlx5_core]
>    [<000003813a791e68>] devlink_nl_eswitch_set_doit+0x88/0x120
>    [<000003813a5b93ea>] genl_family_rcv_msg_doit+0xea/0x150
>    [<000003813a5b95c2>] genl_family_rcv_msg+0x172/0x210
>    [<000003813a5b96c2>] genl_rcv_msg+0x62/0xc0
>    [<000003813a5b7cac>] netlink_rcv_skb+0x5c/0x120
>    [<000003813a5b8f0c>] genl_rcv+0x3c/0x50
>    [<000003813a5b74a4>] netlink_unicast+0x1f4/0x2b0
>    [<000003813a5b783c>] netlink_sendmsg+0x2dc/0x460
>    [<000003813a4c9764>] __sock_sendmsg+0x64/0xd0
>    [<000003813a4cc878>] __sys_sendto+0x108/0x160
>    [<000003813a4cdf50>] __do_sys_socketcall+0x350/0x460
>    [<000003813a8184d2>] __do_syscall+0x172/0x750
>    [<000003813a82d5d2>] system_call+0x72/0x90
> 
> Prefix each cache name with the device name to make it unique.
> 
> Fixes: fd785e5213f0 ("net/mlx5: DR, Allocate icm_chunks from their own slab allocator")
> Fixes: fb628b71fb2a ("net/mlx5: DR, Allocate htbl from its own slab allocator")
> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Closes: https://lore.kernel.org/all/a3cea501-4d1f-47d5-b6d0-fcda9a0aab16@linux.ibm.com/
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
> index fedefb565a21..c9f20a9033eb 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
> @@ -98,9 +98,12 @@ int mlx5dr_domain_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
>   
>   static int dr_domain_init_mem_resources(struct mlx5dr_domain *dmn)
>   {
> +	char name[80];
>   	int ret;
>   
> -	dmn->chunks_kmem_cache = kmem_cache_create("mlx5_dr_chunks",
> +	snprintf(name, sizeof(name), "%s-mlx5_dr_chunks",
> +		 dev_name(dmn->mdev->device));
> +	dmn->chunks_kmem_cache = kmem_cache_create(name,
>   						   sizeof(struct mlx5dr_icm_chunk), 0,
>   						   SLAB_HWCACHE_ALIGN, NULL);
>   	if (!dmn->chunks_kmem_cache) {
> @@ -108,7 +111,9 @@ static int dr_domain_init_mem_resources(struct mlx5dr_domain *dmn)
>   		return -ENOMEM;
>   	}
>   
> -	dmn->htbls_kmem_cache = kmem_cache_create("mlx5_dr_htbls",
> +	snprintf(name, sizeof(name), "%s-mlx5_dr_htbls",
> +		 dev_name(dmn->mdev->device));
> +	dmn->htbls_kmem_cache = kmem_cache_create(name,
>   						  sizeof(struct mlx5dr_ste_htbl), 0,
>   						  SLAB_HWCACHE_ALIGN, NULL);
>   	if (!dmn->htbls_kmem_cache) {
> 
> ---
> base-commit: f8d04b0c74e989c515e0fa17bf779b730077f63e
> change-id: 20260715-kmem-dupliate-name-b151167f5119
> 
> Best regards,
> --
> Leon Romanovsky <leonro@nvidia.com>
> 
> 

Acked-by: Tariq Toukan <tariqt@nvidia.com>

