Return-Path: <SRS0=E0T5=XV=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B9AC432C2
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Sep 2019 11:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89C5F21D56
	for <linux-rdma@archiver.kernel.org>; Thu, 26 Sep 2019 11:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfIZLtI (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 26 Sep 2019 07:49:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:19991 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbfIZLtI (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Thu, 26 Sep 2019 07:49:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 04:49:07 -0700
X-IronPort-AV: E=Sophos;i="5.64,551,1559545200"; 
   d="scan'208";a="183599215"
Received: from ddalessa-mobl.amr.corp.intel.com (HELO [10.254.207.81]) ([10.254.207.81])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 26 Sep 2019 04:49:04 -0700
Subject: Re: [PATCH] IB/hfi1: prevent memory leak in sdma_init
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190925144543.10141-1-navid.emamdoost@gmail.com>
From:   Dennis Dalessandro <dennis.dalessandro@intel.com>
Message-ID: <84ce2808-4447-cc13-1756-60617336fa1d@intel.com>
Date:   Thu, 26 Sep 2019 07:49:03 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190925144543.10141-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 9/25/2019 10:45 AM, Navid Emamdoost wrote:
> In sdma_init if rhashtable_init fails the allocated memory for
> tmp_sdma_rht should be released.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>   drivers/infiniband/hw/hfi1/sdma.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
> index 2395fd4233a7..2ed7bfd5feea 100644
> --- a/drivers/infiniband/hw/hfi1/sdma.c
> +++ b/drivers/infiniband/hw/hfi1/sdma.c
> @@ -1526,8 +1526,11 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
>   	}
>   
>   	ret = rhashtable_init(tmp_sdma_rht, &sdma_rht_params);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		kfree(tmp_sdma_rht);
>   		goto bail;
> +	}
> +
>   	dd->sdma_rht = tmp_sdma_rht;
>   
>   	dd_dev_info(dd, "SDMA num_sdma: %u\n", dd->num_sdma);
> 

Yeah looks like a problem to me, thanks.

Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
