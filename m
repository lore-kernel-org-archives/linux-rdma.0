Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495E5C433FE
	for <linux-rdma@archiver.kernel.org>; Fri,  4 Mar 2022 08:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbiCDIYf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 4 Mar 2022 03:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiCDIYe (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 4 Mar 2022 03:24:34 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D0918A7AF;
        Fri,  4 Mar 2022 00:23:45 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V6Brwzc_1646382222;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V6Brwzc_1646382222)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Mar 2022 16:23:43 +0800
Date:   Fri, 4 Mar 2022 16:23:42 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Tony Lu <tonylu@linux.alibaba.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH net-next 6/7] net/smc: don't req_notify until all CQEs
 drained
Message-ID: <20220304082342.GC35207@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220301094402.14992-1-dust.li@linux.alibaba.com>
 <20220301094402.14992-7-dust.li@linux.alibaba.com>
 <Yh3x93sPCS+w/Eth@unreal>
 <20220301105332.GA9417@linux.alibaba.com>
 <2a950f5a-d3be-0790-2487-9a3c37894b5b@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a950f5a-d3be-0790-2487-9a3c37894b5b@linux.ibm.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Mar 04, 2022 at 09:19:27AM +0100, Karsten Graul wrote:
>On 01/03/2022 11:53, dust.li wrote:
>> On Tue, Mar 01, 2022 at 12:14:15PM +0200, Leon Romanovsky wrote:
>>> On Tue, Mar 01, 2022 at 05:44:01PM +0800, Dust Li wrote:
>>> 1. Please remove "--Guangguan Wang".
>>> 2. We already discussed that. SMC should be changed to use RDMA CQ pool API
>>> drivers/infiniband/core/cq.c.
>>> ib_poll_handler() has much better implementation (tracing, IRQ rescheduling,
>>> proper error handling) than this SMC variant.
>> 
>> OK, I'll remove this patch in the next version.
>
>Looks like this one was accepted already, but per discussion (and I agree with that) -
>please revert this patch. Thank you.

Yes. No problem, I will send a revert patch.

Thanks
