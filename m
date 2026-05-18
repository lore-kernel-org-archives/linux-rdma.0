Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE9C403152
	for <linux-rdma@vger.kernel.org>; Mon, 18 May 2026 12:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779106981; cv=none; b=GR6OaeSKBBSNqjVjUG9N2W4+V13ssE3iVFO41cDsPFGz4ZxTvoDpBXIcIc2cSiMoRSEk4Epf6oiF92DF7XXoArUnsq+GaoT9LrTPOXsCH7gzwa5jwa3k25l8qWekSHPa4ThUEB4IbIVzrL4NhNDSTQFEVRcaM8jBfRfBsqu4hbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779106981; c=relaxed/simple;
	bh=ZPpiEoOHi4UR0O4sGVxYsoYWl16jAuULKjGn3X1wZA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=Q8lsePx7I5DP/GxKoHJUDEC2PvwXtrZC800Ca3tGlFnBfrfYtvgQQva14DL+OQ4rmd1FI3Q9IpWxQQsdhrH+VxWuJ4JbjVeuN7CzSUDeKDZ3uQqiMP98jAR2JsK5SCjC8wO0/3YllriJAna2uzmdhTotKYiDNgoNmZh0joR+19k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=BNuQud3Y; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="BNuQud3Y"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779106973; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+mFjTrbvAC3ugZb8Q62bl8pO0TQZImbGWJ4hDZUs2oM=;
	b=BNuQud3YVBhtsdai22pV3sKLdq2V4DsG8mvLXz7RgkLoWw3CrKlJmEVvq+OjmsCAgz2gT4QrY/0IUr9w4oykECI3R0jqW6UfYiHfAw8Hw65yBAsafw9FXWMxEx3u9sZxjrXnjw6xWRDKG0gKOnH0Sp2DWLEdOnfChjkRWtzCfOk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=boshiyu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X390mz9_1779106972;
Received: from 30.221.149.10(mailfrom:boshiyu@linux.alibaba.com fp:SMTPD_---0X390mz9_1779106972 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 20:22:52 +0800
Message-ID: <a79dc9cb-9fd4-46d9-b6e2-f06d09725669@linux.alibaba.com>
Date: Mon, 18 May 2026 20:22:52 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next 3/3] RDMA/erdma: Implement
 erdma_reg_user_mr_dmabuf
To: Leon Romanovsky <leon@kernel.org>
References: <20260507053437.46211-1-boshiyu@linux.alibaba.com>
 <20260507053437.46211-4-boshiyu@linux.alibaba.com>
 <20260513141221.GF15586@unreal>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, chengyou@linux.alibaba.com,
 kaishen@linux.alibaba.com
From: Boshi Yu <boshiyu@linux.alibaba.com>
In-Reply-To: <20260513141221.GF15586@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 2026/5/13 22:12, Leon Romanovsky wrote:
> It appears Sashiko has some feedback:
> https://sashiko.dev/#/patchset/20260507053437.46211-1- 
> boshiyu@linux.alibaba.com
> 
> The comments regarding ib_umem_find_best_pgsz() seem worth addressing.
> 
> Thanks

Hi, Leon,

Thanks for your review. I’ll add validation for the return value of 
ib_umem_find_best_pgsz() in the next version.

Thanks,

Boshi YU
