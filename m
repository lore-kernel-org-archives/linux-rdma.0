Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.58
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794146003;
	b=XKhTzFTgbZlZT+B5N/Y8pTQYDwWEEJlztmx9FEoRWQ+UPsQQHE7IHpOv2/23I+mnxhfq
	 4LndL0dEdo+/xDzg3A+Aq/WeJU1bjX2M3XkgdzA+UuH2iVdiW4GI964JhqJaY7rh8fF6J
	 K9LC6CzMYHdVfFt84IJSwiNAcTMcxb5xXFzNKW8VfpHbWwZkjnEPx3P8XJmRzaeFmvkAP
	 Hs77tprZGkCbtQbQdfTAQgQHxhDQfVpxR7jjuxrW+zvBfJFJ183EZ2KIngdU/GdbbpjDh
	 iOtT6h+iOQHnOxkCPmBozlHiUxAvpjoRx5winkQTtNC6pP7UK3KPB+XYnOD2xzX8PWw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794146003;
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
	bh=IT0LsEBGJsz7Max2udcCJ0n3pnpA0TPZ0NmC91iMZ00=;
	b=gkdS7LKY3i68GaiReCGEO3N+sRjGpbRovAM3/EZPZE8Z2LF04gU7MA2wRVIIfeFOZrFz
	 3gPbPRjOrxfdA4DbLs9FPgItQetQTLXKoQnD3/9czam6nq73MRvJwqvvRELbCFS7Se1mv
	 nQOh/Ih1xjO5AzsAgjMWXyzxBBVpMTroSbL5L/a7ghuMoUJwpUQSrcg5rwlPo6/4B+y2b
	 1F5Jidrlpy3BFbDrZkN67kcviPL8n/8ytGqNLrWACJFwibCN89cF3UlPa4pFeX46pnHGe
	 6ASM5mOx4u7cM68M0e99HnK7wB0n8uWP/D4HXN4n6110tmrPECtsusMfqt9cp+3EREg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GR0RnZqu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.58
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010058.outbound.protection.outlook.com [40.93.198.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7F1606A31C
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 13:53:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB7F1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=GR0RnZqu
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CNhE8BIV/NnGWlGfLuMOJ0OK+utVXUPBmRI1q19uMi/N6SQpv/xmSrEK89jJQ3PjAwpCTTDDo+HcQP5pAQsNvq3ogcgHdCoWH596F+kG/YL4T3sBItmA3GDGy4Fl57zhSoFn+6jQ6EI1Qp869FtZAexZZ/tnSNE6wl9pJmj4K4kesE/a/7i2DK7ofBNKMgiLKbkcWMTDVlZcqzTXg7k3Eig9zCTNkp5i4A3P7x0YWoYPUeVyQD4k64w2WTCgolSiwhkKcmilO7X5vYeS2bekSNSLQh1qJu4LR1vP5LGhNC7jAl4HP3VppaGnUuh7cfaa2JSKNzmCmzf7v7nSp8jlYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IT0LsEBGJsz7Max2udcCJ0n3pnpA0TPZ0NmC91iMZ00=;
 b=WVBx4lB5k/zJ1MTSAFgoInHNFvWXfM9sJBgSzpLbOEIRcfrRMVpUrPk2/oaxiRz9zgwqbEWkrZwJ9vHcrVnNUCdWsS/GOlgKuLXagR6/tCbRSMz0LBC/jVSl8XfraHAkGZlEjWlEfsywRfB2wJUVIGyaCIBzq8gXZuEjJWaC1oG+hVZttTyCesAVF8KEh42VFV7gnJmEiTE7+tMyC6K57e3xfLeTDO1wXBeBzip2xbGbBOWmuqWm9CN9hxeeNF10WAj8hCTu3tvQLFvVUjSXk1mBXoDFEj0nJAG/jVeo1feJgTu3kKv/y2UXpnl5Ht0yABnM7IGxOFrM6aCRBhv8Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IT0LsEBGJsz7Max2udcCJ0n3pnpA0TPZ0NmC91iMZ00=;
 b=GR0RnZquVAV+mvAfx/Ou7KaDh80jRHNEzNkTtj0H8k+KtGGf2kXCqHyKwCPuecqkIU/XVJ8lGkqwX/fx8ozRF6zSzS5161DzrrwO6+ZkmVatdgV8oL8T1gUdC6dPq0hms3p5glwSUV+KGbWuiQSH9xdg4ouhvgA4dhjsk1mab/dp0V98SmdWWqMEWQIlpaYmJQEfYtKfYULN4hW+do+tOxPx6H6N/Ui1sWrXbpBFHJ8XWi6E/wuKn/D7Nno++FfBKvV+pWKOCUioSUPj+nX731Uh3lmE8WdyfD8FK5eL5Sc20f+ddxusw+7DMT+ZhbtEFvD5gRcChauCfdMknVIaaw==
Received: from DS1P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:44c::8) by
 CH3PR12MB7715.namprd12.prod.outlook.com (2603:10b6:610:151::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Sun, 8 Nov
 2026 13:53:18 +0000
Received: from DM3PEPF000265C3.namprd03.prod.outlook.com
 (2603:10b6:8:44c:cafe::21) by DS1P220CA0018.outlook.office365.com
 (2603:10b6:8:44c::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Sun, 8
 Nov 2026 13:53:18 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM3PEPF000265C3.mail.protection.outlook.com (10.167.23.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sun, 8 Nov 2026 13:53:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 05:53:04 -0800
Received: from [10.125.206.9] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Sun, 8 Nov
 2026 05:53:03 -0800
Message-ID: <201fed6a-e042-4a3a-a4b0-8d8b87183d4d@nvidia.com>
Date: Sun, 8 Nov 2026 15:52:50 +0200
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
Subject: Re: [PATCH rdma-next 19/23] RDMA/mlx5: Clamp log_max_cq_sz shift in
 CQ size checks
To: <sashiko-reviews@lists.linux.dev>
CC: <linux-rdma@vger.kernel.org>
References: <20261103163949.1554-1-yishaih@nvidia.com>
 <20261103163949.1554-20-yishaih@nvidia.com>
 <sashiko-outbox-197672@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <sashiko-outbox-197672@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PEPF000265C3:EE_|CH3PR12MB7715:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b322c9b-cb8f-42a1-5d95-08df3d9fa4b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|23010399003|376014|22082099003|18002099003|10067099003|4143699003|11063799006|261028144727099003|261026121527099003|261022075727099003|261022105027099003|56012099006|261021135927099003|261026140227099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	6VPG5z+cWYoOtNFTNuRCIWi3rGuNnSf/Kbz3hf1S6x6M3AYZk8ffXBuM7R3C85tFvjLtKlYKFb17II0NVHrasprOWDPLF4XSs2lnBE8m4oz8Sy3mlCdxWDLLlHKm5PZ2o2wGffU3oai2/WP8ZQOw/POWDOZHw+pFf3lcb7Q+n/X80WRhq6FYnGO//gdSqPtJ5X4nAfoj/gEIDx4j3VIW4hrrTqPesl/ZEmHnVWDaJBWhV7KGU7tuW9VJ/6sT9IVXi2CZPfa0VXt4qIlxHrGDibRipjm5o0j0I4kUdIDC8C/64aTdWJGwnb4fTPtD2XEDYWA0RspQ6jb3ZJj+maIErZ2mBo28GDhkUHzcikl6GA9p09G2Eiz9QZ52Q2CQn2lz2cckTGZBQQwlKUZBpHoH7yA1ZjC0EbXquz2LmE/9R/YYJM8wpxOZ06YJ8f/gKg7ijvfPpkng8K5q4Fapnek+L9YpQEWEc288mVXi3WbL9aLFVGTV030xctXnHF9/YR6WxCZv2P+MXk4jLFOmqFZHpoMS5t4pHygsebRxJSUf15NCRdBfbl+IqpXSzkVEx+uuCRDMvmMMavKhPfwTmQxpWhw0ezva6/zAF8OJKTfXQ19LQF8wGi8ED8vVclQzxMDf1WMplaQQs3KfELMEcZdeEsZ45Vwz7Ggnf5i8YRauOWA9Z48saJ9SJoizTbVLTFDb5v8PjR2I+H5BOlHd1ZcnHw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(23010399003)(376014)(22082099003)(18002099003)(10067099003)(4143699003)(11063799006)(261028144727099003)(261026121527099003)(261022075727099003)(261022105027099003)(56012099006)(261021135927099003)(261026140227099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Mjg09pACecHl1P5xs99F2FlVb33cB5jstRRFQY4NfNYD8OvQKrCkePWk8PdpWgPAuHBTktEEKCLHbKg9ijmz6T9dWZe/RNqwP2crkUPlYw30ymhxO5U6IKNclhuaXCNFijL/RLVNte+jIOs5/yeOxuauI0Py5lm13A1AxmmaYF1jUJmhHsKmmnf3Q80fUvjQ8vBgkapSs9JKWIdLNM+wSvLySxuQOmHdjbN8/C9Ia12mgSR1AiPPPo+dOHplxh/VV5KxvTGUHDEESRFeHSa20cL7DJua4InIfN1sqz7onHd8jPef+a6YNcthmkVFmmQX+bpG+wNyZNWEhwmBvHlHJAXGyR98yBsSdi2dwZOKsQsUQBUt2Q6rWaXenDGd9d3v1jzNP1PgMvNl2WJ3t74kpulfFuODzBTW1oXY+vzPX8mD8ppwAiAQqMFgRMfvJ5BC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 13:53:18.1132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b322c9b-cb8f-42a1-5d95-08df3d9fa4b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM3PEPF000265C3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7715

On 04/11/2026 18:43, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] RDMA/mlx5: 32-bit entries * cqe_size overflow in CQ create and resize
> --
> 
> commit 23d4d478ec288a1c091e2edf580c64eccf4e7c49
> Author: Yishai Hadas <yishaih@nvidia.com>
> 
> RDMA/mlx5: Clamp log_max_cq_sz shift in CQ size checks
> 
> This commit replaces the 32-bit shift of log_max_cq_sz with
> MLX5_CAP_GEN_LOGSZ_U64(), rounds up the requested CQ entry count using 64-bit
> arithmetic, and rejects rounded-up entry counts above INT_MAX in the CQ create
> and resize paths.
> 
>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>> index f955eb762051d..25344dfba1c12 100644
>> --- a/drivers/infiniband/hw/mlx5/cq.c
>> +++ b/drivers/infiniband/hw/mlx5/cq.c
>> @@ -1117,6 +1117,15 @@ static void notify_soft_wc_handler(struct work_struct *work)
>>   	cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
>>   }
>>   
>> +/*
>> + * Next power of 2 above entries. It can be 2^32, which doesn't fit the
>> + * unsigned long of roundup_pow_of_two() on 32-bit archs.
>> + */
>> +static u64 cq_roundup_entries(u64 entries)
>> +{
>> +	return 1ULL << fls64(entries);
>> +}
>> +
>>   int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
>>   			   const struct ib_cq_init_attr *attr,
>>   			   struct uverbs_attr_bundle *attrs)
>> @@ -1124,7 +1133,7 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
>>   	struct ib_udata *udata = &attrs->driver_udata;
>>   	struct ib_device *ibdev = ibcq->device;
>>   	struct mlx5_ib_create_cq_resp uresp = {};
>> -	int entries = attr->cqe;
>> +	u64 entries = attr->cqe;
>>   	int vector = attr->comp_vector;
>>   	struct mlx5_ib_dev *dev = to_mdev(ibdev);
>>   	struct mlx5_ib_cq *cq = to_mcq(ibcq);
>> @@ -1136,15 +1145,17 @@ int mlx5_ib_create_user_cq(struct ib_cq *ibcq,
>>   	int cqe_size;
>>   	int eqn;
>>   	int err;
>> +	u64 max_cq_entries = MLX5_CAP_GEN_LOGSZ_U64(dev->mdev, log_max_cq_sz);
>>   
>> -	if (attr->cqe > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
>> +	if (attr->cqe > max_cq_entries)
>>   		return -EINVAL;
>>   
>>   	if (check_cq_create_flags(attr->flags))
>>   		return -EOPNOTSUPP;
>>   
>> -	entries = roundup_pow_of_two(entries + 1);
>> -	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
>> +	entries = cq_roundup_entries(entries);
>> +	/* cq->ibcq.cqe and create_cq_user() take an int */
>> +	if (entries > max_cq_entries || entries > INT_MAX)
>>   		return -EINVAL;
>>   
>>   	cq->ibcq.cqe = entries - 1;
>> @@ -1214,7 +1225,7 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>>   		      struct uverbs_attr_bundle *attrs)
>>   {
>>   	struct ib_device *ibdev = ibcq->device;
>> -	int entries = attr->cqe;
>> +	u64 entries = attr->cqe;
>>   	int vector = attr->comp_vector;
>>   	struct mlx5_ib_dev *dev = to_mdev(ibdev);
>>   	struct mlx5_ib_cq *cq = to_mcq(ibcq);
>> @@ -1226,12 +1237,14 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
>>   	int cqe_size;
>>   	int eqn;
>>   	int err;
>> +	u64 max_cq_entries = MLX5_CAP_GEN_LOGSZ_U64(dev->mdev, log_max_cq_sz);
>>   
>> -	if (attr->cqe > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
>> +	if (attr->cqe > max_cq_entries)
>>   		return -EINVAL;
>>   
>> -	entries = roundup_pow_of_two(entries + 1);
>> -	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
>> +	entries = cq_roundup_entries(entries);
>> +	/* cq->ibcq.cqe and create_cq_kernel() take an int */
>> +	if (entries > max_cq_entries || entries > INT_MAX)
>>   		return -EINVAL;
>>   
>>   	cq->ibcq.cqe = entries - 1;
>> @@ -1532,18 +1545,22 @@ int mlx5_ib_resize_cq(struct ib_cq *ibcq, unsigned int entries,
>>   	int inlen;
>>   	int cqe_size;
>>   	unsigned long flags;
>> +	u64 entries64 = entries;
>> +	u64 max_cq_entries = MLX5_CAP_GEN_LOGSZ_U64(dev->mdev, log_max_cq_sz);
>>   
>>   	if (!MLX5_CAP_GEN(dev->mdev, cq_resize)) {
>>   		pr_info("Firmware does not support resize CQ\n");
>>   		return -ENOSYS;
>>   	}
>>   
>> -	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)))
>> +	if (entries64 > max_cq_entries)
>>   		return -EINVAL;
>>   
>> -	entries = roundup_pow_of_two(entries + 1);
>> -	if (entries > (1 << MLX5_CAP_GEN(dev->mdev, log_max_cq_sz)) + 1)
>> +	entries64 = cq_roundup_entries(entries64);
>> +	/* resize_user() and resize_kernel() take an int */
>> +	if (entries64 > max_cq_entries + 1 || entries64 > INT_MAX)
>>   		return -EINVAL;
>> +	entries = entries64;
> 
> [Severity: High]
> When an untrusted NIC reports log_max_cq_sz >= 24, bounding the rounded-up
> entry count only by INT_MAX allows power-of-two values of entries from 2^24
> up to 2^30 to reach the downstream buffer size calculations. Can those 32-bit
> multiplications by cqe_size still overflow?
> 
> In mlx5_ib_create_user_cq() -> create_cq_user(), entries (int) is multiplied
> by ucmd.cqe_size (__u32, validated as 64 or 128) in 32-bit unsigned
> arithmetic before widening to size_t:
> 
> drivers/infiniband/hw/mlx5/cq.c:create_cq_user() {
> 	...
> 	cq->buf.umem = ib_umem_get_cq_buf_or_va(&dev->ib_dev, attrs,
> 						ucmd.buf_addr,
> 						entries * ucmd.cqe_size,
> 						IB_ACCESS_LOCAL_WRITE);
> 	...
> }
> 
> For entries in 2^25..2^30 with ucmd.cqe_size == 128 (or 2^26..2^30 with
> ucmd.cqe_size == 64), entries * ucmd.cqe_size wraps to 0, which lets a
> 1-page user buffer pass the min_size check in ib_umem_get_desc_check() while
> programming log_cq_size = 25..30 in the CQ context.
> 
> Similarly, in mlx5_ib_create_cq() -> create_cq_kernel() ->
> alloc_cq_frag_buf() and mlx5_ib_resize_cq() -> resize_kernel() ->
> alloc_cq_frag_buf(), nent * cqe_size is evaluated as a signed 32-bit int and
> passed as int size to mlx5_frag_buf_alloc_node():
> 
> drivers/infiniband/hw/mlx5/cq.c:alloc_cq_frag_buf() {
> 	...
> 	err = mlx5_frag_buf_alloc_node(dev->mdev,
> 				       nent * cqe_size,
> 				       frag_buf,
> 				       dev->mdev->priv.numa_node);
> 	...
> }
> 
> For nent == 2^24 (with cqe_size == 128) or nent == 2^25 (with cqe_size == 64),
> nent * cqe_size overflows to INT_MIN, and for nent >= 2^25 (cqe_size == 128)
> or nent >= 2^26 (cqe_size == 64), it wraps to 0. When size is 0,
> mlx5_frag_buf_alloc_node() sets frag_buf->frags = ZERO_SIZE_PTR and returns 0,
> and init_cq_frag_buf() then dereferences ZERO_SIZE_PTR when iterating over
> buf->nent:
> 
> drivers/infiniband/hw/mlx5/cq.c:init_cq_frag_buf() {
> 	for (i = 0; i < buf->nent; i++) {
> 		cqe = mlx5_frag_buf_get_wqe(&buf->fbc, i);
> 		cqe64 = buf->cqe_size == 64 ? cqe : cqe + 64;
> 		cqe64->op_own = MLX5_CQE_INVALID << 4;
> 	}
> }
> 
> Would it make sense to cap entries so that entries * cqe_size cannot overflow
> int (or use check_mul_overflow() in create_cq_user() and alloc_cq_frag_buf())?
> 

Yes, v1 will use check_mul_overflow() in both, with the real CQE size.

Yishai
