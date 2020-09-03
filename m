Return-Path: <SRS0=kLQv=CM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53692C433E2
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 15:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B018206D4
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 15:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgICPcW (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Sep 2020 11:32:22 -0400
Received: from verein.lst.de ([213.95.11.211]:38300 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbgICPcV (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 3 Sep 2020 11:32:21 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 919D867357; Thu,  3 Sep 2020 17:32:17 +0200 (CEST)
Date:   Thu, 3 Sep 2020 17:32:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH rdma-next 0/4] scatterlist: add sg_alloc_table_append
 function
Message-ID: <20200903153217.GA21689@lst.de>
References: <20200903121853.1145976-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903121853.1145976-1-leon@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

Patch 1 never made it through.
