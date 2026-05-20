Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CF6343886;
	Wed, 20 May 2026 06:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779257093; cv=none; b=jOabsjM/07WaesztR2zU9hT71S29ZsQV9CHWsQ7SPvcc0HroGDCneOCR1WRz9r1Lb5kf5DGxfmyhGXp9P23E4YDNP5SRBT1y28SgbobTBqPafSrosUg5WnmSb97dgfhxL1EFsooJcL+y5IkbDvombyX/66p3xayTaTsjiax11lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779257093; c=relaxed/simple;
	bh=t8t0YviG4raIcFlsLCskV659TAabxZI97idn6HoaONA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZLK172UND/t+qc7usOdypI7giCdiOXujCc9S1ws+e8FU1hUErkKCjcAqx2ZKWcqB89gqw4I5lFcveAUewD6vcrVH+LS0rkWrU1BHLFXXNKN2B5aJTk/FBVtG/KLsrtHqyU2ixTcZi9ZL3NAOKHM89x05iH36aLc6fhhO3HKDA3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gL15V4mWSzRhRG;
	Wed, 20 May 2026 13:57:02 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 95DF62025F;
	Wed, 20 May 2026 14:04:43 +0800 (CST)
Received: from [10.67.120.168] (10.67.120.168) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 20 May 2026 14:04:43 +0800
Message-ID: <8fca4982-3046-95d1-27c7-0766105db73e@hisilicon.com>
Date: Wed, 20 May 2026 14:04:42 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: RDMA/hns: dead empty check on head->root in setup_root_hem?
To: Maoyi Xie <maoyixie.tju@gmail.com>, Chengchang Tang
	<tangchengchang@huawei.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260519202809.2437430-1-maoyixie.tju@gmail.com>
Content-Language: en-US
From: Junxian Huang <huangjunxian6@hisilicon.com>
In-Reply-To: <20260519202809.2437430-1-maoyixie.tju@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf100018.china.huawei.com (7.202.181.17)



On 2026/5/20 4:28, Maoyi Xie wrote:
> Hi all,
> 
> While auditing list_first_entry callsites, I noticed a place in
> drivers/infiniband/hw/hns/hns_roce_hem.c where the developer
> wrote a NULL check for an empty list but used the unsafe API.
> The check is dead code. I would appreciate it if you could take
> a look and let me know whether this is worth fixing.
> 
> The site is setup_root_hem() (linux-7.1-rc1, around line 1270):
> 
>     root_hem = list_first_entry(&head->root,
>                                 struct hns_roce_hem_item, list);
>     if (!root_hem)
>             return -ENOMEM;
> 
>     total = 0;
>     for (i = 0; i < region_cnt && total <= max_ba_num; i++) {
>             ...
>             cpu_base = root_hem->addr + total * BA_BYTE_LEN;
>             ...
> 
> list_first_entry() returns container_of(&head->root, struct
> hns_roce_hem_item, list) when head->root is empty, never NULL.
> The -ENOMEM early return is dead code.
> 
> With an empty head->root, the fall through pointer aliases
> &head->root inside struct hns_roce_hem_head. root_hem->addr is
> then read from memory at a fixed offset inside that struct,
> producing a garbage DMA base address that is then handed to
> the hardware.
> 
> head->root is empty if the caller fails to allocate and add the
> root item before calling setup_root_hem. A future caller could
> also miss that precondition.
> 
> A candidate fix is a one liner. Switch to list_first_entry_or_null
> so the -ENOMEM early return runs.
> 
> Similar dead empty checks after list_first_entry have been
> cleaned up in the same shape, for example commit fbb8bc408027
> (net: qed: Remove redundant NULL checks after list_first_entry),
> commit c708d3fad421 (crypto: atmel: use list_first_entry_or_null
> to simplify find_dev) and commit 10379171f346 (ksmbd: use
> list_first_entry_or_null for opinfo_get_list). The qed commit
> message describes the exact shape we observe here. This hns
> site appears to be missed by those cleanups.
> 
> If this is intentional or already known, please disregard.
> Otherwise I am happy to send a [PATCH] or to leave the fix to
> you.

Please send a patch, thanks!

Junxian

> 
> Thanks,
> Maoyi Xie
> https://maoyixie.com/
