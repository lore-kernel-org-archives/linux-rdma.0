Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712102;
	b=iGZmoCrlOVLjyum3SOG5QkAHj7opqKxAbFTqPHv96xTGqtnFgIw5vuhPbk/1S1MOYtVl
	 OoQvC0HzeA54OuLD5MAzyk3lmf1sNI6wjWqja4rrze/52e6i2QYGNrwGf7xRjP+Ow+W8A
	 ythdKBTluz0/vZ8nU/6a9GAfdgk4V6pgZsvbuI/9hdTk9VwBSChhSBtx2yl4ORhyoWX22
	 5z8RwesAdytF/YvBbwDzqHAT4kxNewM/HfMv++AylE3lNFSpE1lrYwkEwYUQqnUQBBs9A
	 1VfceS8UxEm4NPudoUx33+oIa72EOL4p3gjVfCdc3/teQ9fEPGVE0SfMJX/Av5BTzuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712102;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=FyaWd4lHsGkMrnZWgLUU8r+UM7sMIgI1ab4YRtFV7zk=;
	b=LGWRteo4lIxlE0q/Zx+Mg9rPJG8mZN++CakN2Rlk9FLv6Bxbv0gIyLSa6YqzUL5ChIwe
	 WOSf5RF4R196BR160oVuhnO6hco+A5zaP5yPfE/DFwzhTyS2PTsG/ho3JtTxxmLknNGUc
	 LyoPdmAGcd7xPiLyQ7x5MFAR0Z9Pcr4z6KczjTp28BJWXCK1jCmgcAilwoJpHhg2dFbzI
	 EWJmza6rP/lGZ4Kg5SIMilGe2fjpPoXpv6YAp+Bwut+iFIe54Ewt6hm2XpocGxOUX0mdq
	 hA9B+rHl+LYSmgVXptBVM0eydLhk4eQRqFcexrU2orH8RMlnYWr4tSWbv088RFgb/GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="X/I7yClg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D797F606A326
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X/I7yClg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B8E1F00A02;
	Tue,  3 Nov 2026 13:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712101;
	bh=FyaWd4lHsGkMrnZWgLUU8r+UM7sMIgI1ab4YRtFV7zk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X/I7yClgGeF1WE1X3Z4wLoNXSBrIvvZzHGVxE6NbZXxdmXEDNxtGRFqPk60C0V5cM
	 OAzch4FkcTHYlCKADqO4uzXZfmK7b6VygxpjuI2II1qm3xujTdWLp76Z9TvIvU1dQ4
	 WtZFtBXxhC1SlC1M0DrBF4I10LkRxjw+6FvyHx+KkuNyQmXo/X8kyenu9eym5S41Pz
	 9N/wJl7lVnoBc1SZAIYkIJvs13143matoJwCaB55HimDg80fQKT6fxuHmAR7v/uNvm
	 UF/pMPg7nofa8SFlOEesq9+49cpbY2w1kmMrH7mBO6doyfyJfIoQGZbfxArIJK6qbN
	 tbDfIcwwICvVQ==
Message-ID: <sashiko-outbox-195327@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/5] IB/isert: drain the QP without holding
 isert_conn->mutex
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103125955.1530355-3-yhlee@isslab.korea.ac.kr>
References: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
 <20261103125955.1530355-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:21:40 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103125955.1530=
355-1-yhlee@isslab.korea.ac.kr?part=3D2

