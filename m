Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794864024;
	b=Kp6ChReTlaa0o2WBEv4NDY270K9csCiIsot1yrDY4ODjiZQ6EYYhyqIhCkROe3FlowjB
	 tz/ki28xcyULi1DvnfbRD4F89pEuJpbBrzDvCUuTOfFDgKrsyshJ7d/TRV3bRt+cXtzAW
	 pChwHk/3wL4NZ8/GbV8gzZIuWrxjMEmps8/Hlm9Ur6cMSVNxlHObsmVKLqYZw1H+ZV+rC
	 nhu0Q1GGdsvfJuIha5h8hLfO0wA0aj63DkJiw7krxiv73Zx+Bz5p2z4xlHGITfonuhqxq
	 plxVPf4iN4sPv+G96aOm3K9xuToT08P3VKdi88Sudh0YwiFQ5m8k1PPkF/eL/PuuIqQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864024;
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
	bh=fmCUCPLSZVS7PNdjJv8H3MKZU1qhR+BslZbLH252sYk=;
	b=iK6SjLY1DYYb7F5ytwVsmwzACIvAmKzcFEugVP+kCMWd2v1o2yJcj/pDNpFBFHl42F78
	 cHCgZdtRkrz2DqM+yYqOIExh18EDHQXozrw5233YXKgtPw25zCg7ANrDXDJMe2iFTvZmx
	 gpV8j3PmsrM0N3TF++2m5NKvEh50xaSaXbCYb+Sxd0OMIEDPKWQFVlp8znIXfdcum7woY
	 nRQH7vErmMEVmZhYt0j9nYPnJPhKkD5N32vWuQZcV5iIAFkaBwM0W/N3bELurx4dZihgF
	 IJ1ouz9tSrexDzm7jGeIHtJ8wDIq79m9blazcSZS5M+2MtNRYq//ezpGWz+XPVgz1eg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KhwxK7Rp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.27
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012027.outbound.protection.outlook.com [52.101.48.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6876606A33A;
	Mon, 16 Nov 2026 21:20:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6876606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KhwxK7Rp
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sUem6qAX3F4o37tA0xgZzWDyVNXyxlZ/tQNRdXLCiX12aVHB7yER2/72ZWLNvRJUPbJkNhWumsG55dPgRcC5UaKHvlqBi+n9fBUkv9JEvRY96rJ7QDT6YfbPSOufwbITQ6iyvTBrCk/LPETwaq0vZhiiM8Fkm04bfeoVHPrMi6sbWOu0f2/FMj8Ggf/KkDadjW8Lyj1nlog1kBHfE0t2ecWd7q+VD3wHXjaLv01CTMCYRxD2V3rBGFvzreT2L/jTb1gMhpdJqey6w3qMlN1EHfixtDBqImJjR5JaeZKDmGQ/DKloyzbLFKy7WskygCmigM22dkbC9Na8VDOML6ynAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmCUCPLSZVS7PNdjJv8H3MKZU1qhR+BslZbLH252sYk=;
 b=fLVrGt/Tmn5UQh/ZI8v+CZpa8eNik1N+RjO1z5SnlxA7UX/SbRJxSrG6bbLRvGS55w+POZsL6IEoshHI49gr7pyKpHIVK/y5zZB7p0Vw0+0W1JgOaGteObdp9ynji+oFCDIgl9Cn2afudqdlL+P35Coa97fY7+rHJGc+ziI/rZtyiFYGalwcHjqAr3/cZbBw1Vn1f61Ht059cdWwkem6/FEufVat+t94TafFNOFQUWVzK+ZCpfo3vJenM7e9zb8PLQpi5eABoW87kPKDk8R0d5IWwtmWqRCUrtL+vNbHpECr8dYsOGf2QIU3bMcw3uj4MpVem55K3cJ+bYSCsbXOLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmCUCPLSZVS7PNdjJv8H3MKZU1qhR+BslZbLH252sYk=;
 b=KhwxK7RpdhJYV7twJF992ynHJpnmlOFYlNATuOrrVkGQtFMO5QjIO3T0Z9gadFf3fIz47Et3YAK6rceEGCeDRUQHZD/yRh8pz8vO8pRLUa3wb9a0ypUquYAptQ1F2j12uPxyytNrVPz3VekfFOmtP9MEGHqxP2ylcT6Yt2UlfR/25O6fasSodNzzF1CxXYnD6ZcgiXDV1ulR35GJ2+wDsY9t17dAqQSnkgh6EXmcwXC6hn+eAdshZDE4Ddcb1FXKxFQFvs99C/sLEhLXYa49nGSf5coDlg/tcOvPgp5cfdhOruDEPm2LB1AcEan1ZSuVr9gomD3dq3wh6MXoInpvEQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by IA0PR12MB9010.namprd12.prod.outlook.com
 (2603:10b6:208:48e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Mon, 16 Nov
 2026 21:20:19 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 21:20:19 +0000
Message-ID: <08161b3e-9838-45da-8842-dd003269311f@nvidia.com>
Date: Mon, 16 Nov 2026 23:20:14 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2 1/1] net/mlx5e: fix NULL pointer dereference in
 arfs_create_groups()
To: Jinvas <jinvas@126.com>, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, leonro@nvidia.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, horms@kernel.org, alexious@zju.edu.cn
References: <20261116130406.1171-1-jinvas@126.com>
 <20261116130406.1171-2-jinvas@126.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261116130406.1171-2-jinvas@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TLZP290CA0011.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::19) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|IA0PR12MB9010:EE_
X-MS-Office365-Filtering-Correlation-Id: d88b6db3-536b-41b7-ea96-08df44276a9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|921020|10067099003|261102123227099003|5023799004|11063799006|4143699003|56012099006|261021123027099003|261026140227099003|261026121527099003|261028144727099003|261022105027099003|261021121427099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	+kuhdib/5EHzcQKJD2pb4NjLB8+tqeKoj46qN+LRCSgx3+wLvnaPPek8yffjFZ42tMnDfihYsC40iTAIFqjsilEyuTgmqK62Q36LSKDRxK+l9p8mCRssMeHBq3Z8K5UtWo2QL7aVZreFFdfTAZBxtvQWbnWiolJrctd+u8lQEGszf4/GegnZrOZ3AulFifrEgJAxi8lqESafvVTAfYMkkG94NWlgyrJlsXrRv/C5rJKud3UBfJh5wpYb3LD1PAZgyNWwrqAT3DJ904LDlBVtHui3WbyLf6qQD6FlI2pXwD8bXYaOl2aaHKyM1GlPW+6qfPnueoGz+QxHrWhbfFNmP9pRrIVYpj4zL+pRsjlu618fwkS1am75cmvsdeEKiPkJRo1K2ByRegm2vnZAIVkP4bGNb8sEiT4rdvLeM18LFAN+6g2vvto7dtwrQvMJqhxc22DIdJLAYfBht07Own38ylcvrWASHOw9v/sEOci9E7XAy7+Omui0DoqiHjBKPNCGqPlwugjswQWEj7CAcyRoIzMuwBRnxJR0RJ/tDwu0QujdkKNWoFmse77wNyO+f8XvaGqUHQ6FKwrpEytGI/9HgRJMoPC7nt+gT0C893wjJ7kCNA/zI9UVmwIac2h/8p+pzE0DuDbcCeTtavn+XXxhsSMqxUdD+4PlcNd5PsZ2xTXP01wVCdUDckSMjd6MMI2KyEjYaxBk5jj05SDn9mCvzg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(921020)(10067099003)(261102123227099003)(5023799004)(11063799006)(4143699003)(56012099006)(261021123027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261022105027099003)(261021121427099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkdvUDR3RWhHT2dheEZJenZQWVRrV201ZlNVYlFnVXF4cys2K1FMZlJkeERW?=
 =?utf-8?B?S2RMbXpKYUtTSU1PbUpiaXc2a3VUUkt0aHBQZzhORklXWFp1dTBaTUxMWGU2?=
 =?utf-8?B?V1NWaWFsK1kyNmhUbytHTmJtdUdNTzhkWjB0U1BLZ205U1M0VkJPVk5od25t?=
 =?utf-8?B?V1JDWlNiVGQ4TTNFM1Jra2kwOWdrbFgzMTcxaWpnL0RUY25jaGRiQ1dpMWVP?=
 =?utf-8?B?dXVOUnNJSW5IZ0hWMDhoZG1qTFBBSEVnUThoY2Vncm9NNk10QVRZMU1tbXhB?=
 =?utf-8?B?TXVvcjltQXRtMlRkRXpsTmg5M3IvLy9mMVdaTUJKaEZ5T2Jzd3VsNUU4M1Nn?=
 =?utf-8?B?YmNiMnZmWU9FYm1vRkU2OXovSFRWbDRyR3ZlS3ExdENDbkViSkJlMFZGUlBa?=
 =?utf-8?B?VnJtRFRhb1lSOGFveXNTeEgwVUpFUVFxZEpVOXQ4bU5iZlNrRUdjRzBObUJq?=
 =?utf-8?B?TDA3dHpTb3NBUnM1SXFnc2dUbFZ1bjhEWU5DV1hpVXpVbmdabXc0TWZXdEFF?=
 =?utf-8?B?cnZNMVVMWlN2U2xXRVFvTWQ1Q2t2M1VzM0RBOXhxSFNVYTBGUGczaUVVUkti?=
 =?utf-8?B?ekttQlNOSzM2TFFOQkQ2MStuV01rOXJSd0d5Vk9udXROM1ZBR3BrMXJZQmtC?=
 =?utf-8?B?SEV4TENRVy96bWEyK2NBUFMybTZuRUJWYithbE04M1ZYYjVkcFlmRVA0OFdj?=
 =?utf-8?B?YXFsNFZXeUJCRms4Y21QZUFkWW5JcWc4K1lpK0o3L0FXbDRRRGR4bmRFcGRQ?=
 =?utf-8?B?LzlnUExId3Y1ZGt4S2lEWWo3cmVwR0NMVUZoWmRKT0xOR05SWFJmci9sZVFn?=
 =?utf-8?B?SU1TMDJtWHI4OCtyNG9BaktGU3A5bnhzRWFYRDJGNG1BTFRWNjA0RHBEUTZX?=
 =?utf-8?B?M3BQcFBEeWJjVFZNK2oyRGJrYTFNbW9RUXJuRmpLa3o5TThqZnpHcEdpRGo2?=
 =?utf-8?B?WGtHTlR6aVljcjFpK1ZtUGh0WHRmKzZxRFh4cmQxZ3lRQWZ0SUhpTGlFSmgx?=
 =?utf-8?B?SDhGdDhFeWcxRHpuNEQ1aU9WRkVnL05ZTGJaNzcyODh1bXErNDhhaFhwR1BE?=
 =?utf-8?B?N2poMEtTRi8yaVBNS1NDWFJacFNKTlNVL0dac1VKQzRhV2lZUDQyZk0wRG83?=
 =?utf-8?B?YTJ4U213YUx6UlBMK3loS2t3ZktqVVh4amJVZnN6bnNQMExncUs0NUdhZnIv?=
 =?utf-8?B?dG1FbkdUYlZycVhYSlBlU25ZeW1SdmFxd2N2L01LcDVseW9vekJ0bjBYWU45?=
 =?utf-8?B?VHhrOE9wNVEvZk9YNWNpaUZ0d0pDZFQranFjQU5FNEkzaEtWd3h2MDFlRE9I?=
 =?utf-8?B?T0IxQTE3N2hYZXEyZzNzTXpSWk5Wam9YaEZkclJmczQ0Z3kyb1QxQWtoQVVi?=
 =?utf-8?B?cUVxekprQ3IxQ1JtLzdGRjQyODNiaWF1dVBYTjUwY2ZKN0ZoNXVZb20zRktC?=
 =?utf-8?B?WEhWTGdZYXgybzFPbjZmM1pWa1d0VlA5T0s5ZmM3RVp2cExqSnJLU2tIK1k2?=
 =?utf-8?B?N0xSV0NJQTFBbGhRQ0R4OFROb2dKZUtjcHZJSEhqbFNBcmErbnhFYUxMdEMx?=
 =?utf-8?B?NHZReWlxbWhWaHJmekRVNDR3RXc1RjFEQkdmOXN0TkxVejFVa1doY1htdWNy?=
 =?utf-8?B?NUFHOVU4M1BWK3MvbElnS3lldTVkenNXNm9aaFJLMGo0Qm1HT093UVcyMG95?=
 =?utf-8?B?a3J1NDlGN0ZBMnJ3Vk5udXlMTTAreThWSTZvdVVzYnhqUmJBb2k1TjBsTVdR?=
 =?utf-8?B?OTlPZFBvT3lwZWtCRDVyUzRzNXZsUDBOUWZ6N3FrZzNoUVNmKzRMcmRDMG9B?=
 =?utf-8?B?VGFGZWJLNDJGUzl3bUc2SXU0SVd0dVIvUUxMcWhQdll1bVZOUS9JeVFLd1lT?=
 =?utf-8?B?VnBRVTVMREM2cWRPQ3YwUURVT2FuV2puZ09jNnNicWpaYlZWNkZvdTNxc090?=
 =?utf-8?B?QmtJRS9CYktHN0FiVlN3QlN1bFFSZURQWEVMTnY5dU9odDJvLzBaMzlNUGRO?=
 =?utf-8?B?U1doMG54K201SnZIOHBJbU1tbDZYbWdacERTNWM3MzdIcnZBNUhLN05UZkdz?=
 =?utf-8?B?YXBod3VxUDlPeFhsdkVjck5mYTZoUi8zclJ6YS8wOGJ6cVJYR2FlVThwT2Z2?=
 =?utf-8?B?VnJHbkJEaXc3QTZTMDR4Q0IvWWpZd3VuWVo3aitKTmhXYmQyZE5CaEl3cTBX?=
 =?utf-8?B?R3ltN1lzRTBVYlNGQjZNOG5XUmx6WTlrblQ2SitOaW42UkJHeWg2b3ZheThp?=
 =?utf-8?B?ODJSWGdJQmZ1MXRrY2VRQitOY29GZTFLbGJBbWpqYXY2YXh4aHh5dDZlamlW?=
 =?utf-8?B?MWVRNUZVeldKTlYrc0g0MTg2T2Erc1I3ZUJMTmVuNHp0MzZEcnhqQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d88b6db3-536b-41b7-ea96-08df44276a9c
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 21:20:19.4967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9inGSi410O+7OM7gNgcyaQsCR9LFPmmXyqW+caFmVGU9kE5X6snKn846ik1wP0aj3k47/9kAQoxqHng4Q5r2Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9010



On 16/11/2026 15:04, Jinvas wrote:
> arfs_create_groups() creates up to two flow groups in ft->g[], and
> increments ft->num_groups for each group that was created successfully.
> If creating the second group fails, the error path frees ft->g and sets
> it to NULL, but leaves ft->num_groups at 1.
> 
> The only caller, arfs_create_table(), calls mlx5e_destroy_flow_table() on
> the error path, which calls mlx5e_destroy_groups(). The latter walks
> ft->g[] from ft->num_groups - 1 down to 0 and dereferences ft->g[0].
> Since ft->g was freed and set to NULL, this is a NULL pointer
> dereference, and the kernel oopses.
> 
> The same error path also leaks the flow group that was created
> successfully before the failure, since ft->g is freed without the group
> being destroyed.
> 
> Freeing ft->g here was added by commit 3c6d5189246f ("net/mlx5e: fix a
> double-free in arfs_create_groups"). Before that commit, the group
> failure path did not touch ft->g at all, so the caller destroyed the
> flow groups that had been created and then freed the array. That
> commit fixed a double free in the allocation failure path by freeing
> ft->g here as well, and in doing so changed the group failure path
> too.
> 
> Rather than also resetting ft->num_groups, leave the free of ft->g to
> the caller: mlx5e_destroy_flow_table() frees ft->g exactly once, and
> also destroys the flow groups that were created. This fixes the NULL
> pointer dereference and the leak, while keeping the double free fixed.
> 
> This also makes the error handling of this function consistent with the
> rest of the driver, e.g. mlx5e_create_l2_table().

Thanks for the fix, and for the detailed analysis.
Doesn't seem accurate. mlx5e_create_l2_table() does the opposite. Better 
drop the sentence.

> 
> Fixes: 3c6d5189246f ("net/mlx5e: fix a double-free in arfs_create_groups")

Say in the commit message how the bug was found, whether
the fix was tested, and on which device. A trimmed oops maybe as well.
This info is currently in the cover letter.

> Signed-off-by: Jinvas <jinvas@126.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
> index c5e62d7..7888d38 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
> @@ -267,7 +267,7 @@ static int arfs_create_groups(struct mlx5e_flow_table *ft,
>   	in = kvzalloc(inlen, GFP_KERNEL);
>   	if (!in) {
>   		err = -ENOMEM;
> -		goto err_free_g;
> +		goto err_free_in;

nit: nothing needs to be freed here anymore, so a plain
"return -ENOMEM;" is simpler than jumping to a label that frees "in".

The fix itself looks right.

>   	}
>   
>   	mc = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
> @@ -338,9 +338,6 @@ err_clean_group:
>   	ft->g[ft->num_groups] = NULL;
>   err_free_in:
>   	kvfree(in);
> -err_free_g:
> -	kfree(ft->g);
> -	ft->g = NULL;
>   	return err;
>   }
>   

