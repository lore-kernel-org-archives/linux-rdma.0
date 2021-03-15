Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD43BC433DB
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Mar 2021 07:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9181464E6F
	for <linux-rdma@archiver.kernel.org>; Mon, 15 Mar 2021 07:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhCOH47 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 15 Mar 2021 03:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230255AbhCOH4w (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 15 Mar 2021 03:56:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DF2B64E12;
        Mon, 15 Mar 2021 07:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615795012;
        bh=Z7qiagatHhIeo2CDOv/v9xCdImTlFYGzIbFM9El/kGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rVIZfJ1kf1pCS+z2mypv0pDAoak2WfAPUy0tFyEX8oVc2iWNOuLXSptDuUwxfmus3
         YSNF/qmAIbcSMWyLbYk0jLAsg3Lh8DwqXQnZ7Yl44pHOYSZVy8B9d7G+6u9pXAwyMb
         BPlD+kGiwx95oqazRQ4x8Gk6wk46OqfImlCnrPV0=
Date:   Mon, 15 Mar 2021 08:56:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yi Zhang <yi.zhang@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Nicolas Morey-Chaisemartin <nmoreychaisemartin@suse.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        bart.vanassche@wdc.com, stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/srp: Fix support for unpopulated and unbalanced
 NUMA nodes
Message-ID: <YE8TQtOlLDBiQmz2@kroah.com>
References: <9cb4d9d3-30ad-2276-7eff-e85f7ddfb411@suse.com>
 <20210217133740.GA2296847@nvidia.com>
 <45c0875e-be7f-d59b-04cf-6e9cb0cb6747@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45c0875e-be7f-d59b-04cf-6e9cb0cb6747@redhat.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Mar 15, 2021 at 11:30:34AM +0800, Yi Zhang wrote:
> Hello
> 
> I reproduced the issue on 5.11.7-rc1, could we port this patch to stable
> branch.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
