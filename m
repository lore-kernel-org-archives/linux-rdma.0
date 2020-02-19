Return-Path: <SRS0=b7KD=4H=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8638DC34031
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Feb 2020 01:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6471924655
	for <linux-rdma@archiver.kernel.org>; Wed, 19 Feb 2020 01:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgBSBUF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 18 Feb 2020 20:20:05 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:36878 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726795AbgBSBUF (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 18 Feb 2020 20:20:05 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 88C8B8ABA901C14FB778;
        Wed, 19 Feb 2020 09:20:03 +0800 (CST)
Received: from [127.0.0.1] (10.40.168.149) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 19 Feb 2020
 09:19:53 +0800
Subject: Re: [PATCH for-next] RDMA/hns: Initialize all fields of doorbells to
 zero
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     <dledford@redhat.com>, <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
References: <1581759368-16700-1-git-send-email-liweihang@huawei.com>
 <20200219004652.GA24788@ziepe.ca>
From:   Weihang Li <liweihang@huawei.com>
Message-ID: <cccde0dc-810e-65ff-b082-ca1ca2929e3a@huawei.com>
Date:   Wed, 19 Feb 2020 09:19:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200219004652.GA24788@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.168.149]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 2020/2/19 8:46, Jason Gunthorpe wrote:
> On Sat, Feb 15, 2020 at 05:36:08PM +0800, Weihang Li wrote:
>> From: Lang Cheng <chenglang@huawei.com>
>>
>> Prevent uninitialized fields when new fields are added, and make code
>> look simpler.
>>
>> Signed-off-by: Lang Cheng <chenglang@huawei.com>
>> Signed-off-by: Weihang Li <liweihang@huawei.com>
>> ---
>>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 9 ++-------
>>  drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 5 +----
>>  2 files changed, 3 insertions(+), 11 deletions(-)
> 
> This doesn't apply, please resend
> 
> Jason
> 
> 

OK, will resend, thank you.

Weihang

