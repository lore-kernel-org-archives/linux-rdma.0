Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D810E7D27A
	for <linux-rdma@archiver.kernel.org>; Tue, 26 Sep 2023 10:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234396AbjIZKjO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 26 Sep 2023 06:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbjIZKjO (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 26 Sep 2023 06:39:14 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8958695;
        Tue, 26 Sep 2023 03:39:07 -0700 (PDT)
Received: from kwepemi500006.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Rvx4g2MZtzrSrl;
        Tue, 26 Sep 2023 18:36:51 +0800 (CST)
Received: from [10.67.120.168] (10.67.120.168) by
 kwepemi500006.china.huawei.com (7.221.188.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 26 Sep 2023 18:39:05 +0800
Message-ID: <fd68ff0c-8dcb-d60a-60eb-c4d7d34c4805@hisilicon.com>
Date:   Tue, 26 Sep 2023 18:39:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH for-next] RDMA/hns: Support SRQ record doorbell
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
CC:     <jgg@ziepe.ca>, <linux-rdma@vger.kernel.org>,
        <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>
References: <20230920033005.1557-1-huangjunxian6@hisilicon.com>
 <20230926093046.GG1642130@unreal>
From:   Junxian Huang <huangjunxian6@hisilicon.com>
In-Reply-To: <20230926093046.GG1642130@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.120.168]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500006.china.huawei.com (7.221.188.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 2023/9/26 17:30, Leon Romanovsky wrote:
> On Wed, Sep 20, 2023 at 11:30:05AM +0800, Junxian Huang wrote:
>> From: Yangyang Li <liyangyang20@huawei.com>
>>
>> Compared with normal doorbell, using record doorbell can shorten the
>> process of ringing the doorbell and reduce the latency.
>>
>> Add a flag HNS_ROCE_CAP_FLAG_SRQ_RECORD_DB to allow FW to
>> enable/disable SRQ record doorbell.
>>
>> If the flag above is set, allocate the dma buffer for SRQ record
>> doorbell and write the buffer address into SRQC during SRQ creation.
>>
>> For userspace SRQ, add a flag HNS_ROCE_RSP_SRQ_CAP_RECORD_DB to notify
>> userspace whether the SRQ record doorbell is enabled.
>>
>> Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
>> Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
>> ---
>>  drivers/infiniband/hw/hns/hns_roce_device.h |  3 +
>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 30 ++++++--
>>  drivers/infiniband/hw/hns/hns_roce_srq.c    | 85 ++++++++++++++++++++-
>>  include/uapi/rdma/hns-abi.h                 | 13 +++-
>>  4 files changed, 120 insertions(+), 11 deletions(-)
> 
> Junxian, do you plan to resubmit it this patch to fix kbuild error?
> 
> Thanks

Yes. I'll resubmit soon.
