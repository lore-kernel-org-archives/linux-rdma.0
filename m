Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814851;
	b=ijGoqG+mNoneQwbmUJfXjLUB9a0o5qBpZFFgmgM/OkeRb7yq3lntKGMGDkBd9ZnnLBgO
	 bOKEXtwjPuVy8UBrIPuVLL3JUeNL3rGHRJ0gjDibxFs+Xmgdhm5WCPcIqRGQi39RSAiy0
	 tyxRS0ksK4XRtaGtnbg8p6KGY6i/w6cTQb8tMkw26v7Gl0+ADENEQDPFe1RGHjEZmf8OD
	 bkiuzOM+9EO+ETOJxSkfJOSwsmY8aPkT3/SKv9JCZhSgueGf6LMs03XlkxcnZCZvNFR5x
	 W16ZhDT1ezMtj8oKzlUpNfth1dG60bTOWtM445RaRse9BdJ9rF5QBjMyIpYKCallbVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814851;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=7K9004fqD59SWBg/6UNT50O6vX5JywOSlqUV5CSWzIU=;
	b=y5Ee1gVAXvXLJ5XYlN6mYq4kK9cnW+moRfQPIHsoZQgfA1cA3S5/wWvGC2KEEvk8HgWK
	 L6RVXdSGhza9oeQhHb9durnNvmUtBiQSr7bqsYbCNAPuRdTGiSG8vfGfWvbc5tnxFnE7D
	 Cgg01xzkkYHJ+lY6qXLVbfvtxKQnuMuQBH/2+/naQeInqwfHHuWk+Chw9o1FqGW8mMb8y
	 W2ZDav13t5+7hRBSHEotbfisTD2qmsy522dna9rKBE9LHE8G1KuuegO6po2CoRpNUkjDJ
	 BKnUSsPBywMp30o4f8AWbzXDv6Z+ObzLfnueQ+fLzqg9Xq5uLqam0137BFTUbykxAag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QXCqytnN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5329F60756F9
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 17:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QXCqytnN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050D91F000C1;
	Wed,  4 Nov 2026 17:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793814851;
	bh=7K9004fqD59SWBg/6UNT50O6vX5JywOSlqUV5CSWzIU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QXCqytnNtgCBK7NPR/IJm0pTb2btucqFcMa4zYg8m5pYj2DpUx85/041sbEnps2pD
	 L0D9lGmD8UBm9SosdTZ7Jax4rbjeur4rTdUlU0e9eyt4zSj32OCo6eZp72d3V6jg93
	 xh+LHp2z9NFzePM3eXr6aboWzlTvCjRDsDgEIU7vuyyHFAUqLhZEXLlUY+ZyBoQDKY
	 upNzIqd84s4nxCbbMFnPLOilgA8fWl4yO5h2+z2wFPfu0/Jpr9LLlavrsokba97r4f
	 d/I+KOz6iooanTm86sri4lw1AYCSF0bQTuT2LlJqD4gjkCFMI1aIaUdkI2acPqfsjB
	 MVf+NPRGAZPvg==
Message-ID: <sashiko-outbox-197799@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] SUNRPC: Set up the servername before the transport
 is created
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chuck Lever" <cel@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104-liange-v1-5-f097e10cea1b@kernel.org>
References: <20261104-liange-v1-0-f097e10cea1b@kernel.org>
 <20261104-liange-v1-5-f097e10cea1b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 17:54:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> xprt_create_transport() checks the servername length and copies the
> string only after the class setup() routine has returned. A
> backchannel setup() routine publishes the new transport in the
> svc_xprt's xpt_bc_xprt field before it returns, and svc_xprt_free()
> puts that pointer when the svc_xprt goes away. When the length
> check or the kstrdup() then fails, xprt_create_transport() calls
> xprt_destroy(), which ignores the reference count and frees the
> transport. xpt_bc_xprt is left pointing at freed memory, and
> svc_xprt_free() later puts a dangling reference.
>=20
> The setup() routines never read the servername, so validate and
> duplicate it before the transport is created. After the change, no
> failure remains between setup() and the return, and the
> xprt_destroy() calls on the error path go away with it.
>=20
> Fixes: 4e0038b6b246 ("SUNRPC: Move clnt->cl_server into struct rpc_xprt")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chuck Lever <cel@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-liange-v1-=
0-f097e10cea1b@kernel.org?part=3D5

