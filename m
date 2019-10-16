Return-Path: <SRS0=MLWl=YJ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32437FA372A
	for <linux-rdma@archiver.kernel.org>; Wed, 16 Oct 2019 15:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06A7021928
	for <linux-rdma@archiver.kernel.org>; Wed, 16 Oct 2019 15:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571240393;
	bh=qzK1GDAPnco8+JUBQZ/mVINQqUWVxi4MReeispzJLjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GXPOBuHbIk05KMoChDLqVe+wehKjRc7GF6ZLQE9pnwOlTxkMFtj9d0w7XNQawCb+a
	 EX7OZdRWsZVsgjF5GTIsmrU4IbWupWfneQwY5muEm+M8LXkiaZiqPoeO1IdwpebnBv
	 PRqFVzFHrRW9Ap/+298vj6aw0LTnMu6RTlYt9qV4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfJPPjw (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404538AbfJPPjv (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Wed, 16 Oct 2019 11:39:51 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 345C920854;
        Wed, 16 Oct 2019 15:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571240391;
        bh=qzK1GDAPnco8+JUBQZ/mVINQqUWVxi4MReeispzJLjU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=isk5gue//oCQ3K/GgHdozTXKQr9Dhz4fcB/wdDHN94AeqSyMJ2YNi1L5NcyUYB/k+
         eDoyxWt3U4fLoZm6MQElGvkn0O1diKKAhj+rldf2cEFv5M6VDqFEvar3zb/YSHYNgn
         vLOrvGlhazrtLWPGr/aqICdNXCKE6x0R2OKbd6Ms=
Date:   Wed, 16 Oct 2019 18:39:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     ariel.elior@marvell.com, bharat@chelsio.com, dledford@redhat.com,
        jgg@ziepe.ca, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/core: Fix compatibility between driver and rdma-core
Message-ID: <20191016153943.GF6957@unreal>
References: <20191016101723.8475-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016101723.8475-1-michal.kalderon@marvell.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Oct 16, 2019 at 01:17:23PM +0300, Michal Kalderon wrote:
> Commit 30e0f6cf5acb39 ("RDMA/iw_cxgb3: Remove the iw_cxgb3 module from kernel")
> deleted one of the entries in the rdma_driver_id enum. This
> caused a mismatch between the driver-id of some drivers and rdma-core.
>
> ib_uverbs_cmd_verbs: if (unlikely(hdr->driver_id != uapi->driver_id)
>
> Added the entry back as deprecated to maintain compatibility between old/new
> rdma-core and driver. For the same reason, entry should not be removed from
> rdma-core, but modified to deprecated when cxgb3 is removed from rdma-core.
>
> Fixes: 30e0f6cf5acb39 ("RDMA/iw_cxgb3: Remove the iw_cxgb3 module from kernel")
> Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> ---
>  include/uapi/rdma/rdma_user_ioctl_cmds.h | 1 +
>  1 file changed, 1 insertion(+)
>

Thanks,
https://lore.kernel.org/linux-rdma/20191015075419.18185-2-leon@kernel.org
