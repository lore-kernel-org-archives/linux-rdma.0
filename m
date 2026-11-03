Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793726001;
	b=zde80WC7Qz9MGysvRDwqAdgeRRMusTEJ8s/+QBdzkepmIYGWhKCXzPakzi2CKY/qRJqa
	 xqf2p/y4xbvgYAHw6kfbJZCkjcNHXFQz+T5bdrbEjgVlwVV83+qbLNLKYjFM+0r+KgUse
	 VUJxG9Uan9UCcVLPA3PWeG51fXpTa5nsF0wjX7ep/j4vpD1PrdrhQfMV/qSSJ1lf0DUWB
	 RoIa84f4fVloXyuERlBE2QxKx//wNjvw7G9a8bueZsyomsyod56DTomy6QfL+2ipC8MAz
	 seTIrn4//ydAylKcDOX2qD4kVwneKbCTWUba97da5pwJDMGWAEr6hz1K6OBrNPupVgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793726001;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=XGahh9LKQSxFZ7LuxgMQZ7w7FnBXKhyeqWtawQJw9sA=;
	b=tjVvvOYa5DgD2N68s5aYULmNxE+xQ3iuNf3zGdQBGT0hT52oefKnGPtOML1ktWKKfHbe
	 7zt6ZrwoCoSoR5R6Lxv2UxsrIT4yTfxoJS6Xox+Jkejy0Hq8kVkY0Ced2GTXRLomJFybU
	 Z76eZrKRN9R7FfE9ebPgX7A5Nqx4Fi0eTQDH+jnx3D06JjwTIIBcbfR+r/8fSUU0Yl+S1
	 PFGXlvK6S89fF4EE2tCTZgAV8jKxg0djeMEW66bANC0MRV09rEIRWs2kHHSDExq0qmf/V
	 sZ7LaZUOI/I//u4XScc48P65na55PnnT4aft/o+vTUEjG7NkKIJayyzRfJ47tNc5sYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YCDYPwJg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29379606EEA0
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 17:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YCDYPwJg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FE31F00A16;
	Tue,  3 Nov 2026 17:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793726000;
	bh=XGahh9LKQSxFZ7LuxgMQZ7w7FnBXKhyeqWtawQJw9sA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YCDYPwJgnu5S6u+ldRqUeOOKdvp9Ct7R3lmAN2Yklv1r7vMcpR1ixRLo5ISyVSpZ7
	 RRnuh4+hP1o2f/KvoHv40LqOAwg6Am2io6QZdnQth4PYdX0NKrbvgmhbWcLvLu9cSL
	 SQYEUA0YEKdC/wvqCAxgEaosrL2kTZjAC/SZewDtavSosZXlVRqn7EpiTUoZt/0o7+
	 VSQfd+4IkDzJDwsZ6VBavvXeAvIgw4NPQZ0iStYUOmzz0/WsmXlbwFjKNwWmxJe6VP
	 D0oNtjKBUljzOPqJGm+57tPYq4KoiZgwuovNc68d+mNvskSbluF/LxEMeNOTxhEE2D
	 wc1Gc+gQA/gzQ==
Message-ID: <sashiko-outbox-195777@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/ipoib: cancel the AH reaper work synchronously
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengyu Liu" <lui2012qwq@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103170703.1600310-1-lui2012qwq@gmail.com>
References: <20261103170703.1600310-1-lui2012qwq@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 17:13:20 +0000
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
> with a small module exercising this exact guard/cancel/free pattern
> (no Infiniband hardware available); PoC and splat are below.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Chengyu Liu <lui2012qwq@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103170703.1600=
310-1-lui2012qwq@gmail.com?part=3D1

