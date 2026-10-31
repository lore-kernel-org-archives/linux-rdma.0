Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793456460;
	b=Znti7yWcT+3TUzPmJ1UA9E+VwyzwXwBdxo8hiEJWfQ0GEydL+ILc/Xs1EmdBrs/vmz4s
	 yIrDtGEdxqdrl9ZlhaofWTfMsgGOeLfhLOmPnjSpcPFHetV7fqcwWma8TAok2Zkud2tps
	 LrP27WUbJA8rAh0Mcq53C8qm1BkRjfJ/sMlU1XenIP5HME99UuITq4syzORR8TJZ39l7B
	 F8+IHxzdYpgko64e9n5q1vqkFJ/CRysN21QW3VfRB5IrXH+69WuBUg+XI9BXsowH3mXUJ
	 epqjd1MY4d9tARbA9KtYmIyxoM137B3jQR8VlEnXd/X4Cg9TqbMXkxswflpqdsbt9Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793456460;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3yxA6iW1nSogwUm5/Mp5+t4EtH0RLBmA2qKFN/8vMdw=;
	b=oJ2T5CTFLCjaKs05+uIdi1ez4KbJz/i7Pchh1DDKNj8uS+VGnZ77+w/rqNvSVXTYn5IQ
	 28yMZUtACMLv36UnGGFJkkYR/Mh9vbWqknlABnVT3aJvKoxPGD5L/a8KuPs/+kXpZPLJ1
	 Uej1rkzBdb5uKb3LpRGdCWEUfewLDrU64fYmz00CXgdslH15U8z3brp3Ek3SuOniIX+bp
	 P6MHi7wyh1VUD3a4dmD8h2e0ZyiS35Nuk4d3TbAmUKoPQtWRDiPnHJoYoVQdc/y49Ru9b
	 wLl5gQyPyv2updfRQjXRL8ExnI80M3znH1cXx274tP2AX3koeRYkd1hh1T8VAyZu6Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IjKelLqe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FF0606A31C
	for <linux-rdma@vger.kernel.org>; Sat, 31 Oct 2026 14:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IjKelLqe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F531F000C1;
	Sat, 31 Oct 2026 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793456459;
	bh=3yxA6iW1nSogwUm5/Mp5+t4EtH0RLBmA2qKFN/8vMdw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IjKelLqeaQP4kUPLQUmS2IujVadAqwaKBIzkPRN/eUn42+Wm+pqArZWs3TPeQ9vil
	 hy2n7FXc7X+l3jNmv3rfmqVPagBHYLsK6nytOpyi9umzdiXO5mAzQNiMkxvJbYRM6+
	 X9Qs1EFninjxZCu/LDdTOkpnw+4kcv9tInh95nw06sb+We2VYaqhhXBvFhgsYvMTtR
	 dLFT8xGQrSz5+qAnKn6tYXnjMBB64KP1VLShf0UHfOxEZnRY3l0WpcN3H424eCC83F
	 rfPZWsmFQL+2/d55jZrIIctd71VFz8gnAAtk9D+A391CZ3BM+kFIxTdhmjXtlwfQIA
	 64BGCE2eETv1Q==
Message-ID: <sashiko-outbox-191991@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rtrs: Fix potential use-after-free on client sysfs
 setup failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guangshuo Li" <liguangshuo@mail.sdu.edu.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <ddd08640709b149408b616c3eec8fee847af757e.1793455791.git.liguangshuo@mail.sdu.edu.cn>
References: <ddd08640709b149408b616c3eec8fee847af757e.1793455791.git.liguangshuo@mail.sdu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 14:20:59 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rtrs_clt_create_path_files() drops the path reference on failure, but
> its callers still close connections and free the path. This can access
> freed memory and free the path twice.
>=20
> Keep the caller's path reference until its cleanup completes. Move
> per-CPU stats cleanup to the path release callback and let the embedded
> stats kobject hold a path reference until its own release callback, so
> delayed kobject release cannot outlive the enclosing allocation. Keep
> direct cleanup for failures before the path kobject is initialized.
>=20
> This issue was found by our static analysis tool under development.
>=20
> Fixes: 215378b838df ("RDMA/rtrs: client: sysfs interface functions")
> Cc: stable@vger.kernel.org
> Assisted-by: OpenAI:gpt-6-astra
> Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/ddd08640709b149408b=
616c3eec8fee847af757e.1793455791.git.liguangshuo@mail.sdu.edu.cn?part=3D1

