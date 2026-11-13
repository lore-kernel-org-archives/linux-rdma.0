Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546317;
	b=zfoQIhuF+OHaHITtaUHLZRiLeFxz7+1Kirgrto/Hbt6fAmsP6ZRVZMbCbKKhwa8GfOFR
	 fhu+bWG8I20rbPgOZWf4XB12ED1vMYMFV0+0WbNB7cSInEh09Z0Feg36ik3jpSRPbwhNW
	 dN75AhcDJkttzHwRyX/KJ0m5auXGhH8uW+Y2xyJfNO0PEKAeB6HRF3HnSOAzr1fZMzP87
	 l6lWen92w8gb1QahkXXSdPtiLsBVtkwGvGsW5MWcEhGflvLBN1RtKbhZQfFWiub6ueKMt
	 6/l8cJiLbobaBcLLZTrLGS/x4cROhHbrot5LdVjAowerXkXROas4Z6fSsuNfRNrwa4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546317;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+yLww650GX89ddmDlgj1XG/R9JuWJ+hvlRgt/HxEzAU=;
	b=EUPa/Lwk+rYQ884IsAaZXYlL6YaYY3XFtjeyy2pmSxkHyvHS2ily0suU/OCMdfFNQsqK
	 HBtqTuO5shQUTJ8NSGwKAlOUkall4AKsvFvlXLRMS9NGbb8fSGSdGnLYbIYcX3jg1+5+M
	 3JZgAfhrsy23bKcK5U0Rau6CVSaGCRxy+Wja0Yf4vteaPLtFvcZsAkz89Ooz8uH0Lsymu
	 5eSIDEjH0Fr0Il7rgTy4WzDGlmZykaR7hnIo8dxenOtJRi7pK6iP0SkLqfihhmNtNoCGo
	 W3FHluD4ds+hbzLiLR+ckuc8bwOZNhNoWtzcbP8d1B+e4X8Yl7CkXtbpjnplTd70rBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DId4H7es;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302E3606A331
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 05:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DId4H7es
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE2F1F000C5;
	Fri, 13 Nov 2026 05:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546317;
	bh=+yLww650GX89ddmDlgj1XG/R9JuWJ+hvlRgt/HxEzAU=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=DId4H7esz4vpXTK9MdaTKgrlnJu2Veh2h5KwG2KaZ0RAqvC8Or2MtrIfb9yPymCZd
	 9WHF3R/BxUdv7JVR/86ItuV9D3xOTyfBqljlKOmCHImuHpUeK9zavmRO8J2ghI+cbp
	 XzzKE2YzQpPz0KTaNE3RTw372XCzFv9QpTcFpqIsGBJqXE+tl4YkAklqfK7OFI0X1z
	 16A83rszrx8xZLuKuZv+yivmGt8kNm442ZT5qEkHM3lm4PdKYE3+V+VdhB7wsNkupx
	 Ubhefm9omxoDz5LcVAyVC0tIwdJJu9i63PcOajI5DfiAx97cCKEl29W+h6E9PIBqi9
	 pQZ/J50M0YkcA==
Message-ID: <sashiko-outbox-212200@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v12 11/12] net/rds: give cm_id->context a
 reference on its connection
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261113044355.2932029-12-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
 <20261113044355.2932029-12-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 05:05:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rds_rdma_cm_event_handler_cmn() picks the connection up from
> cm_id->context and holds c_cm_lock - a mutex that lives in the
> connection's path array - across the transport callbacks, but the
> context pointer owns no reference.  What keeps the connection alive
> under the handler is ordering: rds_ib_conn_path_shutdown() destroys the
> id, and rdma_destroy_id() waits for a running handler, before the
> destroy drops the connection's initial reference, so no event is
> handled on a connection that is being freed.  Before this series that
> ordering was broken from inside the handler, since rds_conn_destroy()
> freed synchronously and the one callback that destroyed its
> connection, rds_ib_cm_connect_complete() on a protocol version below
> 3.1, left the handler's mutex_unlock() running on freed memory;
> commit f97d8c7bab78 ("rds: ib: use rds_conn_drop() on protocol version
> mismatch") has since switched that path to rds_conn_drop(), which also
> removed the deadlock that destroy took on c_cm_lock.
> [ ... ]
> rds_ib_add_conn() refusing a device that rds_ib_dev_shutdown() has
> marked.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113044355.2932=
029-1-achender@kernel.org?part=3D11

