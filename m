Return-Path: <SRS0=kLQv=CM=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE596C433E2
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 15:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9F7320786
	for <linux-rdma@archiver.kernel.org>; Thu,  3 Sep 2020 15:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599148561;
	bh=FHALxW756C48xQGSGjeLpDkO9PfNrHnFzQ23hqC9M4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=JWAS3VY+DvxuHXKaBpdUMsX6qTWyhpCIgra4AjsxUF8mLV9xZi6WKaKTmZIFgXWjt
	 R4K6Wb0Aydic8qfgWjSAooeCz5e5WmY1mZu5ohGyEXviRPp6PxItkCrexYUeqgqrOl
	 RxYslraNjof4QzDrhRBXVP9lfQwHBZo+BTMwnhbI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgICPz7 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 3 Sep 2020 11:55:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728623AbgICPzz (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 3 Sep 2020 11:55:55 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7114820639;
        Thu,  3 Sep 2020 15:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599148555;
        bh=FHALxW756C48xQGSGjeLpDkO9PfNrHnFzQ23hqC9M4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1j5nDL/1AszZbJmEh1G+Dsrd1QW6JRAoVJA9yRSMS0FiKMlzJ84j+wB61jitlc3j4
         WbfmXK+md7LQKinPldN/sVKlg3HryuFPEWNyRuRcRsmNXNS56H6+aT/04o+7sPFu5D
         mfbWr8xijZgCZg/b+balfcp1OlPAllXbvzA/AcYY=
Date:   Thu, 3 Sep 2020 18:55:51 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH rdma-next 0/4] scatterlist: add sg_alloc_table_append
 function
Message-ID: <20200903155551.GC1137836@unreal>
References: <20200903121853.1145976-1-leon@kernel.org>
 <20200903153217.GA21689@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903153217.GA21689@lst.de>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Sep 03, 2020 at 05:32:17PM +0200, Christoph Hellwig wrote:
> Patch 1 never made it through.

Thanks, I sent it now and the patch is seen in ML.

https://lore.kernel.org/linux-rdma/20200903153217.GA21689@lst.de/T/#t
