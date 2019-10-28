Return-Path: <SRS0=4Nee=YV=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C7BCA9EC0
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Oct 2019 20:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CECD7218BA
	for <linux-rdma@archiver.kernel.org>; Mon, 28 Oct 2019 20:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387781AbfJ1UlX (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:41:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44696 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfJ1UlW (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 28 Oct 2019 16:41:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 20AB114B79F60;
        Mon, 28 Oct 2019 13:41:22 -0700 (PDT)
Date:   Mon, 28 Oct 2019 13:41:21 -0700 (PDT)
Message-Id: <20191028.134121.1161125360437050103.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     kvalo@codeaurora.org, trivial@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [trivial] net: Fix misspellings of "configure" and
 "configuration"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191024152201.29868-1-geert+renesas@glider.be>
References: <20191024152201.29868-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 13:41:22 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Thu, 24 Oct 2019 17:22:01 +0200

> Fix various misspellings of "configuration" and "configure".
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v2:
>   - Merge
>     [trivial] net/mlx5e: Spelling s/configuraiton/configuration/
>     [trivial] qed: Spelling s/configuraiton/configuration/
>   - Fix typo in subject,
>   - Extend with various other similar misspellings.

Applied to net-next.
