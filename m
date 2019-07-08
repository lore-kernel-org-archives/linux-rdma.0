Return-Path: <SRS0=cc4V=VF=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B897C606A7
	for <linux-rdma@archiver.kernel.org>; Mon,  8 Jul 2019 10:44:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3BAC20665
	for <linux-rdma@archiver.kernel.org>; Mon,  8 Jul 2019 10:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562582685;
	bh=hWjS29h/ZCT35G8FsyyzhLT/un/0c80Lgrq61dQuATc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=nbRafPwG3FmHMVSsrwtLPZwH5GDL+1qtXIgimfk5iTKB8HvDEM3/Qb1PitQa6kVp2
	 3Oyyym93InQSYq9A/6kX8vL6UVXKYn8U6c4ljxWdJSlBH+cmK7gPGCjF7yChzNxFRL
	 W30URpjcZBX3Maomzl9Nbar61k19EAugQtbQL9Dw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfGHKop (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 8 Jul 2019 06:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730166AbfGHKop (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 8 Jul 2019 06:44:45 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80D662063F;
        Mon,  8 Jul 2019 10:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562582684;
        bh=hWjS29h/ZCT35G8FsyyzhLT/un/0c80Lgrq61dQuATc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=argeYVYbOl2bP2OaCpbAfV3JLqNvxWpUb9zR/ytufKdzUUx19sB56ieqY6L87y95L
         13qrqzAi4g9Mnxn4fr9sfoFBEl00LU/0FxU5PkIHrjXxp+w6DKFFDmcNUdzYy3GSQ9
         vX8q0RLjYvL9Fm+Lg+vt7aZ4whx5pLS9ZVupo0Bc=
Date:   Mon, 8 Jul 2019 13:44:39 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>
Subject: Re: [PATCH rdma-next v4 2/3] RDMA/core: Provide RDMA DIM support for
 ULPs
Message-ID: <20190708104439.GC7034@mtr-leonro.mtl.com>
References: <20190704125743.7814-1-leon@kernel.org>
 <20190704125743.7814-3-leon@kernel.org>
 <efdb7d5f-1cd7-fd34-0245-b494000a0954@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efdb7d5f-1cd7-fd34-0245-b494000a0954@grimberg.me>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Jul 08, 2019 at 02:31:51AM -0700, Sagi Grimberg wrote:
>
> >   drivers/infiniband/core/cq.c      | 45 +++++++++++++++++++++++++++++++
> >   drivers/infiniband/hw/mlx5/main.c |  2 ++
>
> Can you please separate the mlx5 patch from the core?

Sure, no problem.

Thanks
