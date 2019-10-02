Return-Path: <SRS0=/rP3=X3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9ECC352AA
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 15:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F9112133F
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 15:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfJBPIm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Oct 2019 11:08:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfJBPIm (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 2 Oct 2019 11:08:42 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE8EE14BBED93;
        Wed,  2 Oct 2019 08:08:41 -0700 (PDT)
Date:   Wed, 02 Oct 2019 11:08:41 -0400 (EDT)
Message-Id: <20191002.110841.1635125794151710562.davem@davemloft.net>
To:     valex@mellanox.com
Cc:     mkubecek@suse.cz, saeedm@mellanox.com, leon@kernel.org,
        bp@alien8.de, stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] mlx5: avoid 64-bit division in
 dr_icm_pool_mr_create()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <57dc9ea7-e925-e8e8-af71-35326bb5c673@mellanox.com>
References: <20191002121241.D74DAE04C7@unicorn.suse.cz>
        <57dc9ea7-e925-e8e8-af71-35326bb5c673@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 08:08:42 -0700 (PDT)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>
Date: Wed, 2 Oct 2019 14:58:44 +0000

> On 10/2/2019 3:12 PM, Michal Kubecek wrote:
>> Recently added code introduces 64-bit division in dr_icm_pool_mr_create()
>> so that build on 32-bit architectures fails with
>>
>>    ERROR: "__umoddi3" [drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.ko] undefined!
>>
>> As the divisor is always a power of 2, we can use bitwise operation
>> instead.
>>
>> Fixes: 29cf8febd185 ("net/mlx5: DR, ICM pool memory allocator")
>> Reported-by: Borislav Petkov <bp@alien8.de>
>> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
 ...
> Align diff is power of 2,  looks good to me.
> Thanks for fixing it Michal.

I'll just apply this directly, thanks everyone.

