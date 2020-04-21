Return-Path: <SRS0=jfUh=6F=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22648C54FD0
	for <linux-rdma@archiver.kernel.org>; Tue, 21 Apr 2020 12:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00EF12076B
	for <linux-rdma@archiver.kernel.org>; Tue, 21 Apr 2020 12:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgDUMAB (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 21 Apr 2020 08:00:01 -0400
Received: from verein.lst.de ([213.95.11.211]:46268 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726691AbgDUMAB (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 21 Apr 2020 08:00:01 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1E6D268C7B; Tue, 21 Apr 2020 13:59:59 +0200 (CEST)
Date:   Tue, 21 Apr 2020 13:59:58 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Max Gurtovoy <maxg@mellanox.com>
Cc:     linux-nvme@lists.infradead.org, kbusch@kernel.org, hch@lst.de,
        sagi@grimberg.me, martin.petersen@oracle.com, jsmart2021@gmail.com,
        linux-rdma@vger.kernel.org, idanb@mellanox.com, axboe@kernel.dk,
        vladimirk@mellanox.com, oren@mellanox.com, shlomin@mellanox.com,
        israelr@mellanox.com, jgg@mellanox.com
Subject: Re: [PATCH 02/17] nvme: Add has_md field to the nvme_req structure
Message-ID: <20200421115958.GC26432@lst.de>
References: <20200327171545.98970-1-maxg@mellanox.com> <20200327171545.98970-4-maxg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327171545.98970-4-maxg@mellanox.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Fri, Mar 27, 2020 at 08:15:30PM +0300, Max Gurtovoy wrote:
> From: Israel Rukshin <israelr@mellanox.com>
> 
> Transport drivers will use this field to determine if the request has
> metadata.

Can we make this a flags field with a bit?  Also why do we even need
it, can't we use blk_integrity_rq?
