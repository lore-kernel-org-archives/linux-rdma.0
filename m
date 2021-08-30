Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA3CC4320E
	for <linux-rdma@archiver.kernel.org>; Mon, 30 Aug 2021 10:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61C3A610CE
	for <linux-rdma@archiver.kernel.org>; Mon, 30 Aug 2021 10:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbhH3KMk (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 30 Aug 2021 06:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhH3KMj (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 30 Aug 2021 06:12:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10126C0613D9;
        Mon, 30 Aug 2021 03:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Doe4Y3c6/HJtxTnrRvUecOMxbV
        hAKGS2IT+m/CFY0EWvhW1kBD0dcQzsv/3PNVnOSm9SMUaQCat/daHakiW/J6YK8aVjjDcNqp+jZUp
        43H+J7goe/lX9D3edt2RBBJ0Xh44B+FZu8cRKf3gpV2ak92rhjzQ9wMSozENGstSZSmSirA6MRChq
        LWTMforeaPsMRMRdMAXtwMXAbmWSDOsb8Ww9Pj1tKH52qK9KukPfBQrFyIxNz9dke1un9r2koSSOL
        yIbtIW4DpqE3AiBYk0Q+oWW+ytNSvl+VpwBXV087fJNltKpVdJbP0Tsd7DrfgiEuog2047v5EzNS3
        XVN+rFGg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKeEc-0000Bp-6a; Mon, 30 Aug 2021 10:10:09 +0000
Date:   Mon, 30 Aug 2021 11:09:46 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Li Zhijian <lizhijian@cn.fujitsu.com>
Cc:     linux-mm@kvack.org, linux-rdma@vger.kernel.org,
        akpm@linux-foundation.org, jglisse@redhat.com, jgg@ziepe.ca,
        hch@infradead.org, yishaih@nvidia.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/hmm: bypass devmap pte when all pfn requested
 flags are fulfilled
Message-ID: <YSyuavTm7UDfvHdH@infradead.org>
References: <20210830094232.203029-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830094232.203029-1-lizhijian@cn.fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
