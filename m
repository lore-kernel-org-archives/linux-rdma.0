Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0418FC74A44
	for <linux-rdma@archiver.kernel.org>; Tue, 14 Mar 2023 11:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjCNLwB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 14 Mar 2023 07:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjCNLwA (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 14 Mar 2023 07:52:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F6A9DE18;
        Tue, 14 Mar 2023 04:51:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 955FFB81733;
        Tue, 14 Mar 2023 11:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAD7C433EF;
        Tue, 14 Mar 2023 11:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678794671;
        bh=WJQMVekMCvTK/ErC1vNvTFuK12s0X8aXSxX4nPY5K/c=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=Jf9Kbm2iJzcZzz8CycoDNv+B8ISXhvF1nLgknABXz0+ABybU47eBux5RSIulTRNYq
         VfzeZ9KrRFKCA4rzSURUWISZPLn0vzbtxaCj/3vmiGlUyhobvBfXF3s/Pwmdno12zF
         QtgFJYVyWb7YF7P6+maqDblH5Uc5hlQ2QZVLIB2i3BkhysbclhWK4JzXZ/C5PaXUPj
         guBAjhbjCCmwP+hsfEsZ+wPeDSbbL4xHK79GAl4vRRHhCSokY40nmRz1roqgQPLgj/
         h0NqgjB0HR5UBqqx9qWkeErklyU4Uwxxk3fejvL5PeQ9aSI1jl6FQAinH+fKriZLBM
         yQR7wwv3r+PHA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Ira Weiny <ira.weiny@intel.com>
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20230217-kmap-qib-v1-1-e5a6fde167e0@intel.com>
References: <20230217-kmap-qib-v1-1-e5a6fde167e0@intel.com>
Subject: Re: [PATCH] rdma/qib: Remove deprecated kmap() call
Message-Id: <167879466639.235555.17568096529294287253.b4-ty@kernel.org>
Date:   Tue, 14 Mar 2023 13:51:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


On Tue, 07 Mar 2023 09:15:31 -0800, Ira Weiny wrote:
> kmap() has been deprecated in favor of the kmap_local_page() call.
> kmap_local_page() is thread local.
> 
> In the sdma coalesce case the page allocated is potentially free'ed in a
> different context through qib_sdma_get_complete() ->
> qib_user_sdma_make_progress().  The use of kmap_local_page() is
> inappropriate in this call path.  However, the page is allocated using
> GFP_KERNEL and will never be from highmem.
> 
> [...]

Applied, thanks!

[1/1] rdma/qib: Remove deprecated kmap() call
      https://git.kernel.org/rdma/rdma/c/4f00848e490c59

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
