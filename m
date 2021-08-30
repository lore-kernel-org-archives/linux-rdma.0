Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CA9C4320E
	for <linux-rdma@archiver.kernel.org>; Mon, 30 Aug 2021 07:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48F986056B
	for <linux-rdma@archiver.kernel.org>; Mon, 30 Aug 2021 07:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbhH3Hdx (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 30 Aug 2021 03:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbhH3Hdx (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 30 Aug 2021 03:33:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FFBC061575;
        Mon, 30 Aug 2021 00:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CsUY/25ldc/6yahhooVuAywYxR4PUqEW9297uxOOCDU=; b=NcP4iF5tJ9VEvyLqe7IMu72O+V
        I3qr7DNGae5hgE7ncyEKZ/b1464fzo8K97qrKFweFipsAWDDe4ort38XqiYLHu23IPSi/+ozsftoV
        Mey+aSOuwJBBH9RhEQ8ALrDoYyl2KJlQQC4pFs0RvXdGlsll8GF9WHSO4sY+Ynwh0hrzm4LeEKC1m
        XZSABurZOxkd/4UD4vruvdg0OcvYk47NN2Ksar/znHeairQJoalg4v0osoxgPMZ/9iDFb9SSrtCdg
        WIhB2PUbk/k9db0/QbIuv8XmCLSLUTr1l/D+y5qWhHC5l8U2DSYEw6cL4XYbbXKVFq9TGH9NXTuhu
        5zrRLB9g==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mKbm1-00HSK5-13; Mon, 30 Aug 2021 07:32:10 +0000
Date:   Mon, 30 Aug 2021 08:32:05 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Li Zhijian <lizhijian@cn.fujitsu.com>
Cc:     linux-mm@kvack.org, linux-rdma@vger.kernel.org,
        akpm@linux-foundation.org, jglisse@redhat.com, jgg@ziepe.ca,
        hch@infradead.org, yishaih@nvidia.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/hmm: bypass devmap pte when all pfn requested
 flags are fulfilled
Message-ID: <YSyJdUirSGv01nTy@infradead.org>
References: <20210828010441.3702-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210828010441.3702-1-lizhijian@cn.fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sat, Aug 28, 2021 at 09:04:41AM +0800, Li Zhijian wrote:
> +	if (!pte_devmap(pte) && pte_special(pte) &&
> +	    !is_zero_pfn(pte_pfn(pte))) {

Maybe this is a little too superficial and nitpicky, but I find the
ordering of the checks a little strange.  Why not do the pte_special
first and then the exlusions from it later?
