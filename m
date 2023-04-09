Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66D4C77B61
	for <linux-rdma@archiver.kernel.org>; Sun,  9 Apr 2023 10:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjDIKGj (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 9 Apr 2023 06:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDIKGi (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 9 Apr 2023 06:06:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1F8269D
        for <linux-rdma@vger.kernel.org>; Sun,  9 Apr 2023 03:06:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D694260B80
        for <linux-rdma@vger.kernel.org>; Sun,  9 Apr 2023 10:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE26AC433EF;
        Sun,  9 Apr 2023 10:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681034797;
        bh=4OhLfeDL9FHBkVUqB7KDElgcH9JTZZB7hjB1yFzlEUM=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=gX1NPFUqsljqfOTbwcPBERNnzE7Pcl6xu5FPWCSOkLguW2Q0jzOdm/laOEehjmWbf
         gvpmNLDpAzwQHblYQclPK30UbVGi957WycQg6p89G/LktOJxOGqNWbqR8jS+G8Na02
         hVBj59uy9Y3x75DoKRskI66N2Toq3qESqK2PQZBj9N3Bd5MvhnvU3S99gLbLkcdYZK
         Na8qkTKVGWI8eHNbNSU6iXpO9zlEVtUjHQvR4wOAufwcVPxLDoiXLWK9yYCdq2/VgE
         H5m5L1/tWcpgV4YKKwD/E1Xh6TVXus2PGTswZQ7FPHSfm1mJnhFR7CYt4zN9egE3RP
         SxsLxbcleRNaA==
From:   Leon Romanovsky <leon@kernel.org>
To:     jgg@ziepe.ca, Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Cc:     linux-rdma@vger.kernel.org,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
In-Reply-To: <20230406042549.507328-1-saravanan.vajravel@broadcom.com>
References: <20230406042549.507328-1-saravanan.vajravel@broadcom.com>
Subject: Re: [PATCH v2 for-rc] RDMA/srpt: Add a check for valid 'mad_agent' pointer
Message-Id: <168103479299.166000.2927805873123388114.b4-ty@kernel.org>
Date:   Sun, 09 Apr 2023 13:06:32 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Wed, 05 Apr 2023 21:25:49 -0700, Saravanan Vajravel wrote:
> When unregistering MAD agent, srpt module has a non-null check
> for 'mad_agent' pointer before invoking ib_unregister_mad_agent().
> This check can pass if 'mad_agent' variable holds an error value.
> The 'mad_agent' can have an error value for a short window when
> srpt_add_one() and srpt_remove_one() is executed simultaneously.
> 
> In srpt module, added a valid pointer check for 'sport->mad_agent'
> before unregistering MAD agent.
> 
> [...]

Applied, thanks!

[1/1] RDMA/srpt: Add a check for valid 'mad_agent' pointer
      https://git.kernel.org/rdma/rdma/c/eca5cd9474cd26

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
