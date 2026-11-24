Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795511526;
	b=zXspGsbU5g4ZhjHuWIIeGrHpjE7NlrPQP3qB/VwU1yFXR2mNLvT0OUy+OQGdnaJxlkmV
	 VTqIviorS8Uac9ctHKv6LJegP+0XnWfYYrjBeKWkmLzhKFJjD4KJopQsNH45xkC6T8FOD
	 IAOpNZcp6Kk7azyfWf1l2wGy7SI9hwyaFaJ/wqQwOAOda64dXyucEpmNs86w/0MpSCUG5
	 zxdeMVCgfFs3td52KRwmkUgdmi8W7yWLH+ttS4/K21ra6zVz3+hFxQyDjfyFPwB3KKSwu
	 Qwnq5MSEh+ZXLRN12TktKk7csaLhpWyhOMRnCw9B8hi6Ds/z988SAA8RffgWiE++elA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795511526;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ztF+ZDTVdmmesfJjnVqmTmiShymi0cVqTWmYe7/SQvA=;
	b=qQ7AaHx2Z5TTCgdUc0ktTOFLqQQWMtrO7jW8eA2oGi/hCF6GUrzvvYWk6abtAVwtGtil
	 apBRTuOMII//e2I9rkOS49G4GCtw/m1cJPL+hOBRZV62rg8SgwDW7NRZhxEyv3wg51UOO
	 zS7N5GMDXuXEptH3FkKrTK/QtbU8ix+JEY8PK36CjnOYCBBeHbtQNwQ9KW4nnW1+8f/IN
	 qknKyFtAx833FY2jFkNrgtcHEIiAExaJdqeJX4DFWjLvz5/tobD4kRNIw6Qu+eVIZF5Oo
	 Oh8DqnubhuL1ozIvlTlFTpepWWHe6ptKCk6DJRuDg7WhSdaz5BkkIw3SRlQdOIu2nGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OyPxtb2m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA35606A31E
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 09:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OyPxtb2m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A3A1F000CA;
	Tue, 24 Nov 2026 09:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795511525;
	bh=ztF+ZDTVdmmesfJjnVqmTmiShymi0cVqTWmYe7/SQvA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OyPxtb2mHpvhQ8G0sxJm2YwWqRREbnU9dOTmm65tgaH/G2BFWkJGDeDwyRQfABczy
	 w2ZsL54l7vFHdQF1fQuc/cNa8dxsbfEWtCDF1963s5WhXWiL+ND7gast0qlyCc+//K
	 Aa+kN5gQpawrvM90nGPEOwdr95P6VkbGeGv52S3utn1D3RtoY4OKA30qufPOn/4wel
	 ysXF4STFw9sske9Gqro3xnS/5rwn4SKJm5nvVuRILsk+nRWWgw7JD3bs9vDgjijzu5
	 s0sWGybQRIETAcb4IFfeUEqjeUpIqZKpyzKOYDEGkdOeajOzhYf7VNC4jl473eYj78
	 WAEnodb4PbLYg==
Message-ID: <sashiko-outbox-230793@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] IB/iser: Fix blocking connect hang and endpoint
 double free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ziyu Zhang" <ziyuzhang201@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261124090121.77115-1-ziyuzhang201@gmail.com>
References: <20261124090121.77115-1-ziyuzhang201@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 09:12:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> iser_connect() waits for up_completion while holding
> iser_conn->state_mutex.  The RDMA CM callback that advances the
> connection state machine needs the same mutex, so a blocking connect
> can never finish establishing and the wait only returns when a signal
> arrives.  The caller then sits there with rx_queue_mutex held, which
> stalls the iscsi netlink path for the whole daemon.
>=20
> Dropping the mutex around the wait is not enough on its own:
> up_completion is only completed on RDMA_CM_EVENT_ESTABLISHED, so an
> address, route, connect or reject error still leaves the waiter asleep
> forever; complete it from iser_connect_error() as well.  The cleanup
> events are the other way an attempt can end without an establishment:
> DISCONNECTED, ADDR_CHANGE, TIMEWAIT_EXIT and DEVICE_REMOVAL reach
> iser_cleanup_handler() with the connection still ISER_CONN_PENDING,
> where iser_conn_terminate() does nothing because it only acts on an
> [ ... ]
>=20
> Fixes: 504130c039f9 ("IB/iser: Protect iser state machine with a mutex")
> Fixes: 9a3119e4b787 ("IB/iser: Release the iscsi endpoint if ep_disconnec=
t wasn't called")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ziyu Zhang <ziyuzhang201@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124090121.7711=
5-1-ziyuzhang201@gmail.com?part=3D1
