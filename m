Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793746833;
	b=amk4BXAYmFuU1wJuRvKZkXwj10GPy2PAah0TBQ5BFwAXU37b3zVQZAv4ZBxZTPDn4i7d
	 vq6sFwT78dvvIgAs0Qo9I1eCv33ujZ3vOHcpYNheBfbUrme2s6PL803uIvbYaOUixGLpE
	 FYE74RW2vjXEPbyiIqQd/yzJPIEI9nmd2UZpDzExt37V8YOifG+VA7KvUIyAxlxd6SjFh
	 kfa0lGWkS0rJGG2R5uOuMsnQDnktwhFSZruHgr8u24qM/tTkPq1drth887vn+ED8BfPOM
	 43ivD/5iSRrNFPNlOmpQKJ6+3NFu+l3Eyn/LM+jYXtwiGiOlbU4/jtETGdN0yFIbW1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793746833;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CeDjFYJ7/qwDQz23QRooYEcqmXtSXuujByMCp6KjiUY=;
	b=Eiwm4ryLwtgo5VJG10bAxZtE7QWk6p0y7pF6CPd4oiB23gZgq+aW0KONKp/XW9bNn5LU
	 cEK3gjr8T4fgM46r+OO8+T0/kSInjE8KG/rFT9VbPJirlp6qJrDV0EaxdFLhzuxJk/erb
	 /Owzjb6bdDrkNPkD4BHvtwXK42MglkUmuCAJX4kNhGpHZi2nhPKrermTdaIQAoiczdf1Y
	 gDISRVMZ9koZgmc80tYU8FrIO+9i2Rd+x/8UO8pvvWQ1HofSd3yF1omZI2gjQ2x2x2hir
	 49SySrMIFrNFyMNBoFXGibOh3DdmpKuDPA0t6x8AzTFIu2tKBh+M9gsfmYIKeJ0h9kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CI5E+EBv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A479606A32D
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 23:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CI5E+EBv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6681F00919;
	Tue,  3 Nov 2026 23:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793746833;
	bh=CeDjFYJ7/qwDQz23QRooYEcqmXtSXuujByMCp6KjiUY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CI5E+EBvJdEe7X1FBRYGpq9/jJnbczPGLLBBQiXJD1oJGiJ4Mz34kBvSgbI7B3Yf4
	 oqEoMbKVhVeCGPZljZdyL5fzK4kQr5ui8DFF7cb9ODU0Mui1WrSdCDt0L/OhxdWugN
	 MiJJ0GNCQAjKkVCsniwYy8mamf7b3p+h8VGYtEk/itAF+bWmx7aq1ImSUJmaOlRCsA
	 P3CUhCE9vlx734iIDAmnb7QI/wQ8sc8StkrmTPOVZIhLARFrLVHP5c+iKqm+ALCmLl
	 z2FrXqvlzljbJtW5HK8NmmBS+1eyM33CbslQEMf61jze5JL22lyivHiHPMvOaKUxDj
	 2i9anPcqyfmTw==
Message-ID: <sashiko-outbox-196168@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 4/6] IB/isert: drop the promotion reference when a
 connection errors out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103223802.1697607-5-yhlee@isslab.korea.ac.kr>
References: <20261103223802.1697607-1-yhlee@isslab.korea.ac.kr>
 <20261103223802.1697607-5-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 23:00:32 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103223802.1697=
607-1-yhlee@isslab.korea.ac.kr?part=3D4

