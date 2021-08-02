Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20C1C4338F
	for <linux-rdma@archiver.kernel.org>; Mon,  2 Aug 2021 07:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C46AC60F9F
	for <linux-rdma@archiver.kernel.org>; Mon,  2 Aug 2021 07:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbhHBHdJ (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 2 Aug 2021 03:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232173AbhHBHdJ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 2 Aug 2021 03:33:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B868C60F5A;
        Mon,  2 Aug 2021 07:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627889580;
        bh=qP6XyTQW5v/s1xq73iZTqyR01yDHYItj69Ov9IBgzTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a9KPi5Cy6rg9TK/giAE6PRRlMLPG5RAwcUHjL+iuQ8hEpQ1A12nWloZJv3+8aDJ7K
         nWdfO7uQweL+tXB872sQSppTKo97vGZth4RG43b/ZFJ/qB6vSpbU+lVsCN0RzWfh1J
         Q2Lwx3tuN4PWOqj48ZNE7RaHOlA+kbFaPh40LlTBIeEIDAfUgbvql3pSc0pEcG5wPQ
         AyMVqUC4qKpspteeRcFg/s2P1XndUlB55NgR7rVCxV6UDZqxz1DshOLUz5zGfP8pv2
         St7qTeGkmBSorS/zSY0GjPTODPUkJ4HbpQTbRlqYzJOh6Oo1i7h0IJQm9vVFfXBYEa
         PGmQS+LGLcYqg==
Date:   Mon, 2 Aug 2021 10:32:57 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     linux-rdma@vger.kernel.org, bvanassche@acm.org,
        dledford@redhat.com, jgg@ziepe.ca, haris.iqbal@ionos.com,
        Gioh Kim <gi-oh.kim@ionos.com>
Subject: Re: [PATCH for-next 10/10] RDMA/rtrs: remove (void) casting for
 functions
Message-ID: <YQefqauic265deCw@unreal>
References: <20210730131832.118865-1-jinpu.wang@ionos.com>
 <20210730131832.118865-11-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210730131832.118865-11-jinpu.wang@ionos.com>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Jul 30, 2021 at 03:18:32PM +0200, Jack Wang wrote:
> From: Gioh Kim <gi-oh.kim@ionos.com>
> 
> As recommended by Leon
> https://www.spinics.net/lists/linux-rdma/msg102200.html
> this patch removes (void) casting because that does nothing.
> 
> Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
> Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

I would write the commit message differently:

------

Casting to (void) does nothing, remove them.

Link: https://www.spinics.net/lists/linux-rdma/msg102200.html
Suggested-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Reviewed-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
