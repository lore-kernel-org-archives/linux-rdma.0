Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792857719;
	b=IKTsRfcj6jESzWQfgFcBCptLODDgIO0TJe5JsweCA8NnhrbzG/KeR/sAgwElsrP4Cg6F
	 +A0hNW/ABWCEHeyu+IjT3pA3opOJszw4AAK0+cT04ftrhNlpFSc+S5UaDQuh8iJ2diIgz
	 2laqaEC/Aj0gIIjS2zP3gxQYRdtOfpMio0Eks95FAm7jkx7TtTmRZdYdP4XDaBFgqLPtb
	 w2jCmusEmc4hf80GGoTUWeVLsBSjVMeQ1eyC+Ztxr+G7ts0FKWvD1nf06gJwbnma6jj8k
	 g/8UlTPIu8DFXhgIlNbT+e851vS6QTg8p30SmGhq6t0lZBb/87Yqj1OXp1SSDqixcvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792857719;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=UdoAtqzfQfprW2CA7CGrTDrJCuheMOC4xnFXaX2aLhQ=;
	b=sTXpmQcY3/gV1BCjAZ/CRtdseoYUZxBTr6v2KQxeMNdWXfHcUgNQ3FSjb+mSfhzBkdhz
	 NRJslNMAWlwumuYMk3UOIDEfUff30wO2hKwPGxf9MKnbgOTO46b/6fBj9jMWxo5Pik2Zj
	 7va+DvXUIKBiQcTaX8UUrkChJsWuF3A+IFl+kMIkn++hKQJQ6S2MPQnh7WRJzxfTQHMx1
	 jyLy68wKzqFntE3VrtC95sDnn22dv+a8fNR/FhFHRtEi9vvuPvXsDkCneVtZGuZTbLUzu
	 B8SSKZhdV462NBPP/7Wbqs5LW2Gthojon6n85YWq7tqMyuk/r1dlTqlJRhLm10I70Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qubc2L9m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C36D606A31A
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 16:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qubc2L9m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D821F01825;
	Sat, 24 Oct 2026 16:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792857719;
	bh=UdoAtqzfQfprW2CA7CGrTDrJCuheMOC4xnFXaX2aLhQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qubc2L9m/sJZ4O1EF/XPRCKGZhsRwHCAg8cOPMALyBf5DdVXFyUDSwtuRhd9XNS2U
	 iFHxYYoRD3BtS9ATBatnfx+2KW3qYh9WR0AbGk52KQEIDvpOw8yC71MHUX2KbLPHp7
	 MHZdy69Nus6euS2lyRj12NIspRaB3M/iKTFkTFEE8rZwvKk/dQEk8ylelWMZmJC1Xl
	 ZfncxBnDTVHWhtUeVxWEH3on0v+dMfZz4b3vmcarQfVWVl+j3BxaBBv7BcHF0go+y6
	 mzy2YERLf93zIA4Kjuf4Gl6rOd1e6vYL5yRYiDMAPLXOqIdPnE77K/EyriXw8MCO3x
	 1e7lgal6vGitg==
Message-ID: <sashiko-outbox-183787@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] IB/cm: hold a cm_id reference across the send error
 callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261024155507.3418345-1-yhlee@isslab.korea.ac.kr>
References: <20261024155507.3418345-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 16:01:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> cm_process_send_error() lets cm_free_priv_msg() release the reference the
> message held on the cm_id and then keeps using cm_id_priv, dropping
> cm_id_priv->lock and calling the consumer's cm_handler() callback. If that
> was the last reference, a concurrent ib_destroy_cm_id() takes the count to
> zero and returns while the callback is still running, so the consumer fre=
es
> its context underneath it. For an RDMA CM consumer that context is the
> rdma_id_private which _destroy_id() kfree()s once ib_destroy_cm_id() has
> returned, and the callback reads it through cm_id->context before any sta=
te
> check.
>=20
> Reaching this needs a send that expects a response, so a REQ, REP, DREQ or
> SIDR_REQ, to complete with a real error rather than a flush, and the
> consumer to destroy the id while that error is being processed.
>=20
> The report below comes from an out-of-tree KUnit test. The race is a few
> [ ... ]
> path.
>=20
> Fixes: c1cf6d9f743aa ("IB/cm: Call the correct message free functions in =
cm_send_handler()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024155507.3418=
345-1-yhlee@isslab.korea.ac.kr?part=3D1

