Return-Path: <SRS0=0J7V=ZK=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B2DC43141
	for <linux-rdma@archiver.kernel.org>; Mon, 18 Nov 2019 12:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 364FB20857
	for <linux-rdma@archiver.kernel.org>; Mon, 18 Nov 2019 12:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfKRMB0 (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Mon, 18 Nov 2019 07:01:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:37310 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726518AbfKRMBZ (ORCPT <rfc822;linux-rdma@vger.kernel.org>);
        Mon, 18 Nov 2019 07:01:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8ECD9AFF6;
        Mon, 18 Nov 2019 12:01:20 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id CAC881E4AFE; Mon, 18 Nov 2019 10:47:37 +0100 (CET)
Date:   Mon, 18 Nov 2019 10:47:37 +0100
From:   Jan Kara <jack@suse.cz>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 06/24] goldish_pipe: rename local pin_user_pages()
 routine
Message-ID: <20191118094737.GD17319@quack2.suse.cz>
References: <20191115055340.1825745-1-jhubbard@nvidia.com>
 <20191115055340.1825745-7-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191115055340.1825745-7-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org

On Thu 14-11-19 21:53:22, John Hubbard wrote:
> 1. Avoid naming conflicts: rename local static function from
> "pin_user_pages()" to "pin_goldfish_pages()".
> 
> An upcoming patch will introduce a global pin_user_pages()
> function.
> 
> Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/platform/goldfish/goldfish_pipe.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
> index cef0133aa47a..7ed2a21a0bac 100644
> --- a/drivers/platform/goldfish/goldfish_pipe.c
> +++ b/drivers/platform/goldfish/goldfish_pipe.c
> @@ -257,12 +257,12 @@ static int goldfish_pipe_error_convert(int status)
>  	}
>  }
>  
> -static int pin_user_pages(unsigned long first_page,
> -			  unsigned long last_page,
> -			  unsigned int last_page_size,
> -			  int is_write,
> -			  struct page *pages[MAX_BUFFERS_PER_COMMAND],
> -			  unsigned int *iter_last_page_size)
> +static int pin_goldfish_pages(unsigned long first_page,
> +			      unsigned long last_page,
> +			      unsigned int last_page_size,
> +			      int is_write,
> +			      struct page *pages[MAX_BUFFERS_PER_COMMAND],
> +			      unsigned int *iter_last_page_size)
>  {
>  	int ret;
>  	int requested_pages = ((last_page - first_page) >> PAGE_SHIFT) + 1;
> @@ -354,9 +354,9 @@ static int transfer_max_buffers(struct goldfish_pipe *pipe,
>  	if (mutex_lock_interruptible(&pipe->lock))
>  		return -ERESTARTSYS;
>  
> -	pages_count = pin_user_pages(first_page, last_page,
> -				     last_page_size, is_write,
> -				     pipe->pages, &iter_last_page_size);
> +	pages_count = pin_goldfish_pages(first_page, last_page,
> +					 last_page_size, is_write,
> +					 pipe->pages, &iter_last_page_size);
>  	if (pages_count < 0) {
>  		mutex_unlock(&pipe->lock);
>  		return pages_count;
> -- 
> 2.24.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
