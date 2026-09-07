Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011020.outbound.protection.outlook.com [52.101.52.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F117439F86;
	Mon,  7 Sep 2026 08:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788770456; cv=fail; b=LNO2Qp/4jRu+g7nAZYKYhVUqhyaizVNy50MZwn5Ps/3FjOfHyZFPszLdOZ1/VWVRMHM+jtanp/WruLXItteUeLcYF/UhI7/fUXU0wPTw8Lb58AD5Y/qIfef/tRMd5B5UHKzakNjNaaBudhsIZ8B726znd7E4RGNErxcOCi4uEeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788770456; c=relaxed/simple;
	bh=DsqIaWyKZUnzcG836d85O8JJSqMdKFyfNJDsgd+9lKs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ip4w7VRuZU/USTuxmdUs7wEnNVYYAn47yMGeI1EoeeCe9NCOXYO1OUFS03Jg5fmtfcWo5XH7PDZqg3UuPF4TLfZuoqANwjOv2CbiM4ZccTJq7tRtD9qnfUpeQ6V2CQt2YgqfqMT/5VT/I/Dn38qWIHsHoVwGA8MzjDQ/IfeHL4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=khIGDFRq; arc=fail smtp.client-ip=52.101.52.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="khIGDFRq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FhbwyLrK0f/zChPd0CKADHGxpyyRk8fiKPCDUpxjEHDvBQqAH/pkd0tIMnsdnBC4afY5jMk1aYW1xOZRj4I7RtJlXB3n3aiUNctnfNXs0kg9bRlN4YrHGI3xHhbC2eNa3mezl8Tdk08ldShoA6j/vSiYwW4IPAXuSok9D4r1ocKRNSlDLaoygPtoC58aOy5bUQG+2ducT1G4+H2PDC9J4QPq/IYUCFKhw4q7kBim6e4WRTb6IRTcwX44s7Vp9FGAWnG65l4sZE5ky6MBPiqLgADpZxsRsbnFtO+A9Qra1BNWa39OzbKXqwytbP/W7BIN8T/Bu8VZEMgNK5ta2ZLDUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n4c6kIdoJVWS3Tp9s5rJYWnT1An7o6hkaAqoxayuqUA=;
 b=J2Yk6iobL7Gmv/Zi2BguCbbNcbDIZZqsckLo1TBd5xBTxuimxTqY5+uzMDu6GEmlfeBi0EEnWGypiXbxNOcb+O9Lc+BWxN+44tYU273qFrIM5lbwxlawWRtZjjsE/2C2biyegN7DZnYEmQs8YUYKwepWUVPB26wzS3oE+Bn7eUdAcXr9GFWY2BJCjDAPbzZUxucbPghaqCxbpguCaSGmJrOniT/QUqBgsi09Qo0zghy67sIb5okye6+BaFG+ooyph3JrvViNRK1EaGam63LQlvtnwtM0VxJv6A0pzkwvBiZ0yUs4bt5aoOXOFQ7yPCxjngN7Ulx1hUxecyDiUgb+cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4c6kIdoJVWS3Tp9s5rJYWnT1An7o6hkaAqoxayuqUA=;
 b=khIGDFRqymmCSKPsG3tW6Qsq1AEb7VOveEbyggjew16hLH1h1B9MQK/yhvumAaUaXoLACpmKThExYvBdZnFJKipycUy/CM9lXyiU3EM8jiKB/qo5dG+mox3pgL9k+67qRbq7WPhqiHaMHHzE5GSAG4u3mHyXyPziMKGv1CcjFLlkURqEjpQ7E6DsLxlzeoR3xTJrOj4K/gbHBEtpM+YG386Y3NVU9zb3aY2g71xRW12O0C+/V4c+m/0TzCUKXYvZUJ7Wx3Cwy1ncWx1CyYzUk+tfZJcrgcsAUJKDvIHqGZX8NvvW6QGsAxmNAUkpLcORRwJ4+fpNw2NQWrcCqdrcqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by DS7PR12MB5958.namprd12.prod.outlook.com (2603:10b6:8:7d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 08:40:50 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%5]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 08:40:49 +0000
Message-ID: <33de3b17-8492-4eda-bb39-22d82e7b880c@nvidia.com>
Date: Mon, 7 Sep 2026 11:40:43 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 09/14] net/mlx5: Remove obsolete 32-bit DMA mask
 fallback
To: Ruizhe Zhou <zhouruizhe@resnics.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org
References: <20260903084339.870562-1-zhouruizhe@resnics.com>
 <20260903084339.870562-10-zhouruizhe@resnics.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260903084339.870562-10-zhouruizhe@resnics.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0120.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::18) To MW6PR12MB7086.namprd12.prod.outlook.com
 (2603:10b6:303:238::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|DS7PR12MB5958:EE_
X-MS-Office365-Filtering-Correlation-Id: 0413ee0e-c30f-4556-6246-08df0cbbb80e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|6133799003|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4UVVNb6EXNzlFS2X4RG6eEo0EJ6gPsMlmgluWxV3T3S9pKBEs4G1xC4gpweY6AjOEChhSoG6vzlCdjfQrSnW3ME30LpFS3zxAzP3UiUMvrOzgd6evt6rIwU4zYIeJBkgXwRYZtMoc3soWg6u2LGtz8R9IR8zrNH5cP8V0/vgHe4a1JusMZy0QQpOAkHB4WgkhDhrYADbUuj/utIPKMq5n0OWJe1/Ct+vpGhJ1ryrWJRdUbQi7PNEOe8jvI9iJGQUHjO8t/3XhTfxXt5xGwoQLLha91Zdr6U1jcZROnalFl1M1EvMG0NypE9RdtA4FnXRr0dAPCtEpAA2q5qNk4/aWF8Re0iEphgFjrDiKqdtzOr//yCYIUooEiesOnqpb4lNpVsR6vfZkpWINTMgIdBYICsFUS1iAx1HPhsffLLFKJmGz/CT6UkVbUgdjm0iMG2xIo6b7xj96CvaVO1suRHjtpmmGcxV7v8qazdOD8R/bK0EmxDEIAIMSVEe3Qttj3UopxkyUXPS3Qg4p4etfyH8sCuAxyEw7TNwCx44ouRMCxM9jIeJgb77gpFx2QERGG+Ybt4SpDkn+LliAXpx5hIfOswWjn/mXSyseTtuLB+pAJPWb48cZKt2aaGfG3U36XzKdMqjcq54XCoIQ3hbBTVeI71QzYSf1oG5kn1OM4VkUWw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enh2aG5yaERMSFhkYjlpakYxMjNydnpyNk5pcUdUUEg0Z0psdExSQ0J0VSt5?=
 =?utf-8?B?NGJranJ5OXE1MmIxeUhDMHk1UTVkUVZlSmx0T0Jab0RtNW5hUGFHRmpTK043?=
 =?utf-8?B?aEwzaDZlYXFVWGZPZU90QjdTWEpHM2JoWUJiajVsYndpK3J0dUUxc0FsTTFa?=
 =?utf-8?B?bFBBSHlyNTNsdGdDUmRRRGpUSXpBU3Z5TjdqVTFwSVF5MTNNQjZkT3FaeGNQ?=
 =?utf-8?B?ZTFrM1BZNy8rVWMvZXFTZmZ6c2JZckxaVm5uenNrSmNqK0RYNEs5SlpWZjRw?=
 =?utf-8?B?Qm4yd3JsRDhsL29GdGFGeEw0eVBOdURYczNHMXpBN2hIcGVwSWxHY0VJU0gw?=
 =?utf-8?B?a25CZzZsL2R2cmNKTmE4SnhVU3Z5RDQvaDFyZ0o3YXh0cW5ESmhLYlJpOVo5?=
 =?utf-8?B?RXU3RXdsTjFTRmx3L2pqYWtwUXNxME04UTVlemdtcnBsNkpQK090a0VLeVZq?=
 =?utf-8?B?cjZBeVRhSHdzVzNDRmg1S2N1elBURXNXdCtHVFdqa3ZNdXl6bzR3SVBra0Rp?=
 =?utf-8?B?VS85VG42UWxLaEJUbXdOcFpFL1dtQUFYNkNMR0oxOHk1OVNycUVKWlErMjNI?=
 =?utf-8?B?ODBoVlVDazNMbEQ1dSt6Y3NWYmszQkNSTzByUm1zUEpCa3UrQTZjTGJsY1NS?=
 =?utf-8?B?NE9rV2kzaXBzV3Y1OElZRHNTaWpCUC9iWWVBV2JBS2N0bXBEelZ4L0ZkWXJW?=
 =?utf-8?B?S2E0RnBNZTJERHdCNk9veFluWjlBR3Y3cFlLUy9VSlAxY2RCZ1ArZk13KzFa?=
 =?utf-8?B?d2xkU0dCRHNaTDE3bDdhcFowSVBTdVRWczBuc3NJRzI5R1hzWUtsd0lHZXlW?=
 =?utf-8?B?NzA5K0kweVpITHRmcUQrdCtoK3FncjNQN2Y2bUhOUjF0K01wdjYwTHd4eHdG?=
 =?utf-8?B?QU1WKzFLQUdRdGJ3bGxRSGJ6UHNtSnFhczhLekdiNi9wKzVnK2NDbVI2OXd5?=
 =?utf-8?B?aUgzYnJmZjRtRUJ3eDdVWTFsQjkwSWpwQkt5d2xyMWxoeGFDMGlnU0MzUXND?=
 =?utf-8?B?dEJvQUovbVZsbzFKNTMzMEVnU28rd0d0U05NM1paNjJXUmxnQWxqL3RldzA2?=
 =?utf-8?B?b1NmenU3Vm5yR0NqUHNtam9NZzhwcjJqQWdHQlVxdHNtdFFFQVAraC9lTU5N?=
 =?utf-8?B?eW5QdnVEU1VBYURnUERBYlhjZktVQ3k4RTVYalFHU0dpd1hMa05ZR2dwWENI?=
 =?utf-8?B?ZjVyb3RwbklEV0ZNbGtFTXRDSldPNlk2dUFib2cySDc2aVQ4Q0w1cmxtN29H?=
 =?utf-8?B?SXNKWjZwQUpFK1J4TnVTdldteWFrb2ZWb05yRmNXbmhGNHZ2d3QrWXg3Y0k2?=
 =?utf-8?B?TUxyVk43ZVdYTjVFYnVIOWJuQkE0Q2p2d0syUCtCUFBHUmorZy8vejNoNjBD?=
 =?utf-8?B?cldNV3hmNlFHK0I2MkpzUTZXQ0ZqL0Vjb0ZUOHVQWnMrZ3BxaXY5Ti91UVRK?=
 =?utf-8?B?RmZCRkpMNGNJS09NSjdnSlk5ZWlua3dibmMrUXZ5aEtYZFhlSUhaQTVPdXBo?=
 =?utf-8?B?U1dNRDM4Znk2YjVRNW9PeVZ2N09HL2E5aWY5ZUVSbkFYd1VFb1RrRkF5bWM2?=
 =?utf-8?B?VE9yRllDTW95WTBtdW52cTVEWHZMclBjSWFVTnJVR0dwb1BwbmJMQVNuTGYr?=
 =?utf-8?B?RTdoUW04NHZtY2kyRlF5RS92Sk4rcW5NY0IxTkRsUGN4UUxxR0F4Q3NDVWdN?=
 =?utf-8?B?WmE5UzM2SFM5UWQ5bUZCVzIxT2NpN1FtS0VSeHR1OFZ0NkdSUWJYUHQ4UUpt?=
 =?utf-8?B?UExiZWZVWml4OGNTaGFKTzBybTJucW1TcXBnSmw0WnpLVUE2SXdlejM0WTdJ?=
 =?utf-8?B?Mm9jeGNHaTNvM09ITENaTWt1WFpHcDZnWUpSenFpdUYrT1hyVlU3aWFlSDF1?=
 =?utf-8?B?Q09BMzUwa3BoRnlxVDdVbWVsVUhBSTVPQk5FWExYTVhieFhQQ0pPN2lCWUVY?=
 =?utf-8?B?Y3hsMWExeFZZNVgrMmEzbXNhb252elV4ZmlmQnNiSUxwc2JhbktWWWp4aEM4?=
 =?utf-8?B?eVd4MGF1SlRkbmhsbEIrUmlYdDJlSFkzTFM0TVNrdDhzQ3FieGVmcmpNdXhq?=
 =?utf-8?B?VFphNUNSUHdYaTRxbFV5bnY2U2ZOYktHVWVPVFk0ZXdvZTB0ckpUK0ljUlpG?=
 =?utf-8?B?VDQ1NW9PNWdEYTJ2QjAwMXFOYUNiVjdwOEZYVXZ6aVRaUHpRbWlWc25QUFpi?=
 =?utf-8?B?YzVKWE02b0RjUE45MUpYVTArYTNkSFZpT1A1Y2R5N3JETlBrV0dHcVMzTE9s?=
 =?utf-8?B?RkEzL0xjV3MxZGF5b1c1aGZhWjNiQ0x0cCtTbWxaRFFuNW8yWTBKTEZTY01I?=
 =?utf-8?B?RytvVjhSVlZWeFdrUituWVMraDF5WjNoNy9yVjJFeWdNVzdQNkpOZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0413ee0e-c30f-4556-6246-08df0cbbb80e
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB7086.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 08:40:49.7784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7SYSTGQAG9VH3dleVFncJaGaWwfGm36R+iKBzFqCS9QoA+r6h3WJ8xd6O0LF1sU+oNBdgC+geEkVuoDfG3HvBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5958



On 03/09/2026 11:43, Ruizhe Zhou wrote:
> The DMA API guarantees support for masks of 32 bits or wider and
> explicitly identifies retrying a 32-bit mask after a 64-bit request as
> incorrect:
> https://docs.kernel.org/core-api/dma-api-howto.html#dma-addressing-capabilities
> 
> Remove the obsolete fallback while retaining the error check so that a
> genuine DMA setup failure is still reported and aborts initialization.
> 
> Signed-off-by: Ruizhe Zhou <zhouruizhe@resnics.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/main.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 5f28d906c35b..3a3b0ec4aad1 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -184,12 +184,8 @@ static int set_dma_caps(struct pci_dev *pdev)
>   
>   	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>   	if (err) {
> -		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit PCI DMA mask\n");
> -		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> -		if (err) {
> -			dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting\n");
> -			return err;
> -		}
> +		dev_err(&pdev->dev, "Can't set PCI DMA mask, aborting\n");
> +		return err;
>   	}
>   
>   	dma_set_max_seg_size(&pdev->dev, 2u * 1024 * 1024 * 1024);

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

