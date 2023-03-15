Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7874FC61DA4
	for <linux-rdma@archiver.kernel.org>; Wed, 15 Mar 2023 08:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCOI1M (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 15 Mar 2023 04:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjCOI1M (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 15 Mar 2023 04:27:12 -0400
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5DE40C2;
        Wed, 15 Mar 2023 01:27:10 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vdvd8zw_1678868826;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Vdvd8zw_1678868826)
          by smtp.aliyun-inc.com;
          Wed, 15 Mar 2023 16:27:07 +0800
Date:   Wed, 15 Mar 2023 16:27:05 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kai <KaiShen@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v4] net/smc: Use percpu ref for wr tx reference
Message-ID: <ZBGBWafISbzBapnq@TONYMAC-ALIBABA.local>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20230313060425.115939-1-KaiShen@linux.alibaba.com>
 <20230315003440.23674405@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315003440.23674405@kernel.org>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Mar 15, 2023 at 12:34:40AM -0700, Jakub Kicinski wrote:
> On Mon, 13 Mar 2023 06:04:25 +0000 Kai wrote:
> > Signed-off-by: Kai <KaiShen@linux.alibaba.com>
> 
> Kai Shen ?
> 
> > 
> 
> You're missing a --- separator here, try to apply this patch with 
> git am :/

There is another commit ce7ca794712f ("net/smc: fix fallback failed
while sendmsg with fastopen") that has been merged that also has this
problem. Maybe we can add some scripts to check this?

> 
> > v1->v2:
> > - Modify patch prefix
> > 
> > v2->v3:
> > - Make wr_reg_refcnt a percpu one as well
> > - Init percpu ref with 0 flag instead of ALLOW_REINIT flag
> > 
> > v3->v4:
> > - Update performance data, this data may differ from previous data
> >   as I ran cases on other machines
> > ---
