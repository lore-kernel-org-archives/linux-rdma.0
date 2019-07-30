Return-Path: <SRS0=GXMw=V3=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D75B6C433FF
	for <linux-rdma@archiver.kernel.org>; Tue, 30 Jul 2019 23:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3C1C206E0
	for <linux-rdma@archiver.kernel.org>; Tue, 30 Jul 2019 23:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfG3Xeq (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 30 Jul 2019 19:34:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:22466 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfG3Xeq (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 30 Jul 2019 19:34:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jul 2019 16:34:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,327,1559545200"; 
   d="scan'208";a="196124120"
Received: from iweiny-desk2.sc.intel.com ([10.3.52.157])
  by fmsmga004.fm.intel.com with ESMTP; 30 Jul 2019 16:34:45 -0700
Date:   Tue, 30 Jul 2019 16:34:45 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     Tony Luck <tony.luck@intel.com>
Cc:     Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Parav Pandit <parav@mellanox.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IB/core: Add mitigation for Spectre V1
Message-ID: <20190730233444.GA13835@iweiny-DESK2.sc.intel.com>
References: <20190730202407.31046-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730202407.31046-1-tony.luck@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Tue, Jul 30, 2019 at 01:24:07PM -0700, Tony Luck wrote:
> Some processors may mispredict an array bounds check and
> speculatively access memory that they should not. With
> a user supplied array index we like to play things safe
> by masking the value with the array size before it is
> used as an index.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Tested-by: Ira Weiny <ira.weiny@intel.com>

> ---
> 
> [I don't have h/w, so just compile tested]
> 
>  drivers/infiniband/core/user_mad.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
> index 9f8a48016b41..fdce254e4f65 100644
> --- a/drivers/infiniband/core/user_mad.c
> +++ b/drivers/infiniband/core/user_mad.c
> @@ -49,6 +49,7 @@
>  #include <linux/sched.h>
>  #include <linux/semaphore.h>
>  #include <linux/slab.h>
> +#include <linux/nospec.h>
>  
>  #include <linux/uaccess.h>
>  
> @@ -888,6 +889,7 @@ static int ib_umad_unreg_agent(struct ib_umad_file *file, u32 __user *arg)
>  	mutex_lock(&file->port->file_mutex);
>  	mutex_lock(&file->mutex);
>  
> +	id = array_index_nospec(id, IB_UMAD_MAX_AGENTS);
>  	if (id >= IB_UMAD_MAX_AGENTS || !__get_agent(file, id)) {
>  		ret = -EINVAL;
>  		goto out;
> -- 
> 2.20.1
> 
