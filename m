Return-Path: <SRS0=+IkR=VZ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E1BC7618B
	for <linux-rdma@archiver.kernel.org>; Sun, 28 Jul 2019 12:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF9E92087C
	for <linux-rdma@archiver.kernel.org>; Sun, 28 Jul 2019 12:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564318573;
	bh=M84mJQUAsPmHj2uDQ+myixTPBLw7nn6LWPstaCXYtXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ec+i+uSUsFOepQjNZazHrqR7VjTzaVlpvH3cEpATNareD0xNhvTkJJw/AvhxIzzJG
	 EqVsDr27s+wX+zAXefU1kGxD3KKo7M3JcsRprsKr02Ld3gXOrrcnwx69OooRLFnVLF
	 HkegDIgXSRt0r3TFBq33u1DEgnspYP0ITl4YHEh4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbfG1M4N (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sun, 28 Jul 2019 08:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfG1M4N (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sun, 28 Jul 2019 08:56:13 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 738EC2064A;
        Sun, 28 Jul 2019 12:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564318572;
        bh=M84mJQUAsPmHj2uDQ+myixTPBLw7nn6LWPstaCXYtXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tMjiwVZh4XN1IhipPSAI7OIubZPuohS5BLtuXp2BWpUVMPzKxeo7KRQtJHHwbGuh7
         3AWhWJBbBhxzBGLBb8MVvk23bSk8ITk7929QmGnAoFaCTwALSTQYiiaHUk8N05ONGq
         4/xivZzv0tQaV059ZSeXK/XBBKG7gyPfBIajg038=
Date:   Sun, 28 Jul 2019 11:37:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Potnuri Bharat Teja <bharat@chelsio.com>,
        linux-rdma@vger.kernel.org, nirranjan@chelsio.com
Subject: Re: [PATCH rdma-core 2/2] cxgb4: remove unused c4iw_match_device
Message-ID: <20190728083749.GH4674@mtr-leonro.mtl.com>
References: <20190725174928.26863-1-bharat@chelsio.com>
 <20190725181424.GB7467@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725181424.GB7467@ziepe.ca>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, Jul 25, 2019 at 03:14:24PM -0300, Jason Gunthorpe wrote:
> On Thu, Jul 25, 2019 at 11:19:28PM +0530, Potnuri Bharat Teja wrote:
> > match_device handler is no longer needed after latest device binding changes.
> >
> > Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
> > ---
> >  providers/cxgb4/dev.c | 41 -----------------------------------------
> >  1 file changed, 41 deletions(-)
>
> Do you know if we can also drop the same code in cxgb3?

Can we simply remove cxgb3?

Thanks

>
> Jason
