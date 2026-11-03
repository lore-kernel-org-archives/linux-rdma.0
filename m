Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793747679;
	b=XokbzOIQhcDHMSxEPTm+4fkrDB7PFWZCj4L3TMrzINkzS/aTEhGHka4EWg26vewE5Ogh
	 bfxrl3N3bSF1wBx68/4B+z6tp1UOWk8jvMZbz6i0av6b/7C3CANcZC5DG0nOV7PyWVhXA
	 y5hGzdNXRjlX62Mk7TTOkMEu3H5+HJDPx6p5JJqsc2/zdRKvdljVNrnTUVBF+Z9yqO756
	 9gPXq7Ei3pSHX7gBhhMCxaD5VqsZPx8x1rnS5WlIqALzgaBb1Yyf2e/1xvmpbI7jymY+1
	 7zwuL6NNYfxL/K26sMHPcGz0TNM5KsFja0wcCNnL7TrOFNbv3T8FzItuAdas2Tfg2MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793747679;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BoijAHkLC379np6ikpHDhLJdgFKiiqh9vbrh0b1PodU=;
	b=xSNdU5Pxhuf5DhJWbNAOGk0Ydqf3+p91iEp3vIHZxqxXqL8z97Sh1z/2bvCXK5SbmGkX
	 w+b5NTowIuoTAyFcufQv8ijHXf857T3o/KONsWatsAMiI8kJbdfI7+BLc+TPnuLzl6On2
	 sHzB1mOxOKxY/b4kThbHgzQdpTq0N1nNDMl6ks0RZI1mjQZm57ls8soOprKLLWUmKP/UO
	 27L9yrCugYC5dLDn7vZ6FIxu8U6U+o5YrR40dB4KlMZ4lKDehTP/LMz+0MTBTVsDP0mEu
	 5h6R3EsgYTr2EBaXSwW5TNJmscz/ZZALG9Js5dqlN+pc9bVGcMq2GHyNq7ItzO+ne1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SLa1NUYX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820E3606A31B
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 23:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SLa1NUYX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A661F000C1;
	Tue,  3 Nov 2026 23:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793747679;
	bh=BoijAHkLC379np6ikpHDhLJdgFKiiqh9vbrh0b1PodU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SLa1NUYXkQXpH7QaUHWYtGu5+ZTLezPXRWQIuOKO/Rs37IE+vDOIMEfwRva9pcmbD
	 XpxITQ9TidGQSZVUabZaOBg23Xyt8hi6DfOr95qIxWS4zwsUcDy5vr9hf6SLUd52wG
	 U38qAKDWTEfJuvsdYjMlR6WSpjcQ9indzpxYmheegKN2pqrhUWNgZDJvUGmAqrKuSb
	 skEdJK0PVc/QqbhuGnObxGvFaAoj4dtvPz9vGYs8ex/ZcraT/ElN3l4V1pcWOEo0Hw
	 8vi532YCJjOjd+fSsEjjy9SRgljABTiNDXvvw3xS6MMWUgx3dpEYMbNMNe9j40aeYi
	 eeMJQ5Dw8h0Lw==
Message-ID: <sashiko-outbox-196187@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 6/6] IB/isert: only reinstate a connection that
 reached full feature phase
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103223802.1697607-7-yhlee@isslab.korea.ac.kr>
References: <20261103223802.1697607-1-yhlee@isslab.korea.ac.kr>
 <20261103223802.1697607-7-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 23:14:38 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> isert_teardown_conn() and isert_connect_error() ask iscsi to reinstate the
> connection whenever it is bound, ISER_CONN_BOUND included.  A connection
> stays BOUND from isert_accept_np() until isert_get_rx_pdu(); during the
> final login response the rx thread is already running but still waits for
> its login completion.  iscsit_cause_connection_reinstatement() sends it
> SIGINT, that wait fails, and iscsi_target_rx_thread() returns without the
> connection exit path, so isert_remove_one() waits for ever.
>=20
> Ask for reinstatement only from ISER_CONN_FULL_FEATURE, read under
> isert_conn->mutex.  There the rx thread is inside isert_get_rx_pdu() and
> returns to the exit path, so the signal still helps.  In BOUND terminating
> is enough: if the login completes, isert_get_rx_pdu() sees
> ISER_CONN_TERMINATING and returns; if it fails,
> iscsi_target_login_sess_out() calls isert_wait_conn() and
> isert_free_conn().
> [ ... ]
>    </TASK>
>=20
> Fixes: 6d1fba0c2cc7 ("iser-target: Rework connection termination")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103223802.1697=
607-1-yhlee@isslab.korea.ac.kr?part=3D6

