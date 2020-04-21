Return-Path: <SRS0=jfUh=6F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9CEDC54FCC
	for <linux-rdma@archiver.kernel.org>; Tue, 21 Apr 2020 15:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98DDB20663
	for <linux-rdma@archiver.kernel.org>; Tue, 21 Apr 2020 15:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgDUPdn (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:33:43 -0400
Received: from verein.lst.de ([213.95.11.211]:47390 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725613AbgDUPdn (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 21 Apr 2020 11:33:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3A05E68C4E; Tue, 21 Apr 2020 17:33:40 +0200 (CEST)
Date:   Tue, 21 Apr 2020 17:33:39 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Max Gurtovoy <maxg@mellanox.com>
Cc:     linux-nvme@lists.infradead.org, kbusch@kernel.org, hch@lst.de,
        sagi@grimberg.me, martin.petersen@oracle.com, jsmart2021@gmail.com,
        linux-rdma@vger.kernel.org, idanb@mellanox.com, axboe@kernel.dk,
        vladimirk@mellanox.com, oren@mellanox.com, shlomin@mellanox.com,
        israelr@mellanox.com, jgg@mellanox.com
Subject: Re: [PATCH 15/17] nvmet: Add metadata support for block devices
Message-ID: <20200421153339.GF10837@lst.de>
References: <20200327171545.98970-1-maxg@mellanox.com> <20200327171545.98970-17-maxg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327171545.98970-17-maxg@mellanox.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Mar 27, 2020 at 08:15:43PM +0300, Max Gurtovoy wrote:
> -	if (!nvmet_check_transfer_len(req, nvmet_rw_data_len(req)))
> +	if (!nvmet_check_transfer_len(req,
> +				      nvmet_rw_data_len(req) + req->md_len))

Shouldn't we also calculate the actual metadata length on the fly here?

>  	blk_start_plug(&plug);
> +	if (req->use_md)

Can't we use a non-NULL req->md_sg or non-null req->md_sg_cnt as a
metadata supported indicator and remove the use_md flag?  Maybe wrap
them in a helper function that also checks for blk integrity support
using IS_ENABLED and we can skip the stubs as well.

