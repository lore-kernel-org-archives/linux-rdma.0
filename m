Return-Path: <SRS0=/9Vh=WQ=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C08C3A589
	for <linux-rdma@archiver.kernel.org>; Tue, 20 Aug 2019 14:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA5F922DBF
	for <linux-rdma@archiver.kernel.org>; Tue, 20 Aug 2019 14:08:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="v4pil1Eu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbfHTOI3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 20 Aug 2019 10:08:29 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:23391 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729968AbfHTOI3 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Tue, 20 Aug 2019 10:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1566310108; x=1597846108;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=rudiA7k4Ijm/RqBJ2dAJFWab5chfRJqEeMG7NKqDENg=;
  b=v4pil1EubfqNUwCOVdh4+N2nImFaKDKMCsoplryOqTohTbRAlMXxYywH
   Dbcp90Sey6tM91wO4inKIsd8M65OQ7HN0Y+PHV/6sNRRdMB6DwYuu9tNB
   WSV6m30bcubF1pfWs557La06HQb+dGyqT2QNOZh85/6TYoDirY9EQPttg
   w=;
X-IronPort-AV: E=Sophos;i="5.64,408,1559520000"; 
   d="scan'208";a="821659690"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 20 Aug 2019 14:08:26 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 474D5221C9F;
        Tue, 20 Aug 2019 14:08:26 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 20 Aug 2019 14:08:25 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.161.230) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 20 Aug 2019 14:08:20 +0000
Subject: Re: [PATCH v7 rdma-next 1/7] RDMA/core: Move core content from
 ib_uverbs to ib_core
To:     Michal Kalderon <michal.kalderon@marvell.com>,
        <mkalderon@marvell.com>, <aelior@marvell.com>, <jgg@ziepe.ca>,
        <dledford@redhat.com>, <bmt@zurich.ibm.com>, <sleybo@amazon.com>,
        <leon@kernel.org>
CC:     <linux-rdma@vger.kernel.org>, Ariel Elior <ariel.elior@marvell.com>
References: <20190820121847.25871-1-michal.kalderon@marvell.com>
 <20190820121847.25871-2-michal.kalderon@marvell.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <0f6f1dd6-e4b3-5261-7480-0735f29bac63@amazon.com>
Date:   Tue, 20 Aug 2019 17:08:02 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820121847.25871-2-michal.kalderon@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.230]
X-ClientProxiedBy: EX13D10UWA004.ant.amazon.com (10.43.160.64) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 20/08/2019 15:18, Michal Kalderon wrote:
> diff --git a/drivers/infiniband/core/ib_core_uverbs.c b/drivers/infiniband/core/ib_core_uverbs.c
> new file mode 100644
> index 000000000000..cab7dc922cf0
> --- /dev/null
> +++ b/drivers/infiniband/core/ib_core_uverbs.c
> @@ -0,0 +1,100 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/*
> + * Copyright (c) 2005 Mellanox Technologies. All rights reserved.
> + * Copyright 2018-2019 Amazon.com, Inc. or its affiliates. All rights reserved.
> + * Copyright 2019 Marvell. All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */

Is the full license needed in addition to the SPDX?
