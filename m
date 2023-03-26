Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD9DC6FD1C
	for <linux-rdma@archiver.kernel.org>; Sun, 26 Mar 2023 00:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjCZALK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 25 Mar 2023 20:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCZALJ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 25 Mar 2023 20:11:09 -0400
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A34AF31
        for <linux-rdma@vger.kernel.org>; Sat, 25 Mar 2023 17:11:05 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Vebos7F_1679789461;
Received: from 30.15.194.245(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0Vebos7F_1679789461)
          by smtp.aliyun-inc.com;
          Sun, 26 Mar 2023 08:11:02 +0800
Message-ID: <5823ff9c-eef9-f834-9e54-421b3d04bee0@linux.alibaba.com>
Date:   Sun, 26 Mar 2023 08:10:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH for-next v2 2/2] RDMA/erdma: Support non-4K page size in
 doorbell allocation
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org,
        KaiShen@linux.alibaba.com, Yossi Leybovich <sleybo@amazon.com>,
        Gal Pressman <gal@nvidia.com>
References: <ZBm/deQgMYfdPt/u@ziepe.ca>
 <2c82439c-15d0-d5dd-b1c5-46053d3dd202@linux.alibaba.com>
 <ZBrsexPDqDIej/2/@ziepe.ca>
 <6c982b76-61b2-7317-ab76-8ff0b4fb4471@linux.alibaba.com>
 <ZBsKHBN2NIFA6/YD@ziepe.ca>
 <8c446431-9f86-7267-6051-9c016e23215e@linux.alibaba.com>
 <ZBw9pmTtAlNVffuA@ziepe.ca>
 <243f9c6f-72ab-c503-33be-24e58e1d4ddf@linux.alibaba.com>
 <ZBxOoxynDEql7wHT@ziepe.ca>
 <8677b42c-3f61-b83d-cd97-68591778944d@linux.alibaba.com>
 <ZBxfuN66QYgFrJd/@ziepe.ca>
From:   Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <ZBxfuN66QYgFrJd/@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 3/23/23 10:18 PM, Jason Gunthorpe wrote:
> On Thu, Mar 23, 2023 at 10:10:25PM +0800, Cheng Xu wrote:
>>
>>
<...>
>>
>> Malicious doorbell will corrupt the head pointer in QPC, and then invalid WQEs
>> will be processed. My point is that WQE validation can correct the head pointer
>> carried in malicious doorbell, and can prevent such attack.
> 
> No, if the head pointer is incorrect an attack can stall the QP by
> guessing a head pointer that is valid but before already submitted
> WQEs.

You are right.

Thanks very much for this discussion and your advisement.

Cheng Xu

> 
> There is no WQE based recovery for such a thing.
> 
> Jason
