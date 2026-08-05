Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DB73D332C
	for <linux-rdma@vger.kernel.org>; Wed,  5 Aug 2026 21:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785966862; cv=none; b=uBKTKZJl/P5/KaysO0McMLjYCFN3DIsqta2QvchHDfbcBz/MnUhRIe9LnDvKvN05JkhknBmH11xUmuWnOrAxUD1ak/I7XhEnP5ywHGP+KSIyd/ZjRkon+EuM+1lNay6Bl5FkNUyXcmfKrM6t08QIynAUpZLftEzevEqvc9+93kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785966862; c=relaxed/simple;
	bh=YeZlZj/6yv0tuSwXK9NUXrB4B2FjLvdl1dODfySsUIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CMy2bTgZks7ErN2Ka+ch0tdBzbl7Bb+qzwy8NcqxslWVlhYchY61F24t5syZqJAy/DnkogDW4EnBmEPqj50YIongoBstk6V/Ao6ffs1O17qV0vT3comtTXE+F/eg8OBJJWlZlmbVF085FNHc2fL75qCSuO9jED2M1my/XGopadQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hQx5Xi/B; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hQx5Xi/B"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cede6375caso35315ad.0
        for <linux-rdma@vger.kernel.org>; Wed, 05 Aug 2026 14:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785966861; x=1786571661; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DmFR1tIG37Sn8lWSRTTHmCfFrbBwlyIU1WQoL0/U/C4=;
        b=hQx5Xi/BdqG12bOjGJ/7e6u1rmA9vrukjDSBqLXdP5FAqtTc69F/oO4xeD1KG+uPyY
         PuHFTti5iP2c5Hmzh2x78kaaeuhOtZV4xn7YWddfFxSV3sgrxbx147wR9Dpqw5iuT7qY
         oymg3C9fCZ33U08UnY7GjKnLIL9UFSH0tUT16NOdGL+1mCWMD2ACvRcsrXsQX/1Gcsce
         wXBKgihZ3uRVH+ZKEZ8hHD/tLIndCLqT9i1rzpsgsOYNDoQRvXzANmxOaX8QP9X7ZeU8
         9yLerjMlA4aznuFCiydSxk3oUhxeRsejaugX9o8gF40xEh64HCUXsp1UFS+ma1JYrKkh
         W5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785966861; x=1786571661;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DmFR1tIG37Sn8lWSRTTHmCfFrbBwlyIU1WQoL0/U/C4=;
        b=W4whk+N5LA7BJvR0oFgPwrX0HP5z5N7RYlESbKmZK9vBUY5WMsYycYCWdaeub4hzJW
         JWem2ZXhiNPHfulD4h+aMDtXfNLeMvLHtdYPK07tcm9AMvChhH5uZ9VncXQqUH0mxNne
         3cjmB/hl9W/RrIcEdm/nKJu6YwPce2zpys/UC/xtvwCWzMdPlGppxrWz52jS+c+YK950
         gaYH1ZgZgu7ULX+HxwMkRv3ks6mfFUFjIlpK7sCj2jMFZ+/U+tkHHRpxgnRHT+27RjqS
         AglcHf3izDUzO3Jc/hsyB2S8oRDHgLM7a041n11hg9FLIYYktmoX7UPYbJHeE+tss0wI
         5AIw==
X-Forwarded-Encrypted: i=1; AHgh+RpAgwp7fuqou0B54V1sWDomiOfKaZ5p8KzHy4LSHxdsXWblKhyuab+GKhH4yRVvwF38SoCwZwtfHkex@vger.kernel.org
X-Gm-Message-State: AOJu0YwZkhV7v7ZjbfPQL7jOdvDceyCZ66xuohCiycig8HeTDuKe9rKp
	EjKRfTb7ZahtBcv3986VfyQ9VNrGIZHaCQVbTgNUAXyRh3bn/c9ag4ZFWE/O1+gqQg==
X-Gm-Gg: AR+sD10u5QReSZitQdH0d1yuDfDe3Bys048k5CY21lDlk+3heygT0k8WZxQWdAGGhQ6
	/dakBMbawT+ToeR/caaNMYUyn6YiVdEFImC/6ju1nXebdBTV4GAB6hXzCvFxqMBNkI4G1ZJWayD
	0kUJf9AkdjQUj2IQNW0y2aM0/5tvmY3+9xMM6CjfAxb7UW73nzcI3G2s7eyqaL2wZ1TthAhlL6V
	S8m2zAvjxTVeEwPCnyTRKWvBXJsZ3lElcSe3A3kQaFBpSHP9UYoBKiN8o/0c/EU+nxPWicSk1Tb
	6EjggwQPv+pGJDNdKYYK0vcZAneOhCevAio8LTnPDac8vpSvMnEcWZrOiZvpF7kTQyy8iXmbi5m
	tUV91uF88vNJ8AQiYPcw6Zif52aZ8FDvYleDaNhP3QhWMZNgfmBwR8WZSH0nBupN6VAHW3E/F62
	wjbJxy44uayoGC6/8eK9uSg5rjEg0+NX+xQCAuhaJH4JzQ/vKKAJ93phIZWNh0UpEAZC4PsMuzu
	iaCmqOreAS6Vr6mTafuykE=
X-Received: by 2002:a17:902:d58e:b0:2cf:41ba:96b8 with SMTP id d9443c01a7336-2d0f2d40656mr2783555ad.6.1785966860447;
        Wed, 05 Aug 2026 14:54:20 -0700 (PDT)
Received: from google.com (21.168.124.34.bc.googleusercontent.com. [34.124.168.21])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315863fb350sm20223659eec.8.2026.08.05.14.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 14:54:19 -0700 (PDT)
Date: Wed, 5 Aug 2026 21:54:13 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Trond Myklebust <trondmy@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>, linux-nfs@vger.kernel.org,
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-pci@vger.kernel.org,
	linux-rdma@vger.kernel.org, Shivaji Kant <shivajikant@google.com>
Subject: Re: [PATCH v3 5/5] nfs: introduce nfs_direct_extract_pages helper
Message-ID: <anOxBdQYqAB3LV64@google.com>
References: <20260715143540.3597616-1-praan@google.com>
 <20260715143540.3597616-6-praan@google.com>
 <a7fe5eadb2999b8d95595e73d3b99d76df6895a4.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7fe5eadb2999b8d95595e73d3b99d76df6895a4.camel@kernel.org>

On Wed, Aug 05, 2026 at 01:12:28PM -0700, Trond Myklebust wrote:

Hi Trond,

> On Wed, 2026-07-15 at 14:35 +0000, Pranjal Shrivastava wrote:
> > Introduce nfs_direct_extract_pages() in direct.c to centralize page
> > extraction and request creation for the Direct I/O path. The helper
> > manages extraction from the iters and builds a list of nfs_page
> > requests
> > 
> > Refactor nfs_direct_read_schedule_iovec() and
> > nfs_direct_write_schedule_iovec() to utilize the new helper, unifying
> > the extraction logic on both paths.
> > 
> > Signed-off-by: Pranjal Shrivastava <praan@google.com>
> > ---
> >  fs/nfs/direct.c | 127 ++++++++++++++++++++++++----------------------
> > --
> >  1 file changed, 64 insertions(+), 63 deletions(-)
> > 
> > diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
> > index b9ac0a67693c..d31e4720ffff 100644
> > --- a/fs/nfs/direct.c
> > +++ b/fs/nfs/direct.c
> > @@ -178,6 +178,50 @@ static void nfs_direct_release_pages(struct page
> > **pages, unsigned int npages,
> >  	}
> >  }
> >  
> > +static ssize_t nfs_direct_extract_pages(struct nfs_direct_req *dreq,
> > +					 struct iov_iter *iter,
> > +					 size_t size, loff_t *pos,
> > +					 struct list_head *list)
> > +{
> > +	bool pinned = iov_iter_extract_will_pin(iter);
> > +	struct page **pagevec = NULL;
> > +	ssize_t result, bytes = 0;
> > +	unsigned int npages, i;
> > +	size_t pgbase;
> > +
> > +	result = iov_iter_extract_pages(iter, &pagevec, size, ~0U,
> > 0, &pgbase);
> > +	if (result <= 0)
> > +		return result;
> > +
> > +	npages = (result + pgbase + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > +	for (i = 0; i < npages; i++) {
> > +		struct nfs_page *req;
> > +		unsigned int req_len = min_t(size_t, result - bytes,
> > PAGE_SIZE - pgbase);
> > +
> > +		req = nfs_page_create_from_page(dreq->ctx,
> > pagevec[i],
> > +						pinned, pgbase,
> > *pos,
> > +						req_len);
> > +		if (IS_ERR(req)) {
> > +			if (!bytes)
> > +				bytes = PTR_ERR(req);
> > +			break;
> > +		}
> > +
> > +		list_add_tail(&req->wb_list, list);
> > +		pgbase = 0;
> > +		bytes += req_len;
> > +		*pos += req_len;
> > +	}
> > +
> > +	if (i < npages) {
> > +		iov_iter_revert(iter, result - bytes);
> 
> Oopsable if bytes == PTR_ERR(req)
> 

Ack. I'll catch errors in a separate variable something like:

 ...
    for (i = 0; i < npages; i++) {
 ...
        req = nfs_page_create_from_page(...);
        if (IS_ERR(req)) {
            err = PTR_ERR(req);
            break;
        }
 ...
        bytes += req_len;
    }

    if (i < npages) {
        iov_iter_revert(iter, result - bytes);
        nfs_direct_release_pages(pagevec + i, npages - i, pinned);
    }

    kvfree(pagevec);
    return bytes ? bytes : err;

> > +		nfs_direct_release_pages(pagevec + i, npages - i,
> > pinned);
> 
> See what happens above with swap over NFS (which sets pinned = false).
> 

I see what you mean, we never got a ref (after patch 4) but we'll call
put_page() if pinned == false. I'll reduce the nfs_direct_release_pages
to the following in patch 4 (when we start using the new extract API):

static void nfs_direct_release_pages(struct page **pages, unsigned int npages,
				     bool pinned)
{
	if (pinned) 
		unpin_user_pages(pages, npages);
}


Sounds good for v5? 

Thanks,
Praan
