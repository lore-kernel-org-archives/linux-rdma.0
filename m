Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99EA4C6FD20
	for <linux-rdma@archiver.kernel.org>; Fri, 24 Mar 2023 08:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjCXIV7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 24 Mar 2023 04:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCXIV6 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 24 Mar 2023 04:21:58 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7ED2413E;
        Fri, 24 Mar 2023 01:21:53 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=kaishen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VeX2MDu_1679646108;
Received: from 30.221.112.234(mailfrom:KaiShen@linux.alibaba.com fp:SMTPD_---0VeX2MDu_1679646108)
          by smtp.aliyun-inc.com;
          Fri, 24 Mar 2023 16:21:49 +0800
Message-ID: <c7434855-b569-4e10-fd19-7f7d525cad7f@linux.alibaba.com>
Date:   Fri, 24 Mar 2023 16:21:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] net/smc: introduce shadow sockets for fallback
 connections
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, kuba@kernel.org,
        davem@davemloft.net, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20230321071959.87786-1-KaiShen@linux.alibaba.com>
 <8f4bd9333117eda4c5ff324f92b969d9a6b57b65.camel@redhat.com>
From:   Kai <KaiShen@linux.alibaba.com>
In-Reply-To: <8f4bd9333117eda4c5ff324f92b969d9a6b57b65.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 3/22/23 9:08 PM, Paolo Abeni wrote:
> 
> It looks like only the shadow sockets' receive queue is needed/used.
> 
> Have you considered instead adding 2 receive queues to smc_sock, and
> implement a custom accept() variant fetching the accepted sockets from
> there?
> 
> That will allow better encapsulating the changes into the smc code and
> will avoid creating that 2 non-listening but almost listening sockets
> which look quite strange.
> 
> Cheers,
> 
> Paolo

I am not so sure about this two sockets implementation but Here are my
concerns:
1. When I tried to implement a custom accept, I found the function.
mem_cgroup_charge_skmem is not exported and SMC-R couldn't access it as
a module. If there are more functions like this in future updates this
could be a problem.
3. The custom accept should synchronize with future updates of TCP
accept.
2. SMC-R is trying to behave like TCP and if we implement custom accept,
there may be repeated code and looks not good.

Thanks,

Kai
