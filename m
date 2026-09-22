Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010050.outbound.protection.outlook.com [52.101.201.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564FB3C9EF0
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 07:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061953; cv=fail; b=CBRez6wwuuEt0bPv9csenzFKoa2kfFGhiO8U5LKkI6R0Jrzkfd+iLW+dGAYxkVIrDcIwrpICNOLZm6yZ2HKExIk/8QWBwzswNKHfRiVdrgMKK8LXM6dh96m5rdlwPCM8Q5zRQZuzeEx4Jl9ShB2V0Pbq083e2wjaDFG8K4D5i7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061953; c=relaxed/simple;
	bh=ZzQymBv6+ND1/VCCeRgv4hOHRz0sDpRcoQUtM1GZ/ik=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Ggn+WEUwYqh5uPU/mLMviiLmDUuF024Z7wzbnFFNJrDWKeVE4Gtj9XOqvBDySXqNeiSx/QV8mhgrig00Q5XjGcZRG4+/phNNOSNhdV47GbvYMYgJ6IEjstk43uCKn3/YMNKh9T8Hk5uCplDRCA6r2Q0Dqd6XPken+cK4swVcp/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lYUhfnUM; arc=fail smtp.client-ip=52.101.201.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lYUhfnUM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SbSZIuvPpRby+QbaV8Pm8P6v73oW/hBbVyxqmVXneynFWzHcvenN/k+T4c6XywSXMkVjblR1PJ/Hz10XkkhEfQsEfU/TnyNnzwuIDRp+OVBZe4053BzZdlHuLF3XuCY5Mbc8hKmaHoau7Fvc0PLb5e/goNNxwiIL4puaDYpB98TOlKc4UlhYX2mmmISrPsg5StnhK98pxAd+I7bIR1v85Gj01w6rfii8u+5i0//Jtdy15JwXxiLITir2NgGuRdUGY9bXCtUOifaMX5XjKdrVULMBOxe2r76qKs6JxdwEqIqcTKH5cnQ8cVyrCpdpIUxJ11XSZR3qO2ZwDGLW7BElZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7+y/SXm7En2z/2Xf43u9mfI98ZuTVFWO93RE1Z1scE=;
 b=doDan9LyYo+sF/R+hhcnxvbY/snVBDy7n9JLGPeEy2TWfkcNTuIkISXmsAA4rKg3NnCIawLqEJyRGqy5vz6xH0TRoIzI2ByY+EpEa1X/HzB1c8oal3GNH9lNsGPPvcuxqCj1PG9lJyMSbG/aVQRhWVPPMaKS7drhExp3VmACiIhJeAS3yUqxM+wZ5GrW5DULDWLwUe6Xu/z9W3FExwxA8SbO1PgT5H9Bpl7gAnU/mOY/WCyAKRIglymagIJTkCO7X1XjTYhR99kFOw/ao4ttTmUSJCvidBpvLtOmFrNdoK1LbA8WmaybF/+F456cn0lO2WnuWC2qBZQ2yd7rAs+Syg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7+y/SXm7En2z/2Xf43u9mfI98ZuTVFWO93RE1Z1scE=;
 b=lYUhfnUMKqVnF7Fe5vDSDgnJ4UdVBybHQ99PiBPM3CGI33ocCmjdaM49lh/kEJi1lx7eer3eLcG7Cp8El76JDSAR8yfRpx5MmdTjaCFdvkJLZfAO0ppN5KP23RJC9auFoDtyuxQTbwIr/CWIl2kfH2mqRqWrWQS2ZHONvkIT11jbEbaAVo9yaOI4+zqu00PfoC3FVngM4CGyD6T6NAXKcJmhwN6G/3ttEZ5I4wb1Ahn46NVjiHVMHvb91qhoYtymHX60CWkKKr2VKFP0F1kbBb8ssbXhL/VncOf5Kl+D9vGr3deiYslgA/VscdsKjSdW2L0uKzGQV5JI9bo82RgSug==
Received: from BLAPR03CA0001.namprd03.prod.outlook.com (2603:10b6:208:32b::6)
 by IA1PR12MB6043.namprd12.prod.outlook.com (2603:10b6:208:3d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.13; Tue, 22 Sep
 2026 07:25:47 +0000
Received: from BN1PEPF00018070.namprd04.prod.outlook.com
 (2603:10b6:208:32b:cafe::19) by BLAPR03CA0001.outlook.office365.com
 (2603:10b6:208:32b::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.16 via Frontend Transport; Tue,
 22 Sep 2026 07:25:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00018070.mail.protection.outlook.com (10.167.245.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Tue, 22 Sep 2026 07:25:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 00:25:27 -0700
Received: from [10.125.200.122] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 22 Sep
 2026 00:25:23 -0700
Message-ID: <1a4c6d73-ba48-4fb2-9a7a-9b5521d62203@nvidia.com>
Date: Tue, 22 Sep 2026 10:25:21 +0300
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 rdma-next 04/15] RDMA/umem: Reuse
 ib_umem_get_cq_buf_or_va() for VA-only CQ pinning
To: Leon Romanovsky <leon@kernel.org>
CC: <jgg@ziepe.ca>, <linux-rdma@vger.kernel.org>,
	<selvin.xavier@broadcom.com>, <kalesh-anakkur.purayil@broadcom.com>,
	<chengyou@linux.alibaba.com>, <kaishen@linux.alibaba.com>,
	<tangchengchang@huawei.com>, <huangjunxian6@hisilicon.com>,
	<abhijit.gangurde@amd.com>, <allen.hubbe@amd.com>, <longli@microsoft.com>,
	<kotaranov@microsoft.com>, <mkalderon@marvell.com>,
	<bryan-bt.tan@broadcom.com>, <vishnu.dasa@broadcom.com>, <maorg@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-5-yishaih@nvidia.com> <20260920122411.GB563127@unreal>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20260920122411.GB563127@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00018070:EE_|IA1PR12MB6043:EE_
X-MS-Office365-Filtering-Correlation-Id: a6848f47-90c2-4a78-6366-08df187ab872
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|82310400026|36860700016|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ojHLuKbih9n4HWLzLc6s9S5e/0gPLeeXFi/ahxesI18hIx9zANhli+QuiXon4RFixAzgniLHbipVmTgymGsHSwb7V1f/91q3owslVZeODDUpEHumrhu27c3x3Yytycl8x2oPHSAU/J4MhDZyhnZ86rTndIal8AsXZalh+9UvJnAI31+L+Wz2DGUa6SQvMVdI0tWUL8XrbWitI6lAtOyHhwMF8zDAUEgUAjLzu+iX7WhlwD2oqVnzx3WnKawi1s7K82Y2EuT62ymKC6LecrR9KyjuszyGO0s7ed1v3+W9X/ZK8zwOoRl/zKhNjgBYQaDAvYwrdO5hgpCfYRgESbgY5f3gUEbMG6PAGzGKn3JWEiGJNAZqq3g3Mp6QNoR6H4ZGE0GXYEq0u8ZrTlI2YO9QvX3fnDxY/QUHh5hE+52aeLpgA9egvtNSP5xOEFOgQOtd8yg9fKUa+B9bpLnvACxF+ZBlhlQyXUmjPI4VGohlCb2LTwCoFjlScyTdlKR3JYz7KaWpGnUt87u4FoVM3GBBPC49oqBPQNZ+otaBugiyoOho2pEEIWOBs/fXqxMXvVDQToUC2ON1SDZamd6KKg6sCV1Xh8lIW2C1qJ4sfdunEieeiij1JeDpO0jRIdEfNMlODJk3ive0R+uo1Gy7Cx9AAQAIE+NL1oxnVCh2SnfhMU1mtlcEiOBVEY2a6mVUcaE3ag9pHb+B8yzr2DacKAQmUw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oD9Zp3iinKPWbchGWfLZFWaYFo1uADb00dIJFHJFjjAGN5UNTIpyH3D14BKhbt9JqdYwNmfaxceuLV8rsJW5tPDR15CSN8tbGLIqrPxgH8RgUF8ehspq1C130wky1NBPbtpFIq8GQSfFRUdPN3R///w21/XZjZ/LVpIsij8UY7tInFQKsQ68jkjEer5LZDQEfy8FvflgApwnU/u2AHT3LAk3HfYICyfIpwnqErtn4k9LRJKumRftu/gHxgsw0NJzaPaabBdAy5neSny6deO1MUJ5TOnHUqA0cUSSjXgosaOkkpJsZEJTY1ueGOHqU0DOg/Xxdjl5XiKPB7X2+8SeP9G4K41usvWeYkxvos3flYY4bVR0Kmy4bWmbOnQJ6aLTPvhWTkVRFEBiPJfmapgby9Rm1lKmOcXWg5vFHt8Hogp2nh+wSLRVeJYjXtU9ISKu
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 07:25:46.7590
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a6848f47-90c2-4a78-6366-08df187ab872
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018070.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6043

On 20/09/2026 15:24, Leon Romanovsky wrote:
> On Tue, Sep 15, 2026 at 05:09:22PM +0300, Yishai Hadas wrote:
>> Several drivers pin their CQ ring buffer via ib_umem_get_va() rather
>> than the CQ-specific helper. Switch them to ib_umem_get_cq_buf_or_va()
>> so the subsequent DMA_FROM_DEVICE change covers all CQ paths at once.
>>
>> For shared helpers used by both CQ and non-CQ callers (qedr, mana,
>> erdma, hns) a new is_cq parameter selects the appropriate pinning
>> function; non-CQ callers pass false.
>>
>> vmw_pvrdma's CQ is excluded: it embeds a ring-state header that the
>> driver CPU-writes after polling, making it genuinely bidirectional.
>>
>> This is a pure refactor with no functional change.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  9 ++++----
>>   drivers/infiniband/hw/erdma/erdma_verbs.c     | 17 +++++++++-----
>>   drivers/infiniband/hw/hns/hns_roce_cq.c       |  2 +-
>>   drivers/infiniband/hw/hns/hns_roce_device.h   |  2 +-
>>   drivers/infiniband/hw/hns/hns_roce_hw_v2.c    |  2 +-
>>   drivers/infiniband/hw/hns/hns_roce_mr.c       | 22 +++++++++++++-----
>>   drivers/infiniband/hw/hns/hns_roce_qp.c       |  2 +-
>>   drivers/infiniband/hw/hns/hns_roce_srq.c      |  4 ++--
>>   .../infiniband/hw/ionic/ionic_controlpath.c   |  5 ++--
>>   drivers/infiniband/hw/mana/cq.c               |  2 +-
>>   drivers/infiniband/hw/mana/main.c             |  9 ++++++--
>>   drivers/infiniband/hw/mana/mana_ib.h          |  2 +-
>>   drivers/infiniband/hw/mana/qp.c               |  9 ++++----
>>   drivers/infiniband/hw/mana/wq.c               |  3 ++-
>>   drivers/infiniband/hw/mlx4/cq.c               | 14 ++++++-----
>>   drivers/infiniband/hw/mlx5/cq.c               |  6 ++---
>>   drivers/infiniband/hw/qedr/verbs.c            | 23 +++++++++++++------
>>   17 files changed, 84 insertions(+), 49 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> index ef08d42f377e..7f9aa3620abb 100644
>> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
>> @@ -3749,12 +3749,13 @@ int bnxt_re_resize_cq(struct ib_cq *ibcq, unsigned int cqe,
>>   	if (rc)
>>   		goto fail;
>>   
>> -	cq->resize_umem = ib_umem_get_va(&rdev->ibdev, req.cq_va,
>> -					 entries * sizeof(struct cq_base),
>> -					 IB_ACCESS_LOCAL_WRITE);
>> +	cq->resize_umem = ib_umem_get_cq_buf_or_va(&rdev->ibdev, NULL,
>> +						   req.cq_va,
>> +						   entries * sizeof(struct cq_base),
>> +						   IB_ACCESS_LOCAL_WRITE);
> 
> 
> <...>
> 
>> index fca2553e47ad..3519b5044e8f 100644
>> --- a/drivers/infiniband/hw/erdma/erdma_verbs.c
>> +++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
>> @@ -828,11 +828,16 @@ static void erdma_destroy_mtt(struct erdma_dev *dev, struct erdma_mtt *mtt)
>>   
>>   static int get_mtt_entries(struct erdma_dev *dev, struct erdma_mem *mem,
>>   			   u64 start, u64 len, int access, u64 virt,
>> -			   unsigned long req_page_size, bool force_continuous)
>> +			   unsigned long req_page_size, bool force_continuous,
>> +			   bool is_cq)
>>   {
>>   	int ret = 0;
>>   
>> -	mem->umem = ib_umem_get_va(&dev->ibdev, start, len, access);
>> +	if (is_cq)
>> +		mem->umem = ib_umem_get_cq_buf_or_va(&dev->ibdev, NULL, start,
>> +						     len, access);
>> +	else
>> +		mem->umem = ib_umem_get_va(&dev->ibdev, start, len, access);
> 
> Sorry, but this patch doesn't look right to me.
> 
> In bnxt_re_resize_cq(), you chose to move away from the ib_umem_get_va()
> API, but here you still keep that API because most of its callers are not
> CQs. Why is it so important to specify the direction for CQs while QPs
> and MRs are left without it?
> 

For CQs, IB_ACCESS_LOCAL_WRITE isn't describing who writes the memory — 
it's there purely so get_user_pages() pins a writable private page 
(FOLL_WRITE), which the NIC needs to DMA-write CQEs into.
The access-flag derivation added later in this series ("RDMA/umem: 
Derive DMA direction from IB access flags"): ib_access_writable(access) 
? DMA_BIDIRECTIONAL : DMA_TO_DEVICE reads that same flag as "this memory 
is written from both sides" and picks DMA_BIDIRECTIONAL. But the actual 
bus traffic is one-way: NIC writes, CPU only reads. That's why CQs need 
an explicit DMA_FROM_DEVICE instead of the derived value — they're the 
one buffer type where the flag used for pinning and the flag used for 
direction don't mean the same thing.

QPs and MRs don't have this mismatch, so the derived value is already 
correct for them:

QPs are pinned with access = 0 because the device never writes into a QP 
ring — WQEs are CPU-written, NIC-read only. FOLL_WRITE matters for 
writers that bypass the page-fault path (DMA writes); ordinary CPU 
writes get a private age via the normal fault/COW mechanism regardless 
of pinning flags. Since the device never writes here, there's no 
DMA-write-into-shared-page hazard to guard against, so access = 0 is 
correct.

MRs are pinned with the actual IB access flags the user requested for 
that region (LOCAL_WRITE, REMOTE_WRITE, etc.) — those flags are the 
permissions granted to the device, so they directly describe its real 
access pattern.

Yishai

> Thanks
> 
>>   	if (IS_ERR(mem->umem)) {
>>   		ret = PTR_ERR(mem->umem);
>>   		mem->umem = NULL;
>> @@ -951,7 +956,7 @@ static int init_user_qp(struct erdma_qp *qp, struct erdma_ucontext *uctx,
>>   
>>   	ret = get_mtt_entries(qp->dev, &qp->user_qp.sq_mem, va,
>>   			      qp->attrs.sq_size << SQEBB_SHIFT, 0, va,
>> -			      (SZ_1M - SZ_4K), true);
>> +			      (SZ_1M - SZ_4K), true, false);
>>   	if (ret)
>>   		return ret;
>>   
>> @@ -960,7 +965,7 @@ static int init_user_qp(struct erdma_qp *qp, struct erdma_ucontext *uctx,
>>   
>>   	ret = get_mtt_entries(qp->dev, &qp->user_qp.rq_mem, va + rq_offset,
>>   			      qp->attrs.rq_size << RQE_SHIFT, 0, va + rq_offset,
>> -			      (SZ_1M - SZ_4K), true);
>> +			      (SZ_1M - SZ_4K), true, false);
>>   	if (ret)
>>   		goto put_sq_mtt;
>>   
>> @@ -1250,7 +1255,7 @@ struct ib_mr *erdma_reg_user_mr(struct ib_pd *ibpd, u64 start, u64 len,
>>   		return ERR_PTR(-ENOMEM);
>>   
>>   	ret = get_mtt_entries(dev, &mr->mem, start, len, access, virt,
>> -			      SZ_2G - SZ_4K, false);
>> +			      SZ_2G - SZ_4K, false, false);
>>   	if (ret)
>>   		goto err_out_free;
>>   
>> @@ -1931,7 +1936,7 @@ static int erdma_init_user_cq(struct erdma_ucontext *ctx, struct erdma_cq *cq,
>>   
>>   	ret = get_mtt_entries(dev, &cq->user_cq.qbuf_mem, ureq->qbuf_va,
>>   			      ureq->qbuf_len, IB_ACCESS_LOCAL_WRITE,
>> -			      ureq->qbuf_va, SZ_64M - SZ_4K, true);
>> +			      ureq->qbuf_va, SZ_64M - SZ_4K, true, true);
>>   	if (ret)
>>   		return ret;
> 
> Thanks

