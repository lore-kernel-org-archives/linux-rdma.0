Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CB2563295
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 18:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792003454; cv=none; b=PdJbYhASyVbGBDgnyL1jIGNWctJyptZljV2Ex43l5WjUarivgaugZFjej4U5/47pf2q0uGOjx+q/mAuKbnJVso23FSjjBv2kPdDlYJXgm8IRLbH/9oFAcwmOMYe3M608rECwK7biUJD4H8nXyebDZjALMN+2kPd43H5HmGY8anA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792003454; c=relaxed/simple;
	bh=H85zYlzuZqfDNSBPvzbI4qTx6rR7wGW/r0DDYQkDStE=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=ivTAT/1L7uy6yonwGWg0B6lr3Q5LmiGcEqiVioC6dcux8eBK4nhXLckxqedr/MwTiz/zl1Wo12WEVEcUvFGfredH/g7bVC30PJhcoE71c4VJHrDmXnkBBPvaFOkm0wFacQboMRLX+XsFkEx31WdjF6BF4W+UQceVH6D9z0Mlmw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BYAnJ9N3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BYAnJ9N3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CB41F000C8;
	Wed, 14 Oct 2026 18:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792003452;
	bh=H85zYlzuZqfDNSBPvzbI4qTx6rR7wGW/r0DDYQkDStE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=BYAnJ9N3ZxKfD5nY5Yn+3PKKAUpobqQFsAOImfsMbWbLepyslk2tW2UVYtLLlWW3R
	 Kbfu3rKdfoITLCYSzTKvgtGdS79Sr/2QBwTKoj9Oj0+wE1NeZzZVRTn3Ezv9SslF5+
	 qB5V6XenRuI46+FnKBW0StwxQAt3Tz5Dz1nI03pvaLZKDDpM/duTXkghnWNmfBB7yQ
	 CjIbx+t5cZoeUimKnRVs2vC4ba1/jDmGKThtcd4FvnT21tBs6jwEBNSd72yF12BRnZ
	 wHo+lO3v/iJ3mUWox1zHA7zPLK9/Mf+KvaHoPiTn7J+4pppn0fZlnYLijwH1DAhhsa
	 pUP5g3kjPPA2Q==
Message-ID: <sashiko-outbox-171728@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 5/6] net: skbuff: use skb_frag_ref() in
 skb_try_coalesce()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261014173945.373295-6-almasrymina@google.com>
References: <20261014173945.373295-1-almasrymina@google.com>
 <20261014173945.373295-6-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 18:44:11 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> skb_pp_frag_ref() was introduced solely to work around skb_frag_ref()
> ignoring skb->pp_recycle and incrementing the non-pp backing refcount.
> Now that skb_frag_ref() handles both pp_recycle=3D1 and pp_recycle=3D0
> symmetrically, call skb_frag_ref() directly in skb_try_coalesce() and
> remove skb_pp_frag_ref().
>=20
> Assisted-by: LLM
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014173945.3732=
95-1-almasrymina@google.com?part=3D5

