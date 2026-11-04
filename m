Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793815429;
	b=Mctg8aSvd4t79vCf9Vj4MeCLjH+6oVgPAAMnQRjBkIKbp8p3de/Nz7JG6B05jBS/ldKT
	 WNUenogg51M5A1+R+fbpR/TkeJvfwjzDb8IebzmG4rF4hgOOWQ5J8GLq5AFdoZQFDjJvJ
	 +/KpZHW11WuQFWqEByrxEPRN7OLIgrgiqizq9rsWr3ekmK8T6J8eWncM6P+raHep4d2lI
	 uPbAsS6c/VdN5RhvBNI4p+AVjCCEHhBvOkLlCj8Gzz5jv6I9TJyyM+ivkhI3CrwJjdXGl
	 G+o4ldGdsFKbrUc96ZC8KBx9yZtp2dmILGoAtEw7vHtLe1J+3o2FW/ap6J8E5NSdWew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793815429;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zwLHx4z82Q+FAVbtm20JGXD5mWr5G4Dr6ti79TuJ/iA=;
	b=2ucmiBsV5DZEuLxA+8MhBRnJipIhtEB8KUTreMCZ7+x68g+ZnbVvAJHA4Ca5Gnv1phls
	 jJRg70gSJ5lcZo7thurYgpk4g3ta9jvGqsti/1bsiPZ65UgIbnFyr/XbiqvgJi3faokzo
	 17U8OuNM4PxZJZh6RPtCnN612v5K1NO3MS9nvNx+IHq1CtMvPTdW4SSNyZ6N310+ePQWW
	 Lzm2Ai8eHL8tIEvYDti8NOAZHEG6Q47vpU0NKsCXEgfTNWyLB9kDvDTttpZ0S2bFecuvz
	 e2515HJj3VGmAIFcBWgz8Q2+L7iGfx+3ToCajvhb96tn4Qv+2e9AKvhhkFDzHniiTCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PznwU6vA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D11C606A328
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 18:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PznwU6vA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C851A1F000C1;
	Wed,  4 Nov 2026 18:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793815428;
	bh=zwLHx4z82Q+FAVbtm20JGXD5mWr5G4Dr6ti79TuJ/iA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PznwU6vAW84L4WkBrjCns7HqvCbdCVo8gHyC/X7uGnja6bKZYWRvy4Ysxg6EcCgK9
	 IhuCCZOkXnKUIcrkL3vGIfo+9LDIvZa98APJvoNekPdwRBZDZvwuAqZwmJRmNrwFZ1
	 QTdujQg62vf7gmX6FQpUfTJ1lpD1Npw7cX1fmEArAEwyArrHsl1GtBIUNr3bQnZKaM
	 Mq/njRFosXJO2e4V77Fids1hChbdNq1nluTRB6+dP7lqbpWXADVrxaWg8VJZWq03os
	 yi4uemgbTvZsasSj4Vxa8F7PZsJY32dMhA/BDcXS6B5HFe6QOEsvd/6Cf/lgI1VyIg
	 bmL8IxfxkIafg==
Message-ID: <sashiko-outbox-197812@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/5] svcrdma: drop the extra reference on the
 backchannel transport
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chuck Lever" <cel@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104-liange-v1-2-f097e10cea1b@kernel.org>
References: <20261104-liange-v1-0-f097e10cea1b@kernel.org>
 <20261104-liange-v1-2-f097e10cea1b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 18:03:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Wentao Liang <vulab@iscas.ac.cn>
>=20
> Beyond the reference xprt_alloc() returns to the caller,
> xprt_setup_rdma_bc() takes two more on the new rpc_xprt: one for the
> xpt_bc_xprt link, which svc_xprt_free() drops, and a second whose put
> was in __svc_rdma_free(). Commit 729580ddc53e ("svcrdma: xpt_bc_xprt
> is already clear in __svc_rdma_free()") removed that put as a
> duplicate of the one in svc_xprt_free(), but left the matching
> xprt_get() in place. The second reference is therefore never
> released: the rpc_xprt outlives the callback client and the
> connection, and the net namespace reference taken by xprt_alloc()
> leaks along with the rpc_xprt.
>=20
> Take only the reference that svc_xprt_free() releases, as
> xs_setup_bc_tcp() does.
>=20
> Fixes: 729580ddc53e ("svcrdma: xpt_bc_xprt is already clear in __svc_rdma=
_free()")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> Link: https://patch.msgid.link/20261104022813.1484267-1-vulab@iscas.ac.cn
> Signed-off-by: Chuck Lever <cel@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-liange-v1-=
0-f097e10cea1b@kernel.org?part=3D2

