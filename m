Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B1DC433F5
	for <linux-rdma@archiver.kernel.org>; Sat, 19 Mar 2022 08:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238598AbiCSI5C (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 19 Mar 2022 04:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiCSI5C (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sat, 19 Mar 2022 04:57:02 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F642D6562
        for <linux-rdma@vger.kernel.org>; Sat, 19 Mar 2022 01:55:40 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V7aIJJh_1647680137;
Received: from 30.236.17.167(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0V7aIJJh_1647680137)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 19 Mar 2022 16:55:38 +0800
Message-ID: <b9ea8456-c032-1d43-b238-2bd130af2a07@linux.alibaba.com>
Date:   Sat, 19 Mar 2022 16:55:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH for-next v4 07/12] RDMA/erdma: Add verbs header file
Content-Language: en-US
To:     Wenpeng Liang <liangwenpeng@huawei.com>, jgg@ziepe.ca,
        dledford@redhat.com
Cc:     leon@kernel.org, linux-rdma@vger.kernel.org,
        KaiShen@linux.alibaba.com, tonylu@linux.alibaba.com,
        BMT@zurich.ibm.com
References: <20220314064739.81647-1-chengyou@linux.alibaba.com>
 <20220314064739.81647-8-chengyou@linux.alibaba.com>
 <ed3059aa-0c30-84ff-97f4-ac3224f5a64b@huawei.com>
From:   Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <ed3059aa-0c30-84ff-97f4-ac3224f5a64b@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 3/18/22 7:46 PM, Wenpeng Liang wrote:
> On 2022/3/14 14:47, Cheng Xu wrote:
>> This header file defines the main structrues and functions used for RDMA
>> Verbs, including qp, cq, mr ucontext, etc,.
> 
> structrues -> structures?
> 

Will fix.

> <...>
>> +struct erdma_uqp {
>> +	struct erdma_mem sq_mtt;
>> +	struct erdma_mem rq_mtt;
>> +
>> +	dma_addr_t sq_db_info_dma_addr;
>> +	dma_addr_t rq_db_info_dma_addr;
>> +
>> +	struct erdma_user_dbrecords_page *user_dbr_page;
>> +
>> +	u32 rq_offset;
>> +};
> 
> A blank line is missing here.
> 

Will fix.

Thanks,
Cheng Xu

> Thanks,
> Wenpeng
> 
>> +struct erdma_kqp {
>> +	u16 sq_pi;
>> +	u16 sq_ci;
>> +
>> +	u16 rq_pi;
>> +	u16 rq_ci;
