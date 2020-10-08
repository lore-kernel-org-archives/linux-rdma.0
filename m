Return-Path: <SRS0=E4jb=DP=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90556C4363C
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Oct 2020 05:52:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44C632173E
	for <linux-rdma@archiver.kernel.org>; Thu,  8 Oct 2020 05:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgJHFwT (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 8 Oct 2020 01:52:19 -0400
Received: from smtprelay0103.hostedemail.com ([216.40.44.103]:33388 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726245AbgJHFwT (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 8 Oct 2020 01:52:19 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 0F3F6127F;
        Thu,  8 Oct 2020 05:52:18 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: toe57_3515d0f271d5
X-Filterd-Recvd-Size: 1362
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Thu,  8 Oct 2020 05:52:16 +0000 (UTC)
Message-ID: <2279bdda913b31bdea68c23a9889e056c3947201.camel@perches.com>
Subject: Re: [PATCH-next 0/4] RDMA: sprintf to sysfs_emit conversions
From:   Joe Perches <joe@perches.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 07 Oct 2020 22:52:15 -0700
In-Reply-To: <20201008054128.GD13580@unreal>
References: <cover.1602122879.git.joe@perches.com>
         <20201008054128.GD13580@unreal>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu, 2020-10-08 at 08:41 +0300, Leon Romanovsky wrote:
> On Wed, Oct 07, 2020 at 07:36:23PM -0700, Joe Perches wrote:
> > A recent commit added a sysfs_emit and sysfs_emit_at to allow various
> > sysfs show functions to ensure that the PAGE_SIZE buffer argument is
> > never overrun and always NUL terminated.
> 
> Unfortunately but the sysfs_emit commit is not in rdma-next tree yet.

Likely it'll still apply fairly well when the sysfs_emit commit is...


