Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A86EED8
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 10:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789984885; cv=none; b=n76Gc5SQ3rCtWb6mn0MjVe5nAhL7x7h38xxkgErMXyNtOvlqsQK//BVpTvQaJNlcsXRQwc8mEjkDmayJfCTuqZccyJY2SROn4Rxc/5hJ/RrOBPQwADBt7UKITlbK7ZxN8+QtpnO7ibQl9z9Ww/hsB7FSRqrdJ6ff7GFEtqOlNuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789984885; c=relaxed/simple;
	bh=V8t/vuw3cEoesg0TzhkfkCe95a8q7V8HillkDw+ICv4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jHCobtuDN7mkMYa2SWBmqvzGyZvWGoTub9yhPxhwM0nwlgs7JNUaZkkOAN8QzNnXv8vmInlx88sw9+yj4bhSy0Lhree6J6rtUVCTlnVlYYRaw6GlRuV74t/+fMI5/ePCnSaYvPKuSNAh/lJGUNQ9u6Rf52I+INx1GKK146+e+cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LOea2aR5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOea2aR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97441F000FF;
	Mon, 21 Sep 2026 10:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789984883;
	bh=V8t/vuw3cEoesg0TzhkfkCe95a8q7V8HillkDw+ICv4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LOea2aR5PyT91wjzxE0fRuTVbWVzIVp98zp7vE4fJUyvWEQmeNmAQRu2WJ5CJgOSD
	 udHZAl7qhtm6u2v1eN7QnI3T9g4f+/JpYYypP+vbEe4KZZAwqzgccm5SgXxej9kaAV
	 iGsPO1U3GjuuPKyjSXYlYRUNfI9u8lnlYW7FyKYYpiaI3+58eW4j0KCS4j9V4bi4dK
	 hlQa/xEa9cE0L1SzB144S7/s4z4IJ0A9/Nuz3kIjZvkwvYj86cV+5Kc9O33TRjllff
	 KqCYKM/IlYqYAq7SxR/H6sCR+krnNe5yRoSy/ffXfvHmDNGe4LzcZ2/6EKkoWOENCx
	 5ESrujqTYeJZA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 3/5] RDMA/mana_ib: Revise UD receive
 posting with GDMA_WR_IB_SGL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260921095352.3524691-4-kotaranov@linux.microsoft.com>
References: <20260921095352.3524691-1-kotaranov@linux.microsoft.com>
 <20260921095352.3524691-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 10:01:23 +0000
Message-Id: <20260921100123.B97441F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Pass receive verbs SGEs directly to GDMA instead of copying them into
> a small stack array. Accept the receive SGE limit, supply a dummy SGE
> for zero-length requests, and ring once after each successful batch.
>=20
> Introduce GDMA_WR_IB_SGL, its request union, and the wrap-aware verbs
> SGE writer together with their first consumer. These shared GDMA pieces
> must precede the later extended-WQE patch so this receive path does not
> depend on definitions or encoding support introduced after it.
>=20
> Address verbs SGEs by ring offset so both scattered-page boundaries and
> ring wrap preserve the local kernel baseline's non-contiguous buffers.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921095352.3524=
691-1-kotaranov@linux.microsoft.com?part=3D3

