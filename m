Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795593024;
	b=Sm4bAR7wB9NKNlkdYM1Uk+2SveSD2a++48R48BRvf2mGqzuhbxnUQ/QqvaTlQseCuZzT
	 aravbeazDwwLzUtUL/oF7QUyIZcwYD843zcqmCwvytvzayCnBkRlLQy/osPy8Q+H52Q2S
	 tdEW9tNiaMSm6ueuNPdSa9p4wBx5Yxis+vdotqyT+K874sLj1+kt7LH6Azmj23hni6ofB
	 Wz6jITmrNAmNI+/Bl5VcuiqJCZ+Td+fzuJd6WSQC4n1Uq+JiqPxb32Wgf77Z3kofUrxX5
	 9jDrLdN8W8zoxqPHZxbUzPlsfW8RXZuhKryFRIVcGXjf3omOOvfiTolApc26JmoEyzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795593024;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/cU/P9Tc//w/3ZbHSHLGUp64zHa7crcQPtXGNo+e+dc=;
	b=kyrYCigXLbLrznTv0Xw0P9eo6Ngaey/0iBD4fTtdvDXvkJITVwTVrNOlHYHYqAV0gmia
	 AiW0+r14GSKT2N3xAvhi0GkRbp7774c1MwUQt6D7CWGCZHuGxkYCWYt3dMDuSbuhqyH2b
	 QzThPRMcwWwEVW0mEG/McywosXy1muSBhU0dyO6GlNCeibfw3CDbiotr6/yS4F440KbBu
	 H+jpaeNOGaUZ7z6Aay9z4vK00BHq499znfNha4ZxRZFtmYz35gqJoGUY3ZFoipaolbLBU
	 PqOJdidZHQA6lstRe7I6Kf/bhegCbRoufODQClEQtID7Mon/bHABZnrEnM8kvbnKNLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KkySALfH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F01C606A31E;
	Wed, 25 Nov 2026 07:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KkySALfH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AEF1F000C0;
	Wed, 25 Nov 2026 07:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795593023;
	bh=/cU/P9Tc//w/3ZbHSHLGUp64zHa7crcQPtXGNo+e+dc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KkySALfHy+e+RTJI2ud+42xsH1+N7aah+UeJeeDmRRuE0Bvb+2NiG9lHpBeVLeLro
	 WZu8KJ0pgn9K9M6xYqruE3PE88Her6kRLqKoYeA5AZXTyeKLj7sxi7KJOPIaw7rz4k
	 9xT5Q7CvjFxRqjYE8w3q/lxiFocDrRypOIm5DrukFy0vgkzvQIk2tz7Kab0lGhE2Cf
	 XTKvfCdFTSXVK3d06tWjw4FBAjUtTPcagof/mDb3/cA0NgizAinpbAE6Z9UxVRC/8Y
	 4+QQ6z/QVcOU/kPF2W2KFA09ymd5aGPnDRc47EWqCkEzTibJs4LPvVfRFlxkRYJj1w
	 FW4Ot1MXHWaAQ==
Message-ID: <sashiko-outbox-232834@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 1/3] net/smc: keep clcsock until socket
 release
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mahanta Jambigi" <mjambigi@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261124074927.3622245-2-mjambigi@linux.ibm.com>
References: <20261124074927.3622245-1-mjambigi@linux.ibm.com>
 <20261124074927.3622245-2-mjambigi@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 07:50:22 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] net/smc: missing Fixes trailers for clcsock asynchronous release
  fix
--

commit ff1c66913cdc1e51d673fa46e01a60e2f0984410
Author: Mahanta Jambigi <mjambigi@linux.ibm.com>

> net/smc: keep clcsock until socket release
>
> The clcsock of an SMC socket can be freed from asynchronous contexts:
> link group termination reaches smc_close_active_abort() and peer close
> reaches smc_close_passive_work(), and both can run while the socket is
> referenced by an open file. A task that uses the fd then operates on a
> released socket; this was found by code inspection, not from a reported
> regression.
>
> Free the clcsock only when no socket file can reference it: from the
> release paths, and from the abnormal close paths only once the socket
> has no file left. __smc_release() now tears the connection down before
> releasing the clcsock, which is safe because smc_conn_kill() and
> smc_close_passive_work() return early once conn->freed is set, so a
> clcsock can stay allocated until the application closes the socket.
>
> Signed-off-by: Mahanta Jambigi <mjambigi@linux.ibm.com>

[Severity: Low]
This fixes premature clcsock release while a socket file is still open,
introduced in __smc_release() and smc_close_passive_work() by
b03faa1fafc8 ("net/smc: postpone release of clcsock") and in
smc_close_active_abort() by 81cf4f4707af ("net/smc: remove close abort
worker") and 42bfba9eaa33 ("net/smc: immediate termination for SMCD link
groups").  Should the commit message include these Fixes: tags?

  Fixes: b03faa1fafc8 ("net/smc: postpone release of clcsock")
  Fixes: 81cf4f4707af ("net/smc: remove close abort worker")
  Fixes: 42bfba9eaa33 ("net/smc: immediate termination for SMCD link groups=
")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124074927.3622=
245-1-mjambigi@linux.ibm.com?part=3D1
