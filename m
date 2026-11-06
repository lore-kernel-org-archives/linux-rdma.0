Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794003770;
	b=JrLEi/2dtu7rYCjdNZBA0xzWmrgzqXLoGGpzvl11K7/qSQYvC0ySzkUKlsxK6elE3H+0
	 zYL5wggb+nfiUQ030gDFruWKDwROe+s59toU/bT+RfOgBMWHLwpIfvJCVVC/2wk81TPiO
	 OjhkpcWtPgQcMkGKadLHUmTAoAJ7LCEUa1Ws0JPVA8OpNPY/Z+VOyaQc9bPACusf5apeL
	 1Jizv4y0G2I9zoiOx1MvqMNoM0gf7wkyu3EMxHINjh+v9tqFpeJx9OhLYE+f2AAIJ3YtI
	 LxljmIpWma+dVPweJH7+bsqTDwI8ncVOM4RMnZ++lTIw+jTDZocqwdPzK4j1DLbkBvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794003770;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dd36zJNBiUENJRkG2lQqhmfVHrIETX+KWNcFOiTsIns=;
	b=rcsiJGiDvMB20WLvBJvuhKfIYMj9K4tIFrpYcqmFvBTv6ZpZhcF1kudkYwGLt2FhVqNq
	 KHUP4jbk7EWDI0cWrUpQ3CUGTrb0Vw4UjDFR2ej70qIlQInTk0E1uTCj4adhtQsa1J3Lr
	 i7nIS+K2TuggHdjf4o1AAbwavtf8+tKlHL/SBWt9K4uUQF/gFd+NnyyxPoZHvVdg2kmOc
	 NR29JbxoV3+PzMbUb6k08m4zJ5E8m/KysjklAmzG78b++zuI39x4S/Wjm02J7N24TCRYt
	 6VJ26All1UnziLGDZ835HZlkKvMRkx3+Dxr0BOGTSQ+/sU2cHf71qPD8hb5PwGRsgvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JEevxi48;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644B0606A331
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 22:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JEevxi48
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C3C1F008A5;
	Fri,  6 Nov 2026 22:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794003770;
	bh=dd36zJNBiUENJRkG2lQqhmfVHrIETX+KWNcFOiTsIns=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JEevxi48PYEDSTQJNURfI0CW62ocD461R85966x8+ph5X5Ecx5CnfXG1QXgcq9X+6
	 HofGYGGMgjL/HURN4aai5aTa3y+n3rockngjlf2vSQW3gqHrRxyek3Y/y7HjU1IOUd
	 4o0XKRwVegsnGWER/6/cCcIG2XUuvevPThwrvQ2iaW1TJhtnQBGYA/gqK2eCApamqa
	 D5lCrpKswNqh8NZaQJt4uJmDqQEAKPCapTNdUhfjdBYYnYu5jcpaZnnj4SrBJ98fRw
	 YfSfem0QqYMkmnqa8o3Yx85b5+J5rguc57mw3ueVVgke49nharXFYxLX3VYnT6xAKW
	 YdyaHnNAhkkVg==
Message-ID: <sashiko-outbox-202328@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 2/4] RDMA/irdma: Check QP handle before
 decoding CQE errors
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261106221201.2266301-3-jmoroni@google.com>
References: <20261106221201.2266301-1-jmoroni@google.com>
 <20261106221201.2266301-3-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 22:22:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When a QP is destroyed, any pending completions for it are scrubbed
> from the associated CQ ring(s) by setting the QP handle value to NULL.
>=20
> When completions are polled, these scrubbed CQEs are identified and
> skipped by checking for a NULL QP handle, but this check was
> located after the QP handle could already be dereferenced.
>=20
> Fix this by moving the NULL check earlier, right after the handle
> is obtained.
>=20
> Fixes: 42f1d099093b ("RDMA/irdma: Extend CQE Error and Flush Handling for=
 GEN3 Devices")
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106221201.2266=
301-1-jmoroni@google.com?part=3D2

