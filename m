Return-Path: <SRS0=4PuW=6Z=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 126C0C47255
	for <linux-rdma@archiver.kernel.org>; Mon, 11 May 2020 18:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0116220720
	for <linux-rdma@archiver.kernel.org>; Mon, 11 May 2020 18:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730999AbgEKSyw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 11 May 2020 14:54:52 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:59726 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbgEKSyw (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 11 May 2020 14:54:52 -0400
Received: from localhost ([10.193.186.242])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04BIsg6e012988;
        Mon, 11 May 2020 11:54:48 -0700
Date:   Tue, 12 May 2020 00:24:42 +0530
From:   Potnuri Bharat Teja <bharat@chelsio.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Nirranjan Kirubaharan <nirranjan@chelsio.com>
Subject: Re: [PATCH for-rc] RDMA/iw_cxgb4: Fix incorrect function parameters
Message-ID: <20200511185440.GA12579@chelsio.com>
References: <20200510184157.12466-1-bharat@chelsio.com>
 <20200511131135.GR26002@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511131135.GR26002@ziepe.ca>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Monday, May 05/11/20, 2020 at 18:41:35 +0530, Jason Gunthorpe wrote:
> On Mon, May 11, 2020 at 12:11:57AM +0530, Potnuri Bharat Teja wrote:
> > Fixes the incorrect function parameters passed while reading TCB fields and
> > completing cached SRQ buffers.
> 
> For a -rc fix you must explain what bad thing happens because of the
> bug
> 
My bad. This patch fixes app segfults during connection teardown when SRQ is 
used. Resending patch wit updated description.
