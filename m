Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.67
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794219885;
	b=GCeFLFTleRsGrm8PxpXIJxpDNx96FiM3uWK87kqYit5F/0rRs3sL6dHG2VDgyYc2YkmA
	 MhVpOYUqupB+rLE3fZ6kVI4+dOa7h/EbhP0xh3EWxi9cYsAE8jTtfX0JWfglQIjoyyQzd
	 dcr42B8kEvWV9pIPQIe2Q5g0PFtzfmwakJCTYmEy8ksNDrcQCbdezdXOUxb6Q1ixkaX3L
	 Ptaw421r46lSgzrn4HDoJwc1Sx6pl77pDqtcINaXng8CpQwkBxd2SqAXbowWUTrCWwUXF
	 zqvqr/R8WPPsA76dCKGQ+Gw9l5gLFb81c5UFusBMrCMqLpBO/2mRpcKtYYGgNVkTF1Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794219885;
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
	bh=bryMfTQwPNgIqNUrE9md6TzVVOMrqYqwdtw2wzFWoAw=;
	b=T/ZRlom4LusdgpFzRSDau+ct7+lVUUOfJtGVuvHM74p9F/4dMPuriddu8pH1mp4SRgjx
	 rdYv3bwTQMX4K8JMIa9T5Pa4Ud7E8VIpgB5BjfhVpzEb/WzCzoxIKBT7tWrv/s0GzEP49
	 UOJlTmMdnsP+xPKUDiBrGb3BaaUIwultPqKTBTuAvKD0oC3Z4IEAF0kyXaI291IOSluyB
	 YNQydQT8l4u4LecL917+OuF8Je9gJS4Q3+Xq2XrpxTuwwy3OJ7GFUzbhy6IrCKsCjbKlO
	 FQsAsNdFswfWhnZadMl0BL1dvVqW9/RGfw0JyKhaSNneT3MeG0l/oYflv+U5tFSP1iQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rtcK2Y5S;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.67
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011067.outbound.protection.outlook.com [52.101.57.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74142606A321;
	Mon,  9 Nov 2026 10:24:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74142606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rtcK2Y5S
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OTUdCUfWjrwPaTcZwzCtdZVdtpq0p/YHOnh6szH27abooMv9axfXnMq3f1GdLK52I6JwLsh3W7cjJ0N9axwp+3DEa5KoYJX5GW+B4kkhuOXkLGEezUO8tcDekk0U0SXks6ELzYe0npH5xKk4yTrqTfyUJUzDs/A00pCNTiOwKjsIzQmDgATjypby1rHw8tbaWiqlnSRf3/ctbBB5YtoCYp8B/RluOPt32gwJUca6Qc7qWip/auTyFtdrdw7NXN9M12LLXkmb1kiXHbRi1tPhyybJnhZzg1riNlnrHXyBH8MPz/DVxOumlO7uuGYpp0Ct/4Lg1X9WrgNoYLt5WCKSgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bryMfTQwPNgIqNUrE9md6TzVVOMrqYqwdtw2wzFWoAw=;
 b=G6IoMON2ZX4y7GBcGIz7sAbeC6qoq6JurwbVHONGWm6mWKbA44VfsPMrhsrgZkhOuJc3VH9DXatIwry7uz1p8U8MtqGgh4tWsrZEbr7qcL7j+uudM82OyWQgPSW5J9wEY2QccDHMlwOujIhie+r2TjowbtMVFbCjMvvrW0cEb7bSWk8DqhtFswcVuhfnpv4uFZe0aBiEIDFqyARQ+5wGL7Jh9PKFQYmazbq4F1GpYdyhdtMFjy8jEYb+8mAC7fkQDRaLwovC6gXs/3cUPYWG68oMyCs67Vz6xpeu9P74APPX3bWQCrCD2zKo4YCKYJbTZUVDE/Snh4IAn/ElZy/tmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bryMfTQwPNgIqNUrE9md6TzVVOMrqYqwdtw2wzFWoAw=;
 b=rtcK2Y5SQRSIWW97OvgiR0psCUDnh0eR2XT41rpXA0UXQZL/THZtcJKMqp7XS4UYYJMScTH8oXAH3qfLE7qG1UfjP6glUaBCGW3zHLZ/iTaghKpJ/Z682N744QLCBHa6S8O4VWnm5CqQ4UFZZLlvPFyiHk5tB3ChKR5NItpSZvPO0FiXLXZybSIJ6ElObJI9lqyNOq3Uo1k/0j1NAtVgJnsP7jJz2xx6BTSEhNgIHH5YeYJXSDil4CoaYiWnjYJUldLnR1rpOJaZdgtMPN+VJQ0K08yBKFuLxolICpkmk6ycsoEOrHrSppaClc9yEOclSFUL3PQOaAdOxiG/SyduaQ==
Received: from PH7PR17CA0055.namprd17.prod.outlook.com (2603:10b6:510:325::16)
 by SAEPR12MB231369.namprd12.prod.outlook.com (2603:10b6:802:204::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 10:24:39 +0000
Received: from SJ5PEPF000001C8.namprd05.prod.outlook.com
 (2603:10b6:510:325:cafe::5) by PH7PR17CA0055.outlook.office365.com
 (2603:10b6:510:325::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.13 via Frontend Transport; Mon, 9
 Nov 2026 10:24:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001C8.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Mon, 9 Nov 2026 10:24:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:24:26 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Mon, 9 Nov
 2026 02:24:21 -0800
Message-ID: <a1abb4d5-022b-4ba7-b4f6-56ea4e7fdce2@nvidia.com>
Date: Mon, 9 Nov 2026 12:24:17 +0200
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
Subject: Re: [PATCH rdma-next 18/23] RDMA/mlx5: Validate firmware RQ/SQ state
 before sqrq_trans[] lookup
To: <netdev-bot+sashiko@kernel.org>
CC: <jgg@ziepe.ca>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
	<netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@kernel.org>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<dtatulea@nvidia.com>, <moshe@nvidia.com>, <maorg@nvidia.com>
References: <20261103163949.1554-19-yishaih@nvidia.com>
 <179408310322.994134.9461475387371859568@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <179408310322.994134.9461475387371859568@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C8:EE_|SAEPR12MB231369:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fc1777d-f429-4f3a-2d24-08df3e4ba967
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|23010399003|376014|22082099003|18002099003|6133799003|10067099003|4143699003|11063799006|261028144727099003|261026121527099003|261102123227099003|261022105027099003|56012099006|261021135927099003|261021121427099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	r8UycCjHaoyQ2GjJYPLgpDegS1AO0Hjwquv59LPXJp/RtcnziZa0u2CM3s+ywQSISpGjMP6uLnEZ0VnGK4XPavqXUUaW7+K1j50CWfmVeGLytJ4N45inB3A94JUE+gLifSVo07SfOxx+PNHCbOzDZ9AWG9Rq9hKk8wdDnYOZCbLdRL8harWb2fTeOxBfmX5NT4i1z+nq5fK0LryRN4GleuTR3xXYFmKhxbfe71e5fsJUMhbvpbSZtG4dYduFPBwz9wxpsxYexW04S4N8RJENARCaRSaZk5z6e9F07TKPke0zFf5G8OecgacN8cUhqdsy+g8EwzU4ogRXg7Py6HbmMQeDOqvtJqkhrXrqEJOk8EG8PZZiRzM5foejRR/aWVck6ha9GxIx7BaURBoUGpTbuYtInR4ojGlHPNEf7kq17Rh5I9Q6FXiQN+I5t96tizVEtOEg03L8OZInsF+AjLETt2+WhWiQ2/UtV3aopdS7cOZ7gTeMQ5W4wT9hqTD0spu22hUKts6n6kZY5uilS2PIKxHXjUuAKDMG7sT74d2+NxJKPMXbKkk9jH/N9IRRc6HmiJSN98vqQsTpwUHw/OcDDmY4uiccAlb8xcfaeEqB6vXhmyDaqHS7B+XMhWrdGxOtRgm6yZhy4HOQ32+Ov6V67V5/QPGBz1j9TYCvIe2HhVKVRyAPAFAra+QhXOyzt/gEU3U/bZCLEHwu69jx6kExBw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(23010399003)(376014)(22082099003)(18002099003)(6133799003)(10067099003)(4143699003)(11063799006)(261028144727099003)(261026121527099003)(261102123227099003)(261022105027099003)(56012099006)(261021135927099003)(261021121427099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	L+YA0KqdyPkHVswuFdJA0Nr0+cblR9sW4k/n+jnxBC/xKfMkBkpOO/jTijKVJZAp3I/b/dn6u78nBKyoLusD4Y0eqHR6y9o6ZY4iIOlXgcJSJCtQlzSMxfdtHso6nqZ6HYUMCXQQybdql0bnloIL8AGYLQpTMk+bfy1lhh3HABrGY4T9jAAzoI7hSgspl8ZWeIVjwFwGp+3YA1AqDg77hUnWtb2dzd5SlRY/TQx9LOkOTNhtAhPlXQzX9A32cb/KnRCeWdIDURk5xDEbljtsBSTTtF4Jxm+xJwCTU1xeWIZCmgi/Wy8Rdw18+WLzoow8zobLhtGo2r4seRlCb67aL7h2HcTE9aXYOmpc+zhCvuC1pn1zNUpJTz/JMfHI0u+MtbdTeYInOnklcfgs+9OKFmWdsH4hD+Vos1LhO2DolBYdgRrn+qxNJRIm+Ahvl8gs
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 10:24:39.5352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc1777d-f429-4f3a-2d24-08df3e4ba967
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAEPR12MB231369

On 07/11/2026 22:25, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 0
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The new check in sqrq_state_to_qp_state()
>    (drivers/infiniband/hw/mlx5/qp.c:5084) bounds the firmware SQ/RQ state…
> 
> --
> 
> RDMA/mlx5: Validate firmware RQ/SQ state before sqrq_trans[] lookup
> 
> This commit adds a bounds check to sqrq_state_to_qp_state() in
> drivers/infiniband/hw/mlx5/qp.c. Any SQ or RQ state returned by QUERY_SQ
> or QUERY_RQ that is at or above the sqrq_trans[] table dimension is now
> rejected with -EIO, which prevents an out-of-bounds read of the 5x5
> table.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
>> index 19cbf6b2b979d..05e8e75d734fb 100644
>> --- a/drivers/infiniband/hw/mlx5/qp.c
>> +++ b/drivers/infiniband/hw/mlx5/qp.c
>> @@ -5081,6 +5081,9 @@ static int sqrq_state_to_qp_state(u8 sq_state, u8 rq_state,
>>   		},
>>   	};
>>   
>> +	if (sq_state >= MLX5_SQ_NUM_STATE || rq_state >= MLX5_RQ_NUM_STATE)
>> +		return -EIO;
>> +
>>   	*qp_state = sqrq_trans[rq_state][sq_state];
> 
> [Severity: Medium]
> Should this check compare against the hardware state encodings instead of
> the table size?
> 
> The hardware only defines three values in include/linux/mlx5/mlx5_ifc.h.
> The RQC values are the same:
> 
>      MLX5_SQC_STATE_RST  = 0x0,
>      MLX5_SQC_STATE_RDY  = 0x1,
>      MLX5_SQC_STATE_ERR  = 0x3,
> 
> The table dimension comes from a driver-only sentinel in
> include/linux/mlx5/qp.h:
> 
>      MLX5_SQ_STATE_NA	= MLX5_SQC_STATE_ERR + 1,
>      MLX5_SQ_NUM_STATE	= MLX5_SQ_STATE_NA + 1,
> 
> That means firmware values 2 and 4 still get past the new check.
> 
> query_raw_packet_qp_rq_state() passes the raw 4-bit field through
> unchanged, and mlx5_core_query_sq_state() does the same for the SQ:
> 
>      *rq_state = MLX5_GET(rqc, rqc, state);
> 
> query_raw_packet_qp_state() sets the NA sentinel by default and only
> overwrites it for queues that exist:
> 
>      u8 sq_state = MLX5_SQ_STATE_NA;
>      u8 rq_state = MLX5_RQ_STATE_NA;
> 
>      if (qp->sq.wqe_cnt) {
>          err = query_raw_packet_qp_sq_state(dev, sq, &sq_state);
>      ...
> 
> Take an SQ-only raw packet QP where firmware returns SQ state 4. Doesn't
> that value alias MLX5_SQ_STATE_NA and land on sqrq_trans[NA][NA]?
> 
>      [MLX5_SQ_STATE_NA]	= MLX5_QP_STATE_BAD,
> 
> That entry reaches WARN(1, "Buggy Raw Packet QP state, ...") through
> ib_query_qp()->mlx5_ib_query_qp()->query_raw_packet_qp_state(). A legal
> SQ value on that QP always maps to MLX5_QP_STATE. The RQ-only case with
> RQ state 4 behaves the same way.
> 
> Value 2 indexes a row or column that is never initialized, so it reads
> as 0, which is IB_QPS_RESET. Would ib_query_qp() then report RESET with
> no error and no WARN? On an SQ-only QP, any legal value would have
> returned qp->state.
> 
> On a panic_on_warn system, a device-triggered WARN here becomes a panic.
> 
> Would it close this gap to accept only the RST, RDY and ERR encodings,
> and only for the queues that were actually queried?
> 
>>   
>>   	if (*qp_state == MLX5_QP_STATE_BAD) {
> 

No. This patch prevents the out of bounds read. The values left inside
the table can only give a wrong QP state or the existing WARN, which the 
NIC can also reach with legal encodings, e.g. an RQ in RST with an SQ in 
RDY.

Yishai
