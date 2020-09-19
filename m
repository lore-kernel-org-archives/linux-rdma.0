Return-Path: <SRS0=5wWz=C4=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F06C43464
	for <linux-rdma@archiver.kernel.org>; Sat, 19 Sep 2020 02:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1C5721707
	for <linux-rdma@archiver.kernel.org>; Sat, 19 Sep 2020 02:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgISCo4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 18 Sep 2020 22:44:56 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:59194 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgISCo4 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 18 Sep 2020 22:44:56 -0400
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 1A67834ED32F5497F645;
        Sat, 19 Sep 2020 10:44:55 +0800 (CST)
Received: from dggema704-chm.china.huawei.com (10.3.20.68) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 19 Sep 2020 10:44:54 +0800
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggema704-chm.china.huawei.com (10.3.20.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 19 Sep 2020 10:44:54 +0800
Received: from dggema753-chm.china.huawei.com ([10.9.48.84]) by
 dggema753-chm.china.huawei.com ([10.9.48.84]) with mapi id 15.01.1913.007;
 Sat, 19 Sep 2020 10:44:54 +0800
From:   liweihang <liweihang@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH v2 for-next 4/9] RDMA/hns: Correct typo of
 hns_roce_create_cq()
Thread-Topic: [PATCH v2 for-next 4/9] RDMA/hns: Correct typo of
 hns_roce_create_cq()
Thread-Index: AQHWhodzhbJrqQVIjEizo3npjNWucg==
Date:   Sat, 19 Sep 2020 02:44:54 +0000
Message-ID: <6abda766819e4c289900a4967b2af687@huawei.com>
References: <1599641854-23160-1-git-send-email-liweihang@huawei.com>
 <1599641854-23160-5-git-send-email-liweihang@huawei.com>
 <20200918140937.GA305257@nvidia.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.100.165]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 2020/9/18 22:09, Jason Gunthorpe wrote:
> On Wed, Sep 09, 2020 at 04:57:29PM +0800, Weihang Li wrote:
>> From: Lang Cheng <chenglang@huawei.com>
>>
>> Change "initialze" to "initialize".
>>
>> Signed-off-by: Lang Cheng <chenglang@huawei.com>
>> Signed-off-by: Weihang Li <liweihang@huawei.com>
>> ---
>>  drivers/infiniband/hw/hns/hns_roce_cq.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Missing fixes line
> 
> Jason
> 

OK, thank you.

Weihang
