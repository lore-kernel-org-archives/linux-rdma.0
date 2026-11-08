Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.30
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794131381;
	b=MuqEVtPS08SG3yU0ozxFUeevglBWHIMbEIfqCKXX0NJzbAkAodm5d593SqeAqatLK00T
	 OLvQft8Geu/xj3bsYL1YwC7PqgGno6o5wc2ay3D0B32ikeXzNzQ6+HVhNaTN6in7Ix6iW
	 Kdk5WQWWaBaJTnW5MOVYlJvJmi3SjanhkuZgrdhhC5mqLew+S0/RUJiP1FWdN3dgW2FxF
	 G3rVlfRZHF3tQgdccF+I+VEIUqJdb6qP6w87Pl6xcmrNpHXEQWpAwIjoxtkd59ylIlj5c
	 9AUBNY6Nql0qhn0gju25ttVC7WjMDrc/BrvkB0QqWlDPC016HyOXAd19E0+fZf6DcTw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794131381;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=B+IiL1a2uTzMLvWe2SOqpGm4N4uUNtzj27Hp/94S3AM=;
	b=bvEv4fTm45qvwDcbWgR6cfGHug66xTH06bnGeSua06KUa5u8cflm5BVyZSwuyIVMOwpd
	 8z72+sBQ0WgiGBBZohJu9XvWyrRfarxpmfhlOFZ2YUWLHo8WkBWnVbTEL5DohvlHggNdn
	 i9cWp84R+FwwsQurnWD2yHHyfGnZ9qeg2jsW3v0ulGwAz6HxGS12ymhFhLLN9I5l0eade
	 9m7RqaKTo2ndWg4774XXYwyr+C16zTgZSNG4OlQ7eutxUXqsr8euOf0Qb+a2TC0wLCHVl
	 2ODYXpTqJcM+/BlAuCz8oSOgTw1hbukzWK0BNQnmbVRsEk5G5BLDGjt5cdsqcbo59kA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uEZD3FW+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.200.30
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012030.outbound.protection.outlook.com [40.107.200.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B5C606A31C
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 09:49:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4B5C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uEZD3FW+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=buHik7Pds2RQ/zvPmnDKbpKcJe8TJWqqvLlm6zzEJ2KT9EIkQxiCpPITfdzX9GuDOBrPNPhEOoAuOgUOc64maKcC7cwz3uMs6qW4TLWN2mVb3a7JBsiX0zRdm2ejlkHRXzj1VOOlah5aTn7Yux5nMTOusHkIihMg9TkU9muQhrdPkFi5CPi1STQcGJhflWyPPPW0gKL6KlDt5jHsdJ30++optGlP2OeSIefouc13lbNppCoIf1kJGI0Vb6mNko8d20qcl501lCwsrJNwR2pY8FHPnJQJXXOpjPbap7GYMvktArUkOa4MXLe0bLUsNYBKVxPWqMVWfDrmRDwQEzEIUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+IiL1a2uTzMLvWe2SOqpGm4N4uUNtzj27Hp/94S3AM=;
 b=t3Z++oK1V/Rk1zXRjMsOpUtDKHysPT5OQGpXbi+0P7Ej4/PFVVQA8rkaSwbBlLpph2GcE7CE8oqIy1dUZAXmaiUxuD7HJf6cKMoLArwPCbmP1h5m/zr76caCJL4gLS8HCaD0XuXHYhYn0JPDUdpQWXCko4OW7rIm2Z/P+/WPol+kE1I17zWEhUIwSlR3pYVUNLeHmD0ZhjoNw+JZWlNBvyJ3QNN4S7U92kCu6fNvzGUVLR+LDZiPlF+r7W9d3g88477vb/5wr9ZS2rJzsVB7zhAE/fujY1J7bOc5dnnQlWKuH2LOxRADLrvlCpknLblOrVjo46Y5I61nSGXjRzD/UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+IiL1a2uTzMLvWe2SOqpGm4N4uUNtzj27Hp/94S3AM=;
 b=uEZD3FW+Wh/wpqMDmjGVKb/qcdP5ZijVLgvFOMmMD9rqv0OSrh/LgOXt94aBz5pu3444BaJlNPFm/4z+zLUCLund1wAoQjvETSYa8tAWkZU87IVkijCXXdhdiHUNeUBVXuwJCZks3J8Wx9fSB3w0pv1UhF09WIVSSKOr80xXiogJE3y4fltPmi+YwtMtLEIEVCpamTqokTGJLwaUJRCzvxrFKHCVwdolA+JbJR2Gq4dpiialHPaHgN/MmiQcEuQG3ntBk1Jkuxe5SGxc1tkDyOqypl0CPIyKdh1ozEnvxJvEwqpNeacHvBnYK6dHQeXyOoQaK9GGlQlQjceQGqvx+A==
Received: from BN9PR03CA0149.namprd03.prod.outlook.com (2603:10b6:408:fe::34)
 by SJ0PR12MB6941.namprd12.prod.outlook.com (2603:10b6:a03:448::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Sun, 8 Nov
 2026 09:47:32 +0000
Received: from BN1PEPF00018071.namprd04.prod.outlook.com
 (2603:10b6:408:fe:cafe::35) by BN9PR03CA0149.outlook.office365.com
 (2603:10b6:408:fe::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sun, 8
 Nov 2026 09:47:32 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00018071.mail.protection.outlook.com (10.167.245.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sun, 8 Nov 2026 09:47:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 01:47:18 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 01:47:17 -0800
Message-ID: <14170676-7e59-4e21-ac45-0198251f6132@nvidia.com>
Date: Sun, 8 Nov 2026 11:47:09 +0200
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next 13/23] RDMA/mlx5: Keep the UMR QP failed once a
 forged CQE is detected
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-14-yishaih@nvidia.com>
 <sashiko-outbox-197666@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-197666@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00018071:EE_|SJ0PR12MB6941:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dd5a940-6181-4952-45f7-08df3d7d4f87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|11063799006|4143699003|56012099006|261021135927099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	JVIXb0JTPkDSrJmzZ02SqWWNQ+zLXNZm7Xkn4og7L2TLPek/5GZVLOA8XdpJD/EiYSeIB4QZRge3s3wL4hWnOxPr5r2BxftQbeT4CHYbAKidCcEhqtyQ8uQeULWmJpVdVFnby/XlFivY4bYTxxntAy1mrvycet0U+paBdJoOMj1AjKBKOSDgQFhC0r/4foi4YocYKI4Hs8BDFe29i+MSIwhYnh2wbWjSqyz+nD1RpzJ074UMU9egCFO3/5wGi2wFvQzOJqYmxsxTMIrH5Zfu1/uyZORGEJGoHU79jTllzjHGZOzxF8mSl7ECFrsWC2xdki9iJIyDOLi6Sg6K5nahEKQmrXJHmtsLfXKViqheLee91yMAeUdzJ67joBtrymmMfx1W4Ryg0IbnujE6DU6FBQbCX2SUzEry8C64W40thjzzYxSQCE4vTOch0GLSRNQM7nz3buS34DSvVU2upJaCQF+l6IXezfOoBTALG5AsFiFOkPxahoaF6oIy8LcBMGVNRlRi5UG7OIjcp5JvN6ZTLJz4p25xCahHS0FmKRDWdZcWttf24OSHe/2fuXHQ7Dy9JBWefu2dp0RVVn5s31a94GlrVYpn7kVR8QBnlx/DE2ksW+JFtb3X0eHrmEnudEaO4VCKSf/Okt5eDWer6yuPZ+1WmW4dlfLFHb4sNNKUEWUuZTOiFPfgjANDF3OlSADVtyyuz86RGqihEbD+gDd+8g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(11063799006)(4143699003)(56012099006)(261021135927099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GJTxbGVpZAbeAQFN0Vfbp/AY9iJFeHzC/lBwwPlD8Vv6dV69gs0UNHbbDP4GVDqUv8IwAWKQ8OGXs0NohkUMdTL4gE/5plwydnLpyPSGrLhJ45QdyBRPDA6hyE8w57h1YK0MFjU849/cv+xPBH6DciMe1xT2L0npcvi5/v7aVmUoAHBtW+3lfe9EfWU4F3EkkE9RwyOPKZMykaIPcsHD3C6Smycq/eqUIWqtwj4uhzC0YYhjhT6Hcv79T77moICSLAmWFaUSee3Q5c5eyrnNSO3oMUgaeMLMjYFqQf69mlLKa5oSXLPAQCKMzi6uDjDLuXN+/xqf2rI+BwfDJgUhpwm0T68+NLvaHdGd30jIpARIbZtYyaJ6ZMepioWQ7DfdL67CSJKDsRMLEZN80ByjvXLh5Gq+jp4cYUphe/OHZ0KsXVLbXsCmkG+2/sgS9Tf5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 09:47:32.2582
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd5a940-6181-4952-45f7-08df3d7d4f87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018071.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6941

On 04/11/2026 18:43, sashiko-bot@kernel.org wrote:
> RDMA/mlx5: Keep the UMR QP failed once a forged CQE is detected
> 
> This commit updates mlx5r_umr_recover() to transition umrc->state using
> cmpxchg() when mlx5_ib_adversarial_mode is enabled so that a concurrent
> transition to MLX5_UMR_STATE_ERR by the CQ poller is not overwritten back to
> MLX5_UMR_STATE_RECOVER or MLX5_UMR_STATE_ACTIVE.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
>> index b0f00d4bc93ca..086b397b830c6 100644
>> --- a/drivers/infiniband/hw/mlx5/umr.c
>> +++ b/drivers/infiniband/hw/mlx5/umr.c
>> @@ -335,6 +335,23 @@ static int mlx5r_umr_post_send(struct ib_qp *ibqp, u32 mkey,
>>   	return err;
>>   }
>>   
>> +/*
>> + * Move the UMR state from @from to @to. In adversarial_mode ERR is a final
>> + * state: it can be set concurrently by the CQ poller, so the move is atomic
>> + * and does not replace it. Returns false if ERR was found, and true
>> + * otherwise. Outside adversarial_mode this is the plain store it always was.
>> + */
>> +static bool mlx5r_umr_move_state(struct umr_common *umrc, unsigned int from,
>> +				 unsigned int to)
>> +{
>> +	if (!mlx5_ib_adversarial_mode) {
>> +		umrc->state = to;
>> +		return true;
>> +	}
>> +
>> +	return cmpxchg(&umrc->state, from, to) != MLX5_UMR_STATE_ERR;
>> +}
>> +
>>   static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
>>   			     struct mlx5r_umr_context *umr_context,
>>   			     struct mlx5r_umr_wqe *wqe, bool with_data)
>> @@ -353,7 +370,11 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
>>   	if (umrc->state != MLX5_UMR_STATE_RECOVER) {
>>   		mlx5_ib_warn(dev, "UMR recovery encountered an unexpected state=%d\n",
>>   			     umrc->state);
>> -		umrc->state = MLX5_UMR_STATE_RECOVER;
>> +		if (!mlx5r_umr_move_state(umrc, MLX5_UMR_STATE_ACTIVE,
>> +					  MLX5_UMR_STATE_RECOVER)) {
>> +			mutex_unlock(&umrc->lock);
>> +			return -EFAULT;
>> +		}
>>   	}
>>   	mutex_unlock(&umrc->lock);
>>   
>> @@ -387,7 +408,9 @@ static int mlx5r_umr_recover(struct mlx5_ib_dev *dev, u32 mkey,
>>   		goto err;
>>   	}
>>   
>> -	umrc->state = MLX5_UMR_STATE_ACTIVE;
>> +	if (!mlx5r_umr_move_state(umrc, MLX5_UMR_STATE_RECOVER,
>> +				  MLX5_UMR_STATE_ACTIVE))
>> +		return -EFAULT;
> [Severity: High]
> Can a hostile NIC still cause concurrent mlx5r_umr_recover() executions and
> overwrite MLX5_UMR_STATE_ERR back to MLX5_UMR_STATE_ACTIVE?

This is the same root cause as the patch 12 finding, and the coming v1 
fix there closes it. The poller now accepts a non-flush error CQE only 
in ACTIVE, moving to RECOVER with cmpxchg, and treats one in any other 
state as forged: it sets ERR, stops the CQ and forces the health recovery.

> 
> In mlx5_ib_adversarial_mode, up to 64 threads can concurrently post UMR WRs
> in mlx5r_umr_post_send_wait() under umrc->sem, placing their contexts into
> umrc->pending[]. If a hostile NIC returns valid-header MLX5_CQE_REQ_ERR
> completions (matching qpn, sop == MLX5_OPCODE_UMR, and sequential wqe_ctr)
> with a non-flush syndrome (such as MLX5_CQE_SYNDROME_LOCAL_QP_OP_ERR, where
> wc->status != IB_WC_WR_FLUSH_ERR) for multiple in-flight WRs,
> mlx5_ib_poll_one_umr() accepts each CQE and unconditionally writes
> MLX5_UMR_STATE_RECOVER:
> 
> drivers/infiniband/hw/mlx5/cq.c:mlx5_ib_poll_one_umr() {
> 	...
> 	} else {
> 		/* Copy the CQE, so its syndrome is read once */
> 		err_cqe = *(struct mlx5_err_cqe *)cqe64;
> 		mlx5_handle_error_cqe(dev, &err_cqe, wc);
> 		/* As in the generic path, a real failure starts the recovery */
> 		if (wc->status != IB_WC_WR_FLUSH_ERR)
> 			umrc->state = MLX5_UMR_STATE_RECOVER;
> 	}
> }
> 
> Multiple waiters in mlx5r_umr_post_send_wait() then wake up with
> umr_context.status != IB_WC_WR_FLUSH_ERR and call mlx5r_umr_recover().
> Because mlx5r_umr_recover() only holds umrc->lock across the initial state
> check and treats umrc->state == MLX5_UMR_STATE_RECOVER as the normal entry
> state without serializing recovery callers, multiple threads can run
> mlx5r_umr_recover() at the same time.
> 
> This appears to allow two problems:
> 
> 1. If one recovery thread fails at the err label in mlx5r_umr_recover(), it
> sets umrc->state = MLX5_UMR_STATE_ERR without stopping cq->poll_one:
> 
> drivers/infiniband/hw/mlx5/umr.c:mlx5r_umr_recover() {
> 	...
> err:
> 	umrc->state = MLX5_UMR_STATE_ERR;
> 	return err;
> }
> 
> When mlx5_ib_poll_one_umr() subsequently processes another non-flush error
> CQE for an in-flight WR or barrier WR, its plain store overwrites
> MLX5_UMR_STATE_ERR back to MLX5_UMR_STATE_RECOVER, allowing a concurrent
> recovery thread's mlx5r_umr_move_state(umrc, MLX5_UMR_STATE_RECOVER,
> MLX5_UMR_STATE_ACTIVE) call to succeed and reopen the UMR path to
> MLX5_UMR_STATE_ACTIVE.

The plain store is gone in v1, so the poller never writes over ERR and a 
failed recovery stays failed.

> 2. When the first recovery thread's barrier WR completes and it calls
> ib_modify_qp(umrc->qp, IB_QPS_RESET), __mlx5_ib_modify_qp() resets the QP
> and zeroes qp->sq.head, qp->sq.tail, qp->sq.cur_post, and qp->sq.last_poll
> while the second recovery thread's barrier WR is still queued in
> umrc->pending and sleeping in wait_for_completion(&umr_context->done). Does
> that desynchronize umrc->pending from qp->sq and leave the second thread
> hung in wait_for_completion() while holding umrc->sem, since even the
> internal-error software flush in sw_comp() walks from last_poll to head?

Only the first non-flush error reaches a waiter, so a single recovery 
runs at a time, and no other barrier WR can be pending when it resets the QP

Yishai
