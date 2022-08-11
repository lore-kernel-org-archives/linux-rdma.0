Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B19AC3F6B0
	for <linux-rdma@archiver.kernel.org>; Thu, 11 Aug 2022 05:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbiHKFOA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 11 Aug 2022 01:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiHKFN7 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 11 Aug 2022 01:13:59 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CACB86C1B;
        Wed, 10 Aug 2022 22:13:56 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VLxoqJb_1660194832;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VLxoqJb_1660194832)
          by smtp.aliyun-inc.com;
          Thu, 11 Aug 2022 13:13:53 +0800
Date:   Thu, 11 Aug 2022 13:13:51 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] net/smc: optimize the parallelism of
 SMC-R connections
Message-ID: <YvSQD8ddmHbnLlpU@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1660152975.git.alibuda@linux.alibaba.com>
 <20220810202845.164eb470@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810202845.164eb470@kernel.org>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Aug 10, 2022 at 08:28:45PM -0700, Jakub Kicinski wrote:
> On Thu, 11 Aug 2022 01:47:31 +0800 D. Wythe wrote:
> > From: "D. Wythe" <alibuda@linux.alibaba.com>
> > 
> > This patch set attempts to optimize the parallelism of SMC-R connections,
> > mainly to reduce unnecessary blocking on locks, and to fix exceptions that
> > occur after thoses optimization.
> 
> net-next is closed until Monday, please see the FAQ.
> 
> Also Al Viro complained about the SMC ULP:
> 
> https://lore.kernel.org/all/YutBc9aCQOvPPlWN@ZenIV/
> 
> I didn't see any responses, what the situation there?

Sorry for the late reply. I am working on it and will give out the
details as soon as possible.

Tony Lu
