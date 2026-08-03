Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012068.outbound.protection.outlook.com [52.101.43.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30C93770B;
	Mon,  3 Aug 2026 06:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785736948; cv=fail; b=RD+/MU68jLfYTZ5erXWN6P+Tb0reCvhECoUSbYRdQqjsdaA8AR3MCU5BRM3mXGrETYrf8jzJdLbok9RyRn6ntQrD38NRc1/FFdTklD2I350MKn1e5YG6lHv+i1LB/ObuUq/I9xscpN7x2psM8pp7+EFeUfnVJOePkVyhv3/Mrxg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785736948; c=relaxed/simple;
	bh=C07zNTj5JBmaxUQQ/cV4ON8g/CoFviJZe0uFjPEEv7g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U7Crzq1L9F0rx+c4kZjcJ/DT+LCNofOHVeCcEP9hZJeUuQeJJ9v4YIfHby5xJQnVmK06b2Ciq9jEBJ2iyJhg9UWJFJ+6K6LXAJYqf7PDDAelwD5vRLE8jMdH8zIJZpYor5fkn7GoymidlZyhPdZWFPHa4VMqzGUtywZ2d/QkNN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jX0uttOO; arc=fail smtp.client-ip=52.101.43.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jX0uttOO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZCAdO6PCBpTzgxsy9DaTdsO22FUFaCuuHA+2g3DSLb+G7beOKzI6V1MYKLZnJUrCYxYMu/Y3UOIOfTHvKskzEFYBVpr4/LZ1nVNVwYpB3Q3fJEkDPEXoUx6SRXkarp8A16ZxYKpgTmfPyEx68NQ40Qo7fpqakdRxehmb6a8jtJjMNgEJ+Wf6Z8XMt9KMe1MPLNYacxOkL/O8OJPfTlFVJfBzMD3TzqCtufZGDU1vn8MWFVq44CKawT2FZ8C+g17mD/wqJldsOXRxhk+eClcXrfFNINpc01UqPRCbCLzTfm3x9HoMZCLsT/pI7iH34VbV4xP/xavHAtbI6qre/hVK5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hGJ0wIqyW3MzozBS/sxDafr7Rfc+98j6JiTqog1vRJ0=;
 b=ajLxrbCrxjVZwj2uZ1iYO2YnFzOQtok5RKzmaXBYCxXuBQhss1Zk+1ECiN7K7sgmhXTEy0thmbJ06FoUro+F0222GupeOIvO2rp1gLzHAp41CFYzYnhwmQZ8KG4j6ecyMjN6p+Am36QM+L8X1wRUnotSzOOmJLEHSfkQsrCnhWn0f4Y1yLxhlooF9AzZNDIm4XctPaLvxddw7qJX/jSJp7BE5TsrODKYBJbs/JVN4SazzKegoTqpwkWu++YTWHqH+pyCAGkNjTUO8bbKRT9orzIKQls4dA4lQSq7MNwpJmGRkpOZ/pqoAbIej6//Da2L/bgz+xIKfhUV+uaxGrh9qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hGJ0wIqyW3MzozBS/sxDafr7Rfc+98j6JiTqog1vRJ0=;
 b=jX0uttOO0Gt8lAbZuSlC3hxduH9G9TnL1tIy8xwl7zyBFLnJt86SbvwxYDb17E2aSugqQV0PDEl7gELQE7ww9UgeS6n95Rgokl+Xy55fT0wfFXI+bW3qOqvTS80c9lUnBVzg87Uq/VF+VLdWQqqv/+vBHz6BwidqaQuBAqdZ9CkLRSQUD6PzWTgI5//PGZSnsKxJ3D0cHlb0fewAMBjIjYL87kyuf5ZhcvXo0Mn0qrwhGGxkGgszH2BtuTBcNEkOAHrAxLDZ5SunvqtpxzMwj+dJLWcAGjtuXzvwfQJRQeY3Mtt4I0xjG3U/N7VxhFaOUB5qZVO1MAyW/HWmzyp91Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16)
 by CY3PR12MB9702.namprd12.prod.outlook.com (2603:10b6:930:103::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 06:02:23 +0000
Received: from SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc]) by SA0PR12MB7090.namprd12.prod.outlook.com
 ([fe80::de78:df30:c2e6:7adc%6]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 06:02:23 +0000
Message-ID: <aa34a758-29b8-4705-822c-a3732fabcbeb@nvidia.com>
Date: Mon, 3 Aug 2026 09:02:17 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net/mlx5e: fix BQL reset on SQ re-activation
To: Bobby Eshleman <bobbyeshleman@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, Bobby Eshleman <bobbyeshleman@meta.com>
References: <20260729-mlx5-bql-v2-1-cdf285e586df@meta.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <20260729-mlx5-bql-v2-1-cdf285e586df@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0121.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b9::19) To SA0PR12MB7090.namprd12.prod.outlook.com
 (2603:10b6:806:2d5::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB7090:EE_|CY3PR12MB9702:EE_
X-MS-Office365-Filtering-Correlation-Id: a56ef7cc-cdb0-4c85-8e97-08def124c970
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|18002099003|22082099003|11063799006|10067099003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	BSTQuv8YqG0yqBxtllOUD5sge1KptaWncsaQIp77klPX0Ut8Qx7PtYvIbUZ1UQcIG5C36sBLgMUBYvw2MpCnT0ndKx2dCKG7bMUM9RCY7muQVJo7TntLKNOfzVsC4cJxyl9fv02KMoP9xEcTx7zVLniY6xcsj1zyGWJFpbUp5LnlF9z+moB06w/MZlR6925kfubb304THk5VSIx7XJgFKZV/hlL12gK1lFX4b5eMTO06dazSlojsGQNl+6XYQcIJEwR/55WjyeOZSGh/p2kKjH8Jxage9TWjwEF8SHHwSMUso5xkQlANxUFkzKP5uYf9yzqoscE4VLLUHWiXdV95gjBLwO8nomxkPu7UgSyRi9DN1oDnfUYmqfR30HwdpJpxGk5FVBCTMAamNQSj6wCTiXpXHTwXX1Nl6yBiKwKe8AgOPRwnd6btdrOoyOgmbbgqQFWa+nnxtHDmGjgpmlWc2r/X0dKvpHj+Frp45XIWv1VbY+ufI2SIIArB2wq/+vto7w4XkNHiHuZgHyZRS+9UtXfvpROD8NNgfEo0RFv301LZUdO5sTsrcopEBd65Bk7xW2irIrBb9zsROJU2tAW7RnMf4+EuUmAzsZSsk8UBdYSkNBrk5ZymccQtDa6JvFMvWaZCPRDDKnxFG6WMfUSOQCyxDVm4vJSBFV5lZPihpY7LSrsgoHeTA7bHGwVZB3oRxqPIVu0XEoOGqtmJPtiRZA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB7090.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(18002099003)(22082099003)(11063799006)(10067099003)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEx2SHczemk5SEFyZmpPK253S0pVdVpISzFKeWhYdko3eURxM1VMYW9Ca3RI?=
 =?utf-8?B?QUt6VklmQWk4K3VnOFlTYVlrL2IrSUhqWmh4c3pXbUZ1V2xhZlJvQldqN2FM?=
 =?utf-8?B?dENnSTUzb2VNTk9XVzdPTnl6WWVQZ2xjV0dFei8xS0NENHlXT1R2Y2FSeHBy?=
 =?utf-8?B?Szd5ZzA2SlBnMHF2NTdQQVZHbmVVcy9LWjYvVldoNENoR0IrRm1wcVR6Qk5i?=
 =?utf-8?B?Zk9uNEkzbnpFNVpheVFuRVlaZWVjSFpHUFA4MmhGUUNheFplOE43YjlsVExz?=
 =?utf-8?B?ajVlSU1JU05FbFVnRk1aTGhiTjZWL2F4ejcwNHdaQjJjbEMrUzlOUEliM1dK?=
 =?utf-8?B?U1I0aVJkL0k1L1BKNlhmNFhIandqeTZCaVhpcFB3UEd4TDNtVUhieklvc3k5?=
 =?utf-8?B?WEdHK1dLV2VISElRN2Y5UkYzaW9XMjRLTjNiRTdnRXR0WnQyeHRaMVV3Q3Fa?=
 =?utf-8?B?bkliaFQ1QUlzdk0zNFhONUQ0Y1c4OXJ4aC85VHBNZjduTm10TnJJWU5VZU5m?=
 =?utf-8?B?OFZBZml4OEhyQk0xbWtrc3JyRlRENzAwS2FWVHRZRCtCRlRJUFA0V3FDbGRk?=
 =?utf-8?B?eEhtSmp5cm1NMmtsdnVsdkppcXdCNEMvWE1zdkU0d0k1VlZZQ0dEOXJFdGNl?=
 =?utf-8?B?RG03UGlubWdTRStGbDJNUUU0STJ5SHE2S3Q4WWxKS29Ibk0ramtUSm9DR2U3?=
 =?utf-8?B?QTU5ZXhUeWRQeFJFOExNYWVnaE1zNkZtMWhHRm44aE9haC81Y0VtOGFtb0c5?=
 =?utf-8?B?YU83UVJVQlQweHFNQVlTUmNGandRL2tuWUE2MVY4RzJCdEMvY3BwSVJ4bitT?=
 =?utf-8?B?MXZsTHpqYWNhbThSMHl5NGxGcTV2UlBCaDl0ejdUTUR6Z1RlbGw2MVFlSjR3?=
 =?utf-8?B?bS91ZFo3UkJBMFVCVVh1aUdKVmVJdjd1MmUwSFhtYjV6NU1mR3NrTU82bU1v?=
 =?utf-8?B?V0p3cVR0U1FQRFNLbUpTTVRTcXAxMmFVakJwbHFBb0ZYZUZhQUE5eW5ibDNT?=
 =?utf-8?B?NjZYMGF0VkppdFh2ZWRTYnZIMXl1OUtjK1hPNUwvd0RlNzNZalRGWVhwWXFs?=
 =?utf-8?B?NElYQzlIc1ZXeDh0bENZaGRmWmZJRnVDL1p1b2Uxamd5amt6K1Zmb1FjMDUz?=
 =?utf-8?B?Um0xRUJ5dXNtZnpRZmtIQmZUSktUY21vbjJ6Z3FxZjVQSUhsYXh5ZlpId2lk?=
 =?utf-8?B?dVUyWUgzS0Q2c0lyb1dxQUNPejkyU0R1M2hFYnp0M09hZVVCVXo2MmQ3ZEFB?=
 =?utf-8?B?WmRObkx0cWFvcy9oc0dza0VSck9HcWdBclZmdjJ1SEpXYzliMDJOOCtWMFh6?=
 =?utf-8?B?aXVOYTAvTHRyYURjSUFDakJwQUxTMFZ4T3F2V3VLaitZL3RHNjhHWkFXcEZl?=
 =?utf-8?B?U3A5dGw2VFdRRlJVY1lCNDZ5eVZwVUZCNThzWWt0c1h1RUtOK0Z5azF5NkNt?=
 =?utf-8?B?VDBzaUxGZklKTmYxQXI4eURPM09RSWJEbEdPckdRZ212dXo1M05rZ1UzaU04?=
 =?utf-8?B?TjlBVG10ck5HOWNTY2o5MEx6NU9XSDBXd2FMeG1PL2t5WEtJUVR2ekZYUW9y?=
 =?utf-8?B?ZWM0MTVsT3Nhb1RUaHM5VGJYQktWUHNJVkdNMGFrTHIzZkMxVXlKUVdNczUy?=
 =?utf-8?B?Z3N5aEdpeHBtcFpaWU82SWwvbXZ6MmdLT0hiYzdJNk9EVGJYalFnc2MwS1pI?=
 =?utf-8?B?b3ovcWpwcHFFYlcxL3Yxa2Z0ZlViQVV2bTRDcjVqYXdnWEozOGxkbnlXcUZh?=
 =?utf-8?B?Z1E3OEdkSmtHYXBjQnZsM0Z1UnA3aU9yc3RRMEIrbVZKNkFtTkUyT2xydDhh?=
 =?utf-8?B?VHdtSGozcFRJMXFESndqSTdmejN2dE8yV2JUNTVmR3JMcU5ETWtkcXp5TnRV?=
 =?utf-8?B?bXVMREFZa2poR3RCbHJVQ3UvMnlCazFuSmo4RitabWRoTDJsSlZJVEdhbUp5?=
 =?utf-8?B?ZlpzODM1bmRPRW1qWXdjaFU3ZXNBTytSak5YeVFnbmNyMnlNd1J2dFpFZTUz?=
 =?utf-8?B?QkhlSDJrbnhSaE4vcXNVV2ZrVXV0eTNVZkd6TFNTTnhRRmlralZUb281TW5Y?=
 =?utf-8?B?QW5FZ25OS0l3bjNNY3UvTWVLUitWd3k0TTZBODBwczJDc1BXeHVuVklZcVJ5?=
 =?utf-8?B?eTN1WlhBTXFkSHR3MWVzM2tWc3B3N0hUWkRhREptWTZVTHZTS2NTWE5scDkx?=
 =?utf-8?B?T1lFaVV4OWwzWlByN0RzTEM0NDBFdEVTY3pDam82M0t4d0I3VW9uOURzUlpM?=
 =?utf-8?B?NjV0b3FwK0dKaW5HNzBDcnY5ck9uNWFRbC9GdzlFZld3S2NheU1TbGVneDFS?=
 =?utf-8?Q?VsHUY5PkL0iQzzP3ND?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a56ef7cc-cdb0-4c85-8e97-08def124c970
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB7090.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 06:02:23.5981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +d1mUvX3ShByzWMl1Hz22yr4B6I/qZ3l/TaLy9VNOXuHqQOzSuam2CXKNxdngji1rdZD7O+57fq3J4N9c9xWhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9702



On 30/07/2026 4:57, Bobby Eshleman wrote:
> From: Bobby Eshleman <bobbyeshleman@meta.com>
> 
> mlx5e_queue_start() deactivates and re-activates all channels but closes
> only the queue being restarted. mlx5e_activate_txqsq() then
> unconditionally calls netdev_tx_reset_queue(), zeroing the BQL counters
> of channels that kept their in-flight TX WQEs. The next completion then
> over-charges and trips the BUG_ON() in dql_completed():
> 
>    kernel BUG at lib/dynamic_queue_limits.c:99!
>    RIP: 0010:dql_completed+0x23d/0x280
>    Call Trace:
>     <IRQ>
>     mlx5e_poll_tx_cq+0x668/0xa60
>     mlx5e_napi_poll+0x5b/0x7b0
>     net_rx_action+0x15a/0x580
> 
> Reset BQL only when the SQ has no bytes in flight (sq->cc == sq->pc).
> 
> In the case that reset is skipped, the outstanding WQEs will eventually
> complete and rebalance the dql. The dql->limit is carried across the
> reset.
> 
> Fixes: b2588ea40ec9 ("net/mlx5e: Implement queue mgmt ops and single channel swap")
> Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> ---
> Changes in v2:
> - remove misleading comment (Tariq)
> - Link to v1: https://lore.kernel.org/r/20260728-mlx5-bql-v1-1-99a0ab77ede7@meta.com
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 4a8351f95b27..44834890a409 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -1940,7 +1940,9 @@ void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq)
>   {
>   	sq->txq = netdev_get_tx_queue(sq->netdev, sq->txq_ix);
>   	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
> -	netdev_tx_reset_queue(sq->txq);
> +	/* Reset BQL only when the SQ has no bytes in flight. */
> +	if (sq->cc == sq->pc)
> +		netdev_tx_reset_queue(sq->txq);
>   	netif_tx_start_queue(sq->txq);
>   	netif_queue_set_napi(sq->netdev, sq->txq_ix, NETDEV_QUEUE_TYPE_TX, sq->cq.napi);
>   }
> 
> ---
> base-commit: ec83512ba345b1e415ca491509a7a952db84c4c7
> change-id: 20260728-mlx5-bql-84e02a5a46c8
> 
> Best regards,

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

