Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D8334D901
	for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 20:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786394340; cv=none; b=lI5ZO9FzsT3U9AyolCwt/VXz9TuGt+WQ1QwmXiwMB7a+I2r2sb3NkSHqdTDO4NDUcSWdninkqlaeHmGHPBPEIwodOYVxMZ0GA8dwwiENDy+2F0b/posDddswJ3ix8qW+U4IkyJLtLOgojSkUcvpbCS8D696vh1t2qCXVygT8qZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786394340; c=relaxed/simple;
	bh=uJSRGu+secrn6ELFiY8mCeDfdirixJZ+Vh+vWqrsCQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tbDRp0mhT8nAb3ImyABmiJctqGBmz8Q7e+DHFq2HVhcKRITL4ZIWJG1s3cb1QdykLXvp1OWaGEpTJsmJ0Ey/gyg9MfOsujuJRZGOHMlLwhJ/P0YS/8MSUyRc88/QATpyH7P6IPrPQUq5E0T5Z0tW+9T1gn5O6zd+WbLja32udDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=casQjVQX; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="casQjVQX"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cab97c86bdso9035ad.1
        for <linux-rdma@vger.kernel.org>; Mon, 10 Aug 2026 13:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786394337; x=1786999137; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VYp2Tfa4a+eGAB6Piu2ik5k2VivENudTsuNWEkco40o=;
        b=casQjVQXgfPfT4a8Rp7+tK3rt+5o/mi5RbhcDsjjGAzOL2r6d06I10Q9enGM6r6yes
         3M2P/tLm/hEI23sLbSOyiCGW9dcSPqZhBwUfQ2S1/OSosPqq8tgqGWDjVm15q4WGN3n3
         gpqdbdGOJlPkLZ3Obkswmp9AhJ0OFFjV/Hj0/048RiNhIVby1lR9PezcTluSpmUy4UG2
         d/AU2zEuQZ1cqO+dRJv8+zwg8qaI72PQhNY4MFEIPkwcbKEf1VQ8wtBmNI6McGqMlLv5
         fiyQDNYSNsd+Pu9uIP4QLPeNWea076/z/0OJI9uadnXFeT9zMsrRYmo61AQ9wDQaHLCu
         l35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786394337; x=1786999137;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VYp2Tfa4a+eGAB6Piu2ik5k2VivENudTsuNWEkco40o=;
        b=KazbG+yBQvGBhcE1LblSrPsFXGCm7CDwbuWxCrhEpv2d+2U3WmQE3iS+NIAPh/5qjA
         rp4CjEfR6HCDMq4o5N7YudL3vDfFwmQIfzBsWoWxZQiCc8k2mvpjC5Mici9M7GVQhdJ9
         cvorn5JQM+LpWQC5ReFx80v9wWuxGtWw6Si1AF0h2Nl0zy5JHe+v0nJMG/VIwETA2M0s
         rLmpALLjv3T131qbJLsKxUdjwLCFQ0lPARVT8cqnk6xy/o4kLUywsxY8gkAlMnLkX3JT
         9sjFDZPZCuVev4kHUABSzjd4EKVYjKUPuqh2sq/oESF/NCJk/PDU+JxjyFuDqkQSHpPZ
         q9rA==
X-Forwarded-Encrypted: i=1; AHgh+RpATxAwsOe3k5sDJ6BkICIEOsAq8gfYi52EnXCHwABntDbrggb1iddhNRPEKBGwMkq38OHDGiFlA3AC@vger.kernel.org
X-Gm-Message-State: AOJu0YwQNMvMCzMwHVVrY/3g1RU/oXtYR8pK47ZzR0sdK02ckFROWUSK
	choFGoDzVyjy/eka9peNRjdxkXhWKUlwDmpXydreVCdXKeTlNEYVwJv2UFnkFLiCvg==
X-Gm-Gg: AR+sD12RFFIQbp8qp7lghUHfCF2zRpTxe3l8dhDT0rC2EagIpS+kqUSf9p/VGjnvkK9
	3g7COJXnYhYSdKkr34JMUElN3QfTvXzd3cvS3uxjO/CifDwrVvi/CgVOZ0zS5IlVBMGMVs/HrOe
	uYGC6wzKeIr7F0X4X6xq2/obH4B/sBGBGf/gwVaSjgv/d/5mioxYwS15FtK9JGVz8RugEHzfIL7
	HYEE7X/4lmmwzNa54INUQ2N3GMbmsazez+K1QZYuDBCj6sTCNRUaC/8W6tM6vkrOUyuPbzfKpI9
	N3aqJb/D1+Ti8aV5HbqqbhUZL/bZMNp/P9en76Lg7DGZjse64mgzoQMGx+NMDItymVvMy9invfO
	FFuWiZuYwCs8tnc5rXALrzTzbX4mUEpddpFVmG6Jf40oVs8S3c+zRFVHK/ajGuPaWAun/zNCs3g
	IEKv9KsRl8E/jl8W4WxX7Rct1k9GatRxp5NGaFxfMYtUnOxQi2aZpUOAwj28kvfR8tMtRcLMwG8
	kfCl4ZmidmBjzIMuUOvH5Y=
X-Received: by 2002:a17:902:ea0a:b0:2ce:b436:272a with SMTP id d9443c01a7336-2d31201ad00mr133605ad.3.1786394336550;
        Mon, 10 Aug 2026 13:38:56 -0700 (PDT)
Received: from google.com (21.168.124.34.bc.googleusercontent.com. [34.124.168.21])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d14ccd8f1bsm41025825ad.25.2026.08.10.13.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 13:38:55 -0700 (PDT)
Date: Mon, 10 Aug 2026 20:38:49 +0000
From: Pranjal Shrivastava <praan@google.com>
To: linux-nfs@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-pci@vger.kernel.org,
	linux-rdma@vger.kernel.org, Shivaji Kant <shivajikant@google.com>
Subject: Re: [PATCH v4 0/5] nfs: modernize direct I/O path
Message-ID: <ano2R8fAeGmsNt9f@google.com>
References: <20260810195040.2877784-1-praan@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810195040.2877784-1-praan@google.com>

On Mon, Aug 10, 2026 at 07:50:34PM +0000, Pranjal Shrivastava wrote:
> Modernize the NFS Direct I/O path as a preparatory step to enable PCI
> Peer-to-Peer DMA (P2PDMA) support. Following feedback on the initial
> RFC [1], the modernization and architectural changes are split into
> different series. Additionally, based on the discussion in the v2 [2]
> of this series, the migration of NFS Direct I/O to folios would be
> handled in a separate follow-up series.
> 
> Currently, NFS O_DIRECT relies on the legacy iov_iter_get_pages_alloc2()
> API which does not support the pinning requirements for P2P memory.
> The implementation moves NFS to the modern iov_iter_extract_pages() API.
> 

[...]

I'm calling out a few typos / non-code mistakes:

1. On the cover letter I missed updating the subject to v5 for this series
  (the changelog is noted below).

2. I also accidentally dropped Christoph's Reviewed-by tags on patches 
   1, 2, and 3 during the rebase (given while reviewing v4 [1]).

Everything else in the series is correct as per the v5 changelog.
Please let me know what the right etiquette is? Shall I resend the series?

Apologies for the noise!

> 
> [v5]
>  - Fixed an iov_iter_revert oops in nfs_direct_extract_pages().
>  - Fixed a refcount underflow in nfs_direct_release_pages() during
>    swap-over-NFS by ensuring we do not call put_page() on unpinned memory.
>  - Rebased on fs-next
> 
> [v4]
>  - https://lore.kernel.org/all/20260720150601.2702700-1-praan@google.com/
>  - Dropped superfluous externs in include/linux/nfs_page.h
>  - Scoped `req` locally inside the loop in nfs_release_request_list()
>  - Wrapped >80 character lines in Patch 1 to adhere to coding style.
>  - Fixed typos and capitalization convention in the commit msgs
>  - Collected Reviewed-by tags from Christoph and Shivaji
>  - Rebased on fs-next
> 
> [v3]
>  - https://lore.kernel.org/all/20260715143540.3597616-1-praan@google.com/
>  - Dropped patches that added folio support for NFS Direct I/O
>  - Folded requested_bytes accounting in patch 5 due to dropped folio support
>  - Rebased on fs-next
> 
> [v2] 
>  - https://lore.kernel.org/all/20260616134000.2733403-1-praan@google.com/
>  - Fix data corruption in nfs_direct_extract_pages() by correctly
>    calculating intra-page offsets using offset_in_page().
>  - Fix requested_bytes accounting in direct read/write paths to only
>    increment after successful RPC scheduling.
>  - Add missing kernel-doc descriptions for the @pinned parameter in
>    nfs_page_create_from_page() and nfs_page_create_from_folio().
>  - Rebase on fs-next/
> 
> [v1] https://lore.kernel.org/all/20260603053033.3300318-1-praan@google.com/
> 
> Pranjal Shrivastava (5):
>   nfs: make nfs_page pin-aware
>   nfs: track number of pinned pages in nfs_page
>   nfs: introduce nfs_release_request_list helper
>   nfs: migrate direct I/O to iov_iter_extract_pages
>   nfs: introduce nfs_direct_extract_pages helper
> 
>  fs/nfs/direct.c          | 139 ++++++++++++++++++++-------------------
>  fs/nfs/pagelist.c        |  62 ++++++++++++++---
>  fs/nfs/read.c            |   2 +-
>  fs/nfs/write.c           |   2 +-
>  include/linux/nfs_page.h |   8 ++-
>  5 files changed, 130 insertions(+), 83 deletions(-)
> 
> 
> base-commit: 5b57716ed7ad2f4b1724461c8777015c4e4befb1
> -- 
> 2.55.0.679.g6767b8d81c-goog
> 

Thanks,
Praan

[1] https://lore.kernel.org/all/20260720150601.2702700-1-praan@google.com/

