Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B936EE49A5
	for <linux-rdma@archiver.kernel.org>; Mon, 21 Aug 2023 07:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbjHUHlL (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 21 Aug 2023 03:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjHUHlL (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 21 Aug 2023 03:41:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1901FBB
        for <linux-rdma@vger.kernel.org>; Mon, 21 Aug 2023 00:41:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A75B96118C
        for <linux-rdma@vger.kernel.org>; Mon, 21 Aug 2023 07:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D11FC433C8;
        Mon, 21 Aug 2023 07:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692603669;
        bh=rjZk+35mVDG8IdUKR3NdNcbbzxrd+iq3dCwcj/CNOfs=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=XP8kkOKFEwton9rxRc21heGWD3nGaqWlPQS7ad49MC3MLtxHxxTtM2eZv1W4eIdCk
         ILgZoPsaGXfc/8+lFvrcb7niXirD0VXQrVCEKoaGUjgBDmMhfbOX4UHSwONLFOve5D
         KuNoGlPOvcYN92JfDvsW1Fwy4QSa5t97pxS5hnPqPi/UJDxE6EvDYKE/3akJKcWCaD
         TlFKzaSLtLlVnUnEIzuEp4wuFkrYULmWggYvl67j7EG8EmzGhayNTrbW1uMUwiJNif
         cKCH+SO02gVzX4mrPhv7nWEF5eWKgHH+ZU9HvZlZfZFeHKu20dgqI05vsgXEaLDwMf
         8mWzIcVFKfkSQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc:     kernel test robot <lkp@intel.com>, linux-rdma@vger.kernel.org,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Leon Romanovsky <leon@kernel.org>
In-Reply-To: <4b22c385f1b68590ace8f82f2985d14b20999432.1692539554.git.leon@kernel.org>
References: <4b22c385f1b68590ace8f82f2985d14b20999432.1692539554.git.leon@kernel.org>
Subject: Re: [PATCH rdma-next] RDMA/bnxt_re: Fix kernel doc errors
Message-Id: <169260366520.61271.12250490294568613508.b4-ty@kernel.org>
Date:   Mon, 21 Aug 2023 10:41:05 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Sun, 20 Aug 2023 16:53:15 +0300, Leon Romanovsky wrote:
> Fix set of the following errors due to use of wrong kernel doc format
> to describe function parameters:
> 
> drivers/infiniband/hw/bnxt_re/qplib_rcfw.c:68: warning: Function parameter or member 'rcfw'
> 	not described in '__wait_for_resp'
> 
> 
> [...]

Applied, thanks!

[1/1] RDMA/bnxt_re: Fix kernel doc errors
      https://git.kernel.org/rdma/rdma/c/c6c0052df25ab9

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
