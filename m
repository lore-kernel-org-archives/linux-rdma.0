Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CF5C05027
	for <linux-rdma@archiver.kernel.org>; Mon,  6 Feb 2023 12:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjBFMMO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 6 Feb 2023 07:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjBFMMM (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 6 Feb 2023 07:12:12 -0500
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AF2EC43;
        Mon,  6 Feb 2023 04:12:04 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Vb36paa_1675685520;
Received: from 30.221.149.210(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Vb36paa_1675685520)
          by smtp.aliyun-inc.com;
          Mon, 06 Feb 2023 20:12:01 +0800
Message-ID: <93bc1405-2f76-54b6-bae3-39da4542e618@linux.alibaba.com>
Date:   Mon, 6 Feb 2023 20:11:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [net-next v7 0/4] net/smc: optimize the parallelism of SMC-R
 connections
Content-Language: en-US
To:     Wenjia Zhang <wenjia@linux.ibm.com>, kgraul@linux.ibm.com,
        jaka@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1675326402-109943-1-git-send-email-alibuda@linux.alibaba.com>
 <273e8c67-fbb0-edd8-600f-512c1a6812f3@linux.ibm.com>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <273e8c67-fbb0-edd8-600f-512c1a6812f3@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org




On 2/6/23 7:06 PM, Wenjia Zhang wrote:
> 
> 
> On 02.02.23 09:26, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>

> This answer seems too late ;-)
> 
> I did some test as thoroughly as I can, it looks good to me.
> 
> Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>

Hi, wenjia

Thank you very much for your test. I'm very glad that you it passed.
I will resend those as soon as possible. (make confirm/delete rkey process concurrently)

Best wishes.
D. Wythe

