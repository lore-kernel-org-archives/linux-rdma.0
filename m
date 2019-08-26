Return-Path: <SRS0=Drwg=WW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DADC3A59F
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Aug 2019 14:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89C652186A
	for <linux-rdma@archiver.kernel.org>; Mon, 26 Aug 2019 14:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566829427;
	bh=OCVPuBqM5p6kwN7KRXr6+HLTV5NW8AeRGSCCGvBy2DU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hK2C13TNgJilQ5BskQ8eNPx0tjXSyj5udiroE9nutBdqc5dUvQogD9SpTDgpFPOP8
	 b+vUJB+K6WPPiGSLzQ0jwwf5u72t828KMn8OBj/2cxxY3hOu2ewdpDDa5GUMPjSfXi
	 Hk6VmbEjLWdgAXfqQob3/t8lSXz2ai8uCVzzWb+U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732450AbfHZOXq (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 26 Aug 2019 10:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732449AbfHZOXq (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 26 Aug 2019 10:23:46 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32155217F5;
        Mon, 26 Aug 2019 14:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566829425;
        bh=OCVPuBqM5p6kwN7KRXr6+HLTV5NW8AeRGSCCGvBy2DU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vigea5nDNg8M4AW+ixL+zuCDo8KFyX5MGBezqvQoRcpd8ZSpIkHwQrd0A/0nhOZv/
         /JSg9nbxDSRKlb+nHw+P/Kh0honywz5LG5FKS6zQ6TnDaACZVkRm6HT2v60MNFywIR
         +Siat6+lOm++3x6RUK7AKbeYqvfPkCSTI2oGz6F4=
Date:   Mon, 26 Aug 2019 17:23:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: ib_umem_get and DMA_API_DEBUG question
Message-ID: <20190826142320.GD4584@mtr-leonro.mtl.com>
References: <526c5b18-5853-c8dc-e112-31287a46e707@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526c5b18-5853-c8dc-e112-31287a46e707@amazon.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Aug 26, 2019 at 05:05:12PM +0300, Gal Pressman wrote:
> Hi all,
>
> Lately I've been seeing DMA-API call traces on our automated testing runs which
> complain about overlapping mappings of the same cacheline [1].
> The problem is (most likely) caused due to multiple calls to ibv_reg_mr with the
> same address, which as a result DMA maps the same physical addresses more than 7
> (ACTIVE_CACHELINE_MAX_OVERLAP) times.
>
> Is this considered a bad behavior by the test? Should this be caught by
> ib_core/driver somehow?

If I'm not mistaken here, but we (Mellanox) decided that it is a bug in
DMA debug code.

Thanks
