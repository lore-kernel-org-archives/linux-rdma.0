Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12874C0502E
	for <linux-rdma@archiver.kernel.org>; Mon, 29 Aug 2022 03:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiH2D2y (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 28 Aug 2022 23:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiH2D2x (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 28 Aug 2022 23:28:53 -0400
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A597402C7;
        Sun, 28 Aug 2022 20:28:51 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VNW.E43_1661743728;
Received: from 30.227.95.166(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VNW.E43_1661743728)
          by smtp.aliyun-inc.com;
          Mon, 29 Aug 2022 11:28:48 +0800
Message-ID: <c2092a9e-16da-68fc-824b-65699430bb68@linux.alibaba.com>
Date:   Mon, 29 Aug 2022 11:28:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v2 00/10] optimize the parallelism of SMC-R
 connections
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <cover.1661407821.git.alibuda@linux.alibaba.com>
 <20220826183213.38eb4cac@kernel.org>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <20220826183213.38eb4cac@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 8/27/22 9:32 AM, Jakub Kicinski wrote:
> On Fri, 26 Aug 2022 17:51:27 +0800 D. Wythe wrote:
>> This patch set attempts to optimize the parallelism of SMC-R connections,
>> mainly to reduce unnecessary blocking on locks, and to fix exceptions that
>> occur after thoses optimization.
>>
>> According to Off-CPU graph, SMC worker's off-CPU as that:
>>
>> smc_close_passive_work			(1.09%)
>> 	smcr_buf_unuse			(1.08%)
>> 		smc_llc_flow_initiate	(1.02%)
>> 	
>> smc_listen_work 			(48.17%)
>> 	__mutex_lock.isra.11 		(47.96%)
> 
> The patches should be ordered so that the prerequisite changes are
> first, then the removal of locks. Looks like there are 3 patches here
> which carry a Fixes tag, for an old commit but in fact IIUC there is no
> bug in those old commits, the problem only appears after the locking is
> removed?
> 


Thank you for your suggestion, this is indeed my ill-consideration.

The first PATCH with the Fix tag is indeed a prerequisite for removing the lock,
and it do should be placed before. The other two with PATCH fixes theoretically
can also appear before, but after the lock is removed the probability of it will
be greatly increased. I see it can also be placed before.


> That said please wait for IBM folks to review first before reshuffling
> the patches, I presume the code itself won't change.

Thanks your suggestion again, I will reshuffling the order of it after you
have reviewed it all.


> Also I still haven't see anyone reply to Al Viro, IIRC he was
> complaining about changes someone from your team has made.
> I consider this a blocker for applying new patches from your team :(

Sorry to bother you and your team, my colleague will explain to you soon.

Thanks.
D. Wythe




