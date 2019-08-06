Return-Path: <SRS0=BMee=WC=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9809C433FF
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Aug 2019 20:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 871DD20818
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Aug 2019 20:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfHFUsv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 6 Aug 2019 16:48:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49582 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfHFUsv (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 6 Aug 2019 16:48:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A05ED1264D598;
        Tue,  6 Aug 2019 13:48:48 -0700 (PDT)
Date:   Tue, 06 Aug 2019 13:48:48 -0700 (PDT)
Message-Id: <20190806.134848.2232719643712591918.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     hslester96@gmail.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, leon@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx5e: Use refcount_t for refcount
From:   David Miller <davem@davemloft.net>
In-Reply-To: <aaf9680afe5c62d0cf71ff4382b66b3e4d735008.camel@mellanox.com>
References: <20190802164828.20243-1-hslester96@gmail.com>
        <aaf9680afe5c62d0cf71ff4382b66b3e4d735008.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 13:48:48 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 6 Aug 2019 20:42:56 +0000

> On Sat, 2019-08-03 at 00:48 +0800, Chuhong Yuan wrote:
>> refcount_t is better for reference counters since its
>> implementation can prevent overflows.
>> So convert atomic_t ref counters to refcount_t.
>> 
>> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
>> ---
>> Changes in v2:
>>   - Add #include.
>> 
> 
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> 
> Dave, up to you take it, or leave it to me :).

Please take it, thank you.
