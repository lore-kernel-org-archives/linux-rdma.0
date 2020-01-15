Return-Path: <SRS0=S6Iu=3E=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE68EC33C9E
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Jan 2020 01:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEE5E2467C
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Jan 2020 01:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgAOBai (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 14 Jan 2020 20:30:38 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:40252 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728844AbgAOBah (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 14 Jan 2020 20:30:37 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9D342FE65B6C0751AABA;
        Wed, 15 Jan 2020 09:30:35 +0800 (CST)
Received: from [127.0.0.1] (10.40.168.149) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 15 Jan 2020
 09:30:27 +0800
Subject: Re: [PATCH for-next] RDMA/hns: Add support for extended atomic
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Weihang Li <liweihang@hisilicon.com>, <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <linuxarm@huawei.com>
References: <1573781966-45800-1-git-send-email-liweihang@hisilicon.com>
 <20200102210351.GA398@ziepe.ca>
 <2b8eb4ac-ef0c-7c7f-270f-8d3768f7c2a7@huawei.com>
 <20200103133907.GB9706@ziepe.ca>
 <05e78494-20fc-b551-9a5b-2eb577206286@huawei.com>
 <20200114132931.GA22037@ziepe.ca>
From:   Weihang Li <liweihang@huawei.com>
Message-ID: <fb051bcd-c4e6-1884-d52b-b740b81647f5@huawei.com>
Date:   Wed, 15 Jan 2020 09:30:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200114132931.GA22037@ziepe.ca>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.168.149]
X-CFilter-Loop: Reflected
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 2020/1/14 21:29, Jason Gunthorpe wrote:
> On Tue, Jan 14, 2020 at 09:53:07AM +0800, Weihang Li wrote:
>> Thanks for your reminder about extended atomic in kernel and sorry for the
>> delayed response.
>>
>> We cancel this patch as your suggestion, and will send another one which
>> the user space extended atomic is dependent on.
> 
> You should not have allowed your userspace to be merged until any
> required kernel pieces were merged.
> 
> Jason
> 
> 

Hi Jason,

Sorry for that, I missed two related changes to configure QP context to
enable capability of extended atomic.
Will send it as soon as possible.

Weihang

