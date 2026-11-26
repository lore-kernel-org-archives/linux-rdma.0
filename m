Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795724695;
	b=NDksgpkWo1Y7EebdlV4ui7O5PQNDWPfIjpU7vZPgKGsAqUyyfey3C/HpZKhKNDndhdKB
	 Z8yDtQ4WDN8JEUO8lbr2UtgO9OcZzOVHZpgLUsjx++1cDjp3wxtJvbf7j++OTE/TPqieo
	 5if6S1EdRyD3CMotOLxAqdAdR/3t8AwNKY0QxXNQN4cqWw8Ucw8TCBRAlFHSREy+006Yj
	 k74C13AacA2j04cDETd9eo7Q3UgQ47gdEGS0KgzWjfV9PXIoNYnGVvhNnouc/tzC/7sf1
	 JHgV2o1WWxM0KbWIvkFDlXkHgiwpRHgyif1LPTFLWF1Vr20HMuNBKINlPY1eywVKXEg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795724695;
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
	bh=ARcsJjDoB+cMwtakG+/Vm8ERqlvNq7SV24zi0KG/p6I=;
	b=3nBt76jtZJcx3WT9miWWZJPbMR5i+RAVJ5acJuowIVAVrVAToQH+/RQvUs3fjMFPfYtV
	 dJKosHkhJ4RCV8kbYKfq9lhcG7Pv/RuXaEo1vU8PXLr7pWiY1mcoSF9/Fz+t7UMvXTOKK
	 mdQ5pERt3XFmiIfdKP7TEi/HWYxxe4peDZsJ8bp8V9AuPT6NwRme0DOIZRRpw0+5bUDUO
	 Swl27B7l2agHaYL7Taj8bFMqvMdGKC9BhdgoS80Q/9l7Zl451vmTc6lwgiCz1AYksiYku
	 Pdj4JALLzjWZuTmneGhvwzE0wP6F65/fi4yvXaAG2dpo8MZGmFI1A+Ij/wn4j/AQhug==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PczvHMMy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.21
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9D5606A31C;
	Thu, 26 Nov 2026 20:24:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A9D5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PczvHMMy
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NMbzSZEScXC+KCwgaYgY0rj6uqd3E9wxABaTjSzav9VE9JoxjrUQX5ViJceOJwvdntvo9EHpucG+mMUtAskgwdmenvAhW6FHmr3m4l24PQVlAKIk/y1xrTQGZMR7drhBdLz25EE9HmwIJUchdez5EHlTjaF8+W4u71vFt3jCXfPEFAwCnaiBPnojnrpXIAL19Vkuzk12CELyQDT64cq3m8GAFy0II2Gn0WuHxqhyZmmf4Vi4WMYuNmd0RG5Sm4gB0GY0veprHOcqLfoIZXwKR+WIZs/h8j/cPPGMtOn19YkU6GRyiWLn4aX5udNbwJY3USsL+QaaIfZUgZzftKrfcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ARcsJjDoB+cMwtakG+/Vm8ERqlvNq7SV24zi0KG/p6I=;
 b=DefhsgPwsF5j0JpHLIglDKhC+WpPOdCgqoa9QyyCCaHWp8d3QNj5mj3Ya0cF0qq/5y7NglCKUm75wby2pHJGPbezG4BGUUzYGsM5/qH1ZGFYoceo/cuHQ9dZYqQ6E7pl+9nVY7JnjhdcBO51emOwOEQIMPoK8JDzdTBSeppk0Lk27+Op/Af5+45RK0zTuDxTpe7uaKs6fORbiI9n7NOsO2fgfnTysTrPVs7dcChaIjfcX8WuBUoYdwrHdRKtRfvbG/MJ28EKs0HalasU2nTm/XoLapFf5D8dAMCaOATK05mEhwla93bXiNxXzLYFQ4ajYMdNgyaubnAOHXwLbcttCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARcsJjDoB+cMwtakG+/Vm8ERqlvNq7SV24zi0KG/p6I=;
 b=PczvHMMyJqB9vcNEI7ejfdUXtMUtdyfU5Mp9P+uJD6Y8iIOw8ACwYIM3CMHD+CvgI9rBxd1Fyjz6CRhYxMyzmojGrxhP9y+3182ursD6844sXJWLNOBBfqcmJW3UsOG+zmVBYG61VXETuzNkePJyGbI4TKEKlBrn4VPkTd0BrhtswLRZud6TiqHiGw+tbPY/iM4Mx6c/XeIb7fHjn42nPZk7+zA+lzG8tTmCLqbMuDyEuTdyFy6hwiwFjgSqKfq/p1F1EyunJBYABa5JfTox1bYr8BDMD9ZvrIhPNIBm18A3Y4kM8+wEle19F5N0xLLA6uUPnbccxyf0oieioXEmRg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20)
 by DS0PR12MB6413.namprd12.prod.outlook.com (2603:10b6:8:ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 20:24:50 +0000
Received: from BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df]) by BL1PR12MB5873.namprd12.prod.outlook.com
 ([fe80::e8aa:dc7d:992f:93df%4]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 20:24:50 +0000
Message-ID: <ec5bb13d-7ef5-4150-97c6-bed18c7333c1@nvidia.com>
Date: Thu, 26 Nov 2026 22:24:42 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/mlx5: Free the table after storing failure in
 mlx5dr_domain_get_recalc_cs_ft_addr()
To: Wanhui Fu <fuwh1120@163.com>, saeedm@nvidia.com, leon@kernel.org,
 tariqt@nvidia.com, mbloch@nvidia.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, muhammads@nvidia.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261126132229.4028110-1-fuwh1120@163.com>
Content-Language: en-US
From: Yevgeny Kliteynik <kliteyn@nvidia.com>
In-Reply-To: <20261126132229.4028110-1-fuwh1120@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0006.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:2::6)
 To BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20)
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
X-MS-TrafficTypeDiagnostic: BL1PR12MB5873:EE_|DS0PR12MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a9e66e8-9f1e-40de-2683-08df4bfb5218
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|261009223027099003|18002099003|22082099003|921020|261102123227099003|11063799006|261028144727099003|56012099006|10067099003|261026121527099003|261022105027099003|261026140227099003|261021121427099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	xGR99k2R1SMfhYNdaefDufb+sAk5n/GkTypYVOqnkTkj/CXefrxJlzkai+wYhla6qyxLAlWeZG1XuuI9OZKbFAIqlHmuDWXI1fBu0An4IY3wpTIl1Bq22ktnqEnPfZdOaLAWVBATCDDaxKlQSAlRh9OIaOBexys6RQdCYAR1VtqSQv/cnSwMNbcRniKZqqwDdesZkQSK0jGCeqWg1Q0yaxuAEi2vCUq6drGCjYv4p1MHZKQOWUF40/LJ86pukVrOZFcK4Dpi2hH7yvQF0pBEbDB1H7xxf4AFLKMx6HAsjJn6tn/P2BfddMFGRqMEqVDvJNgT1Gdjj8s3Wki3Nojg4nMgUsL9LeG/8p0uU3sBKhN2GnWrnYcPd6UhEYsalFyyVnmv5EMTHKbH8FFGo6ydIus3p2L1JBxdRmTI3PRlDhCtMOXNVTltSrOYgXFnlzCC9Cr72kc2tNv888/YBp7/kZ0tiJ/BhW1eL2i29LDpn2mdsqOJjtYHCOzrWU48nWIktdji8ayZanqeblRcAexE7LA4lXt8rFv8aOea/PXym1CH4E6NfT/BXFf1tBwp/ZbkEQUg3fFBpc1pTphceKA/8l78EaoYMnBinZ4/LVkjwx2yUYCtmSlNV9D/Gh8t5IXhmO5qoQ4SVtoaTDtl9tUNRrm8jrnp6KE21m4dacgusOkN46VU+e5gYyZ7e/jbfZKGHFRy/Gp/R9X4O8+m4CbEhw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5873.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(261009223027099003)(18002099003)(22082099003)(921020)(261102123227099003)(11063799006)(261028144727099003)(56012099006)(10067099003)(261026121527099003)(261022105027099003)(261026140227099003)(261021121427099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVN6Z25udHBkNDZuLytScGVjVzZGZHo5bmlubGZTQ0VJK3ZIdjdhRVNSTGh0?=
 =?utf-8?B?TEVCbW8zenhCOGt5N1lNb0dlQ1lMZXhyc3NDMngwZUlpaHh2YVhoV3RCVTZP?=
 =?utf-8?B?YlZrK0FKbkhrZWVBeWZhVGExT0FNQ3RpcmxlVmI2SG1JR01sYkdpQXdYU0VG?=
 =?utf-8?B?Y1hoQ3V5K1ZGTjFiTFV3VmNOYkpXdDBITHhQb2tkRTBFRElsMEJoUU03ZlNM?=
 =?utf-8?B?QkhuU3FhVTJURzlWS3Uwdms1Uk1DcjRMcnc5bHVJYmI0dUZWYTNmRlUzKzlP?=
 =?utf-8?B?NlFQb3liWkJyc2U4dmthRTM2MVRsTEUxc0dYY0F5NlZtbjdldFBIemVxMC82?=
 =?utf-8?B?ZUNnOXB4bSt4S01Nb3B3UWNMdVlSTm9kV1lhdVVJK1RHS3FqbitYeDkveXlx?=
 =?utf-8?B?bTl1czBVeHIrRVpsYWc4QUV5TFNzQ1BSbHBCa3FhTFZvS3NuZXc0LzFib1d5?=
 =?utf-8?B?WTlsejVrTWFmanNRbUNRbmJUVVF1RU5aNWNKR1N1K0hSSmRFMW9HQldPYW1P?=
 =?utf-8?B?VWdVQVl1RjNkMG5adWdEQXhVTjhaajdaVDhSa3FZR3RrRjVxUXZsTG9nUktU?=
 =?utf-8?B?bkhqM0k0Z2ZoVncwd0x1c2Q2Mm9rdXk2SGJpMmVPSDVaaWpEZ2g0ZGJHNlNk?=
 =?utf-8?B?NXhOdDdtNUFnRFBRZXMxSTBBb212NFZoTnpGMmFNbnFlVjJad2I2WEhrNUsr?=
 =?utf-8?B?SzJpN0dRU056dmw5N0JRSGtVOEgweWRVdGVDdElZVWtQU2JjYlVUbVpSWkxF?=
 =?utf-8?B?b25CcjIwN0dlQ0RKemxqUUxmZk5BNFFRRGNDSlBpMU5sQVY0Rnl3b1IzY2k1?=
 =?utf-8?B?V3pydU51ZHNpUGZmbU8zeTlXRmhLa3ltUzBRR0N0M0hTalhuQ3hDNWdSWFk1?=
 =?utf-8?B?Z2liazJjREd5S01PT3pBWWZnSDVCUEtaN2c2aS9MbXJVeEc3c3RCNk56by9Y?=
 =?utf-8?B?QTJjNkxYQTAxTmZibXIrOWlhN2Z5ZkhoUWp1ZGNRMElHU1hQRWMwQVFlckFs?=
 =?utf-8?B?OGdYWktoMVRueTdkMHJxZnBtT0dLL1AvYWZxeEFJMGdMb2VzZjNlajBOOXBq?=
 =?utf-8?B?ZFdIU1dDczRWU0tlNlNEeWtSRTBHa0JIUUt5T3BNekx6YW42QmZlN1lxZkli?=
 =?utf-8?B?aWJYNDZtRWtCOFFUMlJuSVBWRWRaeFFuQzNvU3NwdTViZmMvSjdYZkpZVFp1?=
 =?utf-8?B?MGpBMWo1YnptNkNVVTVDS2xSN1JmeTJUVXJ5Y1JrSHdjUkdSSnM2NHFRWEwx?=
 =?utf-8?B?aDR4a1ZaNTY1c1VGUVRzbll4SGhJZERYalUrbSt2cVdXcFlxQzRkYWdvR2tN?=
 =?utf-8?B?WThVTmhIcFBLWTFKRWlHT1N2R01uL09QRVpYZ3pTZll1bTNiRzdQYVRNTDhP?=
 =?utf-8?B?ZzNmNmhCVXBveWRrbUlKZXdMdjk5bUZwcE1haHllL2FRYXpTa3VTN2srZnha?=
 =?utf-8?B?MXRaQlgxRjlsQ2toY3lRMmJYeTB6YWxqUmhGaWlyQmU2RERDODE3NWxQTG5w?=
 =?utf-8?B?eENsUUtKcXV0UVFjZjN6VTN5UDZsTnBQVGV0MXZqRDNxTEY2bDBrZ243VmRT?=
 =?utf-8?B?ajBNQTM5aXdlQXVRbkozc3lwL1ZTQm5maHovbTZ4RTcyS1l1TG4xZkw4RTlz?=
 =?utf-8?B?K3plV3RieFYrWlFoSC9hb3JIdjE2ckNhNDY3REpsbG5LUjJsT3N2OFh5aGdy?=
 =?utf-8?B?NG9VRStaYWgzcllUUmNIRWxNZ0JrKzVMT2twdFJZVVQ4K2xEM0wwVXpqc2o3?=
 =?utf-8?B?T3VKc1EyRlR4RmhCQTl2Z2NNeTkzYzZGM2hJYk0zQlhabi9RdGlFVHRialZF?=
 =?utf-8?B?R0FnamdqaFNmUGhDQlduWXpkKzBCd0VxQzhJcFFXbjlSM2tkSkx0QUtkUkF4?=
 =?utf-8?B?NnFEVWg2dVd4cEVveFpHK0k1bmJuWmNMUmlKMC9xMmNQNFhuYmtuN2tTZjFp?=
 =?utf-8?B?SHdJbWswZlN6SUVhMjEzSFBmQXluZjN1bXZmWkdSRzNQaHRVR2YwZnRwTGVi?=
 =?utf-8?B?cmhzM2t6WlFLdUI1Z2FtL3AxWFZhbHVJZi9LMU0raGF6M2NvSHZHbEJEd09u?=
 =?utf-8?B?ZFcwRWRLZG40STQ5R21DY3YyMHdHdGpQZm1Da2t6QXR1MDlFUzJia3J5M3pN?=
 =?utf-8?B?emVpd0ViY3pWNkZoVWUrR0VidnBzOVRCVTluZGxJQWRzZWkzTlAwdkFQRDBP?=
 =?utf-8?B?RUlzSWZYNnNuSkNHRXkrNnpTVFdSTGRSWk16R2FQaC9lOTFtZ2xBc0hIblVT?=
 =?utf-8?B?OHcvV1gwdHlvYjJsTHp1WU5rMDRrbnhGelJjak50RWdDZENGbjlyZzkxSFgw?=
 =?utf-8?B?NmVvKzFqUHBNbStEQVVUZEREYjBTYmtmKzBVVTVZaytPS2QrWUZ6UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a9e66e8-9f1e-40de-2683-08df4bfb5218
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5873.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 20:24:49.9882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y5nlTqzSboZzinVm9JwYjF82Yd7oT3zxMW/oUT/AeqU78nOXEqNct61i4NNcZHIR52ewsHEDZVL6i9eGe14vKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6413

On 26-Nov-26 15:22, Wanhui Fu wrote:
> If xa_store() fails, the entry recalc_cs_ft has not been stored in
> XArray. Therefore dr_domain_uninit_csum_recalc_fts() would not destroy
> this entry. Just call mlx5dr_fw_destroy_recalc_cs_ft if xa_store() fails.
> 
> Found it by a self-developed static analysis tool and compile-test passed.
> 
> Fixes: c0e90fc2ccaa ("net/mlx5: DR, Support csum recalculation flow table on SFs")
> Signed-off-by: Wanhui Fu <fuwh1120@163.com>
> ---
>   .../net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c  | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
> index fedefb565a21..3747c217b61c 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_domain.c
> @@ -87,8 +87,10 @@ int mlx5dr_domain_get_recalc_cs_ft_addr(struct mlx5dr_domain *dmn,
>   
>   		ret = xa_err(xa_store(&dmn->csum_fts_xa, vport_num,
>   				      recalc_cs_ft, GFP_KERNEL));
> -		if (ret)
> +		if (ret) {
> +			mlx5dr_fw_destroy_recalc_cs_ft(dmn, recalc_cs_ft);
>   			return ret;
> +		}
>   	}
>   
>   	*rx_icm_addr = recalc_cs_ft->rx_icm_addr;

Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>

Thanks
