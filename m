Return-Path: <SRS0=H2xG=7A=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD0E3C433E0
	for <linux-rdma@archiver.kernel.org>; Mon, 18 May 2020 07:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 965022070A
	for <linux-rdma@archiver.kernel.org>; Mon, 18 May 2020 07:16:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vDIHbt9/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgERHQb (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 18 May 2020 03:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgERHQa (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 18 May 2020 03:16:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA661C061A0C
        for <linux-rdma@vger.kernel.org>; Mon, 18 May 2020 00:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=MDfmhUSEN6T1GWC2JS9ETQihJaCCpQUmpR95XbCnZog=; b=vDIHbt9/FFHQvvtrqu3ceP744/
        Et419wdtoBJPRcro8nFtvRPYBmkyQG22n2DUH8NH789eQAaTxxxk2tzDnEn9mKogm+WOXTzL1ceeg
        J7sngmxcB+y8vd1scCObbJSJP6dJyep3tyg84z4nE4hNrMmPfPOR5jRSam/uX+ZkCilMHORn17oC+
        RzV2Vu2c4pF1zLEwJPQmIMIYWKX6PGrE2gLD1aV1UMfPw6r53H/Vn+8vqV473mmu5C5ppDPQRLQHR
        zfBlHJep6mflKx+V3D79oSl4LpKQnovmJ0IH5CMO/JjxO3k4r/2A1X50sWu5UYwfOdXfsbOqHgbYf
        gcjaAb+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaa0f-0000Jo-0n; Mon, 18 May 2020 07:16:25 +0000
Date:   Mon, 18 May 2020 00:16:24 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Sagi Grimberg <sagigrim@gmail.com>
Cc:     Alexey Lyashkov <umka@cloudlinux.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Leon Romanovsky <leon@kernel.org>,
        Israel Rukshin <israelr@mellanox.com>, sagi@grimberg.me,
        jgg@mellanox.com, linux-rdma@vger.kernel.org, dledford@redhat.com,
        sergeygo@mellanox.com
Subject: Re: [PATCH] IB/iser: Remove support for FMR memory registration
Message-ID: <20200518071624.GA20312@infradead.org>
References: <1589299739-16570-1-git-send-email-israelr@mellanox.com>
 <20200512171633.GO4814@unreal>
 <5b8b0b51-83e3-06c2-9b99-dec0862c0e5b@acm.org>
 <49391e02-803b-f705-b00e-e48efd278759@mellanox.com>
 <0C22D41B-89CD-4B2D-B514-8EA06F2233D7@cloudlinux.com>
 <9fe7ac28-4702-d537-a568-c3eb0b5b0ce3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9fe7ac28-4702-d537-a568-c3eb0b5b0ce3@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Sun, May 17, 2020 at 01:35:33AM -0700, Sagi Grimberg wrote:
> 
> 
> On 5/14/20 3:09 AM, Alexey Lyashkov wrote:
> > CX3 with fast registration isn’t stable enough.
> > I was make this change for Lustre for year or two ago, but it was
> > reverted by serious bugs.
> 
> This must be issues with the Lustre implementation, all the rest of the ULPs
> (almost) default
> to FRWR.

And even if it wasn't out of tree junk like Lustre simply doesn't matter
for upstream decisions.
