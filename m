Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE1BC433ED
	for <linux-rdma@archiver.kernel.org>; Mon, 10 May 2021 07:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A6F06143B
	for <linux-rdma@archiver.kernel.org>; Mon, 10 May 2021 07:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhEJHBT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 10 May 2021 03:01:19 -0400
Received: from verein.lst.de ([213.95.11.211]:57323 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230154AbhEJHBP (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 10 May 2021 03:01:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AE55C67373; Mon, 10 May 2021 09:00:08 +0200 (CEST)
Date:   Mon, 10 May 2021 09:00:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     mkalderon@marvell.com, aelior@marvell.com, hch@lst.de,
        sagi@grimberg.me, yaminf@mellanox.com,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        Shai Malin <smalin@marvell.com>
Subject: Re: [PATCH] nvmet-rdma: Fix NULL deref when SEND is completed with
 error
Message-ID: <20210510070007.GB30907@lst.de>
References: <20210506070819.12502-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506070819.12502-1-michal.kalderon@marvell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Thanks,

applied to nvme-5.13.
