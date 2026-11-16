Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794828557;
	b=Lg7JTJ899yzCTMNNUspX+GDvT96SY7kaFNJSLTf7/n9XEVSDhPbetsOzYWnF/2IH93Wh
	 R0ju6cQ31PyMP55dm1fbA4jjoUmz/k8Y3NxszNEsjxuL8t2DkM/XfTCsYJA2Do8HxZzdo
	 /TtT1iRAlbVdYWuRihV9e1Fz72hs4b2/wmxnOlLL0CZo2ikETyJVpb04hze9VCA7sfldE
	 CdWZyRfMOMw4tqAML+tYcKitPNY2BOpKlT9tXad5NAt5Vu6+/T8q2Y4MJ2mYw3wWQr4eo
	 0LrO03YVAEkTOYCyG30MFhoF/937e2D7ebXtWJjUMCQHtKZzPRneLe6XLyelqtudmcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794828557;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=CPrNGh3HPvcoWKq+BJHlqOI3IhwVyoSnFuAXHxF/5tA=;
	b=gS/ZckRwKLJJvpXTUkPBh/HoBlwoU3TKf/9pSDqfcmIXuGZQg8Tzx1t8ZXKF4oM0TntE
	 jXA+EaLepqocIQN8RTP/bHQGeeoAoGcFheQEmyrb4EuiRzzKdnIgzxNjFqbS82MW77oZC
	 nBnW2oXyZGKo+MhUkjtpDwYlEweLub0UvUvRs/5OnS7/lMnFnqnyidHxKio4WHQY4PVBa
	 sMu0hQlQZQSUJgH5Y0O6HnH2fhbJq0UGR4QnXmqIzk9owVi/vkbK3HJArVrEPRqm3oXc7
	 qxcmqtS9zCwndST12bEGi71OtmZnmjcgLW3oGLqoHQQyraIkAzzt+O2EjxoVoCBe4cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="B/EHUMOw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5788606A337
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 11:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B/EHUMOw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86121F000C4;
	Mon, 16 Nov 2026 11:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794828556;
	bh=CPrNGh3HPvcoWKq+BJHlqOI3IhwVyoSnFuAXHxF/5tA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B/EHUMOw8XZ2AGUVIZ8HvtCwUw3zcj+ZQ1n/VJ7Mx9DlDO4FX22HttFrsYLHyVW7j
	 83xUBxNbJejhzhzNg5Ca96ck7FXH38Dv2IjBEu9llHHKoSw5FxqPB4nOpvKdhlXBdd
	 V1kotL3/5QKyWx3Rz9XaH11f9ORZE9wjaOoQrIrKl3OupADDdbwRPEz3qxhSFuX/cH
	 PpkbKYXmnVHRD/4c2qrru00ydOZZziWn1UBlNhMDWM3CuuWzgR5ImkZPYIdm53rLdv
	 ZuZbHC8wfk5Ly4b42aPS7GFAMJMMn2wDOiPXBjQ9bqs4aa82b+dCkTuEh/1Kj2T8YR
	 8WbkYVYF+cp4Q==
Date: Mon, 16 Nov 2026 13:29:13 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Ilia Kolominsky <ikolomin@amazon.com>
Cc: jgg@nvidia.com, linux-rdma@vger.kernel.org, sleybo@amazon.com,
	matua@amazon.com, gal.pressman@linux.dev
Subject: Re: [PATCH for-next 0/3] RDMA/efa: Add Completion Actions support
Message-ID: <20261116112913.GI11319@unreal>
References: <20261109081349.27316-1-ikolomin@amazon.com>
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
In-Reply-To: <20261109081349.27316-1-ikolomin@amazon.com>

On Mon, Nov 09, 2026 at 08:13:46AM +0000, Ilia Kolominsky wrote:
> EFA Completion actions let an application observe work request
> completions without polling a completion queue: when a work request
> completes, locally or at the remote side, the device performs an action
> that the work request names, such as writing a value to a user buffer.

Why are these verbs EFA-specific? This looks like extension of already
generic UVERBS_METHOD_COMP_CNTR_* code and probably should be general too.

Thanks

