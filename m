Return-Path: <SRS0=fADM=YW=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37049CA9EAE
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Oct 2019 12:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04BCD208E3
	for <linux-rdma@archiver.kernel.org>; Tue, 29 Oct 2019 12:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfJ2MPF (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Tue, 29 Oct 2019 08:15:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:43109 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbfJ2MPF (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Tue, 29 Oct 2019 08:15:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Oct 2019 05:15:05 -0700
X-IronPort-AV: E=Sophos;i="5.68,243,1569308400"; 
   d="scan'208";a="203546862"
Received: from ddalessa-mobl.amr.corp.intel.com (HELO [10.254.206.224]) ([10.254.206.224])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 29 Oct 2019 05:15:02 -0700
Subject: Re: [PATCH hmm 06/15] RDMA/hfi1: Use mmu_range_notifier_inset for
 user_exp_rcv
To:     Jason Gunthorpe <jgg@ziepe.ca>, Jerome Glisse <jglisse@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Felix.Kuehling@amd.com
Cc:     linux-rdma@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        Ben Skeggs <bskeggs@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>
References: <20191015181242.8343-1-jgg@ziepe.ca>
 <20191015181242.8343-7-jgg@ziepe.ca>
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
Message-ID: <fbe0ba5a-916b-c631-3faa-74f18909643c@intel.com>
Date:   Tue, 29 Oct 2019 08:15:00 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015181242.8343-7-jgg@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 10/15/2019 2:12 PM, Jason Gunthorpe wrote:
> From: Jason Gunthorpe <jgg@mellanox.com>
> 
> This converts one of the two users of mmu_notifiers to use the new API.
> The conversion is fairly straightforward, however the existing use of
> notifiers here seems to be racey.
> 
> Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

Typo in subject s/inset/insert.

Tested-by: Dennis Dalessandro <dennis.dalessandro@intel.com>

Thanks

-Denny
