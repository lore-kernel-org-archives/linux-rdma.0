Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.0
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793897218;
	b=Mt40qVZIMYnxFiFU5368D1/55SJN0PoGpCdHraKQCb09ofRro5L1/yZYKyPGbdTfP3/8
	 aJI3W8oF96NNVpeZaDfAz3Iui9hdnz3PyIodRGNPsXaF+/prX2ohgYSn9taXu5sqlQg5H
	 1qr8iVYj0vCt0VFY+qEsid4M734DEoXsIPcvC2jpM97c1c0U8GsdRBBTtLWG1K6DyVsmz
	 NzDF13TebpdmqYmU5Iuc+6GmweWjF21JfHuJwVPcW3xK8xPMR+o0o9Sa4DAZctBqIpMAK
	 J3JaVGqZxY38MmUF7iO8QQbgaCFnKf6nL/VYY6sgScghI0XIoM5R5XjCSRY7hb9yRlQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793897218;
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
	bh=9U2W/l6HONDgEKCYJhjcNm0Q+NpfzA9qbXHQvhq1QaU=;
	b=CuZouoW4dL1YULgyvnyx/uWXG6yOB/9CxpZ2Zj24X66f1ckFdQbRJyhvx8la96Xmdhh0
	 QrufG+PmOCph17N/J5IqEZ34BypVPf7Gj9+xgwkobyLAGU9KVWW8SDQWaLb7dkmhk1TaM
	 ddxlQz6Vkvdl3EKa6AzAS15iBKf6oOuolW1Dp7o79KNDeWokISUH9oOgXa/W7EsUt6sf4
	 hnFQkQl/IGJL6nr3xSKKuRhHShRNJQHIQ90LU6SNy+xYPc67NJw8u59dkVsa3/myxtx34
	 drJFwWUjHfcW1B0/DPYDKya4IC9bZCqwS1Q86Ueb1G8SQOwtcQS6aAhpQt19e4Rh/zA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=af9MZgXc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.0
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010000.outbound.protection.outlook.com [52.101.46.0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA85606A339
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 16:46:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EEA85606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=af9MZgXc
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kSW3/zSvXHXmvxP4j8vPpKrj1ASpHIuBzPx70IFEsOjjeoreKDhKHe2mBOiKnvtV9AeCy8p6SoP9CoZm5jXrFFHdmJdenNDDA476VZ7ECVytfmKy1SdobNz9u+aALB0hUmGT3Fm+Q2mWGdeqxK+rs58tajuxiSJJpQesh3UMbN9/TQCX0W/BYwmbqLPn9R5evtEl6BLh9PTmHstBL3D0SH+M4vzGcYQKFsQLzr8pXopjNQ7vxz9cW1fQ4/7Jq4gHHF82h0kPQeW9VvyDJe97dPI8nFQUyUbEmCtV4sXJKxvRaE0uo+6QN/b4Q1NaYPUY7TIBnPrUtoNWPOlmeurScA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9U2W/l6HONDgEKCYJhjcNm0Q+NpfzA9qbXHQvhq1QaU=;
 b=U7RCgR+T4EAQEJX7gR2I6YkfwVbJ7+Kar5UwZkSpN7tW5RySZvwA3r7fIL+o39Ieb0fqZyPpO6kxQqxfVVEPFrTrpFEeFYbxEG0yLcgEiUQ8sU2OzihdQXvsVljrrOIRZno0fVmvr0uYZGEzqM30AY+h2xNr2zxBpofom3gVqQotbdJgCAgvDobBhhtZLBQJ3XTbZxA9zBMupVfdN4ApmTplhBcjmrF9a7tYUhdTzbM39sLvrlqt15PVVlgV/vWTMeulxNtWTJlWxG8/eQEXdVUVwEe+L13g5MNrY0NUnhlyJBF5ERJ0eMO18MXGnGA3UHapeDXuRtxrOvHUqWeI8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9U2W/l6HONDgEKCYJhjcNm0Q+NpfzA9qbXHQvhq1QaU=;
 b=af9MZgXcbOpGzj810DWStpBuVJQdlZr5ETXee2LnDuW2ev1njB5swZ0ANJkOZkFg3Dh1fGjwEwIxkdn/OOsNxA6XJC+q5VceS4Khqx44c2oKX6F6VzBeNDNNiCEHLwaDFNLSdAdO5QvdNcbm2AlHkCFRF+uu0izyX5oZWfvg99/NOERz3NbZsHffzzbs7E5pPLWDsSxswIVo2MXajscqTOKF9lr1uZWbsu5x7d1dwejTJJhRtvai9ZIxtJFkWDMc7Qep3gVxDZ44ZMtuisgS9nFnOB5l80ZsCyjTl7Nd6zL4aj8nVali9hLJayJbWhH5h89l+NgEYBoNeCDigL7JGw==
Received: from PH5P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:34a::12)
 by PH7PR12MB6763.namprd12.prod.outlook.com (2603:10b6:510:1ad::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Thu, 5 Nov
 2026 16:46:53 +0000
Received: from BY1PEPF0001AE17.namprd04.prod.outlook.com
 (2603:10b6:510:34a:cafe::44) by PH5P220CA0007.outlook.office365.com
 (2603:10b6:510:34a::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 16:46:53 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BY1PEPF0001AE17.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 5 Nov 2026 16:46:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 08:46:29 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 5 Nov
 2026 08:46:28 -0800
Message-ID: <2b1bc8b7-f81e-4203-9917-397bcfb236a4@nvidia.com>
Date: Thu, 5 Nov 2026 18:46:25 +0200
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
Subject: Re: [PATCH rdma-next 12/23] RDMA/mlx5: Verify UMR CQ polling against
 a hostile NIC
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-13-yishaih@nvidia.com>
 <sashiko-outbox-197665@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-197665@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE17:EE_|PH7PR12MB6763:EE_
X-MS-Office365-Filtering-Correlation-Id: d29327bf-d5ae-434c-e0eb-08df3b5c6521
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|376014|36860700016|56012099006|261102123227099003|4143699003|5023799004|261026121527099003|261022075727099003|261021135927099003|261028144727099003|261009223027099003|261021121427099003|261026140227099003|11063799006|261022105027099003|22082099003|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	WAs2LRyA7qzOflxkX9Zu+mqCtFk+P9Z7NpiBAvYEFZeYVs2LjKzVayrV7InZpFRoopzxwFzfXJMqBFtz2sQf27GooXLVmbjznwK9GyvMJ97ckcx52XZiZlpOwYKI2IoKBXF5Lic6uycyxmC3Hxw/TBsFr8QWPf5Wb77DiCmcPIiYClzAPO+jp6CBfeRizZlg9HjDePa5jwsGYGcsQ6qQn6sKC9B/JsCamj7EP0Z8OAqnPj1NOC7UVJkfINduJW2qC9RhacQRsq5HVvf2ZYIDgg05KtxZnX3U8KQF65hE9b8Egf1lxLRKz8Z6Yf3yGUjlMdlf6e4lTtt1joVhQfYR3UWKQU5BFliDk85zJ/HHbucEN1q3aJu+u1zqazqcHeynmVuSptYh0aeTZVmr3MYFz3qJSvRURA1HQvcIVsInqKfa5n5hIwLaY0foN2bg8b2WldurBFX4Pc2cNO71h/e/EkyyTS22rdXLsSgONz8eyVg1eO45nTg7bDLKuaOdtgh6BbKs9ueGAf3iPmifkuk2X+6+wYpUReR3aPoHjAM2TUIuXljD/KZ4mTwu23tKTi0h14clQTNjviZbEtpg4arK4jQuGdt4U7XEUwDkyl4V/KKSNZL+fuywoBBoIv7CQKi23kc3yNuI/1r/GLXxEuleUG+nRTiYzped9fEucHPsQdU3FAffTbyLjdNfctxgFekIjXTUhAsN7VO0SBJVakPWgA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(376014)(36860700016)(56012099006)(261102123227099003)(4143699003)(5023799004)(261026121527099003)(261022075727099003)(261021135927099003)(261028144727099003)(261009223027099003)(261021121427099003)(261026140227099003)(11063799006)(261022105027099003)(22082099003)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2ZBJy1fZvEdnT2E4uoCgkMBktz0grjAQfUWbgA2KBwoNs2aJpOxbl/O4l+N5ao6sP1bCOgi7eYYnLepMheKBiCkoFUdeqffDpHAY7IOc9cFO50tqjSVA+XjKExKUdODTgKw3JjSmXHL7adgX/qywWYYlNIfTiPD7+yJT9saB0i3v6NHL91UtxJ4cb+QnYqtLwawFfbhggYMGb3g6XSMcOwRxfwg9wucMm9pMHIADQgJHF/u3zLwscMzP5EewHzJAJn8wY4mQTjQsxF0RiPTshOaap/Ezpdlqqu+HaSahPCVNd2xpm4Zo+0G7C2HPqn4CURPHSWJLQUexFisqi6+4m6ixwtHo6e2AKOsrTVQ+dVCyWDrVeenCnUBhD1nUg/TNcIOJfDIilkXiIdDOkRvfbUnIsgljbxIlA8p2QDNji4EWS4X5nGWVaKB5v5Is1QCi
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 16:46:52.8358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d29327bf-d5ae-434c-e0eb-08df3b5c6521
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE17.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6763

On 04/11/2026 18:43, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Critical] RDMA/mlx5: unvalidated error CQE syndromes in mlx5_ib_poll_one_umr()
> - [High] RDMA/mlx5: hung UMR waiters in mlx5_ib_poll_one_umr() on teardown
> --
> 
> commit da9b5d87a1b071b4bd6eacadaf91a72df89f8c23
> Author: Yishai Hadas <yishaih@nvidia.com>
> 
> RDMA/mlx5: Verify UMR CQ polling against a hostile NIC
> 
> This commit adds a dedicated UMR CQ polling handler in adversarial mode
> that validates incoming CQEs against a shadow FIFO of posted UMR requests
> and triggers forced health recovery if a forged CQE is detected.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>> index 11c1153747c24..1a98263ec3111 100644
>> --- a/drivers/infiniband/hw/mlx5/cq.c
>> +++ b/drivers/infiniband/hw/mlx5/cq.c
> 
> [ ... ]
> 
>> @@ -608,6 +609,161 @@ static int poll_soft_wc(struct mlx5_ib_cq *cq, int num_entries,
>>   	return npolled;
>>   }
>>   
>> +static int mlx5_ib_poll_one_stopped(struct mlx5_ib_cq *cq,
>> +				    struct mlx5_ib_qp **cur_qp, struct ib_wc *wc)
>> +{
>> +	return -EAGAIN;
>> +}
> 
> [ ... ]
> 
>> +int mlx5_ib_poll_one_umr(struct mlx5_ib_cq *cq, struct mlx5_ib_qp **cur_qp,
>> +		      struct ib_wc *wc)
>> +{
> 
> [ ... ]
> 
>> +	/* Pop the shadow FIFO head: validated, dispatch to its waiter */
>> +	WRITE_ONCE(umrc->pending[head & (MLX5_UMR_MAX_WR - 1)], NULL);
>> +	umrc->pending_head = head + 1;
>> +	wc->wr_cqe = &expected->cqe;
>> +
>> +	wc->qp = &qp->ibqp;
>> +	wq->tail = wq->wqe_head[idx] + 1;
>> +	/* Advance wq->last_poll, the internal error flush starts from it */
>> +	handle_atomics(qp, cqe64, wq->last_poll, idx);
>> +
>> +	if (opcode == MLX5_CQE_REQ) {
>> +		wc->status = IB_WC_SUCCESS;
>> +	} else {
>> +		/* Copy the CQE, so its syndrome is read once */
>> +		err_cqe = *(struct mlx5_err_cqe *)cqe64;
>> +		mlx5_handle_error_cqe(dev, &err_cqe, wc);
>> +		/* As in the generic path, a real failure starts the recovery */
>> +		if (wc->status != IB_WC_WR_FLUSH_ERR)
>> +			umrc->state = MLX5_UMR_STATE_RECOVER;
>> +	}
> 
> [Severity: Critical]
> Does mlx5_ib_poll_one_umr() need to validate whether the error syndrome in a
> MLX5_CQE_REQ_ERR completion is valid for the current umrc->state?
> 
> If umrc->state is MLX5_UMR_STATE_ACTIVE and a hostile NIC reports
> MLX5_CQE_SYNDROME_WR_FLUSH_ERR for the oldest pending UMR WQE,
> mlx5_ib_poll_one_umr() completes the request with IB_WC_WR_FLUSH_ERR while
> leaving umrc->state as MLX5_UMR_STATE_ACTIVE. In
> drivers/infiniband/hw/mlx5/umr.c:mlx5r_umr_post_send_wait(), the waiter sees
> IB_WC_WR_FLUSH_ERR, continues the loop, sees umrc->state is still
> MLX5_UMR_STATE_ACTIVE, and reposts the WQE indefinitely.
> 
> Conversely, when multiple UMR requests are in flight concurrently and the NIC
> returns a non-flush error syndrome for more than one of them, each of those
> waiters wakes up in mlx5r_umr_post_send_wait() with a status other than
> IB_WC_WR_FLUSH_ERR and calls mlx5r_umr_recover(). Because mlx5r_umr_recover()
> drops umrc->lock before posting the barrier WR and resetting the QP:
> 
> drivers/infiniband/hw/mlx5/umr.c:mlx5r_umr_recover()
>      mutex_unlock(&umrc->lock);
>      err = mlx5r_umr_post_send(umrc->qp, mkey, umr_context, wqe, with_data);
>      ...
>      wait_for_completion(&umr_context->done);
>      attr.qp_state = IB_QPS_RESET;
>      err = ib_modify_qp(umrc->qp, &attr, IB_QP_STATE);
> 
> multiple threads can enter recovery concurrently. When the first thread
> resets the QP via __mlx5_ib_modify_qp(), qp->sq.head, qp->sq.tail,
> qp->sq.cur_post, and qp->sq.last_poll are zeroed while the second thread's
> barrier WR remains in umrc->pending with a non-zero wq->wqe_head[idx].
> Completing that second barrier WR then sets wq->tail = wq->wqe_head[idx] + 1
> while wq->head is 0. If a subsequent forged CQE triggers internal error
> flushing, sw_comp() computes cur = wq->head - wq->tail (which wraps around as
> unsigned int) and completes stale wq->wrid[] entries pointing to
> stack-allocated mlx5r_umr_context structures of callers that have already
> returned.
> 
> Should a flush error while active, or a second non-flush error after
> entering recovery, be treated as a forged CQE (or should error CQEs on the
> UMR QP be disallowed altogether in adversarial mode)?

A second non-flush error during a recovery: OK, V1 will treat it as forged.

A flush while active: No change is expected, a conforming NIC may send 
one after an async QP error. It is a pre-existing, generic issue and a 
DoS at most, which is out of scope for this series.

Disallowing error CQEs altogether: No change is expected, a real UMR 
failure can happen and is handled by the existing recovery.

> 
>> +
>> +	return 0;
>> +
>> +forged_cqe:
>> +	/* mlx5_ib_poll_cq() updates the CI only for a returned completion */
>> +	mlx5_cq_set_ci(&cq->mcq);
>> +	/*
>> +	 * The NIC forged a CQE. Fail the UMR path for good, ignore any later
>> +	 * CQE and force the health recovery, as the fatal sensors still read
>> +	 * clean. The internal error flush then completes the waiters. Return
>> +	 * an error, not -EAGAIN, as a CQE was consumed.
>> +	 */
>> +	umrc->state = MLX5_UMR_STATE_ERR;
>> +	cq->poll_one = mlx5_ib_poll_one_stopped;
>> +	mlx5_trigger_health_work_force(dev->mdev);
>> +	return -EIO;
>> +}
> 
> [Severity: High]
> Can relying solely on mlx5_trigger_health_work_force() to flush pending UMR
> requests leave waiters in mlx5r_umr_post_send_wait() hung during device
> teardown, reload, or removal?
> 
> During teardown or reload, mlx5_unload_one_devl_locked() and
> mlx5_uninit_one() in drivers/net/ethernet/mellanox/mlx5/core/main.c hold
> dev->intf_state_mutex while unregistering the IB device, which revokes open
> MRs through:
> 
>    mlx5_ib_dereg_mr()
>      -> mlx5r_handle_mkey_cleanup()
>        -> mlx5_umr_revoke_mr_with_lock()
>          -> mlx5r_umr_revoke_mr()
>            -> mlx5r_umr_post_send_wait()
> 
> In addition, remove_one(), shutdown(), and
> mlx5_sync_reset_set_reset_requested() call mlx5_drain_health_wq() or
> mlx5_stop_health_poll(), setting MLX5_DROP_HEALTH_WORK before mlx5_ib
> teardown finishes.
> 
> If a forged CQE is detected in mlx5_ib_poll_one_umr() during these flows,
> cq->poll_one is replaced with mlx5_ib_poll_one_stopped without completing
> the entries in umrc->pending. The queued force_fatal_report_work calls
> mlx5_fw_fatal_reporter_err() in
> drivers/net/ethernet/mellanox/mlx5/core/health.c:
> 
>      mutex_lock(&dev->intf_state_mutex);
>      if (test_bit(MLX5_DROP_HEALTH_WORK, &health->flags)) {
>          mlx5_core_err(dev, "health works are not permitted at this stage\n");
>          mutex_unlock(&dev->intf_state_mutex);
>          return;
>      }
> 
> Because dev->intf_state_mutex is held by the thread waiting in
> wait_for_completion(&umr_context.done), or because MLX5_DROP_HEALTH_WORK is
> already set, enter_error_state() and the software CQ flush cannot run,
> leaving the UMR waiters blocked forever. Could forged_cqe drain and complete
> the remaining contexts in umrc->pending directly?
> 

The same hang can already happen today, in a rare race: if a UMR WQE is 
not completed while unbind runs, the health work is already dropped, 
nothing flushes it and the waiter hangs, as the wait has no timeout.

A forged CQE reaches the same state. It is a pre-existing hang, i.e. a 
DoS, which is out of scope.

Draining the pending contexts in forged_cqe would also be racy, as the 
internal error flush may complete the same WQEs again. so forged_cqe 
does not drain the pending contexts.

Yishai
