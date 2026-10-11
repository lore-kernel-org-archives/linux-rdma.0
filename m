Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013020.outbound.protection.outlook.com [40.93.201.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BC93546EC;
	Sun, 11 Oct 2026 06:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791701575; cv=fail; b=ELKcnFJ2PIGSxa2wK7FESzLNCOVAQjO6MibHarsOygqqp+nEu9823azm4j1xWlArTUeIXnEmxSzlsQB938lCQ1fihCFPqbLllSFq8XTWKb1jmMRtwabLJpQjbaTaWoKwVV67e9BCbmT+x844Atn04FW+Jwq9GB7NSKJZFmLCgLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791701575; c=relaxed/simple;
	bh=rspXbUxsH7BKSp98V/vo2+4x5qTrN0HWAMV2UtL7bhg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g/Mk1zulySG3ncrDgHSsJFnrdEubzwq6XSw3xyXwD45k9HPX/U/wK1oVr1h98HXDmcUZY8TQTqv8vu894M+zeZ5vkKI+Um6WQG0WwVNtoVGO5gtJQOA8yvJYC/qAIPglLAMORm4ytSIAS27fUFEA5cOG+1pwGj2y7yx08yRXa1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LYFZIKTy; arc=fail smtp.client-ip=40.93.201.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LYFZIKTy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jdDVVxbVKjM2fsaij9V49Pli5I6Jgdt4czHC8bj5TEbZLXk352IwrRCKB9zY+GoVFat2u2shJVHdzwW/lFKn7EpJnxM5CBZoWNXHoOFrxDyG5uhD3ATaqfDnjCsob5SsSpCCqTD3gabbv0qcuMEWoZpK/1XJOfx/rSAW9W/VijPRfwo4TfDD3kON9z8cGvDO+13VGOpTevfjTd8HQ8G5dMfrhKkoC9wu1HSVZUSicA36RNu5XKWKaHVvPVHm146fUbLGAein4OJHHx4EkXpxuXrHfc1VU18bc5jTA5C7x9MSnAJxxmXeWqSUgq5hnhW9QFw/5gC4pdHsUG5ko2S1JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HONd5Ish3JvCMHUXIGTmLqrZEwVlxvEb72FpqEG+rYI=;
 b=ozMVajeO3d4rNGYucbMDiZ4oOk0exo/AdhMQHomXxmqKxRba3YKd6Z9e86uiHzzdDae7sO3TyWmHu9Pv4iymflTxWDxAtUXCZyywJgmxTB1kslM41Q+5XqR/gnQsXNNLNezcXbNJ50yZJuZyPckAaSZ/diK36DBZyJ9R2tBxoZSSzSd8zaVNgIISVtjbI8ULTbj3N6Kb/yZFGTl3hBMhpoNAXi2HxuG6K9FxMTKCH72i32reCfU3qeQlUtfAoK0cNg9YM0rSlI/o4UEfL9mLtmCaIV8OMXXL0Bc260uNRYjusje19Znw1lfpAkTJhYRips++WGinnFe/7Vv44NMLKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HONd5Ish3JvCMHUXIGTmLqrZEwVlxvEb72FpqEG+rYI=;
 b=LYFZIKTyNhGLFMXQvwYbo2RvLGYRA4sX1D0VjJPJkQsDm7D5WqGjqPkLiJ4Uo2KM0zpG/mgozOeT1tm1OJ/oAEdTZCAjhYw76QoRadipdhQbe98RcctMF99mB/jni0G5s33R10jR59mmDFZFqk+qWZ1kuWPV5/bjXxOvFiij9yfvExIoDe2w8Q+O03OTLkeEBT5rkF1LtgOKBq1wC+XAAOQQTcdByYMTyxx7eIGQ29AGr/x6P6HpOuv66SyYTutNqCrP06/yL/MSmpzwJhZjaGHcqz57PwYtRp/CXkDN9txjViLGdrQRAVpWPpn874mPhHJoFP/WjSufrHJN+4okQA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
 by MN0PR12MB5930.namprd12.prod.outlook.com (2603:10b6:208:37d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Sun, 11 Oct
 2026 06:52:51 +0000
Received: from SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc]) by SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc%3]) with mapi id 15.21.0472.015; Sun, 11 Oct 2026
 06:52:50 +0000
Message-ID: <9b49ab1e-a50a-428c-914e-0231bc59f5cf@nvidia.com>
Date: Sun, 11 Oct 2026 09:52:47 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 2/2] net/mlx5: HWS, fix flow meter offset within its
 bulk
To: Moshe Shemesh <moshe@nvidia.com>, Alexandre Cassen
 <acassen@corp.free.fr>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20261007143830.1733583-1-acassen@corp.free.fr>
 <20261007143830.1733583-3-acassen@corp.free.fr>
 <03f7a3ae-e223-48bb-bd4c-3a12288257b0@nvidia.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <03f7a3ae-e223-48bb-bd4c-3a12288257b0@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL0P290CA0008.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:5::19) To SA0PR12MB7090.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7090:EE_|MN0PR12MB5930:EE_
X-MS-Office365-Filtering-Correlation-Id: 592c3b77-8665-4d21-61cd-08df2764445f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|261009223027099003|11063799006|4143699003|56012099006|10067099003|18002099003|22082099003|41080700001|15866825006;
X-Microsoft-Antispam-Message-Info:
	6iinf9FH7hRnirFe/DGc2bfet6zTWNh84fsfqyM/Xay4eud/wcO9fglQkADkdX7ckvK9aXgcPKAs35OJOui6ul5XhmtxflfNhCx0B0gZ1XRH2xWjgJVPJxRven1/ODBsbznVN9TEcJO9g/R2z+RrPJUH9c2TYwxZ04A1jx8eT2IRQRrxqTR7sT8sG3TSS9jMS9YR+qxI3w9cmj8bDb3CJmrVEflwa4zLwqxvsKjCongoU7N5fWmz70KFaelgyc+AqzK2cmUogmHE/13kmXSaZa+kvr5waGtGjU4moGie5MxjUKVj2LpwSpb3d/Bbsa1qoCcXHOFQG5WLLAOaA5cmIAWScNNsaE1fSKtT06vw3r9rT0HwV7kTXogpVCSfzjfGCYsVVsRiZcdoaYai22HCe22LRfab4Jh+d2fvb5naV1CMD2+OUH0xeL/NMY8VLBRZmSsJurb+YGQJycL6//C3U8iOfeNuYGShEz2YjelojlkwXe1SVqrErwsQktXUGDUJyq4OqCs4diDZWvnIUXTK4FUl8DbXgWjVxO4aPDa9VFDTtEmX9WvBSFBjj1T+01DcY9xw9nUeN0jCPtcaFTsKhM8/bhCViHk2f/7pFdmgWxomm3K57DarvoqlZ/VrGi/eJ6phzyZ7zMfPE5B1RbKAHWN42bKfT1F7U25fUEYGm66cbwIKjcrSR1QnGHBCxlXoyuF7ZfgM4GmpJqEKCkQnvHPYw9mySincZx7P+4QqlsF7vGJ/oWFGgY4ZCCCP9Mav
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7090.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(261009223027099003)(11063799006)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003)(41080700001)(15866825006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K0tiL1VaREFqV2loVHFlMXhUTE1pdHF4S1NzZWVLVjkvRkVOenlpcjQ0R1Fh?=
 =?utf-8?B?SG5lZEltUHZNak9laXJsUDNSR2VOYUtqNW1GTFlCNEV0dWV0eDUzR3RsK2lP?=
 =?utf-8?B?MXNPY1dwNVh5MjhEN0ZkeC9OZ3pIU256QkltK2VUNndTQ1ZLSmg4R015TGpS?=
 =?utf-8?B?K0c2MTBZS3p2QU5ibGd6d1p0SXdOZUIxUk41dURhaDRYL3FiWnI3MjNva0Fs?=
 =?utf-8?B?K3BKaDM5VjdaekVLRTYxYXBEa2k4Y0RZWXRTZ3Nxc3piQTJvamdlVEFqTXpo?=
 =?utf-8?B?UlMwdFk1ZTNxNkxwaUdpRVJKK2p1bFowaEVwWWUrSlM0cy9tWHl3UzM5SUdH?=
 =?utf-8?B?cnRyQmFmaVQxT2hxT2ZxVTZ2QlBHVDI2NGRhak5tNGVlaXRoOFJBT3QwNlBZ?=
 =?utf-8?B?em9vcUUxZ3B2aHptWUl3a3VVbkdHQnRkZ2dMVmk3b3B1d2ZZZVREd2Z5YnZL?=
 =?utf-8?B?bGNRcTl2MWhBb2g0YnF3a040RkpwVzRxbzc2M1YweFdZZUNqVU5qdnF5RjI0?=
 =?utf-8?B?bmkvdldQeTV6Um9laWlKUmtLUE1NTHl1UHNxMmVXMGlMYnM2SkIvcUNxNlVi?=
 =?utf-8?B?b1dvMi8rOUhlYlVZcE9FOHVSYnJXUHFlYTBLZlhlb0xpNVc0Mlo5cEpJalZ4?=
 =?utf-8?B?UWJPeks3YlVWUFFEQ1NoWG5UcDhqaTlRcEpxamFSTkZ1eG9RV3BkYUZGVGdP?=
 =?utf-8?B?RlllU3hESzBFa2JvN290RHVMRStVbmVNN3FxUWYxZFBLN2JQajNVaXcvQUlU?=
 =?utf-8?B?dmk3eW1icDhxVnhzWnVCeEFyeEZVbys1TktMSUVHNVFEZ24wT1NWZnlUY2lS?=
 =?utf-8?B?ejNscXlNa0xKalA3U1hRMGNKbEN4a0RhY0dCZ2pxSnlqaitEcDlHcmZaYWFU?=
 =?utf-8?B?bUx6ZWVEMEoybWNZZitiMUs2Q0lIM3Z6cUE3eE5TU0pDcEYzc0FmeFNIOHI0?=
 =?utf-8?B?bFJWTHJPZmFVWUt4Q1lsQzh5S2pFaGV4NXB2YzJZUkhMOUN5c2ZrYm5sM0Yr?=
 =?utf-8?B?cFpKL0NFUWNrRjRVZTR4am9pTHJkWGs3ajlqOGFxMlV5UlNEZzR6N3QzbWlw?=
 =?utf-8?B?RVlldEZsOGRiY3ZQVkpOSWlvMmdHb3NpOGM4NGZBQVo5U1k5VXVRTWdtMWtY?=
 =?utf-8?B?eGZHUFpCMkNGUXFPc1NHRUxxOGtUK2lndHNGbFZ1N3B6RStITmxVK1VuRUU1?=
 =?utf-8?B?dVF2SlpINW9RWHVGaWdQN2VhZWxObVdUOG1UZk4zeFRYR3h5QkxIVCthMG5v?=
 =?utf-8?B?UXR1eTNFemRmN0ZCcTk2dTdQaDdvenJObHZ4Zm05OW1iV2ptaTNXVU92VC9R?=
 =?utf-8?B?amxkaE5Hb3YvR1ViQlhUdDRSN2RmZTd5bjdDeU1EMzVVSE1OT1lCWDVHUVA4?=
 =?utf-8?B?WkJmL0VRV0tUSmJzbkwwcStzU3JQWHlDSWk4ZjVOeXpZNHpWNkdETmxWTHpv?=
 =?utf-8?B?bFJMemt4RG5XS3FwRko5UlR2L1JxaE5QR0hSdEdMQlBSSVBLVGFMeG9rTjd3?=
 =?utf-8?B?Q043cm5BWmphZHJGMVI4NGNqUUVoaThEWjFXblhCeHI0bG1SYTJ5SUIzM1Va?=
 =?utf-8?B?ejVtZTk0cFRKZThsQW02bTYrcjB4R0lKeW9kL25wQklnSWN3cm95aGpYcS9Z?=
 =?utf-8?B?VXlGOUtHZCtvc0pqTGNoQXZ6emY4SEMwMGxQdzVwV2VudXIwakJObGZibytD?=
 =?utf-8?B?U0xubU9GZ3AwenZiSFluVmVZeFNxWW9kRGsvR204RFR1SGVZeWFMRmlsTmlr?=
 =?utf-8?B?UG5GM2wyQTVQYzliOXJWb1BHY1NEQTAvYnFrbWRRSEF2a3A5cG11RXVrNUhu?=
 =?utf-8?B?VnA1YUx4N0U2Z25Xcm1sVG1vaXBRYjF5QnhnbTU3QXN1ZVJBQTloUjVpYXNT?=
 =?utf-8?B?KzZBamNNdnE4UndtMzd5RUp4cVlDbmJETlBKT1VhTmd4MjRJdUdMMUhVQkFl?=
 =?utf-8?B?SlVka1FFOElIcVlDRFRGUFFZWm1oYWpQL3FhdmkrTVNpK1AzUlJHWmQ2NTVy?=
 =?utf-8?B?a0ZCcmEyTDJ6eWtWekNEdE93ZGtObW1YMVdDYm1BdHZ2QjV5c3F2ZlBjQmRG?=
 =?utf-8?B?YXBwengyeS9QNnpFdDc0MGxTUlRmaE95NkdHbTNWbXNMV242blJROVhNUVdx?=
 =?utf-8?B?MEVFK0VzOFJXZjlLcmpBam5kNm5nT2YreGNUYVE5djBqRm5YTFhqNUxtS3RM?=
 =?utf-8?B?aDhTQ2RYRFdwT0NOUFBmd1loSWo0YXAwWjcyVDM4NFloYVVKSlhPbWNnU0l0?=
 =?utf-8?B?dWZ4NzJ3eHQxdEdXYWRub05kZGdtMERGUzJDc0g0NG95am8xcHQ1YjA4aTdI?=
 =?utf-8?B?cllVVEJDNW5yTk9Td3dSMEd2NUhyVUNmOXp0RXZwL1FjNlVRdURJdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 592c3b77-8665-4d21-61cd-08df2764445f
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2026 06:52:50.8418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o09oFOO1pkksinW2GyZ49ysh39Hnh+BuEMQe7h6YOdd54i9T2jVPhWVWhWpc0HYHmb2u2IoQiuoQ/be9RN0yHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5930



On 08/10/2026 18:59, Moshe Shemesh wrote:
> 
> 
> On 10/7/2026 5:38 PM, Alexandre Cassen wrote:
>>
>> The flow meter action is bound to the first ASO object of the bulk but
>> the rule offset only indexes the meter within its own object. A rule
>> past the first object runs on the wrong meter.
>>
>> Fixes: 82d3639ef7dc ("net/mlx5: fs, add support for flow meters HWS 
>> action")
>> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
> 
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> 
> Thanks.

Acked-by: Tariq Toukan <tariqt@nvidia.com>


>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/ 
>> fs_hws.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
>> index 44b311b4532d..54761754e657 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.c
>> @@ -928,6 +928,7 @@ static int mlx5_fs_fte_get_hws_actions(struct 
>> mlx5_flow_root_namespace *ns,
>>                          goto free_actions;
>>                  }
>>                  (*ractions)[num_actions].aso_meter.offset =
>> +                       (fte_action->exe_aso.object_id - fte_action- 
>> >exe_aso.base_id) * 2 +
>>                          fte_action->exe_aso.flow_meter.meter_idx;
>>                  (*ractions)[num_actions].aso_meter.init_color =
>>                          fte_action->exe_aso.flow_meter.init_color;
>> -- 
>> 2.43.0
>>
> 

