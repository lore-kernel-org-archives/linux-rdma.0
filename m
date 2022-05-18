Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 560A7C433EF
	for <linux-rdma@archiver.kernel.org>; Wed, 18 May 2022 07:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbiERHnm (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 18 May 2022 03:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiERHnl (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 18 May 2022 03:43:41 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A5D11E1F8
        for <linux-rdma@vger.kernel.org>; Wed, 18 May 2022 00:43:39 -0700 (PDT)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L34fM35S6zQk90;
        Wed, 18 May 2022 15:40:43 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 18 May 2022 15:43:37 +0800
Received: from [10.40.238.78] (10.40.238.78) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 15:43:37 +0800
Subject: Re: [PATCH for-next] RDMA/hns: Add support for extended doorbell of
 HIP09
To:     <jgg@nvidia.com>, <leon@kernel.org>
References: <20220510135242.51094-1-liangwenpeng@huawei.com>
CC:     <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
From:   Wenpeng Liang <liangwenpeng@huawei.com>
Message-ID: <5c0c3f1c-cbf8-504b-7425-4cfba15b7149@huawei.com>
Date:   Wed, 18 May 2022 15:43:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220510135242.51094-1-liangwenpeng@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.238.78]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 2022/5/10 21:52, Wenpeng Liang wrote:
> The link table of the extended doorbell of HIP09 will be allocated from the
> sram of the device instead of the host memory.
> 
> Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
> Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_cmd.h    |   4 +
>  drivers/infiniband/hw/hns/hns_roce_device.h |   2 +
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 186 +++++++++++++++-----
>  drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |   6 +-
>  4 files changed, 153 insertions(+), 45 deletions(-)

Sorry, the requirements for this feature have changed, and its design
will change. So we had to stop uploading this feature until a new
solution came along.

Sorry again for wasting everyone's time.

Thanks,
Wenpeng
