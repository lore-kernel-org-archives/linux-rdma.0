Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1CBCCA48B
	for <linux-rdma@archiver.kernel.org>; Wed,  8 Jun 2022 06:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbiFHGBJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 8 Jun 2022 02:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238718AbiFHFwB (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 8 Jun 2022 01:52:01 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA156703F9;
        Tue,  7 Jun 2022 20:36:13 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VFj6p37_1654659370;
Received: from 30.43.105.165(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0VFj6p37_1654659370)
          by smtp.aliyun-inc.com;
          Wed, 08 Jun 2022 11:36:11 +0800
Message-ID: <ef94d5de-da12-a894-8ff3-af7ecf9d568a@linux.alibaba.com>
Date:   Wed, 8 Jun 2022 11:36:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH -next] RDMA/erdma: remove unneeded semicolon
Content-Language: en-US
To:     Yang Li <yang.lee@linux.alibaba.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc:     kaishen@linux.alibaba.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
References: <20220608005534.76789-1-yang.lee@linux.alibaba.com>
From:   Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <20220608005534.76789-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 6/8/22 8:55 AM, Yang Li wrote:
> Eliminate the following coccicheck warning:
> ./drivers/infiniband/hw/erdma/erdma_qp.c:254:3-4: Unneeded semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Reviewed-by: Cheng Xu <chengyou@linux.alibaba.com>

Thanks.


Jason,

BTW, are this and other two patches for erdma posted today parts of
the static checker reports which you mentioned in [1] ? If so, I think I
should re-post the v10 patches including the fixes ?

Thanks,
Cheng Xu

[1] https://lore.kernel.org/linux-rdma/20220606154754.GA645238@nvidia.com/
