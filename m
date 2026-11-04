Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793766156;
	b=2eFlKJ4FBSUskTpI46Hb1AJgORgFLbhHqLIyl6Po92koDSeoeJhQiSsZDRnqElMZbw91
	 6pGX5KFVeloQBOIEmPdf17/T5IQTK/nHrsx3t+VI37IxHaPKrgseP8LZER2JokRAXjDlu
	 sdo6NaEmPybDTW6RNk5zvIDYDJ4ubSkoOr1ViacEIXvsPj6rWHI+0Ht5rwT28KCUgdjDH
	 rLotEFcU/ZtL9DylEO0EVgJM2NdH8ifuVqMpM0ggZba8lep3p3Aw5K//qmZSvNZXzndfr
	 7ICQ6exoe//QTm2AnvWS1vQBI+4xyTeGv7A1KvCOL5Wvqot9G+2rv50ht2a2/bfT8rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793766156;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=cyVdzhF0KzswxPzhtguFx4RLpxF8VG94X5kBHnS9Y4Q=;
	b=2RXhYkDwDb57v3q7WSwl3eZ9/f+KvQSvVTjkwqoedqnMZF1g4ExG5e0RZq0JzErLNBHn
	 IXWqp/dIV71MLwv1aGuR4ZROB/afIg/f7c7f0v5ikngS21WbjzueNR6XxUW6XsTyc10bZ
	 JLKjvTk8h/Y1rn46rV6w0Dl+0n1pGY/IzNIsVbJBUgUm3HbqASGFJnEMnSXg4XRiSam8R
	 2yP+RuCyYUjrdfg729zqRd57V2SfaqN1y2i4JZajU7VHi9cpgpfNpCHmDtS+fVyfd7n6Q
	 q2O3vZeY1Xp1ZQX+AL9bq7shK4UTWnu8q8h15iagzNxqt0Lec2w67iEPNAbjM5NerEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QhLdSiWR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E06606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 04:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QhLdSiWR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CD41F000C1;
	Wed,  4 Nov 2026 04:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793766155;
	bh=cyVdzhF0KzswxPzhtguFx4RLpxF8VG94X5kBHnS9Y4Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QhLdSiWRYM/6881fXtTd1BcNE33o6Dc8yREGvaM972/sKOQr9KFEkzBFbTcKUgi0+
	 945nOLgsHJxFr3XBf9voUb2aq5XBGTTGeuZn3gQlzue8YC17uqXCylZXY5/eiE9Fn5
	 wXX0hPpdxdDJuQOmU3YLYdbnPY5PNmkTtlcuQJbAMVr2MkSQbLP/otuFysR2ipWMIw
	 +hfdiaX0di8rlEC5RjkQV0Q8wPjUSzBr+xigibLyvM+fe7pJVC2bYD2iuFeUIXxeXt
	 4Bm7LtNKbWkvnZ+S5t/S5kL7aE7Om8yrb64HZx+Py+RDnAtulCIg+ujTsB788/GyFv
	 SP1pMB8CKySMw==
Message-ID: <sashiko-outbox-196651@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 2/6] IB/isert: drain the QP without holding
 isert_conn->mutex
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104040318.1844865-3-yhlee@isslab.korea.ac.kr>
References: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
 <20261104040318.1844865-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 04:22:34 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> isert_disconnected_handler() drains the QP with isert_conn->mutex held.
> The drain waits for the flush completions of the send and receive queues,
> and those are reaped by ib_cq_poll_work() on ib-comp-wq, where
> isert_login_recv_done() takes isert_conn->mutex before it looks at the
> connection state.  If a login receive completes while the handler holds
> the mutex, the completion handler blocks on the mutex and the drain blocks
> on the completion that handler would have reaped.
>=20
> Return from isert_conn_terminate() whether this caller moved the
> connection to ISER_CONN_TERMINATING, and drain after dropping
> isert_conn->mutex.  Only the owner of isert_conn->node drains, so two
> callers cannot drain the same QP; the send and receive queues reserve room
> for one drain each, and a second concurrent drain hits the WARN_ONCE in
> __ib_drain_sq() and returns without draining.
>=20
> [ ... ]
>    </TASK>
>=20
> Fixes: 6d1fba0c2cc7 ("iser-target: Rework connection termination")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104040318.1844=
865-1-yhlee@isslab.korea.ac.kr?part=3D2

