Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F903C2D0E4
	for <linux-rdma@archiver.kernel.org>; Wed,  9 Dec 2020 00:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38AFA239E5
	for <linux-rdma@archiver.kernel.org>; Wed,  9 Dec 2020 00:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731928AbgLIA0D (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 8 Dec 2020 19:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731931AbgLIAZ7 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 8 Dec 2020 19:25:59 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6E1C0613CF;
        Tue,  8 Dec 2020 16:25:19 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 289F74D248DBF;
        Tue,  8 Dec 2020 16:25:19 -0800 (PST)
Date:   Tue, 08 Dec 2020 16:25:18 -0800 (PST)
Message-Id: <20201208.162518.612024256091904820.davem@davemloft.net>
To:     zhengyongjun3@huawei.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: simplify the return expression of
 mlx5_esw_offloads_pair()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201208135625.11872-1-zhengyongjun3@huawei.com>
References: <20201208135625.11872-1-zhengyongjun3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 08 Dec 2020 16:25:19 -0800 (PST)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>
Date: Tue, 8 Dec 2020 21:56:25 +0800

> Simplify the return expression.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Applied.

