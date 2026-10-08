Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A8B4F052D
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 18:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483421; cv=none; b=P4+p7G6Xmaej/xjThGNLsXjWHW1fbeNYR4FIhZKO95pHJolf2XBC8bzejGx1xNahOfN++SEo7aD2Sky0Ad+y/dqlM1c2k0m1R3hULLYVHnjwZxfZbTcjg4O4icfM96k5GhGYj0pTlBFNZqa0pkxlxi3OB6qmeTneiNaK1W9y0dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483421; c=relaxed/simple;
	bh=LigVw9EauyLoU2q4aeJdOY296DcpcybDM6SCjont/mU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=cGYOjAyfdsHIq3GDeBF+gfSm5B+Yb+EJPE6G3Ow2i9ghEv5YDCZOLYs/hoF8yfR5bAonq4hqViHQMbioTH63m1ja9ndfvgX6E6lpllnCTQ1m4a6WXEL3c7atEw9wS2o5CfV2Em45O1LFm/i/t4eco7glDzmkM+0ZHWzrpR6nd7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=clasa4H8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="clasa4H8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A031F00893;
	Thu,  8 Oct 2026 18:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791483420;
	bh=H9LOvnDoD+35fywn4kLsddt8yt5WqBAHe8H9SFqVS/s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=clasa4H8PrfW7RX1l95x66aQYoRHG98wx9pcuFLwIKnqhoK6nglhuVu4Ty6haAZtH
	 1y61Hlb9o4KSJ05924i5qeMbpmn8w5XaJCTB4Re/xYy2ZwNm7fAxGPOfO83Lw9L2lI
	 lVLiaqDpoOU7xvwGUIXLCXrU2xSxHKAZjVVHoS28MO9qglE1FZQJDm7hKkuT0cm05q
	 KeH5kb1HFejkxA/kNuaFEgs/98a9fEKzBNrxdjbzjaCe8lp21ZvKjoqYGlDVRT3y6M
	 ZLlmyfs14V8peu71luTsoDpm0Kojs8gtJWIqkreqtwtqMyY9pgKmXPxvXiOf08ynFb
	 REQ2Cb2WXQazg==
Message-ID: <sashiko-outbox-164449@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 9/9] net: skbuff: don't reset truesize in
 skb_condense() if the pull fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261007-b4-pskb-pull-tail-drivers-v1-9-9512b0fb977b@toxicpanda.com>
References: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
 <20261007-b4-pskb-pull-tail-drivers-v1-9-9512b0fb977b@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 18:17:00 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> skb_condense() pulls all of the frag data into the head and then sets
> truesize to cover just the head, but it ignores the return value of
> __pskb_pull_tail().  If the pull failed, the frags would still be
> attached and truesize would undercount them.
>=20
> It can't fail today.  The caller has checked that the head has room,
> that the skb isn't cloned and that the frags are readable, and pulling
> all of data_len eats every frag_list skb whole, so nothing is
> allocated.  Check the result anyway and leave the skb alone on
> failure, so this stays correct if any of that changes.  Use
> __skb_linearize(), which is what this pull is.
>=20
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-b4-pskb-pu=
ll-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com?part=3D9

