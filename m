Return-Path: <SRS0=4HyS=2L=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE98C2D0D3
	for <linux-rdma@archiver.kernel.org>; Sat, 21 Dec 2019 10:15:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1DBE222C2
	for <linux-rdma@archiver.kernel.org>; Sat, 21 Dec 2019 10:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576923336;
	bh=28FLe1Rig0f46+KUWV/d5T4094Hd1K1D6/bIkj1jpXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=kPYCNQaAzi1IVp15ldrQAJ1+NLxlHWE+Zp6dgiwD30MaLHVStgXAeLANmTQgn6bA3
	 4pEVuHbIAT/HS5QE1Rc5SZXgq0bWE14tdTPI9G4OJh6AX5sxXsNyuI3ds0uFT3q1up
	 tIi2g1o8hUokAtD5zYdsO01YQ3sMj0NRUFRrrMXA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfLUKPf (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Sat, 21 Dec 2019 05:15:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbfLUKPf (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Sat, 21 Dec 2019 05:15:35 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13EEE2072B;
        Sat, 21 Dec 2019 10:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576923334;
        bh=28FLe1Rig0f46+KUWV/d5T4094Hd1K1D6/bIkj1jpXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w8msgnEDhgLmjU+mSN3ZIvBSsMTi4GZtVib54F/SUTX4bE0nJbJwWsx84I15NGvzn
         y7p/KiTuJ4/QLqZI1LFBIlQd1S808Y66uvey4Zx4Lyp5BRmbleX6KxiaAiWPJBC8Im
         jGDK94V0oPz/DHL8+A8ElXlaIA8cCJm65RXbtVBM=
Date:   Sat, 21 Dec 2019 12:15:30 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jack Wang <jinpuwang@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
        axboe@kernel.dk, hch@infradead.org, sagi@grimberg.me,
        bvanassche@acm.org, dledford@redhat.com,
        danil.kipnis@cloud.ionos.com, jinpu.wang@cloud.ionos.com,
        rpenyaev@suse.de
Subject: Re: [PATCH v5 02/25] rtrs: public interface header to establish RDMA
 connections
Message-ID: <20191221101530.GC13335@unreal>
References: <20191220155109.8959-1-jinpuwang@gmail.com>
 <20191220155109.8959-3-jinpuwang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220155109.8959-3-jinpuwang@gmail.com>
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Dec 20, 2019 at 04:50:46PM +0100, Jack Wang wrote:
> From: Jack Wang <jinpu.wang@cloud.ionos.com>
>
> Introduce public header which provides set of API functions to
> establish RDMA connections from client to server machine using
> RTRS protocol, which manages RDMA connections for each session,
> does multipathing and load balancing.
>
> Main functions for client (active) side:
>
>  rtrs_clt_open() - Creates set of RDMA connections incapsulated
>                     in IBTRS session and returns pointer on RTRS
> 		    session object.
>  rtrs_clt_close() - Closes RDMA connections associated with RTRS
>                      session.
>  rtrs_clt_request() - Requests zero-copy RDMA transfer to/from
>                        server.
>
> Main functions for server (passive) side:
>
>  rtrs_srv_open() - Starts listening for RTRS clients on specified
>                     port and invokes RTRS callbacks for incoming
> 		    RDMA requests or link events.
>  rtrs_srv_close() - Closes RTRS server context.
>
> Signed-off-by: Danil Kipnis <danil.kipnis@cloud.ionos.com>
> Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/infiniband/ulp/rtrs/rtrs.h | 334 +++++++++++++++++++++++++++++
>  1 file changed, 334 insertions(+)
>  create mode 100644 drivers/infiniband/ulp/rtrs/rtrs.h
>
> diff --git a/drivers/infiniband/ulp/rtrs/rtrs.h b/drivers/infiniband/ulp/rtrs/rtrs.h
> new file mode 100644
> index 000000000000..5b55ad163505
> --- /dev/null
> +++ b/drivers/infiniband/ulp/rtrs/rtrs.h
> @@ -0,0 +1,334 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * InfiniBand Transport Layer
> + *
> + * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
> + * Authors: Fabian Holler <mail@fholler.de>
> + *          Jack Wang <jinpu.wang@profitbricks.com>
> + *          Kleber Souza <kleber.souza@profitbricks.com>
> + *          Danil Kipnis <danil.kipnis@profitbricks.com>
> + *          Roman Penyaev <roman.penyaev@profitbricks.com>
> + *          Milind Dumbare <Milind.dumbare@gmail.com>
> + *
> + * Copyright (c) 2017 - 2018 ProfitBricks GmbH. All rights reserved.
> + * Authors: Danil Kipnis <danil.kipnis@profitbricks.com>
> + *          Roman Penyaev <roman.penyaev@profitbricks.com>
> + *
> + * Copyright (c) 2018 - 2019 1&1 IONOS Cloud GmbH. All rights reserved.
> + * Authors: Roman Penyaev <roman.penyaev@profitbricks.com>
> + *          Jinpu Wang <jinpu.wang@cloud.ionos.com>
> + *          Danil Kipnis <danil.kipnis@cloud.ionos.com>
> + */
> +
> +/* Copyright (c) 2019 1&1 IONOS SE. All rights reserved.
> + * Authors: Jack Wang <jinpu.wang@cloud.ionos.com>
> + *          Danil Kipnis <danil.kipnis@cloud.ionos.com>
> + *          Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
> + *          Lutz Pogrell <lutz.pogrell@cloud.ionos.com>
> + */

Perhaps it is normal practice to write half a company as authors,
and I'm wrong in the following, but code authorship is determined by
multiple tags in the commit messages.

Thanks
