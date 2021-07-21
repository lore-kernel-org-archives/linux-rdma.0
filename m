Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A2EC12002
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Jul 2021 16:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B837F60FF3
	for <linux-rdma@archiver.kernel.org>; Wed, 21 Jul 2021 16:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhGUPgC (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 21 Jul 2021 11:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbhGUPgB (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 21 Jul 2021 11:36:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6039C061575;
        Wed, 21 Jul 2021 09:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=dovBFK3QQdO0rOX8vuhPmoaedl
        ggoMRCo09tbcMv7DguiDQsLvJaZAEFeOCHY64YF8+XeisjCS0MfFmCbAjnK7WWbibGrXW5kNp95H9
        xfLXECgjN1DM2kXnXe+uYTmEesIzs/xr5310buPqfdvE2luvfrAXJ9lO2dIerZh9CflZMjlLSGo6X
        iEDYmRjNSHYEo7mbBb4GNyqpvq9tHohN9ymD28n8q5rlk9Uh38aNj279aOIfxDm1jPx60t4qH9JuL
        EbOcHo6L8tLo7zO2s7OAbUH+SIf31zd1YhyYcoJdEboEqWRBQe3wALgsHsqnUvN9tXm6+4NLCYrbx
        go//Vf2w==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6Et7-009NYa-0x; Wed, 21 Jul 2021 16:16:01 +0000
Date:   Wed, 21 Jul 2021 17:16:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Maor Gottlieb <maorg@nvidia.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Roland Scheidegger <sroland@vmware.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        VMware Graphics <linux-graphics-maintainer@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zack Rusin <zackr@vmware.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next v2 2/2] RDMA: Use dma_map_sgtable for map umem
 pages
Message-ID: <YPhIQWvob3pTTUYA@infradead.org>
References: <cover.1626605893.git.leonro@nvidia.com>
 <009740c35873683e401da3f86d0e7a78b2f25601.1626605893.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009740c35873683e401da3f86d0e7a78b2f25601.1626605893.git.leonro@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
