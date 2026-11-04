Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793756061;
	b=4OcJ5ZOKr7sw5Oxs93ByzzuTXfOxkEMSYBD0VykaR/sEbIFur6EsTtCudFEHdLImcG8T
	 Q8OKQFZA0+V48JMR++paWFVicAs+6+8Gun5c0/c64ZtcHxDuyL11uE/RU6s06yAzGU2Du
	 C3rZszQuBXOgm+ChRUd+WyRFT7E1NXYybvrVvZ3SGY+0nRr8Y01uw3FGWXFT1fV0/xgU2
	 Qc10C+AvoNSFyFGNqAXwNwI45t0wuxT5TQICU/y5otJ/VBXKqztXMvOSkb9Zw+xfso98G
	 DBpNpZoIVhVyoXMpJL5TJXeIdYDQFCUCGGxfva9365uLTIktQnuczmRS+jrTlGRqdgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793756061;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=GpQVfUGZYRSyvDHWHj17myfJ5RqaK1HkE6ZBqaIqZjY=;
	b=opr77qG1bKQDHrk7ZEqontXyBh3x6B+CvAkga2y/YJIw6tHQkUptQcjtsSicWx75h9N4
	 aS+js8v16QsiY/2sxHo41rzV86m+5E/soe4ktTBcHdqZzkczBE3u5QaTffHgLHHxxgD1D
	 RtKS3MZ+i8eTYRg9y3/UFUbL2VVKh1zW/5oDkj8EEPkw+/pxw7rnQc1Xl4Iv5/fL7i04y
	 OhB7NLdTYZWYNJ6mJ9pBqwbKMPZ6QHqmAeOrZCQJY65k6xYmvbKtehgr4ahp0TFBFG7eL
	 ihvTP8zxwAdvkb4kUqRq0LOH72OESjyMRi/DWHXqo55LW5avu7Zq7009AsEQCeTa9aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gs6z9S9R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84616606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 01:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gs6z9S9R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA391F000C1;
	Wed,  4 Nov 2026 01:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793756061;
	bh=GpQVfUGZYRSyvDHWHj17myfJ5RqaK1HkE6ZBqaIqZjY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gs6z9S9RlF23rL+Jbxr803N9jMknYc+IkzmQ39EDHDItC4FXBk7mTSTKKyRHk9Wit
	 KyBJkM6sCkBOxFK5+k6bs5DZY7ydyzaCe2bgDeYvNdfrU2lzd9mk9T3sjfdBeGTUfl
	 Ko1xM6mb2C/QZKfdMfn1MRnyzdxRhJVhxwKxI83jtmFFO9HzKUYZxTg6WYnrz9kkNJ
	 P12MfS6l1Pi29Ub/QuqRM3QY6Ca5CqLa8mihq6AHJXBji/Hj7phxWOp7Xp4zacNSsY
	 G/XfJLEWCJ0Dp35oa6Gr3uIp1CHoeeOZ2ISzcwpJLa8kli4FP5XLIl/bJsowcffQv7
	 pWNjFgW1E1QCg==
Message-ID: <sashiko-outbox-196361@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 4/6] IB/isert: drop the promotion reference when a
 connection errors out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104012219.1759523-5-yhlee@isslab.korea.ac.kr>
References: <20261104012219.1759523-1-yhlee@isslab.korea.ac.kr>
 <20261104012219.1759523-5-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 01:34:20 +0000
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104012219.1759=
523-1-yhlee@isslab.korea.ac.kr?part=3D4

