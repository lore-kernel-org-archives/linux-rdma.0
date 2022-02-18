Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62530C433F5
	for <linux-rdma@archiver.kernel.org>; Fri, 18 Feb 2022 02:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiBRCHM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 17 Feb 2022 21:07:12 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiBRCHM (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 17 Feb 2022 21:07:12 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141F311B32D
        for <linux-rdma@vger.kernel.org>; Thu, 17 Feb 2022 18:06:54 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V4nBO1K_1645150010;
Received: from 30.43.105.166(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0V4nBO1K_1645150010)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 18 Feb 2022 10:06:52 +0800
Message-ID: <c5634c02-9263-a8a5-69a1-25a677261c64@linux.alibaba.com>
Date:   Fri, 18 Feb 2022 10:06:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH for-next v3 00/12] Elastic RDMA Adapter (ERDMA) driver
Content-Language: en-US
To:     Bernard Metzler <BMT@zurich.ibm.com>,
        Cheng Xu <chengyou.xc@alibaba-inc.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>
Cc:     "leon@kernel.org" <leon@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "KaiShen@linux.alibaba.com" <KaiShen@linux.alibaba.com>,
        "tonylu@linux.alibaba.com" <tonylu@linux.alibaba.com>
References: <BYAPR15MB2631867F60D52B2626D3708499369@BYAPR15MB2631.namprd15.prod.outlook.com>
From:   Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <BYAPR15MB2631867F60D52B2626D3708499369@BYAPR15MB2631.namprd15.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 2/18/22 1:21 AM, Bernard Metzler wrote:
> 
>> -----Original Message-----
>> From: Cheng Xu <chengyou.xc@alibaba-inc.com>
>> Sent: Thursday, 17 February 2022 04:01
>> To: jgg@ziepe.ca; dledford@redhat.com
>> Cc: leon@kernel.org; linux-rdma@vger.kernel.org;
>> KaiShen@linux.alibaba.com; chengyou@linux.alibaba.com;
>> tonylu@linux.alibaba.com
>> Subject: [EXTERNAL] [PATCH for-next v3 00/12] Elastic RDMA Adapter (ERDMA)
>> driver
>>
>> From: Cheng Xu <chengyou@linux.alibaba.com>
>>
>> Hello all,
>>
>> This v3 patch set introduces the Elastic RDMA Adapter (ERDMA) driver,
>> which released in Apsara Conference 2021 by Alibaba. The PR of ERDMA
>> userspace provider has already been created [1].
>>
> 
> Is this only at my side? I did not get [09/12] of that v3 set.
> If yes, I'll find a way to comment on that as well if
> needed. I see it at patchwork.

Can you find [09/12] in other folders in your email APP? It alreay in
lore.kernel.org now:

[1] 
https://lore.kernel.org/all/20220217030116.6324-10-chengyou.xc@alibaba-inc.com/#t

> I am traveling these days, therefore cannot comment before mid
> next week.
All right, thanks.


Cheng Xu,

> Thanks,
> Bernard.
> 

<...>

