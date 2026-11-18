Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022028;
	b=tVqr0ITHNTZjVn1UU4nC4fxOlMitnOpe6WsGCp+kQZRmZUbtUr2KfQYInv/GaISb/c4l
	 ai1EbEEAlK3BnhJLznP3bL6jmf4rb66G603MeehFL1uHJXU79OmkqQIUGZIdCWSbKY300
	 Wl5hIJWshgXwCyJjkhCpL092cowkrNtERS3R5ph52J6Wo/f/2YWKnI1bJZbDjgM3mpKbU
	 sKkRcYTJIOtgGeCHZwqCf3TykWW0pUd/v6y1wJvTUhOEph/ErGNMT7ra/18P+JQNM+yuI
	 wKEc2e2JeI9KXSerO7hKKo2VvSDuIknvaZ/OPQwsZucTClGVKqvMrz+Pj3Ixldpz2rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022028;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cZALFnQii3XsSKMoNaaqBkgOpRA1sZfKR6/BOAk31us=;
	b=SSi5JuI0t9qZFjKaF4kEJydeI/VoLCOIcBvxLqxAxSWbMCbEDw2HgnzyVHYxMHfeHARr
	 aeuGdAkNeEdItuw94CaEbjMnik5lBxGRwjlkXBthhHwF8UDkrScC7DMd32dLYVySwf8PR
	 y1uvUPDWiqFeus/JhzHODvPv5+AabcCCyLYFb+Jvarw6n6RyjyzmSeVsId9f5gW4GCeM2
	 E/X86JVbqnozGNT+7601xSFFRUKLw+2xzaHML3VgxDOP5OEgfvhpEq7SZ6t1aw5Y4QqWe
	 N5KBFFo2dDwZsGLFc3xVo4mXIdNKh0/lFBNKPvGpiF8bXhAFVFzm/2/nnFbV/mqq2Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BlVpVk6q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D36F606A335
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BlVpVk6q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DED1F000C6;
	Wed, 18 Nov 2026 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022028;
	bh=cZALFnQii3XsSKMoNaaqBkgOpRA1sZfKR6/BOAk31us=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BlVpVk6q+MpuI3PoMKl7zNKWV1IIxzApKXDl1RXJTSde9ktjLQ0BtAWfugZyWucWs
	 8eV9fRzmw5chBh3J2e/KaJNDnx8xOJ3aHekHyRR/Ik0Ry33bsLB/YTmlB7g/Us+asW
	 MlN7jR2f02EJW/tNrtX+A8Z61hRg/AG86ExcqiSW6ExNAMCiMSpxfzm1l7K6Ih5QrV
	 v+PpHnaFBahEJsVM/aTukyRb2BQvL3B2kpdMfyf1EhXADA2v1ggk7G4dZQgH67XMIk
	 wDtuoozqONt8dzj6z8ICyiP3DQdBCS0qrs7tN8ZgW6J7X+IRRLwGAeCxFVVoY+5OkR
	 blMxslVWoauEQ==
Message-ID: <sashiko-outbox-221612@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 11/21] RDMA/mlx5: Add shadow FIFO
 infrastructure for UMR completions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-12-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-12-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The UMR CQ is polled by the generic path, which finds the completed
> request by indexing qp->sq.wrid[] with the CQE wqe_counter. A hostile
> NIC can forge it to complete a request other than the one that really
> completed, or one that is not pending at all.
>=20
> The UMR QP signals every WR, and its send queue completes in posting
> order. In adversarial mode, keep a FIFO of the posted UMR contexts, so
> a follow-up patch can check each CQE against the oldest pending
> request instead of trusting it. Each context also records the
> SQ producer counter it was posted at, as its address alone doesn't
> identify the post: it is usually on the stack and reused across posts.
>=20
> Nothing consumes the FIFO yet.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D11

