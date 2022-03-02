Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BC2C433F5
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Mar 2022 05:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235683AbiCBFt4 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbiCBFt4 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 2 Mar 2022 00:49:56 -0500
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3604B0C69;
        Tue,  1 Mar 2022 21:49:12 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V60zap9_1646200149;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V60zap9_1646200149)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Mar 2022 13:49:10 +0800
Date:   Wed, 2 Mar 2022 13:49:08 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: fix compile warning for smc_sysctl
Message-ID: <Yh8FVOQZ+nPN50D+@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220302034312.31168-1-dust.li@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302034312.31168-1-dust.li@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Mar 02, 2022 at 11:43:12AM +0800, Dust Li wrote:
> Fix build:
> 
>    In file included from net/smc/smc_sysctl.c:17:
> >> net/smc/smc_sysctl.h:23:5: warning: no previous prototype \
> 	for function 'smc_sysctl_init' [-Wmissing-prototypes]
>    int smc_sysctl_init(void)
>        ^
> 
> and
> 
> >> WARNING: modpost: vmlinux.o(.text+0x12ced2d): Section mismatch \
> in reference from the function smc_sysctl_exit() to the variable
> .init.data:smc_sysctl_ops
> The function smc_sysctl_exit() references
> the variable __initdata smc_sysctl_ops.
> This is often because smc_sysctl_exit lacks a __initdata
> annotation or the annotation of smc_sysctl_ops is wrong.
> 
> Fixes: 462791bbfa35 ("net/smc: add sysctl interface for SMC")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>

Thanks for the fixing.

Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
