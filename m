Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47645C433DB
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Feb 2021 18:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18F7A64E32
	for <linux-rdma@archiver.kernel.org>; Wed, 10 Feb 2021 18:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhBJSxu (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 10 Feb 2021 13:53:50 -0500
Received: from gentwo.org ([3.19.106.255]:47920 "EHLO gentwo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233894AbhBJSv6 (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 10 Feb 2021 13:51:58 -0500
Received: by gentwo.org (Postfix, from userid 1002)
        id ACCD23F11A; Wed, 10 Feb 2021 18:51:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by gentwo.org (Postfix) with ESMTP id AA7DF3F09E;
        Wed, 10 Feb 2021 18:51:09 +0000 (UTC)
Date:   Wed, 10 Feb 2021 18:51:09 +0000 (UTC)
From:   Christoph Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To:     Jason Gunthorpe <jgg@nvidia.com>
cc:     linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] Fix: Remove racy Subnet Manager sendonly join checks
In-Reply-To: <20210210130311.GU4247@nvidia.com>
Message-ID: <alpine.DEB.2.22.394.2102101848520.178574@www.lameter.com>
References: <alpine.DEB.2.22.394.2101281845160.13303@www.lameter.com> <20210209191517.GQ4247@nvidia.com> <alpine.DEB.2.22.394.2102100925200.172831@www.lameter.com> <20210210130311.GU4247@nvidia.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, 10 Feb 2021, Jason Gunthorpe wrote:

> > Yes the Linux Foundation guys are not willing to address this issue in any
> > way. I may have to give up my linux.com email address.
>
> It looks like you have to linux.com emails through their SMTP relay,
> just like kernel.org ?

No they do not offer an SMTP relay. That would actually fix the issue.

> I have an exim config that auto-routes to an authenticated smarthost
> based on the From email address if that would help you

I am running a mailer too but that does address the issue of not being
able to setup the SPF records for me on linux.com.


