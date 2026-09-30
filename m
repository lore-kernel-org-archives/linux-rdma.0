Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012036.outbound.protection.outlook.com [52.101.48.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA0051D503;
	Wed, 30 Sep 2026 21:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790803349; cv=fail; b=VonthG/g0zjViF71qNsGj+zg1E8MRzEzJ+nkS2t+4mnJYu7TklVv46RTERkSfU9BQJyiQ1WFDqCG51OyQwCubGAzCn+nv2h5g/AtnG9f2tIKsMEkG4ikBMlFXsuhtLiVCnzkUdsjX5Ts4BXY48T5JTUL0grFYM0Wlufrb+9ML+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790803349; c=relaxed/simple;
	bh=HY6SPOI71nQDb36Bc4jvfcqvs5ytBvYifMK3UWTR29A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CXiBJO/MKyedI96YyzEjbZzFBp85I8HYBn8N4FZW2m2DKbDu9kwvT5lWfxwj+8qWkQfbOwDZwDezN/2NUf4VmDqqUCOAQe+SLQLzbWJW/UCLDXYLUUl50SB7c9VNmG1BhIKKQ6PAWYsZXl1Ag7RGwsBYtAp+FNTDLrgVr8qktrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Rcv2KAb5; arc=fail smtp.client-ip=52.101.48.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Rcv2KAb5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QoftlolfOKBViVg2xwdlVPs4QAeepv8klTDA6+J+EyI93U89fbBdApG6BbXWPmqFXYW9EIsXGfQWIOc7DwkCw2vNKP1PfLdMS8cSduKQakqRKQdPNR+slG7YPfmnldftbUFEROpzr8kib1UDaAek/XUDq+pisJRVeA8qN5jhLLhpPTnf8zDR7pxw9eAfZU9RW+UsZEXpQfwT5AeNOUUm6NABDb/N/V7NME464cNDusCJZGzkqhoaSZ/9QrHHWuT+Je/wT8P0hmMSCeE7Xs8YMa4P9IEWACqLwYYGQVYWDzofJOUylIhkV70j7JblLkP6VlH3HdhzlU9aRjFsge8fRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p6YSpDKAOzb4syxN68+uqKj3ctNtsypW9K8qlo6p58g=;
 b=NP9xUxJ28hsL/iw5+PvH5L4mFJpfaSHSgP4nWdT+kU6Rpbcb6xry7iiiO4jtbo/LQL2gE7i9QBEMj/tgW+NmQ3rfglHQ3R2kZhBEqUpNfRO4YL/Vn88DWfNd99r49bEbTNoJkLeg8LXuvEJQnbjlH5ovQ2c9T21M01vGEn3glYt8P8ABbX348YzTcqSPC4+3VUi0RmTrURRNHRKuMBRze+Ss1YZQ5LUMPbQJLM8ieR9Y3xr80CgWnl7mmW/oHdo5hr7zRwCcajPEgOeL60XSDiQNeUokhEHNeS/ni0MwEhe0gDF1cZxs8eTCgWmXyh1hPbzNXmtBZyP296tIz/q8nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p6YSpDKAOzb4syxN68+uqKj3ctNtsypW9K8qlo6p58g=;
 b=Rcv2KAb5vgfPM2g4dVLddLCR77al7c16KUCqiOgoGIBJtnZySRCU3GC8Dp3BHbcBlr+Rwg0XvhFDW88pAQvLuAFVEtCbdfVuRhjsOSx/3OPu3iy1W9ztI8Aet6Jmk8LBcHJGO8pJGQc0vwqq6gS3ubmR3+pECvULRwLf1RsySloJ2qxpsCecdeRzKFDVj5TmXKW/C3WHIvVd+G3E3f+PYjqLtBY+7KShFRDcckK8dWtH7k3v4MD7iKbws4sDEcU4DcaEPrpQ4woZvgxP1ZWJkuDdtpp2BtS9U0u4N04BwHKxf8fTl3/lPSyavHfL4fLHrRMqEeD2sWm5wIH38VH36w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7) by MN0PR12MB6149.namprd12.prod.outlook.com
 (2603:10b6:208:3c7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Wed, 30 Sep
 2026 21:22:21 +0000
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c]) by SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c%6]) with mapi id 15.21.0451.022; Wed, 30 Sep 2026
 21:22:20 +0000
Message-ID: <7fd8c833-d497-43cf-a00d-3596e707a29f@nvidia.com>
Date: Thu, 1 Oct 2026 00:22:13 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/5] net/mlx5: Lag, split aggregate speed into oper
 and max helpers
To: Jakub Kicinski <kuba@kernel.org>, tariqt@nvidia.com
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 netdev@vger.kernel.org, pabeni@redhat.com, edwards@nvidia.com,
 gal@nvidia.com, jgg@ziepe.ca, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, msanalla@nvidia.com, mbloch@nvidia.com,
 saeedm@nvidia.com, shayd@nvidia.com
References: <20260910102432.3845360-2-tariqt@nvidia.com>
 <20260915015118.875210-1-kuba@kernel.org>
Content-Language: en-US
From: Or Har-Toov <ohartoov@nvidia.com>
In-Reply-To: <20260915015118.875210-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0169.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::11) To SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB239779:EE_|MN0PR12MB6149:EE_
X-MS-Office365-Filtering-Correlation-Id: a4fb5b90-d856-4b61-f034-08df1f38e98e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|23010399003|366016|376014|10067099003|56012099006|6133799003|4143699003|3023799007|22082099003|11063799006|18002099003|5023799004;
X-Microsoft-Antispam-Message-Info:
	xblf3o+zy3vMIoslsWS1BacLcTVmUvYe+Ha6NYdZjIG7j3+KzhTl5Bdurzp3vWq2Vwn5K+t80n6LeHaLll3FijNqfAl4vDF26+uaosUe/9vBE9kz5jEZENspWNyRWYgEtQ+G/Fm4ygecP4suNY6zeX7OvL89SrQUPVc4QZc25esw4AtD5SNMck4Y359Ukhy7yKHIDMRisObzYtsH+CBj/KgP+M9tNF73PrITabOYLAxDo5pBmuZsC2PB7ZgmG/z3EGOVUjQJFCBJUbjhMAHwvwHbps9FlcELjHWNCcUSulPkFsDJ3FcNr4L8X3wQ5+uCRXfYxEvs6XySn/oz55fiQqOD5l8en3xnJQn+9xDpoYEGaygvmqpeIrfNWRZdbwGlJqfaLhtheHJrXKkQ7/8Wn5Z2PqDfdeBVUBYq/4hCGnFkYPMZAU4uejyvIr9p1OCHOQBP6lkeMoF7HVJ2wVyBdOVVjcjssQKk/7q4+2pCPLkWTgcsUq+NUDM+BgKFyOFAhA+Ta2cfPM7/R+4TZdZd8O8GLdsbblLISQVPxYIvvD28a9Rtf5jO5PI2yGIbtfZMF+8rZgU9X3VBwIkM09RXwDNRZs29kRo8LmPAVOoLz0z5id5IVw5U42PlJLRtYzngJHvSMfhBBwcQupw6EyqH9Pl7wKFSdHS8mP7QLHSdZUo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB239779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(23010399003)(366016)(376014)(10067099003)(56012099006)(6133799003)(4143699003)(3023799007)(22082099003)(11063799006)(18002099003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VU9FN1BuV3FOL3VzQlJvS1BCTUkweFJxamQ4YThXRmx1VzhjSWV2c050cVMv?=
 =?utf-8?B?ZHRpMXgyOUEzK245UTBYRm1URW83VHFWK29hQXVtOGtCZWxMNUx6QnRibk5J?=
 =?utf-8?B?c0FmR3UxNy9CcU55ZlAwSFY3VWg1UUdOQzlJMytNa2FQTjVkKzNhRElISDZw?=
 =?utf-8?B?Mi92KzVOZWhVK1MraGNQcDNhRHJIUkpwNlRlRWg3bUlneUhpd1lINmZldUFC?=
 =?utf-8?B?NyswVllUZjZOZGphMTJNN3hWd1dUaEt6akxDcFAzeVQ5eGJVYUN3dWdGTHhy?=
 =?utf-8?B?Z01pWFR5Qkx2MkRXdGRoNWlQVkxSK3U0emtFcjQ3Y0tBdjJvVWxUVE9xNkVt?=
 =?utf-8?B?Z1NwTjhnTnVpUWJYZE9hcGpqM2RmNkZvK1h2Q2NVbWlqSksrQkpxVHBZd3Uv?=
 =?utf-8?B?aGVId3VtcGpwYzIydEQ1SVZ1anpLanRqV0ltV2RqMmR0OEd0OE1FMUdaWEVk?=
 =?utf-8?B?WU5zaXR1ZWVWUDdUQkN3T0dic1grWEc4bmZNc1AzSHZiUm44bUQ3TFU5WWhq?=
 =?utf-8?B?Z2RLQWk0cDNBZFZmQjd1bVQ2eVBpcUNTT3AyOHJXMXVCdFU1ZTZ3Y3dHRFVV?=
 =?utf-8?B?eU9TRXN5VnlrSXNSWjFPclVzdlNreGRiSWlCT3p3QythZU5Hci9EcUtlOEQy?=
 =?utf-8?B?c1Q3TGVDbEJ3L2pJTndaQjhYcTVXNDhudVk0c0RiUkFUY09JTVYrNlQxRG9r?=
 =?utf-8?B?eExPOGVEZ0JXdnhBWm5OTnBtTGhqSFBuTWFtS1p3eDQzN0JiUXlVZXBMeGFy?=
 =?utf-8?B?MzZIaHJoQ1FkRlBKRUc4ckd1MXZ3b0VYVkhBa1F2RmFNeUZVbzVZSFROWkZH?=
 =?utf-8?B?RCtReURoSFdMVlNoM3N3WW5COHpFSmhaTC9BWkZXdjZ4bDgwMEw4SnVHcVdx?=
 =?utf-8?B?RG40amdyZ3FpbTY0WEtDN1BVbGx3d3ltK2hSOUd1Y1NjemdhL1VZTHMyVy9y?=
 =?utf-8?B?MjV4bzhvRXBuN2pMK2ZYdHJSMG1HN1FDZEh0cHNabjVkTCs4QnlXN0ZPZHAz?=
 =?utf-8?B?WTh5cWxzRWU5ejhOTU1CNU1Oc2hnWVFaMUwvckwxQkkvSHZNMkwzSVhtbU1E?=
 =?utf-8?B?UUk3Q3ZzY0Z2WWtib0Q3RVJVb0krV3FPN1c2cms1MG1SaWlrTjhYa3Jya2xM?=
 =?utf-8?B?bEMzYWNSdHBTQWxSb1VlMVE2VUEwS2lwU3I0dzFzOHJPOU9zSzNoNXc5RVJR?=
 =?utf-8?B?Q0lmR0ErRks1dVlycytqb0llOTAwdjl6L1FKRVJRMDJZUUwzV0xva251ZmZs?=
 =?utf-8?B?WGZKUVZYWU9rMitLU2dCZENuY0lsZWFkN0FOUkxJaVZVeWt1WUF0UUF3Zm9p?=
 =?utf-8?B?U0VaaHpIZiszSlRaeUg3My8yVy9RQklTTUdXZ2RveWdTOEduWE9xWVdQbHhD?=
 =?utf-8?B?WDFPMTJwS2pZOHYvZnpwUjgvczB5akJoM3I0Rlp1b3dMZ3ZsUjNYQ2hjamVw?=
 =?utf-8?B?NTloSk9HdWxsR3Vwbi91M0twZUlJUGJHcDNITnQweUFUaStuS2E2N3AxU1pS?=
 =?utf-8?B?MlZqanN0R2p2TFNOMllnRGp0My9UclNVNjcyR3h5ejUrMFN2RDlGenVTbnh4?=
 =?utf-8?B?TnVkUk9GWFJFM0w4NkNlYm10dU4yNnVTYVhwY1pCV04zYVJudCtXRkxTOU11?=
 =?utf-8?B?RGVlMHQ3d09sUG1GR0VZR0VjYi9ETUlRc1ZhM2ZzNTE1YlJiRUREeXhYa04w?=
 =?utf-8?B?Q3cvTjdyaXlkbVY2M1VlbkxyaXE0Y1JHTE5uVFlDY0NpYjYvdmhYSndqdVVj?=
 =?utf-8?B?N1Y5WktCZTl4b0E1SUpsbXJoNUZIRnN6K3owMktMZ3NwT0RKSGR1NDFQL0ox?=
 =?utf-8?B?dkFCcENxUHJERG45cmhrL2ExRStXb2dPNTI4ZEVYNUhCY0diblRDbE8zUmxG?=
 =?utf-8?B?cTJ3aVJ3eUVIZEozb2s2VlhTVEZDcHV6OHJiV1YwVmJ6ZTd6UFdVTE9qRklp?=
 =?utf-8?B?aWN1c0RJMGMvbVF6WkZKM2pFUUV1MitEalNHWmJ0U0FCQVZjeEZFUnF4bDda?=
 =?utf-8?B?L0ExemJQRzZjbGV1dnVMSzlTZEkzVExSM0lJYW5oaGtxbXFHcnA0eGhPZVNy?=
 =?utf-8?B?SmxrMEVPRVZyQTRrTjZtZU1GZThSVUIveWc1NVFSMm4zbFkrTFRJNktHNngz?=
 =?utf-8?B?OUlpbExHS3NPYXA3U0QyVHBNRTFNUHV6WFBBbXl5OUJpaFlrNWdmczFLV0I3?=
 =?utf-8?B?Vm5zeFVSQVZKWjhmRFF5b1BGR3ordzdiZXRKQlp1bS9HRnNZbzRzTHZGTEZD?=
 =?utf-8?B?OTJWVWRNTnBTR3dJY2tNdlBhRXVFUWtsV2xMcFR2VUR5ZXJxWVF5b0x6c243?=
 =?utf-8?B?WkxzNWJyK01aemp3QnlYYVdRUi9SMW1MTXFmMDRkTkxRZVdEMUQwZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4fb5b90-d856-4b61-f034-08df1f38e98e
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB239779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 21:22:20.8371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 492pnRjUE/qfmDie4O4WvbhcwcktASOu28xBFTcO0KEkxccXVf5BUijD6H3cPgChtGladKfBlORAwiPOwM8JVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6149



On 15/09/2026 4:51, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
> 
> 
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> net/mlx5: Lag, split aggregate speed into oper and max helpers
> 
> This splits the single mlx5_lag_sum_devices_speed() helper into
> mlx5_lag_get_devices_oper_speed() and mlx5_lag_get_devices_max_speed().
> The oper helper skips ports that are not forwarding traffic, while the max
> helper takes the best single port for active-backup and sums the ports for
> XOR, LACP and MPESW.
> 
> A few questions on the new helpers below.
> 
>> net/mlx5: Lag, split aggregate speed into oper and max helpers
>>
>> The oper function skips a port for two reasons:
>> - the bonding driver set tx_enabled=false - LACP converging or
>>    active-backup standby slave, where carrier may still be up but the
>>    port is intentionally not forwarding traffic.
>> - the link is down.
> 
> [Severity: Low]
> The changelog lists two skip reasons, but the new oper helper also adds a
> third, MPESW-only gate that queries the vNIC vport state per PF:
> 
>          if (mpesw) {
>                  if (mlx5_query_vport_state(pf_mdev, opmod, 0) !=
>                      VPORT_STATE_UP)
>                          continue;
>          }
> 
> Since the value returned by this helper ends up in every vport's
> max_tx_speed, would it be worth spelling out the MPESW gate and its effect
> on the programmed speed in the changelog too?

The MPESW case is also a port down. It is just that in lag we have this 
information in the tracker and in mpesw we need to query it from FW.
I will explain better in V2's commit message

> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> index c655f6e32e9b0..5aa9d5c98fe16 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
>> @@ -1412,16 +1412,20 @@ static bool mlx5_lag_should_disable_lag(struct mlx5_lag *ldev, bool do_bond)
>>   }
>>
>>   #ifdef CONFIG_MLX5_ESWITCH
>> -static int
>> -mlx5_lag_sum_devices_speed(struct mlx5_lag *ldev, u32 *sum_speed,
>> -                        int (*get_speed)(struct mlx5_core_dev *, u32 *))
>> +static int mlx5_lag_get_devices_oper_speed(struct mlx5_lag *ldev,
>> +                                        u32 *sum_speed)
>>   {
>>        struct mlx5_core_dev *pf_mdev;
>>        struct lag_func *pf;
>>        int pf_idx;
>> +     bool mpesw;
>>        u32 speed;
>> +     u8 opmod;
>>        int ret;
>>
>> +     mpesw = ldev->mode == MLX5_LAG_MODE_MPESW;
>> +     opmod = MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT;
>> +
>>        *sum_speed = 0;
>>        mlx5_ldev_for_each(pf_idx, 0, ldev) {
>>                pf = mlx5_lag_pf(ldev, pf_idx);
>> @@ -1430,13 +1434,20 @@ mlx5_lag_sum_devices_speed(struct mlx5_lag *ldev, u32 *sum_speed,
>>                pf_mdev = pf->dev;
>>                if (!pf_mdev)
>>                        continue;
>> +             if (mpesw) {
>> +                     if (mlx5_query_vport_state(pf_mdev, opmod, 0) !=
>> +                         VPORT_STATE_UP)
>> +                             continue;
>> +             }
> 
> [Severity: Medium]
> Can a failed firmware query be mistaken for a down vport here?
> mlx5_query_vport_state() in core/vport.c returns 0 on command failure:
> 
>          err = mlx5_cmd_exec_inout(mdev, query_vport_state, in, out);
>          if (err)
>                  return 0;
> 
>          return MLX5_GET(query_vport_state_out, out, state);
> 
> and include/linux/mlx5/device.h has VPORT_STATE_DOWN = 0x0, so a timeout,
> -EIO on a device in error state, or -EBUSY is indistinguishable from a real
> "vport down" reply.
> 
> The PF is then silently dropped from the sum and the helper still returns 0,
> unlike the mlx5_port_oper_linkspeed() failure a few lines below which aborts
> the whole computation.
> 
> The under-computed value reaches the hardware through
> mlx5_lag_set_vports_agg_speed() -> mlx5_lag_modify_device_vports_speed(),
> which stores it in vport->agg_max_tx_speed and calls
> mlx5_modify_vport_max_tx_speed() for every enabled vport, so with one
> failing PF in a two-PF MPESW LAG the rate limit is roughly halved until the
> next port change event. If every query fails the sum stays 0 and the
> capability-max fallback below is used instead.
> 
> This path is reachable from ordinary events via
> mlx5_lag_mpesw_port_change_event() -> mlx5_mpesw_speed_update_work() ->
> mlx5_lag_set_vports_agg_speed(). Should the query failure be distinguished
> from VPORT_STATE_DOWN and propagated like the linkspeed error?

good point, fix in V2

> 
>> +             } else if (!ldev->tracker.netdev_state[pf_idx].tx_enabled ||
>> +                        !ldev->tracker.netdev_state[pf_idx].link_up) {
>> +                     continue;
>> +             }
> 
> [Severity: Low]
> Is this else-if arm reachable at this point of the series? The only caller
> in this commit is mlx5_lag_set_vports_agg_speed(), which calls the helper
> exclusively under:
> 
>          if (ldev->mode == MLX5_LAG_MODE_MPESW) {
>                  if (mlx5_lag_get_devices_oper_speed(ldev, &speed))
>                          return;
> 
> so mpesw is always true inside the helper and the tx_enabled/link_up skip
> described in the changelog has no effect yet. The later patch
> "{RDMA,net}/mlx5: cache and use TX-enabled aggregate speed for vports"
> introduces mlx5_lag_update_agg_speed(), which calls the oper helper for all
> LAG modes and makes this branch live, so this is only an intra-series
> ordering observation.

Removed the sriov case for now and will add it in a later patch

> 
> [Severity: Low]
> This is a pre-existing issue, not introduced by this patch, but these reads
> of ldev->tracker.netdev_state[pf_idx].tx_enabled/.link_up (and the
> tracker.tx_type read in mlx5_lag_get_devices_max_speed() below) take only
> ldev->lock, while the writers use different conventions:
> 
> mlx5_lag_netdev_event() republishes the whole struct from RTNL context with
> neither ldev->lock nor lag_lock held:
> 
>          ldev->tracker = tracker;
> 
>          if (changed)
>                  mlx5_queue_bond_work(ldev, 0);
> 
> and mlx5_ldev_add_netdev()/mlx5_ldev_remove_netdev() write the same fields
> under lag_lock. The same pattern already exists in the baseline, where
> mlx5_do_bond() snapshots ldev->tracker under ldev->lock and
> mlx5_infer_tx_enabled() consumes these fields to program the port mapping.
> 
> Any mixed snapshot here looks self-correcting because the event path requeues
> the bond work, which recomputes the aggregate speed. Is it worth settling on
> one lock for the tracker fields while this code is being reworked?

This is not related to this series...
> 
>>
>> -             ret = get_speed(pf_mdev, &speed);
>> +             ret = mlx5_port_oper_linkspeed(pf_mdev, &speed);
>>                if (ret) {
>>                        mlx5_core_dbg(pf_mdev,
>> -                                   "Failed to get device speed using %ps. Device %s speed is not available (err=%d)\n",
>> -                                   get_speed, dev_name(pf_mdev->device),
>> -                                   ret);
>> +                                   "Failed to get device %s oper speed (err=%d)\n",
>> +                                   dev_name(pf_mdev->device), ret);
>>                        return ret;
>>                }
>>
>> @@ -1446,17 +1457,41 @@ mlx5_lag_sum_devices_speed(struct mlx5_lag *ldev, u32 *sum_speed,
>>        return 0;
>>   }
>>
>> -static int mlx5_lag_sum_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
>> +static int mlx5_lag_get_devices_max_speed(struct mlx5_lag *ldev, u32 *max_speed)
>>   {
>> -     return mlx5_lag_sum_devices_speed(ldev, max_speed,
>> -                                       mlx5_port_max_linkspeed);
>> -}
>> +     struct mlx5_core_dev *pf_mdev;
>> +     struct lag_func *pf;
>> +     bool take_max;
>> +     int pf_idx;
>> +     u32 speed;
>> +     int ret;
> 
> [ ... ]
> 
>> +             ret = mlx5_port_max_linkspeed(pf_mdev, &speed);
>> +             if (ret) {
>> +                     mlx5_core_dbg(pf_mdev,
>> +                                   "Failed to get device %s max speed (err=%d)\n",
>> +                                   dev_name(pf_mdev->device), ret);
>> +                     return ret;
>> +             }
>> +
>> +             *max_speed = take_max ?
>> +                     max(*max_speed, speed) : *max_speed + speed;
>> +     }
> 
> [Severity: Low]
> Both new helpers sum per-port Ethernet link speeds from
> mlx5_port_max_linkspeed()/mlx5_port_oper_linkspeed(), which derive their
> value purely from the PTYS protocol capabilities, with no bound from the
> device's PCIe link bandwidth. The changelog says the max helper "represents
> the maximum achievable speed", yet the summed value can exceed what the host
> DMA path can sustain, and that value is programmed as the vport rate limit.
> 
> The follow-up patch "net/mlx5: Lag, limit aggregated TX speed by PCIe
> bandwidth" adds the missing clamp in both helpers:
> 
>          pci_bw = mlx5_pcie_bandwidth(pf_mdev);
>          if (pci_bw)
>                  speed = min(speed, pci_bw);
> 
> so this is closed inside the series; was there a reason for keeping the
> clamp in a separate patch rather than adding it here?
> 

These are 2 different bugs so better to have them in separated patches>>
>>   static void mlx5_lag_modify_device_vports_speed(struct mlx5_core_dev *mdev,
>> @@ -1505,7 +1540,7 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
>>        int pf_idx;
>>
>>        if (ldev->mode == MLX5_LAG_MODE_MPESW) {
>> -             if (mlx5_lag_sum_devices_oper_speed(ldev, &speed))
>> +             if (mlx5_lag_get_devices_oper_speed(ldev, &speed))
>>                        return;
>>        } else {
>>                speed = ldev->tracker.bond_speed_mbps;
>> @@ -1514,7 +1549,7 @@ void mlx5_lag_set_vports_agg_speed(struct mlx5_lag *ldev)
>>        }
>>
>>        /* If speed is not set, use the sum of max speeds of all PFs */
>> -     if (!speed && mlx5_lag_sum_devices_max_speed(ldev, &speed))
>> +     if (!speed && mlx5_lag_get_devices_max_speed(ldev, &speed))
>>                return;
> 
> [Severity: Low]
> Should this comment be updated? mlx5_lag_get_devices_max_speed() no longer
> always sums, since:
> 
>          take_max = ldev->tracker.tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP;
>          ...
>          *max_speed = take_max ?
>                  max(*max_speed, speed) : *max_speed + speed;
> 
> For an active-backup bond in a non-MPESW mode the fallback returns the best
> single port speed, not "the sum of max speeds of all PFs", and that is the
> value programmed into vport max_tx_speed.
> 
> The comment also survives unchanged in the follow-up patch that moves this
> code into mlx5_lag_update_agg_speed(), so nothing later in the series
> corrects it.

Done in V2

> 
>>
>>        speed = speed / MLX5_MAX_TX_SPEED_UNIT;

