Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527237;
	b=yK2hY0qgaymjVsoQ6FIf2CIl+2uhOSjsvA/nNIj/+lAswuIMxYN+YsCrl2olW0vFKVBQ
	 6p+efp2T9U1OAPTD8DUOpIIuaXjtCUdsLS6zPzvTdCqI0SEHnUvYz8GpvilXRnufE5z8J
	 MBEmR704zy6RNnaQDROznur5UcWpyCY+2ZcEIDcgi6YJad7gGzMJQHB0QwTiIWkOUeIsF
	 pk2wLmMvVIQA2Zi3aLRaRUKjwhWH2IdOIUZ3W8nSmjqExehAXCAzTVxZR+LqjUsedJ+ZV
	 Pl1r1IXY2GohNUVVA2iy1dEOEuyKcWGqaL166Is1fFgoy7Bl9EW7fztAWssmdA7yLLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527237;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=PglH4quGh2tzv/MIU/fLjiipFlCFEwtlNMG/LvDeVTs=;
	b=bDX/aYkl1C3whvfuFJGltFmznEgcLrKOCQVGyRMG8XzOzEA8zvg4mS2okrtVRNanhaYB
	 +z3NpltRAya2QYkUPuaocpYvvNImoz4TOw5dNIoRx+HUNqSR3joNgI7xlPCYfEB38mIB8
	 3CkogUDc1pP9FmL8kGiDvRYhiBdLvFGh2n2E7B2kB8hZ6zei5oxYrwjnoxYSyCJex2/ig
	 Y8Uq/pmdNIfRgewb9muWAca/r81Atx8QkHsR5PwrLfeeEYB3iaAIGgHEnBC8ufqgiTGp3
	 n0vZriE4prKIQX01APRAGdXf+JoykFv+dUFyVN8cy4djz+saCnBftre8XKDyhUmEe4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SvEDHmZs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B99D606A33B;
	Tue, 24 Nov 2026 13:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SvEDHmZs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663EC1F000C0;
	Tue, 24 Nov 2026 13:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795527237;
	bh=PglH4quGh2tzv/MIU/fLjiipFlCFEwtlNMG/LvDeVTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SvEDHmZshWBs43UEfSmZl7V4BE7S10opdkSm0BZajLnFSFMG04KoLMlJ+JrFwqkMJ
	 zYrEhKrtsko8X1oasHZnTHi0kqhxEcVfpi0Bh0urta2gGzSWvWZSBjLiEhFHB66N1T
	 VPV1gs3s+aRM4MimrmjVvlMzfoI0cjF11oGjx2zwmhYWjzX60RCm/7QwlkgdZq0OYf
	 vMFgrCrbjIqX8N/vzL29vGBOuJVT49nVE1/xc3mbVN6jug8ARK41ckR1/07KFO3ngt
	 5CSzdv4RN7wVatrpG3BzxqpNrtMf7QDXcATaNmUIESNiwzlbwze9FSsbUyHV9tpC8e
	 bCU0QLDZgxMFQ==
Date: Tue, 24 Nov 2026 15:33:53 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yishai Hadas <yishaih@nvidia.com>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
	mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
	dtatulea@nvidia.com, moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Message-ID: <20261124133353.GT14811@unreal>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-22-yishaih@nvidia.com>
 <20261122073156.GA12665@unreal>
 <761ca80e-a772-41f3-b8e9-cc332e4ba5d9@nvidia.com>
 <20261124125327.GR14811@unreal>
 <20261124125950.GC9566@ziepe.ca>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261124125950.GC9566@ziepe.ca>

On Tue, Nov 24, 2026 at 08:59:50AM -0400, Jason Gunthorpe wrote:
> > > RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
> > > 
> > > In adversarial mode the NIC is not trusted. As the kernel protects its
> > > own code from it, user space has to protect its own area, e.g. the data
> > > path that polls CQEs directly from the HW.
> > > 
> > > Hardened user space might use a different data path, with extra checks,
> > > and support a smaller surface. This isn't needed for a trusted NIC, so user
> > > space must know when a device is in adversarial mode.
> > 
> > This information is part of trust level series. Why is this a “must” in RDMA UAPI? 
> 
> Userspace has to work differently if the kernel driver is in the
> adversarial mode, and the kernel should not permit an old non-supporting
> rdma-core from loading to prevent a security downgrade.

I understand the first part of the sentence above, but the second part is
unclear. Why should this prevent it? In adversarial mode, the kernel simply
isolates that device from the others.

Moreover, the kernel cannot determine whether rdma-core has actually been
adapted. A locally cloned version of rdma-core can set the new adversarial
flag without changing the old, legacy version.

Once that flag is set, the kernel allows the patched rdma-core to proceed.
Therefore, saying that it “should not permit” this makes no sense.

Thanks

> 
> So it has to be in the GET_CONTEXT handshake to do all of this.
> 
> Jason
> 
