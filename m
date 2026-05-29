Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9514312F585
	for <linux-rdma@vger.kernel.org>; Fri, 29 May 2026 02:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780021003; cv=none; b=AE6vEys75c/A/IZd//7JH7/Qs4YP/I79I4ict+nasypvhssYs1JYkHXYF76q0yvyc8b+r/FHOok+MPeu6stmakYaGSvotDrlpIq5GrEzjAk93Cqjg7sxI2uLB5x9SM64HUvt9hmd5UvxcLHxoOX/Fmkm9VSIiAs4HGBVIF73ppk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780021003; c=relaxed/simple;
	bh=GvTSJ7jDxcWV0fzfxb7OFwYDM5SHmB6SErkH6xvLplA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=mLQS7KA345UdC4q/u3qWM8XdSsWOvo5QWpbjX9D++wlGuaIgJEEt67keZNQJr8jlb493x/WREvGjH+p5c/j9o9uZY9RwrwYThCRZksnkHShaEhj13R/RP7aNf5YEk03aIVuUREKCPUE+Ih5x2cDumQiqNNvoxkexALRs9eYxlwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Su2PKpNM; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Su2PKpNM"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780020997; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=v1ocmTGmgoZy30Eimm1HaXE/hJ4GypwwY7oVKee9Qbw=;
	b=Su2PKpNME2q7QjqQknqGHji0yBSpfeP9TJ/LMaVJzSG9EQLTH3eVqVqMRM+l70o09GpGaKwkVpdN0R6hYicvypG8V3c/S4MC15xPicsmKH4cODvoaDxUflV59jiJAlYZRKcOD9G/mW76SDJ0zWR0bFjCvS89LV0LJR/TLrQOQjk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=boshiyu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X3nxGhC_1780020995;
Received: from 30.221.149.52(mailfrom:boshiyu@linux.alibaba.com fp:SMTPD_---0X3nxGhC_1780020995 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 29 May 2026 10:16:36 +0800
Message-ID: <ad4b6678-ae4b-4320-9b5b-e01516322735@linux.alibaba.com>
Date: Fri, 29 May 2026 10:16:34 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v2 3/3] RDMA/erdma: Implement
 erdma_reg_user_mr_dmabuf
To: Jason Gunthorpe <jgg@nvidia.com>
References: <20260518120637.16831-1-boshiyu@linux.alibaba.com>
 <20260518120637.16831-4-boshiyu@linux.alibaba.com>
 <20260525163708.GA2504127@nvidia.com>
From: Boshi Yu <boshiyu@linux.alibaba.com>
Cc: Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
 chengyou@linux.alibaba.com, kaishen@linux.alibaba.com
In-Reply-To: <20260525163708.GA2504127@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2026/5/26 00:37, Jason Gunthorpe wrote:
> On Mon, May 18, 2026 at 08:06:28PM +0800, Boshi Yu wrote:
>> +	if (attr->flags & ERDMA_MEM_FLAG_DMABUF) {
>> +		umem_dmabuf = ib_umem_dmabuf_get_pinned(&dev->ibdev,
>> +							attr->start, attr->len,
>> +							attr->fd, attr->access);
>> +		if (IS_ERR(umem_dmabuf)) {
> 
> I don't want to see new MR implementations that use the get_pinned
> interface.
> 
> Please implement the revoked interface Jacob added:
> 
> commit ff85a2ebacbdaec9f28c4660c991295ace93cd1c
> Author: Jacob Moroni <jmoroni@google.com>
> Date:   Thu Mar 5 17:08:24 2026 +0000
> 
>      RDMA/umem: Add pinned revocable dmabuf import interface
>      
>      Added an interface for importing a pinned but revocable dmabuf.
>      This interface can be used by drivers that are capable of revocation
>      so that they can import dmabufs from exporters that may require it,
>      such as VFIO.
> 
> 
> Any IBTA compliant device should be implement revoke at least through
> regreg_mr.
> 
> Jason

Hi, Jason

Thanks for your suggestion. I’ll use ib_umem_dmabuf_get_pinned_revocable 
instead of ib_umem_dmabuf_get_pinned in the next version.

Thanks,
Boshi Yu
