Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D743BF660
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 21:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791579841; cv=none; b=q8iZ3JkDuw+ZkupRuBzmcMRcyYq+U6jOHqoQCdr7ex53n3P3N+TaUPqu1243LqVGG7NA/aQsTmxp3pTGdDzbw9vtbhjqpcldQEsQbSi21d5JnDJEcZExkvKUTCpDNGkMAPk7WrP1EpLMKlzpSdk2rT2YHv3+tJTRI8w7XDOyrAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791579841; c=relaxed/simple;
	bh=Xz/vpqyoyb8dTmtmAcleMUzk81w6XNo+BVxFqHQDJCA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=XivLNd8XkekgJzuy8kuLM/r2vM1+0CdA2TPOHQJIndhuKlSv7YyzcZs0CPc2Sf+wat+NLrZVbSCh2kxBVaQ73Fpv3zBLjG9394eAqeKoLsf1CLavtf3/1oKd0TC48beTS+XD5ul4ar4UwBrFc9zWzjRzPQUfc6K2i2DCS1feabc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gym6jvsW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gym6jvsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF02A1F000FF;
	Fri,  9 Oct 2026 21:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791579840;
	bh=Tcv8NXtIokDyWQizCm2H02vtvGGJ+ADovDn6UZtLp6o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gym6jvsWiZNIXkn3xpHP5WuG1UWKJ6TrIrIMcaElSyZPUN4fcRGUBcO0Ff646F6sf
	 MLx2vwwyr59YUjTPdmMMl7aCYib2y/YdkBBtnjlafzstRqPSGP60LEmZn/RKxO6WoA
	 VoD+GguU4B1627KOL6dkwl3btvXD4mJd6pgDMWdJPhdEK9/PDyVLVFi1TAtef8kyam
	 NmervWCYeOv7xpvS17EnC4DIZBvF2sZevBQ4v5GeH6hJuTJulee3AXr7mBmnB9iMAh
	 LnAonNCR1/qQk62HMZU7Fkpdn1ulnbPp1s8vRzWbfr2s3apRVy/0v4kgZAF8Dgiib8
	 TF/6h8IJGgQKg==
Message-ID: <sashiko-outbox-166072@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 01/10] net: skbuff: add
 skb_drop_empty_frags()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-1-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008-b4-pskb-pull-tail-drivers-v2-1-8f2bd9bee138@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 21:03:59 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> __pskb_pull_tail() releases every zero-length page frag as it walks the
> frags array, even when it's asked to pull nothing.  Some drivers depend
> on that.  xen-netfront calls it with a zero count on purpose to make
> room when a backend fills the frags with empty slots, see commit
> d81c5054a5d1 ("xen/netfront: tolerate frags with no data").  netxen and
> qlcnic get the same effect when the frags they pull to fit a TX
> descriptor happen to be empty.
>=20
> pskb_may_pull() returns before getting there when the head already
> holds the requested length, so these drivers can't simply switch to
> it.  Add skb_drop_empty_frags() to do just that part, unsharing the skb
> first if it's cloned like __pskb_pull_tail() does.
>=20
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-b4-pskb-pu=
ll-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com?part=3D1

