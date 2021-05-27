Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D512C47089
	for <linux-rdma@archiver.kernel.org>; Thu, 27 May 2021 10:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23A5B613C5
	for <linux-rdma@archiver.kernel.org>; Thu, 27 May 2021 10:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbhE0K35 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 27 May 2021 06:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236093AbhE0K3y (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 27 May 2021 06:29:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FA7C061574;
        Thu, 27 May 2021 03:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=37FHlrs537m89HhOgV9zLgVKZ+yxkRp2d6A8j89nLIA=; b=kpzlqDsfs/8cEBjpcdUcF+ME9+
        GWv0EA0jkCwfAkELq8mgJLwVBXRzRyvJXck2ITOucucI5zul0gTnXod9pZMZRXraYjjJG0B4/WY/t
        EXRBbrghbMejxLXEzsTne+I+nkaKBt5bhBBhK1p9rKNl0bNuDe6EeovnGl+gORCq6oiX79BzXezSU
        k4SD/gyBq67M+W1qGw3Tu1Gmh+cM9Ggj9HMDqERORzLYprMtZ6vLt5sh5e1UBGU+RqMVBHmFDHjq6
        D6mwhsfNfFAUNWgcjp5WkXMofuxoOEE7C8O23vZO0Q1KC1o0Kty+6ZtPlMInekehbqPG9gPIViwH4
        iSBJbnJg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lmDFA-005Qcf-86; Thu, 27 May 2021 10:28:03 +0000
Date:   Thu, 27 May 2021 11:28:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Avihai Horon <avihaih@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH rdma-next v1 1/2] RDMA: Enable Relaxed Ordering by
 default for kernel ULPs
Message-ID: <YK90MOp0ZKeUMf5w@infradead.org>
References: <cover.1621505111.git.leonro@nvidia.com>
 <73af770234656d5f884ead5b8d40132d9ed289d6.1621505111.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73af770234656d5f884ead5b8d40132d9ed289d6.1621505111.git.leonro@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

The way this is implemented looks confusing and error prone to me.

I'd like to suggest the following:

 1) add a prep patch that entirely untangles IB_ACCESS_* from
    IB_UVERBS_ACCESS.  Maybe even add a __bitwise type for IB_ACCESS_*
    to allow sparse based type checking.  Preferably ib_check_mr_access
    could be changed into a function that does this translation as it
    needs to be called anyway.
 2) then just invert IB_ACCESS_RELAXED_ORDERING while keeping
    IB_UVERBS_ACCESS_REMOTE_ATOMIC as-is, and enable
    IB_ACCESS_STRICT_ORDERING if IB_UVERBS_ACCESS_REMOTE_ATOMIC is not
    set in ib_check_mr_access.
