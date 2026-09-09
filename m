Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61983546E2;
	Wed,  9 Sep 2026 03:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924590; cv=none; b=HFYV2hxo5fpS9dN7h+xHauoV4tDyf6gAmnom9+1jrr2JYuNxZG5RNfEXQv8/R88BoPf4bqAuQE9SZR6k7ltx7HvBebZiDFAeIe8EHNCMrTpXFs1WVoj6k6Ruvl59wVy50L5oOP7O3s3LmRoObC4nDOge8NP5vx419wxcbXHaufM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924590; c=relaxed/simple;
	bh=ActFmUd/cU8YKE9f/nmCoAGWZuyrbWKmT/jYvO9MUO4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=vDYMV0NUlBrrnZvZekuapK/xFUd3Te++1tZbAPCsecQ8SVne6H1zef/63Tzn8jUyWF+3KIons/O7bEaChJj9y94RkAZkB2VLhnHBg/XoRS28XQ29uak0//8Ruu4v0ndWOuvyjXbIFkFX0n6HTGmdk0yfWvubyFmKXq3xT2jcMX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhKIqv3l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhKIqv3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A998B1F00A3E;
	Wed,  9 Sep 2026 03:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788924588;
	bh=ActFmUd/cU8YKE9f/nmCoAGWZuyrbWKmT/jYvO9MUO4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VhKIqv3lrjgF3NiuXSZY+Lliek0RLVvaXhQnCMdVsEy3ypY1xstCt7OczD7RtHaHG
	 WiSCg7Mg1H2XkWwHODN+XrGCysdxKLoHlM7HnKCJPgXi61tFfUC6FiJqsh8sadZnr7
	 YqkWb4H5p6t7WJpBTfDEoXCYC4BETUoH6v0xkdo+eCQreVEhOrQ2v0O4h0Q31evwlm
	 krMTCINNOcTDPo0tJs0Fves0ODPfIR4o9KCPCGHM+LuIBH2QOviVdWrXq0BLibUs1p
	 AZTwE9JFW9niHFmJGCXdQf5cNQkH9gqPl2UxPt3pz0bnDwRwc7+INdI/UmUCL5rMjX
	 tV4jow0VTIK5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 10/13] net: mana: release EQs left idle by a
 channel-count reduction
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260908032843.397667-11-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-11-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:29:48 +0000
Message-Id: <20260909032948.A998B1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Release EQs above the live queue count after retiring queues are freed
> or replacement allocation fails. All CQs using those EQs must be gone.
> Return their vector allocations to the pool; IRQ registrations remain.
>=20
> Store each EQ's debugfs dentry in apc->eqs[] rather than a stack copy so
> shrinking can remove individual EQ directories.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908032843.3976=
67-1-longli@microsoft.com?part=3D10

