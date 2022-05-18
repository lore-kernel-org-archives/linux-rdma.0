Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0967FC433F5
	for <linux-rdma@archiver.kernel.org>; Wed, 18 May 2022 13:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbiERNa1 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 18 May 2022 09:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237896AbiERNa1 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 18 May 2022 09:30:27 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E4E1BB110
        for <linux-rdma@vger.kernel.org>; Wed, 18 May 2022 06:30:25 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VDdqqcF_1652880621;
Received: from 192.168.0.25(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0VDdqqcF_1652880621)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 May 2022 21:30:23 +0800
Message-ID: <86bda5c4-6ad4-6f43-f097-593038bbfce1@linux.alibaba.com>
Date:   Wed, 18 May 2022 21:30:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH for-next v8 00/12] Elastic RDMA Adapter (ERDMA) driver
Content-Language: en-US
To:     jgg@ziepe.ca, dledford@redhat.com, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com,
        tonylu@linux.alibaba.com, BMT@zurich.ibm.com
References: <20220518015751.38156-1-chengyou@linux.alibaba.com>
From:   Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <20220518015751.38156-1-chengyou@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 5/18/22 9:57 AM, Cheng Xu wrote:
> Hello all,
> 
> This v8 patch set introduces the Elastic RDMA Adapter (ERDMA) driver,
> which released in Apsara Conference 2021 by Alibaba. The PR of ERDMA
> userspace provider has already been created [1].
> 

Please ignore this version, I'd send another version later to handle
erdma's ibdev and netdev more properly.

Thanks,
Cheng Xu
