Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B182DCDB482
	for <linux-rdma@archiver.kernel.org>; Thu, 19 Oct 2023 06:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbjJSGce (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 19 Oct 2023 02:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbjJSGcd (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 19 Oct 2023 02:32:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F99BBE
        for <linux-rdma@vger.kernel.org>; Wed, 18 Oct 2023 23:32:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5510BC433C7;
        Thu, 19 Oct 2023 06:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697697152;
        bh=WRDMEkeRE7rYVrLw4lAi6MnKcVIDo0/UZepy27FXOAQ=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=iJy1ymd7uhkIknGmGhEs/TmloS0f0TZPppx+K3ioNYGDnGdDY/a540a7DL1l7wQAn
         8SiPDxgFWAxUTj6feNFro4JtWrcB1pirCfq8/7j4u8aHSnMswefbo88qpfRRDulxhG
         n0M2/CBPSVHZ+gVCKwurtP1akd/cwznnmgw3fEYwrzB1B6L53Ts40RaVPY2k0Ub2Jg
         SPC1wD5ySoV2S5HU8AEjJ4xaQmzLTrs1/brpwoZSiHsszRuo7aMuGD2Xo8vMYl4ogZ
         8/OeLUCjDnPzaUsWsy7v7jyjEnlEtQsusBGqfPtAZmuQoOQ4NxFuS4Kmmmo3Xj+hZj
         ory5RZ7mFE28w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc:     Patrisious Haddad <phaddad@nvidia.com>, linux-rdma@vger.kernel.org
In-Reply-To: <90398be70a9d23d2aa9d0f9fd11d2c264c1be534.1696848201.git.leon@kernel.org>
References: <90398be70a9d23d2aa9d0f9fd11d2c264c1be534.1696848201.git.leon@kernel.org>
Subject: Re: [PATCH rdma-next] RDMA/core: Add support to set privileged QKEY parameter
Message-Id: <169769714759.2016184.7321591466660624597.b4-ty@kernel.org>
Date:   Thu, 19 Oct 2023 09:32:27 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Mon, 09 Oct 2023 13:43:58 +0300, Leon Romanovsky wrote:
> Add netlink command that enables/disables privileged QKEY by default.
> 
> It is disabled by default, since according to IB spec only privileged
> users are allowed to use privileged QKEY.
> According to the IB specification rel-1.6, section 3.5.3:
> "QKEYs with the most significant bit set are considered controlled
> QKEYs, and a HCA does not allow a consumer to arbitrarily specify a
> controlled QKEY."
> 
> [...]

Applied, thanks!

[1/1] RDMA/core: Add support to set privileged QKEY parameter
      https://git.kernel.org/rdma/rdma/c/465d6b42f1a3b8

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
