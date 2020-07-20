Return-Path: <SRS0=DhTo=A7=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 055F3C433E0
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Jul 2020 01:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB05A20B1F
	for <linux-rdma@archiver.kernel.org>; Mon, 20 Jul 2020 01:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgGTBPB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 19 Jul 2020 21:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgGTBPB (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 19 Jul 2020 21:15:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AA2C0619D2;
        Sun, 19 Jul 2020 18:15:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A812B128464A9;
        Sun, 19 Jul 2020 18:15:00 -0700 (PDT)
Date:   Sun, 19 Jul 2020 18:15:00 -0700 (PDT)
Message-Id: <20200719.181500.700026178439001994.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     linux-kernel@vger.kernel.org, santosh.shilimkar@oracle.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] net: rds: rdma_transport.h: delete duplicated word
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200719180824.12014-1-rdunlap@infradead.org>
References: <20200719180824.12014-1-rdunlap@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jul 2020 18:15:00 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Sun, 19 Jul 2020 11:08:24 -0700

> Delete the doubled word "be" in a comment.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied.
