Return-Path: <linux-rdma-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6793DC54EAA
	for <linux-rdma@archiver.kernel.org>; Mon, 30 Jan 2023 12:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236882AbjA3MfP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 30 Jan 2023 07:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbjA3MfO (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Mon, 30 Jan 2023 07:35:14 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EE14211;
        Mon, 30 Jan 2023 04:35:10 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1ED3168D09; Mon, 30 Jan 2023 13:35:06 +0100 (CET)
Date:   Mon, 30 Jan 2023 13:35:05 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Eric Dumazet <edumazet@google.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 00/13] Add RDMA inline crypto support
Message-ID: <20230130123505.GA19948@lst.de>
References: <cover.1673873422.git.leon@kernel.org> <20230118073654.GC27048@lst.de> <ac48766a-b861-4fc0-3171-7b23f175c672@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac48766a-b861-4fc0-3171-7b23f175c672@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Wed, Jan 18, 2023 at 04:20:27PM +0200, Max Gurtovoy wrote:
> Today, if one would like to run both features using a capable device then 
> the PI will be offloaded (no SW fallback) and the Encryption will be using 
> SW fallback.

It's not just running both - it's offering both as currently registering
these fatures is mutally incompatible.
