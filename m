Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422909;
	b=h9SjAoPFCSPVwNFQBdIIC8F1lg09XW+roI6NFOxC3eddU/qSHATe71JCA892f6gn+p8w
	 Q0t0O7LJBZFrct0V53oXFqwzvzOJlnA9/+YsCDL4hPjo3BPSKf/xJ/D7KY2S9LkCmyRt/
	 SvzOeE1P1KI9H64BBfl8cZbFog+i6RibjKBFahPoyC59UbREpfD5NpKtrkXqLJ9wVEG3L
	 2gdqSM+1naiiRFHhEti3Ro7X9Ja7gwVNhgDYAQf2OsbLt2PEb+49epY3G0Nx2rZqyP3C0
	 oG3U9cyxZQSQi0YxrKenKq3q5IJULkHsqoK3z51ynBqp/KpypjJlZWsH91rhJmjy0eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422909;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=72c6ya/WmW0BKmhndWVtOK2+men8R0vbNXmriqzRppU=;
	b=Fc/Wro5ZKUwSy3bNW1t8fU5xwPgrZqdb0JCFc2ZhhUOVDaUpRrLnyxM4KCea1Ley0qA/
	 MWmYRDWVNx0vKTD77pSbDenI4tOcyrsY0bfRokzp7s45yZH8+qx1I9hj/2paTI6lbsYCn
	 xSNY40gGyLuGvaAEhzzshvebnXfBGYUpP+v9minD/PFRPDFbNpS82PDSZtSTNFlzT8fMc
	 luIAHqobkv1umH/mx66Y+pvW7waJS4ePIye4PsXawnHhL/PeRE6zQ8ZWESkwSoFqI+pnB
	 78f65dXOInzo8lMJ0gMNI0QE9ITF8adq56AL8jpe3OzDbMXfCZUxZNoSQ+2uVQX26sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nBmZ60LJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05000609DCD2
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 15:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nBmZ60LJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8CBC1F000C4;
	Mon, 19 Oct 2026 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792422908;
	bh=72c6ya/WmW0BKmhndWVtOK2+men8R0vbNXmriqzRppU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nBmZ60LJB41Ua/KbgRMSZgroHOxmz3DffnlfIbtI8vYYU4RpMhWue4/CPMe9dXrii
	 sqNGhWGrCf/tgqJHbgYCsVW5K7Z6wfPLmk+0DL2SsqT2J6fFGdbRJKXWXuwpfhpdQc
	 B+kBc8i8i8A2I4W64m8k0VRS/MRGrOs+FAkT7tpb/F+Grm2Z8hEUW8x9+Du0PjCm/t
	 QNzZB4tOS6xaeUPIMTAXFBBS+KuoGUIdReSCKF9PZzFMOoseM39oH1R3+fDgZCsYgJ
	 yZWNs1dsuavRhYpfm5L9Q9lguQCPyI4fQq2fuKf2vxkmpoDtMCRLnu9X1DpPIy5G2U
	 SVseoycxIHseg==
Message-ID: <sashiko-outbox-177660@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] net/rds: hold the socket while an
 rds_mr references it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019135441.1420968-432-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-432-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 15:15:08 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: H=C3=A5kon Bugge <haakon.bugge@oracle.com>
>=20
> [ Upstream commit 9079adef042c1e7a6141dcdfd3041acd30607297 ]
>=20
> Each rds_mr stores a bare back pointer to the socket that created it
> (mr->r_sock) but takes no reference on it.  When the mr is destroyed it
> references the rs. Hence, provisions must be made to avoid the rs
> being destroyed before all mrs referencing it have been destroyed.
>=20
> The MR itself is refcounted, and in-flight messages legitimately hold
> MR krefs that can outlive the socket: rds_release() drops the rb-tree
> references via rds_rdma_drop_keys(), but a send completion arriving
> afterwards drops the final message reference from the CQ handler and
> ends up in
>=20
> [ ... ]
>  __rds_put_mr_final(); update commit message]
> Signed-off-by: Allison Henderson <achender@kernel.org>
> Link: https://patch.msgid.link/20260730041629.3512480-3-achender@kernel.o=
rg
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-432-sashal@kernel.org?part=3D1

