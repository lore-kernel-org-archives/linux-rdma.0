Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586E7C433FE
	for <linux-rdma@archiver.kernel.org>; Tue, 22 Nov 2022 14:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiKVOWl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 22 Nov 2022 09:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233953AbiKVOWd (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 22 Nov 2022 09:22:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7FCA463
        for <linux-rdma@vger.kernel.org>; Tue, 22 Nov 2022 06:22:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A2EFB81980
        for <linux-rdma@vger.kernel.org>; Tue, 22 Nov 2022 14:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7C4C433D6;
        Tue, 22 Nov 2022 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669126948;
        bh=xy0G6JuYzmbgnlWZbgXzGDIrQu/d3+ZXjSfw5mkT8C8=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=ZQePRR0oCx9h/jCdmgC47NaW6zZZMMnGcS7eOdroCf5P4gq8FVhPplHNMTVBNag9K
         HmbUZDMjlR4J0y1QSBfluKHLNRsSuqjl9Jghdipnzbs3JBkTiuuIuqsQs1dch0wdKj
         gKPmrUTwNIfe7Y3y+0HQdhjTZyvIQkanT/ZosAB33OKd2FVe3XieXODelX1WqTLMVC
         Mn0ocum1ek2fdSHLYthm58A3cnVUdHFB89/3QwMtqp7P6ttkfTthnRhMm7ABuNB6qH
         LNBqLHLrt7MQFJZ5TltEaj9nlWowtTEZAFixpSXtq2W8uZUJXfCiNhMEVkikIJoYTq
         jAOQMAnh+f+xQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     linux-rdma@vger.kernel.org, liangwenpeng@huawei.com,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        xuhaoyue1@hisilicon.com
Cc:     liweihang@huawei.com, wangxi11@huawei.com, jgg@ziepe.ca,
        yuehaibing@huawei.com, chenglang@huawei.com, weiyongjun1@huawei.com
In-Reply-To: <20221119070834.48502-1-shaozhengchao@huawei.com>
References: <20221119070834.48502-1-shaozhengchao@huawei.com>
Subject: Re: [PATCH] RDMA/hns: fix memory leak in hns_roce_alloc_mr()
Message-Id: <166912694444.318357.5851828031209525457.b4-ty@kernel.org>
Date:   Tue, 22 Nov 2022 16:22:24 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-87e0e
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sat, 19 Nov 2022 15:08:34 +0800, Zhengchao Shao wrote:
> When hns_roce_mr_enable() failed in hns_roce_alloc_mr(), mr_key is not
> released. Compiled test only.
> 
> 

Applied, thanks!

[1/1] RDMA/hns: fix memory leak in hns_roce_alloc_mr()
      https://git.kernel.org/rdma/rdma/c/a115aa00b18f7b

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
