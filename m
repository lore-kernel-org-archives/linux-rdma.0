Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794325531;
	b=YU19M7+thqMX7zI23v6W2pbWdKD4U24R1fspbqjVlmtOb1Yqt/VhhaluBQ4qJUPbRdYb
	 GcRmpmqlvpA+pWtxTawMbs7QWjeDgxX9NfY8/2dFBBjpJ+iSs6UAsYpIm1FirpJ6vLW+m
	 1QpXhG0MxryXkHPom6E2JJLFisL3foyXAcSz40qmUG2+oCgMkTNja4+zlQS2qllyOW+zt
	 tuI4iS+gg+6QYX9qwKYha+WCINsXb3TjyFC6gX9FkYM7nTqZ+dFMxEZuxssZChxDzikj0
	 HzaFUBuM493R2sTbOLf/rXpc0zLW6JDG20jzt7ekAQYUdcRjykTuFARuD8qaHlh92XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794325531;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=PbEWNohwIDgZAwALQiBpZFe+D/Xg9x1yr3W9GBnQvsM=;
	b=pwbww4pnBFU5hZyKhbonD1N41vnbKHea9vGiEOJa+6UZY9bvrrrfgIiifDSW93rHwB0E
	 zghkWmAwjAjRN38vu8RWBV7fqGLA/Uw7RSlzkeWm0vOq5hgE3+sPGUjBAzPjlDm1tD/Uy
	 2vBUhGAnGEC5Od1NJBNLa2wFmU4Vh7GzDO7W0GWka1qaiQzzm5sT+9jOFqMRn70DImau7
	 oKZdqpioI9OYK/7Dt/4d+W/JEpltbQbPxSwGrumGKDB6YX1CZRv78/AWaTrntAmxaqXlM
	 gIW/o/B1DiUm/WlC0/fxvMZWZTSx3wp4eMRBr/p4LO/MqWCyCx5dCP8Nysrsjdf+kHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MxzS2Hna;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B8F606A330
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 15:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MxzS2Hna
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA231F008A3;
	Tue, 10 Nov 2026 15:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794325531;
	bh=PbEWNohwIDgZAwALQiBpZFe+D/Xg9x1yr3W9GBnQvsM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MxzS2HnayYbkSLfzqtj38nof47tMvOaGAh8e3YEjSyZZ66R6yXv/CPYFvZrIwymo8
	 NFuBHu4r74U1OvwSylbxQo5bWMKl4ia1qbxvrsA3c35NZ89YAz1+EomcnqKzP+LYxy
	 m3LIZpAc82GgFkPwbj/dCXDaWXKAaAIBAF7LLbxL4thB5XLZwm6KUGPh5H92j2t+ag
	 KIGK/23+r17vuaTph6O9APr9zkndrJzHZkbe5XsXe66jAIjwkh2CRkLE8pm+uKOTxe
	 YIJr8+Eg4oyICMM/C++tGKFSZSiyTOmdBPIOXvdarocyvjbELnEGBRLrIB0fkdLdp4
	 Wzt1dUogUpKlw==
Message-ID: <sashiko-outbox-207289@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v10 3/4] net: mana: support concurrent HWC
 requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <2ae0e8b22569dc23178d0ea42178808ad92cb6db.1794208055.git.weh@linux.microsoft.com>
References: <cover.1794208055.git.weh@linux.microsoft.com>
 <2ae0e8b22569dc23178d0ea42178808ad92cb6db.1794208055.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 15:45:30 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Long Li <longli@microsoft.com>
>=20
> Give HWC message slots separate sender and response ownership. Initialize
> each slot under the inflight resource and per-slot locks, publish its
> bitmap bit last, and release the slot only after both references are
> released. The per-slot lock also excludes an older duplicate callback from
> resetting or consuming the next caller's state.
>=20
> Serialize SQ posting so concurrent senders cannot corrupt the producer
> state. A posted request which times out keeps its response reference and
> slot until its late response arrives or teardown cancels it. The bootstrap
> channel remains depth one here; the next patch selects and allocates
> larger queues.
>=20
> Wait for a free slot while the channel is healthy instead of imposing a
> [ ... ]
> Link: https://lore.kernel.org/r/20260914175044.2a26bb46@kernel.org
> Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@k=
ernel.org
> Link: https://lore.kernel.org/r/179250339266.3135.15035365058593192217@ke=
rnel.org
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794208055.gi=
t.weh@linux.microsoft.com?part=3D3

