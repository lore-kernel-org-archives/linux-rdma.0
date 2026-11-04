Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793756733;
	b=iy/2D5qU1X5503hiBSNxupaFpm0FrZ+otjgca+MPFzJGBJkMcsCf3lUQNYCmmWyk43LY
	 zYBDCqsWUIxnQyt0Ln6ta/4z3AnpWDbajkfDyGF26T28dKkJfgnY48ip8AbiJp5X+e6a0
	 ZGFFdjkJiM2PsY5zf2pAJlMmOvhE0g4xKjGwwrJG5AkSsuEy+lwdbOpj0WArktMT2rcKw
	 cLjZ4XO+oPf1lM5ksG6zG9rQ/n62/wrt3RJ4sX/jsb3XZqifRXjxRp2jZWWq5APXeFYah
	 +2Uq5nvkHbvt9exQB6fDwMmkvAg51owg8b+DnhSM3woLnqLQGv6x/HpP7lFXcPEnc6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793756733;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Z/j+ii54if0JoAhvrLmKZaSRfECQqaiibU7J3A58s3k=;
	b=AGZvNmHnacJsh+DhrnU1rO1F22+TJ6YWbKerQJgMQnOCUz5VooTCy/nNF1qjVGvJQABY
	 tJLfDmMYNA/twDWjUXxjcEW13eJ1TnrG2RZoM8OJUcyXiqUQThnZw/QRvtblYcXzVof3M
	 kmlTWH6/jZiT2eM8weXe5aJOGCGrvhZ6ottCSUmy4KQ+MfjE2b0p4+LXGo11G0qtuk2Y1
	 euS0HfS7x3e6UytwDDSOoh1txXDYwmHZpZfO9WisZmeMD6A7uATb1fsPkhrIH+tP6rkrB
	 gkpTK6YzIsVnYj/Ez/7eD6N6/yCDbkwl1XnRLQPMBh9f5m3VKwsQ/jcKSyZogN5BKmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jDPXeGTp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6D4606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 01:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jDPXeGTp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6541F00A15;
	Wed,  4 Nov 2026 01:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793756732;
	bh=Z/j+ii54if0JoAhvrLmKZaSRfECQqaiibU7J3A58s3k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jDPXeGTpBKj50AqN3zMqbv0WJd367vUH7iaLQKFUaeETWNSeMuIkUS/Q2MOwZZM1c
	 CM+EhUyD/Eat8QD5/0zMXt70iLy5oa1BNFDWNP85bPGXOFJEEi0IhT4mqjQ4o7A59g
	 YI/JE+6L520vvjEeLATyOCbbgedsQyKkTSYmslMqB2TROCuG5Gs7qU2Dn9XiZHHeFS
	 Tmp0PBDIy9+lW3bazMpK5orsOYPA/Jp8R8kwMWOiCBRpWW9rNjQlDYmjlKQxGh/jcq
	 HqJER6P6zAwPxIClR3rfOuE1uUj/WMLMO2AY65FxGwfZ6wInPdPS3Vu1wVWJFneEGB
	 GqpEuHcn0xkFA==
Message-ID: <sashiko-outbox-196377@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 1/6] IB/isert: do not publish connections being
 released on a second list
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104012219.1759523-2-yhlee@isslab.korea.ac.kr>
References: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
 <20261104012219.1759523-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 01:45:32 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104012219.1759=
523-1-yhlee@isslab.korea.ac.kr?part=3D1

