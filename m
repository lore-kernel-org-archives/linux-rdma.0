Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEA0C433B4
	for <linux-rdma@archiver.kernel.org>; Mon,  5 Apr 2021 05:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4929D61399
	for <linux-rdma@archiver.kernel.org>; Mon,  5 Apr 2021 05:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhDEFwv (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 5 Apr 2021 01:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231590AbhDEFwv (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 5 Apr 2021 01:52:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4F3961393;
        Mon,  5 Apr 2021 05:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617601965;
        bh=1fySX/wpQNMOAvlx875E/VNopNCCqH+BRivsyhOXwi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qnQVshEVT5SnOo+BZywVVWwoCHQDluQE77pqGDqBzLmPEa6kcO7LwFsBRtAeZo6vr
         ezETajiFrIH9tslLPHyou0bOaLW9YmS1sYRvYmxFa2gog/MUympm/y4Apy1NFN0tlM
         Ub84t/G97NlV4ljd+S49I938+XbD8/wSAVlGjTZfy6wIOj9Sm70e91lm0hOw8lsCks
         bb+Gn3u7dXX4PX+9LFuUuGbQsdzihYPZempudREbedNeiFnaFshkXzg9tLNGG1CjWg
         EIyhMio0U0qiPLiShl9KhG3nSFTcaGK2f0mR4FdWDjUEAguoitGwTL/lnRc0lhcttH
         dVmxVI5u95PmQ==
Date:   Mon, 5 Apr 2021 08:52:41 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Mark Bloch <mbloch@nvidia.com>, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Mark Bloch <markb@mellanox.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] RDMA/addr: potential uninitialized variable in
 ib_nl_process_good_ip_rsep()
Message-ID: <YGqlqQyhM5kpar9U@unreal>
References: <YGcES6MsXGnh83qi@mwanda>
 <YGmWB4fT/8IFeiZf@unreal>
 <1b21be94-bf14-9e73-68a3-c503bb79f683@nvidia.com>
 <20210405054140.GY2065@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405054140.GY2065@kadam>
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Mon, Apr 05, 2021 at 08:41:41AM +0300, Dan Carpenter wrote:
> Could you send that and give me a reported-by?  I'm going AFK for a
> week.

Sure, we will handle it.

Thanks for the report.

> 
> regards,
> dan carpenter
> 
