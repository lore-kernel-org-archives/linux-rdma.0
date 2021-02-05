Return-Path: <linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70D0C433DB
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Feb 2021 04:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7554964FA3
	for <linux-rdma@archiver.kernel.org>; Fri,  5 Feb 2021 04:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhBEEM3 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Thu, 4 Feb 2021 23:12:29 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13924 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhBEEM2 (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Thu, 4 Feb 2021 23:12:28 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601cc5830000>; Thu, 04 Feb 2021 20:11:47 -0800
Received: from [10.2.60.31] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 5 Feb
 2021 04:11:46 +0000
Subject: Re: [PATCH v2 1/4] mm/gup: add compound page list iterator
To:     Joao Martins <joao.m.martins@oracle.com>, <linux-mm@kvack.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Doug Ledford <dledford@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
References: <20210204202500.26474-1-joao.m.martins@oracle.com>
 <20210204202500.26474-2-joao.m.martins@oracle.com>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <74edd971-a80c-78b6-7ab2-5c1f6ba4ade9@nvidia.com>
Date:   Thu, 4 Feb 2021 20:11:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <20210204202500.26474-2-joao.m.martins@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612498307; bh=90hw+ICZ/gKhWm8sbsBiKwsDNH4LvCEMvipiRUiV0MM=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=LhpAcaoP90LK+h6C9NVPT0uTQMDR5adUruhZC5cyal3ffapkhntOgUvld0IvTvww4
         /K+2lyHpdwCoj8kFhCUtjNO7/H2V75pkG6KVChSn6gg2JOnyD5H0hRCoLz3Ldi7/Zf
         r3YgIcBJ9JtKRuerOeZMhNmkTmF2LkBbJIH0YHq3UkLOs7rxC7WbxhD9322HjLtYCl
         CSt8GFEnCdY0CxhkercG678mzx7Tu3VUS5Ca+G3GjyC9ZqeKUhwxDak0vOWHsc47ut
         /pclIuZ47BQD5SnLBVMOyY9Aa2tLWZQkcI2U+Y5Ja5BR58NFwT+4+pKK3NA9OFjrck
         h0rpXks7BXNZw==
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On 2/4/21 12:24 PM, Joao Martins wrote:
> Add an helper that iterates over head pages in a list of pages. It
> essentially counts the tails until the next page to process has a
> different head that the current. This is going to be used by
> unpin_user_pages() family of functions, to batch the head page refcount
> updates once for all passed consecutive tail pages.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   mm/gup.c | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index d68bcb482b11..d1549c61c2f6 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -215,6 +215,35 @@ void unpin_user_page(struct page *page)
>   }
>   EXPORT_SYMBOL(unpin_user_page);
>   
> +static inline void compound_next(unsigned long i, unsigned long npages,
> +				 struct page **list, struct page **head,
> +				 unsigned int *ntails)
> +{
> +	struct page *page;
> +	unsigned int nr;
> +
> +	if (i >= npages)
> +		return;
> +
> +	list += i;
> +	npages -= i;

It is worth noting that this is slightly more complex to read than it needs to be.
You are changing both endpoints of a loop at once. That's hard to read for a human.
And you're only doing it in order to gain the small benefit of being able to
use nr directly at the end of the routine.

If instead you keep npages constant like it naturally wants to be, you could
just do a "(*ntails)++" in the loop, to take care of *ntails.

However, given that the patch is correct and works as-is, the above is really just
an optional idea, so please feel free to add:

Reviewed-by: John Hubbard <jhubbard@nvidia.com>


thanks,
-- 
John Hubbard
NVIDIA

> +	page = compound_head(*list);
> +
> +	for (nr = 1; nr < npages; nr++) {
> +		if (compound_head(list[nr]) != page)
> +			break;
> +	}
> +
> +	*head = page;
> +	*ntails = nr;
> +}
> +
> +#define for_each_compound_head(__i, __list, __npages, __head, __ntails) \
> +	for (__i = 0, \
> +	     compound_next(__i, __npages, __list, &(__head), &(__ntails)); \
> +	     __i < __npages; __i += __ntails, \
> +	     compound_next(__i, __npages, __list, &(__head), &(__ntails)))
> +
>   /**
>    * unpin_user_pages_dirty_lock() - release and optionally dirty gup-pinned pages
>    * @pages:  array of pages to be maybe marked dirty, and definitely released.
> 

