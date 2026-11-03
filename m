Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793747234;
	b=sRcl9Y95oe1mASLJOBJo1/9ciQB7eqdXf+XRARkLfAKShLkXRYVcgbYOJrgcmfEMooGD
	 VzSynCqXtbvkTmQKqi9IZa1jpXC5PhSxSuq7LhfAm4XvKmkZXo+FK8hDkXZyLbynJY30K
	 88B7dKia5ubomINr/VqOAq3qIJxkUt1Z6/Ks76vMWoVSRkYjq/N6bFkQYthala9syU5rp
	 vIPVzse1s8bvzF5SNXR85pkXwmx0Th1MMfkQGEkxmWHbOPdZWqVro6Msan2UH35Z/J9GL
	 egJcddqonmqW0y7lQ55v7BJa8KgLrYWqXSNcXYS/Ni8ziywqzzw6lGxtacr8U+pSl4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793747234;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jMIZcj8M4LvD3AJcnLEFxjwlIryN9sFDihBPSrSe7uA=;
	b=ueCrXRgg3DjNiFbZ7k/SBLXxL3/ZhW/FPY07raxHmjGP7s5rXK8FUdg8mU/a3ljTGPbv
	 K8k3Emt1HYIi5G5IoIBRoiZ2VgYEP8Ww52aU1akbrepmWS/dzUQZYQrhTF2Gx8Y/DJQkJ
	 WP5QS171zx5+4HyNUmhwmWL+DZtydnmUGm+Qk+3NO+x0ura7nsvuPRtedEwyxjAXWho25
	 CSgWASVGj796h3xIq49JszoXbqu4iAmeVkj1loLUBUARzkdZu1UCOSS2DCnNz/EewnA+t
	 jmi0ckaF04JLNvvj04nRpTmi5DurSJZbs4rfmbA89Ji2z5CJ0ZIFBR1LnXCwvNm0ASw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kbLX64jA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A046606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 23:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kbLX64jA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978FD1F000C1;
	Tue,  3 Nov 2026 23:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793747233;
	bh=jMIZcj8M4LvD3AJcnLEFxjwlIryN9sFDihBPSrSe7uA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kbLX64jA7ZWHOvEpUh1RCIuer3RU4uecpEKHxCh/mx1Bhfrv1yAZlsdS1Tl5OWhnH
	 CDgYouvf6o5To9/w5bzOY4roOuGmWWOeq13pfjw5LdE4T0a4XNxGYhlt0ztLKzh1U9
	 MM7BBPJOl7OhxzuGXgKznvoM1Ujd9ty7KFqn/rHXMfsx2+YlVPWC/eKk8/3IOSJQ2n
	 9FwWUYGmLPWQXE0pf8Cdy/DHX833KR/v51L5H++nQrxYkP1ZHZztQ2jkVHFszvqqMu
	 oAVWRqsFOWGa7uzzy7VAX5Gpj/oielLU2/J0fYfYkH+Uz6ZDlZiJnyJuh2DZI6q2v8
	 0/tpp2Qgs/zug==
Message-ID: <sashiko-outbox-196179@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 3/6] IB/isert: tear connections down from an
 ib_client on device removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103223802.1697607-4-yhlee@isslab.korea.ac.kr>
References: <20261103223802.1697607-1-yhlee@isslab.korea.ac.kr>
 <20261103223802.1697607-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 23:07:13 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The RDMA_CM_EVENT_DEVICE_REMOVAL callback waits for the connection it was
> handed to reach ISER_CONN_DOWN and then frees it.  isert_release_work()
> publishes that state before it drops its reference, so the handler can fr=
ee
> a connection that isert_connect_release() is still running on.  The wait
> itself deadlocks against the handler_mutex rdma_destroy_id() needs.
>=20
> Register an ib_client instead, as nvmet-rdma did in commit f1d4ef7d8883
> ("nvmet-rdma: register ib_client to not deadlock in device removal"), and
> tear the device's connections down from its remove callback.  It walks
> isert_conn_list under isert_conn_mutex, takes a reference with
> kref_get_unless_zero(), tears each one down after dropping the lock, and
> asks iscsi to reinstate the session.  isert_device_put() completes
> removal_comp once the CQs and the PD are gone.  Publishing now happens in
> the same isert_conn_mutex section that tests isert_device->removing, and
> isert_np is reference counted because a connection can outlive its portal.
> [ ... ]
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>=20
> Fixes: 63b268d232b8 ("IB/isert: Properly release resources on DEVICE_REMO=
VAL")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103223802.1697=
607-1-yhlee@isslab.korea.ac.kr?part=3D3

