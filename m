Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC81BC001DE
	for <linux-rdma@archiver.kernel.org>; Mon, 31 Jul 2023 07:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjGaHmE (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 31 Jul 2023 03:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjGaHmA (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 31 Jul 2023 03:42:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89EBB2;
        Mon, 31 Jul 2023 00:41:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D24A60F4D;
        Mon, 31 Jul 2023 07:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4073EC433C7;
        Mon, 31 Jul 2023 07:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690789318;
        bh=nKEbD8eSLXpzWcsAbvuZ7Gnjw2FwxIoFI2vEY1JlN74=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=TlitBY7ePjpw186uUTOis32pmfSrTQSyg/cI0FYzY2jcLizChxWJQZUSDFV4UypMT
         G6kJHU8dAwjNZ2VlD+SDvrW9C1W8ElWZ4R3R+qeCnnrAk0y4Ep0v4yCTv9+BkfoehA
         cMbIZXR3zhQcE5/hy7AY8RrJ5LDTKgdCpScQpV5Fk3cEk5XMMLRmR4SEzFoDHBdtBG
         XnVNn648bIomG8FOQB9Lfv0oPYI2K9R/1N7grkjVfxRevO9S0KsqllO670C4NP9coh
         qUM9hcXHDa33uQYE6aZ1vC10o4Jl/C+C7uMBUZnPx6NS7Ij0NKcQNSXV/FIzithUVb
         jia9hJBFTF8ag==
From:   Leon Romanovsky <leon@kernel.org>
To:     mustafa.ismail@intel.com, shiraz.saleem@intel.com, jgg@ziepe.ca,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Cc:     Abaci Robot <abaci@linux.alibaba.com>
In-Reply-To: <20230731015915.34867-1-yang.lee@linux.alibaba.com>
References: <20230731015915.34867-1-yang.lee@linux.alibaba.com>
Subject: Re: [PATCH -next] RDMA/irdma: Fix one kernel-doc comment
Message-Id: <169078931544.92919.1279214592846732486.b4-ty@kernel.org>
Date:   Mon, 31 Jul 2023 10:41:55 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Mon, 31 Jul 2023 09:59:15 +0800, Yang Li wrote:
> Remove description of @free_hwcqp in irdma_destroy_cqp().
> to silence the warning:
> 
> drivers/infiniband/hw/irdma/hw.c:580: warning: Excess function parameter 'free_hwcqp' description in 'irdma_destroy_cqp'
> 
> 

Applied, thanks!

[1/1] RDMA/irdma: Fix one kernel-doc comment
      https://git.kernel.org/rdma/rdma/c/d43ea9c3d52f2e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
