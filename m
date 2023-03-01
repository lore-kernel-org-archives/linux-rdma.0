Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0F6C6FA8E
	for <linux-rdma@archiver.kernel.org>; Wed,  1 Mar 2023 02:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCACmG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 28 Feb 2023 21:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCACmF (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 28 Feb 2023 21:42:05 -0500
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F001837554;
        Tue, 28 Feb 2023 18:42:01 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VclalNq_1677638517;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VclalNq_1677638517)
          by smtp.aliyun-inc.com;
          Wed, 01 Mar 2023 10:41:58 +0800
Date:   Wed, 1 Mar 2023 10:41:57 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 0/4] net/smc: Introduce BPF injection
 capability
Message-ID: <Y/67dZ8X+VoOi10b@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <1677576294-33411-1-git-send-email-alibuda@linux.alibaba.com>
 <20230228150051.4eeaa121@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228150051.4eeaa121@kernel.org>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Feb 28, 2023 at 03:00:51PM -0800, Jakub Kicinski wrote:
> On Tue, 28 Feb 2023 17:24:50 +0800 D. Wythe wrote:
> > From: "D. Wythe" <alibuda@linux.alibaba.com>
> > 
> > This patches attempt to introduce BPF injection capability for SMC,
> > and add selftest to ensure code stability.
> 
> What happened to fixing the issues Al pointed out long, long time ago?
> 
> https://lore.kernel.org/all/YutBc9aCQOvPPlWN@ZenIV/

Actually, this patch set is going to replace the patch of TCP ULP for
SMC. If this patch set is accepted, I am going to revert that patch.

For the reasons, the TCP ULP for SMC doesn't use wildly. It's not
possible to know which applications are suitable to be replaced with
SMC. But it's easier to detect the behavior of applications and
determine whether to replace applications with SMC. And this patch set
is going to fallback to TCP by behavior with eBPF.

So this is the _fix_ for that patch.

Thank you,
Tony Lu
