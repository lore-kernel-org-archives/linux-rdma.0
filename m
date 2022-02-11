Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D574C433F5
	for <linux-rdma@archiver.kernel.org>; Fri, 11 Feb 2022 02:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244012AbiBKCqp (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 10 Feb 2022 21:46:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241955AbiBKCqp (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 10 Feb 2022 21:46:45 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C545F5E;
        Thu, 10 Feb 2022 18:46:44 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V46pEgn_1644547601;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V46pEgn_1644547601)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 11 Feb 2022 10:46:42 +0800
Date:   Fri, 11 Feb 2022 10:46:40 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v7 5/5] net/smc: Add global configure for
 handshake limitation by netlink
Message-ID: <YgXOECtXYJnsWLDd@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1644481811.git.alibuda@linux.alibaba.com>
 <d8bb3cbf1c532d5cf8048c67ccbf0b87664a00f4.1644481811.git.alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8bb3cbf1c532d5cf8048c67ccbf0b87664a00f4.1644481811.git.alibuda@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Feb 10, 2022 at 05:11:38PM +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> Although we can control SMC handshake limitation through socket options,
> which means that applications who need it must modify their code. It's
> quite troublesome for many existing applications. This patch modifies
> the global default value of SMC handshake limitation through netlink,
> providing a way to put constraint on handshake without modifies any code
> for applications.
> 
> Suggested-by: Tony Lu <tonylu@linux.alibaba.com>
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>

This patch looks good to me. This patch set starts to solve the problem
that the SMC connection performance is not good enough.

Thank you,
Tony Lu
