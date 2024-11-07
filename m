Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6C62F2D;
	Thu,  7 Nov 2024 01:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730943721; cv=none; b=hgScLN7Um3lhV3eqSVMo8MzpK9g7T8FN+T899Z0jVMjQ21hkPOscybTAenEZDy96DAHldwcqGo4jUb+SD2edLT6VaRz3nA5nt+cSwt5H9Lw1nCG3keFF9httg06J1oGGNUKU6m8nqos4Vic5UQuxNlIFO0BnGMub9e0mN6iUcK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730943721; c=relaxed/simple;
	bh=PrjAHSYNUFy7LOmdNZV+ZZB4eC9hXrGwwKFdK8n08Xg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Ng+M922iO3FR/BaW/mBBBrHVtxH1FDb3z3rpx5rBicclwdCD58tT1J79a867ZLWe1gqcFI4jTGTRWwFab/oylYPPFo7UHaoOx3FVDUliJkCW1vJODUXdlxppOVTD81FD7DZz1vT1PA/3X6UqoXTDz/ph4T+CPYZL6R7BcbDvEzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XkPsr40cRz20rX9;
	Thu,  7 Nov 2024 09:40:48 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 2A7571A0188;
	Thu,  7 Nov 2024 09:41:56 +0800 (CST)
Received: from [10.67.120.168] (10.67.120.168) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 7 Nov 2024 09:41:55 +0800
Message-ID: <c9aaf37b-c6d8-0609-0113-449a635ddfc2@hisilicon.com>
Date: Thu, 7 Nov 2024 09:41:54 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH for-next 0/2] Small optimization for ib_map_mr_sg() and
 ib_map_mr_sg_pi()
Content-Language: en-US
To: Leon Romanovsky <leon@kernel.org>
CC: <dennis.dalessandro@cornelisnetworks.com>, <jgg@ziepe.ca>,
	<linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
	<linux-kernel@vger.kernel.org>, <tangchengchang@huawei.com>
References: <20241105120841.860068-1-huangjunxian6@hisilicon.com>
 <20241106120819.GA5006@unreal>
 <b7dd1cc5-849d-781e-ad08-c5b554900150@hisilicon.com>
 <20241106133646.GE5006@unreal>
From: Junxian Huang <huangjunxian6@hisilicon.com>
In-Reply-To: <20241106133646.GE5006@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemf100018.china.huawei.com (7.202.181.17)



On 2024/11/6 21:36, Leon Romanovsky wrote:
> On Wed, Nov 06, 2024 at 09:12:47PM +0800, Junxian Huang wrote:
>>
>>
>> On 2024/11/6 20:08, Leon Romanovsky wrote:
>>> On Tue, Nov 05, 2024 at 08:08:39PM +0800, Junxian Huang wrote:
>>>> ib_map_mr_sg() and ib_map_mr_sg_pi() allow ULPs to specify NULL as
>>>> the sg_offset/data_sg_offset/meta_sg_offset arguments. Drivers who
>>>> need to derefernce these arguments have to add NULL pointer checks
>>>> to avoid crashing the kernel.
>>>>
>>>> This can be optimized by adding dummy sg_offset pointer to these
>>>> two APIs. When the sg_offset arguments are NULL, pass the pointer
>>>> of dummy to drivers. Drivers can always get a valid pointer, so no
>>>> need to add NULL pointer checks.
>>>>
>>>> Junxian Huang (2):
>>>>   RDMA/core: Add dummy sg_offset pointer for ib_map_mr_sg() and
>>>>     ib_map_mr_sg_pi()
>>>>   RDMA: Delete NULL pointer checks for sg_offset in .map_mr_sg ops
>>>>
>>>>  drivers/infiniband/core/verbs.c         | 12 +++++++++---
>>>>  drivers/infiniband/hw/mlx5/mr.c         | 18 ++++++------------
>>>>  drivers/infiniband/sw/rdmavt/trace_mr.h |  2 +-
>>>>  3 files changed, 16 insertions(+), 16 deletions(-)
>>>
>>> So what does this change give us?
>>> We have same functionality, same number of lines, same everything ...
>>>
>>
>> Actually this is inspired by an hns bug. When ib_map_mr_sg() passes a NULL
>> sg_offset pointer to hns_roce_map_mr_sg(), we dereference this pointer
>> without a NULL check.
>>
>> Of course we can fix it by adding NULL check in hns, but I think this
>> patch may be a better solution since the sg_offset is guaranteed to be
>> a valid pointer. This could benefit future drivers who also want to
>> dereference sg_offset, they won't need to care about NULL checks.
> 
> Let's fix hns please. We are moving away from SG in RDMA.
> 

Sure, thanks

Junxian

>>
>> Junxian
>>
>>> Thanks
>>>
>>>>
>>>> --
>>>> 2.33.0
>>>>
>>>>
