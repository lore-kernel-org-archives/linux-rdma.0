Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32245545297
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 15:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790178349; cv=none; b=qbTqkJvL1/2k8JCMHj9hMwgUbcqdgSh0PfrE5vPGoAK+FH1C82s57epcvuBICEYtrx+/DiUTwoEWGwES36m9vloBZ5fz8EKsGH9Jfldp3E25QjAVFFXpNE1TPM36KyftfTgIOMZXDg3uwLZv/wIr1FwNfRgey/kAwcJG1f48qhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790178349; c=relaxed/simple;
	bh=VbErMnDA/GhFZlNmYlglp3yJ0ywP2JBgE12YxfxXd3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PwO9qCmSWSqZdigQaqGrmDNkfJ4OcxQfmCCITuVh/ZBk6m+88aNSv/UknDhBZ2EODytnmi+oO6iEilXdwrjegtkp4LewBHcuFfsQ/XjK9fCvti6bZXB9o5glLKxup1OZ7jORpWAkWk7SXqpw49KcFkeYoFypdQDIVA8nfMD5L+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=PZEtKmJC; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="PZEtKmJC"
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-895353e9051so14632237b3.0
        for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790178346; x=1790783146; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hl5c+nDp55q10FL2fP3DxEWHpXYEUr3EHlApS5pPHcs=;
        b=PZEtKmJCJ2kLmP4vkK+xCrfiLxnrytjNrPJZHGjKpTtxYJ0djR2KMnviAhONollIzU
         YhjckkpX809jrvuz3K8YKrY20yQn1UUUf76+u8s+S84rE/HWPWTifkF73AhquiH0H44e
         VT4lEE8r9t+GjtcrLBYHQZ8gSqwbpwrZxImyv4a+pbW3YYkwma8MX9RIV5oj53lLxWhN
         vpx+Y6lkQwgLO52Ka9WacvAlppSBmCYdA75nk9lxnUbs/os0EXj0JEbA5bItpMVeghK8
         7fvEBG6gDV2mH5L/0szgS2GMPT7RQUExWDF3jUlCQLaiS8RrCSwE5WT/jwf0aN0lv1b/
         6qsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790178346; x=1790783146;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hl5c+nDp55q10FL2fP3DxEWHpXYEUr3EHlApS5pPHcs=;
        b=JRqLRrhqUZYi/ncDMg0uNollbVN+1apLtkd5UiyIy338CgBUbMcpPqJNUSFXKCq2Dp
         Ff/fLTciiDzj/cM9h+gNBdYuth413Yfn7ujgbUCCPg3mcZ1HzQGQu2GfjvrVdvPPMmov
         dxiTaYgnufaBV4Lvbrhiapip5Fl+/T8bAzNTlD0egTcGssD8+pHEK3w0hZLPrkJGgwAa
         KArSbhbfa1t2+JzXF5yHE594MS4U08aj8Mo4UHo99dKcqyKjiT4U2qJDJDRd7cYS7DCG
         b12eubbY6eJz11utLquXYF5/Yk9COr7O7FagfNNdTpQGzyGs5I42tY1rq6S4Kgr+BoMY
         MmIw==
X-Forwarded-Encrypted: i=1; AKwUvBz9+Vd1r0wak2UwIkrWcSR7Lo/n/sbP7LDHr1PlCNpkAsFiYkewFD3Nc8xemBCGixSUC4qbb4GGi07O@vger.kernel.org
X-Gm-Message-State: AFuF++kRJPyoQ5Zkjr9Nt2LW8aHH0hmVyr6lAe0HAk6/YTZ8wXUawTvK
	kjRyDPt/B04FhlRnY9bw8FHomhmX7oxnXVlg5xcTHHSXlUyqmQNn21eujb4W4QfN8vtYXMEJcF4
	QvQLj
X-Gm-Gg: AYBFou3Z97bPEVJD6zkerlRTGVLsCuaRbc8coRQwZTovQ8KcrECgwndR9/QMscn6foN
	zxDAvt7uq2YzWlMcvtBNFgZAbQnlNtVydwtOl18Y2kDjWNRo6Qyit6XxGrcx7+G91hGxXftmvx6
	FPTtuvLSb3meGRznN55m5AhlFQQjreRoguJG01jXXpovMu2OByadXTw2jptTymOCQsHEPYVQ2vX
	nzsMri9q7ZUCZHuZ2rhgt7L5ydUy3vmkPO3yRTbcf9dwJ3Gl7k/KOnoKVSxwtM5j35q+Ke70HZF
	uY2H0ulChNCX1tUBpYpw2f4cerG+0olXISMBd0bbwnC48MvQL2esnffRTcVNIIRRD6KHGdt8Jyq
	rn9JM0E4eEr5QrDSs4dMn6hRoRD5CrmHtEvuaL13rcEkFwcXdd9I+KnZLPK2Z1AVEtqj57Nf7UU
	Kqr5BP/rwe/9aXaVBdlZ/tb7eLeTMrLDLBiDAKRGIpo4bK
X-Received: by 2002:a05:690c:9985:b0:8a0:645d:2953 with SMTP id 00721157ae682-8a45c64b100mr21200397b3.66.1790178345941;
        Wed, 23 Sep 2026 08:45:45 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a4662b824dsm11392037b3.30.2026.09.23.08.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 08:45:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x9PAF-0000000Dv2z-1B5c;
	Wed, 23 Sep 2026 12:45:43 -0300
Date: Wed, 23 Sep 2026 12:45:43 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>, linux-rdma@vger.kernel.org,
	lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/mlx5: Restore flow_attr-first layout in leftovers
 flow rules
Message-ID: <20260923154543.GI1540250@ziepe.ca>
References: <20260917111722.1723-1-lirongqing@baidu.com>
 <179016730862.3410790.15823629589301922889.b4-ty@kernel.org>
 <20260923124547.GR563127@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923124547.GR563127@unreal>

On Wed, Sep 23, 2026 at 03:45:47PM +0300, Leon Romanovsky wrote:
> On Wed, Sep 23, 2026 at 08:41:48AM -0400, Leon Romanovsky wrote:
> > 
> > On Thu, 17 Sep 2026 19:17:22 +0800, lirongqing wrote:
> > > Commit e91fb8b9d0ed ("RDMA/mlx5: Avoid flexible array warning") split
> > > the leftovers_specs[] array into two separate structs to silence the
> > > "array of flexible structures" sparse warning, but in doing so
> > > reversed the member order: eth_flow was placed before flow_attr.
> > > 
> > > _create_flow_rule() locates the flow specs with:
> > > 
> > > [...]
> > 
> > Applied, thanks!
> 
> I dropped it, as it causes to flex array errors to return.

Yeah, but the bug is real..

There is a macro for this case:

	static TRAILING_OVERLAP(struct ib_flow_attr, flow_attr, flows,
		struct ib_flow_spec_eth eth_flow;
	) leftovers_wc = { .flow_attr = { .num_of_specs = 1,

Jason
