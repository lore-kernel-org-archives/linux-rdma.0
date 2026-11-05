Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793853253;
	b=Jj2/n3PrpnN7CvTbW9PL9eKD6BOEi5OHXJuMiIE40pRHMdDtO2qTzAPIgnX0nRAbHTcg
	 qrMiwUIlkCm7xSGS9gkeVHLPwlUPjdeuUQhlPGgYb2xYhjHYbRFqbHEXyI5HuWLLCH/QS
	 cNRzsJUOtUTEd9TLbUWuCHj+9nOpAyW9Aq9a/t6UI7AYpywEDrd6PyuEpLvjFVS3lYmQJ
	 r6giKUFFaFd6hBBNpCL+VY72wiC3VPqdx1kx/iaHS3sQ82T7cCm1OAstWZ6tnQIk6AkQU
	 4bEULhA5MrheHSuO5eXWiflvEgphVuwr8khvKsVdmXFdmdb1piRJtsibpicdlK+jYZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793853253;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hIfjFtcwKTpJ+j+he32BqIsROLqaYx+LKaz68gZPBGM=;
	b=BcNcCLpG1z2PNhKT/m6wHFMwlgpMDUwUnPLAzg+I/GzxbcoEGOI/OU1+GqR3ysxC6/9e
	 LIaR/k9l/S6YkGNU9UJuqnJuCGFk49LEiFulpwSUEtx5jlZmayATG7u1ztQKMDgpRJpzT
	 RsG2fXJxhck+wB24Oor8199vGdk8s3wRGqvtArH5jWLrsTU5Sp5Mv3kxvi49YvpSYuUeJ
	 ajyJ058bZtl/RUdkd9hcNwsGsuOo4EWKrnFMB9ciZ82vpCpO857Dr885F+bnppOFRW2yj
	 9Apfpj6DYTTnkCFLu3qZ+TzKt/8U6vlEW1STjyTnu5qxhmQKcmbV8Ce9p9X7uycdzTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NWO9Awyx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5746606A31B
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 04:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NWO9Awyx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812BE1F000C1;
	Thu,  5 Nov 2026 04:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793853252;
	bh=hIfjFtcwKTpJ+j+he32BqIsROLqaYx+LKaz68gZPBGM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NWO9AwyxvdHLMNQPpA56wxVBXZU/Doqt5Tdykr8Y2CBGoXAYhd9tWU5dKcMn9clyZ
	 5CJL0JjfUdr+pURYkEjFcf6BtV5hRyIswS/YdK3+4tJlmIB1whaBE5tVzdz4p2prms
	 cr58ksyFOSAhB2X/KBmL0W3pZm+TfjtwKw64XaM5wupVS+pjzAMrmFW8j1Uh484pQk
	 Q+IrIwix874wJr4Pi0C0Fsz+jOTLALfGgS+blIIMI7J0I5+d5g8Uyt4IUQ9gc6KmiA
	 Oha0sDddgpEwiiyIaWOGSxp2RZKxh+t2guQYIaGqiio9bCYWX+i6uKuOD3+NtRFk7c
	 fZlvtaafarwpw==
Message-ID: <sashiko-outbox-198553@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/ipoib: cancel the AH reaper synchronously on
 teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengyu Liu" <lui2012qwq@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261105042922.14733-1-lui2012qwq@gmail.com>
References: <20261105042922.14733-1-lui2012qwq@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 04:34:12 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> ipoib_stop_ah_reaper() uses cancel_delayed_work(), which cannot stop a
> callback that is already running.  ipoib_reap_ah() re-arms itself after
> an unlocked test_bit(IPOIB_STOP_REAPER) check, so a callback that has
> passed the check but has not re-armed yet still queues the delayed work
> after the "stop":
>=20
>   CPU0 (reaper)                     CPU1 (stop/teardown)
>   test_bit(STOP_REAPER) =3D=3D 0
>                                     set_bit(STOP_REAPER)
>                                     cancel_delayed_work()  (no-op)
>                                     ... destroy_workqueue(priv->wq)
>   queue_delayed_work(priv->wq, ...)  <- delayed work sits on the timer
>=20
> destroy_workqueue() cannot see a delayed work that is pending on the
> timer wheel, so the re-armed work fires after the workqueue is
> [ ... ]
> escapes the stop and re-arms, the timer fires one second later in
> __run_timer_base() on the destroyed workqueue (slab-use-after-free).
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Chengyu Liu <lui2012qwq@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105042922.1473=
3-1-lui2012qwq@gmail.com?part=3D1

