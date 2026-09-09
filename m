Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086C2349B0D;
	Wed,  9 Sep 2026 03:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788924586; cv=none; b=m7UE5VBZhIDwzlzQCzRCocCI6sczkQTu1Py1b3T8+4GytdRAm5vEG334XhTLIKLrql2xmy46IZqZAfeobW0PgFzS3qFp6JbR7SWn58lVj0W9fa2QnC9/bZ45UL6edRJICpqfxO5aEMfriiNrL1XPaonKs7TjQyKmclq7kGWTQls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788924586; c=relaxed/simple;
	bh=o0VaF1gfFrqpxPUdJpxjcxVW16etytMfFPpRxTGVU1g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YCj+Vj0WUOb5gvHtlsnLDZ5TApyvZlfdjjEjsxyb/Iv5ke7JMzS+dax3psrSym3kUXNlIh+T51vR0XSkfgFisBcg4NbxlMsY8dM+0wKF3Q5fDZuOcmXrQEyHUKNkIuKJYESmR83/ygbanrGvjP9LbGx3bU4HOUsXqHLr/o+SbOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fMU62b0Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fMU62b0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5DE1F00A3E;
	Wed,  9 Sep 2026 03:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788924584;
	bh=o0VaF1gfFrqpxPUdJpxjcxVW16etytMfFPpRxTGVU1g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fMU62b0QwmGiiikaNBbU0mwBYdiMOJ2O6RZuUQ2AgTDDTEs167R0mDYIuHK/6DVr+
	 sckWxKPzZZ+61B6apMSeSEyyS8kUzNdgbDehLrIUPIW2puakbPxUC4EFnSCN5l3daU
	 CGERK0+iFgSN3pX5D3WCMTNs+aVQvUIhVbN7knJf2xn2if8/seEXlGkpeC9CaKm/K+
	 gcGon4u+mxCAK1YkWCmItyVQCi4tBux2xTxVsJCRIiK7ai//tJ97Y5zfiWp+XjbIWz
	 4sbxPG4tc4YgCQTjh9W2grCkJKX+49n2+JlKgHKYgDPdid6tLeUw2aepH1veowQCTm
	 ZflJjkc+p8w5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v4 02/13] net: mana: share the EQ pool across a
 queue-set swap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260908032843.397667-3-longli@microsoft.com>
References: <20260908032843.397667-1-longli@microsoft.com>
 <20260908032843.397667-3-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 03:29:43 +0000
Message-Id: <20260909032944.6F5DE1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Make the EQ pool port-owned so overlapping queue sets share EQs instead
> of requiring old + new vector allocations. Allocate max_queues slots and
> track populated entries with num_eqs.
>=20
> Grow the pool before creating replacement CQs. Additional EQs survive
> allocation failure in this patch and are released at port teardown.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908032843.3976=
67-1-longli@microsoft.com?part=3D2

