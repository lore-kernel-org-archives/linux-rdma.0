Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811B8ECAAD1
	for <linux-rdma@archiver.kernel.org>; Wed, 31 Aug 2022 08:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiHaIZA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 31 Aug 2022 04:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbiHaIY6 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 31 Aug 2022 04:24:58 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136141573D
        for <linux-rdma@vger.kernel.org>; Wed, 31 Aug 2022 01:24:56 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MHcYp3yj2zYd40;
        Wed, 31 Aug 2022 16:20:30 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 31 Aug 2022 16:24:54 +0800
Received: from [10.40.238.78] (10.40.238.78) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 31 Aug
 2022 16:24:54 +0800
Subject: Re: [PATCH for-next] RDMA/hns: Disable local invalidate operation
To:     Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
References: <20220829105203.1569481-1-liangwenpeng@huawei.com>
 <Yw28pZu4wuLzfYVT@unreal> <Yw4VNtNY/mcCYGfd@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
From:   Wenpeng Liang <liangwenpeng@huawei.com>
Message-ID: <21a1e5e7-ab3d-f18b-e070-74c7dc99c791@huawei.com>
Date:   Wed, 31 Aug 2022 16:24:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <Yw4VNtNY/mcCYGfd@nvidia.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.238.78]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 2022/8/30 21:48, Jason Gunthorpe wrote:
> On Tue, Aug 30, 2022 at 10:30:45AM +0300, Leon Romanovsky wrote:
>> On Mon, Aug 29, 2022 at 06:52:03PM +0800, Wenpeng Liang wrote:
>>> From: Yangyang Li <liyangyang20@huawei.com>
>>>
>>> Currently, local invalidate operation doesn't work well. So the hns driver
>>> does not support it temporarily and removes related code.
>>
>> Please add Fixes line, and provide some context, so we can take it to
>> -rc and to all stable@ trees so this feature will be deleted from
>> previous kernel versions too.
>>
> 
> A more detailed description of what "works well" means would be good
> too
> 

I will add more descriptions and resend this patch.

Thanks,
Wenpeng

> Jason
> .
> 
