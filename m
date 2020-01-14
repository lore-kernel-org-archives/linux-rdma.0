Return-Path: <SRS0=Cfzb=3D=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E203C33CA9
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Jan 2020 01:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14B27207FF
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Jan 2020 01:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgANBxR (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 13 Jan 2020 20:53:17 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9165 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728838AbgANBxR (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 13 Jan 2020 20:53:17 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5C5D3DF31CC998FAAE9C;
        Tue, 14 Jan 2020 09:53:15 +0800 (CST)
Received: from [127.0.0.1] (10.40.168.149) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 14 Jan 2020
 09:53:07 +0800
Subject: Re: [PATCH for-next] RDMA/hns: Add support for extended atomic
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Weihang Li <liweihang@hisilicon.com>, <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
References: <1573781966-45800-1-git-send-email-liweihang@hisilicon.com>
 <20200102210351.GA398@ziepe.ca>
 <2b8eb4ac-ef0c-7c7f-270f-8d3768f7c2a7@huawei.com>
 <20200103133907.GB9706@ziepe.ca>
From:   Weihang Li <liweihang@huawei.com>
Message-ID: <05e78494-20fc-b551-9a5b-2eb577206286@huawei.com>
Date:   Tue, 14 Jan 2020 09:53:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200103133907.GB9706@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.168.149]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 2020/1/3 21:39, Jason Gunthorpe wrote:
> On Fri, Jan 03, 2020 at 01:57:22PM +0800, Weihang Li wrote:
> 
>  
>> This patch has no relationship with the userspace one you pointed out.
>> But I have pushed a userspace patch that support extended atomic on hip08,
>> maybe you were asking about the following one:
>>
>> https://github.com/linux-rdma/rdma-core/pull/638
> 
> Right, sorry
>  
>> The kernel part is not needed by the userspace part, they are independent
>> of each other.
>>
>> We made this patch because we noticed that some other providers has also
>> support this feature in kernel, maybe there will be some kernel users in
>> future. I would be grateful if you could give me more suggestions.
> 
> I think we have no kernel users of extended atomics, it is probably an
> mistake that other providers implemented this in the kernel.
> 
> I would advise against making the hns send path more complicated with
> dead code.
> 
> Jason
> 
> 

Hi Jason,

Thanks for your reminder about extended atomic in kernel and sorry for the
delayed response.

We cancel this patch as your suggestion, and will send another one which
the user space extended atomic is dependent on.

Weihang

