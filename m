Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022029;
	b=UPdVxoo1urQL5DCiuWOPrH49z8IBLpN4MZAjN+C859lVYQ+gXphjMXHncuGLfNlSMVr7
	 C7X2TjRdyZB6w4QrYOt+9RJ899f7YcvUuNezj2AVHFfyEhaAhdHrR3aDCrcH6zSlr7KcZ
	 zUPBM5FMFzNQ9RwyLxenbSdUa4pl/XNoKL0wqB03wAJn7II/QKHJkJFai4rtZhHChQzJJ
	 php9W0Y1cMZCJKe5XhJn33wPFP8APxQ6hSKutBxdxgLSnyF3IMa980U4Tnl1NCXZADmOz
	 ev83pgw1R9p6qscvUdiy+kVVoP/RLf5sZVZhG41CSxT5EBChmO0DGtV8lsUITvEh+1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022029;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=D3c+w8SxM/1vbeLAJwsUcshhtHAnvjDB9/vrTV5PKJQ=;
	b=kkOx1Rhy1sdLHqGZ85xasmG8GTDW8JqZJOVbFJOTTOXD6ZuKnrFaL9etzAp0OGErvQz4
	 bCgnMaeCvYZLiOBgw9jfl+126pu7F0jJo0ddlTedW1lYKoVe0+aY6xVxDnIAvGcZKBPF+
	 H3hAg0m7CAPNCI0ch8BTjJ4UpJzyO69j16z868Jj8WLwgdP/eiMjH8AhXlNv2/Fj38smn
	 f8Rlyu6ljpkWBpU0LETbuywWZ3itScg8rUU6XDBOaWX2Wy14tq1QDGNCuVRX0lUPXwk0t
	 e1U1aRabuSXD7a6+U7ARrgK2KNDhbpDH8s3PDQXg1waGsiKyQPBrFe78SDok+TUQPPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=npubcRGu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDCD606A33F
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=npubcRGu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3C91F000C5;
	Wed, 18 Nov 2026 17:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795022029;
	bh=D3c+w8SxM/1vbeLAJwsUcshhtHAnvjDB9/vrTV5PKJQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=npubcRGuRQ2qqppx7vTA2RGk5/cvP7a3DJQWmDFqkNkwnbU1q+LnLMQH70ePrz+5O
	 9VMDDzphR9N7q4tKZTl9Y03R0V6Ss6nAJcjdrB10QJaN3KGTKeKcDTqIhJeOTIIs/P
	 mHaK3pu7xYP19LNfuk35h4LHAnqPl5C0M3XtgTVf7MStIXU3BqqQsL4lnjlt5uC41y
	 BVdA3U/uAgzgeaIElYbmzKRqOpp9Yt1UbJmIGNiwRPWdTnGP0G1qANmswtoC+P49yt
	 KMrKs49ZFWRINXSJJvk/0ngBX/I4pp+g+1Fpj2BTq9BrMp8LJht+2+9dBgDna58jql
	 TWoUc8boX1ocQ==
Message-ID: <sashiko-outbox-221614@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V2 rdma-next 13/21] RDMA/mlx5: Keep the UMR QP failed
 once a forged CQE is detected
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261117170914.27410-14-yishaih@nvidia.com>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-14-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 17:13:48 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> In adversarial mode MLX5_UMR_STATE_ERR is a final state: the poller sets
> it when it rejects a forged CQE, after which hardware polling is stopped,
> and it stops mlx5r_umr_post_send_wait() from posting again.
>=20
> mlx5r_umr_recover() runs concurrently with that and moves the state with
> plain stores: it enters RECOVER from whatever state the path is in and
> ends with an unconditional ACTIVE. An ERR set while a recovery is in
> flight is therefore overwritten, which opens the UMR path again for a
> NIC that was just caught lying, with its poller already stopped.
>=20
> In adversarial mode move the state with cmpxchg() in recovery, ACTIVE to
> RECOVER on entry and RECOVER to ACTIVE at the end. If ERR was set in the
> meantime the transition leaves it in place and recovery returns
> -EFAULT. Outside adversarial mode the transitions are unchanged.
>=20
> This keeps new UMRs away from the NIC until the forced health recovery
> moves the device to MLX5_DEVICE_STATE_INTERNAL_ERROR, after which posts
> fail with -EIO anyway.
>=20
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117170914.2741=
0-1-yishaih@nvidia.com?part=3D13

