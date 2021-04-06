Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E78C433ED
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Apr 2021 18:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FD706124C
	for <linux-rdma@archiver.kernel.org>; Tue,  6 Apr 2021 18:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbhDFSOw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 6 Apr 2021 14:14:52 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:47422 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234527AbhDFSOq (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 6 Apr 2021 14:14:46 -0400
Received: from localhost (mehrangarh.blr.asicdesigners.com [10.193.185.169])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 136IETwj030877;
        Tue, 6 Apr 2021 11:14:30 -0700
Date:   Tue, 6 Apr 2021 23:44:30 +0530
From:   Potnuri Bharat Teja <bharat@chelsio.com>
To:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>
Cc:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH for-rc] RDMA/cxgb4: check for ipv6 address properly while
 destroying listener
Message-ID: <YGylBjulSvR1TEfx@chelsio.com>
References: <20210331135715.30072-1-bharat@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331135715.30072-1-bharat@chelsio.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wednesday, March 03/31/21, 2021 at 19:27:15 +0530, Potnuri Bharat Teja wrote:
> ipv6 bit is wrongly set by commit '3408be145a5d' which causes fatal adapter
> lookup engine errors for ipv4 connections while destroying listener.
> Current patch properly checks the local address for ipv6 and fixes the
> blunder introduced by commit '3408be145a5d'.
> 
> Fixes: 3408be145a5d ("RDMA/cxgb4: Fix adapter LE hash errors while destroying ipv6 listening server")
> Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>

Gentle reminder.

> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index 81903749d241..e42c812e74c3 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -3616,7 +3616,8 @@ int c4iw_destroy_listen(struct iw_cm_id *cm_id)
>  		c4iw_init_wr_wait(ep->com.wr_waitp);
>  		err = cxgb4_remove_server(
>  				ep->com.dev->rdev.lldi.ports[0], ep->stid,
> -				ep->com.dev->rdev.lldi.rxq_ids[0], true);
> +				ep->com.dev->rdev.lldi.rxq_ids[0],
> +				ep->com.local_addr.ss_family == AF_INET6);
>  		if (err)
>  			goto done;
>  		err = c4iw_wait_for_reply(&ep->com.dev->rdev, ep->com.wr_waitp,
> -- 
> 2.24.0
> 
