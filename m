Return-Path: <SRS0=Aeev=ZF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27758C43331
	for <linux-rdma@archiver.kernel.org>; Wed, 13 Nov 2019 00:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0032D21D7F
	for <linux-rdma@archiver.kernel.org>; Wed, 13 Nov 2019 00:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573603723;
	bh=KjzzTcYnHTbPiZHHU3oiNXK2IO0S++IshKJ56E3fWIM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=xMqsDn3xHNVFMFiocil8x83bawHUmtDgtE6Ff2wnFmvAcu9j5AbAghe9GzTWPnvXN
	 3yEoMARPLlHHLbxGDfNf2+nOKKdTD4y/9XvgBR/6vLpIT9nFtSFBgO7+86W/uwrHgi
	 MzwNCpO/ZNZlgxVnoZdXosHKsHl7oGJsjx7euZGE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfKMAIj (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 12 Nov 2019 19:08:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbfKMAIj (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 12 Nov 2019 19:08:39 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 273AA2196E;
        Wed, 13 Nov 2019 00:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573603718;
        bh=KjzzTcYnHTbPiZHHU3oiNXK2IO0S++IshKJ56E3fWIM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LOiGsvx+c2husp91s1WCl9gljHVh7c5xjNQNDyeBqhxPkRhboXxQqmqoTBCQPqQZ1
         V2L9yuouLTv+rFxK1urn3WJ2bX10DDbmxjicANXYOddYCrZUMzv4RI1uer5JQH180k
         Lv+aNCMejDxus+4oUYACPPj8wFzi6MgoCQydwG18=
Date:   Tue, 12 Nov 2019 16:08:35 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Ralph Campbell <rcampbell@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jerome Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Shuah Khan <shuah@kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] mm/hmm/test: add self tests for HMM
Message-Id: <20191112160835.9bfa58cf756683ddc8d470fd@linux-foundation.org>
In-Reply-To: <07589a71-3984-b2a6-b24b-6b9a23e1b60d@nvidia.com>
References: <20191104222141.5173-1-rcampbell@nvidia.com>
        <20191104222141.5173-3-rcampbell@nvidia.com>
        <20191112152521.GC12550@lst.de>
        <07589a71-3984-b2a6-b24b-6b9a23e1b60d@nvidia.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, 12 Nov 2019 13:51:11 -0800 Ralph Campbell <rcampbell@nvidia.com> wrote:

> On 11/12/19 7:25 AM, Christoph Hellwig wrote:
> > Shouldn't this go into mm/ instead? It certainly doesn't seem
> > like a library.
> 
> I was following the convention for the other vm test kernel modules.
> I see a couple of modules in mm/ but I don't have a personal
> preference for where to place it.
> 
> Andrew, do you have a preference?

q:/usr/src/25> ls -l lib/test_*.c|wc 
     33     297    2051

lib/ is a somewhat strange place, but I'd use that for now.

Presumably one day someone will (pointlessly) move these into
lib/test-modules/.

Then into lib/test-modules/mm/, etc..
