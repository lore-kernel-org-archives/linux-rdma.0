Return-Path: <SRS0=2Sn3=65=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E10BCC433E0
	for <linux-rdma@archiver.kernel.org>; Fri, 15 May 2020 09:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5E122073E
	for <linux-rdma@archiver.kernel.org>; Fri, 15 May 2020 09:40:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgEOJkh convert rfc822-to-8bit (ORCPT
        <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 15 May 2020 05:40:37 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2135 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728030AbgEOJkg (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 15 May 2020 05:40:36 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 063B684A8EF9AA0A3D30;
        Fri, 15 May 2020 17:40:35 +0800 (CST)
Received: from DGGEML424-HUB.china.huawei.com (10.1.199.41) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 15 May 2020 17:40:34 +0800
Received: from DGGEML522-MBX.china.huawei.com ([169.254.7.243]) by
 dggeml424-hub.china.huawei.com ([10.1.199.41]) with mapi id 14.03.0487.000;
 Fri, 15 May 2020 17:40:26 +0800
From:   liweihang <liweihang@huawei.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: Questions about masked atomic
Thread-Topic: Questions about masked atomic
Thread-Index: AdYnm7vjyDIKjW3JQkW+0B8JTa36qA==
Date:   Fri, 15 May 2020 09:40:26 +0000
Message-ID: <B82435381E3B2943AA4D2826ADEF0B3A02363499@DGGEML522-MBX.china.huawei.com>
References: <B82435381E3B2943AA4D2826ADEF0B3A02359ED3@DGGEML522-MBX.china.huawei.com>
 <20200512113512.GK4814@unreal>
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

On 2020/5/12 19:35, Leon Romanovsky wrote:
> On Mon, May 11, 2020 at 01:54:48PM +0000, liweihang wrote:
>> Hi All,
>>
>> I have two questions about masked atomic (Masked Compare and Swap & MFetchAdd):
>>
>> 1. The kernel now supports masked atomic, but the it does not support atomic
>>    operation. Is the masked atomic valid in kernel currently?
> 
> Yes, it is valid, but probably has a very little real value for the kernel ULPs.
> I see code in the RDS that uses atomics, but it says nothing to me, because
> upstream RDS and version in-real-use are completely different.
> 
>> 2. In the userspace, ofed does not have the corresponding opcode for the masked
>>    atomic (IB_WR_MASKED_ATOMIC_CMP_AND_SWP, IB_WR_MASKED_ATOMIC_FETCH_AND_ADD),
>>    and ibv_send_wr also has no related data segment for it. How to support it in
>>    userspace?
> 
> ibv_send_wr is not extensible, so the real solution will need to extend ibv_wr_post() [1]
> with specific and new post builders.
> 
> Thanks
> 
> [1] https://github.com/linux-rdma/rdma-core/blob/master/libibverbs/man/ibv_wr_post.3.md
> 

Hi Leon,

Thanks for your response. May I ask another question:

Why it's not encouraged to use atomic/extended atomic/masked atomic operations in kernel?
Jason said that there seems no kernel users of extended atomic, is there any other reasons?

Weihang
