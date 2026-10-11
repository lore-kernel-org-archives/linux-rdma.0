Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC948C8D9
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 01:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791681627; cv=none; b=VkWeIweXM9gAee/z//ev0sSLEfWWiTqrAVkLSIekQcg46nG1Ir+TbMTA97phXq8O/PoM44QT7HwtwV2LANknlLiu7A2sCek93cdx6lpRQafasr9aKrW/hACNGmYLsMQvil01E8gCfH6NlclMTFRcjQxNicB1uqakZNEVcMqL9Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791681627; c=relaxed/simple;
	bh=1QK39Aj3TJrduVvFHX3fvutZEh+OeBiGxsb2s4D8oKU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Q44oJnOJ1luZqQE02NkcCO8jYXH04/Zt4q+vZb1ZaPLP2gdOi2nJ4VhB+GOLbXs7W+D6wP4k6r2JS9+wUAKH8RGbiSk8GZJbAJYVsitEXO7IrzXIX10uh4Oox56KaQaSVzBaxGV3zD6kIFJSOeQBnKbHRvaMkelzgt4b3nhk/m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwo1fGd5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwo1fGd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6E51F000FF;
	Sun, 11 Oct 2026 01:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791681626;
	bh=1QK39Aj3TJrduVvFHX3fvutZEh+OeBiGxsb2s4D8oKU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jwo1fGd5ZArCAyGXsS9FbYJtfXQeIl9UaUF5V66oBsiFAf6Oi/L/FckmZYuVDVvC1
	 cv5kxjhVKsMKluAC20/wpmpZvpHkBy/SOhQAeCo3aAcy1hdty264yTESbCf1tiIPTS
	 egYTJYxqf88meZznoCNlHUsidMhqirQ5Vrnofwu2M/BKSF9DBUhDpDF1xkPYkZ74tl
	 O98m5uKwFC4aWxA6xGgsLr/5Sn6CZTuX7sulYI09/l7IGif7xeSvSaoc/2zyQAwKRm
	 BRDB3Hbbx9eMrZLU2aemOzHZKFnoRo5750EZNrorAJEde5GPclz6WpKhJborQftjtB
	 64n8RhY48QVbQ==
Message-ID: <sashiko-outbox-166956@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 2/5] RDMA/irdma: Register irdma UVERBS ioctl
 namespace
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261011011022.1445352-3-dhu@x6u.co>
References: <20261011011022.1445352-1-dhu@x6u.co>
 <20261011011022.1445352-3-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 01:20:25 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: David Hu <xuehaohu@google.com>
>=20
> An irdma UVERBS module is now created. An irdma
> specific shadow buf is defined for CQ, while QP and
> SRQ reuses core's uapi definitions. This works since
> core builds shared core ioctl parsing tree first,
> before adding driver specific `uapi_definition`.
>=20
> Destroy paths are automatically handled by core
> dispatchers, as objects are now registered in the
> parsing tree and no additional driver specifics are
> needed in destroy ioctls. Resize, Query, and Modify
> continue to go through write() cmds.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011011022.1445=
352-1-dhu@x6u.co?part=3D2

