Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31ACC433ED
	for <linux-rdma@archiver.kernel.org>; Tue, 13 Apr 2021 03:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83BFA6120E
	for <linux-rdma@archiver.kernel.org>; Tue, 13 Apr 2021 03:46:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242824AbhDMDqm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 12 Apr 2021 23:46:42 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3398 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238999AbhDMDqm (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 12 Apr 2021 23:46:42 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FKBKG07Smz5pGB;
        Tue, 13 Apr 2021 11:43:30 +0800 (CST)
Received: from dggema702-chm.china.huawei.com (10.3.20.66) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 13 Apr 2021 11:46:03 +0800
Received: from dggema753-chm.china.huawei.com (10.1.198.195) by
 dggema702-chm.china.huawei.com (10.3.20.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Tue, 13 Apr 2021 11:46:03 +0800
Received: from dggema753-chm.china.huawei.com ([10.9.48.84]) by
 dggema753-chm.china.huawei.com ([10.9.48.84]) with mapi id 15.01.2106.013;
 Tue, 13 Apr 2021 11:46:03 +0800
From:   liweihang <liweihang@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH v2 for-next 7/7] RDMA/core: Remove redundant BUG_ON
Thread-Topic: [PATCH v2 for-next 7/7] RDMA/core: Remove redundant BUG_ON
Thread-Index: AQHXK4ad3QgTBs0cDEejc2ZY6yksaw==
Date:   Tue, 13 Apr 2021 03:46:03 +0000
Message-ID: <6df048fba865495aa55ece110e3ab2a9@huawei.com>
References: <1617783353-48249-1-git-send-email-liweihang@huawei.com>
 <1617783353-48249-8-git-send-email-liweihang@huawei.com>
 <20210412175132.GA1140114@nvidia.com>
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

On 2021/4/13 1:51, Jason Gunthorpe wrote:
> On Wed, Apr 07, 2021 at 04:15:53PM +0800, Weihang Li wrote:
>> It's ok if the refcount of cm_id is zero when release the reference of it,
>> there is no need to call BUG_ON.
> 
> Huh? No it isn't.
> 
> If you want to remove this BUG_ON then convert this to a refcount_t
> and rely on refcount debugging instead.
> 
> Jason
> 

I see. I will try using refcount_t instead.

Thank you
Weihang
