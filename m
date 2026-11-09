Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794217768;
	b=E3WKYZE592DGgIwT1N8gY2pwm00QIJ1aUXa/p6wM0r9VL4F+DEbUPNVKemjO4+ONIsQV
	 ufxNtZTzPG3YXmLU6gAWfIiTNf6ecoVp8mPg42u9B9NmoptnoofM8kZ0Pqwlu8juHDHPV
	 p3y6KjA5d8agyDo4eAOeW3gHbKqdC1GwSnCVJjOqzx+OUO5gLBbXyNt3+RyM0harrdav4
	 TeqHsVNOienVcUIumPQPOt0P4KoVOW7O9Vo5h9d4CQw0IeKcii0b9C2N4znppVSuUwDX5
	 62ilRu/0rm0Ne6yEgudseh/fVFIc9LdaICvPS6+KW85WT5XcJArixG5jyoQXjTL8JYQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217768;
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
	bh=yP8kovZnPLfelG2xizgnbK0YhV0pYl8+iAmcENWcre8=;
	b=S9H9B6mrEQds3KeJHkQaRLZnyNFit3dhz2cmvZ087rk3DF5jVcjcSiE6pNTxegARSz7B
	 uou+AAJjy79B09pJ/arLZYB2eUN9xm+q0Cw+csoUhizzU+wxGN6oYOdmiGUqXG8lU7uk6
	 NrDLXk9fS/Q4ic9+cCDsvPKTeVqOwxSUVd4f6IkJu/h7Fjpz/yzsSKiD1YexDumj3USSW
	 UUB227Hgcw1yb3dvx8bBPQdSD7XetZRGyCeoHlN4gxWRpf8xkeEFN/YFW4FJeatX4xIAu
	 HSmNaVE/u4RiGapw2bK+xCkQV2v3sRfbuEwfWcwVcAQNf22RqO0jn3Nvyhy2zQs9MxA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="mpHn4/w7";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.201.50
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010050.outbound.protection.outlook.com [52.101.201.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131E2606A31C;
	Mon,  9 Nov 2026 09:49:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 131E2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=mpHn4/w7
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hESXY84aqgc8ousIsMk9rMh3D0rcFBm/UXnle12dDPZQBNOYsOKEWpK+8s9OwGIS+yEuvYWrW+5J2z7AJdz56U7/9sPcqLyPyxyQDSKUjbfj7sNDPMt1zQDxpx44AuCCdNDbsoRIQyFCei+n6CCgNA33ge6Pxvlu7BmNtu6COROom33XQw1DGb/TyvzDaLvSDS4shOSWMRKzEvwI1lHVkrS0+k5SMFntppQGGzBi+ApJy8G+UiL1YoWCccpuyicBM2yCZQTmoufXdzllOMi9LiH/GOhiChuFkhzS7rwjUghTdYLMFDLVj9Nq7lW5H4AocvNNcIdrWiWWmsnjAFrsag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yP8kovZnPLfelG2xizgnbK0YhV0pYl8+iAmcENWcre8=;
 b=Zzv7fCgZJcKeRyvwgGSLOsISN9iKNLyCOArjyqd8f8nNMR06Sy1oEEg3TaZ4grTc3u9nFuYtegAa0EG0CKbr9D/pgPtm/KKtH3W2Iqt7WOf2zfqTAxijsFTPWfNLRKvGlO85SzL80xYw9dmpKuHzsxJSNKExsQB4ZMltS6zoqEO5Uq0cHLLyDhT7n3LHpJ91NCWIOQRFK6p9MzO106+mf0KfwY16KgxiYw2eqq5uoBEwUwlPL0b9e662tXy2OnT74F7b/h9ZHCYJ5KhfpuX9RpfuYRLP0IpH6gn4tr49VqP0Rkmyjuen4OPHiuV8f0+Ro8Tr0xDrRTc/LBiFXch9Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yP8kovZnPLfelG2xizgnbK0YhV0pYl8+iAmcENWcre8=;
 b=mpHn4/w7d53j6/AGpeq8pu2u9yZc5zRtsgnHRm3ktAXXIOGLAaDL5wAVsXeTFyyQ87Hbfkdt7xRyettDw2DhuJ2HPP2nXq5oBB8bwqrLAGOyRXxan5m2OZDrazI5i4sX8ZqWran8FFU8y3fWU0jlMWIusMEaFogghTji4sJL3eZk0K9COwPlrU7jAxMSDqxWUfWnFgnDt+b3OMTi18YMjpgxL1i0gZsOK9IefIRAD/G34g1hfFW6i383Mfs1uBCb+1EBkl4q8SMEV96y4dWsrk8PJRygAWRdEHZXwn91yNAA3EVSDZY3BngR/6nX4jz9DxomRlgJBmfgKuuAh0Xekw==
Received: from PH8P220CA0061.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:2d9::12)
 by IA4PR12MB469045.namprd12.prod.outlook.com (2603:10b6:207:108::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 09:49:24 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2603:10b6:510:2d9:cafe::a8) by PH8P220CA0061.outlook.office365.com
 (2603:10b6:510:2d9::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 09:49:23 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 09:49:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 01:49:08 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 01:49:02 -0800
Message-ID: <f57abee4-9504-4491-bfdb-c5554cc01873@nvidia.com>
Date: Mon, 9 Nov 2026 11:48:59 +0200
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
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-14-yishaih@nvidia.com>
 <179408309600.994134.14553230868146108147@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408309600.994134.14553230868146108147@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|IA4PR12MB469045:EE_
X-MS-Office365-Filtering-Correlation-Id: f642be57-03f6-472e-1e8b-08df3e46bc3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|23010399003|376014|7416014|22082099003|18002099003|6133799003|10067099003|4143699003|11063799006|5023799004|261028144727099003|261102123227099003|261022105027099003|56012099006|261021121427099003|261021135927099003|261026121527099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	u4O+uOqPbIoZHdSbyeJONXKN3cIBTNFUTKoXDjM/fV3eKTgJOY7+bwgD9rFFK/FUaUKkDQv5vDMQgYk0OX89hf3GxQX5MSyUwMrj0Xx90//OCUDzmS3gSfu1l5gaoZYjOFlymGISYVHx4sSBfe+76+FMR54uZlJP1zXtvLzUeT4UkFH3CG9cqEyV7Wcqcr8dtsgxxH9eIIazXJEh19Of3a/aYVR2ACHd6sapOED7oX3QEfE6H6cQglW0w3RBmetAADMFDbR9Na7WgKShcPy5+eU4GSADZ66thV54IwkOxj0QZfJkKl5zVp5AQGiMOu04DuIqXEKi2l4R/0Lyz386sZ17oM0p+RQvRnaRL+av3sCs3lTZaCkPsr7ONCAN/8qtZgGFojZteAgcq7Etp741CQmtIHgF7mZ/Sq749H32Kz1ZQh8nm1OJtxdzixIjm2Xt4qTA9oeY8nsYumkjeM8Td+VZvicdbdUqpAB7z3BwFoKhCfzPQVsS/NUAILSsUk36zBaBBOzwpVq0/Fswq+NJtcnlwYjYqnYFnEUtvno2zP5cNdmTW7TKtuoNjp7B6FFRbZA2FwQNdyA9uXY0SrSY8GqiXwaB8uAShYmjD3IkuBgWgLIahCuOLK1JvB8TU2F0kiaSxBMvnyck/Fccy7WVi5cxRbwkUUIix4OxcmBNUBHw/1J2qwI9/LE/S5gHR4vWn3HZ62omKh3L6FssZX9vCQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(6133799003)(10067099003)(4143699003)(11063799006)(5023799004)(261028144727099003)(261102123227099003)(261022105027099003)(56012099006)(261021121427099003)(261021135927099003)(261026121527099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lMsV/GgEdUFy/vANddW2BZg9Lp9zNLYjzW/nnjtt8lCQyCyEIHpgFejFqbAtLLoQH2IKHR9etuss3LXlEWo1wll8WDL/cLZHwrQubZJSUnMI8ahKDEVKz+yQ8/+ysjpQHK8LEE2FPI+qDipoR9H3KaeG9I9bmylmJRooP3S03FgJkvnbH1yYVmLv31HvYaXwc90DhPsqKzcoM3t4PC93u+aK8F6Np2/rSMna7H4fNjarT9CVHWCQTP15dVzFPDkmyFhgOHzWczkGtNwE88m4Q5sEgq+PCJ+ZlDY8UqXZNwXvjkqnjGOfT1CYWScgNylXW0fvYproAwqdaj3dBEFXEN6wvtmpmrf9y1ATqh1oBj2DdOmWesNFxHPKB7vaCdEtblnre2QV2wSGkr3phqDEwIbX2vaT+yExOyGks0zy2xBawdzSgB6PNz09ZxHsnWLj
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 09:49:23.6521
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f642be57-03f6-472e-1e8b-08df3e46bc3f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB469045

On 07/11/2026 22:24, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 2 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] In adversarial mode, mlx5r_umr_recover()
>    (drivers/infiniband/hw/mlx5/umr.c) checks for MLX5_UMR_STATE_ERR at…
> - [Medium] The new comment on mlx5r_umr_move_state() (umr.c:338-343) and
>    the commit message both say that in adversarial mode ERR is a final…
> 
> --
> 
> RDMA/mlx5: Keep the UMR QP failed once a forged CQE is detected
> 
> In adversarial mode, this commit changes mlx5r_umr_recover() to move the
> UMR state with cmpxchg(): ACTIVE to RECOVER on entry and RECOVER to
> ACTIVE at the end. The goal is to stop recovery from overwriting an
> MLX5_UMR_STATE_ERR that the CQ poller sets on a forged CQE. Outside
> adversarial mode the transitions are unchanged.
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
> 
> [Severity: Medium]
> Is ERR really final here? Only the transitions in mlx5r_umr_recover()
> were converted to cmpxchg(). mlx5_ib_poll_one_umr() in cq.c still does a
> plain store for every validated non-flush error CQE:
> 
> drivers/infiniband/hw/mlx5/cq.c:mlx5_ib_poll_one_umr() {
>      ...
> 		if (wc->status != IB_WC_WR_FLUSH_ERR)
> 			umrc->state = MLX5_UMR_STATE_RECOVER;
>      ...
> }
> 
> That store can overwrite the ERR written by the err: label in
> mlx5r_umr_recover(), and that label does not stop the poller:
> 
> err:
> 	umrc->state = MLX5_UMR_STATE_ERR;
> 	return err;
> 
> Could a hostile NIC reopen the UMR path with a sequence like this?
> 
> 1. Waiters A and B each post a UMR while the state is ACTIVE.
> 
> 2. The NIC returns validated non-flush error CQEs for both. A and B enter
>     mlx5r_umr_recover(), find the state already RECOVER, skip the entry
>     cmpxchg, and post barriers WQE3 and WQE4.
> 
> 3. The NIC completes WQE3. A moves the QP to RESET, the NIC fails
>     RST2INIT, and A's err: label stores ERR.
> 
> 4. The NIC returns a non-flush error CQE for WQE4. It passes the opcode,
>     QPN, sop, wqe_ctr (FIFO head) and wqe_head checks, so the poller
>     stores RECOVER over ERR.
> 
> 5. B's RESET and RST2RTS succeed, and B's cmpxchg(RECOVER->ACTIVE) also
>     succeeds, so the UMR path is ACTIVE again.
> 
> The generic store of RECOVER in mlx5_poll_one() has the same problem at
> this commit. The later commit "RDMA/mlx5: Block generic CQ poll path in
> adversarial mode" closes that path by making mlx5_poll_one() return
> -EOPNOTSUPP in adversarial mode before the store is reached.
> 
> Would a cmpxchg(ACTIVE->RECOVER) in mlx5_ib_poll_one_umr() fix this? If
> not, should the comment say that only an ERR set on a forged CQE is
> final?

Right, V1 will move the state in mlx5_ib_poll_one_umr() with 
cmpxchg(ACTIVE->RECOVER), and treat a non-flush error CQE that fails it 
as forged.

> [ ... ]
> 
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
> 
> [Severity: Medium]
> What happens if the poller detects a forged CQE after this
> mutex_unlock()?
> 
> mlx5_ib_poll_one_umr() never takes umrc->lock. It sets ERR under cq->lock
> and only queues the forced health work:
> 
> 	umrc->state = MLX5_UMR_STATE_ERR;
> 	cq->poll_one = mlx5_ib_poll_one_stopped;
> 	mlx5_trigger_health_work_force(dev->mdev);
> 
> After the unlock, mlx5r_umr_recover() does not look at umrc->state again
> until the final cmpxchg, so recovery continues:
> 
> mlx5r_umr_recover()
>    mlx5r_umr_post_send()
>      only checks mdev->state, writes the barrier WQE and rings the doorbell
>    wait_for_completion()
>    ib_modify_qp(umrc->qp, &attr, IB_QP_STATE)  /* RESET */
>      __mlx5_ib_modify_qp()->mlx5_ib_cq_clean() sweeps the stopped UMR CQ
>    mlx5r_umr_qp_rst2rts()
>      RST2INIT/INIT2RTR/RTR2RTS put the hardware UMR QP back in RTS
>    mlx5r_umr_move_state(umrc, MLX5_UMR_STATE_RECOVER, MLX5_UMR_STATE_ACTIVE)
>      first point where ERR is seen
> 
> The NIC controls CQE timing. It can complete the barrier with a valid CQE
> and then forge one while recovery is in the RESET/RTS steps. All of this
> can happen before the forced health work moves the device to
> MLX5_DEVICE_STATE_INTERNAL_ERROR.
> 
> umrc->state stays ERR, so mlx5r_umr_post_send_wait() still refuses new
> UMRs. Even so, in this window the subject line "Keep the UMR QP failed",
> the existing comment "don't revive the QP" in mlx5r_umr_recover(), and
> this part of the commit message don't seem fully met:
> 
>    This keeps new UMRs away from the NIC until the forced health recovery
>    moves the device to MLX5_DEVICE_STATE_INTERNAL_ERROR
> 
> In adversarial mode, should ERR be checked again at these points?
> 
> - before the barrier post, perhaps inside mlx5r_umr_post_send() under
>    qp->sq.lock
> - after wait_for_completion()
> - before each ib_modify_qp() step
> 
> [ ... ]
> 

Not needed. ERR stays set, as the final cmpxchg fails, so no new UMR is 
posted, and the stopped CQ completes nothing.

Yishai
