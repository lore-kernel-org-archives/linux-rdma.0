Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B62D5EE57CB
	for <linux-rdma@archiver.kernel.org>; Fri,  8 Sep 2023 06:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjIHGJt (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 8 Sep 2023 02:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjIHGJs (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 8 Sep 2023 02:09:48 -0400
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01591BDD
        for <linux-rdma@vger.kernel.org>; Thu,  7 Sep 2023 23:09:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0VrbSgW._1694153380;
Received: from 30.221.108.114(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0VrbSgW._1694153380)
          by smtp.aliyun-inc.com;
          Fri, 08 Sep 2023 14:09:41 +0800
Message-ID: <4428faf8-85f6-d555-f68b-5ca8fe27a836@linux.alibaba.com>
Date:   Fri, 8 Sep 2023 14:09:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [bug report] RDMA/erdma: Add verbs implementation
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     linux-rdma@vger.kernel.org
References: <3d140c1d-524a-4dbe-a51c-aee4f7ecafdb@moroto.mountain>
From:   Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <3d140c1d-524a-4dbe-a51c-aee4f7ecafdb@moroto.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 9/6/23 7:27 PM, Dan Carpenter wrote:
> Hello Cheng Xu,
> 
> The patch 155055771704: "RDMA/erdma: Add verbs implementation" from
> Jul 27, 2022 (linux-next), leads to the following Smatch static
> checker warning:
> 
> 	drivers/infiniband/hw/erdma/erdma_verbs.c:1044 erdma_get_dma_mr()
> 	error: potential zalloc NULL dereference: 'mr->mem.mtt'
> 

<...>

Hi, Dan,

I can reproduce it, it was introduced by commit:

 7244b4aa4221 ("RDMA/erdma: Refactor the storage structure of MTT entries")

Also I submited a patch to fix it just now.

Thanks very much.

Cheng Xu
