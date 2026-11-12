Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445021;
	b=XTozio+rIOCoSe6TAtpaBOCiwRh+EA6uB2LZfaZFlKbEcqebHi1CxCukqEmN44pqx4Wl
	 xA4vrsvCZfzCWSxHq679ioi6zHZsqZwkapyGOTuc5Rs02DsKs7dAWeEECN8ZPukK4vde+
	 1Qfjy+yOfdKebjYEqBSkLNe4Mb7Xn8PqjzMhV0JnrFWBRAlxZSZKCQCQawds0TzQKggTc
	 L1pd75XTr9OlJCjMY7Hk6LA20mp2kZJCLiEzdD2JQLgBBseJh1jPZiBVsBhpFh0t8jtls
	 JlSocCYzMPAp2RkfkPDt9WwE1CptZXD8lc83gF3tqVdoxip72uS4p5aD6nQ4mGEXVGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445021;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gKM+UsziAigbdeQ5/OufZMy78M8OdXWRb39oNW+FUEo=;
	b=gkaDDAGysAl6DrprIvtRKV2HrhTbDUTETFFqTSz+jw4wQn1t9ax0TcKUAGfLqGtAxM76
	 pSHlVjJRSttQRks+5t0N9Ojo6WYxMRvT+sO7HVWmyNvEsS9iFV3I7w6guXfavpVS1FQ8R
	 yUnYg44bGeilRJ1ad4c2/WTmHpBLaAs45K4XztRRBPagTBRNsc4Tc155MxiSzCnrICrK1
	 XHmbEWC4NCvHM0xJloPNz0ukT/WTBcTEPM5uMvfjNazMr4VuPPWefbERSgZsG16nSRm+J
	 Xf3DaPoKhZ8DZLk84qCdQGNpsQ/1KKlbR/usS5hBY5O88MBncFsTvZpjx7y9uCM6iVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hCFV5R3l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E6A606A321
	for <linux-rdma@vger.kernel.org>; Thu, 12 Nov 2026 00:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hCFV5R3l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504B31F00A05;
	Thu, 12 Nov 2026 00:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445021;
	bh=gKM+UsziAigbdeQ5/OufZMy78M8OdXWRb39oNW+FUEo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hCFV5R3lJC4wAtL/CrQA4t/9EY8J3nooyl9M1EWXbrysJJ4z6c0pQyZakJHu5Ub07
	 pPAX4OQjlE4zp8R5NUfBxgbG+YJg22nZjs3AuRUSIM6n5wWQLf23GNgWWyvLUsiNxt
	 JSnW/ipSYhqcWbihhSG7mZRSMts+Eo3BCCP71bjNMvodU2pjiRAAN5XqbqczI4VEKh
	 QTUemL48Yr3PaUZParxCVI+qI5priczfHZ2S2h7D4isQoEVUr0SORiuYeo7oZdWLLw
	 f8Eo3yHTJ4ICx4sjSMSgUrvyNMLsUuUTXNCMZpI6cH/NIvcBci7lmnwaDHZ7t30qrb
	 UG7H+ROvbbymQ==
Message-ID: <sashiko-outbox-210007@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 04/15] psp: add support for socket-less psp
 associations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Todd Freed" <toddfreed@meta.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261111005533.6436-5-toddfreed@meta.com>
References: <20261111005533.6436-1-toddfreed@meta.com>
 <20261111005533.6436-5-toddfreed@meta.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:57:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> currently, a psp association is bound to a tcp socket when it is
> created, and can hold both an rx and a tx key.
>=20
> add a small registry of un-bound associations. These have either an rx
> or tx flavor, and are referenced by an id. other parts of the stack can
> then attach them to packets. see the subsequent patches, where the tc
> psp action does just this.
>=20
> an rx association records the spi, version, and device key generation,
> primarily for describe (assoc-get). a tc filter matches these fields
> with the flower keys psp_spi, psp_ver, and psp_dev instead of
> referencing the association by id, to facilitate hw offload. these
> matches are added in a subsequent patch.
>=20
> adds the following new netlink commands for managing these associations.
> [ ... ]
>=20
> published associations are dropped from the registry when their psp
> device is unregistered.
>=20
> Signed-off-by: Todd Freed <toddfreed@meta.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111005533.6436=
-1-toddfreed@meta.com?part=3D4

