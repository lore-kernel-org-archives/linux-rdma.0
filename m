Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793381877;
	b=m5Psh6VuhXXsD7oNfmHNvAW6EhTHYyUhlSsh+hIvO+9bhCEv4VtLnr4M1q+dJ0UrOvcv
	 9cn+9rEgyQBJs0qy42Lf7MLW6n+fmUaZshxdcOFV4xUauOLn1R5kavnJrt/43b9Lkm9TH
	 nglGVPR+LrWFbOl3Ul/lA9brTnCcff03LTGYIqiATUCqfr0DKweO+99LqPc3DnOa2JK9w
	 8WCt0FTS+ek8AJKOdQGAT/kzBIu0OqE96DP8ku43QVAHRb8G/CU4LMYnyJL//P8u0Xm15
	 gPBEomukG5fst+gkWoV36GhNzliLJFF3rf+/oTtoOjO7rawpEI7OUFyH/Crq5wuz1Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793381877;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cPgFaWwM/UVLX43eA3mvzXoVD74DFfgu7MVjzVzAuVc=;
	b=V4qyK52gFQfDIdpVTgoyENyexFnpJ+guADnkZa7/5+gYFOsNhLTwYOSDLrK8/0/feYxN
	 Dv5sthSyk7Cb2Eyl42K7ykBbveSSZE4EkPdwZLzm6uQOcptAP81JmCmvEZ3DhvWlm36g5
	 j/0Bc6nXNSEMJ+Qbo/73embcefOjlp1bVfHqb75eBcO9ZcTjT/BEglzdd5H7nMOPpsxrD
	 Okcxxp2n+Ym+jfY4WD+qBnPvP/IkPUcUcWD7AXnVxq+PeXGVNQMIQicvb/tRNeOHosZ6W
	 UvXgJsLgNpEZ3L75p49FqSxqKl6WOzw3vrXzQRm4ewCDYCqVeYq9OgdTrsbvi0FMdQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WHtHObKI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E676A606A32C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 17:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WHtHObKI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD601F000C1;
	Fri, 30 Oct 2026 17:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793381876;
	bh=cPgFaWwM/UVLX43eA3mvzXoVD74DFfgu7MVjzVzAuVc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WHtHObKIA2by1DGrFFN1ZUYtCexuDr2iPcZcJSm4MzSrkS9jhMidDV7S64ZMvAqTe
	 84d/dXME9/VncS2svCaKu/PICJrYeEQQupd0jVlJFQiIUB4p//Z92OeWbE/cJFiXsx
	 YXzRtdEg55ir5Utl9cdJUDCjX9jNOQVdmPKuDhRtfVlazAq4zkGS+1wpP7VNxywBQL
	 s95OI3eJCp+OUvTIAkt7NM6RNxDbIy/r5DMvXS3cusAMZBhgnTUJtB3QdjMaYIftFJ
	 OldMJSDwaW+f1FCaBazFQHunr2/62ZF9AdjDXr8Oo6muAsCtOiu+11zZi0JE4RaYsn
	 32uRS6aa8EYxw==
Message-ID: <sashiko-outbox-191349@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next] RDMA/irdma: Free cq with a safer cq num
 reference
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030173254.2000665-1-dhu@x6u.co>
References: <20261030173254.2000665-1-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 17:37:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: David Hu <xuehaohu@google.com>
>=20
> Within a iwcq, `cq_num` is allocated first, and only
> copied to an inner uk structure, `cq_uk.cq_id` at a
> later stage. Freeing cq by `cq_uk.cq_id` before the
> later stage leads to a cq id leak.
>=20
> Free `iwcq->cq_num` instead, which is allocated
> right after initial rsrc allocation.
>=20
> Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20261016202909.1289496-1-dhu@x6u.c=
o?part=3D4
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030173254.2000=
665-1-dhu@x6u.co?part=3D1

