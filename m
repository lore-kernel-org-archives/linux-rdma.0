Return-Path: <SRS0=/rP3=X3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42DEC352AA
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 13:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98EBC21783
	for <linux-rdma@archiver.kernel.org>; Wed,  2 Oct 2019 13:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570023134;
	bh=6xkgvDrp3hOpaYOlfP2GK6YivfcLwzAvqR9QeqHeclM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=flDre67veTRX6P7d6jZK30FwGm8/DGl+QB26hvj0++qBU9BxtwDRAHVkzm1L9RkB2
	 NcEruqFFnmnQlBaDF9ARh30pRMKqAi0OrQdlYKh2F8sNdm3JPl8F083LDvBLgNR+Gd
	 6FA+XXPkyMns67Ahf64ZdtmFvCXJwvBZ9hPGUD4Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfJBNcO (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 2 Oct 2019 09:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfJBNcN (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 2 Oct 2019 09:32:13 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF2C020842;
        Wed,  2 Oct 2019 13:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570023133;
        bh=6xkgvDrp3hOpaYOlfP2GK6YivfcLwzAvqR9QeqHeclM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pnp8zF5PBqenL4kA+rVVptzQysqI7hVJgzXhq4QO+awjMip0rx22/2pZmOWQ/KMSa
         pPrcCwypNwJ0O6q4m2zkfg6oJHt7auTt09MrcIuGS9t+fFfBpyvuvQJKd7u4FA48mV
         w+GREHHc1uLzg+EthJt448kg0IQtL9joCak71IQQ=
Date:   Wed, 2 Oct 2019 16:32:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bernard Metzler <bmt@zurich.ibm.com>
Cc:     linux-rdma@vger.kernel.org, bharat@chelsio.com, jgg@ziepe.ca,
        nirranjan@chelsio.com, krishna2@chelsio.com, bvanassche@acm.org
Subject: Re: [[PATCH v2 for-next]] RDMA/siw: Fix SQ/RQ drain logic
Message-ID: <20191002133210.GD5855@unreal>
References: <20191002131423.4181-1-bmt@zurich.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002131423.4181-1-bmt@zurich.ibm.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Oct 02, 2019 at 03:14:23PM +0200, Bernard Metzler wrote:
> Storage ULPs (e.g. iSER & NVMeOF) use ib_drain_qp() to
> drain QP/CQ. Current SIW's own drain routines do not properly
> wait until all SQ/RQ elements are completed and reaped
> from the CQ. This may cause touch after free issues.
> New logic relies on generic __ib_drain_sq()/__ib_drain_rq()
> posting a final work request, which SIW immediately flushes
> to CQ.
>
> Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
> Signed-off-by: Krishnamraju Eraparaju <krishna2@chelsio.com>
> Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
> ---
>  drivers/infiniband/sw/siw/siw_main.c  |  20 -----
>  drivers/infiniband/sw/siw/siw_verbs.c | 103 +++++++++++++++++++++-----
>  2 files changed, 86 insertions(+), 37 deletions(-)
>

I didn't follow after v1 discussion and will be glad to see changelog,
what is the reason for v2?

Thanks,
