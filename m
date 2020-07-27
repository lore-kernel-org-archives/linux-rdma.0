Return-Path: <SRS0=6I5V=BG=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B0FC433E0
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Jul 2020 17:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD0382073E
	for <linux-rdma@archiver.kernel.org>; Mon, 27 Jul 2020 17:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbgG0RLA (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 27 Jul 2020 13:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728835AbgG0RLA (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 27 Jul 2020 13:11:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01656C061794;
        Mon, 27 Jul 2020 10:11:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 65B1A1286DD39;
        Mon, 27 Jul 2020 09:54:14 -0700 (PDT)
Date:   Mon, 27 Jul 2020 10:10:59 -0700 (PDT)
Message-Id: <20200727.101059.1257161436665415755.davem@davemloft.net>
To:     Julia.Lawall@inria.fr
Cc:     saeedm@mellanox.com, kernel-janitors@vger.kernel.org,
        leon@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] net/mlx5: drop unnecessary list_empty
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595761112-11003-5-git-send-email-Julia.Lawall@inria.fr>
References: <1595761112-11003-1-git-send-email-Julia.Lawall@inria.fr>
        <1595761112-11003-5-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 09:54:14 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Julia Lawall <Julia.Lawall@inria.fr>
Date: Sun, 26 Jul 2020 12:58:29 +0200

> list_for_each_entry is able to handle an empty list.
> The only effect of avoiding the loop is not initializing the
> index variable.
> Drop list_empty tests in cases where these variables are not
> used.
> 
> Note that list_for_each_entry is defined in terms of list_first_entry,
> which indicates that it should not be used on an empty list.  But in
> list_for_each_entry, the element obtained by list_first_entry is not
> really accessed, only the address of its list_head field is compared
> to the address of the list head, so the list_first_entry is safe.
> 
> The semantic patch that makes this change is as follows (with another
> variant for the no brace case): (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Saeed, please pick this up.

Thank you.
