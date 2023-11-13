Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E019DC4167D
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Nov 2023 03:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbjKMDpF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 12 Nov 2023 22:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjKMDpF (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 12 Nov 2023 22:45:05 -0500
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89451729;
        Sun, 12 Nov 2023 19:45:00 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VwBn65N_1699847097;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0VwBn65N_1699847097)
          by smtp.aliyun-inc.com;
          Mon, 13 Nov 2023 11:44:58 +0800
Date:   Mon, 13 Nov 2023 11:44:57 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, wintera@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v1] net/smc: avoid data corruption caused by decline
Message-ID: <20231113034457.GA121324@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <1699436909-22767-1-git-send-email-alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1699436909-22767-1-git-send-email-alibuda@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Nov 08, 2023 at 05:48:29PM +0800, D. Wythe wrote:
>From: "D. Wythe" <alibuda@linux.alibaba.com>
>
>We found a data corruption issue during testing of SMC-R on Redis
>applications.
>
>The benchmark has a low probability of reporting a strange error as
>shown below.
>
>"Error: Protocol error, got "\xe2" as reply type byte"
>
>Finally, we found that the retrieved error data was as follows:
>
>0xE2 0xD4 0xC3 0xD9 0x04 0x00 0x2C 0x20 0xA6 0x56 0x00 0x16 0x3E 0x0C
>0xCB 0x04 0x02 0x01 0x00 0x00 0x20 0x00 0x00 0x00 0x00 0x00 0x00 0x00
>0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0xE2
>
>It is quite obvious that this is a SMC DECLINE message, which means that
>the applications received SMC protocol message.
>We found that this was caused by the following situations:
>
>client			server
>	   proposal
>	------------->
>	   accept
>	<-------------
>	   confirm
>	------------->
>wait confirm
>
>	 failed llc confirm
>	    x------
>(after 2s)timeout
>			wait rsp
>
>wait decline
>
>(after 1s) timeout
>			(after 2s) timeout
>	    decline
>	-------------->
>	    decline
>	<--------------
>
>As a result, a decline message was sent in the implementation, and this
>message was read from TCP by the already-fallback connection.
>
>This patch double the client timeout as 2x of the server value,
>With this simple change, the Decline messages should never cross or
>collide (during Confirm link timeout).
>
>This issue requires an immediate solution, since the protocol updates
>involve a more long-term solution.
>
>Fixes: 0fb0b02bd6fd ("net/smc: adapt SMC client code to use the LLC flow")
>Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
>---
> net/smc/af_smc.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>index abd2667..5b91f55 100644
>--- a/net/smc/af_smc.c
>+++ b/net/smc/af_smc.c
>@@ -599,7 +599,7 @@ static int smcr_clnt_conf_first_link(struct smc_sock *smc)
> 	int rc;
> 
> 	/* receive CONFIRM LINK request from server over RoCE fabric */
>-	qentry = smc_llc_wait(link->lgr, NULL, SMC_LLC_WAIT_TIME,
>+	qentry = smc_llc_wait(link->lgr, NULL, 2 * SMC_LLC_WAIT_TIME,
> 			      SMC_LLC_CONFIRM_LINK);

It may be difficult for people to understand why LLC_WAIT_TIME is
different, especially without any comments explaining its purpose.
People are required to use git to find the reason, which I believe is
not conducive to easy maintenance.

Best regards,
Dust



> 	if (!qentry) {
> 		struct smc_clc_msg_decline dclc;
>-- 
>1.8.3.1
