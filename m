Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AF434CDD
	for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 07:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787817088; cv=none; b=pCx83CIA/G6kOaNnTp9PEIL97A5pJarG25NRmZ43db5VPBtHQLBaPimU63/GUgDM1U4pF3mGirJnxoo0XMp0xfcU6ozUBMYBtn73j53tlbCA7XFt/NaPLLfwjcYfhM3cz2o76KBo+xddjHAoexr6MuUvCJR2kUR5cvb2Szau3Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787817088; c=relaxed/simple;
	bh=DERkrRFDHAp7KPRDA7KORB0bSJq1xeW7RwscUwZHPZE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=VBjDtl3QoBoNI7AtNGigZO9SgNQbcMfNylBBa6yBIdIOiT/QniUqY2ncEmZGFHpAXEChxnvM3c0NMdwrm7l3G3F+NcNHzJFZL0UKc6UX3l+Cil+bsXNVZe+hPoHpnZCrYYtspfnfIYMEApgHJ+oQ2dh7rw/ONVv3W7oFbKGNLHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=F0EN2uQ8; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="F0EN2uQ8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787817075; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=hDWiD3v6R8yxfRQVbaNkZa13kptfw1Da2CH7yq1Ui1Y=;
	b=F0EN2uQ8+1XnwCSNfQXH5RGQfYXlMPVr8ajlL+aH//vHfyV2/du92lVxeeV+1iq031VseeueIOMpFPb/zlZThDCMMvTBIHpUlbJ4CY0WQ9un8DKxeuBEl9OPBdkQZRaa/N20844lwRzUXJli5HY9IMtr5ueY76CHHpbO4VL9C4E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X9iwHbm_1787817074;
Received: from 30.221.104.67(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0X9iwHbm_1787817074 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Aug 2026 15:51:15 +0800
Message-ID: <450d60e7-025e-4930-e6bc-6cb9d4c55448@linux.alibaba.com>
Date: Thu, 27 Aug 2026 15:51:14 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH for-next 0/4] RDMA/erdma: Support non-contiguous kernel
 queue buffers
Content-Language: en-US
From: Cheng Xu <chengyou@linux.alibaba.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com
References: <20260825124515.99370-1-chengyou@linux.alibaba.com>
In-Reply-To: <20260825124515.99370-1-chengyou@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 8/25/26 8:45 PM, Cheng Xu wrote:
> Hi,
> 
> This small patchset introduces support for non-contiguous kernel queue
> buffers. Kernel QP and CQ buffers currently use a single coherent DMA
> allocation, which can fail for large queues when memory is fragmented.
> To address this, we allocate page-sized coherent buffers and describe
> them with the existing MTT.
> 
> - #1 adds support for non-contiguous kernel QP buffers.
> - #2 adds support for non-contiguous kernel CQ buffers.
> - #3 unifies userspace and kernel space queue buffer management.
> - #4 moves kernel QP helpers after the shared memory helpers.
> 
> Thanks,
> Cheng Xu
> 
> Cheng Xu (4):
>   RDMA/erdma: Support non-contiguous kernel QP buffers
>   RDMA/erdma: Support non-contiguous kernel CQ buffers
>   RDMA/erdma: Unify userspace and kernel queue buffer management
>   RDMA/erdma: Move kernel QP helpers after memory helpers
> 

Hi,

I found some formatting issues in this patchset. Please ignore it, and I
will send a v2.

Sorry for the noise.

Thanks,
Cheng Xu


>  drivers/infiniband/hw/erdma/erdma_cq.c    |  19 +-
>  drivers/infiniband/hw/erdma/erdma_qp.c    |  38 +-
>  drivers/infiniband/hw/erdma/erdma_verbs.c | 579 +++++++++++++---------
>  drivers/infiniband/hw/erdma/erdma_verbs.h |  64 ++-
>  4 files changed, 420 insertions(+), 280 deletions(-)
> 
