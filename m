Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794221977;
	b=BBkwakf/t0wmeNSyNEf4MTPsW/wCPq/jH+gC0FeabN+bX71tdh9sqNRj9bItRh68x+il
	 lOaCHVLSvQO5tIqyzCRDKIClP0IAp+XWpLrRZCx8gn/V4ricnWwFk6dlF4YnDKQgRKNUT
	 JTKScWC2EHjSmEi2IT4nDy1E5dJqSi7bBiCeJThhXybnJdhud7QVX9rrgZP6tpfJ+Bb9e
	 qsrHzYQufLyzvRNhuey6+P+sExR7fmMWGchkc/MBuQkpb0md91SORNdTg9dOG0SiVudFI
	 fvtfNwlPnQbeT2aTs2LRofnzE393QjKLUvpwN7uOF3efkbD/a70JDr+Jk0TRkMw2x6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794221977;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Debian-User;
	bh=osm7kcunpwMDUpa0AtafPLPtEfGBifAjr7mLSbmoxSs=;
	b=eVkzbs0AQ20LkxESzkizoBIqB5xb7zG+6LnyAQcNmnhWrauUvp+CsZL92b1jSQroIhCY
	 e6Omj0aBCyLw/reSt4XZ5IWNU7S112V3nXXMr5oq1vfM7DuiGe28hHzma4/hmbdiW01rf
	 3G70Bt39ZC4QhKDF4pSbjyBUBHESOpGZHcqldNWo1PWS6hm8vTdQ4nibGSsVT97ZRxrY2
	 M1X8LhtUxEshWY8vUEXlKr55FO78g28sBwMC2LXtLv20xS2hduaD1EVz8lV/yUnvaicUt
	 McYq9oO2K8nDX3iqU4qSdvGR2JbrC5eJzJfT4wZ08gw1ijJhiQOJMZ378M1YIFblU3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=PmBSvkJR;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50D9606A31C;
	Mon,  9 Nov 2026 10:59:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B50D9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=PmBSvkJR
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=osm7kcunpwMDUpa0AtafPLPtEfGBifAjr7mLSbmoxSs=; b=PmBSvkJRE+E4aDV0EmKy+JqADs
	Sa6/sVJSWWB5gAqwLZ+OohAFfpIy/spemjq5iYrHuBQWdFoNDRNLSiCk9l7cRaapYt5mZFq5ZXQ+H
	81DKStnUBSMjLnUoLpTIFwr5WXFIooYVdx02LgI+ZRla4GMMsAkb8aI9IJknzC7BYWSQzyWqWWQBz
	OxD5NGDpQPj1UIWluYnugbg4XCMzKnIOMwfDITbxUVRH7R9D8MptE97MM3pP5rMk96JjgntoCNdeX
	nn3Qqdz8vCJ7PzN88KXwy4Nnu5RG2hmFZiw49ezDPL0L/kN7sz7Hi5+B+0Jt3SmMftsUseLKFvAVl
	pt3W/rMQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xQN5w-00BZ7X-2e;
	Mon, 09 Nov 2026 10:59:25 +0000
Date: Mon, 9 Nov 2026 02:59:16 -0800
From: Breno Leitao <leitao@debian.org>
To: Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com, andrew+netdev@lunn.ch, edumazet@kernel.org, 
	horms@kernel.org, corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	michael.chan@broadcom.com, pavan.chebbi@broadcom.com, saeedm@nvidia.com, tariqt@nvidia.com, 
	mbloch@nvidia.com, alexanderduyck@fb.com, kernel-team@meta.com, sdf@fomichev.me, 
	dimitri.daskalakis1@gmail.com, almasrymina@google.com, dtatulea@nvidia.com, 
	bobbyeshleman@meta.com, asml.silence@gmail.com, daniel@iogearbox.net, 
	razor@blackwall.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, leon@kernel.org
Subject: Re: [PATCH net-next v3 2/9] net: devmem: charge the frag length to
 TX skb truesize
Message-ID: <avGneUOQtUAMvpCq@gmail.com>
References: <20261105222058.944293-1-sdf@fomichev.me>
 <20261105222058.944293-3-sdf@fomichev.me>
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
In-Reply-To: <20261105222058.944293-3-sdf@fomichev.me>
X-Debian-User: leitao

On Thu, Nov 05, 2026 at 02:20:51PM -0800, Stanislav Fomichev wrote:
> Devmem TX charges each frag the net_iov size, PAGE_SIZE today:
> zerocopy_fill_skb_from_devmem() adds PAGE_SIZE to skb->truesize per
> frag and __zerocopy_sg_from_iter() charges it to sk_wmem_queued. TCP
> uncharges in bytes as acked data is trimmed from the skb
> (tcp_trim_head()) and uncharges the rest when the skb is freed. A frag
> shorter than a page leaves the difference charged until then, which is
> small with PAGE_SIZE net_iovs.
> 
> TX net_iovs are about to grow up to 2MB, while frags stay bounded by
> the skb and many frags share a net_iov. Charging the net_iov size would
> charge up to 2MB per frag: a 64KB skb with two frags would charge 4MB
> and fill the default 4MB send buffer on its own.
> 
> Charge the frag length instead, which also matches what TCP uncharges.
> 
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
> Reviewed-by: Mina Almasry <almasrymina@google.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>

Reviewed-by: Breno Leitao <leitao@debian.org>
