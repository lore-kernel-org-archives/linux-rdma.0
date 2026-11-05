Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793899673;
	b=2vCX2TPHV4m5IRpkbq4zuU15ElOpPFTGtlBunND4a/QfcQ81U2zaVKb818U3bXf96VmJ
	 S21xM6Il3R4flz61D0CMejh1WofgjYbGcoWiAuFv84AWzGS1nA4bKtP3fPgAx4lK4EekR
	 FumSEpRCX1dUV3ehxBsD9jtn84xtJJnMi3C8Of6m5//+QErKAXocku8Sr0McLkkULzZbt
	 pejG9r+6oHbynLWfM4rlpOe9iYKB0f/31qxZ3OlEvN1kwRqDL6HFMAlBV9fvAuXnm1wXi
	 c865+nWWFWqzNQ5uAiAWJ7e+LiEV8uVIAaPEmWqhS8vSnC6NW8AtY6bWzDRvpnv4oHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899673;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yRghYNX25/Xa7Pty3pozHxOFwcl4+3vrz5IOnDQAEE8=;
	b=O7iQnrOsFDNtwJ1RBiY/Jm6yVa9Mz7I1R/JF1vEBZcfKNbdRbXxPCsBQZlCxBXPts8SX
	 zYnsUJr5MuqGBGAi50Njp/Y9fELWCswbrPQ4zgcZM62/I0ITUH9sCHy7U+cG4MfMyBQ4Q
	 +b0sG0c4+92B5Mv5rYiyFsNda1a90/6FSXXNk6WnlVPyqjr7xGcWuXeM3qVytWyPNW056
	 humGOQiXr4kmq7V1Tb1rcVRdPv42eLfPezBhOPIzrryjsT4difEdVxxY33PPX/NUA+OhN
	 EyuK2YDB8xOvCzge9zDBBAHOWC4n9EDceau9TSa5sdZDsmvus2iyB8EDW8HQMtAZBow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BXWILmNT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696E2606A31B;
	Thu,  5 Nov 2026 17:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BXWILmNT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160501F00919;
	Thu,  5 Nov 2026 17:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793899673;
	bh=yRghYNX25/Xa7Pty3pozHxOFwcl4+3vrz5IOnDQAEE8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BXWILmNTW6ZWyf9A8BXGzPx02QGMX1+o13CLagcMo1GrNzuSnmthPiQvYbims8puD
	 hzp3kmJ5qzCLV3EDjnxbDAhA6Mbu2xtQEkhtB06+Q6JTAKlYiqs/Bvatv2YrmLzh5D
	 MMj6RbKZG8TNbESR0MnZc+FyDgjYSxcPVKD087pJ5nvH9P37wko6wT/Vqm6BBR4w7p
	 tnVLbtw5HcUud3iRBHyPkC7yXoGlyH5cQvuhOFdIS81uKcrZiOdW3+rpPQmFFTNkmr
	 J8loAxUo9yfmynhyKEd1FmnmcWhZBM8lNjIwdPnokpsRCXZBYdKqyl+KULUQKJgsga
	 2MkyMgg2l6WmA==
Message-ID: <sashiko-outbox-199618@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] treewide: Use offsetofendp()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bence Csokas" <bence.csokas@arm.com>
Cc: linux-rdma@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20261105-offsetof-v1-2-4153f5c10edc@arm.com>
References: <20261105-offsetof-v1-0-4153f5c10edc@arm.com>
 <20261105-offsetof-v1-2-4153f5c10edc@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 17:27:52 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> Generated with the following simple Coccinelle patch:
>=20
> @@
> expression ptr, member;
> @@
> - offsetofend(typeof(*ptr), member)
> + offsetofendp(ptr, member)
>=20
> Signed-off-by: Bence Csokas <bence.csokas@arm.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-offsetof-v=
1-0-4153f5c10edc@arm.com?part=3D2

