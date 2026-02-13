Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790273115BD
	for <linux-rdma@vger.kernel.org>; Fri, 13 Feb 2026 07:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770969176; cv=none; b=fP3NmATt8sDzM24cdcZruyOGBc2x+UQpjiyc7sXld6XZACS8e253LoZfuJAELbblW78tibxo3mr2zZzCtUpZecj83ZkVd99kMjdInMHEndWaMLMyef6S4RauhXXRi5Fn9ItWPml2oDfntvvRzxwetBJfTlmbNiLiGSzVHkVVRYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770969176; c=relaxed/simple;
	bh=ZYVJ7mQ38egDtlDlPSbdR+L/2EqnnaH5k/Dv2rxBLqE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=AwDpI8uj0wER3tZtP0o8yk4G9q7ialv9zXLk2FDQVGQzsdyvqUNrFRvr/uwJvjYVdhOzLu432tTfxXhwJddehiO3H/ON38eckk2UYfUiAMWPMvh+rhdOOf1Fi5x3nlRuKiHUWwvncggoxay/4ffL7LlTiXPrSnRi7/9qqpg8eO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fC4612HDLz1prMF;
	Fri, 13 Feb 2026 15:48:09 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 5058D40569;
	Fri, 13 Feb 2026 15:52:51 +0800 (CST)
Received: from [10.67.120.168] (10.67.120.168) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 13 Feb 2026 15:52:50 +0800
Message-ID: <28023174-dd0a-246e-ee0d-531b0bfda873@hisilicon.com>
Date: Fri, 13 Feb 2026 15:52:50 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From: Junxian Huang <huangjunxian6@hisilicon.com>
Subject: Re: [PATCH for-next 2/3] RDMA/hns: Add write support to debugfs
To: Leon Romanovsky <leon@kernel.org>
CC: <jgg@ziepe.ca>, <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>,
	<tangchengchang@huawei.com>
References: <20260206103110.3414311-1-huangjunxian6@hisilicon.com>
 <20260206103110.3414311-3-huangjunxian6@hisilicon.com>
 <20260212165507.GH12887@unreal>
Content-Language: en-US
In-Reply-To: <20260212165507.GH12887@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf100018.china.huawei.com (7.202.181.17)



On 2026/2/13 0:55, Leon Romanovsky wrote:
> On Fri, Feb 06, 2026 at 06:31:09PM +0800, Junxian Huang wrote:
>> Add write support to debugfs.
>>
>> Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
>> ---
>>  drivers/infiniband/hw/hns/hns_roce_debugfs.c | 38 +++++++++++++++++---
>>  drivers/infiniband/hw/hns/hns_roce_debugfs.h |  1 +
>>  2 files changed, 35 insertions(+), 4 deletions(-)
> 
> <...>
> 
>>  static const struct file_operations hns_debugfs_seqfile_fops = {
>>  	.owner = THIS_MODULE,
>>  	.open = hns_debugfs_seqfile_open,
>>  	.release = single_release,
>>  	.read = seq_read,
>> +	.write = hns_debugfs_seqfile_write,
>>  	.llseek = seq_lseek
>>  };
>>  
> 
> <...>
> 
>> -	debugfs_create_file(name, 0400, parent, seq, &hns_debugfs_seqfile_fops);
>> +	debugfs_create_file(name, ops->write ? 0600 : 0400, parent,
>> +			    seq, &hns_debugfs_seqfile_fops);
> 
> What is this "ops->write ?" check? You added write callback in this
> exactly patch. It is always true.
> 

This ops is the function argument "const struct hns_debugfs_rw_ops *ops", not
the file_operations hns_debugfs_seqfile_fops. This ops->write can be NULL when
the file is read-only, such as the change in create_sw_stat_debugfs() in this
patch.

Junxian

> Thanks
> 
