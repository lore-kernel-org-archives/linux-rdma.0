Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA52C47DFB9
	for <linux-rdma@vger.kernel.org>; Fri, 11 Sep 2026 12:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789131439; cv=none; b=hn1pldYVfE+AVMJCelMmtLzFIV0neNW0PPKO9fMPqO0x97x+COC3m7U5TYJaSksfCMkFharUIk+9I9l+er2agKRhNuQJUk7wHfLClXbnuYVBVwQx6zjXY1FuwztJbHoCZ1SWSe8aRqVEOVnPOVWiIw9sAN4zGCfJBOl8sk3BIdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789131439; c=relaxed/simple;
	bh=e3H047kzZPUPF30kyCAWQHM10KFTgYtPCq5VJwN9Kug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KNlZ8u9rFlI/8bIx72lX61+WYsur0iRJqIJuMKcD5fTBYK/RdyxkkAz/QaLes7jgA5jgbkOezRMwH7cs19OBcyWeU29PaNlcp1DDtuuNaiV9+7fb527WiVKprufUQhdNrJ4CUB9EAROodSTmIq3MR3BzDmOLWqE+IM6hzgGYPNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qrv2kN5i; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qrv2kN5i"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d6ff390a6cso68785ad.1
        for <linux-rdma@vger.kernel.org>; Fri, 11 Sep 2026 05:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789131428; x=1789736228; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sosg5uQD+znETrHmJcgaZWMkG/+x7W8shGk8HBCGWmk=;
        b=Qrv2kN5iQb/H4GJLXohxWSq/Y8IVw41su4WaVm/U5ZeYP6tQ8KmZUjelZ8z40vQEnK
         0+0NxNEINL2+kPrpmuOwE4RJCuqIM3XpsT47GtfNtHPpQFPtvo1dVwBTQrxX7RYbTt55
         jn/hLRJLxbtC6vafjhiZQQ3sdJSrgRo2yN6KW7MLygc6Dc/xQK++c+lB73wcxdmV3xae
         W8GDekai++p4jjeOL5aqWo2QHjIqvTpm01nyMQwSsY/FpM6UCH78lQUuh8UKTwHSrafI
         4mWDC7iPErfSp/CeNNlEwdmKKwI7jihTsmyuE1Xpo0c5H3VJlbr0zalTn/Xw0cBHiEpY
         tH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789131428; x=1789736228;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sosg5uQD+znETrHmJcgaZWMkG/+x7W8shGk8HBCGWmk=;
        b=fGHwBm+KHirdxb1MCR8Q+z29UtKQ6lpV9T3hiOi+BZKYlQSxzEsEwqt5HgVdxPRTGV
         EpBODtFbuwfl0FUXaMD5BHidxnspNdQ7+w/AFzKteOcQrzWrIxwrIhKQBVxAmfSH/5Xq
         NIgtBCOHpln7qR74nb+enm2aOOiw6ygG5yRRdzw9aaeWycAeyUF3Rdfw8MSgampoKn4T
         lSoASjFwUxz7VYs8JvSmvNNV2HXiWXY0Az4Rdihxx7xuj3/5X1Lpx6b0w3+K8ZLSGeru
         4dUOCmHlIzLFNER8nX3j1hP2XjY7V9u8w8oHqQTvPkuRfDtQ7O4uibbE1EYSTQ8F0PO3
         deaw==
X-Forwarded-Encrypted: i=1; AKwUvBwpiPGK35Gs409pKoX6PTVe0QydoGzVXIkClkNJkwgwUPdNTDlSDl72BBJ14ntm/SerpVu9EGn2S0Nv@vger.kernel.org
X-Gm-Message-State: AFuF++m5phswl313gffnBPXgqhbDYLdt1Ep11eEm1weuEhCgoi5TjTIX
	Fuo1W6Fa+juL2cYcCCC5UfnfcdtVK6h59H1aQ3/z2YLYfhserVfkjRRyhJ1PwYkLCw==
X-Gm-Gg: AYBFou1wesQMx7eXNopBsfDVpc2hQLQlUoDKoi/DK1n457yMpKVT8NnKs+vGP+/vT1s
	8u7CVlv7M6a7dfX59Fs5tGhLbxL3NViuFodLjUACGnSKmK1rkp9KkVTAlNgazx8ry6+MI25t4fp
	cvswGQXMcL5U+UjCC1fQqR9NZMOiNmEgyjKOL+ZaUuQEN9DDTVVMT/wxuu1+iiSjS45kmHtFqgL
	yb3FtZ7/KrUEGRg6TEj/qhVUJg74gsur/ZQCHtWxD/sGLq+5W6lW+hx39gJP5R7BLn+QmiPHSQ+
	Z6vdXae6th7Ra3cEG3MZlhML+FxRLn9Mw9GMROlcskd6iwLvEmGvajqp5MKkjy/29eAd/WclWwI
	d+AxoKhyp4+CazEe1ypZ8tfJfgzJm6rfUt3IwEoE2T1b8NZ9vPmR7btWKMDULEcoFBYT8CDeW1R
	U1Fe6MWUNgWda0qNjbTwHdGnN65ndthsY1/xbprXiVAWoCcW2gmPowp+il+tT4K4hiCJgn9xEW8
	K5lLbRJyL0y9wLOFdydUwl6oc0aeFYl0jI7
X-Received: by 2002:a17:902:ce02:b0:2c9:bd54:cf with SMTP id d9443c01a7336-2dd2c93436amr7077235ad.4.1789131428042;
        Fri, 11 Sep 2026 05:57:08 -0700 (PDT)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d994cf9a6sm4819382a91.10.2026.09.11.05.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 05:57:07 -0700 (PDT)
Date: Fri, 11 Sep 2026 12:57:00 +0000
From: Pranjal Shrivastava <praan@google.com>
To: linux-nfs@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-pci@vger.kernel.org,
	linux-rdma@vger.kernel.org, Shivaji Kant <shivajikant@google.com>
Subject: Re: [PATCH v6 0/5] nfs: modernize direct I/O path
Message-ID: <aqP6nM7OSX087UCs@google.com>
References: <20260814143255.861084-1-praan@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814143255.861084-1-praan@google.com>

On Fri, Aug 14, 2026 at 02:32:50PM +0000, Pranjal Shrivastava wrote:
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

Gentle ping on this series. 
(I realized that I sent it close to the merge window, Apologies).

Please let me know if anything else needs to be done for this..

[...]

> 
> [v6]
>  - Fixed double unpin bugs pointed out by Sashiko:
>    https://sashiko.dev/#/patchset/20260810195040.2877784-1-praan%40google.com
>  - Added R-bs from Christoph (due since v4)
> 
> [v5]
>  - https://lore.kernel.org/all/20260810195040.2877784-1-praan@google.com/
>  - Fixed an iov_iter_revert oops in nfs_direct_extract_pages().
>  - Fixed a refcount underflow in nfs_direct_release_pages() during
>    swap-over-NFS by ensuring we do not call put_page() on unpinned memory.
>  - Rebased on fs-next
> 

[...]

Thanks,
Praan
