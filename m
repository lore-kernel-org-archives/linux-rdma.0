Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9016D326D55
	for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 14:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786718257; cv=none; b=IwyA15hc1Q0csPa8SUa5TG7be0X4OZxhUcm3tRoOG3TkIEeOvg1bESIU9N2d/ho3d/IR9iu7GKdHB98ZmTM1Z4zsm6wEcKEq+VH6h5QUuOcxDBljnw5/pfPSeJhuNra/Eg7df3n9DzyvVJQfU2hlyiFkEBxorQBVGZbqsFa3I0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786718257; c=relaxed/simple;
	bh=8HY0wtknzHE1zM0Bt/3qPku0pGktneOD8Vol90D/JnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OnfrDKzzqTG5y5KDZm9fvsFSsp0rxYquWewyRsx5e2E/1DTBNivJgJh/PlB0Uoia3zo4VBXZnr4KBga7pK4ZY+ugTSwgJL0vRAS/jGERdyRkOZ0Za5CY7WVa8rE33pQvs3m6r2Ez3OqWEBq3nujL79F94/G2dCVFcBlNoaQf8vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aihDdt9L; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aihDdt9L"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c10ed63c0so234011cf.1
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 07:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786718249; x=1787323049; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pnSp8kF5uifmNKvBVfAG+ZOgXVW+rCKTiYJb35Z6MS8=;
        b=aihDdt9L1ektfKzp9mKuZNAUZaxydoOhm28YFwiX5GnLvkomUaSLq429uUyiubOvxf
         buTHnNI6bZk04Oe9ibf+/VkXp8ZcgNCq4vh7s1raqPjhBNcYyfTK6eDkYwaPukiJ+XMo
         58LPuXBBadUkr80PKvpQmp+ViB9GEERoMZS92BrGTCpmSDqJX+UMW350+dU2iwDk4rT+
         MGE365CJN9Jx+eNIuvPEwI18LBTmuO/L+TcNcg8n6noyOrf7P4YLjorncU89z27YsfVp
         UguiCh6qlEDvESLMovkrAuYxSLvzQR1uHdeQ/zdGj7HoiUZGfyGP/iZlFT4ceipl5IkJ
         TbeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786718249; x=1787323049;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pnSp8kF5uifmNKvBVfAG+ZOgXVW+rCKTiYJb35Z6MS8=;
        b=sa/xytxBYTGdAoes02zRJ2Jk0llKB9rewmijI8ahVE4Oyc0wnGowDJb32bVL5z7Yv3
         dU6GbJyVxvQ/kQf+Z4n/IVf+y1xhJJVnRlFBbflNCN1JW1RJ7GJD+J3NBlqQt34voWOo
         wwDzie5343uqYz82ZuFHthArG/zGE6TAL7NLssCn1Lsdk9m8q5d1apNN7dbIjD7ayEJZ
         mTFju1n3cac8w+hiFq6bMAfIGooG8E5ECpBceN5KYphZz8CqnDw1EERed2dGCsb+r0Ja
         7eoYUAk3mg3iJ/TscnJKVAoRGMej7rYL6XrZQEeDcXO3flgLAT+f1BFK7gkh8e/HHuN9
         hkVg==
X-Forwarded-Encrypted: i=1; AHgh+RolCPSiGp1NTt2BqorfbX0fspsuM63o6Y7LcQHMXBDNdZwapAyrZICvo6RfXvrBOqtnwPN5YZCFVkiF@vger.kernel.org
X-Gm-Message-State: AOJu0YybQzNPMNFoCL27YwSLYTMxuQZvS2L2PTVIbFKI/sYG5Rq2ULyn
	gGRp7MTkPXWHfwVrmeZGQhYzTY1+zeJbBIodF5L4s+dk2vlk+4UMCNXyb2nI4CVLSw==
X-Gm-Gg: AR+sD11hwUzZ5TPvMFHdRSGbMc5Kf2060lqYjqYMs1wTK670OJVhkBBn8L+96m5iC6n
	gQEZ4xm41dRdYu19XEEcfxnQwmeQWItg8fFySZve/f4k8aer/Vei72jN8go5uSojo0f/rVp9W6k
	344n02a3ON7O+FTfr41h4yEFBH7GSzjvWcJc7yfRDUw2fPGySMDSVSzMSFtNqZpKhWNw/a/r0vv
	axojqnS/f/lfJVSzeQo+eWRLUl/Q2Mc7DAOaSek7a+YhY1I1JR04DYBwnmJVJ7th6wyR3c4YqZC
	y1Onjrd4nC/TUhAuq0bmYJIfy0iSH+9GJTUw/Y5PjJtk3EOnDZ4f0+UzKm/UiZQukYLZ/UlMwey
	l1fSHcxlh0xabHOa0oT66wGggna1shgfaa7J3XmYnMFxAqZMHX2yDln53I7dkSAAFUqSU0Yrd4o
	GxCO5Eu/99zuGNuipcy9FozlxqgzQZ0f3f/nPcMgBqSk4rW2tHUf2xriypgaSJwznBdca9i2AfJ
	mizpBR8DwKTjUQlD7p4djw=
X-Received: by 2002:ac8:5f8b:0:b0:50d:edb1:6bd1 with SMTP id d75a77b69052e-52d8631482cmr14545171cf.13.1786718248227;
        Fri, 14 Aug 2026 07:37:28 -0700 (PDT)
Received: from google.com (21.168.124.34.bc.googleusercontent.com. [34.124.168.21])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a921e6f51sm20444946d6.8.2026.08.14.07.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 07:37:27 -0700 (PDT)
Date: Fri, 14 Aug 2026 14:37:21 +0000
From: Pranjal Shrivastava <praan@google.com>
To: linux-nfs@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-pci@vger.kernel.org,
	linux-rdma@vger.kernel.org, Shivaji Kant <shivajikant@google.com>
Subject: Re: [PATCH v4 0/5] nfs: modernize direct I/O path
Message-ID: <an8oIS2WA5CdQGVQ@google.com>
References: <20260810195040.2877784-1-praan@google.com>
 <ano2R8fAeGmsNt9f@google.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ano2R8fAeGmsNt9f@google.com>

On Mon, Aug 10, 2026 at 08:38:49PM +0000, Pranjal Shrivastava wrote:
> On Mon, Aug 10, 2026 at 07:50:34PM +0000, Pranjal Shrivastava wrote:
> > Modernize the NFS Direct I/O path as a preparatory step to enable PCI
> > Peer-to-Peer DMA (P2PDMA) support. Following feedback on the initial
> > RFC [1], the modernization and architectural changes are split into
> > different series. Additionally, based on the discussion in the v2 [2]
> > of this series, the migration of NFS Direct I/O to folios would be
> > handled in a separate follow-up series.
> > 
> > Currently, NFS O_DIRECT relies on the legacy iov_iter_get_pages_alloc2()
> > API which does not support the pinning requirements for P2P memory.
> > The implementation moves NFS to the modern iov_iter_extract_pages() API.
> > 
> 
> [...]
> 
> I'm calling out a few typos / non-code mistakes:
> 
> 1. On the cover letter I missed updating the subject to v5 for this series
>   (the changelog is noted below).
> 
> 2. I also accidentally dropped Christoph's Reviewed-by tags on patches 
>    1, 2, and 3 during the rebase (given while reviewing v4 [1]).
> 
> Everything else in the series is correct as per the v5 changelog.
> Please let me know what the right etiquette is? Shall I resend the series?
> 
> Apologies for the noise!
> 

Quick update: 
I've posted a v6 [1] with fixes for unpin bugs reported by Sashiko [2]
and with R-bs from Christoph that were dropped mistakenly in v5.

Thanks,
Praan

[1] https://lore.kernel.org/all/20260814143255.861084-1-praan@google.com/
[2] https://sashiko.dev/#/patchset/20260810195040.2877784-1-praan%40google.com
