Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9523D4EFFD7
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 18:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483418; cv=none; b=aXCSTiLM+F4FZXF8bNflnLXWrPPUh+CLgAjG8C71L3DJpLGXWIDk1H3CY9tArlkASfgl7fDulkCehrsuCozTxZQxaN04LGUkKwKW5pPQmoA1vzrS3NKrgWcLDLpTeAUIz/nms5jYUSSdHeIjRNXQn7DMA7yxB1feEuZqyrNNpXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483418; c=relaxed/simple;
	bh=X6pzwYwmiwofcz1zQ/Rr6W8b7kmb/dKaTDjvtySsjEI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Krzjyk5SoeXEpLZL733CUNmHrzp8i8AzbJDv9YaxYPhX4gphmRw4ZhBKpZnN+HiCZulcbkZj7gE5KmrHKqTjOtbNr3/bfnIVoPS3mb05mmrmwLa8LEiIX2QznaCFNJ5vRIC6iPk3aDo+I4MsuUlXriPq/QxRkbFDqMbPh2EDVKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJ6K0dFj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJ6K0dFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC901F00898;
	Thu,  8 Oct 2026 18:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791483417;
	bh=hQP0DDccae/wkhGSwQNqWKTmasq14MDjibKhebkKkUM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dJ6K0dFjn3WaxojiBy+8EDjhE5VXFNNDC/+B8NL3oiHQfsTGgT6ZQ9oiZjWTLQDKm
	 N2a5Sfu4Js6WB4qtlgmlb7DNNFmjHCSFwvEP/SnDQ6LDNzBeU4z7fKHyUzL066/4IZ
	 X4a4X5IiB5tCSj0zotRkl+byaR7sG4OtE3WBo0wv0M4rM4pKrqtLLjz/mBmJqr0zZK
	 3kX2tn7ANaBxIiIjhTUVOJg6aEVlrOuKldxMuMuxnAc3Y4+yespKLkNS2vQTQGiW8P
	 Go/mTBMpdzLkzmERQCct8o5tL3g+vbtL5LjBM6ZC9nA/ab8Vvd2WeaVL519Q1/A+kL
	 kLfRkMUSOzRXg==
Message-ID: <sashiko-outbox-164444@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 6/9] e1000e: use pskb_may_pull() in the
 82571/2/3 TSO workaround
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: linux-rdma@vger.kernel.org, intel-wired-lan@lists.osuosl.org
In-Reply-To: <20261007-b4-pskb-pull-tail-drivers-v1-6-9512b0fb977b@toxicpanda.com>
References: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
 <20261007-b4-pskb-pull-tail-drivers-v1-6-9512b0fb977b@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 18:16:56 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> e1000_xmit_frame() uses __pskb_pull_tail() to pull up to 4 bytes of
> payload into the head when the head holds only the TSO headers.  It
> already checks the result.  Switch to pskb_may_pull(), which takes the
> length the head should end up with and checks it against the skb, so
> this driver no longer calls __pskb_pull_tail() directly.
>=20
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-b4-pskb-pu=
ll-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com?part=3D6

