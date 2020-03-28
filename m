Return-Path: <SRS0=K66X=5N=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E745C43331
	for <linux-rdma@archiver.kernel.org>; Sat, 28 Mar 2020 03:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0003206F1
	for <linux-rdma@archiver.kernel.org>; Sat, 28 Mar 2020 03:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgC1DDP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 27 Mar 2020 23:03:15 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3424 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbgC1DDP (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 27 Mar 2020 23:03:15 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id A6AB346EBB4B39B53B44;
        Sat, 28 Mar 2020 11:03:09 +0800 (CST)
Received: from DGGEML502-MBS.china.huawei.com ([169.254.3.252]) by
 DGGEML404-HUB.china.huawei.com ([fe80::b177:a243:7a69:5ab8%31]) with mapi id
 14.03.0487.000; Sat, 28 Mar 2020 11:03:00 +0800
From:   liweihang <liweihang@huawei.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        oulijun <oulijun@huawei.com>,
        "Huwei (Xavier)" <huwei87@hisilicon.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "wangxi (M)" <wangxi11@huawei.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2][next] RDMA/hns: Fix uninitialized variable bug
Thread-Topic: [PATCH v2][next] RDMA/hns: Fix uninitialized variable bug
Thread-Index: AQHWBKkctrZs8Dqln0e5bv89qkQeTQ==
Date:   Sat, 28 Mar 2020 03:02:59 +0000
Message-ID: <B82435381E3B2943AA4D2826ADEF0B3A022B7434@DGGEML502-MBS.china.huawei.com>
References: <20200328023539.GA32016@embeddedor>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.40.168.149]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 2020/3/28 10:32, Gustavo A. R. Silva wrote:
> There is a potential execution path in which variable *ret* is returned
> without being properly initialized, previously.
> 
> Fix this by initializing variable *ret* to 0.
> 
> Addresses-Coverity-ID: 1491917 ("Uninitialized scalar variable")
> Fixes: 2f49de21f3e9 ("RDMA/hns: Optimize mhop get flow for multi-hop addressing")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
> Changes in v2:
>  - Set ret to 0 instead of -ENODEV. Thanks Weihang Li, for the feedback.
> 
>  drivers/infiniband/hw/hns/hns_roce_hem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
> index c96378718f88..263338b90d7a 100644
> --- a/drivers/infiniband/hw/hns/hns_roce_hem.c
> +++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
> @@ -603,7 +603,7 @@ static int set_mhop_hem(struct hns_roce_dev *hr_dev,
>  {
>  	struct ib_device *ibdev = &hr_dev->ib_dev;
>  	int step_idx;
> -	int ret;
> +	int ret = 0;
>  
>  	if (index->inited & HEM_INDEX_L0) {
>  		ret = hr_dev->hw->set_hem(hr_dev, table, obj, 0);
> 

Acked-by: Weihang Li <liweihang@huawei.com>
