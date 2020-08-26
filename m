Return-Path: <SRS0=dVsF=CE=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA8FC433DF
	for <linux-rdma@archiver.kernel.org>; Wed, 26 Aug 2020 06:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CECD02076C
	for <linux-rdma@archiver.kernel.org>; Wed, 26 Aug 2020 06:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="povnARlp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgHZGPl (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Wed, 26 Aug 2020 02:15:41 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:45088 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbgHZGPl (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Wed, 26 Aug 2020 02:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1598422541; x=1629958541;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=zBCVL0NQDyARdnqYpsf3WdENLUjBRXiAIJrZ5wNsRxE=;
  b=povnARlp34XpdXFiO2v1G5OnN2rMMV+h06HmATGL4Uore1a6C5DaD5OU
   W0BOlI1hJCAnr9fecRurufopRPxMY0PR616ucDzz52ga4oF57UcTL9Eue
   l08GltEm9InfWvL2y+Vl3b853oX2S4d4GLo4YV5INCSZ89FjrZwfr47hf
   E=;
X-IronPort-AV: E=Sophos;i="5.76,354,1592870400"; 
   d="scan'208";a="51484405"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 26 Aug 2020 06:15:38 +0000
Received: from EX13D19EUB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id 54A13A3089;
        Wed, 26 Aug 2020 06:15:36 +0000 (UTC)
Received: from 8c85908914bf.ant.amazon.com (10.43.160.6) by
 EX13D19EUB001.ant.amazon.com (10.43.166.229) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 26 Aug 2020 06:15:32 +0000
Subject: Re: [PATCH] RDMA/umem: Fix signature of stub ib_umem_find_best_pgsz()
To:     Jason Gunthorpe <jgg@nvidia.com>, <linux-rdma@vger.kernel.org>
CC:     Shiraz Saleem <shiraz.saleem@intel.com>
References: <0-v1-982a13cc5c6d+501ae-fix_best_pgsz_stub_jgg@nvidia.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <201bad07-2efc-9712-17d1-86c75c53e187@amazon.com>
Date:   Wed, 26 Aug 2020 09:15:27 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <0-v1-982a13cc5c6d+501ae-fix_best_pgsz_stub_jgg@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.160.6]
X-ClientProxiedBy: EX13D44UWC003.ant.amazon.com (10.43.162.138) To
 EX13D19EUB001.ant.amazon.com (10.43.166.229)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 25/08/2020 21:17, Jason Gunthorpe wrote:
> The original function returns unsigned long and 0 on failure.
> 
> Fixes: 4a35339958f1 ("RDMA/umem: Add API to find best driver supported page size in an MR")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/rdma/ib_umem.h | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
> index 71f573a418bf06..07a764eb692eed 100644
> --- a/include/rdma/ib_umem.h
> +++ b/include/rdma/ib_umem.h
> @@ -68,10 +68,11 @@ static inline int ib_umem_copy_from(void *dst, struct ib_umem *umem, size_t offs
>  		      		    size_t length) {
>  	return -EINVAL;
>  }
> -static inline int ib_umem_find_best_pgsz(struct ib_umem *umem,
> -					 unsigned long pgsz_bitmap,
> -					 unsigned long virt) {
> -	return -EINVAL;
> +static inline unsigned long ib_umem_find_best_pgsz(struct ib_umem *umem,
> +						   unsigned long pgsz_bitmap,
> +						   unsigned long virt)
> +{
> +	return 0;
>  }
>  
>  #endif /* CONFIG_INFINIBAND_USER_MEM */
> 

Reviewed-by: Gal Pressman <galpress@amazon.com>
