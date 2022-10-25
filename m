Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96BC0C38A2D
	for <linux-rdma@archiver.kernel.org>; Tue, 25 Oct 2022 07:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiJYHhw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 25 Oct 2022 03:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiJYHhu (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 25 Oct 2022 03:37:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D209EC2C87;
        Tue, 25 Oct 2022 00:37:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92684B81BB6;
        Tue, 25 Oct 2022 07:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A15C433C1;
        Tue, 25 Oct 2022 07:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666683465;
        bh=1yX3XLwCIhZx3uwra6UtSiNAmlaJnOcsv2QPETxZ664=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=K1rSMc7GcLUQDeO+5XxekX7xVKwvnjKfu9tgSuK5olqF9l8nkCZ9H1WtdD68cd056
         LDImUXXHHNXee0P6/mkk59g+8lozGFObp4EiioJN8Ctm5hJjskhKyE2UsaK+fzrBOS
         M766NzPdjJ15Zq4sXNik7gkYMEgUIr91M7lNHXxrJCerElfYPnjohbYmARV2zIBRKN
         foCIlet/wryE4Mp7LyZi5IkS4a0STzGRRgh0XF1suIfetpIAjHtheudgt7tCKmvJif
         98FgSODnbFdrG5Kq9bNpPeLM6ZlXNGmXHGeYhTaGkja8uxqdHUVAehaqJyGjaSRbYV
         QlC7rAx/dNVEA==
From:   Leon Romanovsky <leon@kernel.org>
To:     linux-kernel@vger.kernel.org,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        linux-rdma@vger.kernel.org
Cc:     wsa+renesas@sang-engineering.com, dledford@redhat.com,
        matanb@mellanox.com, avihaih@nvidia.com,
        penguin-kernel@I-love.SAKURA.ne.jp, jgg@ziepe.ca, raeds@nvidia.com
In-Reply-To: <20221025024146.109137-1-chenzhongjin@huawei.com>
References: <20221025024146.109137-1-chenzhongjin@huawei.com>
Subject: Re: [PATCH] RDMA/core: Fix null-ptr-deref in ib_core_cleanup()
Message-Id: <166668346207.75287.12802762328335692637.b4-ty@kernel.org>
Date:   Tue, 25 Oct 2022 10:37:42 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-87e0e
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 25 Oct 2022 10:41:46 +0800, Chen Zhongjin wrote:
> KASAN reported a null-ptr-deref error:
> 
> KASAN: null-ptr-deref in range [0x0000000000000118-0x000000000000011f]
> CPU: 1 PID: 379
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
> RIP: 0010:destroy_workqueue+0x2f/0x740
> RSP: 0018:ffff888016137df8 EFLAGS: 00000202
> ...
> Call Trace:
>  <TASK>
>  ib_core_cleanup+0xa/0xa1 [ib_core]
>  __do_sys_delete_module.constprop.0+0x34f/0x5b0
>  do_syscall_64+0x3a/0x90
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fa1a0d221b7
> ...
>  </TASK>
> 
> [...]

Applied, thanks!

[1/1] RDMA/core: Fix null-ptr-deref in ib_core_cleanup()
      https://git.kernel.org/rdma/rdma/c/ad9394a3da3399

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
