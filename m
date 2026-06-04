Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E9A407590;
	Thu,  4 Jun 2026 11:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780573959; cv=none; b=VCakU8R02crojhJtKF5bIxVk42++Y3PmnlO28w0gGOMkBZ6DHj8tFnJ9f4YePV7LZ9CirLLFWBL7VFSquX6QwLKDgrxm/8M5B1TZ+J9mkej2b8c3Z66bR/GIwLg4+LlXD0q21YobIMg9snK2taLV0NXvlSvNZdWz68ULQ221bP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780573959; c=relaxed/simple;
	bh=RrmVB/mCZfX1fyWpF6MZnMCjB4n+8IhsSMa/dz75u6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=sVSFlKCp1RpzWxsnGO9O87dHfKJYPq1vxzwH0Sodw9sN8O1yQrHlGiTxP0h5dfHQvK4MWpI5croqrPBH+NCzK8UamZkPuqGkNkAhUfCxQZs4uL1/0e83pQ7lXf7GNfgPSbhZiikby+v0L4TZbF7eh83wJ6/gCTErF0dYl2CwCL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gWN5m3lNTz1cyPx;
	Thu,  4 Jun 2026 19:44:44 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id E41A340563;
	Thu,  4 Jun 2026 19:52:33 +0800 (CST)
Received: from [10.67.120.168] (10.67.120.168) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 4 Jun 2026 19:52:33 +0800
Message-ID: <fb093af7-43fb-b719-145d-49fc79c80483@hisilicon.com>
Date: Thu, 4 Jun 2026 19:52:32 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH for-next 0/3] RDMA/hns: Misc patches
Content-Language: en-US
To: <hginjgerx@163.com>, <hginjgerx@qq.com>
CC: Chengchang Tang <tangchengchang@huawei.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, "open list:HISILICON ROCE
 DRIVER" <linux-rdma@vger.kernel.org>, open list
	<linux-kernel@vger.kernel.org>
References: <20260604114510.2955010-1-hginjgerx@163.com>
From: Junxian Huang <huangjunxian6@hisilicon.com>
In-Reply-To: <20260604114510.2955010-1-hginjgerx@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemf100018.china.huawei.com (7.202.181.17)



On 2026/6/4 19:45, hginjgerx@163.com wrote:
> From: Junxian Huang <huangjunxian6@hisilicon.com>
> 
> This patchset includes changes for RDMA/hns: Misc patches.
> 
> Chengchang Tang (3):
>   RDMA/hns: Fix hung task when drain qp failed.
>   RDMA/hns: Fix missing CQE when UD QP use different SL
>   RDMA/hns: Support setting GSI QP SL
> 
>  drivers/infiniband/hw/hns/hns_roce_debugfs.c | 30 ++++++++++++++++++++
>  drivers/infiniband/hw/hns/hns_roce_debugfs.h |  1 +
>  drivers/infiniband/hw/hns/hns_roce_device.h  |  2 ++
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c   | 23 ++++++++++-----
>  4 files changed, 49 insertions(+), 7 deletions(-)
> 

These patches are still under development and were accidentally sent.
Please ignore them. Sorry for the bother.

Junxian
