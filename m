Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.38
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794217128;
	b=ltzvLwBSbhnAj40YpcrEzwpHi+QQ1KfgY3E++rlMTdJ4Llcv9/2dBoePvlwCkmk47sOz
	 bicJTTvHXIJuokZU6HPDlK0FfaEec6XGx9X3juE3BZxJ3Ld5H6HQeeVcM/kZI1H2Y/abo
	 5cUWp25AqZDa/Sib+2GvXWIfrR/6LJFLX0zMuyU8ucEyjGTMXJyJLaMayjg4plSABfiE0
	 ZDeTdKARPLHXHhkVxvH66o07UTZK7UwW6947fodm/muOwx/KAD3H+5g/J87dfOIBL6hvg
	 ZZZ23DlQ3cDU3ghsASZ/2JgQ/O3ymQtero85TSx4r2vypCRSUJ6pj8DE4mOGvMm1/AQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217128;
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
	bh=HhOuG6U64dk63g5mixJWs263abmHbcnxcG3fFGYM680=;
	b=lqUywxowN+Ze+UqxOt5YZ3F6w3BcG5kEvhu6tyzf85P2DsnwX4vQgE2q8Usxlno3XsU4
	 x5QY5BAcS4xuLP8QwPyCwiKVuyVCVI5AU7Z+tF6t8KeDbijYoU4bo6wkhPJW0Zxx+dHPI
	 fB1fEXUVR0iaIpYE5JWN2b5Qy5Te7Cny06VnAbzR1Nl/qmy58ATmj3XlAqDEjJBc5DTGI
	 HUhsK/6tFJ6b/skMzYZoc/7ESzBPKpmCB8sn0mHYHfOjpYA0/MfPPEmWgkCv0bunW/nZn
	 OKdiZ5C1WSc8Wd058ZyOBjptmcJA8jIq9NNFumg9vyUI+O1OtPES+nGrOafHJ0Trgfw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bEIDJKdU;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.38
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011038.outbound.protection.outlook.com [52.101.52.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2D5606A31C;
	Mon,  9 Nov 2026 09:38:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F2D5606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=bEIDJKdU
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gzM8nI4H1NaqK4NI8T5efEca0Lmu5SsjG7gBYuMKDRP3ZoXwCVSTg4nDON9qvEPRXEEpGVLD46NvFZtwR+a3Pehevu3XWEo8zqLz04UUNV0H0FAmEgTH3ZM4w4KI09z58t7BKz/Q0Nfw9mwdQRO4xerO473NXoGg4VphdSfgzM7dDroZtDY/Zs+MRvmIeVStg4CQh/H2VeWeDWkHywGWyqrvBiTEBinAxiBKtUdw7l/JFuOtoA5eaHXNUtnMYW3YQV8S69SFm4XgNptukbYFN0MI9RaH/cEVRN+gL0RKbw4WlYRK/rYTuuKUR7QQoweL9kGKaEY+vflmOKpEBY2Idg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HhOuG6U64dk63g5mixJWs263abmHbcnxcG3fFGYM680=;
 b=QIsB5MJeIr4el5Dcu2znLw85ZkClY1EBHUfB2nDh5yYX9PXLD4ClBG58Bk7cGOoKyAPOCUDKtp9woBUn8CO8Ghvr4zxE+yPcY6bTGnr1VVk5ekealcuKTXEExdudvRrgAYjr24E5pxx7aztxb822fu3y/2h1G8iGnvKuYNZauEuwUyXBvnY4cFwWFydOB0HsWcqQ9uJ/k+EvkVz483XNGkOA4Cfop2c8aQev9Xcqbe7Vyli+yMFteBUosm5HIcpS48h38gNKiXShE0UTINQ3BY+iImlMyM+DPDf3duJMHgLA7U6HZIr+ZJUU+V03b/summ+FbnsHGUslobq6wmg6og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhOuG6U64dk63g5mixJWs263abmHbcnxcG3fFGYM680=;
 b=bEIDJKdUarzIEKbv/3yes79OoOfVLJjVrI1x26BymzpB/TsKHH/3KNMFnhc3Lx5ibBmePcn7A8V/qFx/Ub+aR+jq43j9PkFZOj1laFtMC6mrjv6ql8FKoJEP61ug1mFnCj8di4II3HYpYPnRJFIB8+AeXAV1hX3TrshiNF7hdKRuT8KA5IODUjI4MCs1kL6gqKEcIVr5YgSEaiAjzMhK0dK3oCcbQnWU7dUjqgUjW97R0cOu8o07xHn5dKhRjm3RBU7q4i9Q59xsG4aAMNh45paso9VoF6ONjWr/cTgOxywqIqMcU4Gr66iSYxjVBQiC3Re9vv9/1oGuOhxZHpJmmA==
Received: from DS1PR03CA0006.namprd03.prod.outlook.com (2603:10b6:8:450::17)
 by BL3PR12MB6596.namprd12.prod.outlook.com (2603:10b6:208:38f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 09:38:41 +0000
Received: from DM3PEPF000265C3.namprd03.prod.outlook.com
 (2603:10b6:8:450:cafe::3d) by DS1PR03CA0006.outlook.office365.com
 (2603:10b6:8:450::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 09:38:40 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM3PEPF000265C3.mail.protection.outlook.com (10.167.23.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 09:38:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 01:38:24 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 01:38:17 -0800
Message-ID: <1d95fb1e-aab3-4f12-a229-5b55ceed8d3a@nvidia.com>
Date: Mon, 9 Nov 2026 11:38:14 +0200
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
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-13-yishaih@nvidia.com>
 <179408309434.994134.3459380801419463957@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408309434.994134.3459380801419463957@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PEPF000265C3:EE_|BL3PR12MB6596:EE_
X-MS-Office365-Filtering-Correlation-Id: a4494a54-f2af-4f2e-1f18-08df3e453d08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|82310400026|36860700016|11063799006|5023799004|4143699003|261021121427099003|56012099006|261021135927099003|261021123027099003|261022075727099003|261022105027099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|261102123227099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	IgGfexO92XgGam3unWRooUrXuG2EdjJbs8DFymPAZUUoTFcwDkfRTzFPa6Y3mVtvcQdAnpF1w15ZCeHsHjRlNMzrnWz8lPWqiXogFKuINXbEXM2p6Oiw0Oa/ZuzbCPDf+VcHaP/li6ja4xwjxGE/bm34pv0X5WpL4t5EyzlE8BaQEHYxGdetd9CsYL8UBQsc9L41JSHFBlWmmw8emkNbcIkdtnLmwjjd59sOxlUnkS5L7rkmByMpM3FfaWmJjQ9KPjvC4kG0FQkHweMpqD/Vc46PV64JdSPs4ktyUiDzjIoPAms+/hKP4i1CqgepU9nC0TnPqgjMxGw86wsIkdC61pNpwKChdYAN5WscEBdkLY6pZn/D3E2tKp/bheWMoQEqu9js+1RarB15+BOKOasCPYXR7lmNMQyJH+lIk8oRThGFISO8ztXKQpls9Z/SN/oDD2qzTLawJF2cp3s8fRprBuEORDOmdTH1cfWataGSZrLFhG27GToAwOJ1a8r8C6yCSaPImfbWmTiNDl6kzrGGyCGPWkIkk+jmAhJjNGLPXyZLmKOmSJvKbXDL55D9A9Ig4O2Y6x/IushWUOmMpVXya8wkhNhSEJaSlqUQ9+LS5DfVaZGyllIzNbMsv2VXSP3P2yvP/65xpwlyWlPWSBkZ/R8L50YEtpG0BlWqEYvhokSZleyjjby3QRLVuxZw29hyJV/1cPGmIvwv+owOuq3AvQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(82310400026)(36860700016)(11063799006)(5023799004)(4143699003)(261021121427099003)(56012099006)(261021135927099003)(261021123027099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	80TiAWuC8NJ1QTrdT/wDuuGjO7z0ZCuhPnjwGA9DoChtmDmHwvyDFszxH1SnD5uVNu7y+A3MmpT1mSc/JoXJBJF4nLx0MlwiwFXv5B/c2VehxjedhjYGkHcgAynx/cRSoKAMHu8dTO5KrG4EK4lKkb98N7QvBMJfqqKHEnlAmnEkqtjhApocVqg0pkBbC28w5ryWbdWcWM8hYt60rpwSDmaJF9yBSVcwuU0HbyKsE4Nqsmpvmwaz9hGpNjcX/R6mg2+NvDd/Iw4hp+IVo6ZwpL9pAIV+0hJ2aNvlLTAK2Kbh21uBnCnfc9ObTuQ2SaRpuX4rVv11XGDs43eREf+0PNKReuYBF20uN3v4t/ZuHkngBO04M1CLfnYrX+EUNXPIjUDIBg33UGdKwLyCA3YdG8El1VPtjNeKwdRFbukv/q99FnJ58/y1KVOJQVodDwMS
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 09:38:40.6214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4494a54-f2af-4f2e-1f18-08df3e453d08
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265C3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6596

On 07/11/2026 22:24, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential
> issue(s) to consider.
> 
> Critical: 1 · High: 0 · Medium: 2 · Low: 2
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Critical] RDMA/mlx5: unvalidated error CQE syndromes in
>    mlx5_ib_poll_one_umr()
> - [Medium] When a forged CQE is detected, the waiters are only woken if
>    the forced health work runs, and on the unload and remove paths it…
> - [Medium] mlx5_ib_poll_one_umr() treats a CQE as forged if the top byte
>    of sop_drop_qpn is not MLX5_OPCODE_UMR.
> - [Low] After the forged-CQE path sets cq->poll_one =
>    mlx5_ib_poll_one_stopped, the UMR CQ's consumer index never advances…
> - [Low] The kernel-doc of mlx5_ib_cq_stop_polling() says that on return
>    'no CQE is looked at again'.
> 
> --
> 
> RDMA/mlx5: Verify UMR CQ polling against a hostile NIC
> 
> In adversarial mode, this installs a dedicated poll_one for the UMR CQ.
> A CQE is accepted only if its opcode, QPN and wqe_counter match the oldest
> entry in a shadow FIFO of posted UMR requests, and the completion context
> is then taken from that FIFO. A CQE that fails validation marks the UMR
> path permanently failed, stops polling the CQ and forces the mlx5_core
> health recovery; teardown also stops polling before the UMR QP is
> destroyed.
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
> [Severity: Medium]
> Could this check flag a legitimate UMR error recovery as forgery?
> 
> The sop check also runs on MLX5_CQE_REQ_ERR CQEs, including WR_FLUSH_ERR
> ones, before the syndrome is examined. In the error CQE layout, this byte
> is the top byte of s_wqe_opcode_qpn in struct mlx5_err_cqe.
> 
> Elsewhere in the tree, handle_good_req() reads it only for successful REQ
> CQEs. Nothing reads s_wqe_opcode for error or flush CQEs.
> 
> The device may not report the UMR opcode in flush CQEs for WQEs it never
> executed. Examples are the WQEs queued behind a failed UMR and the
> barrier WR posted by mlx5r_umr_recover().
> 
> In that case, an honest NIC that hits a recoverable error such as
> LOCAL_PROT_ERR would get the UMR path disabled for good, with -EFAULT for
> every later UMR, plus a forced health recovery.
> 
> This depends on hardware behavior that nothing in the tree confirms or
> rules out. Would it be safer to apply the sop check only to MLX5_CQE_REQ,
> and rely on the full wqe_counter match against the shadow FIFO for error
> CQEs?

The PRM defines the send WQE opcode as valid in a requester error CQE, 
flushed WQEs included, so an honest NIC reports the UMR opcode there as 
well.

> 
> [ ... ]
> 
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
> [Severity: Medium]
> What wakes the pending UMR waiters if the forced health work cannot run?
> The commit message says:
> 
>    Recovery moves the device to the internal error state, and the existing
>    flush then completes the pending requests in software and wakes their
>    waiters, so this path does not complete them itself.
> 
> The forced work ends up in mlx5_fw_fatal_reporter_err() in
> drivers/net/ethernet/mellanox/mlx5/core/health.c:
> 
> mlx5_fw_fatal_reporter_err() {
>      ...
> 	mutex_lock(&dev->intf_state_mutex);
> 	if (test_bit(MLX5_DROP_HEALTH_WORK, &health->flags)) {
> 		mlx5_core_err(dev, "health works are not permitted at this stage\n");
> 		mutex_unlock(&dev->intf_state_mutex);
> 		return;
> 	}
>      ...
> }
> 
> Both checks stop it during teardown:
> 
> - remove_one() calls mlx5_drain_health_wq(), which sets
>    MLX5_DROP_HEALTH_WORK, before it calls mlx5_uninit_one().
> 
> - mlx5_uninit_one() and mlx5_unload_one_devl_locked() hold
>    intf_state_mutex while mlx5_unregister_device() or
>    mlx5_detach_device() deletes the mlx5_ib aux device. mlx5r_driver has
>    no .suspend, so the device is always deleted.
> 
> In that window, ib_unregister_device() destroys user MRs, and pooled or
> cacheable mkeys are revoked through UMR:
> 
> mlx5r_handle_mkey_cleanup()
>    mlx5_umr_revoke_mr_with_lock()
>      mlx5r_umr_revoke_mr()
>        mlx5r_umr_post_send_wait()
>          wait_for_completion(&umr_context.done);
> 
> Suppose a forged CQE is detected during this window. The UMR CQ is never
> polled again and the device never enters the internal error state. Is
> anything left that can complete this uninterruptible wait?
> 
> In the intf_state_mutex case, isn't this a deadlock?

The same rare hang can already happen today: a UMR waiter waits for its 
completion or a flush, and a fatal error while unbind runs, after the 
health work is dropped, leaves its WQE unflushed. A forged completion in 
this window reaches the same state, so it is a pre-existing hang, i.e. a 
DoS, which is out of scope of this series.

> 
> [Severity: Critical]
> Can a hostile NIC push the UMR path into an invalid state with error
> CQEs that still pass the shadow FIFO match?
> 
> The CQE is checked against the oldest pending context. Its syndrome is
> then taken at face value, whatever umrc->state is. Two cases look
> reachable by the NIC this patch defends against.
> 
> The first case is a WR_FLUSH_ERR CQE while umrc->state is
> MLX5_UMR_STATE_ACTIVE.

A conforming NIC may flush the UMR QP after an async QP error, without 
an earlier error CQE, so a flush while active is not treated as forged. 
A NIC that keeps flushing the reposts can only hang the caller, i.e. a DoS.

> 
> The second case is a non-flush error for more than one pending WQE.
> Each matching CQE sets MLX5_UMR_STATE_RECOVER and wakes its waiter with
> a non-flush status, so several waiters call mlx5r_umr_recover().
> mlx5r_umr_recover() drops umrc->lock before it posts the barrier WR and
> resets the QP. The recoveries therefore run concurrently, and each one
> posts its own barrier.
> 
> When the first barrier completes, ib_modify_qp(IB_QPS_RESET) reaches
> __mlx5_ib_modify_qp(), which zeroes qp->sq.head, sq.tail, sq.cur_post
> and sq.last_poll. It clears neither umrc->pending nor qp->sq.wqe_head[],
> so the second barrier is still at the head of the shadow FIFO.
> 
> Suppose the NIC now completes that barrier with its old wqe_ctr. The
> uncommitted-WQE check compares a stale wq->wqe_head[idx] with the reset
> wq->head and passes. wq->tail becomes wq->wqe_head[idx] + 1 while
> wq->head is 0.
> 
> A later forged CQE then forces the health recovery. Once the device is
> in the internal error state, mlx5_ib_poll_cq() completes the SQ in
> software. sw_comp() computes wq->head - wq->tail, which has wrapped,
> and walks wq->wrid[]. The entries it dispatches point at
> mlx5r_umr_context structures on the stacks of callers that have
> already returned. mlx5r_umr_done() then writes the status and completes
> the done field in that freed stack memory.
> 
> Should a flush seen in MLX5_UMR_STATE_ACTIVE take the forged_cqe path
> instead? The same question applies to a second non-flush error once the
> state is already MLX5_UMR_STATE_RECOVER.
> 
> Separately, should mlx5r_umr_recover() be serialized? And should the
> shadow FIFO be reset together with the SQ counters on the RESET
> transition?

Right, V1 will accept a non-flush error only while the UMR path is 
active, and treat any further one as forged, so a single recovery runs.

Yishai
