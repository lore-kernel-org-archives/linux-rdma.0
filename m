Return-Path: <SRS0=vtQQ=3G=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75E0C33CB1
	for <linux-rdma@archiver.kernel.org>; Fri, 17 Jan 2020 17:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A576F20728
	for <linux-rdma@archiver.kernel.org>; Fri, 17 Jan 2020 17:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgAQROd (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 17 Jan 2020 12:14:33 -0500
Received: from mga14.intel.com ([192.55.52.115]:18058 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbgAQROc (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Fri, 17 Jan 2020 12:14:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 09:14:32 -0800
X-IronPort-AV: E=Sophos;i="5.70,330,1574150400"; 
   d="scan'208";a="214543568"
Received: from ddalessa-mobl.amr.corp.intel.com (HELO [10.254.201.179]) ([10.254.201.179])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Jan 2020 09:14:30 -0800
Subject: Re: [PATCH] IB/hfi1: Fix logical condition in msix_request_irq
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20200116222658.5285-1-natechancellor@gmail.com>
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
Message-ID: <2fb6f478-4ca5-0f52-a818-20c3d97730c2@intel.com>
Date:   Fri, 17 Jan 2020 12:14:29 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200116222658.5285-1-natechancellor@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 1/16/2020 5:26 PM, Nathan Chancellor wrote:
> Clang warns:
> 
> drivers/infiniband/hw/hfi1/msix.c:136:22: warning: overlapping
> comparisons always evaluate to false [-Wtautological-overlap-compare]
>          if (type < IRQ_SDMA && type >= IRQ_OTHER)
>              ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~
> 1 warning generated.
> 
> It is impossible for something to be less than 0 (IRQ_SDMA) and greater
> than or equal to 3 (IRQ_OTHER) at the same time. A logical OR should
> have been used to keep the same logic as before.
> 
> Link: https://github.com/ClangBuiltLinux/linux/issues/841
> Fixes: 13d2a8384bd9 ("IB/hfi1: Decouple IRQ name from type")
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
