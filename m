Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B9CBC4332F
	for <linux-rdma@archiver.kernel.org>; Mon, 13 Nov 2023 08:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbjKMIjV (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 13 Nov 2023 03:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbjKMIjU (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 13 Nov 2023 03:39:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5206610EC
        for <linux-rdma@vger.kernel.org>; Mon, 13 Nov 2023 00:39:17 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75469C433C7;
        Mon, 13 Nov 2023 08:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699864757;
        bh=uBhBQ7MMyj6BkkkbzmqbnntIKcSdxUmKjeRhih/37DI=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=TW+8qALIbU5hkRwOu4M0zuEbIpInMlUPtcYBEKCnVLAC6HFQBFyRqMl29rNio7cPr
         e2KCHDpBn2B1xr6sjYUwtSGblL2MYLcjhKQB2oD01S1u1RSHnB51Hqpd2Ih/21mvMU
         5rBouiDwu2dxiEk40qd9dA6Hus4zG5YZO95cd7Bs5V53wjt/pR3jHF4SqvFUA3ANoS
         420IFVhJba1UEyAb7Q21djywpUY4pjXxfVChhnTcMGdRRsrl3NjaWu/QKTHfyiP3AD
         DYogZc9DniccyP2n+VsSGZICHMudrdouS3gX0un6S+X2j/KyYhyZ6mV6sL1LFw4EcQ
         DweoGxCrsksCA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
In-Reply-To: <20231029045839.154071-1-ebiggers@kernel.org>
References: <20231029045839.154071-1-ebiggers@kernel.org>
Subject: Re: [PATCH] RDMA/siw: use crypto_shash_digest() in siw_qp_prepare_tx()
Message-Id: <169986475332.283834.2146910872748586139.b4-ty@kernel.org>
Date:   Mon, 13 Nov 2023 10:39:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Sat, 28 Oct 2023 21:58:39 -0700, Eric Biggers wrote:
> Simplify siw_qp_prepare_tx() by using crypto_shash_digest() instead of
> an init+update+final sequence.  This should also improve performance.
> 
> 

Applied, thanks!

[1/1] RDMA/siw: use crypto_shash_digest() in siw_qp_prepare_tx()
      https://git.kernel.org/rdma/rdma/c/9aac6c05a56289

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
