Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711796;
	b=QP0IlepV0nsixpA1tReD1Lael8wnEQyW7J29Ld06m4B9V/D8F5Dkiw5dnOP+gRWII422
	 xs4KNUULW5dx5L2Ye47klOIaZiJv9ZvUM9fVqieB9PxuLNjLcjIw+7N5BffefB38TheI4
	 Swmmdrcxp1Edu3GNc4VT306x/NtsKfXlAqTXxE8rk8/MryWFfG4mRQmWPQ9UZM58baUXC
	 a12QOtVzKFANYAlgaG79G2QhGuvZ8KC/pqOm1q3AOhHERsNnvEEpf15i6ULG7aVp2Z/1F
	 ZPK84BCzAsxkqq3jdAlFv7jgQ8J6x0KlWWXU5nLg0qO7EMB5AFB/CVxcqYCqgRIK1VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711796;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=dTiwvmprFl1OIhLO+lalmrNsjsd1j0Pswdszbz2lzSU=;
	b=2TakAOeFuUFqiT2nitOVls7rcGkyk3yOLKLOtQiTRmysv7b9COHB+uhWhBEuhJLIv5Pk
	 W2Sfvr7JdrjW+f/wlhGfVMmJ0iI2KFlK5BImxxXHyvFasYX2ZZw7JsoBJdLSmfMcK674s
	 OLqjax9blb0k8hpWbamG2RYDLWU1YGDadF4Hz/FKbevn4KmbhCxUYjF/E8HQLLoiitMac
	 dzk1+7180XcUH2oiAncz4z4g8x6rNGhbBYHlB7+QiMOmsqq4Js4kNhuuURFI87q3TiR9H
	 HRqpo2ayjJVGlTrNf9BZBiIOLbhBDZX0HzLD76OXHRIGKNQWA5nEvg+VvzBS7ctHSOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l8pZtMHA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5D2606A328
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l8pZtMHA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229561F00A02;
	Tue,  3 Nov 2026 13:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711796;
	bh=dTiwvmprFl1OIhLO+lalmrNsjsd1j0Pswdszbz2lzSU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l8pZtMHAvBJJV/nR6rbukpYURvBPRdIfyBLwCA2epgnNVK6JhzZmQ72xZ4ArZn0XK
	 1M0mAZHah0rfswmdbvxKOT//ARx53CEr9jsCZP9YjOTHgkzr6eP9JZh2y7hJAOyV6z
	 8dhvFOg/48gVqsS8OW1TqrxG2GhvBpCmAmWcC06eCm1IcQE+xIawI9LVYfjzKlfj/B
	 D0DugFwkvH1rsUo427k4oDUrNg5BHUhaol8YQ9hNwwPPPDdikw1Zq93rhhix1iK2cD
	 pW6aKAW4REJwp+RpvYNsI3yK6yBn/cwhyBJM0/OGzOodCP7yvxVLoFFd5i/MBEw3fI
	 UiqDOUnNxzHGA==
Message-ID: <sashiko-outbox-195317@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 4/5] IB/isert: drop the promotion reference when a
 connection errors out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103125955.1530355-5-yhlee@isslab.korea.ac.kr>
References: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
 <20261103125955.1530355-5-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:16:35 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> isert_connected_handler() takes a reference when it moves a connection to
> ISER_CONN_UP, and the paths that give a promoted connection up drop it
> again.  isert_connect_error() does not: it drops one reference for any
> state.  A promoted connection that then gets an error event keeps one
> reference for ever, so isert_connect_release() never runs and the
> isert_device reference it holds is never returned.  isert_remove_one()
> waits for that in wait_for_completion(&removal_comp).
>=20
> A REJ after the RTU reaches this path.  cm_rej_handler() accepts
> IB_CM_ESTABLISHED while lap_state is IB_CM_LAP_UNINIT, and a passive id
> stays in RDMA_CM_CONNECT after ESTABLISHED, so cma_ib_handler() passes the
> event on as RDMA_CM_EVENT_REJECTED.
>=20
> Drop the promotion reference too when the connection being given up was
> promoted.  A test-only knob delivered that event to eight promoted
> [ ... ]
>    </TASK>
>=20
> Fixes: 954f23722b57 ("iscsi,iser-target: Initiate termination only once")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103125955.1530=
355-1-yhlee@isslab.korea.ac.kr?part=3D4

