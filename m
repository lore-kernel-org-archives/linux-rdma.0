Return-Path: <SRS0=GXMw=V3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0FBCC433FF
	for <linux-rdma@archiver.kernel.org>; Tue, 30 Jul 2019 13:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8592A206B8
	for <linux-rdma@archiver.kernel.org>; Tue, 30 Jul 2019 13:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564493903;
	bh=GiNEnDx+n0X8Twz9aceE/w3EdBrzcDmdq4aK189LImk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=KETrVznvP8JNHHILbWNhLoE+WsJdnz68xqC+bUj21ecXQ8nv8bRa8FFxb6MzbYLM1
	 xnJNCZb/vOZtjjYabDWZ+E63vLPElri+w0tkZ2BuBUuEr4ZumhARm2xg0zNzXju7wg
	 X4rL1PRkrVD1Ao2sJBDbi95zaG+ti1kCPad4UVV4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfG3NiX (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 30 Jul 2019 09:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfG3NiW (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 30 Jul 2019 09:38:22 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CBFE206B8;
        Tue, 30 Jul 2019 13:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564493901;
        bh=GiNEnDx+n0X8Twz9aceE/w3EdBrzcDmdq4aK189LImk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c+GFAMGkGqS1fZFtCcE9Abfgg1VvBLBuDe8MeX/DvBHS7zXJlbgOfCPzBGyuB+F50
         pPi1SGwejNwUS+r4U0NBVayv0X5dZEZQpnoMy74Nnpth8RGuLLz1Jh1FEkCervfRL1
         xAhs/mlbcn5FZUyoU5ph+sKd+5wrGqVjh3lyNjYg=
Date:   Tue, 30 Jul 2019 16:38:17 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH for-rc] RDMA/restrack: Track driver QP types in resource
 tracker
Message-ID: <20190730133817.GC4878@mtr-leonro.mtl.com>
References: <20190730110137.37826-1-galpress@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730110137.37826-1-galpress@amazon.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Jul 30, 2019 at 02:01:37PM +0300, Gal Pressman wrote:
> The check for QP type different than XRC has wrongly excluded driver QP
> types from the resource tracker.
>
> Fixes: 78a0cd648a80 ("RDMA/core: Add resource tracking for create and destroy QPs")

It is a little bit over to say "wrongly". At that time, we did it on purpose
because it was unclear how to represent such QP types to users and we didn't
have vendor specific hooks introduced by Steve later on.

I would like to see the output or "rdma res" and "rdma res show qp" with
running driver QP after your change.

Thanks
