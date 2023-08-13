Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB59CC41513
	for <linux-rdma@archiver.kernel.org>; Sun, 13 Aug 2023 07:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjHMHdG (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 13 Aug 2023 03:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjHMHdF (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 13 Aug 2023 03:33:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB509F;
        Sun, 13 Aug 2023 00:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44C76618B8;
        Sun, 13 Aug 2023 07:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0174FC433C7;
        Sun, 13 Aug 2023 07:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691911987;
        bh=sHq2+uDYLi0Ctdo7hlHB3t4OF3giWNHNdLiy7ov1+4M=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=Y5zvZKE2JkSJDux1KO9+OIA2OmYGKfech4KuHbfaOmDv3nvsRMgNOneIOMYZ/M3+3
         yWMO3oybbOJDR9zHoH315CGEXraMsjP0hyBNQBqsRryWYbJkgp0GjRGBuD9uEG5jx/
         3DiiiObJUDO68wfSwEO7j1LDhESQpENIlJY7f0BfRN/oMRcuYAlN7zU/vf/0bwZRva
         JwXMx4Izf2DJ/t9I2C6C9XXAT+gMHolXbIX/qzTJcJFYQ/mRf4RrLEoFIDtS0MmMZo
         KT2x3nG0SFUYt8MBG/X3n8FtuFDLxC8g2PzlELuqw2t2w4Y6aVWKllGSJ2oVydhaMb
         K1rIxf1EqbcJQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     jgg@ziepe.ca, Yue Haibing <yuehaibing@huawei.com>
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20230809142718.42316-1-yuehaibing@huawei.com>
References: <20230809142718.42316-1-yuehaibing@huawei.com>
Subject: Re: [PATCH -next] rdma: Remove unused function declarations
Message-Id: <169191198150.24886.3112976531773136581.b4-ty@kernel.org>
Date:   Sun, 13 Aug 2023 10:33:01 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Wed, 09 Aug 2023 22:27:18 +0800, Yue Haibing wrote:
> Commit c2261dd76b54 ("RDMA/device: Add ib_device_set_netdev() as an alternative to get_netdev")
> declared but never implemented ib_device_netdev(), remove it.
> Commit 922a8e9fb2e0 ("RDMA: iWARP Connection Manager.") declared but never implemented
> iw_cm_unbind_qp() and iw_cm_get_qp().
> 
> 

Applied, thanks!

[1/1] rdma: Remove unused function declarations
      https://git.kernel.org/rdma/rdma/c/40cc695d633521

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
