Return-Path: <SRS0=PlVj=DW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2A2C433E7
	for <linux-rdma@archiver.kernel.org>; Thu, 15 Oct 2020 05:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A7AA22247
	for <linux-rdma@archiver.kernel.org>; Thu, 15 Oct 2020 05:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbgJOF3Y (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 15 Oct 2020 01:29:24 -0400
Received: from smtprelay0116.hostedemail.com ([216.40.44.116]:46062 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726323AbgJOF3Y (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 15 Oct 2020 01:29:24 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 9FB7518029122;
        Thu, 15 Oct 2020 05:29:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: play60_0117aeb27211
X-Filterd-Recvd-Size: 1318
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf17.hostedemail.com (Postfix) with ESMTPA;
        Thu, 15 Oct 2020 05:29:21 +0000 (UTC)
Message-ID: <497ed8109393bdcf6ba9642e3a527d7d25972e4f.camel@perches.com>
Subject: Re: [PATCH-next 0/4] RDMA: sprintf to sysfs_emit conversions
From:   Joe Perches <joe@perches.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        linux-rdma@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 14 Oct 2020 22:29:20 -0700
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

It is in Linus' tree now.


