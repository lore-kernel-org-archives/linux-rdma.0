Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793746793;
	b=WpYbLFRb7WxhJeFS7G6FfrZ46Raj3W4E1baHEXk/G+a2KrqzfGuxBoFfTI8kSgogL42F
	 Hkg6GZ39K8E2i1OK6EwlK3Scxjh9eF9/s0CTkfk9egBM+0yUbWjN5rbzNZiGYpPY8MqvF
	 XskD3GkAEd36NFBgG+26WRV1D8H8sDULc9rAZdXTTgVsGtrNTb6zrwV3uIDRpu8v/twP0
	 Zkqw7GDffXe6+GanYkkQYHL2QfPDk/xAUX1JI/cX9bto0af0eaiUUW/aaCfugMHqSVLfl
	 EqhpizFXVrXuNGCgAJ4ZwCu7QpY7cjAEAJPMRCjxLwkmotAqrz4QNTCRtJkkYdLN5fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793746793;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QH8zNecaQushfb5dXt2RD5qJ9QUR8QK0GEd28Jc8hdk=;
	b=pLBnkW2D/B0FLusFVdzWX0xK/OgHkAk6isXJlLw3qz5ZCI4REdITVmGJFVgd7rCYoNoH
	 cEE5olbP75ENUb4w4QCvCFJvQsWsSOEDoTGj55BNd6YvJDxhuRz4O+8yvxBdHFIbMnYFH
	 d6Cq+qgDtrWU1Aw8WKXMe1pCRRe5cYThELpWWR58j3GTwzYKqRxNlsZMS/kWgKoblEJP0
	 A3w2aAW4dIAcLiGOXSeHYVGMsZaR5erk5I+UwvXAcGikQlR4wFoBP76LZ0jZ+YgtBpWVA
	 WVNghhWscz61wJ3noVmIPofQIp6e0Rt9gKoxC8UGFimzynRJgmP4LYbuIKGLVA20FqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bg0AR1VL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D277A606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bg0AR1VL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E971F000C1;
	Tue,  3 Nov 2026 22:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793746792;
	bh=QH8zNecaQushfb5dXt2RD5qJ9QUR8QK0GEd28Jc8hdk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bg0AR1VL8L2DFVzzpNya4Tkt3L/GEoFZe94eK6ZJV1x966131kwvmL2umQBWxeQO/
	 4aSpm7qCeNlo/X6L7IT3T7a2VK29l16i4eV7MGkAjf3XCdDSdr8KIVTlCNYVcGVdkc
	 tDCzuEO6NY91Q5iNxypxVslDHgDKWnnc8adIg3Y5Vcim16hdzqcfs17PJqUzX6mFnw
	 5Ve9iAp9SKLA6vshJc+m94o65GjTE8WfkIYK4XbZSh8/G0hCF8J92k/SAgki9Z/L7R
	 0g9TiFQn/VwEo1sY+6kDBLPxYSAdm+2tdkmdhd+/mJzYo2zK4ik//0YvKta4P+0gkG
	 iVKbKGGE770tQ==
Message-ID: <sashiko-outbox-196167@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 1/6] IB/isert: do not publish connections being
 released on a second list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103223802.1697607-2-yhlee@isslab.korea.ac.kr>
References: <20261103223802.1697607-1-yhlee@isslab.korea.ac.kr>
 <20261103223802.1697607-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 22:59:51 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> isert_connect_error() and isert_disconnected_handler() take a connection
> off isert_np->accepted or isert_np->pending and release it, but they do n=
ot
> check whether the other one got there first, and the connection also stays
> reachable from the list that isert_free_np() walks.  Two callers can
> therefore release the same connection, and isert_free_np() can release one
> a CM handler has already freed.
>=20
> Make the list the single owner token.  A caller that empties
> isert_conn->node under isert_np->mutex owns the drain and the release; one
> that finds it already empty stands back and returns zero, so cma keeps the
> id and the owner destroys it.  isert_connect_error() drains before it tak=
es
> the connection, which is the order mainline already uses, so no drain can
> run on a QP whose id another handler is tearing down.
>=20
> A test-only delay in isert_free_np(), right after it has taken a
> [ ... ]
>    ret_from_fork_asm+0x1a/0x30
>=20
> Fixes: 691b0480933f ("IB/isert: Fix dead lock in ib_isert")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103223802.1697=
607-1-yhlee@isslab.korea.ac.kr?part=3D1

