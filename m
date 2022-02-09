Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DEC2C433F5
	for <linux-rdma@archiver.kernel.org>; Wed,  9 Feb 2022 09:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbiBIJ4O (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 9 Feb 2022 04:56:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234234AbiBIJ4O (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 9 Feb 2022 04:56:14 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED66EE03CD98;
        Wed,  9 Feb 2022 01:56:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V4-Z2K7_1644400457;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V4-Z2K7_1644400457)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 17:54:17 +0800
Date:   Wed, 9 Feb 2022 17:54:14 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v5 5/5] net/smc: Add global configure for auto
 fallback by netlink
Message-ID: <YgOPRh34nUWOqh2C@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1644323503.git.alibuda@linux.alibaba.com>
 <f54ee9f30898b998edf8f07dabccc84efaa2ab8b.1644323503.git.alibuda@linux.alibaba.com>
 <YgOKc5FW/JRmW1U6@TonyMac-Alibaba>
 <20fc8ef9-6cbc-ac1d-97ad-ab47a2874afd@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20fc8ef9-6cbc-ac1d-97ad-ab47a2874afd@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Feb 09, 2022 at 05:41:50PM +0800, D. Wythe wrote:
> I don't think this is necessary, since we already have socket options. Is
> there any scenario that the socket options and global switch can not cover?
> 
When transparently replacing the whole container's TCP connections, we
cannot touch the user's application, and have to replace their
connections to SMC. It is common for container environment, different
containers will run different applications.

Most of TCP knob is per net-namespace, it could be better for us to do
it from the beginning.

Thanks,
Tony Lu
