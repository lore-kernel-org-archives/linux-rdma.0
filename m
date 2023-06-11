Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684C9C7EE23
	for <linux-rdma@archiver.kernel.org>; Sun, 11 Jun 2023 17:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjFKRa0 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 11 Jun 2023 13:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjFKRaZ (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Sun, 11 Jun 2023 13:30:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC33BD
        for <linux-rdma@vger.kernel.org>; Sun, 11 Jun 2023 10:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4127560FA8
        for <linux-rdma@vger.kernel.org>; Sun, 11 Jun 2023 17:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0481FC433EF;
        Sun, 11 Jun 2023 17:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686504623;
        bh=aTM6zEzeSB3E8tNtjp91XLDg1fb71d1/vuCTzvMBfJI=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=L8aZsqTs3cyN8laCcJ3gGj5CrI74eq6I5c4EXE9loJtfZOkvyvfFchnqLjT808mnf
         PzQ91R5URpMhRl/+/Ed9piGe0yf+lNA+CvvTEhph3atirJM6gCU+zVfjL2rDQuDnMh
         OaJHGdpHT52bWJactcM78gIaKKTh6tNRQE6/sc26cATqkcUGRwJ+0hyHRWai/kt05J
         T1Vu+/HVgAR1/sEsdGXdf916kl0qGgdZuc8CzJ3LeS7IyRJv7HS46YEfqorW5ZhtQk
         HwT+Xh12XuxNxW1IJm9PmEhDtPE62JAn8K5Nxtu6Jo7BphHtPIVHHd7llu8SOhRHR7
         HhelQjol6f76A==
From:   Leon Romanovsky <leon@kernel.org>
To:     selvin.xavier@broadcom.com, jgg@ziepe.ca, sagi@grimberg.me,
        Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Cc:     linux-rdma@vger.kernel.org
In-Reply-To: <20230606102531.162967-1-saravanan.vajravel@broadcom.com>
References: <20230606102531.162967-1-saravanan.vajravel@broadcom.com>
Subject: Re: [PATCH v3 for-rc 0/3] IB/isert Bug fixes in ib_isert
Message-Id: <168650461915.409055.4386732440058913162.b4-ty@kernel.org>
Date:   Sun, 11 Jun 2023 20:30:19 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Tue, 06 Jun 2023 03:25:28 -0700, Saravanan Vajravel wrote:
> Generic bug fixes to ib_isert
> 
> Regards,
> Saravanan Vajravel
> 
> v1 -> v2:
>  - Added Fixes tag to all patches
>  - Fixed compilation issue in first patch
> v2 -> v3:
>  - In second patch, limited mutex lock to list_del_init() only
>  - In third patch, corrected Fixes tag
> 
> [...]

Applied, thanks!

[1/3] IB/isert: Fix dead lock in ib_isert
      https://git.kernel.org/rdma/rdma/c/691b0480933f0c
[2/3] IB/isert: Fix possible list corruption in CMA handler
      https://git.kernel.org/rdma/rdma/c/7651e2d6c5b359
[3/3] IB/isert: Fix incorrect release of isert connection
      https://git.kernel.org/rdma/rdma/c/699826f4e30ab7

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
