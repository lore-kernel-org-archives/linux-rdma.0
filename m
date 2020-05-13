Return-Path: <SRS0=bifO=63=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412A1C2D0F8
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 06:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2363D20708
	for <linux-rdma@archiver.kernel.org>; Wed, 13 May 2020 06:47:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgEMGrq convert rfc822-to-8bit (ORCPT
        <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 13 May 2020 02:47:46 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2073 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729189AbgEMGrq (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 13 May 2020 02:47:46 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 7971B7C97D27862EDFA1;
        Wed, 13 May 2020 14:47:44 +0800 (CST)
Received: from DGGEML421-HUB.china.huawei.com (10.1.199.38) by
 DGGEML404-HUB.china.huawei.com (10.3.17.39) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 13 May 2020 14:47:44 +0800
Received: from DGGEML522-MBX.china.huawei.com ([169.254.7.243]) by
 dggeml421-hub.china.huawei.com ([10.1.199.38]) with mapi id 14.03.0487.000;
 Wed, 13 May 2020 14:47:37 +0800
From:   liweihang <liweihang@huawei.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH for-next 0/3] RDMA/hns: Preparing for next generation of
 hip08
Thread-Topic: [PATCH for-next 0/3] RDMA/hns: Preparing for next generation
 of hip08
Thread-Index: AQHWIsg2/bZgQkQWU06s8prlJdtrwg==
Date:   Wed, 13 May 2020 06:47:35 +0000
Message-ID: <B82435381E3B2943AA4D2826ADEF0B3A0235DC34@DGGEML522-MBX.china.huawei.com>
References: <1588674607-25337-1-git-send-email-liweihang@huawei.com>
 <20200513002720.GA6166@ziepe.ca>
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

On 2020/5/13 8:27, Jason Gunthorpe wrote:
> On Tue, May 05, 2020 at 06:30:04PM +0800, Weihang Li wrote:
>> Patch #1 add a macro HIP08_C for this new pci device, #2 and #3 adjust
>> codes about flags.
>>
>> Lang Cheng (1):
>>   RDMA/hns: Combine enable flags of qp
>>
>> Weihang Li (2):
>>   RDMA/hns: Extend capability flags for HIP08_C
> 
> These two applied to for-next
> 
>>   RDMA/hns: Add a macro for next generation of hip08
> 
> This is just dead code, send it as part of something that uses it.
> > Thanks,
> Jason
> 

I see, thank you.

Weihang
