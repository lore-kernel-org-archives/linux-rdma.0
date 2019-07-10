Return-Path: <SRS0=nSk8=VH=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D07C73C6D
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jul 2019 05:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC2D120651
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Jul 2019 05:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfGJFhJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 10 Jul 2019 01:37:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50402 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfGJFhJ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 10 Jul 2019 01:37:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4101C13E9F129;
        Tue,  9 Jul 2019 22:37:08 -0700 (PDT)
Date:   Tue, 09 Jul 2019 22:36:57 -0700 (PDT)
Message-Id: <20190709.223657.1108624224137142530.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     saeedm@mellanox.com, leon@kernel.org, borisp@mellanox.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        ndesaulniers@google.com
Subject: Re: [PATCH v2] net/mlx5e: Refactor switch statements to avoid
 using uninitialized variables
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190710044748.3924-1-natechancellor@gmail.com>
References: <20190708231154.89969-1-natechancellor@gmail.com>
        <20190710044748.3924-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 22:37:08 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


I applied your simpler addition of the return statement so that I could
get the net-next pull request out tonight, just FYI...
