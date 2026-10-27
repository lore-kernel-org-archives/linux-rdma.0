Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793102254;
	b=QrUrhzuwd4iVDaKOo7e1v6FvsW03IaqMFUT8by7lf4TZN4eP4Q7KgKWanBKK3EaBi2/7
	 f+LL/9Z/2l2B19vLFOjtwO0JOgnbSMP+sNcW+VuCvNBrxpbc4hOXhYcQS0Oxf9rKUxbGA
	 AVcnA9bSwHPIyuf3pQ5j+oNpDvF/qbSRME3riT6BGWkbnLsLDQAf2Q/JOFSW4dwPTRokj
	 YUGq+uS8lc6W1HgtXdyYLUpncP6xHASOx8+Z249+56wLX6/E3MvghG8h+Y0301lPpEf9V
	 lpCvoIBLJOcAdZZTiK5V7jNEXxrTbK4EVBeCvBv9996PpnpA5SzCYXOntIxjNXNKepg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793102254;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=U88qweYnCYrU71r8T0Ehm+T7NZ7CYd13glJQesIl94g=;
	b=YB9fSnMkJdZCD1/H7zNOfmFWxFoXj2xLJxkbau6d/58HhavXq3yr0aOnJJb+BhctcQ4m
	 jZV0gVRa97K/DKLHmLTGH9nutjtQGycKyVOkur5G7tMS+dMqLhE7icDccysP8gxzMPue0
	 3rQ4D4xkUohybYQwgVIRdDKehZIUiAeWzdx8jyZNPk2aciBoVaFT/iRMxgHSlELikoBf+
	 tl1RvVD6hbWn87lLYcAMxlYuGSpSPWgOVzeVKl2Fd21hZrFAAs3QVqhibg5RCaJs4TOA+
	 ICOTVgDMtELl3IX+COwvbH3nfiEC0rVndkiMZegD4BFTiv8fO1/r1ACpbt1E0+msnHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=MWn5tv2T;
	arc=none smtp.remote-ip=209.85.214.177
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95347606A31B
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 11:57:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95347606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=MWn5tv2T
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ea7f9c11e6so52795ad.0
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 04:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793102253; x=1793707053; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U88qweYnCYrU71r8T0Ehm+T7NZ7CYd13glJQesIl94g=;
        b=MWn5tv2T6nORDeJlQMGcbmz+uBELnLCHME98VH01oxejJGbCyGKqQvoYP7SB7tNzfD
         fM4lpxigjR4nEWb1/NfNxyRTHKIZxjM1brk43cS15K37TfS0M/0TtT8OVt2e89FNfSSX
         eFBXqk2qG8sUrc9fZejphgPPjd28UAjshJjh77JTbgNUuodEUxyOPogHGFzQCTkUEGXi
         ZFIJ1BdAI0mp8oz39hADY8jXtwzx4I1GjJek5MAhLC9sbrr22nx+2UnNndl4rJRyIPtQ
         tKu3VdgEgnf/C6kPIuhNkEVZYiT7zhQ0v8l78a+igWsJLKXYfGFRUltlbMJoh2Pj7wGQ
         QRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793102253; x=1793707053;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U88qweYnCYrU71r8T0Ehm+T7NZ7CYd13glJQesIl94g=;
        b=PkbLsKlRU2qJey3Pyy72upKBon8UP3FV7IElZmWtPNx9s4H/Bjd7DDJVW5u4axErGT
         8sLLhzraWMJR0+3jo1zoi7ju+n9f5YeploENeZS8ztyz0pdcxckotOh8fERY6yTNn+nW
         YWL04mMmkr39krqzOcvRPQAbccIvEMv+6QxIIIwTJ7PHkNAu2kxNa6rAHxWhm2tRg6ta
         1zjDFZXrx7yxOPCfFxsMIuImD0xzfgwiUXVbyfyd3P9OAl1/Ra83jC0/7PUNGCxQ8akk
         v1h5mlHbSLTmFX3jSkxJm5BXW7j8OHgJcz/UVk5LPwVaEaRgEu0aldAABZLAh4+u5Rmw
         h9jA==
X-Forwarded-Encrypted: i=1; AKwUvBznrp4MB+sEqxtxsXtVYrblnknToPoKpQBCvgBUT9FRU7T2QpRbFgxUgRbDVqMB2QeNg6GPNXdtWJ84@vger.kernel.org
X-Gm-Message-State: AFq9FYILvg7lgt5dGzWUjj1YLP20SRJOqI3RxrL61zYvTpKyc1MRpwHz
	Kw8Bbvl6NuH/lW2ceU2OefCbgF8YmEWKT72m5itFhAAUcVdT7d/zVFXsepI+f5MdvQ==
X-Gm-Gg: AYBFou3D/tqugEOb75c/F3nYG33nT57+f7nhzbe4XN7xxpxrgA41Ex+4Hvdi39dzN+6
	YjK7xpXHDRbFkfxATWw4Q+4h52rnFmla39SCtalSrRTQ3oi4qjBB4oslKC/SLai8NoSmmkSbwd4
	MhUilruIXX6vA/+WpYQDc+jdJCfdmsGVNxXvFoCRrZLKo1EqhFQ7DDy6b8jHSzNoqbPIAoRmKfT
	v1bMzb6X2mvwAgpAchJPYBxoJjhLMpjbxgmDUfCBI+iAafYU1A1WYWkj3cPoyFMRrKSMddbsubG
	vTugbDUoGRNpWa32cBeSt/6/Sa585pa6MAMRzn4TnnAGfRWlScc2quu0nDNcD0Vx0RkvEwuKyra
	lNzGtzfYusazPVI83qw1HTD4Tadyx4qioKthgcJzrvtdn4dr6LZBo5H0fXrxNeeG7mNEYJ51CY4
	YpElIgbKtjjbj5qmNWUa8LQMWlORkrr4KdHbj0JdHqpLsNwvPJ9VbzxO4D/rrprcDka6FTj79Uy
	bWLaRGzn1zLpWVmN4JeJn726JWoA/Wh8x/uP0HV+o9DpxouL/T4CAq+KgeQD6KixyuPfaGJhnN6
	ixQgtjEEvTVGnOBaeplUI3nZqMrlgaEpzO+aLQg=
X-Received: by 2002:a17:902:fc87:b0:2ea:1fa0:8068 with SMTP id d9443c01a7336-2eae7be30b6mr4320395ad.16.1793102252395;
        Tue, 27 Oct 2026 04:57:32 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae4064f4bdsm3633646a91.11.2026.10.27.04.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 04:57:31 -0700 (PDT)
Date: Tue, 27 Oct 2026 11:57:25 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-nfs@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Logan Gunthorpe <logang@deltatee.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-pci@vger.kernel.org,
	linux-rdma@vger.kernel.org, Shivaji Kant <shivajikant@google.com>,
	Tom Talpey <tom@talpey.com>,
	Unnati Sachan <unnatisachan@google.com>
Subject: Re: [RFC PATCH v1 4/8] xprtrdma: return -EREMOTEIO on P2PDMA map
 failure
Message-ID: <auCRpd73dok7Yys7@google.com>
References: <20261006233248.705086-1-praan@google.com>
 <20261006233248.705086-5-praan@google.com>
 <20261012070134.GG27033@unreal>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012070134.GG27033@unreal>

On Mon, Oct 12, 2026 at 10:01:34AM +0300, Leon Romanovsky wrote:
> On Tue, Oct 06, 2026 at 11:32:44PM +0000, Pranjal Shrivastava wrote:
> > ib_dma_map_sg() returns 0 on any failure, so frwr_map() cannot tell
> > why a mapping failed and reports -EIO. Use ib_dma_map_sgtable_attrs()
> > instead, which returns the reason. Pass up -EREMOTEIO, which means
> > the device cannot reach the P2PDMA memory, so the RPC fails with the
> > same error as other P2PDMA refusals. Every other mapping failure
> > still returns -EIO.
> > 
> > Signed-off-by: Pranjal Shrivastava <praan@google.com>
> > ---
> >  net/sunrpc/xprtrdma/frwr_ops.c | 15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> > 
> > diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
> > index e83cef19e656..a55d5e11c0e2 100644
> > --- a/net/sunrpc/xprtrdma/frwr_ops.c
> > +++ b/net/sunrpc/xprtrdma/frwr_ops.c
> > @@ -293,7 +293,8 @@ int frwr_map(struct rpcrdma_xprt *r_xprt,
> >  	bool sg_gaps = ep->re_mrtype == IB_MR_TYPE_SG_GAPS;
> >  	unsigned int max_depth = ep->re_max_fr_depth;
> >  	struct ib_reg_wr *reg_wr;
> > -	int i, n, dma_nents;
> > +	struct sg_table sgt;
> > +	int i, n, dma_nents, ret;
> >  	struct ib_mr *ibmr;
> >  	u8 key;
> >  
> > @@ -381,10 +382,13 @@ int frwr_map(struct rpcrdma_xprt *r_xprt,
> >  	mr->mr_dir = rpcrdma_data_dir(writing);
> >  	mr->mr_nents = i;
> >  
> > -	dma_nents = ib_dma_map_sg(ep->re_id->device, mr->mr_sg, mr->mr_nents,
> > -				  mr->mr_dir);
> > -	if (!dma_nents)
> > +	/* Unlike ib_dma_map_sg(), this reports why a mapping failed */
> > +	sgt.sgl = mr->mr_sg;
> > +	sgt.orig_nents = mr->mr_nents;
> > +	ret = ib_dma_map_sgtable_attrs(ep->re_id->device, &sgt, mr->mr_dir, 0);
> 
> Please avoid using this function. We are gradually moving away from SG tables
> in the RDMA code.
> 
> In general, it is never good thing to built API around try-and-fail
> approach. It will require from us to be aware of "specific" usage for
> the return value from one subsystem by another.
> 

Fair, I'll drop ib_dma_map_sgtable_attrs(), keep ib_dma_map_sg() as it 
is today, and check reachability explicitly before mapping instead.

rpcrdma_p2pdma_allowed() already asks ib_dma_pci_p2p_dma_supported()
whether the device can do P2PDMA at all. It would also run
pci_p2pdma_state() against the device's dma_device for the payload
pages, and refuse the RPC with -EREMOTEIO on
PCI_P2PDMA_MAP_NOT_SUPPORTED. A mapping failure then stays a plain
-EIO, and nothing depends on the DMA layer's return value.

xprtrdma can be built as a module, though, and pci_p2pdma_state() is
an inline wrapper around __pci_p2pdma_update_state(), which isn't
exported. I see two ways to handle that: export
__pci_p2pdma_update_state() as is, or add a small exported helper in
p2pdma.c that returns the map type for a page and a device, e.g.
pci_p2pdma_page_map_type(). Which would you prefer?

Thanks,
Praan
