Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.71
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794209330;
	b=MjhvhV/1jncOhqkQKi8oGpiFOE7Be2Vt6Q85WngUTY4y284akHAeHQEqoBDBmCyV8laV
	 kmIFLR8GJzWAraatfaKz3iEAbAX86ILjl/ub5EXpmnISwH6+r/ywG1DI5vqDTieyBqWza
	 vZZp+qvLSrYNYCGKsXTYBKmTmNCS01dADPdBmlPTPO4liXzd114If4jiOK2V+rPRWMno+
	 eKTVS1vhTXqoJmD995JxKbHCXHblMj8AHFL7yv6O6RF4OsKifl9zhl4i466nAQXNToe7K
	 ijyx/Z2LcpQynAoxHc5MG4OZXjgOyKARUVVDs8xnp+//Hem35jSCacjd4tUqbhUBoLg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794209330;
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
	bh=KWxelsXpY5TWbEJaeV26vxQtjsm1DqeNC7EacOn1lbE=;
	b=K5+RKE2t63ZyOxXMO5WYGTyMffj8ODPEnT2fJaA6x8lxml/SPuBYuwrT8YEvHhxPy5sw
	 od1k7yfpLalKq1sfdEU7L4AsogYgUcTaiKFJgP/m7i3njiV3FxUOZzmuWNZqRNMTzSXoj
	 lEcEC+xA+fZDzy90RfEMYX7nR/R9OPx2BcOYxC5QPjhVe06GaVnWQwDpSVBJMHKWWOCkB
	 0ebu/HK3axrWWH2bRVW8JZR9/9/TW5wo2N8KfG+VZnZA3ISu6sEJQUHY8s8JLfIwTYKNE
	 op/n86pgHHICxmmQz4OJKTzdscevmPeEbgs2oem17PiGPsHvt/ffip0+e2IpFlxeiWg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=W5fCDgET;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.71
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010071.outbound.protection.outlook.com [40.93.198.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C616606A31C;
	Mon,  9 Nov 2026 07:28:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C616606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=W5fCDgET
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G4+cw1513+N/jEYEGd8CCJjQXR5fO/QEu+Ps4dEt9x4pYJ+MrbazJr59dRXWHxAoJcIpXgKyrEvYvYeIew+YXQhFCeI7dGpD2DbDQ3J0KjA10FYPOvk7+pGMOLw/gk55APGDTclvXHUy/UBV/JVvF+9+MBYRdM3h103619VPLuZ9MaClHkmyYXXwmFHrRR4NzOUDmXd9JrUa7pqfYP5EL3CMHGIeAMkkBjOypgTja2WUpIs1/J3bJfv73sODG+hpkIwiftl/GzWGToZ8MoQJaXxLujTaIfIThblOb83KUUMgMbVcCAvGFBZHgC9pvsx44bek6WK+HhmJ8KXKUJU/nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KWxelsXpY5TWbEJaeV26vxQtjsm1DqeNC7EacOn1lbE=;
 b=vavFyCg1UfiDrea9nyvtxpCdfVjZ2SRbNy+3qSzVmZ4s2SVyorOh/seqC788R64u3tqxsdy2RRnw/tsrsyGcwkWjEcA3Bhn2TaFbvurmJhE66bIksCICKZZTAC6/wRtaN19l/UZUTYGFO9RWBsJZtI6UVxqcrUUfaTnK5rMR04phVCv1u4DFTAskZAHdYOjInZ1ygpw39j0uz9fx6RRpTDG7M4pV2NGsuXMUjZefQW6iqjS9OVn2nDBQzlfNSF9FqV9gFS0NoRKO1LHC8S1NbUkBbLBdbC0Zre6YYUksmtoHPPbcvwHw824gUPmucpRSj+epK//NVI5JjS8D6a9Uaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWxelsXpY5TWbEJaeV26vxQtjsm1DqeNC7EacOn1lbE=;
 b=W5fCDgETpsoUJACqqgsuCUR7o8rBVvUG6gtVXrrGLwW3iLH3plHHcq5QSd0nm+1PyGdEo8WUZHf9OkoUOOZ0w3v4tRYTk0YtYx9jvStiVm26/7mOQqOjAemKOXFnz8B5JjSYi8YMutL0sacqibNv0YGVd0Ds20JOmbDb6rvCEJb3Rx+tDtT45qMEtb+frLN0UYYld8tJ+JJgaq4MHJi9mBuFa/saRDY2qCsOxJH88Y/T0XafpNMuDWKecM/lLjy4gefX572CaAEcbl6IcDcsmGjw/UReIgjTILu3+9S/3vCAKLBiMcfOedUggugHnPPrYXPIump2C4v155bsFy11eg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 (2603:10b6:207:12d::15) by DM4PR12MB5769.namprd12.prod.outlook.com
 (2603:10b6:8:60::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 9 Nov
 2026 07:28:45 +0000
Received: from IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f]) by IA4PR12MB932075.namprd12.prod.outlook.com
 ([fe80::5a6f:1f74:6ccb:cf2f%5]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 07:28:41 +0000
Message-ID: <20c04fd0-fd61-4934-b54a-81e3f9d64f7d@nvidia.com>
Date: Mon, 9 Nov 2026 09:28:41 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: macsec: Don't remove fs_id when adding a
 rule fails
To: Changyul Lee <lcy8047@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Sabrina Dubroca <sd@queasysnail.net>, Simon Horman <horms@kernel.org>,
 Joas Antonio dos Santos <joasantonio108@gmail.com>,
 Patrisious Haddad <phaddad@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261105003419.4016283-1-lcy8047@gmail.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20261105003419.4016283-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR1P264CA0057.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3e::12) To IA4PR12MB932075.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: IA4PR12MB932075:EE_|DM4PR12MB5769:EE_
X-MS-Office365-Filtering-Correlation-Id: b03d41cc-7f5b-48aa-649d-08df3e33145e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|921020|261021123027099003|261026140227099003|261022075727099003|11063799006|261026121527099003|56012099006|261028144727099003|5023799004|261009223027099003|261022105027099003|261021121427099003|10067099003|18002099003|261102123227099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	o0mKpVbr18EJW9HH8r8MRLY36keNiHy/E4IGxfVY6dWmKJVznJ5koDcxgh/HUD9Gh/fSlKK9OrdMFNkkSbdA6SnGX7tQVOubqOJHZ4Y8zXsPJi3JaEckCCCu/IcDLJ04tGER4UEyn/Tz6qBUI4F3MYiVPw4vzVH/tx2OHqWNWX4R/ES1blLF5a8unvpnhi90/K7nlaRuoyE6vxKJpnrDIAMexROAfiycZOC9P0TwEsTe/wCfwQ9nIcJOnPKlckkVpei3XCBVVCGYYshQj+6koEZyJz2pk+JO51fQQqugkAZgt/OAz8lZIA1XjdoiJFlxaoPSAb/3nvZqZlkeg0l65onKjVPORBJhkP4GbkX2ADw5T1eafbVeLlIOFkj3z3756yYE9IzXoREPOGKgYMhW+MNfN/l0QLR8V5ltUKhv/V04or6GZHddBoJ4zxwYp/JhbWFg2pIxQHipMzORGrkKdZHDVBZI/UKwFngnDRCKgcd2twaq0jRHC2aGW03+F8psiy07/P0GSuoQhaEqwndnAKh32aSVkdl3OKaK9ojBMMqM4Dv9V0qf2Oe/Ws8M/VPR0UnvM5fSq5mJoFfZbingsV8h17Y7Ui8574qF2N8SU2M2h8hPc8EwqxcHU/9P8e1asgzQ2roaJf80COx02N102NaM3verYbgz6gDvPaFc/aXd6prW+Z/+XC9nO7bzTIiEb81Qdf3Yg8X3Dt3qkDzdsQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR12MB932075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(921020)(261021123027099003)(261026140227099003)(261022075727099003)(11063799006)(261026121527099003)(56012099006)(261028144727099003)(5023799004)(261009223027099003)(261022105027099003)(261021121427099003)(10067099003)(18002099003)(261102123227099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0x0cGo0clIwS3BZZFJtZG4zRDB3aWRJa1dqQ29sZ0NEalB4MU1rRkEwMU9P?=
 =?utf-8?B?SUlHOUUwdlNUTUZqU3F6dU9hWVR4TGlUakhUZVNQaGdEdUtBOTI3WnVPZTlv?=
 =?utf-8?B?KzhFdmdLNmZPQXQ1NzBTcXBWVGxIaExHc0lQVjdJdHB5NTVYNkFOcUVtTGdN?=
 =?utf-8?B?cGg2NC83YlVJMEhaVStxT3BZQm0xakNBRmJid3l2a2phZ01RbHJGRXhvQisx?=
 =?utf-8?B?bkRLM1plNENoVmcxd1IxZ0llS2h1dFVCemRBUUw3SmRoR2thZUVKL1U5bFVH?=
 =?utf-8?B?eGl2clRwMUJNRmlnUTR4dlExSTVGaGxENlBZRUJJUVpuNlBFME5GNGtBQVhU?=
 =?utf-8?B?Q0I0d29zLzN5cGRoVDl5RE5zeWEzckZxQVZramZBbTNOTklFcUcvZ1pGUDJB?=
 =?utf-8?B?N0tJbWYyUmVEeExHVFRuR3lKenhWWEo5YWkxd0YwZkxRWmQwaUVOMXJnYWFo?=
 =?utf-8?B?a25KMEtqbGVlcTNqYmUwSlpUWGhNWUhVZTdmNFNQVU1xWjh1T0M3ekppZXpy?=
 =?utf-8?B?Y2FkbGx5L3ZIa2hCMVl2TkczeStLUTNjR1dPbHdmaFFhWGtrYlR2SDQ3dE1x?=
 =?utf-8?B?U3I2bC9UUldvWHF6eXV4QmNvckhhZkw0S2hhNW4xSG9aWUtxdjlQaitHRGVJ?=
 =?utf-8?B?SHpranF5TklHb1hzZ3Y0d2p2SUhsQVpPYm8yTHErQmp5YW0rQVhuU3BZMHl2?=
 =?utf-8?B?SEVzR1B5aWViOEttaXlOZ0J5UjFndUY4aWRKLzg5WEVZMlVuaWIvLzczQisv?=
 =?utf-8?B?NnVFd0h3ZGZTSlV4amRpRDY0NlVvelpoSUVtUUQ0eW16N21zSFZlN3RVTWk0?=
 =?utf-8?B?YnBvR2xEY0QvU2V5L2pmUnJnSHQzajBqUjR3UEVtUXdaeVdxc2FQZEdwYjhM?=
 =?utf-8?B?dm9uZ2VjZDR0K1ZxdHZWdkxiaGhOYkg3WitmRU5IK1BYakQxaER1eVRHZS9M?=
 =?utf-8?B?akwvMk5hM0Q2bEVxbE92dUJrNmllVFdxR1NMbzZ2TkE0V3p1ejhiRHlzWCtl?=
 =?utf-8?B?S0VYNDNqci92Z2o4aElONGpHeEpSYnVKU2o5TS8raTZLUXcxNkxNYkg1dmNu?=
 =?utf-8?B?cHZmbE5rSFU2dWFoY0I1VExqa2V3MUZRQjJ3MWhTMFFQZ0RBUzU2V3RURjNH?=
 =?utf-8?B?VjJmTGNEWjErNVVOZG4ydHV3K2s4YXozS1FEeWpaVnd4ZUZnck9ZL2dQeFJY?=
 =?utf-8?B?MGV5TlZockFGL2tvaTFsOXhkT085R0U5ZUw3M3ZhUmFRaVFrUndrbTY1OXdh?=
 =?utf-8?B?bXpPVkJxWDlqczluU1d5Y2FrV1E1azM0S2VUcXVaRnpKN2pNU3pOZTI2Yk5L?=
 =?utf-8?B?UnJ5bUpFYVdnOThuREZvZjhhNGFhQVNpTFN0c3dYK3FwR1NjMi9yODBLbHBI?=
 =?utf-8?B?NTNzeGtQUGJQQlVrM0NPWHpFMVYyOGF5SFA0Wmk4ODJMN0QyNDRhU3F4enk3?=
 =?utf-8?B?Mk1VQy9YRHdUR283OFdoazEyMS8rc1VsTllHdE1kMnRrY0JNZWRRTjc1ZkZ0?=
 =?utf-8?B?dUZ4RVZTRmJGQld4N0RNMDdSL2U5Ykg0MVJKZVBzamNyR1Q1YWlOYWVDQmU1?=
 =?utf-8?B?RmZwRnFwTlNhckU0NmpNRW1LeUNnLzV3VHJ4bjZsczlBcUlGVXVQMjd4WVRa?=
 =?utf-8?B?Q1Y5TVN6UlZBSEI2L1Nsbmc3N090ZURhcDRCTzVqZmZ1YnUwZVRzQWJRYXFa?=
 =?utf-8?B?TjF3QmdKcWZNQWMxbFVtYXdEVmNwVE16T211SFlVU0hTZHFLL2V1bGtRK0lk?=
 =?utf-8?B?aXNnOTlUVFM4K2FnNkx3aUdNdWdWUkhhVndya2VaVDBwd0VZUW8xeXVLeS8r?=
 =?utf-8?B?SFFQalFZanM5OVdObnBlcytTMjJETG9ubDU0ZEdrZkVieWEwZ2JXYldtUFo1?=
 =?utf-8?B?KzVyeE5OREJrOHkvTCt4anRNMHlLNXQ5djRkYmVBZ040RjU5MWFYbmRKS0N6?=
 =?utf-8?B?UmxGbUhFbEZReXZ3T3E3eW9KbnI1MEdNOUswcjVnd1BHSHlyUFVVVk80RzI3?=
 =?utf-8?B?SnVCMDFwV3Z1RDFXdVd1TnRvb0xCYndtQUVnb28zaUwzOWFYd3B3YUpzU2Iz?=
 =?utf-8?B?V21zdTNsUnFoRm5qenFxTG8xdE9lSXdJYndwOTZtZVdtRUlteWxndlZ2SXoy?=
 =?utf-8?B?bDFuYkkwbTUzN2YyMXVVT2dyODdsQnZ6THhuUlZPQTFpbTdXRnNVaXhEcGNx?=
 =?utf-8?B?ZUVnYkxtWWdQV1pkMUEvVXJXK0l1bWdFa3hON1pjTng4TVZJM0dDQlp1QktB?=
 =?utf-8?B?UCtRTkFiZHBPbjV4YzQ3a2ZYZnNsV3hoV2tZZkJQRW1hZzBKRVRaa1pEWEMz?=
 =?utf-8?Q?FjaSlSaFnWkZtYiW6K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b03d41cc-7f5b-48aa-649d-08df3e33145e
X-MS-Exchange-CrossTenant-AuthSource: IA4PR12MB932075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 07:28:41.7432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nerLGKxo0DSMGfXWWa0dj6/MANmoDmBm9hTFZOYXZdW9wsEi5NhdplFl8iPUptYgp289u1J6aqmREkL9aG5iwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5769



On 05/11/2026 2:34, Changyul Lee wrote:
> macsec_fs_tx_add_rule() and macsec_fs_rx_add_rule() clean up a failed
> rule with macsec_fs_{tx,rx}_del_rule(), which also calls
> macsec_fs_id_del(). The fs_id is never in the xarray at that point:
> macsec_fs_id_add() is the last step of adding a rule and removes its
> own entry when it fails.
> 
> macsec_fs_id_del() then dereferences NULL, through macsec_device for
> the first SA of a MACsec netdev and through fs_id_found otherwise. On
> RX, the SAs of one SC share an fs_id, so a failure while adding another
> SA drops the reference that an existing SA holds.
> 
> Split the rule teardown from the fs_id removal and do only the teardown
> on the error paths.
> 
> Fixes: d4ece08f4b1d ("net/mlx5: Maintain fs_id xarray per MACsec device inside macsec steering")
> Signed-off-by: Changyul Lee <lcy8047@gmail.com>
> ---
> Found with a static analysis tool we are developing.
> 
> Compile-tested only (x86_64, W=1, CONFIG_MLX5_MACSEC=y). I do not have
> MACsec-capable ConnectX hardware and QEMU does not emulate it, so the
> failure was not reproduced.
> 
>   .../mellanox/mlx5/core/lib/macsec_fs.c        | 38 ++++++++++++-------
>   1 file changed, 24 insertions(+), 14 deletions(-)
> 
Thanks for your patch.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
