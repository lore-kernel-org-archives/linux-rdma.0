Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0113CCA13
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 21:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791579845; cv=none; b=dnnci25jQjkn1k4DrUMrT2cbajl/U+9j6r+UMsgZXBUg68rqqe5f3u+tRJqLiGSfGpy9rI/KPdEa5t2WXGvgW0Dbo2MXnqRl34mMXJGBrMLpTIelgqZFUOyL6NUHr+NA4uKfdf2MtJwXkRJQ+Z6X+NfjRtSXO6N/sAzO3TfOQ/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791579845; c=relaxed/simple;
	bh=d3/vd1cXEaen8VzVLbtTj0/2U/5HGW80EZrAPyBvckQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=X2LBMRAUjdV2aSWqlSOeY0HXXPjo0taHEhqan6J2jLr84Am0nZoY9EsbhogHHj+/HiDit8pJxSWyYWSCZSSEPsdHNhf4XDtT6oNdCWbn6LtrFYPEFW3TxP+bnG3m3hAANh6LpExMyAi7d4GgKJ6j4X5jZtqtVBIOKiYFN9m/J4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ydlc3KCl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ydlc3KCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D581F000FF;
	Fri,  9 Oct 2026 21:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791579844;
	bh=nNfHVcHc5n6vc5zxJ+6omi3qh0ntDFtBFywZxYpSVkU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ydlc3KClHFXLSa+r3/BB0h1ng6/wm8OP1Jq4Vx6kY98nobTZ1HHRzC7Qx253oD4dR
	 yv4+TvlhKG/UPnEBN2dNjWccDwaycpqabyC9dSbGg+ib6kmxe3G1lpq9mHbWhp0oa1
	 knm7FnGJfIl+xHADeQJvlHRBg1JKkXPWA7jyFu025iQwW0EHYDkj1afLuGgP2qPexJ
	 Fdil6amZn6ur76ltuk31Jic0QnJ4RBN1I3kdup9IjQ168WGFyVkixZrcGeR/86etdU
	 xf4JAzGvLSVvYyZlYf5O0hiAfFTL64AA0lIDEFxNheUJYCb8bVMbVAvqjD7s5erCXo
	 nFMudEoA+BCPg==
Message-ID: <sashiko-outbox-166076@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 09/10] qlcnic: use pskb_may_pull() to pull
 excess TX frags into the head
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-rdma@vger.kernel.org, intel-wired-lan@lists.osuosl.org
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-9-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
 <20261008-b4-pskb-pull-tail-drivers-v2-9-8f2bd9bee138@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 21:04:03 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> qlcnic_xmit_frame() pulls the frags that don't fit in a TX descriptor
> into the head with __pskb_pull_tail().  It already checks the result.
> Switch to pskb_may_pull(), which takes the length the head should end up
> with and checks it against the skb, so this driver no longer calls
> __pskb_pull_tail() directly.
>=20
> __pskb_pull_tail() also releases empty frags, even when there's nothing
> to pull, so if the frags being pulled are all empty it still gets the
> frag count under the limit.  pskb_may_pull() returns early in that case,
> so follow it with skb_drop_empty_frags().
>=20
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008-b4-pskb-pu=
ll-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com?part=3D9

