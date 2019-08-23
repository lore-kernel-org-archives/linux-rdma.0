Return-Path: <SRS0=sfWj=WT=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A84D1C3A5A2
	for <linux-rdma@archiver.kernel.org>; Fri, 23 Aug 2019 22:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84AF320850
	for <linux-rdma@archiver.kernel.org>; Fri, 23 Aug 2019 22:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394058AbfHWWSK (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 23 Aug 2019 18:18:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38572 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392604AbfHWWSK (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 23 Aug 2019 18:18:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD44F1543CF90;
        Fri, 23 Aug 2019 15:18:09 -0700 (PDT)
Date:   Fri, 23 Aug 2019 15:18:09 -0700 (PDT)
Message-Id: <20190823.151809.442664848668672070.davem@davemloft.net>
To:     cai@lca.pw
Cc:     saeedm@mellanox.com, leon@kernel.org, moshe@mellanox.com,
        ferasda@mellanox.com, eranbe@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: fix a -Wstringop-truncation warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566590183-9898-1-git-send-email-cai@lca.pw>
References: <1566590183-9898-1-git-send-email-cai@lca.pw>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 15:18:10 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


Saeed, I assume I'll get this from you.
