Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794597434;
	b=XxOtnAIaFazDu+bnZ0UpePKkd8F8Q+spCKdNq0GOPWSVjc2du0BfrKpTCIZ7MrzpQ8hS
	 gpK9hA7JNNm9ZWL/ypWrR5MVVMWzXteBmzDlmO901Ph+0pV1Zmy+U++Hm59LDFDfunTcB
	 R+0ecHwk2Fj8imVxce7vcLQ68zO+EmZLU5GMtiG329dcF1DHsvNgQbAnY94xJfHLN67oD
	 1VOz7Vv0DmNMpeVoQ3aSbmhZVgyPpO8Ue4j/ZUm7nNvLiFB7pPf4YS6784PwiKNIecHJE
	 Rlu9hSWH3MFLDM9EH3Pe1liWjqZZBtlO0EO3gVsA6yRy9WstoSbgAMUpOAcrag4OHEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794597434;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GDY2yo1wx0V00Z4CBXlMSad1trdF+BU/9D1Gl7Tl6RE=;
	b=TLOdpafY4xOi3gqh6xmKKxvqMciEmpkjvWub3p7FCs8FaM7b+sIH4a7ADmrLeKNn6ZBF
	 cLF8ozfsoMI7n/CBsPKjad3HqDTBur0gHVqSvDOq3YC+zIpghhg7EFrL6dMy0XZbYhqd8
	 L5t+5B9LV6p0qFj3E3UX+H5eSPZfC0egX2XEPenTmcBoBIpV+hbaby5UdO0v3MYeoG4tp
	 cTNRXDbp4W105gEJgwXKPN0qFiQk4A4tP6upopXcNdUdza6V3c3r+3h9TNkZOTQk111fQ
	 zOeeaqzU32C0IbiMa1dIhD8EFSot6NxpxKZafo9bDUK5c5tqYR7V0ttiwEHCeNOYhHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nnI+A7Ib;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA61D606A330;
	Fri, 13 Nov 2026 19:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nnI+A7Ib
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7291F000C5;
	Fri, 13 Nov 2026 19:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794597434;
	bh=GDY2yo1wx0V00Z4CBXlMSad1trdF+BU/9D1Gl7Tl6RE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nnI+A7IbnQ3+y3N3DaOr8icd+UEFlsr6oTlDteBtXAeYtx1Q9f4X6U5xIqS14cerU
	 hv41xXqcNY/OU+PQCf+OCAWQDZKIocdbwnwDZzyJ1EVCUkhJUTgKZ2AAZQEvpOJKYf
	 zG40YSwDXdAWe0rHoT3g07fVRog4rMvi4JGnK3+jXFMS/fMSeS5KBs1YnGyRmuIWm6
	 0bYSU20H3YhYKnyF/e/eJUSIfkIwIjiAQxOLoG4AGxtccGV4CVkBCV8pntzMU2ftxG
	 3ZPmd3S2xQiZLKgwDJMHjrB0/wvenlIhyrXumwEtTDmVSpiN5v+KukFUHuMoSwySgw
	 mP1UMr2IlPpbg==
Message-ID: <sashiko-outbox-213534@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/smc: check every link before skipping the RMB
 registration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bryam Vargas" <hexlabsecurity@proton.me>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261113-b4-disp-08835f86-v1-1-b2ee1b9b94e2@proton.me>
References: <20261113-b4-disp-08835f86-v1-1-b2ee1b9b94e2@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 19:17:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Bryam Vargas <hexlabsecurity@proton.me>
>=20
> smcr_lgr_reg_rmbs() skips the MR registration (its fast path) when the
> RMB is registered on every active link, but the check reads is_reg_mr[]
> at the index of the connection's link for each link it walks. An RMB
> that sits unused in the pool when a link is added is not registered on
> that link. A later connection on the older link that reuses it takes
> the fast path, never registers it on the newer link, and its
> CONFIRM_RKEY still gives the peer an rkey for that link. After a
> failover to the newer link, the peer's RDMA writes into the RMB fail
> with a remote access error, that link goes down too and, with no other
> link left, the link group is terminated.
>=20
> Read is_reg_mr[] at each active link's own index, so the fast path is
> taken only when the RMB is registered on all of them.
>=20
> Fixes: 4da687448de7 ("net/smc: reduce unnecessary blocking in smcr_lgr_re=
g_rmbs()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113-b4-disp-08=
835f86-v1-1-b2ee1b9b94e2@proton.me?part=3D1

