Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC03C001DE
	for <linux-rdma@archiver.kernel.org>; Sun, 30 Jul 2023 13:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjG3NAM (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 30 Jul 2023 09:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjG3NAL (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 30 Jul 2023 09:00:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC601AE
        for <linux-rdma@vger.kernel.org>; Sun, 30 Jul 2023 06:00:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E712E60C34
        for <linux-rdma@vger.kernel.org>; Sun, 30 Jul 2023 13:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9030C433C7;
        Sun, 30 Jul 2023 13:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690722008;
        bh=uhI9NsCVR5po5S9bYBTyvUIrGx+T7/YQVFL/EP7ick4=;
        h=From:To:In-Reply-To:References:Subject:Date:From;
        b=Dur5XOZOG/QFJti7YoL/9y+Xgfo3FGnoGEFtoKgR7OtWS3nKT6CnGFgnyHnMEQw0e
         dFDA54Ah45ikGXm7VCGpw2De2o97jNhDeXcUcWyXwmNGnsJfm15CozT2WbEHjAIWMV
         oH4TbVOflKrLlTkZPbWoG9imuplNn43r8mOU3+ep8qCmb9DQYSUUmElFvV9ykMbdUE
         Un6E/gS+zRSl/vTwrx53i+m3j1iU/FP5iOqmhcneX+WkoS7+OpVsCSYOIfaYZDKIQn
         8csaw7VVi8QZpc94xulI2IeTAPQIyX++8SCA/zZWWZRbIF5Eadii81WHMuiKM8vBPC
         M2xYqnzhbpeog==
From:   Leon Romanovsky <leon@kernel.org>
To:     yishaih@nvidia.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        Ruan Jinjie <ruanjinjie@huawei.com>
In-Reply-To: <20230728065139.3411703-1-ruanjinjie@huawei.com>
References: <20230728065139.3411703-1-ruanjinjie@huawei.com>
Subject: Re: [PATCH -next] RDMA/mlx: remove a lot of unnecessary NULL values
Message-Id: <169072200398.317742.5686453050227087426.b4-ty@kernel.org>
Date:   Sun, 30 Jul 2023 16:00:03 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Fri, 28 Jul 2023 14:51:39 +0800, Ruan Jinjie wrote:
> Ther are many pointers assigned first, which need not to be initialized, so
> remove the NULL assignment.
> 
> 

Applied, thanks!

[1/1] RDMA/mlx: remove a lot of unnecessary NULL values
      https://git.kernel.org/rdma/rdma/c/183b5cc943dc2c

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
