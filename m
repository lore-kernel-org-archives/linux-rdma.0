Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A4AC001DF
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Aug 2023 18:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjHCSLy (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Aug 2023 14:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjHCSLs (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 3 Aug 2023 14:11:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A6F2719;
        Thu,  3 Aug 2023 11:11:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D92E361E56;
        Thu,  3 Aug 2023 18:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AB8C433C9;
        Thu,  3 Aug 2023 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691086306;
        bh=IsRDMEurSgruTHOOmrV+hF8ghyu+Q4Im5/V0AR7Pg8k=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=tPaZ82qS+DmKYBtpNtOY9TBL+32QrKH86QT1GUPcvS2+gBk81tVkqhSMS+5ej02Qg
         KmHQPhzf4qlkBDokqwHNO3wGz+JfaXKlTi20MCzbkpaNJb9ONyEI20hSRdUDWWC3cd
         sHgvBd4/R92GnM1uX+/xClBebg/8dptFU03ExrnqgOJNF3iBJxfrESAKtjx/HNK8Zs
         uBy7p2w5+VHN55wNZlYZdvpPf5lhyJcDGMJ2dEHlrdgSg9oVr2gDM7LpNPSNdiZjRa
         5iv6JtXKHtEF7QTXULWYamED7LCWwELohT+jcqf3DEvnPPUGpzkBdzFETVik3z3abv
         tS3DG2Az3DQhA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
In-Reply-To: <ZMpsQrZadBaJGkt4@work>
References: <ZMpsQrZadBaJGkt4@work>
Subject: Re: [PATCH][next] RDMA/irdma: Replace one-element array with
 flexible-array member
Message-Id: <169108630160.1408615.8996122913079845353.b4-ty@kernel.org>
Date:   Thu, 03 Aug 2023 21:11:41 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Wed, 02 Aug 2023 08:46:26 -0600, Gustavo A. R. Silva wrote:
> One-element and zero-length arrays are deprecated. So, replace
> one-element array in struct irdma_qvlist_info with flexible-array
> member.
> 
> A patch for this was sent a while ago[1]. However, it seems that, at
> the time, the changes were partially folded[2][3], and the actual
> flexible-array transformation was omitted. This patch fixes that.
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Replace one-element array with flexible-array member
      https://git.kernel.org/rdma/rdma/c/38313c6d2a02c2

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
