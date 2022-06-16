Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF0BC433EF
	for <linux-rdma@archiver.kernel.org>; Thu, 16 Jun 2022 03:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346612AbiFPDff (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 15 Jun 2022 23:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349302AbiFPDfd (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 15 Jun 2022 23:35:33 -0400
Received: from out199-13.us.a.mail.aliyun.com (out199-13.us.a.mail.aliyun.com [47.90.199.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C574424A5
        for <linux-rdma@vger.kernel.org>; Wed, 15 Jun 2022 20:35:31 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=chengyou@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VGVnd89_1655350527;
Received: from 30.43.105.121(mailfrom:chengyou@linux.alibaba.com fp:SMTPD_---0VGVnd89_1655350527)
          by smtp.aliyun-inc.com;
          Thu, 16 Jun 2022 11:35:28 +0800
Message-ID: <0542ee13-35bd-cadd-a6f3-cb62e7a1040a@linux.alibaba.com>
Date:   Thu, 16 Jun 2022 11:35:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH for-next v11 08/11] RDMA/erdma: Add connection management
 (CM) support
Content-Language: en-US
To:     Weihang Li <li.weihang93@gmail.com>, jgg@ziepe.ca, leon@kernel.org
Cc:     linux-rdma@vger.kernel.org, KaiShen@linux.alibaba.com,
        tonylu@linux.alibaba.com, BMT@zurich.ibm.com,
        dan.carpenter@oracle.com
References: <20220615015227.65686-1-chengyou@linux.alibaba.com>
 <20220615015227.65686-9-chengyou@linux.alibaba.com>
 <0ae9926f-fa76-82ca-c218-c16ca0601ec2@gmail.com>
From:   Cheng Xu <chengyou@linux.alibaba.com>
In-Reply-To: <0ae9926f-fa76-82ca-c218-c16ca0601ec2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org



On 6/16/22 10:59 AM, Weihang Li wrote:
> 

<...>
> 
> Hi, Cheng Xu
> 
> After modify qp to RTS, is that means this TCP stream is offloaded
> to the hardware, and the inbound TCP segments related to the TCP stream
> will not be received in the kernel stack where this driver is running.
> If yes, the ACK of mpa reply will never been revieced by the stack?

Actually, this depends on our infrastructure. ERDMA collaborates with
OVS module, which indeed decides the direction of packets. It makes sure
that packet from VM will be sent to VM, and packet from RDMA will be
sent to RDMA engine. So, the ACK from VM will always be sent to VM.

Thanks,
Cheng Xu


