Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012037.outbound.protection.outlook.com [52.101.43.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97A32FD7B1;
	Thu,  9 Jul 2026 05:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783574921; cv=fail; b=eTEa2ycvj7Bzwz2JQhPBoR9IPO1F/l4eyqzudAK5oVIclJz/kRud8ISvp/QB4kokt6X9nLica5VVhj9e0buCXbKFnEMjGuZNoT+WyfNN/pfTCDMONtV0XB30AGW/bVeZajvqnHGkpm0bcA+fML5klyPAoAXRTp6yFozsO1UsGts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783574921; c=relaxed/simple;
	bh=DRwWMlR5FR+BW6Qg4/STx2R2NXoIrEiGUtDVKW+zxyY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HDLAtdRu1tQI9D/TA+n8EthBiqtR5i44UntEBgsoUvxwicBfffYHE5yhNYqolkYL04kEuePkVl9R221bB2UHF5F6RtiGM8ke/2zxbxtKVYdG0woB3gDARdD23E0/fc5eyeeIac91j8eSXACIiOxrA2LYAl0/LlDqASYRtsMPv4s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IgHQPNoV; arc=fail smtp.client-ip=52.101.43.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IgHQPNoV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u20eIQiHdgjRuyu4kF6YUyLWjqeeCXULeR79Iu+ibFIbFknG/nFBPjsb9JXNScx5HoBzhyTqPQEdufvrObGCFR0ygMM21yvo7wqQkM5IOPlgp+HyQjnbm4Ikixsi8H+QBDEPY062cLEfDFE7dFixnAUY7NkDm7bTgmxMoHqaCXHqhfTZrA6Swkjk9GQh0xg21ycRPnSU0TfsBCKbpIwqIX95srDfOCbZB+CkgFvCljiEuuMp/zWQeE3fuF896pNetu0G4wZVD7U+EGpJoXOMn4nt0G9Rx+5yNiQzrixvX2nUuPszYzDcoBHJW721pNWu1rMzmbIf/JWXJfNJiAdp8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zP6Z7lpLRwMp+qw+vNGlPOgFdeJmdF2+GzODby0pfJI=;
 b=FeRgpCtEH+FtrKiJP0prkGt3XKfiUPfpBAf1MudJ28Nmc+HNvUvNMJJ8+tUEIs6tSkzSWb4FpLBepA359s8bbnBRnzuJbWQGFheqjvn54lKW8Je6yiCJIS23IQW/UDSw0qG8z3Kohlg1b3kWLkODCimVl6Q9+iKt9GhNjTOd7LPwBblkNIRlHre7/R2qWNzaG8xXi8216BG0BF99rP1wljk1Rvudv6iWdHyAq7lozjsP8uo+K0mEWUJzfrKyjOARsOJDlpo+7kkbqOzdyEnS0O2Usv9DjW0p1XeHPDVJts102SLgr6dAeQNu56bltz2LjxP6fl3Anr8hOOrS6hyf3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zP6Z7lpLRwMp+qw+vNGlPOgFdeJmdF2+GzODby0pfJI=;
 b=IgHQPNoViSj0rc5f2x+BTfY7zMOdy+AL9IgYHGjkqKMV8FWrBlgWQJYngV7k5jq9umOGygDdRmrYrtPV45qtPrlDH2A4LL8CwRQHzOXDJByEfGdYhYHfWr3OGeC81tavUiQZIiyPMlmpnacn1kMIbdSKijKOnXHCo9ut20KS3NAg7R1hMTFDVcRfwrB4Zy4T3YtcAzrinHG/IlCSsh9fb5SgwtUTfYGY8+y3jCJsmRGGMGqhZpxcNgS1FbgE+H5xRZBTStbSDF7co7MZCMye6JtzEXMm7zyTOqkzLoVG5YlDER6u31ZXx/0Y8acKIrB9nGYWdUL2tzEPheYldIJj8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by CY3PR12MB9678.namprd12.prod.outlook.com (2603:10b6:930:101::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 9 Jul
 2026 05:28:36 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%6]) with mapi id 15.21.0181.008; Thu, 9 Jul 2026
 05:28:36 +0000
Message-ID: <ad63f6fc-da9c-4850-bcd4-2f3a1324ebae@nvidia.com>
Date: Thu, 9 Jul 2026 08:28:28 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net/mlx5e: Use sender devcom for MPV master-up
To: Manjunath Patil <manjunath.b.patil@oracle.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 netdev@vger.kernel.org
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Patrisious Haddad <phaddad@nvidia.com>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260707233911.3651139-1-manjunath.b.patil@oracle.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260707233911.3651139-1-manjunath.b.patil@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0449.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c6::9) To MW6PR12MB7086.namprd12.prod.outlook.com
 (2603:10b6:303:238::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|CY3PR12MB9678:EE_
X-MS-Office365-Filtering-Correlation-Id: 3345f5f4-6aa1-4c99-6c3b-08dedd7aec4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|22082099003|18002099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	G74QUepF4KEf/Rz3P0JDy4YhFoogZYv1rvWSWR3WtsdQbXJn3n5BCvuDY/+Xx3MNPRgt37PcVjNW49ESO7wBOP+0EmK15u3x/h9nvoAh2C9BG0xVzZBl2658cPNAWGxZkuIADaj9M/CuK5LAqVU9V1ivP71LF6pCWOQCERr5bL9O07pT3r0rcMrwZtTv62K8NKM5oduwAVwus97NPjryaT/7dOKRuAJr0+ozXeIGMm20g5bMu50BMMvkBKDiUt+UkxeZIsIC/uusCqWPmoc+RNlnSeihrhqFsqUKVD5gdL223wqZlCBClBHqclmjEMCIhnuwWCM9T4j1oc4RIJlWE2OxC/BqSdNG/qDr1dgEwyAueRl+MDWXdLu5Nx/OlSWiprW4M8Vw3GIHk/EHyRnziM04bOpSsMmX7L7TLjhHv5arlllQyBtOZ7pnOlhUc9GcfmxVkPBJAVqWSbH0XvWY1vwBeeNDW4kHpt84wTRAuXEWHrqVrMKbP2kGu6WpnHRxP2fThC/zx0BDjSsam6+ykr34QrEciD9/Z0gxHbQZIzqe8tK4Hc3IV6hIlY547FP7kbQ6NddlFjTcZ2JhcLmHtVVP6bD7AM/72EfoPBKnrqsvBrK1UTlvjjibZ7RjRhL2lVobi/WQjgDQpCy2naPcUMN2mzmOQtdkTHPJFfQx/9Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(22082099003)(18002099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ays5Ri9wK0hFVW1YZlh6YklYZVRDVS9kVXpIRUNNcWttVDJLdjYvMitZeVVu?=
 =?utf-8?B?Q3M5bUZqeXhJcnlpZkU2NG5YTGFOczZuUnhEQk5VRmM5TjBxckdTeHpvOTJy?=
 =?utf-8?B?a3h5YmY5UVo3NHBsVkEwcCtPem5WTXJJK216L0w3cFJ0ZVJOYkFOWFhUY3Q5?=
 =?utf-8?B?aUZVWHZNZnc1NlRwSmhvejUwMG9pN3RnQnV4MXdtNU1qQ1NqUHdwM21NdHJR?=
 =?utf-8?B?TUZndVNuOG1yRlBLWC9iZ0FtRDJyUHF2UlRiS2RZOHQ2ZnpsUVQwbkd2WVV1?=
 =?utf-8?B?akFMdWFtY1JjUGJiMUxMQlFMZVZNbjFxQVAyak1pTHhxUjNRSExDem9IK3JQ?=
 =?utf-8?B?Ykdjc2dRTnJyaFNPL3ppTXZVT2lFbitQTlp5WkJndHVBdWtoWElNdDhmSm50?=
 =?utf-8?B?cElSMWI1dGhJbWNPQWJUZVdacGdYTjhWUVRyZ1dmc2JPMmhqb3AwT1BtcU43?=
 =?utf-8?B?a2cxU2Y1NlRqM3FhQWhLYThsekdieFI1NlhaYnArSGdXbDRDUDVtN2l6eS9q?=
 =?utf-8?B?WEJnWldVYk0xKzllZWVBT3EwL2ZwSWxYMTVRbXQ1S2FTYWM4Y255OE10em1H?=
 =?utf-8?B?TWo2OFlJVGxpUmhhSGRTM2NtKzlodGU5YUk0SXdQd3RyRjZTdjNCcmw0TVli?=
 =?utf-8?B?Q1k3bW1xMEdxanhhT1l4Nm5HQTh3bVdDMzdaUzRlTjZSWmh5SXVuOSsxTFJu?=
 =?utf-8?B?WFZMNjJkWVhnNWN1Z0hsVEwxejFWNDE1UzY3TENHTENTbU1QdDhWR0trcnl4?=
 =?utf-8?B?bkVjUU9hLzcwMFc5REVFdXdObGFKdGRBdVVJd3p0dXhvbmRKVGwzSElVSWxK?=
 =?utf-8?B?RjlvemgvZUZNck90M2VuSFl6bVlUY0RtSUZQMnFycWJJeFNZSDJERGZGc3dE?=
 =?utf-8?B?UjRTT2hYempUbVJnVzJ0a1FWK3BQK2JMREVnUVYvL3RRK1RiUmdVMktVamhG?=
 =?utf-8?B?akVvbEhFZGpyY2dJSzhuVHpKbTVWM0pRL0NGK2tkWTh3QzA5ZDhYeFJnNkRD?=
 =?utf-8?B?T2krbmJwZHdIVFRvODZueXR2UkQwK05TM1ZGRzBOejFPbmI3Y011UlhkLzlr?=
 =?utf-8?B?bVc1UmM2MEVKTnk1cEZWS1g2OExoWVJ2N21YeERBSWV4cTF1WmRVN2JGUStO?=
 =?utf-8?B?UVhNc2hCYUdmRW11WjMrNTFPVUlaM1hlMnZBcnVyVlB0RENEbkpKMUdjWm81?=
 =?utf-8?B?UGlLZyttcTlidnpENDdyam9JZ2lMMWkvM3FLdlRZVktsMlk2T2ZrL3NXQzVE?=
 =?utf-8?B?SmNrTHkwK0w3V0ZKOSs2Zi9vN3Y1Qlk1NElRNkxXaWJEaG54SHhlYlJoQnp6?=
 =?utf-8?B?TkxoV1plNEp4YXNFM3F3UHRWOElyNmhZaklVaVE0T1JOdUM2Rlpua3dSeXNG?=
 =?utf-8?B?U0NzTFo5cXppWlRYbmtxVTd1YTU4Ulk1dk9sb3hFdUlQQWJ5by9TRjBIamVN?=
 =?utf-8?B?Y1p5V0p5Vk04c2RwVVNZSEJkLzJWSlNlVlgyUFA1dFNBaDFtUDNreEdXRXo5?=
 =?utf-8?B?djQxbkh6eU9VemNUQjlWaWRmRTZNV2ZaMHh4YXhSdkE5azBVdHY3RTY5NEw0?=
 =?utf-8?B?U0RPdXJuWFFGS2dVVTJmYzNrZzJWdTc1S2dyWG84MFdzVytnYkh4eE02bzBH?=
 =?utf-8?B?SWRkbjl0QWYybk9lSmdvUmNCVWJ3YlBXeXJOZmFOWlJjR1ZZdVc1VFRHWWFW?=
 =?utf-8?B?SUVmZWZkbi9TU2d1UjlZayt6RlpaU3lkb2FGT2Jsc0lVSnVJcmRoWi9nY21l?=
 =?utf-8?B?VGlEN3VoRldTTW1uTGI4aEdmNlRlYUxSQjBsYllDVS9raFcwTVlzOWRRSUty?=
 =?utf-8?B?TzBvRXc5TXlhdG0wYjhKUnEzOXZQMnphZXNES1VoSWxhbjQzTmFWc3Y4NHVL?=
 =?utf-8?B?VGljdzVEWWJWVlo4anUxdWxIZmdxNVNjekgzOTVqdjF0anZkWkg5dEN6cG1F?=
 =?utf-8?B?UUpoajdKSVI3M3FyWWlKb1p1TWpOaFhvbWVDWGRGQ2dSNVRpVjdRQ0U1Yit2?=
 =?utf-8?B?TWxqbHAzSTRRNnJ0dnFZQ2tyWm8vb2NQeWV6TXh2Q053alBscHp2UnMrQmZl?=
 =?utf-8?B?ZWhTdmIxdXN5Z3JNUEZwUWI2M1pLMXZmUnpGVEFUMWsxZi9NMUhEMW9hR2ZG?=
 =?utf-8?B?aGs3YWg1YWp2MWh2Z01CYW9aeUhKTW5PQ21HOTlBaHdsMXFkdWtYajlJMzA5?=
 =?utf-8?B?dmJnWkt1cFNtY3VnVlZJUytZQmRYcHR5cEdybERIRTJ4ejJtaFFuZXdmYnpS?=
 =?utf-8?B?SDhYM2g3MjVQcVZBTUhWRHVKQjdvSDNBOHcrWHFZcHpzZmhBWlBDbkpKVi9a?=
 =?utf-8?B?ai9pZUNPQXdTbnFDSVhQQnB6eUVTNy90RFRLZ3ZFWWJTd1FDZmUvUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3345f5f4-6aa1-4c99-6c3b-08dedd7aec4a
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB7086.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 05:28:35.6875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yqUL1M1RNkcvutvk0s6yI0+2Mrjkw7HIkAoDG7MyTL4NbQWc1r/jEfikAoJ+Nh9fQI3rJ9Q3wy32SNqlxyUy6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9678



On 08/07/2026 2:39, Manjunath Patil wrote:
> After PCIe DPC recovery, mlx5 reloads the affected functions and
> replays multiport affiliation events. In the reported failure, the
> first relevant device error was:
> 
>    pcieport 0000:10:01.1: DPC: containment event
>    pcieport 0000:10:01.1: PCIe Bus Error: severity=Uncorrected (Fatal)
>    pcieport 0000:10:01.1:    [ 5] SDES                   (First)
> 
> mlx5 recovered the PCI functions and resumed 0000:11:00.1. During
> that resume, RDMA multiport binding replayed
> MLX5_DRIVER_EVENT_AFFILIATION_DONE and mlx5e sent
> MPV_DEVCOM_MASTER_UP. The host then panicked with:
> 
>    BUG: kernel NULL pointer dereference, address: 0000000000000010
>    RIP: mlx5_devcom_comp_set_ready+0x5/0x40 [mlx5_core]
>    RDI: 0000000000000000
> 
> Call trace included:
> 
>    mlx5_devcom_comp_set_ready
>    mlx5e_devcom_event_mpv
>    mlx5_devcom_send_event
>    mlx5_ib_bind_slave_port
>    mlx5r_mp_probe
>    mlx5_pci_resume
> 
> MPV devcom registration publishes mlx5e private data to the component
> peer list before mlx5e_devcom_init_mpv() stores the returned component
> device in priv->devcom. A concurrent master-up event can therefore
> reach a peer whose private data is visible but whose priv->devcom
> backpointer is still NULL.
> 
> MPV_DEVCOM_MASTER_UP already carries the sender/master mlx5e private
> data as event_data. The ready bit is stored on the shared devcom
> component, not on an individual peer. Use the sender devcom when
> marking the MPV component ready.
> 
> This preserves the readiness transition while avoiding a NULL
> dereference of the peer devcom pointer during affiliation replay after
> PCI error recovery.
> 
> Fixes: bf11485f8419 ("net/mlx5: Register mlx5e priv to devcom in MPV mode")
> Assisted-by: Codex:gpt-5
> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
> Cc: stable@vger.kernel.org # 6.7+
> ---
> v2:
> - Drop defensive master_priv/master_priv->devcom check as suggested by Tariq.
> - Resend as an independent thread per netdev posting rules.
> 
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 8f2b3abe0092..9b27afeb9b12 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -211,11 +211,11 @@ static void mlx5e_disable_async_events(struct mlx5e_priv *priv)
>   
>   static int mlx5e_devcom_event_mpv(int event, void *my_data, void *event_data)
>   {
> -	struct mlx5e_priv *slave_priv = my_data;
> +	struct mlx5e_priv *master_priv = event_data;
>   
>   	switch (event) {
>   	case MPV_DEVCOM_MASTER_UP:
> -		mlx5_devcom_comp_set_ready(slave_priv->devcom, true);
> +		mlx5_devcom_comp_set_ready(master_priv->devcom, true);
>   		break;
>   	case MPV_DEVCOM_MASTER_DOWN:
>   		/* no need for comp set ready false since we unregister after
> 
> base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for your patch.
