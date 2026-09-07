Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E9C1A6836
	for <linux-rdma@vger.kernel.org>; Mon,  7 Sep 2026 02:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788747698; cv=none; b=WQ+oL7t19JKFkFmr/hEeAY9ConqUWt8h+9Td8yU8YpeOVrWpZ2V9sws71+7lrhSn+sVAVIGVyRRWv0H0iX6Zf1D+YdHBOh/x6ncYR2pdMF0DQl2v6MflhRJ0xWXcUxA8cAK2+SWfRIHft48WpNwVODAR35ajTaaNiGkENm9uRXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788747698; c=relaxed/simple;
	bh=8LGeL5w+yhZzxs76Xz0KPjnlykImiJp/4Wyaj3U7+MA=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ZhBt6UXXJvm1s3fJhc8MVYx9UWTXEISM7SVt737JQEzHqx41N1GkUAqWaZRb0lnALUAXtUS2Ug9FErNXES0YbLYnGTF3Tol5qsZUYbI5UxF71mCzbD9klkhhEfsobxL0cF/DVO7YGTqvClLl+upGUIN7tIQLsvFuQjogrZt+ULU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hdVsM6qdCz1prPv;
	Mon,  7 Sep 2026 10:10:31 +0800 (CST)
Received: from kwepemf100018.china.huawei.com (unknown [7.202.181.17])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C4AB40537;
	Mon,  7 Sep 2026 10:21:26 +0800 (CST)
Received: from [10.67.120.168] (10.67.120.168) by
 kwepemf100018.china.huawei.com (7.202.181.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 7 Sep 2026 10:21:25 +0800
Message-ID: <a7693154-52de-5aa5-cf25-818756ded23b@hisilicon.com>
Date: Mon, 7 Sep 2026 10:21:24 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH for-next 1/2] RDMA/hns: Limit gmv_entry_num to avoid
 memory waste
Content-Language: en-US
To: Leon Romanovsky <leon@kernel.org>
CC: <jgg@ziepe.ca>, <linux-rdma@vger.kernel.org>, <tangchengchang@huawei.com>,
	<linuxarm@huawei.com>
References: <20260904093837.1633748-1-huangjunxian6@hisilicon.com>
 <20260904093837.1633748-2-huangjunxian6@hisilicon.com>
 <20260906091233.GC13683@unreal>
From: Junxian Huang <huangjunxian6@hisilicon.com>
In-Reply-To: <20260906091233.GC13683@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf100018.china.huawei.com (7.202.181.17)



On 2026/9/6 17:12, Leon Romanovsky wrote:
> On Fri, Sep 04, 2026 at 05:38:36PM +0800, Junxian Huang wrote:
>> The GMV entry is a HW object corresponding to a GID. Since gid_table_len
>> is already limited to a maximum of 256, there is no need to allocate
>> memory for those extra GMV entries as they will never be touched.
>>
>> Fixes: 7243396aaf12 ("RDMA/hns: Add a max length of gid table")
>> Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
>> ---
>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> index 27cc7df55ee7..3edceadbca76 100644
>> --- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> +++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
>> @@ -2416,8 +2416,7 @@ static void apply_func_caps(struct hns_roce_dev *hr_dev)
>>  					 caps->gmv_bt_num *
>>  					 (HNS_HW_PAGE_SIZE / caps->gmv_entry_sz));
>>  
>> -		caps->gmv_entry_num = caps->gmv_bt_num * (HNS_HW_PAGE_SIZE /
>> -							  caps->gmv_entry_sz);
>> +		caps->gmv_entry_num = (u32)caps->gid_table_len[0];
> 
> Please fix the declaration of gid_table_len first. It should be u32 in the
> first place.

Will add a patch to fix it.

Junxian

> 
> Thanks
> 
>>  	} else {
>>  		u32 func_num = max_t(u32, 1, hr_dev->func_num);
>>  
>> -- 
>> 2.33.0
>>
