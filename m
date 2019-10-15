Return-Path: <SRS0=iMHv=YI=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8EAC10F14
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Oct 2019 17:58:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85B092067B
	for <linux-rdma@archiver.kernel.org>; Tue, 15 Oct 2019 17:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfJOR6x (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 15 Oct 2019 13:58:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37714 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfJOR6x (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 15 Oct 2019 13:58:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B7851504B4B3;
        Tue, 15 Oct 2019 10:58:52 -0700 (PDT)
Date:   Tue, 15 Oct 2019 10:58:52 -0700 (PDT)
Message-Id: <20191015.105852.994786197393612301.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        jakub.kicinski@netronome.com, geert@linux-m68k.org,
        uwe@kleine-koenig.org, talgi@mellanox.com, saeedm@mellanox.com,
        dledford@redhat.com, jgg@mellanox.com, leonro@mellanox.com,
        ogerlitz@mellanox.com, sagi@grimberg.me
Subject: Re: [PATCH] net: ethernet: broadcom: have drivers select DIMLIB as
 needed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <610f9277-adff-2f4b-1f44-8f41b6c3ccb5@infradead.org>
References: <610f9277-adff-2f4b-1f44-8f41b6c3ccb5@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 10:58:53 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Fri, 11 Oct 2019 21:03:33 -0700

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> NET_VENDOR_BROADCOM is intended to control a kconfig menu only.
> It should not have anything to do with code generation.
> As such, it should not select DIMLIB for all drivers under
> NET_VENDOR_BROADCOM.  Instead each driver that needs DIMLIB should
> select it (being the symbols SYSTEMPORT, BNXT, and BCMGENET).
> 
> Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1907021810220.13058@ramsan.of.borg/
> 
> Fixes: 4f75da3666c0 ("linux/dim: Move implementation to .c files")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied and queued up for -stable, thanks.
